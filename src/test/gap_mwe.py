"""

A minimum working example of NEURON gap junctions over MPI

Author: Tom Close
Date: 8/1/2013
Email: tclose@oist.jp
"""

import os
import argparse
import numpy as np
import neuron
from mpi4py import MPI
from neuron import h
import sys
import ninemlp

# The GID used for the gap junction connection. NB: this number is completely independent from the 
# GID's used for NEURON sections.
VARIABLE_GID = 0

# Arguments to the script
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--plot', action='store_true', help="Plot the data instead of saving it")
parser.add_argument('--output_dir', type=str, default=os.getcwd(), 
                    help="The directory to save the output files into")
parser.add_argument('--gap_mechanism_dir', type=str, default=None,
                    help="The directory to load the gap mechanism from")
parser.add_argument('--build', type=str, default='lazy', 
                    metavar='BUILD_MODE',
                    help='Option to build the NMODL files before running (can be one of \
                          {}.'.format(['lazy', 'build_only', 'compile_only', 'force']))
args = parser.parse_args()

# Compile PyNN mechanisms (including 'Gap' mechanism)
if args.build in ['build_only', 'compile_only', 'force']:
    ninemlp.pyNN_build_mode = args.build
    import ninemlp.neuron #@UnusedImport
    sys.exit(0)
# Load gap mechanism from another directory if required
if args.gap_mechanism_dir and args.gap_mechanism_dir is not os.getcwd():
    neuron.load_mechanisms(args.gap_mechanism_dir)
else:
    neuron.load_mechanisms(os.path.join(ninemlp.SRC_PATH, 'pyNN', 'neuron', 'nmodl'))
# Get the parallel context and related parameters
pc = h.ParallelContext()
num_processes = int(pc.nhost())
mpi_rank = int(pc.id())
print "On process {} of {} (id = {})".format(mpi_rank, num_processes, pc.id())

print "Creating test network..."
# The pre-synaptic cell is created on the first node and the post-synaptic cell on the last node 
# (NB: which will obviously be the same if there is only one node)
if mpi_rank == 0:
    print "Creating pre cell on process {}".format(mpi_rank)
    # Create the pre-synaptic cell
    pre_cell = h.Section()
    pre_cell.insert('pas')
    # Connect the voltage of the pre-synaptic cell to the gap junction on the post-synaptic cell
    pc.source_var(pre_cell(0.5)._ref_v, VARIABLE_GID)    
    # Stimulate the first cell to make it obvious whether gap junction is working
    stim = h.IClamp(pre_cell(0.5))
    stim.delay = 50
    stim.amp = 10
    stim.dur = 100
    # Record Voltage of pre-synaptic cell
    pre_v = h.Vector()
    pre_v.record(pre_cell(0.5)._ref_v)
if mpi_rank == (num_processes - 1):
    print "Creating post cell on process {}".format(mpi_rank)
    # Create the post-synaptic cell
    post_cell = h.Section()
    post_cell.insert('pas')    
    # Insert gap junction
    gap_junction = h.gap(0.5, sec=post_cell)
    gap_junction.g = 1.0
    # Connect gap junction to pre-synaptic cell
    pc.target_var(gap_junction._ref_vgap, VARIABLE_GID)
    # Record Voltage of post-synaptic cell
    post_v = h.Vector()
    post_v.record(post_cell(0.5)._ref_v)
    
# Record time
rec_t = h.Vector()
rec_t.record(h._ref_t)    

# Finalise construction of parallel context
pc.setup_transfer()

# Run simulation    
print "Running..."
neuron.h.finitialize(-60)
neuron.init()
neuron.run(100)

# Convert recorded data into Numpy arrays
t_array = np.array(rec_t)
if mpi_rank == 0:
    pre_v_array = np.array(pre_v)
if mpi_rank == (num_processes - 1):
    post_v_array = np.array(post_v)

# Either plot the recorded values
if args.plot and num_processes == 1:
    import matplotlib.pyplot as plt
    if mpi_rank == 0:
        pre_fig = plt.figure()
        plt.plot(t_array, pre_v_array)
        plt.title("Pre-synaptic cell voltage")
        plt.xlabel("Time (ms)")
        plt.ylabel("Voltage (mV)")
    if mpi_rank == (num_processes - 1):
        pre_fig = plt.figure()
        plt.plot(t_array, post_v_array)
        plt.title("Post-synaptic cell voltage")
        plt.xlabel("Time (ms)")
        plt.ylabel("Voltage (mV)")
    plt.show()
else:
    # Save data
    print "Saving data..."
    if mpi_rank == 0:
        np.savetxt(os.path.join(args.output_dir, "pre_v.dat"), np.transpose(np.vstack((t_array, pre_v_array)))) 
    if mpi_rank == (num_processes - 1):
        np.savetxt(os.path.join(args.output_dir, "post_v.dat"), np.transpose(np.vstack((t_array, post_v_array))))
        
print "Done."