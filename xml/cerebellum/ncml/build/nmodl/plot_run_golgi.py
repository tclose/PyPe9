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

parser = argparse.ArgumentParser(description='A script to plot activity recorded from NINEML+')
parser.add_argument('--incr', type=float, default=0.1, help='The minimum increment required before the next step in the voltage trace is plotted')
args = parser.parse_args()

dt = 0.025

# Load voltages selectively, if the difference between previous voltage point exceeds args.incr
dat = numpy.loadtxt('/home/tclose/kbrain/output/run_golgi.dat')
input_times = dat[:,0]
input_voltages = dat[:,1]
voltages = []
times = []
time_i = 0
prev_v = input_voltages[0] - 2.0 * args.incr
for t, v in zip(input_times, input_voltages):
    # If the voltage change is greater than the specified incr add it to the vector
    if abs(v - prev_v) > args.incr:
        voltages.append(v)
        times.append(time_i * dt)
        prev_v = v
    time_i += 1
# Append last value/time pair to fill out plot of the final ID to the right
voltages.append(v)
times.append(time_i * dt)
plt.plot(times, voltages)
plt.title('Run golgi - Voltage v Time')
plt.xlabel('Time (ms)')
plt.ylabel('Soma Voltage (V)')
plt.show()
