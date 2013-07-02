#!/usr/bin/env python
"""
Contains a method for plotting activity recorded from Neural simulations

@author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################


import neo.io
import matplotlib.pyplot as plt
import numpy as np
import argparse
import sys
import quantities as units

def main(arguments):
    parser = argparse.ArgumentParser(description='A script to plot activity recorded from NINEML+')
    parser.add_argument('filenames', nargs='+', help='The files to plot the activity from')
    parser.add_argument('--time_start', type=float, default=None, help='The start of the plot')
    parser.add_argument('--time_stop', type=float, default=None, help='The stop of the plot')
    parser.add_argument('--incr', type=float, default=0.1,
                        help="The minimum increment required before the next step in the variable "
                             "trace is plotted")
    parser.add_argument('--label', type=str, default='', help='Additional label information')
    parser.add_argument('--include', nargs='+', type=str, default=None, 
                        help="Indices or slices of indices to include")
    parser.add_argument('--combine', action='store_true',
                        help='Plot the variable figures on a single combined axis')
    parser.add_argument('--no_show', action='store_true',
                        help="Don't show the plots initially (waiting for other plots to be " \
                             "plotted")
    parser.add_argument('--spikes_histogram', action='store_true', 
                        help="Plots a histogram of the number of spikes per cell")
    parser.add_argument('--prefix_filename', action='store_true',
                        help="Include the filenames of the files in the subplot titles")
    parser.add_argument('--only', type=str, default=None, help='Only plot spikes or traces')
    args = parser.parse_args(arguments)
    if args.include:
        if len(args.include) == 1 and ':' in args.include[0]:
            args.include = slice(*[float(i) for i in args.include[0].split(':')])
        else:
            args.include = [float(i) for i in args.include]
    for filename in args.filenames:
        if filename.endswith('pkl'):
            reader = neo.io.PickleIO(filename=filename)
        else:
            raise Exception("Unsupported extension for file '{}'".format(filename))
        block = reader.read(cascade=True, lazy=True)[0]
        for seg in block.segments:
            if seg.analogsignalarrays and (not args.only or args.only == 'traces'):
                traces_fig = plt.figure()
                traces_ax = traces_fig.add_subplot(111)
                traces_ax.set_title(filename + ' - Traces')
                for asig in seg.analogsignalarrays:
                    signals = np.asarray(asig)
                    if args.include:
                        signals = signals[:, args.include]
                    times = np.asarray(asig.times)
                    # Filters out steps that result in minor changes to the y-axis value (eg. voltage)
                    # to reduce the plotting load.
                    if args.incr:
                        mask_array = np.zeros(signals.shape, dtype=bool)
                        prev_values = - np.ones(signals.shape[1]) * np.inf
                        for time_i, values in enumerate(signals):
                            mask = np.where(abs(values - prev_values) > args.incr)[0]
                            mask_array[time_i, mask] = 1.0
                            prev_values[mask] = values[mask]
                        print ("Using an increment of {0} -> displaying of {1:.1f}% of signal data"
                               .format(args.incr, 100.0 * float(np.count_nonzero(mask_array))/
                                                  float(mask_array.shape[0] * mask_array.shape[1])))
                        for mask, sig in zip(mask_array.T, signals.T):
                            traces_ax.plot(times[mask], sig[mask])
                    else:
                        traces_ax.plot(times, signals)
                traces_ax.set_xlabel('Time (ms)')
                traces_ax.set_ylabel('Voltage (mV)')
                traces_ax.legend([str(i) for i in args.include])
            if seg.spiketrains and (not args.only or args.only == 'spikes'):
                spikes_fig = plt.figure()
                spikes_ax = spikes_fig.add_subplot(111)
                spikes_ax.set_title(filename + ' - Spikes')
                max_time = float('-inf')
                for s, st in enumerate(seg.spiketrains):
                    if len(st):
                        st_max_time = np.max(st)
                        if st_max_time > max_time:
                            max_time = st_max_time
                        spikes_ax.scatter(st, s * np.ones(st.size))
                if max_time != float('-inf'):
                    plt.axis([0.0 * units.s, max_time, 0, len(seg.spiketrains)])
                spikes_ax.set_xlabel('Time (ms)')
                spikes_ax.set_ylabel('Cell index')
                if args.spikes_histogram:
                    hist_fig = plt.figure()
                    hist_ax = hist_fig.add_subplot(111)
                    hist_ax.set_title(filename + ' - Spike Histogram')
                    hist_ax.set_xlabel('Number of spikes')
                    hist_ax.set_ylabel('Frequency')
                    hist_ax.hist(np.array([len(st) for st in seg.spiketrains]))
    if args.no_show:
        print "Delaying display of plot until matplotlib.pyplot.show() is called"
    else:
        plt.show()

def plot_activity(arguments):
    "Convenience function used in iPython notebooks"
    import shlex
    main(shlex.split(arguments))

if __name__ == '__main__':
    main(sys.argv[1:])
    
