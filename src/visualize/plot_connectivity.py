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
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D #@UnusedImport (is actually used but pylint doesn't know that)

def plot_connectivity(pre, post, proj, save='', include=[], show=False):
    # Load pre and post positions and projections if required
    if isinstance(pre, str):
        pre = np.loadtxt(pre)
    elif not isinstance(proj, np.array):
        raise Exception("'pre' argument needs to be either a file system path to, a or a Nx2 numpy "
                        "array found ({})".format(type(pre)))        
    if isinstance(post, str):
        post = np.loadtxt(post)
    elif not isinstance(post, np.array):
        raise Exception("'post' argument needs to be either a file system path to, a or a Nx2 "
                        "numpy array found ({})".format(type(post)))
    if isinstance(proj, str):
        proj = np.loadtxt(proj)
        proj = np.array(proj[:, :2], dtype=int)
    elif not isinstance(proj, np.array):
        raise Exception("'proj' argument needs to be either a file system path to, a or a Nx2 "
                        "numpy array found ({})".format(type(proj)))
    # Set up 3D figure
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    for pop, colour in zip((pre, post), ('r', 'g')):
        ax.scatter(xs=pop[:, 0], ys=pop[:, 1], zs=pop[:, 2], c=colour)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    # By default (if optional argument not provided) include all
    if not include:
        include = range(pre.shape[0]) 
    # Plot connections between cells
    for pre_id in include:
        post_ids = proj[proj[:, 0] == pre_id, 1]
        # Basically adds another dimension to the front of the post_positions array
        pre_pos = pre[pre_id, :]
        for post_id in post_ids:
            post_pos = post[post_id, :]
            ax.plot((pre_pos[0], post_pos[0]),
                    (pre_pos[1], post_pos[1]),
                    (pre_pos[2], post_pos[2]), c='b')
    # Save or plot figure as required 
    if save:
        fig.savefig(save, dpi=600, transparent=True)
        print "Saved figure to %s" % save
    elif show:
        plt.show()

if __name__ == '__main__':
    import argparse
    # Set up script arguments
    parser = argparse.ArgumentParser(description='A script to plot the connectivity saved from pynn')
    parser.add_argument('pre', type=str, help="The locations of the presynaptic neurons")
    parser.add_argument('post', type=str, help="The locations of the postsynaptic neurons")
    parser.add_argument('projection', type=str, help="The filename of the saved pyNN connections")
    parser.add_argument('--save', type=str, help="The path to save the figure to")
    parser.add_argument('--include', type=int, nargs='+', help="Selection of neurons for plotting")
    args = parser.parse_args()
    plot_connectivity(args.pre, args.post, args.projection, save=args.save, include=args.include, 
                      show=True)
