#!/usr/bin/env python
"""

    This file defines functions to test the performance of the base NEURON and NEST classes


    @author Tom Close

"""

#######################################################################################
#
#        Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import sys
import os.path
import collections
import argparse
import math
import numpy as np
import multiprocessing as mp
try:
    import matplotlib.pyplot as plt
    loaded_matplotlib=True
except:
    loaded_matplotlib=False
    print "Could not import matplotlib, plotting functions will be disabled"

Recording = collections.namedtuple('Recording', 'times voltages')
Inject = collections.namedtuple('Inject', 'times current')

def main(arguments):
    """
    Generates test cells with specified mechanisms and optionally compares them with a reference
    
    @param args [String]: Command line arguments
    """
    parser = argparse.ArgumentParser(description='Compare two mechanisms by plotting the different response to an \
                                                    arbitrary current injection. NB: The simulated activity from the \
                                                    second mechanism will be interpolated to the time-scale of the first.')
    parser.add_argument('mech_paths', nargs='+', metavar='MECH_NAMES', help="Mechanisms names to include in the test cell")    
    parser.add_argument('-r', '--reference', nargs='+', default=[], metavar='REF_MECH_NAMES', help="Mechanisms names to include in the reference test cell")
    parser.add_argument('--celsius', type=float, default=30.0, help='The temperature at which to run the simulations')    
    parser.add_argument('--cm', type=float, default=1.0, help='Membrane capacitance (default: %(default)s)')
    parser.add_argument('--Ra', type=float, default=100, help='Axial resistance (default: %(default)s)')
    parser.add_argument('--length', type=float, default=11.8, help='Length of the compartment (default: %(default)s)')
    parser.add_argument('--diam', type=float, default=11.8, help='Diameter of the compartment (default: %(default)s)')
    parser.add_argument('--save_prefix', type=str, help='location to (optionally) save the recording')
    parser.add_argument('--no_plot', action='store_true', help='Don''t plot the simulations')
    parser.add_argument('--step', nargs=2, type=float, help='Use a step input current rather than uniformly distributed current')
    parser.add_argument('--mean_input', type=float, default=0.01, help="Mean input value")
    parser.add_argument('--stdev_input', type=float, default=0.0025, help="Standard deviation of the input value")
    parser.add_argument('--start_time', type=float, default=3000, help='stimulation start time')
    parser.add_argument('--end_time', type=float, default=5000, help='stimulation end time')
    parser.add_argument('--dt', type=float, default=1, help='time step between input changes')
    parser.add_argument('--build', type=str, default='lazy', help='The build mode for the NMODL directories')
    parser.add_argument('--simulator', type=str, nargs='+', metavar='SIMULATOR_NAME', default=['neuron'], help='Sets the simulator for the new nmodl path (either ''neuron'' or ''nest'', ''default %(default)s''')
    parser.add_argument('--silent_build', action='store_true', help='Suppresses all build output')
    parser.add_argument('--init_var', nargs=2, metavar=('VAR_NAME','INITIAL_VALUE'), action='append', default=[], help='Used to initialise reversal potentials and the like')
    args = parser.parse_args(arguments)
    no_plot = args.no_plot or not loaded_matplotlib
    if no_plot and not args.save_prefix:
        raise Exception('If the ''--no_plot'' option is given (or matplotlib could not be loaded) \
you probably want to specify a save location (''--save_prefix'') because otherwise what is the point?')
    # Put all the simulation params in a dict for convenience
    cell_params = {'cm': args.cm, 'Ra': args.Ra, 'celsius': args.celsius, 'length': args.length, 
                                                     'diam': args.diam, 'init_vars': args.init_var}
    if args.reference:
        #Duplicate the simulator for both tests
        if len(args.simulator) == 1:
            simulators = (args.simulator[0],args.simulator[0])          
        elif len(args.simulator) == 2:
            simulators = args.simulator
        else:
            raise Exception('The number of specified simulators (%d) doesn''t match the number of tests (2)' % len(args.simulator))            
    else:
        if len(args.simulator) == 1:
            simulators = args.simulator
        else:
            raise Exception('The number of specified simulators (%d) doesn''t match the number of tests (1)' % len(args.simulator))            
    # Set up common input stimulation
    if args.step:
        input_shape = 'step'
    else:
        input_shape = 'random'
    time_range = args.end_time - args.start_time
    # Calculate the number of time steps for the input vector
    num_time_steps = int(round(time_range / args.dt))
    # Create the input current and times vectors
    if args.step:
        num_down_steps = int(math.floor(args.step[1] / args.dt))
        num_up_steps = num_time_steps - num_down_steps
        current = np.append(np.ones(num_down_steps) * 0.0, np.ones(num_up_steps) * args.step[0])
    else:
        current = np.random.normal(args.mean_input, args.stdev_input, num_time_steps)
    times = np.arange(args.start_time, args.end_time, args.dt)        
    inject = Inject(times, current)
    print "Recording activity for %s injected current" % input_shape
    mechs_list = []
    load_dirs_list = []
    build_dirs = set()
    # Strip preceding path and '.mod' extension from mechanism names if present (to allow bash wildcard matching)
    for mech_paths, simulator in zip((args.reference, args.mech_paths), simulators):
        # Parse mechanism names and build and load mechanisms
        mechs = []
        load_dirs = set()
        for mech_path in mech_paths:
            mechs.append(os.path.splitext(os.path.basename(mech_path))[0])
            mech_dir = os.path.dirname(mech_path)
            if mech_dir:
                load_dirs.add(mech_dir)
                if simulator == 'neuron':
                    build_dirs.add(mech_dir)
        mechs_list.append(mechs)
        load_dirs_list.append(list(load_dirs))        
    # Since I am already doing multiprocessing for the simulations to use a clean process each time
    # I thought it wouldn't hurt to do the NMODL building in parallel as well
    num_procs = len(build_dirs)
    build_pool = mp.Pool(processes=num_procs)
    build_pool.apply_async(build_mech_dir, zip(list(build_dirs), [args.build] * num_procs,
                                                                 [args.silent_build] * num_procs))
    del build_pool
    if args.reference:
        test_names = ('reference', 'new')    
        # Encapsulate the simulator code within a separate process so that mechanisms can be loaded with 
        # the same name can be loaded into the environment without conflicts. Since we need separate 
        # processes, we might as well do it in parallel.
        simulate_pool = mp.Pool(processes=2)
