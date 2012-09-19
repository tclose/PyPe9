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


import os.path
import argparse
import math
import test.mechs #@UnusedImport
import numpy as np
import sys
from visualize.activity_plot import activity_plot
try:
    import matplotlib.pyplot as plt
except:
    print "Could not import matplotlib, plotting functions will be disabled"
from ninemlp.utilities.nmodl import build as build_nmodl
from ninemlp import SRC_PATH
default_nmodl_path = os.path.join(SRC_PATH, 'test', 'mechs')

def build_mechs(mech_dir, simulator, build_mode, silent_build):
    if simulator == 'neuron':
        build_nmodl(mech_dir, build_mode=build_mode, silent=silent_build)
        try:
            print "Loading mechanisms from '%s'" % mech_dir
            import neuron
            neuron.load_mechanisms(mech_dir)
        except:
            raise Exception("Could not load mechanisms from provided NMODL path '%s'" % mech_dir)
    else:
        raise Exception('Nest build not implemented yet')

def main(arguments):
    """
    Runs the current clamp test on the given mechanisms
    
    @param args [String]: Command line arguments
    
        If one argument is supplied, it is interpreted as filename of previously saved recording.
        If more than one argument is supplied the first two are interpreted as the are the mechanism names, the optional third argument
        is the location to save the data (supresses plotting of recording, use 'none' to skip), and the optional fourth
        argument is the input shape, which can be changed to a step input by supplying 'step'.
    """
    parser = argparse.ArgumentParser(description='Compare two mechanisms by plotting the different response to an \
                                                    arbitrary current injection. NB: The simulated activity from the \
                                                    second mechanism will be interpolated to the time-scale of the first.')
    parser.add_argument('-o', '--old', nargs='+', metavar='MECH_NAMES', help="first mechanism name, followed by simulator name (either 'neuron' or 'nest')")
    parser.add_argument('-n', '--new', nargs='+', metavar='MECH_NAMES', help="second mechanism name, followed by simulator name (either 'neuron' or 'nest')")
    parser.add_argument('--celsius', type=float, default=30.0, help='The temperature at which to run the simulations')    
    parser.add_argument('--cm', type=float, default=1.0, help='Membrane capacitance (default: %(default)s)')
    parser.add_argument('--Ra', type=float, default=100, help='Axial resistance (default: %(default)s)')
    parser.add_argument('--length', type=float, default=11.8, help='Length of the compartment (default: %(default)s)')
    parser.add_argument('--diam', type=float, default=11.8, help='Diameter of the compartment (default: %(default)s)')
    parser.add_argument('--save_prefix', type=str, default='/tmp/mechanisms', help='location to (optionally) save the recording')
    parser.add_argument('--no_plot', action='store_true', help='Don''t plot the simulations')
    parser.add_argument('--step', nargs=2, type=float, help='Use a step input current rather than uniformly distributed current')
    parser.add_argument('--mean_input', type=float, default=0.01, help="Mean input value")
    parser.add_argument('--stdev_input', type=float, default=0.0025, help="Standard deviation of the input value")
    parser.add_argument('--start_time', type=float, default=3000, help='stimulation start time')
    parser.add_argument('--end_time', type=float, default=5000, help='stimulation end time')
    parser.add_argument('--dt', type=float, default=1, help='time step between input changes')
    parser.add_argument('--build', type=str, default='lazy', help='The build mode for the NMODL directories')
    parser.add_argument('--simulator', type=str, nargs=2, metavar=('OLD','NEW'), default=('neuron', 'neuron'), help='Sets the simulator for the new nmodl path (either ''neuron'' or ''nest'', ''default %(default)s''')
    parser.add_argument('--silent_build', action='store_true', help='Suppresses all build output')
    parser.add_argument('--init_var', nargs=2, metavar=('VAR_NAME','INITIAL_VALUE'), action='append', help='Used to initialise reversal potentials and the like')
    args = parser.parse_args(arguments)
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
        input_current = np.append(np.ones(num_down_steps) * 0.0, np.ones(num_up_steps) * args.step[0])
    else:
        input_current = np.random.normal(args.mean_input, args.stdev_input, num_time_steps)
    times = np.arange(args.start_time, args.end_time, args.dt)        
    print "Recording activity for %s injected current" % input_shape
    plot_titles = []
    # Strip preceding path and '.mod' extension from mechanism names if present (to allow bash wildcard matching)
    for name, mech_paths, simulator in zip(('old', 'new'), (args.old, args.new), 
                                                                    args.simulator):
        # Parse mechanism names and build and load mechanisms
        mech_names = []
        loaded_mech_dirs = [] 
        for mech_path in mech_paths:
            mech_names.append(os.path.splitext(os.path.basename(mech_path))[0])
            mech_dir = os.path.dirname(mech_path)
            if mech_dir not in loaded_mech_dirs:
                build_mechs(mech_dir, simulator, args.build_mode, args.silent_build)
                loaded_mech_dirs.append(mech_dir)
        plot_titles.append((name + " mech: " + ','.join(mech_names) + ", sim: " + simulator))                
        # Import appropriate modules for selected simulator        
        # Encapsulate the simulator code within a forked process so that mechanisms can be loaded with 
        # the same name can be loaded into the environment without conflicts
        pid = os.fork()
        if pid: # Parent process
            os.wait() # Parent process just waits for child process to finish before continuing
        else: # Child process
            sim_import_name = str.upper(simulator)
            exec('import test.%s' % sim_import_name)
            exec('from test.%s import simulate' % sim_import_name)
            exec('from test.%s.cells import OneCompartmentCell as TestCell' % sim_import_name)
            # Create test cell and set properties
            cell = TestCell(mech_names, usetable, init_vars=init_vars) #@UndefinedVariable
            cell.set_membrane_capacitance(args.cm)
            cell.set_axial_resistance(args.Ra)
            cell.set_soma_morphology(args.length, args.diam)
            cell.inject_soma_current(input_current, times)
            # Run the recording and append it to the recordings list
            if simulator == 'neuron':
                record_v = [(cell.soma, 0.5)]
                # Print generated test cell with loaded mechanisms
                test.NEURON.h.psection(sec=cell.soma) #@UndefinedVariable
            elif simulator == 'nest':
                record_v = [cell]
            else:
                raise Exception ("Unrecognised simulator name '%s'" % simulator)
            rec = simulate(end_time, record_v=record_v, celsius=celsius) #@UndefinedVariable
            t_v = np.concatenate((np.reshape(rec.times, rec.times.shape +(1,)),
                                                                      rec.voltages), axis=1)
            save_path = args.save_prefix + '.' + name + '.dat' 
            np.savetxt(save_path, t_v)
            print "\nSaved recording to '" + save_path + "'"
            sys.exit(0)
    old_t_v = np.loadtxt(args.save_prefix + '.old.dat')   
    new_t_v = np.loadtxt(args.save_prefix + '.new.dat')
    old_t = old_t_v[:,0]
    new_t = new_t_v[:,0]
    old_v = old_t_v[:,1]
    new_v = new_t_v[:,1]
    # Calculate the difference between the two recordings, old interpolating the new recording to the times of the old.
    interp_new_volts = np.interp(np.squeeze(old_t), np.squeeze(new_t), np.squeeze(new_v))
    diff_v = old_v - interp_new_volts
    np.savetxt(args.save_prefix + '.diff.dat', np.concatenate(old_t, diff_v))
    # Add the title for the difference image
    plot_titles.append('Difference')
    if not args.no_plot:
        for i, name in enumerate(('old', 'new', 'diff')):
            activity_plot('{prefix}{name}.dat --extra_label {label} --no_show'.format(prefix=args.save_prefix,
                                                                            name=plot_titles[i]))
        plt.show()

def mechanisms(arguments):
    import shlex
    main(shlex.split(arguments))

if __name__ == "__main__":
    main(sys.argv[1:])



