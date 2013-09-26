from __future__ import absolute_import
import nineline.pyNN.common.cells
from pyNN.parameters import ParameterSpace
import pyNN.standardmodels
import nest
from nineline.cells.nest import NineCellMetaClass, basic_nineml_translations

class NinePyNNCell(nineline.pyNN.common.cells.NinePyNNCell, pyNN.standardmodels.StandardCellType):

    standard_receptor_type = None

    def __init__(self, **parameters):
        nineline.pyNN.common.cells.NinePyNNCell.__init__(self)
        pyNN.standardmodels.StandardCellType.__init__(self, **parameters)

    def memb_init(self):
        # Initialisation of member states goes here
        print "WARNING, membrane initialization function has not been implemented"
        pass

    def translate(self, parameters):
        """
        Translate standardized model parameters to simulator-specific parameters. Overrides the
        the method in StandardModelType to provide a simpler translation that avoids the evaluation 
        of the 'dots' in the standard name
        """
        native_parameters = {}
        for name in parameters.keys():            
            native_parameters[self.translations[name]['translated_name']] = parameters[name]
        return ParameterSpace(native_parameters, schema=None, shape=parameters.shape)

    def get_receptor_type(self, name):
        if name.startswith('{'):
            name = name[name.find('}')+1:]
        return nest.GetDefaults(self.nest_model)["receptor_types"][name]


class NinePyNNCellMetaClass(nineline.pyNN.common.cells.NinePyNNCellMetaClass):
    """
    Metaclass for compiling NineMLCellType subclases
    Called by nineml_celltype_from_model
    """
    
    _basic_nineml_translations = basic_nineml_translations
    loaded_celltypes = {}
    
    def __new__(cls, name, nineml_model, build_mode='lazy', silent=False, solver_name='cvode'): #@NoSelf
        try:
            celltype = cls.loaded_celltypes[(nineml_model.name, nineml_model.url)]
        except KeyError:
            dct = {'model': NineCellMetaClass(name, nineml_model, build_mode=build_mode, 
                                              silent=silent, solver_name='cvode')}
            dct['nest_name'] = {"on_grid": name, "off_grid": name}
            dct['nest_model'] = name
            dct['translations'] = cls._construct_translations(dct['model'].nineml_model,
                                                              dct['model'].component_translations)        
            celltype = super(NinePyNNCellMetaClass, cls).__new__(cls, name, (NinePyNNCell,), dct)
            # If the url where the celltype is defined is specified save the celltype to be retried 
            # later
            if nineml_model.url is not None: 
                cls.loaded_celltypes[(name, nineml_model.url)] = celltype  
        return celltype

    @classmethod
    def _construct_translations(cls, nineml_model, component_translations):
        translations = []
        for p in nineml_model.parameters:
            if p.reference == 'Voltage':
                translations.append((p.name, 'V_m'))
            else:
                if p.reference in ('Diameter', 'Length'):
                    component = 'Geometry'
                else:
                    component = p.component
                try:
                    varname = cls._basic_nineml_translations[p.reference]
                except KeyError:
                    varname = p.reference
                translations.append((p.name, component_translations[component][varname][0]))
        return pyNN.standardmodels.build_translations(*translations)
