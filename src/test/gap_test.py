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
def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE, 
                        metavar='BUILD_MODE',
                        help='Option to build the NMODL files before running (can be one of \
                              {}.'.format(ninemlp.BUILD_MODE_OPTIONS))
    parser.add_argument('--output', type=str, 
                        default=os.path.join(PROJECT_PATH, 'output', 'gap_test.'), 
                        help='The output location of the recording files')    
    args = parser.parse_args(arguments)
    print "args.build: {}".format(args.build)
    ninemlp.pyNN_build_mode = args.build
    from ninemlp.neuron import Network, run, StepCurrentSource
    print "Building network"
    net = Network(os.path.join(PROJECT_PATH, 'xml', 'cerebellum', 'gap_test.xml'),
                  timestep=0.002, min_delay=0.0025, max_delay=2.0, temperature=25.0,
                  silent_build=False, build_mode=args.build) 
    test1 = net.get_population('Test1')
    test2 = net.get_population('Test2')
    current_source = StepCurrentSource({'amplitudes': [1.0], 'times': [100]})
    test1.inject(current_source)
    test1.record_v()
    test2.record_v()
    net.describe()
    run(200)
    test1.print_v(args.output + 'Test1.v')
    test2.print_v(args.output + 'Test2.v')
    print "Simulated gap test network"
   
def gap_test(arguments):
    import shlex
    main(shlex.split(arguments))   
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
