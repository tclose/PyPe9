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
              'Granules_Golgis.proj',  'MossyFibers_Granules_NMDA.proj']

for pop in pop_names:
    legacy = np.loadtxt(os.path.join(args.legacy_dir, pop))
    new = np.loadtxt(os.path.join(args.new_dir, pop))[:, 1:]
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(legacy[:,0], legacy[:,1], legacy[:,2], c='r')
    ax.scatter(new[:,0], new[:,1], new[:,2], c='b')
    plt.title(pop)
    
for proj in proj_names:
    legacy = np.loadtxt(os.path.join(args.legacy_dir, proj))
    new = np.loadtxt(os.path.join(args.new_dir, proj))
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(legacy[0:100:,2], legacy[0:100:,3], c='r')
    ax.scatter(new[0:100:,2], new[0:100:,3], c='b')
    plt.title(proj)

plt.show()

