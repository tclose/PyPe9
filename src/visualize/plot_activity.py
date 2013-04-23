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

def quit_figure(event):
    """
    Creates a shortcut to close the current window with the key 'q'
    """
    if event.key == 'q':
        plt.close(event.canvas.figure)

class FigureHandler(object):
    
    def __init__(self, num_figures, combine=False):
        self.fig = plt.figure()
        # Set event handler to quickly close figures (just for my convenience)
        self.cid = self.fig.canvas.mpl_connect('key_press_event', quit_figure)
        self._combine = combine
        # Create subplots
        if self._combine:
            ax = self.fig.add_suplot(111)
            self.axes = [ax] * num_figures # Create n copies of the reference to the same axes
        else:
            #Determine the most even dimensions that can fit all the required subplots
            num_high = int(round(math.sqrt(num_figures)))
            num_wide = num_figures // num_high
            if num_figures % num_high:
                num_wide += 1
            self.axes = []
            for i in xrange(num_figures):
                self.axes.append(self.fig.add_subplot(num_high, num_wide, i))
    
    def __iter__(self):
        for ax in self.axes:
            yield ax
            
    def __getitem__(self, index):
        return self.axes[index]
            
def load_spikes(filename):
    spikes_n_ids = numpy.loadtxt(filename)
    if not spikes_n_ids.shape[0]:
        print "No spikes were generated for selected population"
        sys.exit(0)
    spikes = spikes_n_ids[:, 0]
    ids = spikes_n_ids[:, 1]
    return spikes, ids

def load_spikes_hoc(filename):
    spike_matrix = numpy.loadtxt(filename, skiprows=1)
    if len(spike_matrix.shape) == 1:
        spike_matrix = numpy.reshape(spike_matrix, (spike_matrix.shape[0], 1))
    num_spikes = [zeros[0] if len(zeros) else len(zeros)
                                            for zeros in numpy.where(spike_matrix == 0)]
    ids = []
    spikes = []
    for cell_id in xrange(spike_matrix.shape[1]):
        cell_spikes = spike_matrix[:, cell_id]
        # The matrix of spikes is padded out with zeros, so the index of first zero is 
        # found and taken to be the number of spikes for the given cell 
        empty_indices = numpy.where(cell_spikes == 0)[0]
        if len(empty_indices):
            num_spikes = empty_indices[0]
        else:
            num_spikes = len(cell_spikes)
        # Add the spikes to the overall spikes array and add the same number of cell_ids
        # to the corresponding ids vector
        spikes += list(cell_spikes[:num_spikes])
        ids += [cell_id] * num_spikes
    ids = numpy.array(ids)
    spikes = numpy.array(spikes)
    if not len(spikes):
        raise Exception("No spikes were generated for selected population")
    return spikes, ids     

def plot_spikes(ax, label, spikes, ids, time_start=None, time_stop=None):
    # Set default values for time start and stop (first and last spikes)
    if not time_start:
        time_start = spikes.min()
    if not time_stop:
        time_stop = spikes.max()
    length = time_stop - time_start
    # Plot spikes
    ax.scatter(spikes, ids)
    # Set axis labels and limits
    ax.set_xlabel("Time (ms)")
    ax.set_ylabel("Neuron #")
    plt.title(label + ' - Spike Times')
    max_id = numpy.max(ids)
    ax.set_xlim(time_start - 0.05 * length, time_stop + 0.05 * length)
    ax.set_ylim(-2, max_id + 2)

def load_trace_hoc(filename, rescale_traces=False):
    t_data = numpy.loadtxt(filename)
    time = t_data[:, 0]
    values = t_data[:, 1]
    ID = os.path.splitext(os.path.basename(filename))[0].capitalize()
    return [time], [values], [ID]
    
def load_trace(filename, ext, dt, incr, rescale_traces=False):
    f = open(filename)
    # Determine the range of the trace
    if ext == 'v' and not rescale_traces:
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
                    raise Exception("Incorrectly formatted line '{}', should be " \
                                    "'value ID'.".format(line))
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
    # Load values selectively, if the difference between previous variable point 
    # exceeds the provided increment            
    if not rescale_traces:
        incr = var_range * incr
    time_i = 0
    # Make sure the the prev_var variable starts from a value that will always be at
    #  least 'incr' away from the first variable read
    prev_ID = None
    values = []
    times = []
    IDs = []
    for line in f:
        if line[0] != '#': # Check to see if the line is a comment
            try:
                var, ID = line.split()
            except ValueError:
                raise Exception("Incorrectly formatted line '{}', should be " \
                                "'value' 'ID'.".format(line))
            var = float(var) / order_of_mag if rescale_traces else float(var)
            # If the ID signifies the start of a new cell reset the time index
            if ID != prev_ID:
                # If not in the initial loop, append last value/time pair to fill out 
                # the plot of the previous ID out to the right 
                if prev_ID != None:
                    values[-1].append(var)
                    times[-1].append(time_i * dt)
                time_i = 0
                prev_var = var - 2.0 * incr
                prev_ID = ID
                values.append([])
                times.append([])
                IDs.append(int(float(ID)))
            # If the variable change is greater than the specified incr add it to the 
            # vector
            if abs(var - prev_var) >= incr:
                values[-1].append(var)
                times[-1].append(time_i * dt)
                prev_var = var
            time_i += 1
    # Append last value/time pair to fill out plot of the final ID to the right
    values[-1].append(var)
    times[-1].append(time_i * dt)
    if not len(values):
        raise Exception("No trace was loaded from file '{}'".format(filename))
    # Sort the times and values by IDs
    times, values, IDs = zip(sort(zip(times, values, IDs), key=lambda tup: int(float(tup[2]))))
    return times, values, IDs

