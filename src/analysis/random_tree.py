# -*- coding: utf-8 -*-
"""
Created on Mon Feb 18 15:13:58 2013
This module defines a function to generate random trees and calculate the coverages of random trees
@author: Haozhe Zhang
"""

import matplotlib.pyplot as plt
from os.path import normpath,join
from ninemlp import SRC_PATH
import morphology_random
import numpy as np
from copy import deepcopy
import xy_coverages 


def random_tree(forest):
    num_tree = len(forest)
    forest_random = deepcopy(forest)
#   calculate the max bounds and min bounds of the forests
    for tree in forest_random.trees:
        tiled_diams = np.transpose(np.tile(tree.diams, (3, 1)))
        tree.min_bounds = np.min(tree.points - tiled_diams, axis=0)
        tree.max_bounds = np.max(tree.points + tiled_diams, axis=0)        
    for tree in forest_random.trees:
        forest_random.min_bounds = np.select([forest_random.min_bounds <= tree.min_bounds, True],[forest_random.min_bounds, tree.min_bounds])
        forest_random.max_bounds = np.select([forest_random.max_bounds >= tree.max_bounds, True],[forest_random.max_bounds, tree.max_bounds])
    bound = (forest_random.max_bounds-forest_random.min_bounds)/2
    for j in range( num_tree ):
        k = 0
        while k == 0:
            a=np.random.uniform(-bound[0],bound[0],size=1)
            b=np.random.uniform(-bound[1],bound[1],size=1)
            c=np.random.uniform(-bound[1],bound[1],size=1)
            forest_random[j].offset((a[0],b[0],c[0]))
            k = 1
#        if the random trees are out of random, regenerate it.
            for point in forest_random[j].points:
                if point[0] > forest_random.max_bounds[0] or point[0] < forest_random.min_bounds[0] or point[1] > forest_random.max_bounds[1] or point[1] < forest_random.min_bounds[1] or point[2] > forest_random.max_bounds[2] or point[2] < forest_random.min_bounds[2]:
                            k = 0
                            forest_random[j].offset((-a[0],-b[0],-c[0]))
                            break 
    return forest_random

if __name__=='__main__':
    VOX_SIZE1=(0.65,0.65,6.5)# voxsize for the real forest in brain
    VOX_SIZE2=(0.5,0.5,1.1)  # voxsize for the random trees
    print "loading forest..."
    forest=morphology_random.Forest(normpath(join(SRC_PATH,'..','morph','Purkinje','xml','GFP_P60.1_slide7_2ndslice-HN-FINAL.xml')))
    print "Finished loading forest."
    forest.offset((0.0, 0.0, -500))
    forest.align_to_xyz_axes() # this step is very important
    forest_random = random_tree(forest)    
    print "begin to calculate coverages"
    coverages1,z1=xy_coverages.xy_coverages(forest_random, VOX_SIZE1) # variable z1 is the z coordinate
    plt.plot(np.array(range(z1)),coverages1,"red")
    coverages,z=xy_coverages.xy_coverages(forest, VOX_SIZE2)     
    plt.plot(np.array(range(z)),coverages,"black")   
    print "begin to plot coverages"
    plt.xlabel("z-slices")
    plt.ylabel("xy-coverages")
    plt.title("xy-coverages of  dendrite trees")
    plt.show()    
    print 'end'