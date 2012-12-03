#!/usr/bin/env python

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

import numpy as np
import pylab
import argparse

def main(arguments):
    """
    Loads the connectivity matrix from pf2pc_connectivity.py script and plots it in different ways.
    
    @param arguments [list(str)]: The arguments to be parsed using argparser
    """
    parser = argparse.ArgumentParser(description='A script to plot activity recorded from NINEML+')
    parser.add_argument('matrix_file', type=str, help='The files to plot the activity from')
    parser.add_argument('--plot_slice', metavar=('DIM', 'INDEX'), nargs=2, type=int, 
                        help='Plots a slice of the connection matrix')
    parser.add_argument('--histogram', action='store_true', 
                        help='Plots a histogram of the parallel fibre connections')
    args = parser.parse_args(arguments)
    # Read number of x from header
    header = {}
    with open(args.matrix_file) as f:
        for line in f:
            if line[0] != '#':
                break
            if ':' in line:
                key, val = line.split(':')
                header[key[1:].strip()] = val.strip()
    if not header.has_key('num_x'):
        raise Exception("Key 'num_x' was not found in matrix header")
    # Load matrix file
    matrix = np.loadtxt(args.matrix_file)
    matrix = np.reshape(matrix, (int(header['num_x']), -1, matrix.shape[1]))
    if args.plot_slice:
        if args.plot_slice[0] == 0: matrix_slice = matrix[args.plot_slice[1], :, :]
        elif args.plot_slice[0] == 1: matrix_slice = matrix[:, args.plot_slice[1], :]
        elif args.plot_slice[0] == 2: matrix_slice = matrix[:, :, args.plot_slice[1]]        
        else: raise Exception('{} out of range, should be 0-2'.format(args.slice_dim))
        fig = pylab.figure()
        pylab.imshow(matrix_slice)
    elif args.histogram:
        bool_matrix = np.array(matrix, dtype=bool)
        pc_counts = np.sum(bool_matrix, axis=2)
        pylab.hist(pc_counts.ravel(), bins=range(1,matrix.shape[2]))
    else:
        raise Exception("At least one plot option needs to be specified ('plot_slice' or 'histogram'")
    pylab.show()
    
if __name__ == '__main__':
    import sys
    main(sys.argv[1:])