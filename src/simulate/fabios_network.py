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
import sys
from pyNN import __version__
import os.path
if 'NINEMLP_MPI' in os.environ:
    import mpi4py #@UnresolvedImport @UnusedImport
    print "importing MPI"
import argparse
import ninemlp
import time
# Set the project path for use in default parameters of the arguments
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
# Parse the input options
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE,
                            help='Option to build the NMODL files before running (can be one of \
                            %s.' % ninemlp.BUILD_MODE_OPTIONS)
parser.add_argument('--mf_rate', type=float, default=5, help='Mean firing rate of the Mossy Fibres (default: %(default)s)')
parser.add_argument('--time', type=float, default=2000.0, help='The run time of the simulation (ms) (default: %(default)s)')
parser.add_argument('--output', type=str, default=os.path.join(PROJECT_PATH, 'output', 'fabios_network.') , help='The output location of the recording files')
parser.add_argument('--start_input', type=float, default=1000, help='The start time of the mossy fiber stimulation (default: %(default)s)')
parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network (default: %(default)s)')
parser.add_argument('--timestep', type=float, default=0.001, help='The timestep used for the simulation (default: %(default)s)')
parser.add_argument('--save_connections', type=str, default=None, help='A path in which to save the generated connections')
parser.add_argument('--stim_seed', type=int, default=None, help='The seed passed to the stimulated spikes')
parser.add_argument('--para_unsafe', action='store_true', help='If set the network simulation will try to be parallel neuron safe')
parser.add_argument('--volt_trace', metavar=('POPULATION', 'INDEX'), nargs=2, default=[], action='append', help='Save voltage traces for the given list of ("population name", "cell ID") tuples')
parser.add_argument('--debug_network', action='store_true', help='Loads a stripped down version of the network for easier debugging')
parser.add_argument('--silent_build', action='store_true', help='Suppresses all build output')
parser.add_argument('--include_gap', action='store_true', help='Includes Golgi-to-Golgi gap junctions into the network')
parser.add_argument('--no_granule_to_golgi', action='store_true', help='Deactivates the granule to golgi connection in the network.')
args = parser.parse_args()
# Set the network xml location
if args.debug_network:
    xml_filename = 'debug_fabios.xml'
else:
    xml_filename = 'fabios_network.xml'
network_xml_location = os.path.join(PROJECT_PATH, 'xml/cerebellum', xml_filename)
# Set the stimulation random seed
if not args.stim_seed:
    stim_seed = long(time.time() * 256)
    print "Stimulation seed is %d" % stim_seed
else:
    stim_seed = int(args.stim_seed)
# Set the build mode for pyNN before importing the simulator specific modules
ninemlp.pyNN_build_mode = args.build
exec("from ninemlp.%s import *" % args.simulator)
# Set flags for the construction of the network
flags = []
if args.include_gap:
    flags.append('includeGap')
if args.no_granule_to_golgi:
    flags.append(('GranuleToGolgi', False))
# Build the network
print "Building network"
net = Network(network_xml_location, timestep=args.timestep, min_delay=args.min_delay, max_delay=2.0, #@UndefinedVariable
                                build_mode=args.build, silent_build=args.silent_build, flags=flags)

print "Setting up simulation"
mossy_fibers = net.get_population('MossyFibers')
mossy_fibers.set_poisson_spikes(args.mf_rate, args.start_input, args.time)
print "Setting up recorders"
net.record_all_spikes(args.output)
golgis = net.get_population('Golgis')
for ID in golgis:
    neuron.h.psection(sec=ID._cell.soma_seg) #UndefinedVariable
# Set up voltage traces    
for pop_id, cell_id in args.volt_trace:
    cell = net.get_population(pop_id)[int(cell_id)]
    record_v(cell, args.output + pop_id + "." + cell_id + ".v") #@UndefinedVariable
print "Network description"
net.describe()
if args.save_connections:
    print "Saving connections"
    net.save_connections(args.save_connections)
print "Starting run"
# Print out basic parameters of the simulation
print "Simulation time: %f" % args.time
print "Stimulation start: %f" % args.start_input
print "MossyFiber firing rate: %f" % args.mf_rate
# Actually run simulation
run(args.time) #@UndefinedVariable
end() #@UndefinedVariable
print "Simulated Fabio's Network for %f milliseconds" % args.time
