"""

  This file can be used to load a cell model and interact with it using
  NeuronVisio. Needs to be called from within ipython with the '-q4thread' option 
  it will also load the NeuronVisio controls to plot the morphology
  and run interactively (NeuronVisio needs to be installed of course see http://mattions.github.com/neuronvisio/install.html).

  @author Tom Close
  @file neuronviso.py

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################


from neuronvisio.controls import Controls
from ninemlp.neuron.ncml import load_cell_type
import argparse

parser = argparse.ArgumentParser(description='A script to load and plot the morphology of a cell in \
                                                                                    neuronvisio')
parser.add_argument('file_location', help="The filename of the cell to load.")
args = parser.parse_args()

Cell = load_cell_type(args.file_location)
controls = Controls()   # start the GUI
purkinje = Cell()
print 'Successfully loaded cell morphology'
