#!/usr/bin/env python
"""
  This script creates and runs the Granular network that Fabio created for his 2011 paper.

  @author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import os.path
if 'NINEMLP_MPI' in os.environ:
    import mpi4py #@UnresolvedImport @UnusedImport
    print "importing MPI"
import argparse
import ninemlp
# Set the project path for use in default parameters of the arguments
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
# Parse the input options
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output', type=str, help="The output location of the recording files", 
                    default=os.path.join(PROJECT_PATH, 'output', 'morph_test.')) 
args = parser.parse_args()
network_xml_location = os.path.join(PROJECT_PATH, 'xml', 'test', 'morph_test.xml')
# Set the build mode for pyNN before importing the simulator specific modules
from ninemlp.neuron import * #@UnusedWildImport
print "Building network"
net = Network(network_xml_location, timestep=0.02, min_delay=0.04, max_delay=2.0)
print "Network description"
net.describe()
print "Saving connections"
net.save_connections(args.output)
print "Saved connections"