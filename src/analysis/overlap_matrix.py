import os
import os.path
from ninemlp.connectivity.morphology import *
VOXEL_SIZE=(0.25, 0.25, 500)

forest_path = os.path.join('..','..','morph','Purkinje','xml')
forest = Forest(os.path.join(forest_path,
                             'GFP_P60.1_slide7_2ndslice-HN-FINAL.xml'))

for tree1 in forest:
    for tree2 in forest:        
        print tree1.num_overlapping(tree2, VOXEL_SIZE)
