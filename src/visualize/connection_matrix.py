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
    parser.add_argument('--sorted', type=int, nargs='*', 
                        metavar=('PF_TO_INDEX', 'PF_FROM_INDEX', 'NUM_PLOT_COLS'),
                        help='Plots all PF connectivity sorted by number of connections and PC '
                             'depth, the argument is the number of parallel fibres to show in the '
                             'matrix, which is sorted from most to least connections')
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
    if args.plot_slice:
        matrix = np.reshape(matrix, (int(header['num_x']), -1, matrix.shape[1]))
        if args.plot_slice[0] == 0: matrix_slice = matrix[args.plot_slice[1], :, :]
        elif args.plot_slice[0] == 1: matrix_slice = matrix[:, args.plot_slice[1], :]
        elif args.plot_slice[0] == 2: matrix_slice = matrix[:, :, args.plot_slice[1]]
        else: raise Exception('{} out of range, should be 0-2'.format(args.slice_dim))
        pylab.imshow(matrix_slice)
    else:
        bool_matrix = np.array(matrix, dtype=bool)
        pc_counts = np.sum(bool_matrix, axis=1)
        if args.histogram:
            pylab.hist(pc_counts, bins=range(1, matrix.shape[1]))
        elif args.sorted is not None: # Can't use 'if args.sorted' because it could be an empty list
            sorted_pf_indices = np.argsort(pc_counts)
            if args.sorted:
                if len(args.sorted) > 2:
                    from_index = args.sorted[1]
                else:
                    from_index = 0
                to_index = args.sorted[0]
                if to_index < from_index:
                    raise Exception("To index of sorted ({}) is below that of from index ({})"
                                    .format(to_index, from_index))
                sorted_pf_indices = sorted_pf_indices[(-1 - from_index):-to_index:-1]
                num_cols = args.sorted[2] if len(args.sorted) == 3 else 1
            else:
                num_cols = 1
            pf_sorted = matrix[sorted_pf_indices, :]
            purkinje_zs = np.array(eval(header['purkinje_zs']), dtype=float)
            sorted_pc_indices = np.argsort(purkinje_zs)
            sorted_matrix = np.array(pf_sorted[:, sorted_pc_indices], dtype=bool)
            pylab.figure()
            num_pfs = sorted_matrix.shape[0]
            col_size = num_pfs // num_cols
            for i in xrange(num_cols):
                ax = pylab.subplot(1, num_cols, i + 1)
                show_matrix = sorted_matrix[(i * col_size):((i + 1) * col_size), :]
                pylab.imshow(show_matrix,
                             interpolation='nearest',
                             cmap=pylab.get_cmap('PuBu'))
                if i == num_cols // 2:
                    pylab.title('PF to PC connections')                    
                    pylab.xlabel('Purkinjes sorted by mean z')
                if not i:
                    pylab.ylabel('PFs sorted by num connections')
                pylab.yticks(range(0, col_size, col_size // 5))
                ax.set_yticklabels(range(i * col_size, (i + 1) * col_size, col_size // 5))

            pylab.figure()
            pylab.plot(purkinje_zs[sorted_pc_indices])
            pylab.title('Mean z position of Purkinje cells')
            pylab.xlabel('Purkinje cell indices')
            pylab.ylabel('Mean z position')
        else:
            raise Exception("At least one plot option needs to be specified ('plot_slice', 'sorted'"
                            " or 'histogram'")
    pylab.show()

if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
