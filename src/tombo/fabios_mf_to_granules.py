#!/usr/bin/env python
"""
 This script prepares the environment for the simulate/fabios_network.py script on the Sun Grid 
 Engine batch script to run in by making a snapshot of the code base at the start of the run, 
 generating a jobscript and sending it to the job que

 Author: Tom Close (tclose@oist.jp)
 Created: 6/8/2012
"""
#Name of the script for the output directory and submitted mpi job
SCRIPT_NAME = 'fabios_mf_to_granules'
# Required imports
import tombo
import argparse
import os.path
from ninemlp import create_seeds
# Arguments to the script
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--simulator', type=str, default='neuron',
                    help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--mf_rate', type=float, default=5, 
                    help='Mean firing rate of the Mossy Fibres (default: %(default)s)')
parser.add_argument('--time', type=float, default=2000.0, 
                    help='The run time of the simulation (ms)  (default: %(default)s)')
parser.add_argument('--start_input', type=float, default=1000, 
                    help='The start time of the mossy fiber stimulation (default: %(default)s)')
parser.add_argument('--min_delay', type=float, default=0.020001, 
                    help='The minimum synaptic delay in the network (default: %(default)s)')
parser.add_argument('--timestep', type=float, default=0.02, 
                    help='The time step used for the simulation (default: %(default)s)')
parser.add_argument('--net_seed', help="The random seed used to generate the stochastic parts of "
                    "the network", type=int, default=None) 
parser.add_argument('--stim_seed', help="The random seed used to generate the stimulation spike "
                                        "train.", type=int, default=None)
parser.add_argument('--inconsistent_seeds', action='store_true',
                    help="Instead of a constant seed being used for each process a different seed "
                         "on each process, which is required if only minimum number of generated "
                         "random numbers are generated on each node, instead of the whole set. This "
                         "means the simulation will be dependent on not just the provided seeds but "
                         "also the number of processes used, but otherwise shouldn't have any "
                         "detrimental effects")
parser.add_argument('--save_connections', type=str, default=None, 
                    help="A path in which to save the generated connections")
parser.add_argument('--np', type=int, default=96, 
                    help="The the number of processes to use for the simulation " \
                         "(default: %(default)s)")
parser.add_argument('--que_name', type=str, default='short', 
                    help='The the que to submit the job to(default: %(default)s)')
parser.add_argument('--volt_trace', nargs='+', action='append', default=[], 
                    metavar=('POP_ID', 'SLICE_INDICES'), 
                    help="The population label and cell ID of a cell to record its voltage trace")
parser.add_argument('--output_dir', default=None, type=str, 
                    help='The parent directory in which the output directory will be created ' \
                         '(defaults to $HOME/Output)')
parser.add_argument('--dry_run', action='store_true', help="Runs the script but doesn't actually "
                                                           "submit the job")
parser.add_argument('--keep_build', action='store_true', help="Don't delete the build directory to "
                                                             "allow the script to be rerun")
parser.add_argument('--log', action='store_true', help='Save logging information to file')
parser.add_argument('--max_memory', type=str, default='2G', 
                    help="The maximum memory allocated to run the network (when tested the neuron "
                         "version required 1~1.5Gb and the NEST version ~500Mb so 2G is set as the "
                         "safe default")
parser.add_argument('--name', type=str, default=None, 
                    help="Saves a file within the output directory with the name 'name' for easy "
                         "renaming of the output directory after it is copied to its final "
                         "destination, via the command 'mv <output_dir> `cat <output_dir>/name`'")
args = parser.parse_args()
# Set the required directories to copy to the work directory depending on whether the legacy hoc 
# code is used or not
required_dirs = ['src', 'xml']
# Create work directory and get path for output directory
work_dir, output_dir = tombo.create_work_dir(SCRIPT_NAME, args.output_dir, 
                                             required_dirs=required_dirs)
#Compile network
tombo.compile_ninemlp(SCRIPT_NAME, work_dir, simulator=args.simulator, script_dir='test')
net_seed, stim_seed = create_seeds((args.net_seed, args.stim_seed))
# Set up command to run the script
cmd_line = "time mpirun python src/test/{script_name}.py --output {work_dir}/output/ " \
           "--time {args.time} --start_input {args.start_input} --mf_rate {args.mf_rate} " \
           "--min_delay {args.min_delay} --simulator {args.simulator} --timestep {args.timestep} " \
           "--net_seed {net_seed} --stim_seed {stim_seed} --build require"\
           .format(script_name=SCRIPT_NAME, work_dir=work_dir, args=args, net_seed=net_seed, 
                   stim_seed=stim_seed)
for volt_trace in args.volt_trace:
    cmd_line += " --volt_trace"
    for arg in volt_trace:
        cmd_line += " "  + str(arg)
if args.save_connections:
    connections_dir = os.path.join(work_dir, 'output', args.save_connections)
    os.mkdir(connections_dir)
    cmd_line += ' --save_connections {}'.format(connections_dir)
if args.inconsistent_seeds:
    cmd_line += ' --inconsistent_seeds'
if args.log:
    cmd_line += ' --log {}/output/pyNN.log'.format(work_dir)
copy_to_output = ['xml']
# Submit job to que
if not args.dry_run:
    tombo.submit_job(SCRIPT_NAME, cmd_line, args.np, work_dir, output_dir, 
                     copy_to_output=copy_to_output, que_name=args.que_name, 
                     strip_build_from_copy=(not args.keep_build), name=args.name,
                     max_memory=args.max_memory, virtual_memory=args.max_memory)
