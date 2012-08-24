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
import sys
import os.path
if 'NINEMLP_MPI' in os.environ:
    import mpi4py #@UnresolvedImport @UnusedImport
    print "importing MPI"
import argparse
import ninemlp

PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('xml_filename', type=str, help='The name of the xml file to load the cells from.')
parser.add_argument('--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--build', type=str, default=ninemlp.BUILD_MODE,
                            help='Option to build the NMODL files before running (can be one of \
                            %s.' % ninemlp.BUILD_MODE_OPTIONS)
parser.add_argument('--time', type=float, default=100.0, help='The run time of the simulation (ms)')
parser.add_argument('--output_prefix', type=str, default=os.path.join(PROJECT_PATH, 'output', 'single_cell.') , help='The output location of the recording files')
parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network')
parser.add_argument('--timestep', type=float, default=0.001, help='The timestep used for the simulation')
parser.add_argument('--stim_seed', type=int, default=None, help='The seed passed to the stimulated spikes')
parser.add_argument('--volt_trace', nargs=2, default=[], help='Save voltage traces for the given list of ("population name", "cell ID") tuples')
args = parser.parse_args()

network_xml_location = os.path.join(PROJECT_PATH, 'xml/cerebellum', args.xml_filename)

ninemlp.BUILD_MODE = args.build

exec("from ninemlp.%s import *" % args.simulator)

setup(timestep=args.timestep, min_delay=args.min_delay, max_delay=2.0) #@UndefinedVariable

print "Building network"

net = Network(network_xml_location) #@UndefinedVariable

# Set up spike recordings
for pop in net.all_populations():
    record(pop, args.output_prefix + pop.label + ".spikes") #@UndefinedVariable
    record_v(pop, args.output_prefix + pop.label + ".v") #@UndefinedVariable
#    record_gsyn(pop, args.output_prefix + pop.label + '.gsyn') #@UndefinedVariable
    # record_gsyn = common.build_record('gsyn', simulator)

print "Starting run"

run(args.time) #@UndefinedVariable

end() #@UndefinedVariable

print "Simulated single cell for %f milliseconds" % args.time
