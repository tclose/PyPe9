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
from operator import itemgetter

PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))

def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('xml_filename', type=str, help='The name of the xml file to load the cell from.')
    parser.add_argument('--simulator', type=str, default='neuron',
                                               help="simulator for NINEML+ (either 'neuron' or 'nest')")
    parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE, 
                            metavar='BUILD_MODE',
                                help='Option to build the NMODL files before running (can be one of \
                                %s.' % ninemlp.BUILD_MODE_OPTIONS)
    parser.add_argument('--time', type=float, default=2000.0, help='The run time of the simulation (ms)')
    parser.add_argument('--output', type=str, default=os.path.join(PROJECT_PATH, 'output', 'single_cell.') , help='The output location of the recording files')
    parser.add_argument('--min_delay', type=float, default=0.05, help='The minimum synaptic delay in the network')
    parser.add_argument('--timestep', type=float, default=0.025, help='The timestep used for the simulation')
    parser.add_argument('--inject', nargs=3, default=None, help='Parameters for the current injection. If TYPE is ''step'' ARG1=amplitude and ARG2=delay, whereas if TYPE is ''noise'' ARG1=mean and ARG2=stdev', metavar=('TYPE', 'ARG1', 'ARG2'))
    parser.add_argument('--print_all', action='store_true', help='Prints details for all sections instead of just soma')
    parser.add_argument('--silent_build', action='store_true', help='Suppresses all build output')
    args = parser.parse_args(arguments)
       
    if os.path.exists(args.xml_filename):
        network_xml_location = args.xml_filename
    elif os.path.exists(os.path.join(PROJECT_PATH, 'xml', args.xml_filename)):
        network_xml_location = os.path.join(PROJECT_PATH, 'xml', args.xml_filename)
    else:
        raise Exception("Could not find xml file either as a full path or relative to the cwd and '<kbrain-home>/xml/cerebellum' directories")
    
    ninemlp.BUILD_MODE = args.build
    
    exec("from ninemlp.%s import *" % args.simulator)
    
    print "Building network"
    
    net = Network(network_xml_location,timestep=args.timestep, min_delay=args.min_delay, max_delay=2.0, #@UndefinedVariable
                                                    silent_build=args.silent_build) 
    
    
    # Get population and print the soma section of the single cell.
    pop = net.all_populations()[0]
    cell = pop[0]._cell
    soma = cell.soma_seg
    from neuron import h
    h.psection(sec=soma)
    if args.print_all:
        from neuron import h
        for seg_id, seg in sorted(cell.segments.items(), key=itemgetter(0)):
            print "ID: {0}".format(seg_id)
            h.psection(sec=seg)
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
    from neuron import h
    print "celsius: " + str(h.celsius)
    print "Starting run"
    
    run(args.time) #@UndefinedVariable
    
    end() #@UndefinedVariable
    
    print "Simulated single cell for %f milliseconds" % args.time
    
   
def single_cell(arguments):
    import shlex
    main(shlex.split(arguments))   
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
