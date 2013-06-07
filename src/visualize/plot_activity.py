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
import numpy.random
import matplotlib.pyplot as plt
import argparse
import math
import os.path
import pickle
from itertools import izip

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
            ax = self.fig.add_subplot(111)
            self.axes = [ax] * num_figures # Create n copies of the reference to the same axes
        else:
            #Determine the most even dimensions that can fit all the required subplots
            num_high = int(round(math.sqrt(num_figures)))
            num_wide = num_figures // num_high
            if num_figures % num_high:
                num_wide += 1
            self.axes = []
            for i in xrange(num_figures):
                self.axes.append(self.fig.add_subplot(num_high, num_wide, i + 1))

    def __iter__(self):
        for ax in self.axes:
            yield ax

    def __len__(self):
        return len(self.axes)

    def get_primary(self):
        if not self._combine:
            raise Exception("There is no primary axes for this figure handler (i.e. 'combine'==False)")
        return self.axes[0]

class ColourPicker(object):

    BASE_COLOURS = ['b', 'r', 'g', 'c', 'm', 'y', 'k']

    def __init__(self, combine):
        self._colours = self.BASE_COLOURS
        self._curr_index = 0
        self._combine = combine

    def reset(self):
        self._curr_index = 0
        
    def _new_colour(self):
        c = numpy.random.rand(3)
        self._colours.append(c)
        return c

    def spike_iter(self):
        if self._combine:
            for c in self._colours:
                yield c
            while True:
                yield self._new_colour()
        else:
            yield self._colours[0]
            
    def get_trace_colours(self, num):           
        colours = self._colours[self._curr_index:(self._curr_index + num)]
        for i in xrange(len(colours), num): #@UnusedVariable i 
            colours.append(self._new_colour())
        if self._combine:
            self._curr_index += num
        return colours

def load_spikes(filename):
    with open(filename) as f:
        data = pickle.load(f)
    spike_trains = data.segments[0].spiketrains
    spikes = []
    IDs = []
    time_start = float('inf')
    time_stop = float('-inf')
    for ID, train in enumerate(spike_trains):
        spikes.extend(train)
        IDs.extend(numpy.tile([ID], len(train)))
        if train.t_start < time_start:
            time_start = train.t_start
        if train.t_stop > time_stop:
            time_stop = train.t_stop            
    return numpy.array(spikes), numpy.array(IDs), data.name + ' Spikes', time_start, time_stop

def load_txt_spikes(filename):
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

def plot_spikes(ax, label, spikes, ids, time_start=None, time_stop=None, colour='b'):
    # Set default values for time start and stop (first and last spikes)
    if not len(spikes):
        print "No spikes were loaded from given '{}' output file".format(label)
    else:
        if time_start is None:
            time_start = spikes.min()
        if time_stop is None:
            time_stop = spikes.max()
        length = time_stop - time_start
        # Plot spikes
        ax.scatter(spikes, ids, c=colour)
        # Set axis labels and limits
        max_id = numpy.max(ids)
        ax.set_xlim(time_start - 0.05 * length, time_stop + 0.05 * length)
        ax.set_ylim(-2, max_id + 2)

def load_trace(filename):
    with open(filename) as f:
        data = pickle.load(f)
    signals = data.segments[0].analogsignalarrays
    times = [numpy.arange(signals[0].t_start, signals[0].t_stop, signals[0].sampling_period)]
    times *= len(signals)
    legends = [str(i) for i in xrange(signals[0].shape[1])]
    return times, signals, legends, signals[0].description

def load_trace_hoc(filename, rescale_traces=False, time_start=None, time_stop=None):
    t_data = numpy.loadtxt(filename)
    time = t_data[:, 0]
    values = t_data[:, 1]
    if time_start is not None or time_stop is not None:
        if time_start is not None:
            indices = time >= time_start
        if time_start is not None:
            indices = time <= time_stop
        time=time[indices]
        values=values[indices]
    # Create legend values
    legend = os.path.splitext(os.path.basename(filename))[0].capitalize()
    if rescale_traces:
        abs_max = max(abs(numpy.min(values)), abs(numpy.max(values)))
        order_of_mag = 10.0 ** math.floor(math.log(abs_max, 10.0))
        legend += ' (x10^{order_of_mag})'.format(order_of_mag=order_of_mag)
        values /= order_of_mag
    return [time], [values], [legend]

