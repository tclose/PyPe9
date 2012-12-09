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
    args = parser.parse_args(arguments) #@UnusedVariable
    from ninemlp.neuron import * #@UnusedWildImport
    print "Building network"
    net = Network(os.path.join(PROJECT_PATH, 'xml', 'cerebellum', 'gap_test.xml'),
                  timestep=0.002, min_delay=0.0025, max_delay=2.0, temperature=25.0,
                  silent_build=False) 
    test1 = net.get_population('Test1')
    test2 = net.get_population('Test2')
    current_source = StepCurrentSource({'amplitudes': [1.0],  #@UndefinedVariable
                                        'times': [1000]}) 
    test1.inject(current_source)
    test1.record_v()
    test2.record_v()
    net.describe()
    run(2000) #@UndefinedVariable
    test1.print_v(os.path.join(PROJECT_PATH, 'output', 'Test1.v'))
    test2.print_v(os.path.join(PROJECT_PATH, 'output', 'Test2.v'))
    print "Simulated gap test network"
   
def single_cell(arguments):
    import shlex
    main(shlex.split(arguments))   
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
