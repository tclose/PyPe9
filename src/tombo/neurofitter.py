#!/usr/bin/env python
"""
 This script prepares the environment and input scripts for "Neurofitter", a tool to run 
 optimizations over neuron parameters.

 Author: Tom Close (tclose@oist.jp)
 Created: 15/1/2013
"""
import tombo
import argparse
SCRIPT_NAME = 'neurofitter'
# Parse input arguments
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output_dir', default=None, type=str,
                    help="The parent directory in which the output directory will be created "
                         "(defaults to $HOME/Output)")
parser.add_argument('--np', type=int, default=1,
                    help="The the number of processes to use for the simulation "
                         "(default: %(default)s)")
parser.add_argument('--que_name', type=str, default='short',
                    help="The the que to submit the job to(default: %(default)s)")
args = parser.parse_args()
# Create work directory and get path for output directory
required_dirs = []
work_dir, output_dir = tombo.create_work_dir(SCRIPT_NAME, args.output_dir,
                                             required_dirs=required_dirs)
#Compile network
tombo.compile_ninemlp(SCRIPT_NAME, work_dir, script_dir='test', simulator=args.simulator)
# Set up command to run the script
cmd_line = "time mpirun python src/test/{script_name}.py --output {work_dir}/output/ " \
           "--build require".format(script_name=SCRIPT_NAME, work_dir=work_dir)
copy_to_output = []
# Submit job to que
tombo.submit_job(SCRIPT_NAME, cmd_line, args.np, work_dir, output_dir,
                 copy_to_output=copy_to_output, que_name=args.que_name)
