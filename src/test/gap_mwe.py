import neuron
from neuron import h
import numpy as np

neuron.load_mechanisms('/home/tclose/kbrain/src/pyNN/neuron/nmodl')

# Get the parallel context
pc = h.ParallelContext()
num_processes = int(pc.nhost())
mpi_rank = int(pc.id())

# The gid used for the gap junction connection
GID = 0

print "Creating test network..."
#The pre cell is created on the first node and the post cell on the last node
if mpi_rank == 0:
    # Create the pre-synaptic cell
    pre_cell = h.Section()
    pc.source_var(pre_cell(0.5)._ref_v, GID)    
    # Stimulate the first cell
    stim = h.IClamp(pre_cell(0.5))
    stim.delay = 0
    stim.amp = 1
    stim.dur = 100
    # Record Voltage of pre-synaptic cell
    pre_v = h.Vector()
    pre_v.record(pre_cell(0.5)._ref_v)
if mpi_rank == (num_processes - 1):
    # Create the post-synaptic cell
    post_cell = h.Section()
    gap_junction = h.Gap(0.5, sec=post_cell)
    gap_junction.g = 1.0
    pc.target_var(gap_junction._ref_vgap, GID)
    # Record Voltage of post-synaptic cell
    post_v = h.Vector()
    post_v.record(post_cell(0.5)._ref_v)
# Record time
rec_t = h.Vector()
rec_t.record(h._ref_t)    

# Run simulation    
print "Running..."
neuron.h.finitialize(-60)
neuron.init()
neuron.run(100)

# Convert recorded times into numpy array
t_array = np.array(rec_t)

# Save data
print "Saving data..."
np.savetxt("../../output/times.dat",t_array)
if mpi_rank == 0:
    pre_v_array = np.array(pre_v)
    np.savetxt("../../output/pre_v.dat",np.array(pre_v_array))    
if mpi_rank == (num_processes - 1):
    post_v_array = np.array(post_v)
    np.savetxt("../../output/post_v.dat",np.array(post_v_array))

print "Done."