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

parser = argparse.ArgumentParser(description='A script to plot spike activity')
parser.add_argument('filename', help='The file to plot the spikes from')
parser.add_argument('--time_start', type=float, default=None, help='The start of the plot')
parser.add_argument('--time_stop', type=float, default=None, help='The stop of the plot')
parser.add_argument('--v_incr', type=float, default=0.1, help='The minimum increment required before the next step in the voltage trace is plotted')
parser.add_argument('--extra_label', type=str, default='', help='Additional label information')
args = parser.parse_args()

# Load voltages selectively, if the difference between previous voltage point exceeds args.v_incr
f = open(args.filename)
time_i = 0
prev_ID = None
voltages = []
times = []
IDs = []
for line in f:
    if line[0] != '#': # Check to see if the line is a comment
        v, ID = line.split()
        v = float(v)
        # If the ID signifies the start of a new cell reset the time index
        if ID != prev_ID:
            # If not in the initial loop, append last value/time pair to fill out the plot of the previous ID out to the right 
            if prev_ID != None:
                voltages[-1].append(v)
                times[-1].append(time_i * file_header['dt'])
            time_i = 0
            prev_v = v - 2.0 * args.v_incr
            prev_ID = ID
            voltages.append([])
            times.append([])
            IDs.append(int(float(ID)))
        # If the voltage change is greater than the specified v_incr add it to the vector
        if abs(v - prev_v) > args.v_incr:
            voltages[-1].append(v)
            times[-1].append(time_i * file_header['dt'])
            prev_v = v
        time_i += 1
# Append last value/time pair to fill out plot of the final ID to the right
voltages[-1].append(v)
times[-1].append(time_i * file_header['dt'])
if not voltages:
    print "No trace was loaded from file"
    sys.exit(0)
# Plot voltages sorted in order of their IDs
sorted_IDs = []
for t, v, ID in sorted(zip(times, voltages, IDs), key=lambda line: int(float(line[2]))):
    plt.plot(t, v)
    sorted_IDs.append(ID)
plt.legend(sorted_IDs)
plt.title(file_header['label'] + ' ' + args.extra_label + ' - States v Time')
plt.xlabel('Time (ms)')
# Show the plot
plt.show()
