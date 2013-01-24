#!/usr/bin/env python
"""
 This script prepares the environment for the simulate/fabios_network.py script on the Sun Grid 
 Engine batch script to run in by making a snapshot of the code base at the start of the run, 
 generating a jobscript and sending it to the job que

 Author: Tom Close (tclose@oist.jp)
 Created: 6/8/2012
"""
import tombo
import argparse
# Parse input arguments
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output_dir', default=None, type=str, help='The parent directory in which the output directory will be created (defaults to $HOME/Output)')
parser.add_argument('--np', type=int, default=1, help='The the number of processes to use for the simulation (default: %(default)s)')
parser.add_argument('--que_name', type=str, default='short', help='The the que to submit the job to(default: %(default)s)')
parser.add_argument('--mwe', action='store_true', help='Use the MWE instead')
args = parser.parse_args()
if args.mwe:
    script_name='gap_mwe'
else:
    script_name='gap_test'
# Create work directory and get path for output directory
required_dirs = ['src', 'xml']    
work_dir, output_dir = tombo.create_work_dir(script_name, args.output_dir, required_dirs=required_dirs)
# Set gap mechanism dir as a script arg if required
if args.mwe:
    script_args = ' --gap_mechanism_dir {work_dir}/src/pyNN/neuron/nmodl'.format(work_dir=work_dir)
else:
    script_args = ''      
#Compile network
tombo.compile_ninemlp(script_name, work_dir, script_dir='test', script_args=script_args)
# Set up command to run the script
cmd_line = "time mpirun python src/test/{script_name}.py --output {work_dir}/output/ " \
           "--build require {script_args}".format(script_name=script_name, work_dir=work_dir,
                                       script_args=script_args)
copy_to_output= ['xml']
# Submit job to que
tombo.submit_job(script_name, cmd_line, args.np, work_dir, output_dir, 
                 copy_to_output=copy_to_output, que_name=args.que_name)