#        stdout_lock = mp.Lock()
        stdout_lock = None
        old_rec, new_rec = simulate_pool.map(run_test, zip(test_names, mechs_list, load_dirs_list, 
                                                   args.simulator,  [cell_params] * 2, [inject] * 2, 
                                                   [args.save_prefix] * 2, [stdout_lock] * 2))
        del simulate_pool
        # Calculate the difference between the two recordings, old interpolating the new recording to the times of the old.
        diff_voltages = old_rec.voltages - np.interp(old_rec.times, new_rec.times, new_rec.voltages)
        if args.save_prefix:
            save_recording(old_rec.times, diff_voltages, args.save_prefix, 'diff')
        recs = (old_rec, new_rec, Recording(old_rec.times, diff_voltages))
        test_names += ('difference',)
    else:
        test_names = ('test',)
        recs = (run_test(test_names[0], mechs_list[0], load_dirs_list[0], args.simulator[0], 
                                                            cell_params, inject, args.save_prefix),)
    # Set up plot titles
    plot_titles = []
    plot_titles.append((test_names[0] + " mech: " + ','.join(mechs_list[0]) + ", sim: " + simulators[0]))
    if args.reference:    
        plot_titles.append((test_names[1] + " mech: " + ','.join(mechs_list[1]) + ", sim: " + simulators[1]))
        plot_titles.append('Difference')
    if not no_plot:
        for rec, plot_title in enumerate(zip(recs, plot_titles)):
            plt.plot(rec.times, rec.voltages)
            plt.title(plot_title)
        plt.show()

def build_mech_dir(mech_dirs, build_mode, silent):
    from ninemlp.utilities.nmodl import build as build_nmodl
    for mech_dir in mech_dirs:
        build_nmodl(mech_dir, build_mode=build_mode, silent=silent)

