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
from numpy import *
import os
import sys

filename = sys.argv[2]

if os.path.exists("data/"+filename+".dat"):
	
	print "Calculating psd"
	data = pylab.load("data/"+filename+".dat")
	data2 = data[data[:,0].__ge__(1000), 2]
	data5 = data[data[:,0].__ge__(1000), 5]
	
	data = data2[arange(1, len(data2), 1)]
	
	n = 1 << int(pylab.ceil(log2(len(data))) - 3)
	
	
	a,b=pylab.mlab.psd(data, n, 40000, window=hamming(n), noverlap=int(250/0.025))
#	a,b=pylab.mlab.psd(data, n, Fs=40000)
	pylab.plot(b[2:],a[2:], color='r')
	theta = a[logical_and(b.__ge__(8), b.__le__(12) )].mean()
	beta =  a[logical_and(b.__ge__(12), b.__le__(20) )].mean()
	gamma =  a[logical_and(b.__ge__(20), b.__le__(50) )].mean()
	print theta
	print beta
	print gamma
	pylab.bar([10, 16, 35], [theta,beta,gamma], color='r')
#	pylab.psd(data, noverlap=(250*2) ,window=hamming(500*2), NFFT=n, Fs=2000)
	pylab.gca().set_xlim([0,80]) 

#pylab.plot( data[data[:,0].__ge__(1000),0], data[data[:,0].__ge__(1000),5] )
	
	
#	DATA5
	data = data5[arange(1, len(data5), 1)]
	
	n = 1 << int(pylab.ceil(log2(len(data))) - 3)
	
	
	a,b=pylab.mlab.psd(data, n, 40000, window=hamming(n), noverlap=int(250/0.025))
#	a,b=pylab.mlab.psd(data, n, Fs=40000)
	pylab.plot(b[2:],a[2:], color='b')
	theta = a[logical_and(b.__ge__(8), b.__le__(12) )].mean()
	beta =  a[logical_and(b.__ge__(12), b.__le__(20) )].mean()
	gamma =  a[logical_and(b.__ge__(20), b.__le__(50) )].mean()
	print theta
	print beta
	print gamma
	pylab.bar([10+2, 16+2, 35+2], [theta,beta,gamma], color='b')
#	pylab.psd(data, noverlap=(250*2) ,window=hamming(500*2), NFFT=n, Fs=2000)
	pylab.gca().set_xlim([0,80]) 

	#pylab.plot( data[data[:,0].__ge__(1000),0], data[data[:,0].__ge__(1000),5] )
	
	
	# SAVE PNG
	pylab.savefig('spectrogram')

	if len(sys.argv)>1:
		
		pylab.show()
		
else:

	print "No pyr.dat file!"