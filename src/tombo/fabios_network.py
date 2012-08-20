#!/usr/bin/env python
"""
 This script prepares the environment for the simulate/fabios_network.py script on the Sun Grid 
 Engine batch script to run in by making a snapshot of the code base at the start of the run, 
 generating a jobscript and sending it to the job que

 Author: Tom Close (tclose@oist.jp)
 Created: 6/8/2012
"""

#Name of the script for the output directory and submitted mpi job
SCRIPT_NAME = 'fabios_network'

from tombo import * #@UnusedWildImport
import argparse

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--mf_rate', type=float, default=1, help='Mean firing rate of the Mossy Fibres (default: %(default)s)')
parser.add_argument('--time', type=float, default=2000.0, help='The run time of the simulation (ms)  (default: %(default)s)')
parser.add_argument('--start_input', type=float, default=1000, help='The start time of the mossy fiber stimulation (default: %(default)s)')
parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network (default: %(default)s)')
parser.add_argument('--timestep', type=float, default=0.001, help='The time step used for the simulation (default: %(default)s)')
parser.add_argument('--stim_seed', default=None, help='The seed passed to the stimulated spikes (defaults to time stamp)')
parser.add_argument('--np', type=int, default=96, help='The the number of processes to use for the simulation (default: %(default)s)')
parser.add_argument('--legacy_hoc', action='store_true', help="If this flag is passed, then the old legacy code is run instead")
parser.add_argument('--username', type=str, default=None, help='The username with which to run the script with to specify the appropriate folder in /work directory (defaults to user login)')
parser.add_argument('--debug', action='store_true', help='Loads a stripped down version of the network for easier debugging')
parser.add_argument('--output_parent', default=None, type=str, help='The output parent directory in which the output directory will be created (defaults to $HOME/Output)')
args = parser.parse_args()

# Create work directory and get path for output directory
work_dir, output_dir = create_work_dir(SCRIPT_NAME, args.output_parent, args.username)

#Compile network
compile_ninemlp(SCRIPT_NAME, work_dir)

# Set command line that runs the simulation script
cmd_line = "python src/simulate/{script_name}.py --output {work_dir}/output/ \
--time {time}  --start_input {start_input} --mf_rate {mf_rate} --min_delay {min_delay} \
--simulator {simulator} --timestep {timestep} --stim_seed {stim_seed}".format(
                                                                  script_name=SCRIPT_NAME,
                                                                  work_dir=work_dir,
                                                                  mf_rate=args.mf_rate,
                                                                  start_input=args.start_input,
                                                                  time=args.time,
                                                                  min_delay=args.min_delay,
                                                                  simulator=args.simulator,
                                                                  timestep=args.timestep,
                                                                  stim_seed=create_seed(args.stim_seed))
if args.debug:
    cmd_line += " --debug"

# Submit job to que
submit_job(SCRIPT_NAME, cmd_line, args.np, work_dir, output_dir)