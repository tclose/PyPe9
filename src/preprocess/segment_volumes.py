#!/usr/bin/env python
"""
    This module contains methods and classes to load dendritic tree's from Neurolucida's SWC file 
    format into a containing class, and a script to import it into a format that brep can read.
    
    @file segment_volumes.py
    @author Tom Close
    @date 17/7/2012
    
"""


#######################################################################################
#
#        Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import math
import argparse
import numpy as np
from visualisation.common import draw_bounding_box

def main():
    """
    Used for testing the NeurolucidaTree class
    """
    parser = argparse.ArgumentParser(description='A script to read SWC files and print their segment\
                                     volumes to file with the format ''x y z volume''')
    parser.add_argument('input', type=str, help="Path of the input file to read the SWC data from")
    parser.add_argument('output', type=str, help="Path of the output file to print the data to")
    parser.add_argument('--plot', action='store_true', help='Flag to plot the loaded positions')
    parser.add_argument('--axis_order', nargs=3, type=int, help='The order in which the loaded axes will be interpreted. For example "z y x" will interpret the x and z being flipped)')
    args = parser.parse_args()

    if args.axis_order:
        x = args.axis_order.find('x')
        y = args.axis_order.find('y')
        z = args.axis_order.find('z')
    else:
        x = 0
        y = 1
        z = 2

    tree = NeurolucidaTree()
    tree.load(args.input, verbose=False)
    f = open(args.output, 'w')
    f.write("# min_bounds: %f %f %f\n" % (tree.min_bounds[x], tree.min_bounds[y], tree.min_bounds[z]))
    f.write("# max_bounds: %f %f %f\n" % (tree.max_bounds[x], tree.max_bounds[y], tree.max_bounds[z]))
    if args.plot:
        xs = []
        ys = []
        zs = []
    for seg in tree.dendrite_sections.values():
        f.write("%f %f %f %f\n" % (seg.coord[x], seg.coord[y], seg.coord[z], seg.volume()))
        if args.plot:
            xs.append(seg.coord[x])
            ys.append(seg.coord[y])
            zs.append(seg.coord[z])
    print "Saved output volumes to '%s'" % args.output
    if args.plot:
        from mpl_toolkits.mplot3d import Axes3D #@UnusedImport
        import matplotlib.pyplot as plt
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        ax.scatter(xs=xs, ys=ys, zs=zs, marker='+')
        draw_bounding_box(ax, [tree.min_bounds[x], tree.min_bounds[y], tree.min_bounds[z]],
                              [tree.max_bounds[x], tree.max_bounds[y], tree.max_bounds[z]])
        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')
        plt.show()


class NeurolucidaTree:

    class Section:
        def __init__(self, section_id, coord, radius, parent):
            self.id = section_id
            self.coord = coord
            self.parent = parent
            self.radius = radius
            self.children = list()
            if parent:
                parent.children.append(self)

        def has_child(self):
            return len(self.children)

        def is_branch_start(self):
            return len(self.parent.children) > 1

        def is_branch_end(self):
            return not len(self.children)

        def is_fork(self):
            return len(self.children) > 1

        def endpoints(self):
            if self.is_branch_start():
                start = self.parent.coord
            else:
                start = (self.parent.coord + self.coord) / 2.0
            if self.is_fork() or self.is_branch_end():
                end = self.coord
            else:
                end = (self.coord + self.children[0].coord) / 2.0
            return (start, end)

        def length(self):
            epoints = self.endpoints()
            return np.sqrt(np.sum(np.square(epoints[1] - epoints[0])))

        def volume(self):
            return self.length() * math.pi * (self.radius * self.radius)

    def __init__(self):
        self.start = None
        ## Stores all the sections of the tree in a dictionary indexed by the SWC ID
        self.dendrite_sections = dict()
        self.soma_sections = dict()
        self.min_bounds = np.ones(3) * float('inf')
        self.max_bounds = np.ones(3) * float('-inf')

    def load(self, filename, verbose=True):
        f = open(filename, 'r')
        line_count = 0
        while True:
            line = f.readline()
            if not line:
                break
            if line[0] != '#':
                line_count = line_count + 1
                contents = line.split()
                if len(contents) != 7:
                    raise Exception ('Incorrect number of values (%d) on line %d' % (len(contents),
                                                                                        line_count))
                section_id = int(contents[0])
                section_type = int(contents[1])
                coord = np.array(contents[2:5], dtype=float)
                radius = float(contents[5])
                parent_id = int(contents[6])
                if section_type == 1:
                    # If section is part of soma add it to list so that the dendritic sections can 
                    # Note that the "radius" of soma sections is not relevant as it does not 
                    # correspond to the radius of the actual soma
                    self.soma_sections[section_id] = NeurolucidaTree.Section(section_id, coord,
                                                                                float('NaN'), None)
                elif section_type == 2:
                    if verbose:
                        print "Skipped axon on line %d" % line_count
                elif section_type == 3:    #If section is part of dendritic tree (instead of soma)
                    # Save the minimum and maximum bounds of the dendritic tree
                    for d in xrange(3):
                        if coord[d] < self.min_bounds[d]:
                            self.min_bounds[d] = coord[d]
                        if coord[d] > self.max_bounds[d]:
                            self.max_bounds[d] = coord[d]
                    if parent_id == -1:
                        self.start = NeurolucidaTree.Section(section_id, coord, float('NaN'), None)
                        parent = self.start
                    elif parent_id in self.soma_sections.keys():
                        self.start = self.soma_sections[parent_id]
                        parent = self.start
                    else:
                        parent = self.dendrite_sections[parent_id]
                    self.dendrite_sections[section_id] = NeurolucidaTree.Section(section_id, coord,
                                                                                    radius, parent)
                else:
                    raise Exception('Unrecognised section type (%d)' % section_type)
        print 'Loaded %d sections (%d) from file: %s' % (line_count, len(self.dendrite_sections),
                                                                                           filename)

if __name__ == "__main__":
    main()