def run_test(test_name, mechs, mech_dirs, simulator_name, cell_params, inject, save_prefix, stdout_lock=None):
    if simulator_name == 'neuron':
        import neuron as simulator #@UnusedImport
        for mech_dir in mech_dirs:
            try:
                simulator.load_mechanisms(mech_dir)
            except:
                raise Exception("Could not load mechanisms from provided NMODL path '%s'" % mech_dir)
        TestCell = NeuronTestCell
    elif simulator_name == 'nest':
        import nest as simulator
        TestCell = NestTestCell
    else:
        raise Exception('Unrecognised simulator ''%s''' % simulator_name)
    # Create test cell and set properties
    cell = TestCell(simulator, mechs, cm=cell_params['cm'], Ra=cell_params['Ra'], 
                                    length=cell_params['length'], diam=cell_params['diam'], 
                                    init_vars=cell_params['init_var'],verbose=True)
    cell.inject_soma_current(inject.current, inject.times)
    # Run the recording and append it to the recordings list
    rec = cell.simulate(args.end_time, celsius=args.celsius) #@UndefinedVariable
    if save_prefix:
        save_recording(rec.times, rec.voltages, save_prefix, test_name)    
    if stdout_lock:
        stdout_lock.acquire()
    print 'Description of ' + test_name + ' cell:'
    cell.describe()
    if stdout_lock:
        stdout_lock.release()
    return rec
    
def save_recording(times, voltages, save_prefix, test_name):
    assert(len(times) == len(voltages))
    t_v = np.concatenate((np.reshape(times, times.shape +(1,)),
                          np.reshape(voltages, voltages.shape +(1,))), axis=1)
    save_path = save_prefix + '.' + test_name + '.dat' 
    np.savetxt(save_path, t_v)
    print "\nSaved %s recording to '%s'" % (test_name, save_path)
        
#===================================================================================================
# Neuron Test cell class
#===================================================================================================
    
