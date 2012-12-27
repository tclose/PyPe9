#!/usr/local/bin/python
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
# NOTICE OF COPYRIGHT AND OWNERSHIP OF SOFTWARE
#
# Copyright 2007, The University Of Pennsylvania
# 	School of Engineering & Applied Science.
#   All rights reserved.
#   For research use only; commercial use prohibited.
#   Distribution without permission of Maciej T. Lazarewicz not permitted.
#   mlazarew@seas.upenn.edu
#
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import pylab
import os
import sys
from numpy import *

filename = sys.argv[1]

# pyr
if os.path.exists(filename):

	data = pylab.load(filename)
	(Nrow,Ncol) = data.shape
	print (Nrow,Ncol)
	color = ['r','g','b','k','y']
	for i in range(Ncol-1):
		pylab.plot(data[2:-1,0], data[2:-1,i+1],'-', c=color[i])	
	
	b=array([[data[2:,2]>2],  [data[1:-1,2]<=2]])
	print "Number of PYR spikes: ", b.all(0).sum()/2.0
	
	# SAVE PNG
	pylab.savefig('voltage_plot')

	if len(sys.argv)>1:
		
		pylab.show()
	
else:

	print "File pyr.dat does not exist!"


