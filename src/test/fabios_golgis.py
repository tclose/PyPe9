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
from mpi4py import MPI #@UnresolvedImport @UnusedImport
import argparse
import ninemlp
import sys
from ninemlp import create_seeds
# Set the project path for use in default parameters of the arguments
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
# Parse the input options
DEFAULT_TIMESTEP = 0.02
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--simulator', type=str, default='neuron', help="simulator for NINEML+ (either "
                                                                    "'neuron' or 'nest')")
parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE, 
                    help="Option to build the NMODL files before running (can be one of {})"
                    .format(ninemlp.BUILD_MODE_OPTIONS))
#parser.add_argument('--mf_rate', type=float, default=5, help="Mean firing rate of the Mossy Fibres "
#                                                             "(default: %(default)s)")
parser.add_argument('--time', type=float, default=2000.0, help="The run time of the simulation (ms)"
                                                               " (default: %(default)s)")
parser.add_argument('--output', type=str, 
                    default=os.path.join(PROJECT_PATH, 'output', 'fabios_golgis.'), 
                    help="The output location of the recording files")
#parser.add_argument('--start_input', type=float, default=1000, help="The start time of the mossy "
#                                                                    "fiber stimulation "
#                                                                    "(default: %(default)s)")
parser.add_argument('--min_delay', type=float, default=DEFAULT_TIMESTEP, 
                    help="The minimum synaptic delay in the network (default: %(default)s)")
parser.add_argument('--timestep', type=float, default=DEFAULT_TIMESTEP, 
                    help="The timestep used for the simulation (default: %(default)s)")
#parser.add_argument('--save_connections', type=str, default=None, help="A path in which to save "
#                                                                       "the generated connections")
#parser.add_argument('--save_cell_positions', type=str, default=None, help="A path in which to save "
#                                                                       "the generated cell positions")
parser.add_argument('--net_seed', type=int, default=None, help="The random seed used to generate the "
                                                               "stochastic parts of the network")
parser.add_argument('--inconsistent_seeds', action='store_true',
                    help="Instead of a constant seed being used for each process a different seed "
                         "on each process, which is required if only minimum number of generated "
                         "random numbers are generated on each node, instead of the whole set. This "
                         "means the simulation will be dependent on not just the provided seeds but "
                         "also the number of processes used, but otherwise shouldn't have any "
                         "detrimental effects")
#parser.add_argument('--stim_seed', type=int, default=None, help="The random seed used to generate "
#                                                                " the stimulation spike train.")
parser.add_argument('--volt_trace', nargs='+', default=[], action='append', 
                    metavar=('POP_ID', 'SLICE_INDICES'), 
                    help="Save voltage traces for the given list of ('population name', 'cell ID') "
                         "tuples")
parser.add_argument('--debug_network', action='store_true', help="Loads a stripped down version of "
                                                                 "the network for easier debugging")
parser.add_argument('--silent_build', action='store_true', help="Suppresses all build output")
parser.add_argument('--include_gap', action='store_true', help="Includes Golgi-to-Golgi gap "
                                                               "junctions into the network")
parser.add_argument('--no_granule_to_golgi', action='store_true', help="Deactivates the granule to "
                                                                       "golgi connection in the "
                                                                       "network.")
parser.add_argument('--log', type=str, help="Save logging information to file")
args = parser.parse_args()
# Delete all system arguments once they are parsed to avoid conflicts in NEST module
del sys.argv[1:]
# Set up logger
if args.log:
    from pyNN.utility import init_logging
    init_logging(args.log, debug=True)
# Set the network xml location
network_xml_location = os.path.join(PROJECT_PATH, 'xml/cerebellum/fabios_golgis.xml')
# Set the build mode for pyNN before importing the simulator specific modules
ninemlp.pyNN_build_mode = args.build
exec("from ninemlp.%s import *" % args.simulator)
# Set the random seeds
net_seed = create_seeds(args.net_seed, simulator.state if args.inconsistent_seeds else None) #@UndefinedVariable
if args.build != 'compile_only' or args.build != 'build_only':
    print "Random seed used to generate the stochastic elements of the network is %d" % net_seed
from pyNN.random import NumpyRNG
net_rng = NumpyRNG(net_seed)
# Build the network
print "Building network"
flags =[]
net = Network(network_xml_location, timestep=args.timestep, min_delay=args.min_delay, max_delay=20.0, #@UndefinedVariable
              build_mode=args.build, silent_build=args.silent_build, flags=flags, rng=net_rng)
#pop = net.get_population('Golgis')
#local_cells = pop[pop._mask_local]
#for cell in local_cells:
  #cell._cell.source_section.Lkg.e_rev = 20.0
#print "Setting up simulation"
#mossy_fibers = net.get_population('MossyFibers')
#mossy_fibers.set_poisson_spikes(args.mf_rate, args.start_input, args.time, stim_rng.rng)
print "Setting up recorders"
net.record_spikes()
# Set up voltage traces    
for volt_trace in args.volt_trace:
    pop = net.get_population(volt_trace[0])
    if len(volt_trace) == 1: 
        view = pop
    elif len(volt_trace) == 2: 
        view = pop[int(volt_trace[1]):(int(volt_trace[1])+1)]
    elif len(volt_trace) == 3: 
        view = pop[int(volt_trace[1]):int(volt_trace[2])]
    elif len(volt_trace) == 4:
        view = pop[int(volt_trace[1]):int(volt_trace[2]):int(volt_trace[3])]
    else:
        raise Exception("Only up to 4 arguments can be provided to volt_trace option ({})"
                        .format(volt_trace))
    view.record_v() #@UndefinedVariable
print "Network description"
net.describe()
#if args.save_connections:
#    print "Saving connections"
#    net.save_connections(args.save_connections)
#if args.save_cell_positions:
#    print "Saving cell positions"
#    net.save_positions(args.save_cell_positions)
print "Starting run"
# Print out basic parameters of the simulation
print "Simulation time: %f" % args.time
#print "Stimulation start: %f" % args.start_input
#print "MossyFiber firing rate: %f" % args.mf_rate
# Actually run simulation
run(args.time) #@UndefinedVariable
print "Simulated Fabio's Network for %f milliseconds" % args.time
net.write_data(args.output)
# Save recorded data to file
#net.print_spikes(args.output)
#for volt_trace in args.volt_trace:
#    pop = net.get_population(volt_trace[0])
#    pop.write_data(args.output + volt_trace[0] + ".v.pkl", variables='v')
print "Saved recorded data to files '{}*.*'".format(args.output)
