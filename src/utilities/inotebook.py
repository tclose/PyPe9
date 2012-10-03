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

def compare_psections(psection_str, ref_psection_str=None):
    """
    Compares the values of two different hoc psection output strings (or two psections in the one string)
    
    @param psection [str]: a string containing a psection
    @param ref_psection [str]: a string containing a reference psection (if omitted two psections \
will be searched for in the first string
    """
    PSECTION_REGEX="""\n.*{([^}]*\n)*(.*{[^}]*}\n)+([^}]*\n)*.*}"""
    psections = re.findall(PSECTION_REGEX, psection_str)
    if not psections:
        raise Exception("psection output was not found in psection string '{}'".format(psection_str))
    if ref_psection_str:
        psections += re.findall(PSECTION_REGEX, ref_psection_str)
    if len(psections) != 2:
        raise Exception("Two psections required, {} found:\n\n{}'".format(len(psections), psections))
    for name, psection in zip(('ref', 'new'), psections):
        key_vals = re.findall('a', psection)
        print '\n'.join(key_vals)

if __name__ == "__main__":
    psection_str = """
ggaba_GRC_LKG2 = 3e-05
gnabar_GRC_NA = 0.013
beta_GRC_CALC = 1.5
Starting simulation of 'new'...
Simulating at 30.000000C
Finished simulation of 'new'
Description of new cell:
<__main__.NeuronTestCell object at 0x2391a10>.PySec_396ccc0 { nseg=1  L=11.8  Ra=100
    /*location 0 attached to cell 0*/
    /* First segment only */
    insert morphology { diam=11.8}
    insert capacitance { cm=1}
    insert CGC_Ca {}
    insert CGC_CaHVA { comp210_vcbdur_CGC_CaHVA=100 comp210_vcsteps_CGC_CaHVA=8 comp210_vchold_CGC_CaHVA=-71 comp210_vcbase_CGC_CaHVA=-69 comp210_vcinc_CGC_CaHVA=10 comp295_gbar_CGC_CaHVA=0.00046 comp210_vchdur_CGC_CaHVA=30 comp295_e_CGC_CaHVA=129.33}
    insert CGC_KA { comp685_vcbase_CGC_KA=-69 comp685_vcsteps_CGC_KA=8 comp685_vchold_CGC_KA=-71 comp685_vcbdur_CGC_KA=100 comp770_gbar_CGC_KA=0.004 comp685_vcinc_CGC_KA=10 comp685_vchdur_CGC_KA=30 comp770_e_CGC_KA=-84.69}
    insert CGC_KCa { comp1301_gbar_CGC_KCa=0.003 comp1216_vchdur_CGC_KCa=30 comp1216_vcbdur_CGC_KCa=100 comp1216_vcbase_CGC_KCa=-69 comp1216_vchold_CGC_KCa=-71 comp1301_e_CGC_KCa=-84.69 comp1216_vcinc_CGC_KCa=10 comp1216_vcsteps_CGC_KCa=8}
    insert ca_ion {}
    insert CGC_KM { comp1913_vcsteps_CGC_KM=8 comp1913_vcbdur_CGC_KM=100 comp1998_e_CGC_KM=-84.69 comp1913_vchold_CGC_KM=-71 comp1913_vchdur_CGC_KM=30 comp1913_vcbase_CGC_KM=-69 comp1998_gbar_CGC_KM=0.00035 comp1913_vcinc_CGC_KM=10}
    insert CGC_KV { comp2288_vchdur_CGC_KV=30 comp2373_e_CGC_KV=-84.69 comp2288_vchold_CGC_KV=-71 comp2373_gbar_CGC_KV=0.003 comp2288_vcbase_CGC_KV=-69 comp2288_vcinc_CGC_KV=10 comp2288_vcbdur_CGC_KV=100 comp2288_vcsteps_CGC_KV=8}
    insert CGC_Kir { comp1651_e_CGC_Kir=-84.69 comp1566_vchold_CGC_Kir=-71 comp1566_vcsteps_CGC_Kir=8 comp1651_gbar_CGC_Kir=0.0009 comp1566_vcinc_CGC_Kir=10 comp1566_vcbdur_CGC_Kir=100 comp1566_vcbase_CGC_Kir=-69 comp1566_vchdur_CGC_Kir=30}
    insert k_ion { ek=-84.69}
    insert CGC_Lkg1 { comp2635_gbar_CGC_Lkg1=5.68e-05 comp2635_e_CGC_Lkg1=-16.5}
    insert CGC_Lkg2 { comp2726_ggaba_CGC_Lkg2=3e-05 comp2726_egaba_CGC_Lkg2=-65}
    insert CGC_Na { comp2902_gbar_CGC_Na=0.013 comp2817_vcsteps_CGC_Na=9 comp2817_vchold_CGC_Na=-71 comp2817_vchdur_CGC_Na=30 comp2817_vcbase_CGC_Na=-60 comp2817_vcinc_CGC_Na=10 comp2817_vcbdur_CGC_Na=100 comp2902_e_CGC_Na=87.39}
    insert na_ion { ena=87.39}
    insert IClamp { del=1000 dur=1999 amp=0.01875}
}
MPI_Initialized==false, disabling MPI functionality.
Creating ref cell...
ena = 87.39
ek = -84.69
eca = 129.33
gcabar_GRC_CA = 0.00046
gkbar_GRC_KCA = 0.04
gkbar_GRC_KV = 0.003
gkbar_GRC_KA = 0.0032
gkbar_GRC_KM = 0.00025
gkbar_GRC_KIR = 0.0009
gl_GRC_LKG1 = 5.68e-5
ggaba_GRC_LKG2 = 3e-05
gnabar_GRC_NA = 0.013
beta_GRC_CALC = 1.5
Starting simulation of 'ref'...
Simulating at 30.000000C
Finished simulation of 'ref'
Description of ref cell:
<__main__.NeuronTestCell object at 0x2391ad0>.PySec_396cb40 { nseg=1  L=11.8  Ra=100
    /*location 0 attached to cell 1*/
    /* First segment only */
    insert morphology { diam=11.8}
    insert capacitance { cm=1}
    insert GRC_CA { Aalpha_s_GRC_CA=0.04944 Kalpha_s_GRC_CA=15.873 V0alpha_s_GRC_CA=-29.06 Abeta_s_GRC_CA=0.08298 Kbeta_s_GRC_CA=-25.641 V0beta_s_GRC_CA=-18.66 Aalpha_u_GRC_CA=0.0013 Kalpha_u_GRC_CA=-18.183 V0alpha_u_GRC_CA=-48 Abeta_u_GRC_CA=0.0013 Kbeta_u_GRC_CA=83.33 V0beta_u_GRC_CA=-48 gcabar_GRC_CA=0.00046}
    insert GRC_CALC { d_GRC_CALC=0.2 cai0_GRC_CALC=0.0001 beta_GRC_CALC=1.5}
    insert GRC_KA { Aalpha_a_GRC_KA=0.8147 Kalpha_a_GRC_KA=-23.3271 V0alpha_a_GRC_KA=-9.17203 Abeta_a_GRC_KA=0.1655 Kbeta_a_GRC_KA=19.4718 V0beta_a_GRC_KA=-18.2791 Aalpha_b_GRC_KA=0.0368 Kalpha_b_GRC_KA=12.8433 V0alpha_b_GRC_KA=-111.332 Abeta_b_GRC_KA=0.0345 Kbeta_b_GRC_KA=-8.90123 V0beta_b_GRC_KA=-49.9537 V0_ainf_GRC_KA=-38 K_ainf_GRC_KA=-17 V0_binf_GRC_KA=-78.8 K_binf_GRC_KA=8.4 gkbar_GRC_KA=0.0032}
    insert GRC_KCA { Aalpha_c_GRC_KCA=2.5 Balpha_c_GRC_KCA=0.0015 Kalpha_c_GRC_KCA=-11.765 Abeta_c_GRC_KCA=1.5 Bbeta_c_GRC_KCA=0.00015 Kbeta_c_GRC_KCA=-11.765 gkbar_GRC_KCA=0.04}
    insert ca_ion {}
    insert GRC_KIR { Aalpha_d_GRC_KIR=0.13289 Kalpha_d_GRC_KIR=-24.3902 V0alpha_d_GRC_KIR=-83.94 Abeta_d_GRC_KIR=0.16994 Kbeta_d_GRC_KIR=35.714 V0beta_d_GRC_KIR=-83.94 gkbar_GRC_KIR=0.0009}
    insert GRC_KM { Aalpha_n_GRC_KM=0.0033 Kalpha_n_GRC_KM=40 V0alpha_n_GRC_KM=-30 Abeta_n_GRC_KM=0.0033 Kbeta_n_GRC_KM=-20 V0beta_n_GRC_KM=-30 V0_ninf_GRC_KM=-35 B_ninf_GRC_KM=6 gkbar_GRC_KM=0.00025}
    insert GRC_KV { Aalpha_n_GRC_KV=-0.01 Kalpha_n_GRC_KV=-10 V0alpha_n_GRC_KV=-25 Abeta_n_GRC_KV=0.125 Kbeta_n_GRC_KV=-80 V0beta_n_GRC_KV=-35 gkbar_GRC_KV=0.003}
    insert k_ion { ek=-84.69}
    insert GRC_LKG1 { gl_GRC_LKG1=5.68e-05 el_GRC_LKG1=-16.5}
    insert GRC_LKG2 { ggaba_GRC_LKG2=3e-05 egaba_GRC_LKG2=-65}
    insert GRC_NA { gnabar_GRC_NA=0.013 Aalfa_GRC_NA=353.91 Valfa_GRC_NA=13.99 Abeta_GRC_NA=1.272 Vbeta_GRC_NA=13.99 Agamma_GRC_NA=150 Adelta_GRC_NA=40 Aepsilon_GRC_NA=1.75 Ateta_GRC_NA=0.0201 Vteta_GRC_NA=25 ACon_GRC_NA=0.005 ACoff_GRC_NA=0.5 AOon_GRC_NA=0.75 AOoff_GRC_NA=0.005 n1_GRC_NA=5.422 n2_GRC_NA=3.279 n3_GRC_NA=1.83 n4_GRC_NA=0.738}
    insert na_ion { ena=87.39}
    insert IClamp { del=1000 dur=1999 amp=0.01875}
}
"""
    compare_psections(psection_str)









