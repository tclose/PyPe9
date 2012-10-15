#!/usr/bin/env python
"""
  This script creates and runs the simple gap junctions 

  @author Tom Close

"""
#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import os.path
if 'NINEMLP_MPI' in os.environ:
    import mpi4py #@UnresolvedImport @UnusedImport
    print "importing MPI"
import argparse
import ninemlp
import time
from operator import itemgetter
# Set the project path for use in default parameters of the arguments
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
# Parse the input options
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE,
                            help='Option to build the NMODL files before running (can be one of \
                            %s.' % ninemlp.BUILD_MODE_OPTIONS)
parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network')
parser.add_argument('--output', type=str, default=os.path.join(PROJECT_PATH, 'output'), help='The output location the files will be written to')
parser.add_argument('--timestep', type=float, default=0.001, help='The timestep used for the simulation')
parser.add_argument('--time', type=float, default=100.0, help='The run time of the simulation (ms)')
parser.add_argument('--input_rate', type=float, default=1, help='Mean firing rate of the Mossy Fibres')
parser.add_argument('--start_input', type=float, default=50, help='The start time of the mossy fiber stimulation')
parser.add_argument('--stim_seed', type=int, default=None, help='The seed passed to the stimulated spikes')
parser.add_argument('--para_unsafe', action='store_true', help='If set the network simulation will try to be parallel neuron safe')
parser.add_argument('--volt_trace', metavar=('POPULATION', 'INDEX'), nargs=2, default=[], help='Save voltage traces for the given list of ("population name", "cell ID") tuples')
parser.add_argument('--num_pairs', type=int, default=1, help='The number of golgi pairs to create')
parser.add_argument('--ggap', type=float, default=1e-10, help='Gap junction conductance')
parser.add_argument('--print_first', action='store_true', help='Print out the sections (via psection) of the first golgi cell')
parser.add_argument('--temperature', type=float, default=23.0, help='The temperature the experiment is simulated at')
args = parser.parse_args()
# Set the build mode for pyNN before importing the simulator specific modules
ninemlp.pyNN_build_mode = args.build
from ninemlp.neuron import * #@UnusedWildImport
# Set the network xml location
golgi_xml_location = os.path.join(PROJECT_PATH, 'xml', 'cerebellum', 'ncml', 'Golgi.xml')
# Set the stimulation random seed
if not args.stim_seed:
    stim_seed = long(time.time() * 256)
    print "Stimulation seed is %d" % stim_seed
else:
    stim_seed = int(args.stim_seed)
# Print out basic parameters of the simulation
setup(timestep=args.timestep, min_delay=args.min_delay, max_delay=4.0, quit_on_end=True)
print "Simulation time: %f" % args.time
print "Stimulation start: %f" % args.start_input
print "MossyFiber firing rate: %f" % args.input_rate
Golgi = ncml.load_cell_type('Golgi', golgi_xml_location)
golgi_pairs = []
source_var_gid = 0
for pair_i in xrange(args.num_pairs):
    pair = (Golgi(), Golgi())
    for i in (0, 1):
        source = pair[i]
        target = pair[(i + 1) % 2]
        gap_junction = pair[i].soma.Gap
        gap_junction.g = args.ggap
        simulator.state.parallel_context.target_var(target.soma.Gap._ref_vgap, source_var_gid)
        simulator.state.parallel_context.source_var(source.soma(0.5)._ref_v, source_var_gid)
        source_var_gid += 1
    golgi_pairs.append(pair)
first_golgi = golgi_pairs[0][0]
output_path=os.path.join(args.output, "first_golgi.v")
first_golgi.record('v', output_path) #@UndefinedVariable
if args.print_first:
    for seg_id, seg in sorted(first_golgi.segments.items(), key=itemgetter(0)):
        print "ID: {0}".format(seg_id)
        neuron.h.psection(sec=seg)
# Set simulation temperature
neuron.h.celsius = args.temperature
print "Starting run"
run(args.time) #@UndefinedVariable
end() #@UndefinedVariable
print "Simulated Sungho's gap junction test for {time} milliseconds, written to {output}".format(
                                                                 time=args.time, output=output_path)
