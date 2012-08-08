#!/usr/bin/env python

####################################################################################################
# This script prepares the environment for the Sun Grid Engine batch script to run in by making a
# snapshot of the code base at the start of the run, generating a jobscript and sending it to the job que
#
# Author: Tom Close (tclose@oist.jp)
# Created: 6/8/2012
# 
####################################################################################################

import sys

if float(sys.version[0:3]) < 2.7:
    raise Exception("This script requires python version 2.7 or greater (try adding '/apps/python/272/bin' to your PATH variable if running on tombo)")

import os.path
import time
import shutil
import subprocess
import argparse

parser = argparse.ArgumentParser(description='A script to ')
parser.add_argument('--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('--mf_rate', type=float, default=1, help='Mean firing rate of the Mossy Fibres (default: %(default)s)')
parser.add_argument('--time', type=float, default=2000.0, help='The run time of the simulation (ms)  (default: %(default)s)')
parser.add_argument('--start_input', type=float, default=1000, help='The start time of the mossy fiber stimulation (default: %(default)s)')
parser.add_argument('--min_delay', type=float, default=0.002, help='The minimum synaptic delay in the network (default: %(default)s)')
parser.add_argument('--timestep', type=float, default=0.001, help='The timestep used for the simulation (default: %(default)s)')
parser.add_argument('--stim_seed', default=None, help='The seed passed to the stimulated spikes')
parser.add_argument('--num_processes', type=int, default=96, help='The the number of processes to use for the simulation (default: %(default)s)')
parser.add_argument('--legacy_hoc', action='store_true', help="If this flag is passed, then the old legacy code is run instead")
parser.add_argument('--username', type=str, default=None, help='The username with which to run the script with (specifies the appropriate folder in /work directory')
parser.add_argument('--debug', action='store_true', help='Loads a stripped down version of the network for easier debugging')
args = parser.parse_args()

np = args.num_processes

if not args.stim_seed:
    stim_seed = long(time.time() * 256)
else:
    stim_seed = int(args.stim_seed)
    
#Name of the script to run
SCRIPT_NAME = 'fabios_network'

# Set directory to copy files to when completed process
OUTPUT_PARENT_DIR = os.path.join(os.environ['HOME'], 'Output')

if args.username:
    username = args.username
else:
    username = os.getlogin()

DESCHUTTER_UNIT = ['tclose', 'mnegrello', 'raikov', 'dguo', 'shyamkumar']
DOYA_UNIT = ['otsuka','jun-y', 'shauno']

if username in DESCHUTTER_UNIT:
    unit_dir = 'DeschutterU'
elif username in DOYA_UNIT:
    unit_dir = 'DoyaU'
else:
    raise Exception("Unrecognised user '%s', please edit tombo/fabios_network.py to specifiy which unit they belong to")

# Automatically generate paths
time_str = time.strftime('%Y-%m-%d-%A_%H-%M-%S', time.localtime()) # Unique time for distinguishing runs
work_dir = os.path.join('/work', unit_dir, username, SCRIPT_NAME + "." + time_str + ".1") # Working directory path
project_dir = os.path.abspath(os.path.join(os.path.basename(__file__), '..')) # Root directory of the project code

#Ensure that working directory is unique
created_directory=False
count = 1
while not created_directory:
    try:
        created_directory = not os.makedirs(work_dir) 
    except IOError as e:
        count += 1
        if count > 1000:
            print "Something has gone wrong, can't create directory '%s' after 1000 attempts" % work_dir
            raise e
        work_dir = '.'.join(work_dir.split('.')[:-1] + [str(count)]) # Replace old count at the end of work directory with new count

output_dir = os.path.join(OUTPUT_PARENT_DIR, os.path.split(work_dir)[1])

# Copy snapshot of code directory and network description to working directory
DIRS_TO_COPY = ['src', 'xml']
if args.legacy_hoc:
    DIRS_TO_COPY.append('external_refs/fabios_network')
for directory in DIRS_TO_COPY:
    shutil.copytree(os.path.join(project_dir,directory), os.path.join(work_dir,directory), symlinks=True)
# Make output directory for the generated files
os.mkdir(os.path.join(work_dir,'output'))
# Save the git revision in the output folder for reference
subprocess.call('cd %s; git rev-parse HEAD > %s' % (project_dir, os.path.join(work_dir,'output', 'git_revision')), shell=True)

# Specify path variables
PATH ='/apps/python/272/bin:/apps/DeschutterU/NEURON-7.2/x86_64/bin:/opt/mpi/gnu/openmpi-1.4.3/bin'
PYTHONPATH = os.path.join(work_dir, 'src')
LD_LIBRARY_PATH = '/opt/mpi/gnu/openmpi-1.4.3/lib'
NINEMLP_SRC_PATH = os.path.join(work_dir, 'src')

print "Compiling required objects"

if not args.legacy_hoc:
    #Compile network
    compile_env = os.environ.copy()
    compile_env['PATH'] = PATH + os.pathsep + os.environ['PATH']
    compile_env['PYTHONPATH'] = PYTHONPATH
    compile_env['LD_LIBRARY_PATH '] = LD_LIBRARY_PATH 
    compile_env['NINEMLP_SRC_PATH'] = NINEMLP_SRC_PATH
    compile_env['NINEMLP_BUILD_MODE'] = 'compile_only'
    compile_env['NINEMLP_MPI'] = '1'   
    subprocess.check_call('python %s --build compile_only' % 
                                      os.path.join(work_dir,'src', 'test', SCRIPT_NAME + '.py'), 
                                                                       shell=True, env=compile_env)
    # Set up command line and working directory
    run_dir = os.path.join(work_dir, 'src')
    cmd_line = "time mpirun python test/{script_name}.py --output {work_dir}/output/ \
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
                                                                      stim_seed=stim_seed, np=np)
    if args.debug:
        cmd_line += " --debug"
