#!/usr/bin/env python
"""

A minimum working example of NEURON gap junctions over MPI

Author: Tom Close
Date: 8/1/2013
Email: tclose@oist.jp
"""

import sys
import os
import argparse
import numpy as np
# This is a hack I use on our cluster, to get MPI initialised=True. There is probably something
# wrong with our setup but I can't be bothered trying to work out what it is at this point. All
# suggestions welcome :)
try:
    from mpi4py import MPI #@UnresolvedImport @UnusedImport
except:
    print "mpi4py was not found, MPI will remain disabled if MPI initialized==false on startup"
from neuron import h
from ninemlp.neuron.build import compile_nmodl
# Arguments to the script
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--plot', action='store_true', help="Plot the data instead of saving it")
parser.add_argument('--output_dir', type=str, default=os.getcwd(),
                    help="The directory to save the output files into")
parser.add_argument('--gap_mechanism_dir', type=str, default=os.getcwd(),
                    help="The directory to load the gap mechanism from")
parser.add_argument('--build', type=str, default='lazy',
                    help="Can be either 'lazy', 'build_only', or 'require' (used for separating "
                         "compilation and running)")
args = parser.parse_args()
# Compile the gap mechanisms
compile_nmodl(args.gap_mechanism_dir, build_mode=args.build)
if args.build == 'build_only':
    sys.exit(0)
# Get the parallel context and related parameters
pc = h.ParallelContext()
num_processes = int(pc.nhost())
last_process = num_processes - 1
mpi_rank = int(pc.id())
print "Creating test network..."
# The first section is created on the first node and the second section on the last node 
# (NB: which will obviously be the same if there is only one node)
if mpi_rank == 0:
    print "Creating pre section on process {}".format(mpi_rank)
    # Create the first section
    section1 = h.Section()
    section1.insert('pas')
    # Set up the voltage of the first section to be able to connect to the gap junction on the 
    # second section
    pc.source_var(section1(0.5)._ref_v, 0)
    # Insert gap junction
    gap_junction1 = h.Gap(0.5, sec=section1)
    gap_junction1.g = 100.0
    # Set up the gap junction on the first section to connect with the second section voltage
    pc.target_var(gap_junction1._ref_vgap, 1)
    # Stimulate the first section to make it obvious whether gap junction is working
    stim = h.IClamp(section1(0.5))
    stim.delay = 50
    stim.amp = 10
    stim.dur = 100
    # Record Voltage of first section
    v1 = h.Vector()
    v1.record(section1(0.5)._ref_v)
if mpi_rank == last_process:
    print "Creating post section on process {}".format(mpi_rank)
    # Create the second section
    section2 = h.Section()
    section2.insert('pas')
    # Set up the voltage of the second section to be able to connect to the gap junction on the 
    # first section
    pc.source_var(section2(0.5)._ref_v, 1)
    # Insert gap junction
    gap_junction2 = h.Gap(0.5, sec=section2)
    gap_junction2.g = 100.0
    # Set up the gap junction on the second section to connect with the first section voltage
    pc.target_var(gap_junction2._ref_vgap, 0)
    # Record Voltage of second section
    v2 = h.Vector()
    v2.record(section2(0.5)._ref_v)
if mpi_rank == 0 or mpi_rank == last_process:
    # Finalise construction of parallel context
    pc.setup_transfer()
    # Record time
    rec_t = h.Vector()
    rec_t.record(h._ref_t)
    print "Finished network construction on process {}".format(mpi_rank)
    
    # Steps to run simulation    
    h.dt = 0.25
    print "Setting maxstep on process {}".format(mpi_rank)
    pc.set_maxstep(10)
    print "Finitialise on process {}".format(mpi_rank)
    h.finitialize(-60)
    print "Running simulation on process {}".format(mpi_rank)
    pc.psolve(100)
    print "Finished run on process {}".format(mpi_rank)
    
    # Convert recorded data into Numpy arrays
    t_array = np.array(rec_t)
if mpi_rank == 0:
    v1_array = np.array(v1)
if mpi_rank == last_process:
    v2_array = np.array(v2)

# Either plot the recorded values
if args.plot and num_processes == 1:
    print "Plotting..."
    import matplotlib.pyplot as plt
    if mpi_rank == 0:
        pre_fig = plt.figure()
        plt.plot(t_array, v1_array)
        plt.title("Section 1 voltage")
        plt.xlabel("Time (ms)")
        plt.ylabel("Voltage (mV)")
    if mpi_rank == last_process:
        pre_fig = plt.figure()
        plt.plot(t_array, v2_array)
        plt.title("Section 2 voltage")
        plt.xlabel("Time (ms)")
        plt.ylabel("Voltage (mV)")
    plt.show()
elif mpi_rank == 0 or mpi_rank == last_process:
    # Save data
    print "Saving data on process {}...".format(mpi_rank)
    if mpi_rank == 0:
        np.savetxt(os.path.join(args.output_dir, "v1.dat"),
                   np.transpose(np.vstack((t_array, v1_array))))
    if mpi_rank == last_process:
        np.savetxt(os.path.join(args.output_dir, "v2.dat"),
                   np.transpose(np.vstack((t_array, v2_array))))
if mpi_rank == 0:
    print "Allowing other processes (if present) to complete on process 0"
    pc.runworker()
    print "Completing parallel context from process 0"
    pc.done()
print "Finished process {}".format(mpi_rank)