def load_txt_trace(filename, ext, dt, incr, rescale_traces=False, time_start=None, time_stop=None):
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
                    var, GID = line.split()
                except ValueError:
                    raise Exception("Incorrectly formatted line '{}', should be " \
                                    "'value GID'.".format(line))
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
    # Make sure the the prev_var variable starts from a value that will always be at
    #  least 'incr' away from the first variable read
    prev_GID = None
    values = []
    times = []
    GIDs = []
    time = 0.0
    for line in f:
        if line[0] != '#': # Check to see if the line is a comment
            try:
                var, GID = line.split()
            except ValueError:
                raise Exception("Incorrectly formatted line '{}', should be " \
                                "'value' 'GID'.".format(line))
            # If the GID signifies the start of a new cell reset the time index
            if GID != prev_GID:
                # If not in the initial loop, append last value/time pair to fill out 
                # the plot of the previous GID out to the right 
                if prev_GID != None:
                    values[-1].append(var)
                    times[-1].append(time if time_stop is None else time_stop)
                time = 0.0
                prev_var = None
                prev_GID = GID
                values.append([])
                times.append([])
                GIDs.append(int(float(GID)))
            if ((time_start is None or time >= time_start) and 
                (time_stop is None or time <= time_stop)):
                var = float(var) / order_of_mag if rescale_traces else float(var)
                # If the variable change is greater than the specified incr add it to the 
                # vector
                if prev_var is None or abs(var - prev_var) >= incr:
                    values[-1].append(var)
                    times[-1].append(time)
                    prev_var = var
            time += dt
    # Append last value/time pair to fill out plot of the final GID to the right
    values[-1].append(var)
    times[-1].append(time if time_stop is None else time_stop)
    if not len(values):
        raise Exception("No trace was loaded from file '{}'".format(filename))
    # Sort the times and values by GIDs
    GIDs, times, values = zip(*sorted(zip(GIDs, times, values), key=lambda tup: int(float(tup[0]))))
    legends = ['{}'.format(GID) for GID in GIDs]
    return times, values, legends

def plot_traces(ax, times, traces, colour_picker):
    for time, trace, colour in zip(times, traces, colour_picker.get_trace_colours(len(times))):
        ax.plot(time, trace, c=colour)

def read_txt_header(filename, prefix_filename=False):
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
    if prefix_filename:
        label = '.'.join(filename.split('.')[:-1])
    return label, header, variable

