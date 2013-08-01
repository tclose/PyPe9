"""

  This package mirrors the one in pyNN

  @file __init__.py
  @author Tom Close

"""

#######################################################################################
#
#    Copyright 2012 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
# This is required to ensure that the right MPI variables are set before NEURON is initiated
from __future__ import absolute_import 
try:
    from mpi4py import MPI # @UnresolvedImport @UnusedImport
except:
    pass
import os
from collections import namedtuple
import numpy
import nine.cells.neuron
import nine.pyNN.common
from nine.cells.neuron import group_varname, seg_varname
import pyNN.common
import pyNN.core
import pyNN.neuron.standardmodels as standardmodels
import pyNN.neuron.connectors as connectors
import pyNN.neuron.recording
from pyNN.neuron import setup, run, reset, end, get_time_step, get_current_time, get_min_delay, \
                        get_max_delay, rank, num_processes, record, record_v, record_gsyn, \
                        StepCurrentSource, DCSource, NoisyCurrentSource
import pyNN.neuron as sim
from pyNN.common.control import build_state_queries
import pyNN.neuron.simulator as simulator
import neuron
from neuron import h
import logging

logger = logging.getLogger("PyNN")

get_current_time, get_time_step, get_min_delay, \
        get_max_delay, num_processes, rank = build_state_queries(simulator)

class Population(nine.pyNN.common.Population, pyNN.neuron.Population):

    def __init__(self, label, size, cell_type, params={}, build_mode='lazy'):
        """
        Initialises the population after reading the population parameters from file
        @param label: the label assigned to the population (its NINEML id)
        @param size: the size of the population
        @param cell_type: The cell model used to instantiate the population.
        @param params: the parameters passed to the cell model (Note that at this stage the same \
                        parameters are passed to every cell in the model)
        @param build_mode: Specifies whether cell models, or in NEURON's case, cell mechanisms need\
                            to be built. This is actually performed when the cell_type is loaded \
                           but if build_mode is set to 'build_only' then the population isn't \
                           actually constructed and only the NMODL files are compiled.
        """
        if build_mode == 'build_only' or build_mode == 'compile_only':
            print "Warning! '--build' option was set to 'build_only' or 'compile_only', " \
                  "meaning the Population '{}' was not constructed and only the NMODL files " \
                  "were compiled.".format(label)
        else:
            pyNN.neuron.Population.__init__(self, size, cell_type, params, structure=None,
                                            label=label)


#    #FIXME: I think this should be deleted
#    def set_param(self, cell_id, param, value, component=None, section=None):
#        raise NotImplementedError('set_param has not been implemented for Population class yet')

    def rset(self, param, rand_distr, component=None, seg_group=None):
        param_scope = [group_varname(seg_group)]
        if component:
            param_scope.append(component)
        param_scope.append(param)
        pyNN.neuron.Population.rset(self, '.'.join(param_scope), rand_distr)

    def initialize_variable(self, variable, rand_distr, component=None, seg_group=None):
        variable_scope = [group_varname(seg_group)]
        if component:
            variable_scope.append(component)
        variable_scope.append(variable)
        pyNN.neuron.Population.initialize(self, **{'.'.join(variable_scope): rand_distr})

#    def can_record(self, variable):
#        """
#        Overloads that from pyNN.common.BasePopulation to allow section names and positions to 
#        be passed.
#        """
#        if hasattr(self.celltype, 'ncml_model'): # If cell is generated from NCML file
#            match = pyNN.neuron.recording.recordable_pattern.match(variable)
#            if match:
#                parts = match.groupdict()
#                if parts['var'] not in self.celltype.recordable:
#                    return False
#                if parts['section']: # Check to see if section exists
#                    if not hasattr(self.celltype, parts['section']):
#                        return False
#                if parts.has_key('position'): # Check to see if the position is between 0-1
#                    pos = float(parts['position'])
#                    if pos < 0.0 or pos > 1.0:
#                        raise Exception("Position parameter in recording string, {}, is out of "
#                                        "range (0.0-1.0)".format(pos))
#                return True
#            else:
#                raise Exception("Could not parse variable name '%s'" % variable)
#        else:
#            return pyNN.neuron.Population.can_record(self, variable)


class Projection(pyNN.neuron.Projection):

    def __init__(self, pre, dest, label, connector, synapse_type, source=None, target=None,
                 build_mode='lazy', rng=None):
        self.label = label
        if build_mode == 'build_only' or build_mode == 'compile_only':
            print "Warning! '--build' option was set to 'build_only', meaning the projection " \
                  "'{}' was not constructed.".format(label)
        else:
            pyNN.neuron.Projection.__init__(self, pre, dest, connector, synapse_type, 
                                            label=label, source=source, receptor_type=target)


class Network(nine.pyNN.common.Network):

    def __init__(self, filename, build_mode='lazy', timestep=None, min_delay=None,
                                 max_delay=None, temperature=None, silent_build=False, flags=[],
                                 solver_name=None, rng=None):
        self._pyNN_module = pyNN.neuron
        self._ncml_module = nine.cells.neuron
        self._population_type = Population
        self._projection_type = Projection
        self.get_min_delay = get_min_delay # Sets the 'get_min_delay' function for use in the network init
        #Call the base function initialisation function.
        nine.pyNN.common.Network.__init__(self, filename, build_mode=build_mode, timestep=timestep,
                                        min_delay=min_delay, max_delay=max_delay,
                                    temperature=temperature, silent_build=silent_build, flags=flags,
                                    rng=rng)

    def _convert_units(self, value_str, units=None):
        if ' ' in value_str:
            if units:
                raise Exception("Units defined in both argument ('{}') and value string ('{}')"
                                .format(units, value_str))
            (value, units) = value_str.split()
        else:
            value = value_str
            units = None
        try:
            value = float(value)
        except:
            raise Exception("Incorrectly formatted value string '{}', should be a number optionally"
                            " followed by a space and units (eg. '1.5 Hz')".format(value_str))
        if not units:
            return value
        elif units == "Hz":
            return value
        elif units == "um":
            return value
        elif units == "ms":
            return value
        elif units == "us":
            return value * 1e-3
        elif units == "us/um":
            return value * 1e-3
        elif units == 'uS':
            return value
        elif units == 'mS':
            return value * 1e+3
        elif units == 'nS':
            return value * 1e-3
        elif units == 'pS':
            return value * 1e-6
        elif units == 'MOhm':
            return value
        elif units == 'Ohm/cm':
            return value
        elif units == 'S/cm2':
            return value
        else:
            raise Exception("Unrecognised units '%s'" % units)


    def _set_simulation_params(self, **params):
        """
        Sets the simulation parameters either from the passed parameters or from the networkML
        description
        
        @param params[**kwargs]: Parameters that are either passed to the pyNN setup method or set \
                                 explicitly
        """
        p = self._get_simulation_params(**params)
        setup(p['timestep'], p['min_delay'], p['max_delay'])
        neuron.h.celsius = p['temperature']


if __name__ == "__main__":

    net = Network('/home/tclose/Projects/Cerebellar/xml/cerebellum/test.xml')

    print 'done'
