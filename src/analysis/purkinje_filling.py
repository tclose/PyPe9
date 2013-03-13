#!/usr/bin/env python
"""
  This script runs a parallel fibre to Purkinje connectivity analysis on a forest of purkinje fibres 

  @author Tom Close
  @date 17/9/2012
"""
#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import os.path
import argparse
import numpy as np
import ninemlp
from ninemlp.connectivity.morphology import Forest, Tree, NeurolucidaTreeXMLHandler

PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))

def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('forest_xml', type=str, help='The path of the Purkinje forest xml file')
    parser.add_argument('output_file', type=str,
                        help='The output location to save the connectivity matrix')
    parser.add_argument('--pf_spacing', type=float, nargs=2, metavar=('X', 'Y'), default=(2.0, 2.0),
                        help='The distance between parallel fibres (default %(default)s')
    parser.add_argument('--pf_diam', type=float, default=2.0, help='The radius of the parallel '
                                                                   'fibres (default %(default)s')
    parser.add_argument('--vox_size', type=float, nargs=3, default=(1.0, 1.0, 1.0),
                        metavar=('X', 'Y', 'Z'),
                        help='The voxel size of the PF and PC masks (default %(default)s')
    parser.add_argument('--rotate_xz', type=float, default=0.0, metavar=('DEGREES'), 
                        help="Rotate the Purkinje forest in the x-z plane (clockwise in degrees)")
    args = parser.parse_args(arguments)
    forest = Forest(args.forest_xml)
    if args.rotate_xz:
        forest.rotate(args.rotate_xz, axis=0)
    
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])