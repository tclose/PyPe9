import os.path
from pype9.neuron.importer.hoc import HocImporter

alex_ocnc_dir = os.path.join(
    os.environ['HOME'], 'git', 'alex_ocnc', 'test')

importer = HocImporter(alex_ocnc_dir, ['stellate_scaled2.hoc'])

importer.model
