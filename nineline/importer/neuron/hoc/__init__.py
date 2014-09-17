from __future__ import absolute_import
import os.path
import re
import tempfile
import subprocess as sp
from collections import defaultdict
from copy import deepcopy
import itertools
from operator import itemgetter
import numpy
from ....cells import (Model, SegmentModel, AxialResistanceModel,
                       MembraneCapacitanceModel, IonChannelModel,
                       IonConcentrationModel, CurrentClampModel,
                       SynapseModel)


class HocImporter(object):

    @classmethod
    def strip_comp(cls, param_name, comp_name):
        if param_name.endswith(comp_name):
            # the +1 is for the underscore
            param_name = param_name[:-(len(comp_name) + 1)]
        return param_name

    @classmethod
    def param_combinations(cls, name, params):
        """
        Iterates through each of the combinations of variable parameters and
        returns the component name and a parameter dict for it
        """
        # For each of the parameters with a 'dict' value, generate a
        # list of values (zipped with the parameter name for convenience),
        # stripping the component suffix from the parameter name
        varying = [[(cls.strip_comp(k, name), w) for w in v.values()]
                   for k, v in params.iteritems() if isinstance(v, dict)]
        # For each of the parameters with a 'str' value (i.e. not a dict), add
        # to constant dictionary, stripping the component suffix from the
        # parameter name and convert the values into floats
        constant = dict((cls.strip_comp(k, name), float(v)
                         if v is not None else None)
                        for k, v in params.iteritems()
                        if not isinstance(v, dict))
        # Loop through all combinations of varying parameters and create a new
        # component for each combination (although some won't end up being
        # used) if that combination isn't present in the cell morphology
        for combination in itertools.product(*varying):
            # Initialise comb_key which is generated by looping through
            # contstants
            comp_name = name
            # Copy constants into vals dictionary
            vals = deepcopy(constant)
            # Loop through param-name/value pairs and set value appending the
            # param index
            for param_name, val in combination:
                # Append the param name and value to the comp_name replacing
                # decimal points and minus signs
                if val is not None:
                    comp_name += ('__' + param_name +
                                  val.replace('.', '_').replace('-', 'm'))
                    vals[param_name] = float(val)
                else:
                    vals[param_name] = None
            # Yield the component name and dictionary for the current
            # combination
            yield comp_name, vals

    def __init__(self, import_dir, model_files=['main.hoc'], hoc_cmds=[]):
        self.import_dir = import_dir
        self.hoc_cmds = hoc_cmds
        if isinstance(model_files, str):
            model_files = [model_files]
        self.hoc_files = [f for f in model_files if f.endswith('.hoc')]
        self.python_files = [f[:-3] for f in model_files if f.endswith('.py')]
        self._run_model_printouts()
        self._extract_morphology()
        self._extract_mechanisms()
        self._map_segments_to_components()
        self.model.url = None

    def _run_model_printouts(self):
        # Create the python commands to load the model and then run the print
        # out hoc files
        this_dir = os.path.dirname(__file__)
        pycmd = ("import os; os.chdir('{}');".format(self.import_dir) +
                 "from neuron import h;" +
                ''.join("h.load_file(os.path.join('{}', '{}'));"
                        .format(self.import_dir, hf)
                         for hf in self.hoc_files) +
                ''.join("import {};".format(pf) for pf in self.python_files) +
                ''.join("h('{}');".format(cmd) for cmd in self.hoc_cmds) +
                "print '<BREAK>';" +
                "h.load_file(os.path.join('{}', 'print_morph.hoc'));"
                .format(this_dir) + "print '<BREAK>';"
                "h.load_file(os.path.join('{}', 'print_lengths.hoc'));"
                .format(this_dir) + "print '<BREAK>';"
                "h.load_file(os.path.join('{}', 'print_modelview.hoc'))"
                .format(this_dir))
        # Run the python command and save the output
        process = sp.Popen(["python", "-c", pycmd], stdout=sp.PIPE)
        output = process.communicate()[0]
        # Split the output into the different sections for further processing
        (_, self.psections,
         self.lengths, self.modelview) = output.split('<BREAK>')

    def print_section_lengths(self, cell):
        for name, seg in sorted(cell.segments.iteritems(), key=itemgetter(0)):
            print "{} {:.6f}".format(name, seg.L)

    def _extract_morphology(self):
        self.model = Model('hoc_import',
                source=os.path.join(self.import_dir))
        segments = {}
        in_section = False
        started = False
        for line in self.psections.splitlines():
            line = line.strip()
            if line.startswith('points: '):  # Reads pt3 point dumps
                # Load the 3d points in the section
                points = numpy.array([float(p)
                                      for p in line[8:].split(' ')])
                diam = points[-1]
                points = points[:-1].reshape((-1, 3))
                started = True
            elif not started:  # Avoids any leading output lines
                continue
            # If not in section and there is something printed on the line
            # assume it is the start of a new segment
            elif not in_section and line:
                # Skip if it is just one of the random integers that hoc
                # spits out from time to time
                try:
                    int(line)
                    continue
                except ValueError:
                    pass
                # Split line on white space
                parts = line.split(' ')
                # Get segment name
                name = parts[0]
                # Initialise containers to be populated from subsequent
                # lines
                components = defaultdict(list)
                connections = []
                # Read the attributes of the segment from this line
                attributes = {}
                for key_val in parts[2:]:
                    key_val = key_val.strip()
                    if key_val:
                        key, val = key_val.split('=')
                        attributes[key] = float(val)
                in_section = True
            elif in_section:
                # If the closing trailing brace is found collect all the
                # read data into a SegmentModel object
                if line.startswith('}'):
                    for comp_name in ('morphology', 'capacitance'):
                        if len(components[comp_name]) != 1:
                            raise Exception("More than one '{}' component"
                                            .format(comp_name))
                    # FIXME: Should be given units
                    diam = components['morphology'][0]['diam']
                    Ra = attributes['Ra']
                    cm = components['capacitance'][0]['cm']
                    num_segments = attributes['nseg']
                    assert num_segments == 1, "Only implemented for "\
                                                                "nseg == 1"
                    proximal = points[0, :]
                    distal = points[1, :]
                    if len(connections) == 0:
                        parent_name = None
                        self.model.set_root(proximal, diam)
                    elif len(connections) == 1:
                        parent_name = connections[0][0]
                    else:
                        raise Exception("Segment '{}' has more than one "
                                        "connection (expected only one "
                                        "'parent' segment)")
                    segment = SegmentModel(name, distal, diam)
                    # At this stage the inserted mechanisms are just stored
                    # in the 'inserted' item in the content dictionary and
                    # are mapped to component objects in the map mechanisms
                    # function
                    inserted = dict((n, [dict((self.strip_comp(k, n), v)
                                              for k, v in d.iteritems())
                                         for d in p])
                                    for n, p in components.iteritems())
                    del inserted['morphology']
                    del inserted['capacitance']
                    inserted['Ra'] = [{'Ra': Ra}]
                    inserted['cm'] = [{'cm': cm}]
                    contents = segment.get_content()
                    contents.update({'parent_name': parent_name, 'Ra': Ra,
                                     'cm': cm, 'inserted': inserted,
                                     'num_segs': num_segments,
                                     'points': points})
                    segments[segment.name] = segment
                    if parent_name is None:
                        self.model.root_segment = segment
                        self.model.root_segment.get_content()['p3d']._type = 1
                        # Set the root segments index to be 3 (using a 3
                        # point soma)
                        self.model.root_segment._index = 3
                    in_section = False
                # If line starts with 'insert' read the component and what
                # has been inserted
                elif line.startswith('insert'):
                    (component_name,
                         parameters) = line[6:].strip().split('{')
                    component = {}
                    if parameters != '}':
                        for key_vals in parameters.strip()[:-1].split(' '):
                            key, val = key_vals.strip().split('=')
                            component[key] = float(val)
                    components[component_name.strip()].append(component)
                # If line starts with 'connect' read the parent connection
                elif line.find('connect') > 0:
                    parts = line.strip().split(' ')
                    connections.append((parts[0], parts[4]))
        # Convert parent references from names to Section objects
        for seg in segments.itervalues():
            contents = seg.get_content()
            if contents['parent_name'] is None:
                self.model.add_node_with_parent(seg, self.model.get_root())
            else:
                self.model.add_node_with_parent(seg,
                                           segments[contents['parent_name']])
                offset = contents['points'][0] - seg.parent.distal
                if offset.sum():
                    contents['proximal_offset'] = offset
        return self.model

    def _extract_mechanisms(self):
        (inserted_mechs, mechs_list,
         global_params, point_procs) = self._parse_mechanisms_dump()
        for name, params in inserted_mechs.iteritems():
            if name == 'Ra':
                if isinstance(params, dict):
                    for key, vals in self.param_combinations(name, params):
                        self.model.add_component(AxialResistanceModel(key,
                                                                 vals['Ra']))
                else:
                    self.model.add_component(AxialResistanceModel('Ra',
                                                             float(params)))
            elif name == 'capacitance':
                if isinstance(params, dict):
                    for key, vals in self.param_combinations(name, params):
                        self.model.add_component(
                                     MembraneCapacitanceModel(key, vals['cm']))
                else:
                    self.model.add_component(
                                 MembraneCapacitanceModel('cm', float(params)))
            # Otherwise if params is a dict it should be a general density
            # mechanism with multiple parameter groups
            elif isinstance(params, dict):
                for key, vals in self.param_combinations(name, params):
                    self.model.add_component(IonChannelModel(key, name, vals))
            elif name in mechs_list:
                assert params is None
                self.model.add_component(IonChannelModel(name, name, {}))
            # If it gets down this far and it starts with e then I think this
            # is a fairly safe assumption
            elif name.startswith('e'):
                self.model.add_component(IonConcentrationModel(name[1:],
                                                           float(params)))
            # Else it should be single parameter of a mechanism that has a
            # constant value
            else:
                comp_name = [m for m in mechs_list if name.endswith(m)]
                assert len(comp_name) < 2
                if not comp_name:
                    raise Exception("Unrecognised inserted mechanism")
                comp_name = comp_name[0]
                param_name = self.strip_comp(name, comp_name)
                self.model.add_component(IonChannelModel(comp_name, comp_name,
                                                  {param_name: float(params)}))
        for name, params in point_procs.iteritems():
            # FIXME: This is a poor assumption (that point-processes starting
            # with I are current clamps), not sure how to improve though
            # @IgnorePep8
            if name.startswith('I'):
                if name != 'IClamp':
                    print ("Warning: assuming '{}' is a current clamp"
                           .format(name))
                for key, vals in self.param_combinations(name, params):
                    self.model.add_component(CurrentClampModel(key, name,
                                                               vals))
            else:
                for key, vals in self.param_combinations(name, params):
                    self.model.add_component(SynapseModel(key, name, vals))
        for name, params in global_params.iteritems():
            comps = [c for c in self.model.components.itervalues()
                     if c.class_name == name]
            if not comps:
                raise Exception("Could not find a component with matching "
                                "class name '{}'".format(name))
            # Strip component suffix from param name and convert value to float
            global_parameters = dict((self.strip_comp(k, name), float(v))
                                     for k, v in params.iteritems())
            # Set a reference to the same dictionary in each component so they
            # are consistent
            for comp in comps:
                comp.global_parameters = global_parameters

    def _parse_mechanisms_dump(self):
        # Load mechanisms model view dump from file into nested dictionaries
        # for convenient access
        contents = {}
        containers = [contents]
        for line in self.modelview.splitlines():
            strip_line = line.strip()
            if strip_line:
                depth = (len(line) - len(line.lstrip())) // 4
                if strip_line.startswith('* '):
                    strip_line = strip_line[2:]  # remove '* '
                    # remove numbers from the front of item
                    strip_line = re.sub('[0-9]+ ', '', strip_line)
                    for _ in xrange(depth, len(containers) - 1):
                        containers.pop()
                    container = {}
                    containers[-1][strip_line] = container
                    containers.append(container)
                else:
                    key_val = strip_line.split('=')
                    if len(key_val) == 2:
                        key, val = key_val
                        val = val.strip()
                    else:
                        key = '='.join(key_val)
                        val = None
                    index = key.find(' (')
                    if index == -1:
                        index = len(key)
                    key = key[:index]
                    key = key.strip()
                    for _ in xrange(depth, len(containers) - 1):
                        containers.pop()
                    # At the lowest level it is possible for there to be
                    # multiple values with the same number of segments and
                    # hence the same 'key'. Since in this case the key is
                    # actually ignored, if the key exists just use the
                    # value as a key. This effectively treati the container
                    # as a list, which it would ideally be but would
                    # require mendokusai bookeeping to work out.
                    if key in containers[-1]:
                        key = val
                    containers[-1][key] = val
        inserted_mechs = contents['real cells']['root soma']['inserted '
                                                             'mechanisms']
        mechs_list = contents['Density Mechanisms']['Mechanisms in use']
        global_params = contents['Density Mechanisms']['Global parameters for '
                                                       'density mechanisms']
        point_procs_group = contents['point processes (can receive events) of '
                                     'base classes']
        try:
            point_procs = point_procs_group['Point Processes']
        except KeyError:
            point_procs = dict((k, v) for k, v in point_procs_group.iteritems()
                               if k not in ('Global parameters for Point '
                                            'Processes', 'KSChan definitions '
                                            'for Point Processes'))
        return inserted_mechs, mechs_list, global_params, point_procs

    def _map_segments_to_components(self):
        for seg in self.model.segments:
            for mech_name, param_sets in seg.get_content()['inserted'].\
                                                                   iteritems():
                for params in param_sets:
                    comp = [c for c in self.model.components.itervalues()
                            if c.class_name == mech_name and
                               all(c.parameters[k] == params[k] or
                                   c.parameters[k] is None
                                   for k in params.iterkeys())]
                    assert len(comp) < 2
                    if not comp:
                        raise Exception("Could not find matching component "
                                        " for '{}' mechanisms with params:\n"
                                        "    {}"
                                        .format(mech_name, params))
                    seg.set_component(comp[0])

if __name__ == '__main__':
    importer = HocImporter('/home/tclose/git/cerebellarnuclei/'
                           'DCN_morph.hoc')
    print importer.psections