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

import os.path
import numpy as np
import matplotlib.pyplot as plt
import argparse
from mpl_toolkits.mplot3d import Axes3D #@UnusedImport

def quit_figure(event):
    """
    Creates a shortcut to close the current window with the key 'q'
    """
    if event.key == 'q':
        plt.close(event.canvas.figure)


parser = argparse.ArgumentParser(description='A script to plot the connectivity saved from pynn')
parser.add_argument('pre', type=str, help="The locations of the presynaptic neurons")
parser.add_argument('post', type=str, help="The locations of the postsynaptic neurons")
parser.add_argument('projection', type=str, help="The filename of the saved pyNN connections")
parser.add_argument('--transparency', type=float, default=0.3, help="The transparency of the projection barrier surfaces")
parser.add_argument('--save', type=str, help="The path to save the figure to")
args = parser.parse_args()


# Load positions from file into dictionary and record limits on z axis

fig = plt.figure()
cid = fig.canvas.mpl_connect('key_press_event', quit_figure) # Register the 'q' -> close shortcut key with the current figure    
ax = fig.add_subplot(111, projection='3d')

min_bound = float('inf')
max_bound = float('-inf')
pre = np.loadtxt(args.pre)
post = np.loadtxt(args.post)
for pop, colour in zip((pre, post), ('r', 'g')):
    ax.scatter(xs=pop[:, 0], ys=pop[:, 1], zs=pop[:, 2], c=colour)
    minimum = pop.min()
    if minimum < min_bound:
        min_bound = minimum
    maximum = pop.max()
    if maximum > max_bound:
        max_bound = maximum
    
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

projections = np.loadtxt(args.projection)

#Plot bounding cylinder
for pre_id, post_id, weight, delay in projections:
    cell_pos = pre[pre_id, :]
    post_positions = post[projections[:, 0] == post_id, :]
    # Basically adds another dimension to the front of the post_positions array
    for i in xrange(post_positions.shape[0]):
        ax.plot((cell_pos[0], post_positions[i, 0]),
                (cell_pos[1], post_positions[i, 1]),
                (cell_pos[2], post_positions[i, 2]),
                c='b')
    print "Plotted %d projections" % post_positions.shape[0]
    
# Hack for poster
x_range = max_bound - min_bound
ax.set_xlim(-x_range / 2, x_range / 2)

if args.save:
    fig.savefig(args.save, dpi=600, transparent=True)
    print "Saved figure to %s" % args.save
else:
    plt.show()

