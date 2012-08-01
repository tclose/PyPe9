#fin = open('/home/tclose/cerebellar/NINEMLP/brep/build/projections/Granule-Golgi')
#fout = open('/home/tclose/cerebellar/NINEMLP/brep/build/projections/Granule-Golgi.out', 'w')
#for line in fin:
#    (pre_id, post_id, weight, delay) = line.split()
#    pre_id = int(pre_id)
#    post_id = int(post_id)
#    weight = float(weight)
#    delay = float(delay) + 0.02
#    fout.write("%d %d %f %f\n" % (pre_id, post_id, weight, delay))
#print "done"

"""
A single-compartment Hodgkin-Huxley neuron with exponential, conductance-based
synapses, fed by two spike sources.

Run as:

$ python HH_cond_exp.py <simulator>

where <simulator> is 'neuron', 'nest', etc

Andrew Davison, UNIC, CNRS
July 2007

$Id: HH_cond_exp.py 644 2009-06-05 14:42:34Z apdavison $
"""
from pyNN.random import RandomDistribution, NumpyRNG
import numpy

time = 2000
start_input = 1000
mf_rate = 10
stim_seed = None

print "Setting up simulation"
mean_interval = 1000 / mf_rate # Convert from Hz to ms
stim_range = (time - start_input) * 1.5 # Is scaled by 50% just to be sure it doesn't end early
if stim_range >= 0.0:
    mean_num_spikes = stim_range / mean_interval
    stim_rng = NumpyRNG(seed=stim_seed)
#    print "The seed used for the stimulation parameters is %d" % stim_rng.seed
    exp_dist = RandomDistribution('exponential',
                                            [mean_interval],
                                            rng=stim_rng)
    mf_spike_intervals = exp_dist.next((20, mean_num_spikes))
    mf_spike_times = numpy.cumsum(mf_spike_intervals, axis=1)
    print mf_spike_times
else:
    print "Warning, stimulation start (%f) is after end of experiment (%f)" % \
                                                                (start_input, time)
print mf_spike_times

#from pyNN.utility import get_script_args
#
#simulator_name = get_script_args(1)[0]
#exec("from pyNN.%s import *" % simulator_name)
#
#
#setup(timestep=0.01, min_delay=0.1, max_delay=4.0, quit_on_end=False)
#
#hhcell = create(HH_cond_exp)
#
#spike_sourceE = create(SpikeSourceArray, {'spike_times': [float(i) for i in range(1, 100, 1)]})
#spike_sourceI = create(SpikeSourceArray, {'spike_times': [float(i) for i in range(100, 200, 11)]})
#
#connE = connect(spike_sourceE, hhcell, weight=0.02, synapse_type='excitatory', delay=2.0)
#connI = connect(spike_sourceI, hhcell, weight=0.01, synapse_type='inhibitory', delay=4.0)
#
#record_v(hhcell, "Results/HH_cond_exp_%s.v" % simulator_name)
#record_gsyn(hhcell, "Results/HH_cond_exp_%s.gsyn" % simulator_name)
#record(hhcell, 'Results/HH_cond_exp_%s.spikes' % simulator_name)
#
#run(200.0)
#
#end()
#
#print "done"
