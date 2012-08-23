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

import tombo
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
parser.add_argument('--volt_trace', nargs=2, default=None, help="The population label and cell ID of a cell to record its voltage trace")
parser.add_argument('--debug', action='store_true', help='Loads a stripped down version of the network for easier debugging')
parser.add_argument('--output_dir', default=None, type=str, help='The parent directory in which the output directory will be created (defaults to $HOME/Output)')
parser.add_argument('--legacy_hoc', action="store_true", help="Run fabios original hoc model instead of the pyNN version")
args = parser.parse_args()

if args.legacy_hoc:
    required_dirs  = ['external_refs']
else:
    required_dirs = ['src', 'xml']    

# Create work directory and get path for output directory
work_dir, output_dir = tombo.create_work_dir(SCRIPT_NAME, args.output_dir, required_dirs=required_dirs)

if args.legacy_hoc:
    import subprocess
    import os.path
    os.chdir(os.path.join(tombo.get_project_dir(), 'external_refs','fabios_network'))
    subprocess.check_call('nrnivmodl', shell=True)
    cmd_line = \
"""
cd external_refs/fabios_network
nrniv mosinit.hoc
"""
    copy_to_output = []
else:
    #Compile network
    tombo.compile_ninemlp(SCRIPT_NAME, work_dir)
    # Set up command to run the script
    cmd_line = \
"time mpirun python src/simulate/{script_name}.py --output {work_dir}/output/ --time {time}  \
--start_input {start_input} --mf_rate {mf_rate} --min_delay {min_delay} --simulator {simulator} \
--timestep {timestep} --stim_seed {stim_seed}".format(script_name=SCRIPT_NAME,
                                                      work_dir=work_dir,
                                                      mf_rate=args.mf_rate,
                                                      start_input=args.start_input,
                                                      time=args.time,
                                                      min_delay=args.min_delay,
                                                      simulator=args.simulator,
                                                      timestep=args.timestep,
                                                      stim_seed=tombo.create_seed(args.stim_seed))
    if args.debug:
        cmd_line += " --debug"
    if args.volt_trace:
        cmd_line += " --volt_trace {volt_pop} {volt_cellid}".format(volt_pop=args.volt_trace[0], 
                                                                    volt_cellid=args.volt_trace[1])
    copy_to_output= ['xml']
                                                                  
# Submit job to que
tombo.submit_job(SCRIPT_NAME, cmd_line, args.np, work_dir, output_dir, copy_to_output=copy_to_output)
