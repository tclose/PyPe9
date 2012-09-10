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
import argparse
import ninemlp
from neuron import h

PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('xml_filename', type=str, help='The name of the xml file to load the cells from.')
parser.add_argument('--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--build', type=str, default=ninemlp._BUILD_MODE,
                            help='Option to build the NMODL files before running (can be one of \
                            %s.' % ninemlp.BUILD_MODE_OPTIONS)
parser.add_argument('--time', type=float, default=2000.0, help='The run time of the simulation (ms)')
parser.add_argument('--output', type=str, default=os.path.join(PROJECT_PATH, 'output', 'single_cell.') , help='The output location of the recording files')
parser.add_argument('--min_delay', type=float, default=0.05, help='The minimum synaptic delay in the network')
parser.add_argument('--timestep', type=float, default=0.025, help='The timestep used for the simulation')
args = parser.parse_args()

network_xml_location = os.path.join(PROJECT_PATH, 'xml', args.xml_filename)
if not os.path.exists(network_xml_location):
    raise Exception("Could not find xml file at '<kbrain-home>/xml/cerebellum/%s (note passed \
filename needs to be is relative to xml directory)" % args.xml_filename)

ninemlp.BUILD_MODE = args.build

exec("from ninemlp.%s import *" % args.simulator)

print "Building network"

net = Network(network_xml_location,timestep=args.timestep, min_delay=args.min_delay, max_delay=2.0) #@UndefinedVariable

pop = net.all_populations()[0]
cell = pop[0]._cell
h.psection(sec=cell.soma)

pop.record_all(args.output + pop.label)
    
print "Starting run"

run(args.time) #@UndefinedVariable

end() #@UndefinedVariable

print "Simulated single cell for %f milliseconds" % args.time
