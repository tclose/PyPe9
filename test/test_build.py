from __future__ import division
from __future__ import print_function
import ninemlcatalog
from nineml.abstraction import Parameter, TimeDerivative, StateVariable
import nineml.units as un
from pype9.simulate.nest import CellMetaClass
from pype9.simulate.common.cells.with_synapses import WithSynapses
from pype9.exceptions import Pype9BuildMismatchError
import logging
import sys
from unittest import TestCase  # @Reimport

logger = logging.getLogger('pype9')
logger.setLevel(logging.INFO)
handler = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter(
    '%(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)


class TestSeeding(TestCase):

    def test_build_name_conflict(self):
        izhi = ninemlcatalog.load('neuron/Izhikevich.xml#Izhikevich')
        izhi2 = izhi.clone()

        izhi2.add(StateVariable('Z', dimension=un.dimensionless))
        izhi2.regime('subthreshold_regime').add(TimeDerivative('Z', '1 / zp'))
        izhi2.add(Parameter('zp', dimension=un.time))

        izhi_wrap = WithSynapses.wrap(izhi)
        izhi2_wrap = WithSynapses.wrap(izhi2)

        CellMetaClass(izhi_wrap)
        self.assertRaises(
            Pype9BuildMismatchError,
            CellMetaClass,
            izhi2_wrap)