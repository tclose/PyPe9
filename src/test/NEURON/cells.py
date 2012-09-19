"""

    This module defines a base class for a neuron modelled in the NEURON simulator.
    

    @author Tom Close

"""

#######################################################################################
#
#        Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

from test.NEURON import _BaseCell
import neuron

#=====================================================================================================================
# Morphology Params
#===================================================================================================================== 


## Default value for the mean of the soma diameter (um) FIXME: NEEDS TO BE TUNED!!
SOMA_DIAMETER = 17.5

## Default value for the mean of the soma length (um) FIXME: NEEDS TO BE TUNED!!
SOMA_LENGTH = 15


#=====================================================================================================================
# Passive Property Params
#=====================================================================================================================

## Default value for the passive conductance (S/cm^2). FIXME: NEEDS TO BE TUNED!!
PASSIVE_CONDUCTANCE = 0.000375

## Default value for the membrane capacitance (uF/cm^2)  FIXME: NEEDS TO BE TUNED!!
MEMBRANE_CAPACITANCE = 0.77

## Default value for the axial resistance (uF/cm^2) FIXME: NEEDS TO BE TUNED!!
AXIAL_RESISTANCE = 115.0


#=====================================================================================================================
# Synaptic Params
#=====================================================================================================================

## Default value for the synaptic rise time (ms) of the double exponential model FIXME: NEEDS TO BE TUNED!!
SYNAPSE_RISE_TIME = 0.5

## Default value for the synaptic decay time (ms) of the double exponential model FIXME: NEEDS TO BE TUNED!!
SYNAPSE_DECAY_TIME = 1.2

## Default value for the synaptic reversal potential (of the double exponential model) FIXME: NEEDS TO BE TUNED!!
PF_SYNAPSE_REVERSE_POTENTIAL = 0.0

## Default value for the peak synaptic conductance mean (uS) of the double exponential model FIXME: NEEDS TO BE TUNED!!
SYNAPSE_PEAK_CONDUCTANCE = 0.0007

## Default value for the peak synaptic conductance standard deviation (uS) of the double exponential model FIXME: NEEDS TO BE TUNED!!
SYNAPSE_PEAK_CONDUCTANCE_STDDEV = 0

## Default value for the total number of synapses to simulate. FIXME: NEEDS TO BE TUNED!!
NUM_SIMULATED_SYNAPSES = 1000



class OneCompartmentCell(_BaseCell):

    #=====================================================================================================================
    # Initialisation of member variables
    #=====================================================================================================================


    def __init__(self, mech_names, usetables=None, segment_length=None, verbose=False, name_sections=True, init_vars=[]):
        """
        Initialises the _BaseCell cell for use in testing general functions, should not be called by derived functions _base_init()
        should be used instead.
        """

        _BaseCell.__init__(self, 'Test', segment_length=segment_length, verbose=verbose, name_sections=name_sections)

        ## Set soma morphology using defaults
        self.set_soma_morphology()

