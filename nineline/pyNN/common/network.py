from __future__ import absolute_import
import os.path
from pyNN.random import NumpyRNG
import pyNN.standardmodels
import nineml.user_layer
import nineline.pyNN.common
import quantities as pq

_REQUIRED_SIM_PARAMS = ['timestep', 'min_delay', 'max_delay', 'temperature']

class Network(object):

    def __init__(self, filename, network_name=None, build_mode='lazy', verbose=False, timestep=None,
                 min_delay=None, max_delay=None, temperature=None, silent_build=False, flags=[],
                 rng=None, solver_name='cvode'):
        parsed_nineml = nineml.user_layer.parse(filename)
        if network_name:
            try:
                self.nineml_model = parsed_nineml.groups[network_name]
            except KeyError:
                raise Exception("Nineml file '{}' does not contain network named '{}'"
                                .format(filename, network_name))
        else:
            try:
                self.nineml_model = parsed_nineml.groups.values()[0]
            except IndexError:
                raise Exception("No network objects loaded from NineMl file '{}'".format(filename))
        self._set_simulation_params(timestep=timestep, min_delay=min_delay, max_delay=max_delay,
                                                                            temperature=temperature)
        self.dirname = os.path.dirname(filename)
        self.label = self.nineml_model.name
        self._rng = rng if rng else NumpyRNG()
        self._populations = {}
        PopulationClass = self._PopulationClass
        for name, model in self.nineml_model.populations.iteritems():
            self._populations[name] = PopulationClass(model, self._rng, build_mode, silent_build,
                                                      solver_name=solver_name)
        if build_mode not in ('build_only', 'compile_only'):
            self._projections = {}
            ProjectionClass = self._ProjectionClass
            projection_models = self.nineml_model.projections.values()
            num_projections = len(projection_models)
            for model in projection_models:
                try:
                    self._projections[model.name] = ProjectionClass(
                                                  self._populations[model.source.population.name],
                                                  self._populations[model.target.population.name],
                                                  model, rng=self._rng)
                except nineline.pyNN.common.projections.ProjectionToCloneNotCreatedYetException as e:
                    if e.orig_proj_id in self.nineml_model.projections.keys():
                        projection_models.append(model)
                        # I think this is the theoretical limit for the number of iterations this
                        # loop will have to make for the worst ordering of cloned projections
                        if len(projection_models) - num_projections > (num_projections *
                                                                       (num_projections + 1) / 2):
                            raise Exception("Projections using 'Clone' pattern form a circular "
                                            "reference")
                    else:
                        raise Exception("Projection '{}' attempted to clone connectivity patterns "
                                        "from '{}', which was not found in network."
                                        .format(name, e.orig_proj_id))
            self._finalise_construction()

    def _finalise_construction(self):
        """
        Can be overriden by deriving classes to do any simulator-specific finalisation that is required
        """
        pass

    @property
    def populations(self):
        return self._populations

    @property
    def projections(self):
        return self._projections

    def describe(self):
        """
        Describes all populations and projections within the network
        """
        print "Populations:"
        for pop in self.populations.itervalues():
            print pop.describe()

        print "Projections:"
        for proj in self.projections.itervalues():
            print proj.describe()

    def save_connections(self, output_dir):
        """
        Saves generated connections to output directory
        
        @param output_dir:
        """
        for proj in self.projections.itervalues():
            if isinstance(proj.synapse_type, pyNN.standardmodels.synapses.ElectricalSynapse):
                attributes = 'weight'
            else:
                attributes = 'all'
            proj.save(attributes, os.path.join(output_dir, proj.label + '.proj'), format='list', gather=True)

    def save_positions(self, output_dir):
        """
        Saves generated cell positions to output directory
        
        @param output_dir:
        """
        for pop in self.populations.itervalues():
            pop.save_positions(os.path.join(output_dir, pop.label) + '.pop')

    def record(self, variable):
        """
        Record variable from complete network
        """
        for pop in self.populations.itervalues():
            pop.record(variable)

    def write_data(self, file_prefix, **kwargs):
        """
        Record all spikes generated in the network
        
        @param filename: The prefix for every population files before the popluation name. The \
                         suffix '.spikes' will be appended to the filenames as well.
        """
        # Add a dot to separate the prefix from the population label if it doesn't already have one
        # and isn't a directory
        if (not os.path.isdir(file_prefix) and not file_prefix.endswith('.')
                and not file_prefix.endswith(os.path.sep)):
            file_prefix += '.'
        for pop in self.populations.itervalues():
            pop.write_data(file_prefix + pop.label + '.pkl', **kwargs)  # @UndefinedVariable

    def _get_simulation_params(self, **params):
        sim_params = dict([(p.name, pq.Quantity(p.value, p.unit))
                           for p in self.nineml_model.parameters.values()])
        for key in _REQUIRED_SIM_PARAMS:
            if params.has_key(key) and params[key]:
                sim_params[key] = params[key]
            elif not sim_params.has_key(key) or not sim_params[key]:
                raise Exception ("'{}' parameter was not specified either in Network "
                                 "initialisation or NetworkML specification".format(key))
        return sim_params


#     def _convert_units(self, value_str, units=None):
#         raise NotImplementedError("_convert_units needs to be implemented by simulator specific "
#                                   "Network class")
#
#     def _convert_all_units(self, values_dict):
#         for key, val in values_dict.items():
#             values_dict[key] = self._convert_units(val)
#         return values_dict


#     def set_flags(self, flags):
#         if self.nineml_model.parameters.has_key('flags'):
#             try:
#                 self.flags = dict([(f.name, bool(f.value)) for f in self.nineml_model.parameters['flags']])
#             except ValueError as e:
#                 raise Exception("Could not convert flag to boolean: {}".format(e))
#         else:
#             self.flags = {}
#         for flag in flags:
#             if type(flag) == str:
#                 name = flag
#                 value = True
#             elif type(flag) == tuple:
#                 if len(flag) == 2:
#                     name, value = flag
#                 else:
#                     raise Exception("Incorrect number of elements ({}) in flag tuple '{}', "
#                                     "should be 2 (name or name and value)".format(len(flag), flag))
#                 assert(type(name) == str)
#                 assert(type(value) == bool)
#             if name not in self.flags:
#                 raise Exception ("Did not find the passed flag '{}' in the Network ML description "
#                                  "({})".format(name, self.flags))
#             self.flags[name] = value
#
#     def check_flags(self, p):
#         try:
#             return (all([self.flags[flag] for flag in p.flags]) and
#                     all([not self.flags[flag] for flag in p.not_flags]))
#         except KeyError as e:
#                 raise Exception ("Did not find flag '{flag}' used in '{id}' in freeParameters "
#                                  "block of NetworkML description".format(flag=e, id=p.id))