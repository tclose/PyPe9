#!/usr/bin/env python
"""
  This script creates and runs a minimal network in the NINEML+ framework with only one cell 
  in it

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
from ninemlp.connectivity.morphology import read_NeurolucidaXML
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('forest_xml', type=str, help='The name of the xml file to load the purkinje'
                                                     ' forest from.')
    parser.add_argument('--pf_spacing', type=float, default=0.05, help='The distance between '
                                                                        'parallel fibres')
    parser.add_argument('--pf_radius', type=float, default=0.05, help='The radius of the parallel '
                                                                      'fibres')
    parser.add_argument('--vox_size', type=float, nargs=3, default=(1.0,1.0,1.0), 
                        help='The voxel size of the masks')
    args = parser.parse_args(arguments)
    forest = read_NeurolucidaXML(args.forest_xml)
    forest_min = [float('inf'), float('inf'), float('inf')]
    forest_max = [float('-inf'), float('-inf'), float('-inf')]
    for tree in forest:
        mask = tree.get_binary_mask(args.vox_size)
        if mask.offset < forest_min:
            forest_min = mask.offset
    pf_grid = np.meshgrid(np.arange(forest_min, forest_max))
   
def single_cell(arguments):
    import shlex
    main(shlex.split(arguments))   
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])