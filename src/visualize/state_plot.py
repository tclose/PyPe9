#!/usr/bin/env python
"""
Contains a method for plotting saved states from NMODL printouts 

@author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

MAX_NUM_POINTS = 25

import sys
import math
import matplotlib.pyplot as plt
import argparse

parser = argparse.ArgumentParser(description='A script to plot spike activity')
parser.add_argument('filename', help='The file to plot the spikes from')
parser.add_argument('--time_start', type=float, default=None, help='The start of the plot')
parser.add_argument('--time_stop', type=float, default=None, help='The stop of the plot')
parser.add_argument('--incr', type=float, default=0.01, help='The minimum increment required before the next step in the voltage trace is plotted as a fraction of the starting value')
parser.add_argument('--extra_label', type=str, default='', help='Additional label information')
args = parser.parse_args()

max_values = {}
min_values = {}
time_i = 0
prev_ID = None
states = {}
times = {}
prev_x = {}
prev_t = {}
order_of_mags= {}
incrs = {}
last_x = {}
last_t = {}
f = open(args.filename)
# Loop through and get the maximum and minimum value for each ID
for line in f:
    if line.startswith('state: '):
        try:
            t, ID, x = line[7:].split()
        except ValueError:
            raise Exception("Incorrectly formatted line '%s', should be 'time ID state_value'.")
        x = float(x)
        if not max_values.has_key(ID):
            max_values[ID] = x
            min_values[ID] = x
        elif x > max_values[ID]:
            max_values[ID] = x
        elif x < min_values[ID]:
            min_values[ID]
for ID in max_values.keys():
    if not max_values[ID] and not min_values[ID]:
        order_of_mags[ID] = 1.0
    else:
        abs_max = max(abs(min_values[ID]), abs(max_values[ID]))
        order_of_mags[ID] = 10.0 ** math.floor(math.log(abs_max,10.0)) # Calculate the order of magnitude of the maximum absolute value
    value_range = max_values[ID] - min_values[ID]
    incrs[ID] = order_of_mags[ID] * args.incr
f.seek(0) # Rewind file back to beginning
# Load states selectively, if the difference between previous voltage point exceeds args.x_incr
for line in f:
    if line.startswith('state: '): # Check to see if the line is state printout
        try:
            t, ID, x = line[7:].split()
        except ValueError:
            raise Exception("Incorrectly formatted line '%s', should be 'time ID state_value'.")
        t = float(t)
        x = float(x)
        if not states.has_key(ID):
            states[ID] = []
            times[ID] = []
            prev_x[ID] = x + 2.0 * incrs[ID]
        if abs(x - prev_x[ID]) > incrs[ID]:
            states[ID].append(x / order_of_mags[ID])
            times[ID].append(t)
            prev_x[ID] = x 
            prev_t[ID] = t
        last_x[ID] = x
        last_t[ID] = t
f.close()
if not states:
    print "No trace was loaded from file"
    sys.exit(0)
# Append last value/time pair to fill out plot of the final ID to the right
for ID in last_x.keys():
    states[ID].append(last_x[ID] / order_of_mags[ID])
    times[ID].append(last_t[ID])
    print "'%s' has %d points (range %g, incr %g)" % (ID,len(states[ID]), max_values[ID] - min_values[ID], incrs[ID])
# Plot states sorted in order of their IDs
legend = []
for ID in sorted(states.keys()):
    state = states[ID]
    time = times[ID]
    num_points = len(state)
    assert(len(time) == num_points)
    # If the number of points exceeds the maxium, decimate the 
    if num_points > MAX_NUM_POINTS:
        incr = num_points / MAX_NUM_POINTS
        state = state[0:incr:num_points]
        time = time[0:incr:num_points]
        print "Warning state '%s' had to have its time course decimated, likely to have large magnitude high frequency oscillations."
    len(time)
    len(state)
    plt.plot(time, state)
    legend.append(ID + ' x 10^' + str(math.log(order_of_mags[ID],10.0)))
plt.legend(legend)
plt.setp(plt.gca().get_legend().get_texts(), fontsize='small')
plt.title('States v Time')
plt.xlabel('Time (ms)')
# Show the plot
plt.show()
