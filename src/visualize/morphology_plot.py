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
from neuronvisio.controls import Controls
import argparse

def main(arguments):  
    PROJECT_PATH = os.path.normpath(os.path.join(os.path.realpath(__file__), '..', '..', '..'))
    parser = argparse.ArgumentParser(description=__doc__)
    args = parser.parse_args(arguments)




if __name__ == "__main__":
    main(sys.argv[1:])
