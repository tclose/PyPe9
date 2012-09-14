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
import neuron

def current_clamp(first, second, min_input=0, max_input=1, start_time=3000, end_time=5000, dt=1, input_shape='random', plot=True, save_plot=None):
    """
    Tests the responses of two versions of the same mechanism with an arbitrary current clamp.
    
    @param first [tuple(String,String)]: A tuple containing the mechanism name and the simulator name for the first mechanism
    @param second [tuple(String,String)]: A tuple containing the mechanism name and the simulator name for the second mechanism
    @param min_input [float]: Minimum value of the input current(ranges from 0 -> max_input) (nA)
    @param max_input [float]: Maximum value of the input current (ranges from 0 -> max_input) (nA)
    @param start_time [float]: Start time of the input (ms)
    @param end_time [float]: End time of the input and the recording (ms)
    @param dt [float]: Time steps between changes in input (ms)
    @param input_shape [String]: If 'step' uses a step input from 'min_input' to 'max_input', or if 'random' uses a input drawn from a uniform distribution between 'min_input' and 'max_input'.
    @param plot [bool]: A flag that determines whether to plot the recordings or not    
    
    @return [tuple(list(Recording), tuple(float,float), list(String))]: A tuple containing: a list containing a Recording namedtuple for the first mechanism, the second mechanism and the difference between them, a 2-tuple with the start and end time of the experiment, and the list of plot titles
    """

    # Calculate the number of time steps for the input vector
    num_time_steps = int(round((end_time - start_time) / dt))

    # Create the input current and times vectors
    if input_shape == 'step':
        input_current = np.append(np.ones((math.floor(num_time_steps / 2))) * min_input, np.ones((math.ceil(num_time_steps / 2))) * max_input)
    elif input_shape == 'random':
        input_current = np.random.uniform(min_input, max_input, num_time_steps)
    else:
        raise Exception ("Invalid input shape '" + str(input_shape) + "'")

    times = np.arange(start_time, end_time, dt)

    # List to hold the 'Recording' tuples, which are output from the simulation.run() method
    recs = list()

    # A list to hold the titles for the graphs
    titles = list()

    exp_i = 0

    imported_simulators = []

    # Simulate the mechanism for both mechanisms
    for experiment in (first, second):

        mech_name = experiment[0]
        simulator_name = experiment[1]
        import_name = str.upper(simulator_name)

        if simulator_name not in imported_simulators:
            exec('import %s' % import_name)
            exec('from %s import test' % import_name)
            exec('from %s.cells import OneCompartmentCell as NeuronTestCell' % import_name)
            imported_simulators.append(simulator_name)

        cell = NeuronTestCell(mech_name) #@UndefinedVariable

        cell.inject_soma_current(input_current, times)

        # Run the recording and append it to the recordings list
        if simulator_name == 'neuron':
            record_v = [(cell.soma, 0.5)]
        elif simulator_name == 'nest':
            record_v = [cell]
        else:
            raise Exception ("Unrecognised simulator name '%s'" % simulator_name)

        recs.append(test(end_time, record_v=record_v))
        titles.append(("Mech: " + mech_name + ", Sim: " + simulator_name))

        if plot and not save_plot:
            # Plot the simulation
            plot_simulation(recs[exp_i], time_window=(start_time, end_time), volt_title=titles[exp_i], show=False)

        exp_i = exp_i + 1

    interp_second_volts = np.interp(np.squeeze(recs[0].times), np.squeeze(recs[1].times), np.squeeze(recs[1].voltages))

    # Calculate the difference between the two recordings, first interpolating the second recording to the times of the first.
    diff_voltages = np.squeeze(recs[0].voltages) - interp_second_volts
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
    parser.add_argument('-o', '--old', nargs=2, metavar=('MECH_NAME', 'SIMULATOR'), help="first mechanism name, followed by simulator name (either 'neuron' or 'nest')")
    parser.add_argument('-n', '--new', nargs=2, metavar=('MECH_NAME', 'SIMULATOR'), help="second mechanism name, followed by simulator name (either 'neuron' or 'nest')")
    parser.add_argument('-r', '--save_recording', nargs=1, help='location to (optionally) save the recording')
    parser.add_argument('-p', '--plot', nargs=1, help='instead of simulating a recording, plot a saved recording from the given file location')
    parser.add_argument('-s', '--save_plot', nargs=1, type=str, default='', help='Location to save the plot (and close afterwards)')
    parser.add_argument('--step', action='store_true', help='use a step input current rather than uniformly distributed current')
    parser.add_argument('-m', '--min_input', type=float, default=0, help="minimum input value or pre-step value, depending on whether '--step' option is supplied")
    parser.add_argument('-x', '--max_input', type=float, default=1, help="maximum input value or post-step value, depending on whether '--step' option is supplied")
    parser.add_argument('-b', '--begin_time', type=float, default=3000, help='stimulation start time')
    parser.add_argument('-e', '--end_time', type=float, default=5000, help='stimulation end time')
    parser.add_argument('-t', '--dt', type=float, default=1, help='time step between input changes')
    parser.add_argument('-l', '--lazy', action='store_true', help='Only lazily build the files in the new path')
    parser.add_argument('--old_path', type=str, default='', help='Directories from which to load the old NMODL files from (mod files won''t be recompiled unless they are missing')
    parser.add_argument('--new_path', type=str, default=default_nmodl_path, help='Directories from which to load the old NMODL files from (mod files are always recompiled')
    args = parser.parse_args()

    if args.old_path:
        nmodl_paths = [args.old_path, args.new_path]
    else:
        nmodl_paths = [args.new_path]

    if isinstance(args.save_plot, list): # Not quite sure why but save_plot sometimes turns out to be a list
        save_plot = args.save_plot[0]
    else:
        save_plot = args.save_plot

    for nmodl_path in nmodl_paths:
        if nmodl_path == args.new_path and not args.lazy:
            build_mode = 'force'
        else:
            build_mode = 'lazy'
        build_nmodl(nmodl_path, build_mode=build_mode)
        try:
            print "Loading mechanisms from '%s'" % nmodl_path
            neuron.load_mechanisms(nmodl_path)
        except:
            raise Exception("Could not load mechanisms from provided NMODL path '%s'" % nmodl_path)

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
        # Run the experiment
        (recs, (start_time, end_time), titles) = current_clamp(args.old,
                                                                 args.new,
                                                                 min_input=args.min_input,
                                                                 max_input=args.max_input,
                                                                 start_time=args.begin_time,
                                                                 end_time=args.end_time,
                                                                 dt=args.dt,
                                                                 input_shape=input_shape,
                                                                 plot=not args.save_recording,
                                                                 save_plot=save_plot)
        # Save the location of the file 
        if args.save_recording:
            output = open(args.save_recording[0], 'wb')
            pickle.dump((recs, (start_time, end_time), titles), output)
            print "\nSaved recording to '" + args.save_recording[0] + "'"

        print "\nFinished simulation successfully!"
    elif args.new:
        raise Exception ("If the second mechanism argument is supplied than the first must be also")
    elif args.plot:
        plot_recordings(args.plot[0], save_plot)
    else:
        raise Exception ("At least one option needs to be passed to the test parameter see usage (--help option)")


if __name__ == "__main__":
    main()



