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
    parser.add_argument('--input_rate', type=float, default=5, help="Mean firing rate of the input population "
                                                             "(default: %(default)s)")
    parser.add_argument('--start_input', type=float, default=1000, help="The start time of the input population"
                                                                    " stimulation "
                                                                    "(default: %(default)s)")
    args = parser.parse_args(arguments)
    if os.path.exists(args.xml_filename):
        network_xml_location = args.xml_filename
    elif os.path.exists(os.path.join(PROJECT_PATH, 'xml', args.xml_filename)):
        network_xml_location = os.path.join(PROJECT_PATH, 'xml', args.xml_filename)
    else:
        raise Exception("Could not find xml file '{}' either as a full path or relative to the cwd and"
                        " '<kbrain-home>/xml/cerebellum' directories".format(args.xml_filename))
    ninemlp.pyNN_build_mode = args.build
    exec("from ninemlp.%s import *" % args.simulator)
    print "Building network"
    net = Network(network_xml_location,timestep=args.timestep, min_delay=args.min_delay, #@UndefinedVariable
                  max_delay=2.0, silent_build=args.silent_build) 
    # Get population and print the soma section of the single cell.
    granules = net.get_population("Granules")
    nmda_input = net.get_population("NMDAInput")
    nmda_input.set_poisson_spikes(args.input_rate, args.start_input, args.time)
#    granules_nmda_input = net.get_projection("NMDAInput_Granules")
#    granules_nmda_input.setWeights(new_weight)
#    cell = pop[0]._cell
#    soma = cell.soma_seg
#    from neuron import h
#    h.psection(sec=soma)
#    if args.print_all:
#        from neuron import h
#        for seg_id, seg in sorted(cell.segments.items(), key=itemgetter(0)):
#            print "ID: {0}".format(seg_id)
#            h.psection(sec=seg)
    # Create the input current and times vectors
#    if args.inject:
#        inject_type = args.inject[0]
#        if inject_type == 'step':
#            current_source = StepCurrentSource({'amplitudes': [float(args.inject[1])],  #@UndefinedVariable
#                                                 'times': [float(args.inject[2])]}) 
#        elif inject_type == 'noise':
#            current_source = NoisyCurrentSource({'mean': float(args.inject[1]),#@UndefinedVariable
#                                                 'stdev':float(args.inject[2]),
#                                                 'stop': args.time,
#                                                 'dt': 1.0})                                                                                
#        else:
#            raise Exception("Unrecognised current injection type '{}'. Valid values are 'step' " \
#                            "or 'noise'".format(inject_type))
#        granules[0].inject(current_source)
    net.record_spikes()
    granules.record_v()
    print "------Miscellaneous hoc variables to print------"
    net.describe()
    print "Starting run"
    run(args.time) #@UndefinedVariable
    end() #@UndefinedVariable
    net.print_spikes(args.output)
    granules.print_v(args.output + granules.label + ".v")
    print "Saved recorded data to files '{}*.*'".format(args.output)
    print "Simulated single cell for %f milliseconds" % args.time
   
def single_cell(arguments):
    import shlex
    main(shlex.split(arguments))   
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