#        self.set_passive_conductance() Shouldn't be included by default as some models have their own mechanisms for this
        self.set_membrane_capacitance()
        self.set_axial_resistance()

        #If 'None', the number of segments is determined from the d_lambda rule as describe in the NEURON book by Hines and Carnevale 2001
        self.set_segment_length(segment_length)

        for mech_name in mech_names:
            self.insert_mechanism(mech_name)
            if not usetables:
                neuron.h('usetable_%s = 0' % mech_name, sec=self.soma)

        for init_var in init_vars:
            setattr(self.soma, init_var[0], float(init_var[1]))

        # Set initialised to true (needs to be set to False again in derived base classes)
        self._initialised = True

    #=====================================================================================================================
    # Wrap _BaseCell Methods, providing default parameters from py
    #=====================================================================================================================



    def set_membrane_capacitance(self, cm=MEMBRANE_CAPACITANCE):
        """
        Sets the capacitance for each section of the neuron. Wraps _set_membrane_capacitance() providing default parameters
        from py module
        
        @param cm [float]: Membrane capacitance (F/cm^2)
        """

        return self._set_membrane_capacitance(cm=cm)



    def set_passive_conductance(self, rm=PASSIVE_CONDUCTANCE):
        """
        Sets the membrane for each section of the neuron. Wraps _set_passive_conductance() providing default parameters
        from py module
        
        @param rm [float]: Membrane resistance (Ohm    cm^2)
        """

        return self._set_passive_conductance(rm=rm)



    def set_axial_resistance (self, ra=AXIAL_RESISTANCE):
        """
        Sets the resistance for each section of the neuron. Wraps _set_axial_resistance() providing default parameters
        from py module
        
        @param ra [float]: Axial (or intracellular) resistance (Ohm cm)
        """

        return self._set_axial_resistance(ra=ra)



    def insert_receptor(self, sec, pos=0.5, rise_t=SYNAPSE_RISE_TIME, decay_t=SYNAPSE_DECAY_TIME, reverse_v=PF_SYNAPSE_REVERSE_POTENTIAL):
        """
        Inserts a receptor into a section of the Purkinje cell. Wraps _insert_receptor() providing default parameters
        from py module
        
        @param sec [nrn.Section]: Section in which to insert the receptor (must belong to the same purkinje object)
        @param rise_t [float]: Rise time constant (ms)
        @param decay_t [float]: Decay time constant (ms)
        @param reverse_v [float]: Reversal potential (mV)
        @param pos [float]: Position along the section to insert the receptor
        
        @return [nrn.Exp2Syn]: A Reference to the inserted receptor
        """

        return self._insert_receptor(sec=sec, pos=pos, rise_t=rise_t, decay_t=decay_t, reverse_v=reverse_v)



    def poisson_stimulation(self, receptor, spike_start, weight=SYNAPSE_PEAK_CONDUCTANCE, num_spikes=1, spike_interval=50, randomness=0):
        """
        Adds a spike train to a given receptor.    Wraps _poisson_stimulation() providing default parameters
        from py module
        
        @param receptor [nrn.Exp2Syn]: The receptor to provide input to (must belong to the given Purkinje cell)
        @param spike_start [float]: Time when the spike(s) begin (ms)
        @param weight [float]: The peak conductance assigned to the receptor during its connection (uS) 
        @param num_spikes [int]: The number of spikes to input
        @param spike_interval [float]: The mean time interval between spikes (ms)
        @param randomness [float]: How deterministic the spike interval is (0 deterministic, 1 random)
        
        @return [tuple(nrn.NetCon,nrn.NetStim)]: Connection and stimulation NEURON objects
        """

        return self._poisson_stimulation(receptor=receptor, spike_start=spike_start, weight=weight, num_spikes=num_spikes, spike_interval=spike_interval, randomness=randomness)



    def set_poisson_stimulations(self,
                                                                spike_start,
                                                                number=NUM_SIMULATED_SYNAPSES,
                                                                weight_mean=SYNAPSE_PEAK_CONDUCTANCE,
                                                                weight_stddev=SYNAPSE_PEAK_CONDUCTANCE_STDDEV,
                                                                num_spikes=100,
                                                                spike_interval=50,
                                                                randomness=1):

        """
        Adds the specified number of stimulation sources to the receptors found on the tree. The stimulations are uniformly 
        distributed across all sections of all leaves.    Wraps _set_poisson_stimulations() providing default parameters
        from py module
        
        @param number [int]: The number of stimulation sources to attach to the tree.
        @param weight_mean [float]: The mean of the peak conductances assigned to the receptors
        @param weight_stddev [float]: The standard deviation of the peak conductances assigned to the receptors        
        @param spike_start [float]: Time when the spike(s) begin (ms)
        @param num_spikes [int]: The number of spikes to input
        @param spike_interval [float]: The mean time interval between spikes (ms)
        @param randomness [float]: How deterministic the spike interval is (0 deterministic, 1 random)
        """

        self._set_poisson_stimulations(spike_start=spike_start, number=number, weight_mean=weight_mean, weight_stddev=weight_stddev,
                                                                     num_spikes=num_spikes, spike_interval=spike_interval, randomness=randomness)



    def set_poisson_weights(self, mean=SYNAPSE_PEAK_CONDUCTANCE, stddev=SYNAPSE_PEAK_CONDUCTANCE_STDDEV):
        """
        Reset the synaptic weights for all synaptic stimulations attached to the cell. Wraps _set_poisson_stimulations() 
        providing default parameters from py module
        
        @param mean [float]: The mean of the weights
        @param stddev [float]: The standard deviation of the weights
        """

        self._set_connection_weights(mean=mean, stddev=stddev)



    def set_soma_morphology(self, length=SOMA_LENGTH, diam=SOMA_DIAMETER):
        """
        Sets the length and diameter of the soma
        
        @param length [float]: Soma length (um)
        @param diam [float]: Soma diameter (um)
        """

        self._set_soma_morphology(length, diam)

