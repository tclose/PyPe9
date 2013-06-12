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

def plot_connectivity(pre, post, proj, save='', include=None, show=False, weight_variable='weights', 
                      transparency_range=(0.1,1.0), black_bg=False, histogram=False):
    # Load pre and post positions and projections if required
    if isinstance(pre, str):
        pre_file = pre
        pre = np.loadtxt(pre)
        if not len(pre):
            raise Exception("No connections loaded from file '{}'".format(pre_file))
    elif not isinstance(proj, np.array):
        raise Exception("'pre' argument needs to be either a file system path to, a or a Nx2 numpy "
                        "array found ({})".format(type(pre)))
    if isinstance(post, str):
        post_file = post
        post = np.loadtxt(post)
        if not len(post):
            raise Exception("No connections loaded from file '{}'".format(post_file))
    elif not isinstance(post, np.array):
        raise Exception("'post' argument needs to be either a file system path to, a or a Nx2 "
                        "numpy array found ({})".format(type(post)))
    if isinstance(proj, str):
        proj_file = proj
        proj = np.loadtxt(proj_file)
        if not len(proj):
            raise Exception("No connections loaded from file '{}'".format(proj_file))
    elif not isinstance(proj, np.array):
        raise Exception("'proj' argument needs to be either a file system path to, a or a Nx2 "
                        "numpy array found ({})".format(type(proj)))
    if histogram:
        num_axes = proj.shape[1] - 1
    else:
        num_axes = 1
    # Set up 3D figure
    fig = plt.figure()
    ax1 = fig.add_subplot(num_axes, 1, 1, projection='3d')
    if black_bg:
        fig.patch.set_facecolor('black')
        ax1.patch.set_facecolor('black')
    for pop, colour in zip((pre, post), ('b', 'm')):
        ax1.scatter(xs=pop[:, 1], ys=pop[:, 2], zs=pop[:, 3], c=colour)
    ax1.set_xlabel('X')
    ax1.set_ylabel('Y')
    ax1.set_zlabel('Z')
    # By default (if optional argument not provided) include all
    if include and ':' in include[0]:
        slice_args = [int(i) for i in include[0].split(':')]
        if len(slice_args) == 1:
            parsed_include = range(pre.shape[0])[int(slice_args[0]):(int(slice_args[0]) + 1)]
        elif len(slice_args) == 2:
            parsed_include = range(pre.shape[0])[int(slice_args[0]):int(slice_args[1])]
        elif len(slice_args) == 3:
            parsed_include = range(pre.shape[0])[int(slice_args[0]):int(slice_args[1]):int(slice_args[2])]
        else:
            raise Exception("Only up to 4 arguments can be provided to include option ({})"
                            .format(include))
    elif include:
        parsed_include = [int(i) for i in include]
    else:
        parsed_include = range(pre.shape[0])
    # Plot connections between cells
    for pre_id in parsed_include:
        post_ids = np.array(proj[np.array(proj[:, 0], dtype=int) == pre_id, 1], dtype=int)
        if weight_variable == 'weights':
            weightings = proj[:,2]
        elif weight_variable == 'delays':
            weightings = proj[:,3]
        else:
            raise Exception("'weight_variable' has unexpected value '{}' (can be either 'weights' "
                            "or 'delays')")
        alphas = (weightings * (transparency_range[1] - transparency_range[0]) / weightings.max() + 
                 transparency_range[0])
        # Basically adds another dimension to the front of the post_positions array
        pre_pos = pre[pre_id, :]
        for post_id, alpha in zip(post_ids, alphas):
            post_pos = post[post_id, :]
            ax1.plot((pre_pos[1], post_pos[1]),
                    (pre_pos[2], post_pos[2]),
                    (pre_pos[3], post_pos[3]), c='y', alpha=alpha)
        ax1.set_aspect('equal')
    if histogram:
        ax2 = fig.add_subplot(num_axes, 1, 2)
        ax2.hist(proj[:,2], bins=50)
        ax2.set_xlabel('weight (uS)')
        ax2.set_ylabel('frequency')
        if num_axes == 3:
            ax3 = fig.add_subplot(num_axes, 1, 3)
            ax3.hist(proj[:,3], bins=50)
            ax3.set_xlabel('delay (ms)')
            ax3.set_ylabel('frequency')
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
    parser.add_argument('--black_bg', action='store_true', help="Uses a black background")
    parser.add_argument('--histogram', action='store_true', help="Plots histogram of variables")
    parser.add_argument('--save', type=str, help="The path to save the figure to")
    parser.add_argument('--include', type=str, nargs='+', help="Selection of neurons for plotting")
    parser.add_argument('--weight_variable', type=str, default='weights',
                        help="The connection variable (i.e. 'weights' or 'delays') used to weight "
                        "the transparency of the connections")
    parser.add_argument('--transparency_range', nargs=2, type=float, default=(1.0, 1.0), 
                        help="The range of the transparency used for the connections")
    args = parser.parse_args()
    plot_connectivity(args.pre, args.post, args.projection, save=args.save, include=args.include,
                      weight_variable=args.weight_variable, 
                      transparency_range=args.transparency_range, show=True, black_bg=args.black_bg,
                      histogram=args.histogram)
