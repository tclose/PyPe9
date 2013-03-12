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
    parser.add_argument('xml_filename', type=str, help='The name of the xml file to load the cell from.')
    parser.add_argument('--simulator', type=str, default='neuron',
                                               help="simulator for NINEML+ (either 'neuron' or 'nest')")
    parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE,
                            metavar='BUILD_MODE',
                                help='Option to build the NMODL files before running (can be one of \
                                %s.' % ninemlp.BUILD_MODE_OPTIONS)
    parser.add_argument('--time', type=float, default=2000.0, help='The run time of the simulation (ms)')
    parser.add_argument('--output', type=str, default=os.path.join(PROJECT_PATH, 'output', 'single_cell.v') , help='The output location of the recording files')
    parser.add_argument('--min_delay', type=float, default=0.05, help='The minimum synaptic delay in the network')
    parser.add_argument('--timestep', type=float, default=0.025, help='The timestep used for the simulation')
    parser.add_argument('--inject', nargs=3, default=None, help='Parameters for the current injection. If TYPE is ''step'' ARG1=amplitude and ARG2=delay, whereas if TYPE is ''noise'' ARG1=mean and ARG2=stdev', metavar=('TYPE', 'ARG1', 'ARG2'))
    parser.add_argument('--print_all', action='store_true', help='Prints details for all sections instead of just soma')
    parser.add_argument('--no_description', action='store_true', help="Suppresses the pyNN description")
    parser.add_argument('--silent_build', action='store_true', help='Suppresses all build output')
    args = parser.parse_args(arguments)
    if os.path.exists(args.xml_filename):
        network_xml_location = args.xml_filename
    elif os.path.exists(os.path.join(PROJECT_PATH, 'xml', args.xml_filename)):
        network_xml_location = os.path.join(PROJECT_PATH, 'xml', args.xml_filename)
    else:
        raise Exception("Could not find xml file either as a full path or relative to the cwd and" \
                        " '<kbrain-home>/xml/cerebellum' directories")
    ninemlp.pyNN_build_mode = args.build
    exec("from ninemlp.%s import *" % args.simulator)
    print "Building network"
    net = Network(network_xml_location, timestep=args.timestep, min_delay=args.min_delay, #@UndefinedVariable
                  max_delay=2.0, silent_build=args.silent_build, build_mode=args.build)
    if not args.no_description:
        net.describe()
    # Get population and print the soma section of the single cell.
    pop = net.all_populations()[0]
    if args.simulator == 'neuron':
        from neuron import h
        for seg in pop[0]._cell.segments:
            h.psection(sec=seg)
    # Create the input current and times vectors
    if args.inject:
        inject_type = args.inject[0]
        if inject_type == 'step':
            current_source = StepCurrentSource({'amplitudes': [float(args.inject[1])], #@UndefinedVariable
                                                 'times': [float(args.inject[2])]})
        elif inject_type == 'noise':
            current_source = NoisyCurrentSource({'mean': float(args.inject[1]), #@UndefinedVariable
                                                 'stdev':float(args.inject[2]),
                                                 'stop': args.time,
                                                 'dt': 1.0})
        else:
            raise Exception("Unrecognised current injection type '{}'. Valid values are 'step' " \
                            "or 'noise'".format(inject_type))
        pop.inject(current_source)
    pop.record_v()
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
    print "Simulated single cell for %f milliseconds" % args.time
    print "Saved voltage trace to '{}'".format(args.output)
    pop.print_v(args.output)
    end() #@UndefinedVariable

def single_cell(arguments):
    import shlex
    main(shlex.split(arguments))

if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
