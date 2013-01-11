#!/usr/bin/env python
"""
  This script creates and runs a minimal network in the NINEML+ framework with only one cell 
  in it

  @author Tom Close
  @date 17/9/2012
"""
#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import os.path
import argparse
import ninemlp
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE, 
                    metavar='BUILD_MODE',
                    help='Option to build the NMODL files before running (can be one of \
                          {}.'.format(ninemlp.BUILD_MODE_OPTIONS))
parser.add_argument('--output', type=str, 
                    default=os.path.join(PROJECT_PATH, 'output', 'golgi_tuning.'), 
                    help='The output location of the recording files')
parser.add_argument('--diam', nargs='+', type=float, default=[27.0], help='The diameters to plot')
parser.add_argument('--axon', type=str, default='single_compartment', 
                    help="Which golgi cell model to use")
parser.add_argument('--inject_amp', type=float, default=0.1, help="Amplitude of injected current")
args = parser.parse_args()
if args.axon =='single_compartment':
    model_file='single_golgi_single_compartment.xml'
elif args.axon =='without_axon':
    model_file='single_golgi_without_axon.xml'
elif args.axon =='with_axon':
    model_file='single_golgi_with_axon.xml'        
else:
    raise Exception("Unrecognised option to 'axon' option, '{}'".format(args.axon))
ninemlp.pyNN_build_mode = args.build
from ninemlp.neuron import run, reset, StepCurrentSource, Network
net = Network(os.path.join(PROJECT_PATH, 'xml', 'cerebellum', model_file),
              timestep=0.025, min_delay=1.0, max_delay=2.0)
golgis = net.get_population('Golgis')
golgi = golgis[0]
current_source = StepCurrentSource({'amplitudes': [args.inject_amp], 'times': [500]})
golgis.inject(current_source)
golgis.record_v()
for diam in args.diam:
    golgi.__setattr__('soma_group.diam', diam)
    net.describe()
    run(1000)
    golgis.print_v(args.output + str(diam) + '.v')
    reset()
    print "Simulated Golgi cell with diam {}".format(diam)
print "Done"
