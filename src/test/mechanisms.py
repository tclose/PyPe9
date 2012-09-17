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
import pickle
try:
    import matplotlib.pyplot as plt
except:
    print "Could not import matplotlib, plotting functions will be disabled"
from ninemlp.utilities.nmodl import build as build_nmodl
from ninemlp import SRC_PATH
default_nmodl_path = os.path.join(SRC_PATH, 'test', 'mechs')
from test import plot_simulation, Recording

def current_clamp(old_mechs, new_mechs, celsius=30.0, cm=1.0, Ra=100, length=11.8, diam=11.8,
                            mean_input=0, stdev_input=1, start_time=3000, end_time=5000, dt=1,
         step=None, plot=True, save_plot=None, no_new_tables=False, no_old_tables=False,
         new_sim='neuron', old_sim='neuron'):
    """
    Tests the responses of two versions of the same mechanism with an arbitrary current clamp.
    
    @param old [tuple(String,String)]: A tuple containing the mechanism name (or path) and the simulator name for the old mechanism. Note that if the path to the mod file is used (full or relative) mechanisms will be loaded from the directory
    @param new [tuple(String,String)]: A tuple containing the mechanism name (or path) and the simulator name for the new mechanism
    @param mean_input [float]: Mean value of the input current (nA)
    @param stdev_input [float]: Standard deviation of the input current (nA)
    @param start_time [float]: Start time of the input (ms)
    @param end_time [float]: End time of the input and the recording (ms)
    @param dt [float]: Time steps between changes in input (ms)
    @param step [tuple]: If provided needs to be a tuple containing the step amplitude and step time
    @param plot [bool]: A flag that determines whether to plot the recordings or not    
    
    @return [tuple(list(Recording), tuple(float,float), list(String))]: A tuple containing: a list containing a Recording namedtuple for the old mechanism, the new mechanism and the difference between them, a 2-tuple with the start and end time of the experiment, and the list of plot titles
    """

    time_range = end_time - start_time
    # Calculate the number of time steps for the input vector
    num_time_steps = int(round(time_range / dt))

    # Create the input current and times vectors
    if step:
        num_down_steps = int(math.floor(step[1] / dt))
        num_up_steps = num_time_steps - num_down_steps
        input_current = np.append(np.ones(num_down_steps) * 0.0, np.ones(num_up_steps) * step[0])
    else:
        input_current = np.random.normal(mean_input, stdev_input, num_time_steps)

    times = np.arange(start_time, end_time, dt)

    # List to hold the 'Recording' tuples, which are output from the simulation.run() method
    recs = list()

    # A list to hold the titles for the graphs
    titles = list()

    exp_i = 0

    imported_simulators = []

    # Simulate the mechanism for both mechanisms
    for exp_name, mech_names, simulator_name, usetable in (('Old', old_mechs, old_sim, not no_old_tables), ('New', new_mechs, new_sim, not no_new_tables)):

        import_name = str.upper(simulator_name)

        if simulator_name not in imported_simulators:
            exec('import test.%s' % import_name)
            exec('from test.%s import simulate' % import_name)
            exec('from test.%s.cells import OneCompartmentCell as NeuronTestCell' % import_name)
            imported_simulators.append(simulator_name)

        cell = NeuronTestCell(mech_names, usetable) #@UndefinedVariable
        cell.set_membrane_capacitance(cm)
        cell.set_axial_resistance(Ra)
        cell.set_soma_morphology(length, diam)

        cell.inject_soma_current(input_current, times)

        # Run the recording and append it to the recordings list
        if simulator_name == 'neuron':
            record_v = [(cell.soma, 0.5)]
            import neuron
            neuron.h.psection(sec=cell.soma)
        elif simulator_name == 'nest':
            record_v = [cell]
        else:
            raise Exception ("Unrecognised simulator name '%s'" % simulator_name)

        recs.append(simulate(end_time, record_v=record_v, celsius=celsius)) #@UndefinedVariable
        titles.append((exp_name + " mech: " + ','.join(mech_names) + ", sim: " + simulator_name))

        if plot and not save_plot:
            # Plot the simulation
            plot_simulation(recs[exp_i], time_window=(start_time, end_time), volt_title=titles[exp_i], show=False)

        exp_i = exp_i + 1

    interp_new_volts = np.interp(np.squeeze(recs[0].times), np.squeeze(recs[1].times), np.squeeze(recs[1].voltages))

    # Calculate the difference between the two recordings, old interpolating the new recording to the times of the old.
    diff_voltages = np.squeeze(recs[0].voltages) - interp_new_volts
    diff_voltages = diff_voltages.reshape((len(diff_voltages), 1))

    # Store the difference in its own Recording tuple so it can be plotted by simulation.plot
    diff_rec = Recording(recs[0].times, diff_voltages, np.zeros((0, 0)), np.zeros((0, 0)), recs[0].volt_legend, list(), list())

    # Append the difference recording to the other recordings.
    recs.append(diff_rec)

    # Add the title for the difference image
    titles.append('Difference')

    if plot:
        # Plot the difference
        plot_simulation(diff_rec, time_window=(start_time, end_time), volt_title=titles[2],
                                                           show=not save_plot, save_plot=save_plot)

    return (recs, (start_time, end_time), titles)


