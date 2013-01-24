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

import sys
import math
import matplotlib.pyplot as plt
import argparse

COLOR_SEQUENCE=['b','g','r','m','c','y','k']
PATTERN_SEQUENCE=['-','--',':','-.']

def quit_figure(event):
    """
    Creates a shortcut to close the current window with the key 'q'
    """
    if event.key == 'q':
        plt.close(event.canvas.figure)

parser = argparse.ArgumentParser(description='A script to plot spike activity')
parser.add_argument('filename', help='The file to plot the spikes from')
parser.add_argument('--time_start', type=float, default=None, help='The start of the plot')
parser.add_argument('--time_stop', type=float, default=None, help='The stop of the plot')
parser.add_argument('--incr', type=float, default=0.0, help='The minimum increment required before the next step in the voltage trace is plotted as a fraction of the starting value')
parser.add_argument('--extra_label', type=str, default='', help='Additional label information')
parser.add_argument('--max_num_points', type=int, default=5000, help='The maximum number of lines plotted per state, if the minimum increment fails to reduce the number of lines below this number the state plot will either be decimated or truncated (in order to contain plot to permissible overal number of lines) (default: %(default)s)')
parser.add_argument('--truncate', action="store_true", help='If the number of points for a state falls exceeds the maximum number, the state''s plot will be automatically decimated (have time points removed) down to an appropriate size. However, using this option it can also be truncated to show a short example of the trace with no intermediate points missing')
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
line_count = 0
fig = plt.figure()
cid = fig.canvas.mpl_connect('key_press_event', quit_figure) # Register the 'q' -> close shortcut key with the current figure    
ax = plt.subplot(111)
for ID in sorted(states.keys()):
    state = states[ID]
    time = times[ID]
    num_points = len(state)
    assert(len(time) == num_points)
    # If the number of points exceeds the maxium, decimate the 
    if num_points > args.max_num_points:
        if args.truncate:
            state = state[0:args.max_num_points]
            time = time[0:args.max_num_points]
            print "Warning state '%s' has had its time course truncated at t=%f" % (ID, time[-1])
        else:
            incr = num_points / args.max_num_points            
            state = state[0:incr:num_points]
            time = time[0:incr:num_points]
            print "Warning state '%s' has had its time course decimated, meaning it may have large magnitude high frequency oscillations that have been omitted from the plot (use '--truncate' option to investigate short section of trace)." % ID
    line_style = COLOR_SEQUENCE[line_count % len(COLOR_SEQUENCE)] + \
                 PATTERN_SEQUENCE[line_count/len(COLOR_SEQUENCE) % len(PATTERN_SEQUENCE)]
    ax.plot(time, state, line_style)
    line_count += 1
    legend.append(ID + ' x 10^' + str(math.log(order_of_mags[ID],10.0)))
box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
# Put a legend to the right of the current axis
ax.legend(legend,loc='center left', bbox_to_anchor=(1, 0.5))
plt.setp(plt.gca().get_legend().get_texts(), fontsize='small')
plt.title('States v Time (%s)' % args.filename)
plt.xlabel('Time (ms)')
# Show the plot

plt.show()
