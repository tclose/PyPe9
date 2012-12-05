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
from ninemlp.connectivity.morphology import read_NeurolucidaXML, Tree, NeurolucidaXMLHandler

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
    parser.add_argument('--shifted', action='store_true',
                        help="Uses the same PF tree mask that is 'shifted' into position rather "
                             "than creating a new tree for each parallel fibre so will be ~5-6 "
                             "times faster but requires that the 'pf_spacing' option is an even "
                             "multiple of each of the voxel dimensions")
    args = parser.parse_args(arguments)
    if args.shifted and \
            (args.pf_spacing[0] % args.vox_size[0] or args.pf_spacing[1] % args.vox_size[1]):
        raise Exception("Parallel fibre spacing ({}) should be even multiples of corresponding "
                        "voxel sizes ({}) if the 'shifted' option is provided. NB not providing "
                        "the 'shifted' option will have a significant impact on performance"
                        .format(args.pf_spacing, args.vox_size[0:2]))
    forest = read_NeurolucidaXML(args.forest_xml)
    forest_min = np.array([float('inf'), float('inf'), float('inf')])
    forest_max = np.array([float('-inf'), float('-inf'), float('-inf')])
    print "Generating binary masks for Purkinje trees"
    for i, purkinje in enumerate(forest):
        mask = purkinje.get_binary_mask(args.vox_size)
        for dim_i in xrange(3):
            if mask.offset[dim_i] < forest_min[dim_i]:
                forest_min[dim_i] = mask.offset[dim_i]
            if mask.limit[dim_i] > forest_max[dim_i]:
                forest_max[dim_i] = mask.limit[dim_i]
        print "Finished mask for Purkinje {} of {}".format(i, len(forest))
    pf_radius = args.pf_diam / 2.0
    pf_min = forest_min[0:2] + pf_radius
    pf_max = forest_max[0:2] + args.pf_spacing[0:2] - pf_radius
    pf_X, pf_Y = np.meshgrid(np.arange(pf_min[0], pf_max[0], args.pf_spacing[0]),
                             np.arange(pf_min[1], pf_max[1], args.pf_spacing[1]))
    num_x = pf_X.shape[0]
    num_y = pf_X.shape[1]
    print "Calculating pf connections"
    with open(args.output_file, 'w') as f:
        f.write("# PF to PC Connectivity file\n"
                "# num_x: {num[0]}\n"
                "# num_y: {num[1]}\n"
                "# min_x: {min[0]}\n"
                "# min_y: {min[1]}\n"
                "# max_x: {max[0]}\n"
                "# max_y: {max[1]}\n"
                "# step_x: {step[0]}\n"
                "# step_y: {step[1]}\n".format(num=(num_x, num_y), min=pf_min, max=pf_max,
                                               step=args.pf_spacing))
        f.write("# purkinje_zs: [")
        for purkinje in forest[:-1]:
            f.write("{}, ".format(purkinje.centroid[2]))
        f.write("{}]\n".format(forest[-1].centroid[2]))
        if args.shifted:
            start_point = (0.0, 0.0, forest_min[2], args.pf_diam)
            finish_point = (0.0, 0.0, forest_max[2], args.pf_diam)
            pf_branch = NeurolucidaXMLHandler.Branch((start_point, finish_point), [])
            pf_init = Tree(pf_branch, 2)
        for i, (x, y) in enumerate(zip(pf_X.ravel(), pf_Y.ravel())):
            if args.shifted:
                pf = pf_init.shifted_tree((x, y, 0.0))
            else:
                start_point = (x, y, forest_min[2], args.pf_diam)
                finish_point = (x, y, forest_max[2], args.pf_diam)
                pf_branch = NeurolucidaXMLHandler.Branch((start_point, finish_point), [])
                pf = Tree(pf_branch, 2)
            for purkinje in forest:
                num_overlap = purkinje.num_overlapping(pf, args.vox_size)
                f.write(' {}'.format(num_overlap))
            f.write('\n')
            if i % num_x == num_x - 1:
                print "Finished y: {}".format(y)
        print "done"

def pf2pc_connectivity(arguments):
    import shlex
    main(shlex.split(arguments))

if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
