"""

  This script performs a comparison between the performance of networks specified with NINEML+ and
  the legacy hoc code.

  @file comparison.py
  @author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import sys
import os
dir(os)
if 'NINEMLP_MPI' in os.environ:
    import mpi4py #@UnresolvedImport @UnusedImport
    print "importing MPI"
import os.path
from ninemlp import SRC_PATH
project_dir = os.path.join(SRC_PATH, '..')
sys.path.append(os.path.join(project_dir, 'Molecular_Layer'))
from backports import argparse
import time
import ninemlp.utilities.nmodl as nmodl
from ninemlp import BUILD_MODE, BUILD_MODE_OPTIONS
import subprocess

DEFAULT_NINEMLP_TEST = './NINEMLP/test.xml'
DEFAULT_HOC_TEST = './Molecular_Layer/tests/set5'

parser = argparse.ArgumentParser(description='A script to ')
parser.add_argument('-m', '--method', type=str, help="The method (either 'ninemlp'+ or 'hoc')")
parser.add_argument('-t', '--test', type=str, help='The location of the test network (the \
                                               NetworkXML file for NINEML+ and the main.py for Hoc')
parser.add_argument('-s', '--simulator', type=str, default='neuron',
                                           help="simulator for NINEML+ (either 'neuron' or 'nest')")
parser.add_argument('-b', '--build', type=str, default=BUILD_MODE,
                            help='Option to build the NMODL files before running (can be one of \
                            %s.' % BUILD_MODE_OPTIONS)
args = parser.parse_args()


#--------------#
# NINEML+ Code #
#--------------#

if args.method == 'ninemlp':

    if args.simulator == 'neuron':
        from ninemlp.neuron import Network #@UnusedImport
    elif args.simulator == 'nest':
        from ninemlp.nest import Network
    else:
        raise Exception("Unrecognised simulator '%s', valid simulators are 'neuron' and 'nest'")

    if args.test:
        test_loc = args.test
    else:
        test_loc = os.path.join(project_dir, DEFAULT_NINEMLP_TEST)

    start_ninemlp = time.clock()
    net = Network(test_loc, build_mode=args.build)
    elapsed_ninemlp = time.clock() - start_ninemlp

    print "Time for NINEMLP: %f" % elapsed_ninemlp

#----------#
# Hoc Code #
#----------#

elif args.method == 'hoc':

    if args.simulator != 'neuron':
        raise Exception ("Must run NEURON simulation from Hoc code.")

    import main as ml_main


    for mech in ml_main.mechanisms:
        nmodl.build(os.path.join(project_dir, 'Molecular_Layer', 'mechanisms', mech),
                                                                          build_mode=args.build)

    if args.build == 'compile_only':
        print "The '--build' option was specified as 'compile_only' so the network was not \
                                                     constructed, only NMODL files were compiled."
        sys.exit()

    if args.test:
        test_loc = args.test
    else:
        test_loc = os.path.join(project_dir, DEFAULT_HOC_TEST)

    start_hoc = time.clock()
    if args.build == 'compile_only':
        ml_main.init(ml_main.get_nrn_home(), ml_main.get_nrn_arch(), paramdir=test_loc,
                       include_pops=['granule', 'purkinje'],
                       working_dir=os.path.join(project_dir, 'Molecular_Layer'), verbose=True)
    else:
        # Get the path of the nrniv command (must be on the system path)
        nrniv_path = None
        for d in str.split(os.environ['PATH'], os.pathsep):
            potential_path = os.path.join(d, 'nrniv')
            if os.path.exists(potential_path):
                nrniv_path = potential_path
        if not nrniv_path:
            raise Exception ("'nrniv' was not found on the system path '%s'" % sys.path)
        # Change to the Molecular_Layer directory        
        orig_dir = os.getcwd()
        os.chdir(os.path.join(project_dir, 'Molecular_Layer'))
        print os.getcwd()
        #Call the nrniv command on the main code (it is not called from the ml_main import because I couldn't get MPI to engage calling it that way)
        return_code = subprocess.call("mpirun %s -mpi -python main.py --include_pops \"['granule', 'purkinje']\"" % nrniv_path)
        if not return_code:
            raise Exception("Call to legacy hoc model (with command mpirun $NRNIV -mpi -python main.py --include_pops ['granule', 'purkinje']) failed.")
        # Change back to original directory, just done out of cleanliness
        os.chdir(orig_dir)

    elapsed_hoc = time.clock() - start_hoc

    print "Time for Hoc: %f" % elapsed_hoc

elif not args.method:
    raise Exception("Please supply the '--method' option (either nineml or hoc)")

else:
    raise Exception("Unrecognised 'method' option '%s'" % args.method)

