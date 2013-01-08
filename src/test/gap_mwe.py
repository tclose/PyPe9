import neuron
from neuron import h
import numpy as np
import argparse
import matplotlib.pyplot as plt

# The gid used for the gap junction connection
VARIABLE_GID = 1

# Arguments to the script
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--plot', action='store_true', help="Plot the data instead of saving it")
args = parser.parse_args()

neuron.load_mechanisms('/home/tclose/kbrain/src/pyNN/neuron/nmodl')

# Get the parallel context and related parameters
pc = h.ParallelContext()
num_processes = int(pc.nhost())
mpi_rank = int(pc.id())

print "Creating test network..."
# The pre cell is created on the first node and the post cell on the last node 
# (NB: which will obviously be the same if there is only one node)
if mpi_rank == 0:
    # Create the pre-synaptic cell
    pre_cell = h.Section()
    pre_cell.insert('pas')
    pc.source_var(pre_cell(0.5)._ref_v, VARIABLE_GID)    
    # Stimulate the first cell
    stim = h.IClamp(pre_cell(0.5))
    stim.delay = 50
    stim.amp = 10
    stim.dur = 100
    # Record Voltage of pre-synaptic cell
    pre_v = h.Vector()
    pre_v.record(pre_cell(0.5)._ref_v)
if mpi_rank == (num_processes - 1):
    # Create the post-synaptic cell
    post_cell = h.Section()
    post_cell.insert('pas')    
    gap_junction = h.Gap(0.5, sec=post_cell)
    gap_junction.g = 1.0
    pc.target_var(gap_junction._ref_vgap, VARIABLE_GID)
    # Record Voltage of post-synaptic cell
    post_v = h.Vector()
    post_v.record(post_cell(0.5)._ref_v)
# Record time
rec_t = h.Vector()
rec_t.record(h._ref_t)    

# Finalize contruction of parallel context
pc.setup_transfer()

# Run simulation    
print "Running..."
neuron.h.finitialize(-60)
neuron.init()
neuron.run(100)

# Convert recorded data into numpy arrays
t_array = np.array(rec_t)
if mpi_rank == 0:
    pre_v_array = np.array(pre_v)
if mpi_rank == (num_processes - 1):
    post_v_array = np.array(post_v)    

# Either plot the recorded values
if args.plot and num_processes == 1:
    if mpi_rank == 0:
        pre_fig = plt.figure()
        plt.plot(t_array, pre_v_array)
        plt.title("Pre-cell voltage")
        plt.xlabel("Time [ms]")
        plt.ylabel("Voltage [mV]")
    if mpi_rank == (num_processes - 1):
        pre_fig = plt.figure()
        plt.plot(t_array, post_v_array)
        plt.title("Post-cell voltage")
        plt.xlabel("Time [ms]")
        plt.ylabel("Voltage [mV]")
    plt.show()
else:
    # Save data
    print "Saving data..."
    np.savetxt("../../output/times.dat",t_array)
    if mpi_rank == 0:
        np.savetxt("../../output/pre_v.dat",np.array(pre_v_array))    
    if mpi_rank == (num_processes - 1):
        np.savetxt("../../output/post_v.dat",np.array(post_v_array))
        
print "Done."