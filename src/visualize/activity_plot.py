#!/usr/bin/env python
"""
Contains a method for plotting cell positions loaded from BRep export files

@author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

import sys
import numpy
import matplotlib.pyplot as plt
import argparse
import math
import os.path

def generate_subplots(num_subplots):
    fig = plt.figure()
    #Determine the most even dimensions that can fit all the required subplots
    num_high = int(round(math.sqrt(num_subplots)))
    num_wide = num_subplots // num_high
    if num_subplots % num_high:
        num_wide += 1
    axes = []
    for i in xrange(num_subplots):
        axes.append(fig.add_subplot(num_high, num_wide, i))
    return fig, axes

def quit_figure(event):
    """
    Creates a shortcut to close the current window with the key 'q'
    """
    if event.key == 'q':
        plt.close(event.canvas.figure)


def main(arguments):
    parser = argparse.ArgumentParser(description='A script to plot activity recorded from NINEML+')
    parser.add_argument('filenames', nargs='+', help='The files to plot the activity from')
    parser.add_argument('--time_start', type=float, default=None, help='The start of the plot')
    parser.add_argument('--time_stop', type=float, default=None, help='The stop of the plot')
    parser.add_argument('--incr', type=float, default=0.0, help='The minimum increment required \
before the next step in the variable trace is plotted')
    parser.add_argument('--extra_label', type=str, default='', help='Additional label information')
    parser.add_argument('--combine', action='store_true', help='Plot the variable figures on a \
single combined axis')
    parser.add_argument('--no_show', action='store_true', help='Don''t show the plots initially \
(waiting for other plots to be plotted')
    args = parser.parse_args(arguments)

    # Set up the common axis to plot the results on
    num_spike_trains = 0
    num_v = 0
    num_currents = 0
    unique_currents = set()
    for filename in args.filenames:
        ext = filename.split('.')[-1]
        if ext == 'spikes':
            num_spike_trains += 1
        elif ext == 'v' or ext == 'dat':
            num_v += 1
        else:
            num_currents += 1
            unique_currents.add(ext)
    num_unique_currents = len(unique_currents)
    if num_spike_trains:
        spike_fig, spike_axes = generate_subplots(num_spike_trains)
        #Assign quit shortcut to figure
        # Register the 'q' -> close shortcut key with the current figure    
        spike_cid = spike_fig.canvas.mpl_connect('key_press_event', quit_figure)
        spike_legend = []
    if num_v + num_currents:
        if args.combine:
            combine_fig = plt.figure()
            # Register the 'q' -> close shortcut key with the current figure
            combine_cid = combine_fig.canvas.mpl_connect('key_press_event', quit_figure)
            combine_axis = combine_fig.add_subplot(111)
            combine_legend = []
            # Test to see if there are two type of variables that are to be combined.
            if num_unique_currents + num_v > 1:
                rescale = True
            else:
                rescale = False
        else:
            var_fig, var_axes = generate_subplots(num_v + num_currents)
            # Register the 'q' -> close shortcut key with the current figure
            var_cid = var_fig.canvas.mpl_connect('key_press_event', quit_figure)
            rescale = False
    spike_train_count = 0
    var_count = 0
    dat_count = 0 # Counts the number of 'dat' files that are plotted to give them an index
    for filename in args.filenames:
        variable_name = filename.split('.')[-1]
        if variable_name != 'dat':
            #Read Header
            header = {}
            f = open(filename)
            for line in f:
                if line[0] != '#': # Check to see if the line is a comment
                    break
                split_line = line.split()
                key = split_line[1]
                value = split_line[3]
                # Try to convert to numeric value
                try:
                    value = float(value)
                except ValueError:
                    try:
                        value = int(value)
                    except ValueError:
                        pass
                header[key] = value
            f.close()
            # Check loaded header
            if not header:
                raise Exception("Did not load a header from the passed file '%s', is it a pyNN \
output file?" % filename)
            label = header.get('label', '')
        # Get the type of variable recorded via the file's extension
        if variable_name == 'spikes':
            # Load spikes
            spikes_n_ids = numpy.loadtxt(filename)
            if not spikes_n_ids.shape[0]:
                print "No spikes were generated for selected population"
                sys.exit(0)
            spikes = spikes_n_ids[:, 0]
            ids = spikes_n_ids[:, 1]
            if args.time_start:
                time_start = args.time_start
            else:
                time_start = spikes.min()
            if args.time_stop:
                time_stop = args.time_stop
            else:
                time_stop = spikes.max()
            length = time_stop - time_start
            # Plot spikes
            ax = spike_axes[spike_train_count]
            ax.scatter(spikes, ids)
            # Set axis labels and limits
            ax.set_xlabel("Time (ms)")
            ax.set_ylabel("Neuron #")
            plt.title(label + ' ' + args.extra_label + ' - Spike Times')
            max_id = numpy.max(ids)
            ax.set_xlim(time_start - 0.05 * length, time_stop + 0.05 * length)
            ax.set_ylim(-2, max_id + 2)
            spike_train_count += 1
        else:
            if variable_name == 'dat':
                t_data = numpy.loadtxt(filename)
                t = t_data[:, 0]
                data = t_data[:, 1]
                leg = '{variable_name} - ID{ID}'.format(
                        variable_name=os.path.splitext(os.path.basename(filename))[0].capitalize(),
                        ID=dat_count)
                if rescale:
                    abs_max = max(abs(numpy.min(data)), abs(numpy.max(data)))
                    order_of_mag = 10.0 ** math.floor(math.log(abs_max, 10.0))
                    leg += ' (x10^{order_of_mag})'.format(order_of_mag=order_of_mag)
                    data /= order_of_mag
                if args.combine:
                    combine_axis.plot(t, data)
                    combine_legend.append(leg)
                else:
                    var_axes[var_count].plot(t, data)
                dat_count += 1
            else:
                try:
                    dt = header['dt']
                except KeyError:
                    raise Exception("Required header field 'dt' was not found in file header.")
                f = open(filename)
                if variable_name == 'v' and not rescale:
                    # 100 is a rough estimate of the range of the voltage variable to save having to 
                    # determine it from the max and minimum values
                    var_range = 100
                else:
                    max_var = float('-inf')
                    min_var = float('inf')
                    for line in f:
                        if line[0] != '#':
                            try:
                                var, ID = line.split()
                            except ValueError:
                                raise Exception("Incorrectly formatted line '%s', should be \
'value ID'." % line)
                            var = float(var)
                            if var > max_var:
                                max_var = var
                            if var < min_var:
                                min_var = var
                    f.seek(0)
                    if max_var == 0 and min_var == 0:
                        order_of_mag = 1.0
                        var_range = 1.0
                    else:
                        abs_max = max(abs(min_var), abs(max_var))
                        order_of_mag = 10.0 ** math.floor(math.log(abs_max, 10.0))
                        var_range = max_var - min_var
                if rescale:
                    incr = args.incr
                else:
                    incr = var_range * args.incr
                time_i = 0
                # Make sure the the prev_var variable starts from a value that will always be at
                #  least 'incr' away from the first variable read
                prev_ID = None
                variables = []
                times = []
                IDs = []
                # Load variables selectively, if the difference between previous variable point 
                # exceeds args.incr
                for line in f:
                    if line[0] != '#': # Check to see if the line is a comment
                        try:
                            var, ID = line.split()
                        except ValueError:
                            raise Exception("Incorrectly formatted line '%s', should be 'value ID'."
                                                                                             % line)
                        if rescale:
                            var = float(var) / order_of_mag
                        else:
                            var = float(var)
                        # If the ID signifies the start of a new cell reset the time index
                        if ID != prev_ID:
                            # If not in the initial loop, append last value/time pair to fill out 
                            # the plot of the previous ID out to the right 
                            if prev_ID != None:
                                variables[-1].append(var)
                                times[-1].append(time_i * dt)
                            time_i = 0
                            prev_var = var - 2.0 * args.incr
                            prev_ID = ID
                            variables.append([])
                            times.append([])
                            IDs.append(int(float(ID)))
                        # If the variable change is greater than the specified incr add it to the 
                        # vector
                        if abs(var - prev_var) >= args.incr:
                            variables[-1].append(var)
                            times[-1].append(time_i * dt)
                            prev_var = var
                        time_i += 1
                # Append last value/time pair to fill out plot of the final ID to the right
                variables[-1].append(var)
                times[-1].append(time_i * dt)
                if not variables:
                    print "No trace was loaded from file"
                    sys.exit(0)
                # Plot variables sorted in order of their IDs
                sorted_IDs = []
                for t, var, ID in sorted(zip(times, variables, IDs), key=lambda tup:
                                                                                int(float(tup[2]))):
                    if args.combine:
                        combine_axis.plot(t, var)
                    else:
                        var_axes[var_count].plot(t, var)
                    sorted_IDs.append(ID)
                if args.combine:
                    for ID in sorted_IDs:
                        leg = '{variable_name} - ID{ID}'.format(
                                                    variable_name=variable_name.capitalize(), ID=ID)
                        if rescale:
                            leg += ' (x10^{order_of_mag})'.format(order_of_mag=order_of_mag)
                        combine_legend.append(leg)
                else:
                    var_axes[var_count].legend(sorted_IDs)
                    var_axes[var_count].set_title('{label}{extra_label} - {variable_name} vs Time'.
                                                  format(label=label,
                                                  extra_label=args.extra_label,
                                                  variable_name=header['variable']))
                    var_axes[var_count].set_xlabel('Time (ms)')
                    if variable_name == 'v':
                        ylabel = 'Voltage (mV)'
                    else:
                        ylabel = variable_name.capitalize()
                    var_axes[var_count].set_ylabel(ylabel)
                    var_count += 1
    if args.combine:
        combine_axis.legend(combine_legend)
        combine_axis.get_axes().set_title('{extra_label} - Assorted variables vs Time'.format(
                                                                    extra_label=args.extra_label))
        combine_axis.set_xlabel('Time (ms)')
        combine_axis.set_ylabel('Sci. notation (see legend for magnitude)')
    # Show the plot
    if not args.no_show:
        plt.show()

def activity_plot(arguments):
    import shlex
    main(shlex.split(arguments))

if __name__ == '__main__':
    main(sys.argv[1:])
