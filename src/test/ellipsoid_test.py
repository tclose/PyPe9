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
                        default=os.path.join(PROJECT_PATH, 'output', 'ellipsoid_test.'), 
                        help='The output location of the recording files')    
    args = parser.parse_args(arguments)
    print "args.build: {}".format(args.build)
    ninemlp.pyNN_build_mode = args.build
    from ninemlp.neuron import Network
    print "Building network"
    net = Network(os.path.join(PROJECT_PATH, 'xml', 'test', 'ellipsoid_test.xml'),
                  timestep=0.25, min_delay=0.5, max_delay=10.0, temperature=25.0,
                  silent_build=False, build_mode=args.build) 
    net.save_connections(args.output)
    print "Saved connections to '{}'".format(args.output)
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
