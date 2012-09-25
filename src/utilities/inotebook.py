"""

    This module contains methods to initiate and plot simulations for both NEURON and NEST

    
    @author Tom Close
    @date 21/9/2012

"""

#######################################################################################
#
#        Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

import sys
import os.path #@UnusedImport
import subprocess
from difflib import context_diff
from visualize.activity_plot import activity_plot #@UnusedImport

PROJECT_DIR = None

def inotebook_init(project_dir='/home/tclose/kbrain'):
    """
    Adds the source directory to the system path and changes the current working directory
    
    @param project_dir: The project dir for the notebeook
    """
    sys.modules[__name__].PROJECT_DIR=project_dir
    os.chdir(project_dir)
    sys.path.append(os.path.join(project_dir, 'src'))
    git_rev = subprocess.check_output('git rev-parse HEAD', shell=True)
    print "Using git revision of k-Brain: {git_rev}".format(git_rev=git_rev)

def diff(ref_file, new_file):
    """
    Performs a 'context diff' on the two files provided. Useful for comparing to scripts before
    comparing their output
    
    @param file1: The reference file
    @param new_file: The file to compare agains the reference
    """
    ref_file_contents = open(ref_file).readlines()
    new_file_contents = open(new_file).readlines()
    for line in context_diff(ref_file_contents, new_file_contents):
        sys.stdout.write(line)
        
def bash(cmd, silent=False, save_output=None):
    """
    Runs a command in subprocess in a bash shell and returns the output along with the stderr even
    if there is an exception thrown
    
    @param cmd: The command string to be run in bash
    """
    try:
        output = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        output = 'Return Code: {0}\n{1}'.format(e.returncode, e.output)
        silent = False
    if not silent:
        print output
    if save_output:
        f = open(save_output,'w')
        f.write(output)
        f.close()
    
def clear_output_dir(*files):
    if not len(files):
        print "No files provided, clearing all files in output directory"
        files = os.listdir('output')
    for f in files:
        try:
            os.remove(os.path.join(PROJECT_DIR, 'output', f))
            print "Removed {file} from output directory".format(file=f)
        except OSError:
            pass
    print ""
    print "-----------------------------------"        
    print "Remaining files in output directory"
    print "-----------------------------------"
    print '\n'.join(os.listdir(os.path.join(PROJECT_DIR, 'output')))
    print "-----------------------------------"    
    
if __name__ == "__main__":
    bash(' '.join(sys.argv[1:]))