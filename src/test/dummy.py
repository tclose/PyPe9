#!/usr/bin/env python
from pyNN.neuron import Population, setup, run
from pyNN.parameters import Sequence
from pyNN.neuron.standardmodels.cells import SpikeSourceArray
NUM_CELLS=10
setup(1, 1.5, 100)
spike_times = []
for i in xrange(NUM_CELLS):
    spike_times.append(Sequence([i]))
pop = Population(NUM_CELLS, SpikeSourceArray, {'spike_times': spike_times})
pop.record('spikes')
run(NUM_CELLS)
pop.write_data('spikes.pkl')
print "done"