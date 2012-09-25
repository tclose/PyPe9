#!/usr/bin/env python
"""
Compare two mechanisms (or sets of mechanisms) by plotting their different responses to  
arbitrary current injections. NB: The simulated activity from the 
second mechanism (set) will be interpolated to the time-scale of the first.

Author: Tom Close (tclose@oist.jp)
Created: 6/8/2012
"""

#Name of the script for the output directory and submitted mpi job
SCRIPT_NAME = 'mechanisms'

import tombo
import argparse

parser = argparse.ArgumentParser(description=__doc__)
parser = argparse.ArgumentParser(description='Compare two mechanisms by plotting the different response to an \
                                                    arbitrary current injection. NB: The simulated activity from the \
                                                    second mechanism will be interpolated to the time-scale of the first.')
parser.add_argument('mech_paths', nargs='+', metavar='MECH_NAMES', help="Mechanisms names to include in the test cell")
parser.add_argument('-r', '--reference', nargs='+', default=[], metavar='MECH_NAME', help="Mechanisms names to include in the reference test cell")
parser.add_argument('--celsius', type=float, default=30.0, help='The temperature at which to run the simulations')
parser.add_argument('--cm', type=float, default=1.0, help='Membrane capacitance (default: %(default)s)')
parser.add_argument('--Ra', type=float, default=100, help='Axial resistance (default: %(default)s)')
parser.add_argument('--length', type=float, default=11.8, help='Length of the compartment (default: %(default)s)')
parser.add_argument('--diam', type=float, default=11.8, help='Diameter of the compartment (default: %(default)s)')
parser.add_argument('--save_prefix', type=str, help='location to (optionally) save the recording')
parser.add_argument('--no_plot', action='store_true', help='Don''t plot the simulations')
parser.add_argument('--step', metavar='AMPLITUDE', help='Use a step input current rather than uniformly distributed current')
parser.add_argument('--no_input', action='store_true', help='Switch off the input into the cell')
parser.add_argument('--mean_input', type=float, default=0.01, help="Mean input value")
parser.add_argument('--stdev_input', type=float, default=0.0025, help="Standard deviation of the input value")
parser.add_argument('--start_input', type=float, default=1000, help='stimulation start time')
parser.add_argument('--end_time', type=float, default=2000, help='stimulation end time')
parser.add_argument('--input_dt', metavar='INPUT_TIMESTEP', type=float, default=1, help='time step between input changes')
parser.add_argument('--timestep', metavar='TIMESTEP', type=float, default=0.025, help='The timestep of the numerical simulation')
parser.add_argument('--simulator', type=str, nargs='+', metavar='SIMULATOR', default=['neuron'], help='Sets the simulator for the new nmodl path (either ''neuron'' or ''nest'', ''default %(default)s''')
parser.add_argument('--no_tables', action='store_true', help='Turn off tables')
parser.add_argument('--init_var', nargs=2, metavar=('VAR_NAME', 'INITIAL_VALUE'), action='append', default=[], help='Used to initialise reversal potentials and the like, eg. --init_var ek "-84.69" (NB: don''t forget to quote negative numbers)')
parser.add_argument('--output_dir', default=None, type=str, help='The parent directory in which the output directory will be created (defaults to $HOME/Output)')
parser.add_argument('--que_name', type=str, default='short', help='The the que to submit the job to(default: %(default)s)')
args = parser.parse_args()

required_dirs = ['src', 'external', 'xml']    

# Create work directory and get path for output directory
work_dir, output_dir = tombo.create_work_dir(SCRIPT_NAME, args.output_dir, required_dirs=required_dirs)

#Compile network
compile_args = ' '.join(args.mech_paths)
if args.reference:
  compile_args += ' --reference ' + ' '.join(args.reference)
tombo.compile_custom(SCRIPT_NAME, work_dir, script_args=compile_args)
# Set up command to run the script
cmd_line = \
"time mpirun python src/test/{script_name}.py {mech_paths} --celsius {celsius} \
--cm {cm} --Ra {Ra} --length {length} --diam {diam} --save_prefix {work_dir}/output/traces --no_plot \
--mean_input {mean_input} --stdev_input {stdev_input} --start_input {start_input} --end_time {end_time} \
--input_dt {input_dt} --build require \
--simulator {simulator} --timestep {timestep}".format(script_name=SCRIPT_NAME,
                                                        mech_paths=' '.join(args.mech_paths),
                                                        work_dir=work_dir,
                                                        celsius=args.celsius,
                                                        cm=args.cm,
                                                        Ra=args.Ra,
                                                        length=args.length,
                                                        diam=args.diam,
                                                        save_prefix=args.save_prefix,
                                                        no_plot=args.no_plot,
                                                        step=args.step,
                                                        no_input=args.no_input,
                                                        mean_input=args.mean_input,
                                                        stdev_input=args.stdev_input,
                                                        start_input=args.start_input,
                                                        end_time=args.end_time,
                                                        input_dt=args.input_dt,
                                                        simulator=' '.join(args.simulator),
                                                        timestep=args.timestep)
if args.reference:
    cmd_line += ' --reference ' + ' '.join(args.reference) 
for init_var in args.init_var:
    cmd_line += ' --init_var ' + init_var[0] + ' ' + init_var[1] 
if args.step:
    cmd_line += ' --step ' + args.step
if args.no_input:
    cmd_line += ' --no_input'
if args.no_tables:
    cmd_line += ' --no_tables'
copy_to_output= ['external', 'xml']
# Submit job to que
tombo.submit_job(SCRIPT_NAME, cmd_line, 1, work_dir, output_dir, copy_to_output=copy_to_output,
                                                                             que_name=args.que_name)
