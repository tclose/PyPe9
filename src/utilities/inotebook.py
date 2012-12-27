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
import re
import subprocess
from difflib import context_diff
from visualize.activity_plot import activity_plot #@UnusedImport
from collections import defaultdict, namedtuple

PROJECT_DIR = None

def inotebook_init(project_dir='/home/tclose/kbrain'):
    """
    Adds the source directory to the system path and changes the current working directory
    
    @param project_dir: The project dir for the notebeook
    """
    sys.modules[__name__].PROJECT_DIR = project_dir
    os.chdir(project_dir)
    sys.path.append(os.path.join(project_dir, 'src'))
    git_rev = subprocess.check_output('git rev-parse HEAD', shell=True)
    print "Using git revision of k-Brain: {git_rev}".format(git_rev=git_rev)

def diff(ref_file, new_file):
    """
    Performs a 'context diff' on the two files provided. Useful for comparing to scripts before
    comparing their output
    
    @param ref_file: The reference file
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
        f = open(save_output, 'w')
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

def compare_psections(psection_log, ref_psection_log=None):
    """
    Compares the values of two different hoc psection output strings (or two psections in the one string)
    
    @param psection [str]: a string containing a psection
    @param ref_psection [str]: a string containing a reference psection (if omitted two psections \
will be searched for in the first string
    """
    psection = open(psection_log).read()
    # If ref_psection not provided then look for two psections in the psection
    if not ref_psection_log:
        sections = re.split('(.*{ nseg)', psection)
        if len(sections) < 4:
            raise Exception ('Reference psection is not provided and only on psection found in string')
        psection = ''.join(sections[-4:-2])
        ref_psection = ''.join(sections[-2:])
    else:
        ref_psection = open(ref_psection_log).read()
    # The regular expression for picking out the name value pairs
    pattern = re.compile('([a-zA-Z0-9_]+=\-?[0-9]+(?:\.[0-9]+)*(?:e\-?[0-9]+)*)')
    # A dictionary that uses the values as a key to match the corresponding names
    vals_dict = defaultdict(lambda: (list(), list()))
    # Extract the name value pairs and add them to the values dictionary
    for run_i, psection_str, run_name in ((0, psection, 'NEW'), (1, ref_psection, 'REFERENCE')):
        name_vals= pattern.findall(psection_str)
        for name, val in [nv.split('=') for nv in name_vals]:
            vals_dict[val][run_i].append(name)
    if not len(vals_dict):
        raise Exception('No values read from psections')
    for val, name_lists in vals_dict.iteritems():
        print """
{val}       
---------
    Ref:
        {ref_names}
    New:
        {new_names}
""".format(val=val, ref_names=', '.join(name_lists[1]), new_names=', '.join(name_lists[0]))




if __name__ == '__main__':
    #    compare_psections('/home/tclose/kbrain/output/single_granule_cell.log', 
    #                      '/home/tclose/kbrain/output/ivans_generated_granule_hoc.log')
    test_str='insert ca_ion { cai=5e05 cao=2}'
    # The regular expression for picking out the name value pairs
    pattern = re.compile('([a-zA-Z_]+=[0-9]+(?:\.[0-9]+)*(?:e-?[0-9]+)*)')
    name_vals= pattern.findall(test_str)
    print test_str
    print name_vals
    





