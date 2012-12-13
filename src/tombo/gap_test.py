#!/usr/bin/env python
"""
 This script prepares the environment for the simulate/fabios_network.py script on the Sun Grid 
 Engine batch script to run in by making a snapshot of the code base at the start of the run, 
 generating a jobscript and sending it to the job que

 Author: Tom Close (tclose@oist.jp)
 Created: 6/8/2012
"""

#Name of the script for the output directory and submitted mpi job
SCRIPT_NAME = 'gap_test'

import tombo
import argparse

parser = argparse.ArgumentParser(description=__doc__)
#parser.add_argument('--time', type=float, default=25.0, help='The run time of the simulation (ms)')
#parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network')
#parser.add_argument('--timestep', type=float, default=0.001, help='The timestep used for the simulation')
parser.add_argument('--output_dir', default=None, type=str, help='The parent directory in which the output directory will be created (defaults to $HOME/Output)')
parser.add_argument('--np', type=int, default=1, help='The the number of processes to use for the simulation (default: %(default)s)')
parser.add_argument('--que_name', type=str, default='short', help='The the que to submit the job to(default: %(default)s)')
args = parser.parse_args()

required_dirs = ['src', 'xml']    

# Create work directory and get path for output directory
work_dir, output_dir = tombo.create_work_dir(SCRIPT_NAME, args.output_dir, required_dirs=required_dirs)

#Compile network
tombo.compile_ninemlp(SCRIPT_NAME, work_dir, script_dir='test')
# Set up command to run the script
cmd_line = "time mpirun python src/test/{script_name}.py --output {work_dir}/output/ " \
           "--build require".format(script_name=SCRIPT_NAME, work_dir=work_dir)
copy_to_output= ['xml']
# Submit job to que
tombo.submit_job(SCRIPT_NAME, cmd_line, args.np, work_dir, output_dir, 
                 copy_to_output=copy_to_output, que_name=args.que_name)