def read_hoc_header(filename, prefix_filename=False):
    filename_base, filename_ext = os.path.splitext(filename)
    label = filename_base
    header = None
    variable = ""
    if prefix_filename:
        label = '.'.join(filename.split('.')[:-1])
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
    parser.add_argument('--incr', type=float, default=0.01,
                        help="The minimum increment required before the next step in the variable "
                             "trace is plotted")
    parser.add_argument('--label', type=str, default='', help='Additional label information')
    parser.add_argument('--combine', action='store_true',
                        help='Plot the variable figures on a single combined axis')
    parser.add_argument('--no_show', action='store_true',
                        help="Don't show the plots initially (waiting for other plots to be " \
                             "plotted")
    parser.add_argument('--prefix_filename', action='store_true',
                        help="Include the filenames of the files in the subplot titles")
    args = parser.parse_args(arguments)
    # Set up the figure axes to plot the results ---------------------------------------------------
    # Get the different types of data
    spike_filenames = [f for f in args.filenames if (f.split('.')[-1][:6] == 'spikes' or 
                                                     f.split('.')[-2] == 'spikes')]
    colour_picker = ColourPicker(args.combine)
    if len(spike_filenames):
        spike_axes = FigureHandler(len(spike_filenames), args.combine)
        # Loop through each of the spike filenames and plot the spikes
        spike_legend = []
        time_start = args.time_start
        time_stop = args.time_stop
        for filename, ax, colour in izip(spike_filenames, spike_axes, ['b', 'r', 'g', 'c', 'm', 'y', 'k']): #colour_picker.spike_iter()):
            if filename.split('.')[-2] == 'spikes':
                spikes, ids, label, time_start, time_stop = load_spikes(filename) 
            else:
                if filename.split('.')[-1] == 'spikes':
                    label, header, variable = read_txt_header(filename, prefix_filename=args.prefix_filename)
                    spikes, ids = load_txt_spikes(filename)
                else:
                    label, header, variable = read_hoc_header(filename, prefix_filename=args.prefix_filename)
                    spikes, ids = load_spikes_hoc(filename)
                if args.combine:
                    if args.time_start is not None: 
                        first_spike = spikes.min()
                        if first_spike < time_start:
                            time_start = first_spike
                    if args.time_stop is not None: 
                        last_spike = spikes.max()
                        if last_spike < time_stop:
                            time_start = last_spike
            plot_spikes(ax, label, spikes, ids, time_start, time_stop, colour=colour)
            if args.combine:
                spike_legend.append(label)
            else:
                title = "Spike Times"
                if label or args.label:
                    title = label + args.label + " - " + title
                ax.set_title(title)
                ax.set_xlabel('Time (ms)')
                ax.set_ylabel('Cell Index')
        if args.combine:
            ax = spike_axes.get_primary()
            ax.legend(spike_legend)
            title = "Spike Times"
            if args.label:
                title = args.label + " - " + title
            ax.get_axes().set_title(title)
            ax.set_xlabel('Time (ms)')
            ax.set_ylabel('Cell index')
    # Load and plot the traces
    trace_filenames = [f for f in args.filenames if (f.split('.')[-1][:6] != 'spikes' and
                                                     f.split('.')[-2] != 'spikes')]
    if len(trace_filenames):
        colour_picker.reset()
        trace_exts = ['.'.join(f.split('.')[-2:]) if f.endswith('pkl') else f.split('.')[-1] for f in trace_filenames]
        trace_axes = FigureHandler(len(trace_filenames), args.combine)
        # Whether to rescale traces to common 0-1 
        rescale_traces = (args.combine and
                          len(set(t[:-4] if t.endswith('_dat') else t for t in trace_exts)) > 1)
        trace_legends = []
        for filename, ext, ax in zip(trace_filenames, trace_exts, trace_axes):
            if ext.endswith('v.pkl'):
                times, values, legends, label = load_trace(filename)
            elif ext.endswith('_dat'):
                label, header, variable = read_txt_header(filename, 
                                                          prefix_filename=args.prefix_filename)
                times, values, legends = load_trace_hoc(filename, time_start=args.time_start, 
                                                        time_stop=args.time_stop)
            else:
                label, header, variable = read_hoc_header(filename, 
                                                          prefix_filename=args.prefix_filename)
                try:
                    dt = header['dt']
                except KeyError:
                    raise Exception("Required header field 'dt' was not found in file header.")
                times, values, legends = load_txt_trace(filename, ext, dt, incr=args.incr,
                                                    rescale_traces=rescale_traces,
                                                    time_start=args.time_start, 
                                                    time_stop=args.time_stop)
            plot_traces(ax, times, values, colour_picker)
            if args.combine:
                trace_legends += ['{} - {}'.format(label, l) for l in legends]
            else:
                if (ext == 'v.pkl' or ext == 'v' or ext == 'v_dat'):
                    ytitle = 'Voltage'
                    ylabel = 'Voltage (mV)'
                else:
                    ytitle = ylabel = variable
                ax.legend(legends)
                title = '{}{} - {} vs Time'.format(args.label, label, ytitle)
                ax.set_title(title)
                ax.set_xlabel('Time (ms)')
                ax.set_ylabel(ylabel)
        if args.combine:
            ax = trace_axes.get_primary()
            ax.legend(trace_legends)
            if all([e == 'v.pkl' or e == 'v' or e == 'v_dat' for e in trace_exts]):
                ytitle = 'Voltage'
                ylabel = 'Voltage (mV)'
            else:
                ytitle = ylabel = 'Various States'
            title = "{} vs Time".format(ytitle)
            if args.label:
                title = args.label + " - " + title
            ax.get_axes().set_title(title)
            ax.set_xlabel('Time (ms)')
            if rescale_traces:
                ax.set_ylabel('Sci. notation (see legend for magnitude)')
            else:
                ax.set_ylabel(ylabel)
    # Show the plot
    if not args.no_show:
        plt.show()


def plot_activity(arguments):
    "Convenience function used in iPython notebooks"
    import shlex
    main(shlex.split(arguments))

if __name__ == '__main__':
    main(sys.argv[1:])
