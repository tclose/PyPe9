#!/usr/bin/env python
"""
 This script prepares the environment for the simulate/fabios_network.py script on the Sun Grid 
 Engine batch script to run in by making a snapshot of the code base at the start of the run, 
 generating a jobscript and sending it to the job que

 Author: Tom Close (tclose@oist.jp)
 Created: 6/8/2012
"""

#Name of the script for the output directory and submitted mpi job
SCRIPT_NAME = 'single_cell'

import tombo
import argparse
import ninemlp

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('xml_filename', type=str, help='The name of the xml file to load the cells from.')
parser.add_argument('--solver', type=str, default='cvode', help="The solver used to simulate the cell models")
parser.add_argument('--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE,
                            help='Option to build the NMODL files before running (can be one of \
                            %s.' % ninemlp.BUILD_MODE_OPTIONS)
parser.add_argument('--time', type=float, default=25.0, help='The run time of the simulation (ms)')
parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network')
parser.add_argument('--timestep', type=float, default=0.001, help='The timestep used for the simulation')
parser.add_argument('--output_dir', default=None, type=str, help='The parent directory in which the output directory will be created (defaults to $HOME/Output)')
parser.add_argument('--np', type=int, default=1, help='The the number of processes to use for the simulation (default: %(default)s)')
parser.add_argument('--que_name', type=str, default='short', help='The the que to submit the job to(default: %(default)s)')
args = parser.parse_args()

required_dirs = ['src', 'xml']    

# Create work directory and get path for output directory
work_dir, output_dir = tombo.create_work_dir(SCRIPT_NAME, args.output_dir, required_dirs=required_dirs)

#Compile network
tombo.compile_ninemlp(SCRIPT_NAME, work_dir, script_dir='test', script_args=args.xml_filename,
                      simulator=args.simulator)
# Set up command to run the script
cmd_line = \
"time mpirun python src/test/{script_name}.py {xml_filename} --output {work_dir}/output/ --time {time}  \
 --min_delay {min_delay} --simulator {simulator} --timestep {timestep}".format(script_name=SCRIPT_NAME,
                                                                              xml_filename=args.xml_filename,
                                                                              work_dir=work_dir,
                                                                              time=args.time,
                                                                              min_delay=args.min_delay,
                                                                              simulator=args.simulator,
                                                                              timestep=args.timestep)
copy_to_output= ['xml']
# Submit job to que
tombo.submit_job(SCRIPT_NAME, cmd_line, args.np, work_dir, output_dir, copy_to_output=copy_to_output, que_name=args.que_name)
