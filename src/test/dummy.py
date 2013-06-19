from pyNN.nest import Population
from pyNN.nest.standardmodels.cells import SpikeSourcePoisson, SpikeSourceInhGamma 
poisson = Population(1, SpikeSourcePoisson, {'rate' : [5], 'start' : [1000], 'duration': [1e10]})
#poisson = Population(1, SpikeSourceInhGamma, {'a': [1], 'b': [2], 'tbins': [3], 'start': [4], 'duration': [5]})
print "done"