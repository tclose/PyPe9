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
import numpy
import math

PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('xml_filename', type=str, help='The name of the xml file to load the cells from.')
parser.add_argument('--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE,
                            help='Option to build the NMODL files before running (can be one of \
                            %s.' % ninemlp.BUILD_MODE_OPTIONS)
parser.add_argument('--time', type=float, default=2000.0, help='The run time of the simulation (ms)')
parser.add_argument('--output', type=str, default=os.path.join(PROJECT_PATH, 'output', 'single_cell.') , help='The output location of the recording files')
parser.add_argument('--min_delay', type=float, default=0.05, help='The minimum synaptic delay in the network')
parser.add_argument('--timestep', type=float, default=0.025, help='The timestep used for the simulation')
parser.add_argument('--inject', nargs=3, default=None, help='Parameters for the current injection')
args = parser.parse_args()


network_xml_location = os.path.join(PROJECT_PATH, 'xml', args.xml_filename)
if not os.path.exists(network_xml_location):
    raise Exception("Could not find xml file at '<kbrain-home>/xml/cerebellum/%s (note passed \
filename needs to be is relative to xml directory)" % args.xml_filename)

ninemlp.BUILD_MODE = args.build

exec("from ninemlp.%s import *" % args.simulator)

print "Building network"

net = Network(network_xml_location,timestep=args.timestep, min_delay=args.min_delay, max_delay=2.0) #@UndefinedVariable

# Get population and print the soma section of the single cell.
pop = net.all_populations()[0]
soma = pop[0]._cell.soma
h.psection(sec=soma)

# Create the input current and times vectors
if args.inject:
    inject_type = args.inject[0]
    if inject_type == 'step':
        current_source = StepCurrentSource({'amplitudes': [float(args.inject[1])],  #@UndefinedVariable
                                             'times': [float(args.inject[2])]}) 
    elif inject_type == 'noise':
        current_source = NoisyCurrentSource({'mean': float(args.inject[1]),#@UndefinedVariable
                                             'stdev':float(args.inject[2]),
                                             'stop': args.time,
                                             'dt': 1.0}) 
                                                                            
    else:
        raise Exception("Unrecognised current injection type '%s'. Valid values are 'step' or 'noise'" % inject_type)
    pop[0].inject(current_source)
    
pop.record_all(args.output + pop.label)
print "------Miscellaneous hoc variables to print------"
potential_variables = [ 'ena', 'ek', 'eca', 'ecl', 'celsius']
for var in potential_variables:
    try:
        print var + ": " + str(getattr(soma, var))
    except:
        pass
print "celsius: " + str(h.celsius)
print "Starting run"

run(args.time) #@UndefinedVariable

end() #@UndefinedVariable

print "Simulated single cell for %f milliseconds" % args.time
