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

# Reads the 
import csv

#===================================================================================================
#
# Load description files
#
#===================================================================================================
def CommentStripper (iterator):
     for line in iterator:
         if line.strip()[:2] == '//':
             continue
         if not line.strip():
             continue
         yield line

def ReadCells():
	cells_file    = "parameters/cells.par"
	
	# Cells
	reader = csv.reader (CommentStripper (open (cells_file)))
	cellsList2 = list(reader)
	cellsList = []
	
	# Conver the number of cells to int
	for x in cellsList2:
		cellsList.append([ x[0], int(x[1])])
		
	#===================================================================================================
	#
	# Convert the cells from List to List of Dictionaries 
	#
	#===================================================================================================
	# add to the firs cell on th list (default pyramidal cell) one passive cell
	cellsList[0][1] += 1
	
	cellsN = dict(cellsList)
	
	return cellsN