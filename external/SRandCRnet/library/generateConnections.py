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

import csv
import sys
import random

#===================================================================================================
#
# Make sure that the input contains three integer numbers representing the sizes of cell subpopulations 
#
#===================================================================================================
#try:

#	int(sys.argv[1])
#	int(sys.argv[2])
#	int(sys.argv[3])

#except Exception:

#	print "Needs three parameters: Npyr, Nbask, Nolm"	
#	exit()

#===================================================================================================
#
# Load description files
#
#===================================================================================================
synapses_file = "parameters/synapses.par"
cells_file    = "parameters/cells.par"

def CommentStripper (iterator):
     for line in iterator:
         if line.strip()[:2] == '//':
             continue
         if not line.strip():
             continue
         yield line

# Synapses
reader = csv.reader (CommentStripper (open (synapses_file)))
synapsesList = list(reader)

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


#===================================================================================================
#
# Convert the synapses from List to List of Dictionaries 
#
#===================================================================================================
fields = ['preCell', 'postCell', 'synName', 'tao1', 'tao2', 'Erev', 'modFileName', 'synLocSec', 'synLoc', 'Npre', 'gmax', 'delay', 'r']

# Produce a list of dictionary
synapses = []
globalID = -1
for syn in synapsesList:
	d = {}
	for field, val in map(None, fields, syn):

		try:
			d[field]=float(val)
			if(d[field]==int(d[field])):
				d[field] = int(d[field])
			
		except ValueError:
		
			d[field]=val.strip()
	
	globalID+=1
	d['globalID'] = globalID
	synapses.append(d)

Nsyn = len(synapses)

#for i in synapses: print i


#===================================================================================================
#
# Generate GIDs for all neuronal pools
#
#===================================================================================================
GID = {}
count = 0
for cell in cellsN:
	GID[cell] = range(count, count+cellsN[cell])
	count = count + cellsN[cell]

#===================================================================================================
#
# Generate for each instance of synapse for each GID from the postsynaptic pool, 
# the sample of Npre GIDs from the presynaptic pool
#
#===================================================================================================

f=open('parameters/conn.dat', 'w')

# Loop over all instances of synapses
for syn in synapses:
	
	# Loop over all poststnaptic GIDs
	for postGID in GID[syn['postCell']]:
	
		# Generate the sample from the presynaptic GIDs
		# if Npre== -1 mean that all presynaptic neurons will be connected to postsynaptic one 
		if syn['Npre']==-1:
		
			pre = GID[syn['preCell']]
		
		else:
		
			if syn['Npre'] > len(GID[syn['preCell']]):
			
				print "##################################\n\n\n\n\n"
				print "ERROR: too many presynaptic connections\n\n\n\n\n"
				print "##################################\n\n\n\n\n"
				
				exit()
				
			pre = random.sample(GID[syn['preCell']], syn['Npre'] )
		
		# Save the data into the file
		for i in pre:
			
			f.write("%d, %d, %d, %s, %s, %s\n" % (i, postGID, syn['globalID'], syn['preCell'], syn['postCell'], syn['synName']) )
			
f.close()
