"""
Created on Wed Feb 20 16:41:40 2013

This module defines a function to do a simulation  and get the averaged coverage curve for random
"trees" in a rectangle 
@author: Haozhe Zhang
"""

import numpy as np
from numpy import power
from numpy import arange
import matplotlib.pyplot as plt
from scipy import stats

def estimate_coverage(width, length, density, tree_size,vox_size,min_distance):
     trees_NUMBER = int (float(width)*float(length)*float(density)) # get the total numbers of "trees" by density and volume
     trees_array = []     
     for k in range(trees_NUMBER):
         flag = 0
         while flag == 0:
             z_random = np.random.uniform(0,length,size = 1)
             l_random_left = np.random.uniform(0,width-tree_size,size = 1) #get the random "trees"
             l_random_right = l_random_left + tree_size            
             flag = 1
             for ii in range(k):
#  check whether the trees satisfy the assumption of "min-distance"
                 if (l_random_left - trees_array[ii][0][0])*(l_random_left - trees_array[ii][0][0])+ (z_random-trees_array[ii][1])*(z_random-trees_array[ii][1]) < min_distance*min_distance:
                     flag = 0
         trees_array.append([[l_random_left[0], l_random_right[0]], z_random[0]])
     select_trees=[]
     coverage_array=[]
     coverage = 0
     for z in range(vox_size):         
#         select the trees whose z-coordinats are smaller that the "z"
         for l in range(len(trees_array)):
             if trees_array[l][1] <= float (length) /float(vox_size) *float(z+1):
                 select_trees.append(trees_array[l][0])
         coverage = 0
         for i in range(len(select_trees)):            
             for j in range(i,len(select_trees)):
#    to get rid of the doublely counted part ,i.e.the overlaping of different "trees"
                 if select_trees[i][0] <= select_trees[j][0] and select_trees[j][0] <= select_trees[i][1] and select_trees[i][1] <= select_trees[j][1] and i < j:
                     select_trees[i][1] = select_trees[j][0]
                 elif select_trees[i][0] <= select_trees[j][1] and select_trees[j][1] <= select_trees[i][1] and  select_trees[j][0] <= select_trees[i][0] and i < j: 
                     select_trees[j][1] = select_trees[i][0]
                 elif select_trees[i][0] >= select_trees[j][0] and select_trees[i][1] <= select_trees[j][1] and i < j: 
                     select_trees[i][1] = select_trees[i][0]
                 elif select_trees[j][0] >= select_trees[i][0] and select_trees[j][1] <= select_trees[i][1] and i < j: 
                     select_trees[j][1] = select_trees[j][0]
         for m in range(len(select_trees)):
             coverage += select_trees[m][1]-select_trees[m][0] #get the coverage
         coverage_array.append(coverage/width)
         select_trees=[]
         coverage = 0
     return coverage_array
 
if __name__ == '__main__':
    array = []
    vox_size = 100 # This is the vox_size of z-axis,i.e.the length of the rectangle
#  'times' shows the times for which we calculate the coverages of random trees in order to get the averaged coverages
    times =100          
    width = 500 # width of the rectangle
    length = 100 # length of the rectangle ,i.e. the total length of z-axis
    density = 0.001 # number of "trees" in the ractangle of unit area
    tree_size = 15 # the width of "trees"
    min_distance = 5 # the distances of every two random generated trees should be larger than "min-distance"
    set = arange(0.0,15.0,0.05)
    gradient_array=[]
# The loop below is defined to calculate the averaged coverages(array) for different "min-distances". And "min-distance"can be replaced by other variables
    for min_distance in set:
        a=estimate_coverage(width,length,density,tree_size,vox_size,min_distance)
        for t in range(times - 1):
#    estimate_coverage(width,length,density,tree_size,vox_size,min_distance)  get the coverage
            a= np.add(a,estimate_coverage(width,length,density,tree_size,vox_size,min_distance) )
#    np.log(1-a/times) is defined to linearize the formula : y= 1- exp(-az)
        gradient, intercept, r_value, p_value, std_err = stats.linregress(arange(0,float(length),float(length) /float(vox_size)),- np.log(1-a/times))
        gradient_array.append(gradient)
    print stats.linregress(set,gradient_array) #regress
    print gradient_array
    plt.plot(set,gradient_array)   
    plt.show()


    

     
#         
         
