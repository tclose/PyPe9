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
    parser.add_argument('--reverse_inject', help="Inject current into population 2 instead of "
                                                 "population 1 to check both connections are "
                                                 "working.", action='store_true')
    parser.add_argument('--log_file', help='The location of the log file', type=str, 
                        default=os.path.join(PROJECT_PATH, 'output', 'gap_test.log'))
    args = parser.parse_args(arguments)    
    from pyNN.utility import init_logging
    init_logging(args.log_file, debug=True)
    print "args.build: {}".format(args.build)
    ninemlp.pyNN_build_mode = args.build
    from ninemlp.neuron import Network, run, StepCurrentSource, simulator
    print "Building network"
    net = Network(os.path.join(PROJECT_PATH, 'xml', 'cerebellum', 'gap_test.xml'),
                  timestep=0.25, min_delay=0.5, max_delay=10.0, temperature=25.0,
                  silent_build=False, build_mode=args.build) 
    test1 = net.get_population('Test1')
    test2 = net.get_population('Test2')
    current_source = StepCurrentSource(amplitudes=[1.0], times=[100])
    if args.reverse_inject:
        test2.inject(current_source)
    else:        
        test1.inject(current_source)
    test1.record_v()
    test2.record_v()
    print "Created Network"
    net.describe()
    print "Starting run..."
    #simulator.state.parallel_context.timeout = 10
    run(200)
    print "Finished run. Saving..."
    test1.print_v(args.output + 'Test1.v.pkl')
    test2.print_v(args.output + 'Test2.v.pkl')
    print "Simulated gap test network"
   
def gap_test(arguments):
    import shlex
    main(shlex.split(arguments))   
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
