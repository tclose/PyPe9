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
import ninemlp
from ninemlp.connectivity.morphology import read_NeurolucidaXML
#from ninemlp.common.ncml import read_MorphML, read_NCML
# Get the xml location
#CELL_ID = 'Golgi'
#XML_FILENAME = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..', 'xml', 'cerebellum', 'ncml',
#                                             CELL_ID + '.xml'))
#morphml = read_MorphML(CELL_ID, XML_FILENAME)
#ncml = read_NCML(CELL_ID, XML_FILENAME)
#print morphml
#print ncml
XML_FILENAME = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..', 'morph', 'Purkinje', 'xml',
                                             'GFP_P60.1_slide7_2ndslice-HN-FINAL.xml'))
neurolucida_xml = read_NeurolucidaXML(XML_FILENAME)
print neurolucida_xml