def plot_trace(ax, label, time, trace, rescale=False):
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
    plt.title(args.extra_label)

def read_header(filename):
    filename_base, filename_ext = os.path.splitext(filename)
    if filename_ext[-3:] == 'dat':
        label = filename_base
        header = None
        variable = filename_base
    else:
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
            raise Exception("Did not load a header from the passed file '{}', is it a pyNN " \
                            "output file?".format(filename))
        label = header.get('label', '')
        try:
            variable = header['variable'].capitalize()
        except KeyError:
            raise Exception("'variable' key was not found in header")
    return label, header, variable

def main(arguments):
    """
    Runs the visualization script
    
    @param arguments [list(str)]: The arguments to be parsed using argparser
    """
    parser = argparse.ArgumentParser(description='A script to plot activity recorded from NINEML+')
    parser.add_argument('filenames', nargs='+', help='The files to plot the activity from')
    parser.add_argument('--time_start', type=float, default=None, help='The start of the plot')
    parser.add_argument('--time_stop', type=float, default=None, help='The stop of the plot')
    parser.add_argument('--incr', type=float, default=0.0,
                        help="The minimum increment required " \
                             "before the next step in the variable trace is plotted")
    parser.add_argument('--extra_label', type=str, default='', help='Additional label information')
    parser.add_argument('--combine', action='store_true',
                        help='Plot the variable figures on a single combined axis')
    parser.add_argument('--no_show', action='store_true',
                        help="Don't show the plots initially (waiting for other plots to be " \
                             "plotted")
    parser.add_argument('--title_prefix', action='store_true',
                        help="Include the filenames of the files in the subplot titles")
    args = parser.parse_args(arguments)
    # Set up the figure axes to plot the results ---------------------------------------------------
    # Get the different types of data
    spike_filenames = [f for f in args.filenames if os.path.splitext(f)[:6] == 'spikes']
    spike_axes = FigureHandler(len(spike_filenames), args.combine)
    # Loop through each of the spike filenames and plot the spikes
    spike_legend = []
    for filename, ax in zip(spike_filenames, spike_axes):
        header, label, variable, prefix = read_header(filename)
        if os.path.splitext(filename) == 'spikes':
            spikes, ids = load_spikes(filename)
        else:
            spikes, ids = load_spikes_hoc(filename)
        plot_spikes(ax, label, spikes, ids, args.time_start, args.time_stop)
        if not args.combine:
            title = ('{prefix} {label}{extra_label} - Spike Times'.format(label=label, 
                                                                          extra_label=args.extra_label,
                                                                          variable_name=variable,
                                                                          prefix=prefix))
            ax.set_title(title)
            ax.set_xlabel('Time (ms)')
            ax.set_ylabel('Cell Index')
        else:
            spike_legend.append(variable)
            
    if args.combine:
        spike_axes[0].legend(spike_legend)
        spike_axes[0].get_axes().set_title('{} - Spike Times'.format(args.extra_label))
        spike_axes[0].set_xlabel('Time (ms)')
        spike_axes[0].set_ylabel('Cell index')
    # Load and plot the traces
    trace_filenames = [f for f in args.filenames if f.split('.')[-1][1:6] != 'spikes']
    trace_exts = [f.split('.')[-1][1:] for f in trace_filenames]
    trace_axes = FigureHandler(len(trace_filenames), args.combine)
    # Whether to rescale traces to common 0-1 
    rescale_traces = (args.combine and 
                      len(set(t[:-4] if t.endswith('_dat') else t for t in trace_exts)) > 1)
    trace_legend = [] 
    for filename, ext, ax in zip(trace_filenames, trace_exts, trace_axes):
        header, label, variable, prefix = read_header(filename)
        if ext.endswith('_dat'):
            times, values, IDs = load_trace_hoc(filename)
        else:
            try:
                dt = header['dt']
            except KeyError:
                raise Exception("Required header field 'dt' was not found in file header.")
            times, values, IDs, mag_order = load_trace(filename, ext,  dt, incr=args.incr,
                                                       rescale_traces=rescale_traces)
        plot_trace(ax, label, times, values, IDs)
        if not args.combine:
            ax.legend(IDs)
            title = '{prefix} {label}{extra_label} - {variable_name} vs Time'.\
                                          format(label=label,
                                          extra_label=args.extra_label,
                                          variable_name=variable,
                                          prefix=prefix)
            ax.set_title(title)
            ax.set_xlabel('Time (ms)')
            ax.set_ylabel('Voltage (mV)' if (ext == 'v' or ext == 'v_dat') else variable)
        else:
            for ID in IDs:
                leg = '{prefix} - {variable_name} - ID{ID}'.format(prefix=prefix, 
                                                                   variable_name=variable, ID=ID)
                if rescale_traces:
                    leg += ' (x10^{})'.format(mag_order)
                trace_legend.append(leg)
    if args.combine:
        trace_axes[0].legend(trace_legend)
        trace_axes[0].get_axes().set_title('{} - Various Values vs Time'.format(args.extra_label))
        trace_axes[0].set_xlabel('Time (ms)')
        trace_axes[0].set_ylabel('Sci. notation (see legend for magnitude)')
    # Show the plot
    if not args.no_show:
        plt.show()


def plot_activity(arguments):
    "Convenience function used in iPython notebooks"
    import shlex
    main(shlex.split(arguments))

if __name__ == '__main__':
    main(sys.argv[1:])
