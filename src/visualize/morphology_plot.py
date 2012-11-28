#!/usr/bin/env python
"""
Contains a method for plotting morphologies of NINEML+ network

@author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

import sys
import os.path
import argparse

PROJECT_PATH = os.path.normpath(os.path.join(os.path.realpath(__file__), '..', '..', '..'))

def main(arguments):  
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('xml_filename', type=str, 
                        help="The name of the xml file containing the morphology to plot")
    parser.add_argument('cell_id', type=str, help="The ID of the cell to extract from the xml file")
    parser.add_argument('--morph_id', type=str, default=None, 
                        help='The morphology ID to load from the xml file')
    args = parser.parse_args(arguments)
    # Import NeuroVisio gui
    from neuronvisio.controls import Controls
    from ninemlp.neuron.ncml import load_cell_type
    # Start the GUI
    controls = Controls() #@UnusedVariable: Just needs to be created for the GUI to be initialised
    # Load the cell
    Cell = load_cell_type(args.cell_id, args.xml_filename, args.morph_id)
    cell = Cell() #@UnusedVariable: Just needs to be created for the morphology to show up
    # Pause the script to allow inspection of the morphology
    raw_input("<press the 'Plot3D' button on the control panel to plot morphology, then press " \
              " return to continue>")

if __name__ == "__main__":
    main(sys.argv[1:])
