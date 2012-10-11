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
parser.add_argument('--mf_rate', type=float, default=1, help='Mean firing rate of the Mossy Fibres')
parser.add_argument('--time', type=float, default=100.0, help='The run time of the simulation (ms)')
parser.add_argument('--output_prefix', type=str, default=os.path.join(PROJECT_PATH, 'output', 'fabios_network.') , help='The output location of the recording files')
parser.add_argument('--start_input', type=float, default=50, help='The start time of the mossy fiber stimulation')
parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network')
parser.add_argument('--timestep', type=float, default=0.001, help='The timestep used for the simulation')
parser.add_argument('--save_connections', type=str, default=None, help='A path in which to save the generated connections')
parser.add_argument('--stim_seed', type=int, default=None, help='The seed passed to the stimulated spikes')
parser.add_argument('--para_unsafe', action='store_true', help='If set the network simulation will try to be parallel neuron safe')
parser.add_argument('--volt_trace', metavar=('POPULATION', 'INDEX'), nargs=2, default=[], help='Save voltage traces for the given list of ("population name", "cell ID") tuples')
args = parser.parse_args()
# Set the network xml location
golgi_xml_location = os.path.join(PROJECT_PATH, 'xml', 'cerebellum', 'ncml', 'Golgi.xml')
# Set the stimulation random seed
if not args.stim_seed:
    stim_seed = long(time.time() * 256)
    print "Stimulation seed is %d" % stim_seed
else:
    stim_seed = int(args.stim_seed)
# Print out basic parameters of the simulation
print "Simulation time: %f" % args.time
print "Stimulation start: %f" % args.start_input
print "MossyFiber firing rate: %f" % args.mf_rate
# Set the build mode for pyNN before importing the simulator specific modules
ninemlp.pyNN_build_mode = args.build
exec("from ninemlp.%s import *" % args.simulator)
Golgi = ncml.load_cell_type('Golgi', golgi_xml_location) #@UndefinedVariable
g_pop1 = Population('Golgi1', 1, Golgi, params={}, build_mode=args.build_mode)#@UndefinedVariable
g_pop2 = Population('Golgi2', 1, Golgi, params={}, build_mode=args.build_mode)#@UndefinedVariable
proj = Projection(g_pop1, g_pop2, target='Gap')
g1 = Golgi()
g2 = Golgi()
# (TGC) Generated a "source variable" GID (NB: that this is completely separate 
# from the cell gid). 
#
# Warning! This implementation assumes that there is only one projection with 
# gap junctions, maybe a safe offset for each could be calculated when the 
# projections are read from the XML and passed to the projection constructor
synapse_object.g = weight
source_var_gid = int(source) * len(self.post) + int(target)
if source.local:
    simulator.state.parallel_context.source_var(source._cell.source_section(0.5)._ref_v, 
                                                                                    source_var_gid)
simulator.state.parallel_context.target_var(synapse_object._ref_vgap, source_var_gid)
from neuron import h
h.psection(sec=g1.soma)
## Build the network
#print "Building network"
#net = Network(network_xml_location, timestep=args.timestep, min_delay=args.min_delay, max_delay=2.0, #@UndefinedVariable
#                             build_mode=args.build, silent_build=args.silent_build, flags=flags)
print "Network description"
#net.describe()
#if args.save_connections:
#    print "Saving connections"
#    net.save_connections(args.save_connections)
#print "Setting up simulation"
#mossy_fiber_inputs = net.get_population('MossyFiberInputs')
#mossy_fiber_inputs.set_poisson_spikes(args.mf_rate, args.start_input, args.time)
#print "Setting up recorders"
#net.record_all_spikes(args.output_prefix)
## Set up voltage traces    
#if args.volt_trace:
#    cell = net.get_population(args.volt_trace[0])[int(args.volt_trace[1])]
#    record_v(cell, args.output_prefix + args.volt_trace[0] + "." + args.volt_trace[1] + ".v") #@UndefinedVariable
print "Starting run"
run(args.time) #@UndefinedVariable
end() #@UndefinedVariable
print "Simulated Fabio's Network for %f milliseconds" % args.time