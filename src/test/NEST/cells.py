"""

    This module defines a base class for a neuron modelled in the NEST simulator.
    
    @author Tom Close

"""

#######################################################################################
#
#        Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#        NB: The code in "def inject_soma_current()" is derived from the PyNN Trac 
#                repository "root/trunk/src/nest/electrodes.py@691"
#
#
#######################################################################################


from test.NEST import _BaseCell

class OneCompartmentCell(_BaseCell):
    """
    Just a stub at this stage
    """

    def __init__(self, mech_name):

        _BaseCell.__init__(self, mech_name)


