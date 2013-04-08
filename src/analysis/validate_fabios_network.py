#!/usr/bin/env python
"""
This script plot comparisons between cell positions and connectivity between legacy hoc version
of fabios (granular-layer) network and new PyNN version 

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
from visualize import tube_mesh, ellipse_tube_mesh

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--legacy_dir", default='/home/tclose/kbrain/external/fabios_network', type=str,
                    help="The location of the directory containing the output data of the legacy run.")
parser.add_argument("--new_dir", default='/home/tclose/Desktop/fabios_pos_connect', type=str,
                    help="The location of the directory containing the output data of the pyNN run.")
args = parser.parse_args()

pop_names = ['Granules.pop','MossyFibers.pop','Golgis.pop']
proj_names = ['Golgis_Granules.proj', 'MossyFibers_Golgis.proj', 'MossyFibers_Granules_AMPA.proj', 
              'Granules_Golgis.proj',  'MossyFibers_Granules_NMDA.proj', 'Golgis_Golgis_Gap.proj']

legacy_pops = {}
new_pops = {}

for pop in pop_names:
    legacy = np.loadtxt(os.path.join(args.legacy_dir, pop))
    new = np.loadtxt(os.path.join(args.new_dir, pop))[:, 1:]
    legacy_pops[os.path.splitext(pop)[0]] = legacy
    new_pops[os.path.splitext(pop)[0]] = new
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(legacy[:,0], legacy[:,1], legacy[:,2], c='r')
    ax.scatter(new[:,0], new[:,1], new[:,2], c='b')
    plt.title(pop)
    
for proj in proj_names:
    # Load connectivity data
    legacy = np.loadtxt(os.path.join(args.legacy_dir, proj))
    new = np.loadtxt(os.path.join(args.new_dir, proj))
    pre, post = os.path.splitext(proj)[0].split('_')[0:2]
    # Get distances of connections by referencing appropriate cell positions
    legacy_pre = legacy_pops[pre]
    legacy_post = legacy_pops[post]
    legacy_disp = (legacy_pre[np.array(legacy[:,0], dtype=int),:] - 
                   legacy_post[np.array(legacy[:,1], dtype=int),:])
    legacy_dist = np.sqrt(np.sum(legacy_disp**2, axis=1)) 
    new_pre = new_pops[pre]
    new_post = new_pops[post]
    new_disp = (new_pre[np.array(new[:,0],dtype=int),:] - 
                new_post[np.array(new[:,1], dtype=int),:])
    new_dist = np.sqrt(np.sum(new_disp**2, axis=1))
    # Plot distance, weight and delay on 3D scatter plot
    fig1 = plt.figure()
    if legacy.shape[1] == 3:
        ax1 = fig1.add_subplot(111)
        ax1.scatter(legacy_dist[0:100], legacy[0:100:,2], c='r')
        ax1.scatter(new_dist[0:100], new[0:100:,2], c='b')
    elif legacy.shape[1] == 4:
        ax1 = fig1.add_subplot(111, projection='3d')
        ax1.scatter(legacy_dist[0:100], legacy[0:100:,2], legacy[0:100:,3], c='r')
        ax1.scatter(new_dist[0:100], new[0:100:,2], new[0:100:,3], c='b')
        ax1.set_zlabel('Delay')
    else:
        raise Exception("Connections should either have 3 or 4 columns")
    ax1.set_xlabel('Distance')
    ax1.set_ylabel('Weight')
    plt.title(proj + " - Weights and Delays vs Distance")
    # Plot connection distances histogram
    fig2 = plt.figure()
    ax2 = fig2.add_subplot(111)
    ax2.hist(legacy_dist, 100, color='r')
    ax2.hist(new_dist, 100, color='b')
    plt.title(proj + " - Distance Histogram")
    # Get number of post cells histogram
    legacy_pre_ids = np.unique(legacy[:,0])
    legacy_num_conns = []
    for id in legacy_pre_ids:
        legacy_num_conns.append(np.count_nonzero(legacy[:,0] == id))
    new_pre_ids = np.unique(new[:,0])
    new_num_conns = []
    for id in new_pre_ids:
        new_num_conns.append(np.count_nonzero(new[:,0] == id))
    fig3 = plt.figure()
    ax3 = fig3.add_subplot(111)
    nprebins = min((int(len(legacy_pre_ids)), 50))
    ax3.hist(legacy_num_conns, nprebins, color='r')
    ax3.hist(new_num_conns, nprebins, color='b')
    plt.title(proj + " - Pre Connections Histogram {}".format(nprebins))
    # Get number of pre cells histogram
    legacy_post_ids = np.unique(legacy[:,1])
    legacy_num_conns = []
    for id in legacy_post_ids:
        legacy_num_conns.append(np.count_nonzero(legacy[:,1] == id))
    new_post_ids = np.unique(new[:,1])
    new_num_conns = []
    for id in new_post_ids:
        new_num_conns.append(np.count_nonzero(new[:,1] == id))
    fig3 = plt.figure()
    ax3 = fig3.add_subplot(111)
    npostbins = min((int(len(legacy_post_ids)), 50))
    ax3.hist(legacy_num_conns, npostbins, color='r')
    ax3.hist(new_num_conns, npostbins, color='b')
    plt.title(proj + " - Post Connections Histogram {}".format(npostbins))       

plt.show()

