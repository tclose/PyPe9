#!/usr/bin/env python
"""
Contains a method for plotting morphologies of NINEML+ network. The selected cell model 
will be loaded along with NeuronVisio's controls, from which the morphology can be plotted using the
Plot3D function (as a bonus the cell can also be run interactively using the other NeuronVisio 
commands). 

Requires NeuronVisio,to install NeuronVisio see http://mattions.github.com/neuronvisio/install.html.

@author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

import sys
import os.path
from neuronvisio.controls import Controls
import argparse

def main(arguments):  
    PROJECT_PATH = os.path.normpath(os.path.join(os.path.realpath(__file__), '..', '..', '..'))
    parser = argparse.ArgumentParser(description=__doc__)
    args = parser.parse_args(arguments)




if __name__ == "__main__":
    main(sys.argv[1:])