def plot_recordings(file_location, save_plot):
    """
    Loads data recorded and saved to file by current_clamp or voltage_clamp and plots them
    
    @param file_location [String]: The location of the saved recording data
    
    """

    import pickle

    f = open(file_location, 'rb')

    (recs, time_window, titles) = pickle.load(f)

    for i in range(3):
        if save_plot:
            save_plot_i = save_plot + "_" + str(i)
        else:
            save_plot_i = None
        plot_simulation(recs[i], time_window=time_window, volt_title=titles[i], curr_title=titles[i], show=False, save_plot=save_plot_i)

    if not save_plot:
        plt.show()

def main():
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
    parser.add_argument('--save_recording', help='location to (optionally) save the recording')
    parser.add_argument('-p', '--plot', help='instead of simulating a recording, plot a saved recording from the given file location')
    parser.add_argument('--save_plot', type=str, default='', help='Location to save the plot (and close afterwards)')
    parser.add_argument('--step', nargs=2, type=float, help='Use a step input current rather than uniformly distributed current')
    parser.add_argument('--mean_input', type=float, default=0.01, help="Mean input value")
    parser.add_argument('--stdev_input', type=float, default=0.0025, help="Standard deviation of the input value")
    parser.add_argument('--start_time', type=float, default=3000, help='stimulation start time')
    parser.add_argument('--end_time', type=float, default=5000, help='stimulation end time')
    parser.add_argument('--dt', type=float, default=1, help='time step between input changes')
    parser.add_argument('--build', type=str, default='lazy', help='The build mode for the NMODL directories')
    parser.add_argument('--new_simulator', type=str, default='neuron', help='Sets the simulator for the new nmodl path (either ''neuron'' or ''nest'', ''default %(default)s''')
    parser.add_argument('--old_simulator', type=str, default='neuron', help='Sets the simulator for the new nmodl path (either ''neuron'' or ''nest'', ''default %(default)s''')
    parser.add_argument('--no_new_tables', action='store_true', help='Turns off tables for new mechanism')
    parser.add_argument('--no_old_tables', action='store_true', help='Turns off tables for old mechanism')
    args = parser.parse_args()
    if args.old:
        if not args.new:
            raise Exception ("If the first mechanism argument is supplied than the second must be also")
        if args.plot:
            raise Exception ("Plot option is to be used to plot stored recordings, not used in conjunction with the simulation")
        if args.step:
            input_shape = 'step'
        else:
            input_shape = 'random'
        print "Recording activity for %s injected current" % input_shape
        # Strip preceding path and '.mod' extension from mechanism names if present (to allow bash wildcard matching)
        old_mechs = []
        new_mechs = []
        all_mechs = []
        if args.old_simulator == 'neuron':
            all_mechs += args.old
            new_start_index = len(args.old)
        else:
            new_start_index = 0
        loaded_mech_dirs = []
        if args.new_simulator == 'neuron':
            all_mechs += args.new
        for i, mech_path in enumerate(all_mechs):
            mech = os.path.basename(mech_path)
            if mech.endswith('.mod'):
                mech = mech[0:-4]
            if i < new_start_index:
                old_mechs.append(mech)
            else:
                new_mechs.append(mech)
            mech_dir = os.path.dirname(mech_path)
            if mech_dir:
                mech_dir = os.path.abspath(mech_dir)
                if mech_dir not in loaded_mech_dirs:
                    build_nmodl(mech_dir, build_mode=args.build)
                    try:
                        print "Loading mechanisms from '%s'" % mech_dir
                        import neuron
                        neuron.load_mechanisms(mech_dir)
                    except:
                        raise Exception("Could not load mechanisms from provided NMODL path '%s'" % mech_dir)
                    loaded_mech_dirs.append(mech_dir)
        # Run the experiment
        (recs, (start_time, end_time), titles) = current_clamp(old_mechs,
                                                                 new_mechs,
                                                                 celsius=args.celsius,
                                                                 cm=args.cm,
                                                                 Ra=args.Ra,
                                                                 length=args.length,
                                                                 diam=args.diam,
                                                                 mean_input=args.mean_input,
                                                                 stdev_input=args.stdev_input,
                                                                 start_time=args.start_time,
                                                                 end_time=args.end_time,
                                                                 dt=args.dt,
                                                                 step=args.step,
                                                                 plot=not args.save_recording,
                                                                 save_plot=args.save_plot,
                                                                 no_new_tables=args.no_new_tables,
                                                                 no_old_tables=args.no_old_tables,
                                                                 new_sim=args.new_simulator,
                                                                 old_sim=args.old_simulator)
        # Save the location of the file 
        if args.save_recording:
            output = open(args.save_recording[0], 'wb')
            pickle.dump((recs, (start_time, end_time), titles), output)
            print "\nSaved recording to '" + args.save_recording[0] + "'"
        print "\nFinished simulation successfully!"
    elif args.new:
        raise Exception ("If the second mechanism argument is supplied than the first must be also")
    elif args.plot:
        plot_recordings(args.plot[0], args.save_plot)
    else:
        raise Exception ("At least one option needs to be passed to the test parameter see usage (--help option)")


if __name__ == "__main__":
    main()



