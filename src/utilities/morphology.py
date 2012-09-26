#!/usr/bin/env python
"""
Contains a methods to generate MorphML from more general requests

@author Tom Close
@date 26/9/2012

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

from math import sin, cos, pi
import numpy as np

def create_cable(id_prefix, diam, length, num_segs, parent_id, 
            origin=(0.0, 0.0, 0.0), orient=(0.0, 0.0), save_location=None, segment_group=None):
    """
    Generates a chain of segments in MorphML format given parameters for a straight section of 
    cabling with multiple segments
    
    @param id_prefix [str]: Prefix to prepend to the number of the segment
    @param diam [float]: Diameter of the generated cable
    @param length [float]: Length of the generated cable
    @param num_segs [int]: Number of segments along the generated cable
    @param parent_id [str]: ID of the parent segment to connect the cable to
    @param origin [float(3)]: Coordinates of the point which the cable originates from 
    @param orient [float(3)]: The orientation of the cable in (azimuth, elevation) format in degrees
    @param save_location [str]: Optional place to save a location
    """
    azimuth = orient[0] * 2.0 * pi / 360.0
    elevation = orient[1] * 2.0 * pi / 360.0    
    seg_vector = np.array((cos(azimuth)*cos(elevation), sin(azimuth)*cos(elevation), sin(elevation))) * length / float(num_segs)
    origin=np.array(origin)
    if save_location:
        try:
            f = open(save_location, 'w')
        except IOError as e:
            raise Exception('Could not open ''{0}'' file for writing. {1}'.format(save_location, e))
    for seg_i in xrange(num_segs):
        seg_id = id_prefix + str(seg_i)
        distal = origin + seg_vector * float(seg_i+1)
        line = """<segment id="{id}">
    <parent segment="{parent_id}" />
    <distal x="{x}" y="{y}" z="{z}" diameter="{diam}" />
</segment>""".format(id=seg_id, parent_id=parent_id, x=round(distal[0],4), y=round(distal[1],4), z=round(distal[2],4), diam=diam)
        if save_location:
            f.write(line)
        else:
            print line
        parent_id = seg_id
        
    if segment_group:
        line = '<segmentGroup id="{0}">'.format(segment_group)
        if save_location:
            f.write(line)
        else:
            print line
        for seg_i in xrange(num_segs):
            seg_id = id_prefix + str(seg_i)
            distal = origin + seg_vector * float(seg_i+1)
            line = '    <member segment="{0}" />'.format(seg_id)
            if save_location:
                f.write(line)
            else:
                print line
        line = '</segmentGroup>'
        if save_location:
            f.write(line)
        else:
            print line