else:
    run_dir = os.path.join(work_dir, 'external_refs/fabios_network')
    os.chdir(run_dir)
    subprocess.call('nrnivmodl', shell=True)
    cmd_line = "time mpirun nrniv network.hoc"

#Create jobscript
jobscript_path = os.path.join(work_dir, SCRIPT_NAME + '.job')
f = open(jobscript_path, 'w')
f.write("""#!/usr/bin/env sh

# Parse the job script using this shell
#$ -S /bin/bash

# Send stdout and stderr to the same file.
#$ -j y

# Standard output and standard error files
#$ -o {work_dir}/output_stream
#$ -e {work_dir}/output_stream

# Name of the queue
#$ -q longP

# use OpenMPI parallel environment with {np} processes
#$ -pe openmpi {np}

# Export the following env variables:
#$ -v HOME
#$ -v PATH
#$ -v PYTHONPATH
#$ -v LD_LIBRARY_PATH
#$ -v BREP_DEVEL
#$ -v PARAMDIR
#$ -v VERBOSE

###################################################
### Copy the model to all machines we are using ###
###################################################

# Set up the correct paths 
export PATH={path}:$PATH
export PYTHONPATH={pythonpath}
export LD_LIBRARY_PATH={ld_library_path}
export NINEMLP_SRC_PATH={ninemlp_src_path}
export NINEMLP_BUILD_MODE='lazy'
export NINEMLP_MPI=1

echo "==============Starting mpirun===============" 

cd {run_dir}
{cmd_line}

echo "==============Mpirun has ended===============" 

echo "Moving files to output directory '{output_dir}' and cleaning work directory" 

mv {work_dir}/output {output_dir}
mv {jobscript_path} {output_dir}/job
mv {work_dir}/output_stream {output_dir}/output
rm -r {work_dir}

echo "============== Done ===============" 

""".format(work_dir=work_dir, path=PATH, pythonpath=PYTHONPATH, 
  ld_library_path=LD_LIBRARY_PATH, ninemlp_src_path=NINEMLP_SRC_PATH, np=np, run_dir=run_dir, 
  cmd_line=cmd_line, output_dir=output_dir, 
  jobscript_path=jobscript_path))
f.close()

# Submit job
print "Submitting job %s" % jobscript_path
subprocess.call('qsub %s' % jobscript_path, shell=True)
print "While the job is running, its output stream can be viewed by:"
print "less " + os.path.join(work_dir, 'output_stream')
print "Once completed the output files (including the output stream and job script) of this job will be copied to:"
print output_dir
            
