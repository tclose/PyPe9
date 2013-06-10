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
import os

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
args = parser.parse_args()

for filename in args.filenames:
    if filename.endswith('pkl'):
        reader = neo.io.PickleIO(filename=args.filenames[0])
    else:
        raise Exception("Unsupported extension for file '{}'".format(filename))
    block = reader.read(cascade=True, lazy=True)[0]
    for seg in block.segments:
        if seg.analogsignalarrays:
            traces_fig = plt.figure()
            traces_ax = traces_fig.add_subplot(111)
            traces_ax.set_title(os.path.basename(filename) + ' Traces')
            for asig in seg.analogsignalarrays:
                traces_ax.plot(asig.times, asig)
        if seg.spiketrains:
            spikes_fig = plt.figure()
            spikes_ax = spikes_fig.add_subplot(111)
            spikes_ax.set_title(os.path.basename(filename) + ' Spikes')
            for s, st in enumerate(seg.spiketrains):
                spikes_ax.plot(st, s * np.ones(st.size), linestyle='None')
plt.show()
