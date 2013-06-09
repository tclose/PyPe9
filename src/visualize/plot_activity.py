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


import neo
import urllib
from matplotlib import pyplot
import numpy
import argparse

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

distantfile = 'https://portal.g-node.org/neo/neuroexplorer/File_neuroexplorer_2.nex'
localfile = 'File_neuroexplorer_2.nex'
urllib.urlretrieve(distantfile, localfile)


reader = neo.io.NeuroExplorerIO(filename = 'File_neuroexplorer_2.nex')
bl = reader.read(cascade = True, lazy = False)[0]
for seg in bl.segments:
    fig = pyplot.figure()
    ax1 = fig.add_subplot(2,1,1)
    ax2 = fig.add_subplot(2,1,2, sharex = ax1)
    ax1.set_title(seg.file_origin)
    for asig in seg.analogsignals:
        ax1.plot(asig.times, asig)
    for s,st in enumerate(seg.spiketrains):
        print st.units
        ax2.plot(st, s*numpy.ones(st.size), linestyle = 'None', 
                    marker = '|', color = 'k')
pyplot.show()
