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
import numpy as np
from visualize import draw_bounding_box


class SWCTree:

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

    def __init__(self, filename=None):
        self.start = None
        ## Stores all the sections of the tree in a dictionary indexed by the SWC ID
        self.dendrite_sections = dict()
        self.soma_sections = dict()
        self.min_bounds = np.ones(3) * float('inf')
        self.max_bounds = np.ones(3) * float('-inf')
        if filename:
            self.load(filename)

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
                    self.soma_sections[section_id] = SWCTree.Section(section_id, coord,
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
                        self.start = SWCTree.Section(section_id, coord, float('NaN'), None)
                        parent = self.start
                    elif parent_id in self.soma_sections.keys():
                        self.start = self.soma_sections[parent_id]
                        parent = self.start
                    else:
                        parent = self.dendrite_sections[parent_id]
                    self.dendrite_sections[section_id] = SWCTree.Section(section_id, coord,
                                                                                    radius, parent)
                else:
                    raise Exception('Unrecognised section type (%d)' % section_type)
        print 'Loaded %d sections (%d) from file: %s' % (line_count, len(self.dendrite_sections),
                                                                                           filename)

    @classmethod
    def _write_branch_xml(cls, f, branch, indent):
        if math.isnan(branch.radius):
            diam = branch.children[0].radius * 2.0
        else:
            diam = branch.radius * 2.0
        f.write('{indent}<point x="{coord[0]}" y="{coord[1]}" z="{coord[2]}" d="{diam}" />\n'
                .format(indent=indent, coord=branch.coord, diam=diam))
        if branch.is_fork():
            f.write('{indent}<branch>\n'.format(indent=indent))
            for child in branch.children:
                cls._write_branch_xml(f, child, indent + '    ')
            f.write('{indent}</branch>\n'.format(indent=indent))
        elif not branch.is_branch_end():
            cls._write_branch_xml(f, branch.children[0], indent)

    def save_xml(self, filename):
        """
        Saves the SWC tree into the Neurolucida XML file format
        
        @param filename [str]: The path of the file to save the xml to
        """
        print "Writing dendritic tree to xml file '{}'...".format(filename)
        # Open up the file and write all the branches
        with open(filename, 'w') as f:
            f.write('<tree>\n')
            self._write_branch_xml(f, self.start, '    ')
            f.write('</tree>\n')
        print "Finished writing tree"


if __name__ == '__main__':
    """
    Used for testing the SWCTree class
    """
    import argparse
    parser = argparse.ArgumentParser(description='A script to read SWC files and print their segment\
                                     volumes to file with the format ''x y z volume''')
    parser.add_argument('input', type=str, help="Path of the input file to read the SWC data from")
    parser.add_argument('output', type=str, help="Path of the output file to print the data to")
    parser.add_argument('--plot', action='store_true', help='Flag to plot the loaded positions')
    parser.add_argument('--axis_order', nargs=3, type=int, help='The order in which the loaded axes will be interpreted. For example "z y x" will interpret the x and z being flipped)')
    args = parser.parse_args()
    if args.input.split('.')[-1] != 'swc':
        raise Exception("Input file needs to have extension 'swc' (found '{}')"
                        .format(args.input.split('.')[-1]))
    # Get the file extension of the output file to determine the action to take
    output_file_ext = args.output.split('.')[-1]
    # Save morphology in xml format
    if  output_file_ext == 'xml':
        swc_tree = SWCTree(args.input)
        swc_tree.save_xml(args.output)
    # Save the volumes of the tree segments
    elif output_file_ext == 'vol':
        if args.axis_order:
            x = args.axis_order.find('x')
            y = args.axis_order.find('y')
            z = args.axis_order.find('z')
        else:
            x = 0
            y = 1
            z = 2

        tree = SWCTree()
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
    else:
        raise Exception("No action associated with the output extension '{}'"
                        .format(output_file_ext))


