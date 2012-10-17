#!/usr/bin/env python
"""
  This script is used to test out the creation of a network using the MyModule cell class

  @author Tom Close
  @date 17/9/2012
"""
#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import os.path
from ninemlp.nest import * #@UnusedWildImport
# Get the xml location
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
network_xml_location = os.path.join(PROJECT_PATH, 'xml', 'cerebellum', 'single_test.xml')
print "Building network"
net = Network(network_xml_location,0.0025, min_delay=0.005, max_delay=2.0) 
print "Starting run"
run(1000) 
end() 
print "Simulated single cell for %f milliseconds" % 1000