class NeuronTestCell(object):

    def __init__(self, neuron_module, mech_names, cm, Ra, length, diam, segment_length=None, 
                                                                    verbose=False, init_vars=[]):
        """
        Initialises the _BaseCell cell for use in testing general functions, should not be called by derived functions _base_init()
        should be used instead.
        @param hoc: a reference to the hoc module, to avoid it having to be imported globally and henc persisting between tests.
        """
        ## Some 'setter' functions trigger recalculation of the number of segments to ensure the validity of the numerical simulation, the _initialised flag disables them until the cell is initialised
        self._initialised = False
        self.verbose = verbose
        self.neuron_module = neuron_module
        self.h = neuron_module.h
        self.soma = self.h.Section(cell=self)
        ## Set morphology and passive properties
        self.soma.L = length
        self.soma.diam = diam
        self.soma.cm = cm
        self.soma.Ra = Ra
        #If 'None', the number of segments is determined from the d_lambda rule as describe in the NEURON book by Hines and Carnevale 2001
        self.set_segment_length(segment_length)
        #Insert mechanisms into cell
        for mech_name in mech_names:
            try:
                self.soma.insert(mech_name)
            except:
                raise Exception("Could not insert mechanisms '%s'" % mech_name)
        #Initialise vars
        for init_var in init_vars:
            setattr(self.soma, init_var[0], float(init_var[1]))
        # Set initialised to true (needs to be set to False again in derived base classes)
        self._devices = []
        self._initialised = True
        if self.verbose:
            self.h.psection(sec=self.soma)
        
    def inject_soma_current(self, amplitudes, times):
        """
        Injects an arbitrary current into the soma of the cell
        
        @param amplitudes [np.array]: The amplitudes of the current to be injected
        @param times [np.array]: The time points corresponding to the amplitudes vector
        """
        amp_v = self.h.Vector(amplitudes)
        times_v = self.h.Vector(times)
        curr_clamp = self.h.IClamp(self.soma(0.5))
        # Setting recording paradigm
        curr_clamp.delay = min(times)
        curr_clamp.dur = max(times)
        # "play" the input vector into current of the test cell
        amp_v.play(curr_clamp._ref_amp, times_v)
        self._devices.append((curr_clamp, amp_v, times_v))   
            
    def set_segment_length(self, segment_length=None, d_lambda=0.1, freq=100):
        """
        Sets the number of segments per branch either by explicit segment length 
        (if segment_length > 0) or by the  "d_lambda" method as described in 
        <a href="http://nro.sagepub.com/content/7/2/123.short">Hines and Carnevalle 2001</a>.
    
        @param segment_length [float]: The length of each section. If <= 0 the default d_lambda rule is used instead (see below)
        @param d_lambda [float]: The 'd_lambda' value (see reference)
        @param freq [float]: The frequency the length constant is calculated at for the "d_lambda" rule.
        @return [bool]: Whether the number of segments have been altered
        
        From the header of the original hoc code explaining the d_lambda rule:
            "Sets nseg in each section to an odd value so that its segments are no longer than
            d_lambda * the AC length constant at frequency freq in that section. Be sure to specify 
            your own Ra and cm 
            
            To understand why this works, and the advantages of using an odd value for nseg,
                see    Hines, M.L. and Carnevale, N.T.
                     NEURON: a tool for neuroscientists.
                     The Neuroscientist 7:123 - 135, 2001."    
    
        """
        #Loop through all sections and set the number of segments according to the desired 
        #d_lambda fraction of the length constant of the specified frequency
        if segment_length <= 0:
            #Calculate the 'd_lambda' fraction of the length constant for the supplied 
            # frequency, given the sections axial resistance and capacitance
            sec_segment_length = d_lambda * 1e5 * math.sqrt(self.soma.diam / (4 * math.pi * freq *
                                                                     self.soma.Ra * self.soma.cm))
        else:
            sec_segment_length = segment_length
        #Set the number of segments so that the lenght of each section is a fraction, 
        #'d_lambda' of the length constant. 
        self.soma.nseg = int((self.soma.L / sec_segment_length + 0.9) / 2) * 2 + 1

    def simulate(self, run_time, celsius=37, initial_v= -65):
        """
        Runs the simulation and records the specified locations, returning them in numpy arrays contained within a 
        named Tuple ('Recording') along with legends to be used for plotting. Rows of the np.arrays correspond to 
        different recording locations, and columns correspond to common time points in the simulation.
        
        @param run_time [float]: Length of the run
        @param initial_v [float]: The initial voltage for the simulation
        @param record_v [list(tuple(h.Section,float))]: List of h.Sections to record voltage from
        @param record_i [list(h.*Syn)]: List of h.*Syn to record from (should be added with 'poisson_stimulation()').
        @param record_m [list(h.IntFire*)]: List of h.IntFire* from which to record their states.
        @param record_times [list(float)]; Times to record into the recording list. If none then return all the recording.
        
        @return [Recording]: Returns the recorded voltages, currents and states in a named tuple
        """
        # Record Time from NEURON (h._ref_t)
        time = self.h.Vector()
        time.record(self.h._ref_t)
        # Record Voltage from the soma
        volt_rec = self.h.Vector()
        volt_rec.record(self.soma(0.5)._ref_v)
        # Set up recordings from the list of sections to record voltages from
        self.h.celsius = celsius
        print "Simulating at %fC" % celsius
        # Initialises the neuron environment 
        self.h.finitialize(initial_v)
        self.neuron_module.init()
        self.neuron_module.run(run_time)
        # get values for times from NEURON vectors format into numpy format
        times = np.array(time)
        # get values for voltages from NEURON vectors format into numpy format
        voltages = np.array(volt_rec)
        #Return times, voltages, currents, states, volt_legend, curr_legend, state_legend in a namedtuple
        return Recording(times, voltages)    

    def describe(self):
        self.h.psection(sec=self.soma)

#===================================================================================================
# NEST Test cell class
#===================================================================================================

class NestTestCell(object):
    def __init__(self, neuron_module, mech_names, cm, Ra, length, diam, segment_length=None, 
                                                                    verbose=False, init_vars=[]):
        raise NotImplementedError

    def simulate(self, run_time, celsius=37, initial_v= -65, record_v=list()):
        raise NotImplementedError

#===================================================================================================
# Alternative methods to call the script
#===================================================================================================

def mechanisms(arguments):
    import shlex
    main(shlex.split(arguments))

if __name__ == "__main__":
    main(sys.argv[1:])



