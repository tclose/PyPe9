"""

    This module defines a base class for a neuron modelled in the NEURON simulator.
    

    @author Tom Close

"""

#######################################################################################
#
#        Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

# General imports
import collections
from neuron import h as nrn, init as nrn_init, \
    run as nrn_run
from test import Recording as Recording
import math
import numpy as np
import random
import string
try:
    import matplotlib.pyplot as plt
except:
    print "Could not import matplotlib, plotting functions will be disabled."

Connection = collections.namedtuple('Connection', 'synapse input netcon')
ArbitraryInput = collections.namedtuple('AribtraryInput', 'times amps neuron')
Location = collections.namedtuple('Location', 'section pos')

def _rand_string(num_chars):
    """
    Create a random string of hex digits
    
    @return [String]: String of hex digits
    """

    return "".join(random.sample([str(x) for x in range(9)] + list(string.letters), num_chars))


def _strip_id_string(name, num_chars):
    """
    Strips the id string of a section/cell down to the specified characters
    
    @param name [String]: Name to strip
    @param num_chars [int]: The number of characters to remain
    @return [String]: The stripped name
    """

    name_list = name.split('_')
    cell_type = name_list[0]
    id_string = name_list[1]
    sec_name = name_list[2]

    return "_".join([cell_type, id_string[:num_chars], sec_name])


def sec_name(sec, id_length= -1):
    """ 
    Returns a shortened version of the 

    @param id_length [int]: The number of id characters to display, if < 0 will display all of them        
    @return [String]: The name of the section
    """

    if id_length < 0:
        id_length = _BaseCell.ell.ID_STRING_LENGTH

    return _strip_id_string(sec.name(), id_length)


class _BaseCell(object):
    """
    The base cell object from which all cell types derive. Defines common functions such as calculating appropriate numbers
    of segments (compartments) per section, inserting receptors with arbitrary/Poisson input, etc. and sets up generic 
    lists to hold receptors, NetCons, NetStims and the like.
    
    Initialises only the soma section (in member 'self.soma'), all other morphology is defined by the derived classes.
    
    """

    #=====================================================================================================================
    # Initialisation of member variables
    #=====================================================================================================================

    ID_STRING_LENGTH = 10

    def __init__(self, cell_type, segment_length=None, verbose=False, name_sections=False):
        """
        Initialises the _BaseCell.cell for use in testing general functions, should not be called by derived functions _base_init()
        should be used instead.
        
        @param cell_type [String]: The type of the cell, used when automatically generating names for the cell instances (please don't put any underscores in it)
        @param segment_length [float]: The length of the segments within each section (factoring in rounding to the nearest odd number). If <= 0 the d_lambda rule is used to calculate the optimum section length see set_segment_length()
        @param verbose [bool]: If set debugging information is printed to the standard out stream.
        @param name_sections [bool]: If set the sections will be given sensible names, however this contradicts the use of "cell=self" in the construction of the soma, which is in turn required for connecting the Molecular layer (as of 15/12/11) so should only be used for test purposes with small number of cells
        """

        #===================================================================================================================
        # Set flags
        #===================================================================================================================

        ## Some 'setter' functions trigger recalculation of the number of segments to ensure the validity of the numerical simulation, the _initialised flag disables them until the cell is initialised
        self._initialised = False

        ## Prints debugging information to the screen during the construction of the model
        self._verbose = verbose


        #===================================================================================================================
        # Create lists and dictionaries to hold member HOC objects
        #===================================================================================================================

        ## list to hold all sections
        self._sections = list()

        ## A dictionary to reference all the receptors inserted into the cell
        self._receptors = list()

        ## A list of 'Connection' containing references to all the network connections inserted into the cell. @see Connection
        self._connections = list()

        ## A list containing references to all the network simulators (NetStims) inserted into the cell to simulate Poisson parallel fibre input
        self._poisson_stims = list()

        ## A list containing references to all the network simulators (NetStims) inserted into the cell to simulate barrages of parallel fibre input
        self._arbitrary_inputs = list()


        self._devices = list()

        #===================================================================================================================
        # Create Soma and set number of segments
        #===================================================================================================================

        ## Stores the cell type
        self._type = cell_type

        # Pick a name unlikely to be similar to any other names. Might try to test whether names exist so I don't need to use
        # such a long string of alphanumeric

        ## Stores whether to name the sections or let them be automatically generated by pyNEURON
        self._name_sections = name_sections

        if self._name_sections:
            ## Automatically generated name of the 
            self._name = cell_type + '_' + _rand_string(_BaseCell.ID_STRING_LENGTH)

            ## Soma of the neuron model
            self.soma = nrn.Section(name=self._name + '_soma')
        else:
            # The cell=self is used in the connection of the Python class to a GID, therefore name_sections should be False if
            # it is required. They are exclusive because it causes NEURON to quite suddenly if they are both used simulataneously
            # (to the best of my knowledge)
            self.soma = nrn.Section(cell=self)

            self._name = ''

        self._sections.append(self.soma)

        ## Holds the fixed length of the neuron segments. 
        self._segment_length = segment_length


    #=====================================================================================================================
    # Methods to set length and diameter properties of the cell 
    #=====================================================================================================================



    def inject_soma_current(self, amplitudes, times):
        """
        Injects an arbitrary current into the soma of the cell
        
        @param amplitudes [np.array]: The amplitudes of the current to be injected
        @param times [np.array]: The time points corresponding to the amplitudes vector
        """

        amp_v = nrn.Vector(amplitudes)
        times_v = nrn.Vector(times)

        curr_clamp = nrn.IClamp(self.soma(0.5))

        # Setting recording paradigm
        curr_clamp.delay = min(times)
        curr_clamp.dur = max(times)

        # "play" the input vector into current of the test cell
        amp_v.play(curr_clamp._ref_amp, times_v)

        self._devices.append((curr_clamp, amp_v, times_v))



    def name(self, id_length= -1):
        """
        Returns the automatically generated name of the cell
        
        @param id_length [int]: The number of id characters to display, if < 0 will display all of them
        @return [String]: The name of the cell
        """

        if id_length < 0:
            id_length = _BaseCell.ID_STRING_LENGTH

        return _strip_id_string(self._name, id_length)



    def soma_name(self, id_length= -1):
        """
        Returns the name of the soma
        
        @return [String]: The name of the soma
        """

        return _BaseCell.sec_name(self.soma, id_length)



    def _set_soma_morphology(self, length, diam):
        """
        Sets the length and diameter of the soma
        
        @param length [float]: Soma length (um)
        @param diam [float]: Soma diameter (um)
        """

        self.soma.L = length
        self.soma.diam = diam

        #If the neuron is already initialised recalculate the number of segments per section (kind of overkill to reset 
        #the whole tree but can't be bothered separating out soma section).
        if self._initialised:
            self.set_segment_length(self._segment_length)



    def _set_segment_length(self, segment_length=None, d_lambda=0.1, freq=100):
        """
        Sets the number of segments per branch either by explicit segment length (if segment_length > 0) or by the 
        "d_lambda" method as described in <a href="http://nro.sagepub.com/content/7/2/123.short">Hines and Carnevalle 2001</a>.
    
        @param segment_length [float]: The length of each section. If <= 0 the default d_lambda rule is used instead (see below)
        @param d_lambda [float]: The 'd_lambda' value (see reference)
        @param freq [float]: The frequency the length constant is calculated at for the "d_lambda" rule.
        @return [bool]: Whether the number of segments have been altered
        
        From the header of the original hoc code explaining the d_lambda rule:
            "Sets nseg in each section to an odd value so that its segments are no longer than
                d_lambda * the AC length constant at frequency freq in that section. Be sure to specify your own Ra and cm 
            
            To understand why this works, and the advantages of using an odd value for nseg,
                see    Hines, M.L. and Carnevale, N.T.
                     NEURON: a tool for neuroscientists.
                     The Neuroscientist 7:123 - 135, 2001."    
    
        """

        # Whether the number of segments have beed updated
        num_seg_updated = False

        #Check to see if number of segments needs to be recalculated
        if not self._initialised or not segment_length or self._segment_length != segment_length:

            if self._connections:
                raise Exception('Cannot recalculate number of segments as there are already connections attached to the receptors \
                                                    that will be relocated. NB: The number of segments per section is implicitly recalculated \
                                                    when the diameter, capacitance or axial resistance is changed, in the case that d_lambda \
                                                    rule is used, which is the default.')

            if self._initialised:
                print 'Recalculating number of segments per section for %s...' % self._name

            #Loop through all sections and set the number of segments according to the desired d_lambda fraction of the 
            #length constant of the specified frequency
            for sec in self._sections:

                if segment_length <= 0:
                    #Calculate the 'd_lambda' fraction of the length constant for the supplied frequency, given the sections axial resistance and capacitance
                    sec_segment_length = d_lambda * 1e5 * math.sqrt(sec.diam / (4 * math.pi * freq * sec.Ra * sec.cm))
                else:
                    sec_segment_length = segment_length

                #Set the number of segments so that the lenght of each section is a fraction, 'd_lambda' of the length constant. 
                sec.nseg = int((sec.L / sec_segment_length + 0.9) / 2) * 2 + 1

            #Save specified segment length for future reference
            self._segment_length = segment_length

            num_seg_updated = True

        return num_seg_updated



    def set_segment_length(self, segment_length=None, d_lambda=0.1, freq=100):
        """
        Wraps _set_segment_length() to allow derived classes to override just this method and add expressions to reset receptors
        that have been placed in the middle of segments if the segment lengths change to the core method.
         
        @param segment_length [float]: The length of each section. If <= 0 the default d_lambda rule is used instead (see below)
        @param d_lambda [float]: The 'd_lambda' value (see reference)
        @param freq [float]: The frequency the length constant is calculated at for the "d_lambda" rule.
        @return [bool]: Whether the number of segments have been altered
        """

        return self._set_segment_length(segment_length=segment_length, d_lambda=d_lambda, freq=freq)


    #=====================================================================================================================
    # Printing and Statistics
    #=====================================================================================================================



    def __str__(self, all_segments=False):
        """
        Converts the Purkinje cell into a string for printing and debugging
        
        @param all_segments [bool]: Print the values for all segments instead of the central
        """

        s = '\n---------------------\n'
        s = s + '            Purkinje            '
        s = s + '\n---------------------\n'

        if self._segment_length > 0:
            s = s + 'seg. length: ' + str(self._segment_length) + '\n'

        for sec in self._sections:
            s = s + str(sec.name()) + ':\n'
            s = s + '    nseg: ' + str(sec.nseg) + '\n'
            s = s + '    L: ' + str(sec.L) + '\n'
            s = s + '    Ra: ' + str(sec.Ra) + '\n'

            if not all_segments:
                print_segs = [sec(0.5)]
                s = s + '    middle segment:\n'
            else:
                print_segs = sec
                s = s + '    segments:\n'

            seg_i = 0

            for seg in print_segs:
                s = s + '        seg ' + str(seg_i) + ':\n'
                try:
                    s = s + '            Diam.: ' + str(seg.diam) + '\n'
                except:
                    pass
                try:
                    s = s + '            Mem. Capac.: ' + str(seg.cm) + '\n'
                except:
                    pass
                try:
                    s = s + '            Passive: g=' + str(seg.pas.g) + ' e=' + str(seg.pas.g) + '\n'
                except:
                    pass
                try:
                    s = s + '            Ih: g=' + str(seg.Ih.ghbar) + ' e=' + str(seg.Ih.eh) + '\n'
                except:
                    pass
                try:
                    s = s + '            Na: g=' + str(seg.Na.gbar) + 'resurge g=' + str(seg.Narsg.gbar) + ' e=' + str(seg.ena) + '\n'
                except:
                    pass
                try:
                    s = s + '            K: v1 g=' + str(seg.Kv1.gbar) + 'v4 g=' + str(seg.Kv4.gbar) + 'bin g=' + str(seg.Kbin.gbar) + ' e=' + str(seg.ek) + '\n'
                except:
                    pass
                try:
                    s = s + '            Ca: bk-type g=' + str(seg.CaBK.gkbar) + 'p-type g=' + str(seg.CaP.pcabar) + ' extern=' + str(seg.cao) + '\n'
                except:
                    pass
                try:
                    s = s + '            Leak: g=' + str(seg.leak.gbar) + ' e=' + str(seg.leak.e) + '\n'
                except:
                    pass
                seg_i = seg_i + 1

        return s



    def psection_all(self):
        """
        Prints all sections using NEURON's in-built 'psection()' to the standard output
        """

        print 'All sections\n---------------------\n'

        for sec in self._sections:

            nrn.psection(sec=sec)

        print '---------------------\n'



    def total_surface_area(self):
        """
        Determines the total surface area
        @return [float]: The total surface area (um^2)
        """

        surf_area = 0

        for sect in self._sections:
            surf_area = surf_area + sect.diam * sect.L

        return surf_area * math.pi



    def input_resistance(self, stim_amp= -0.05, stim_delay=10000, stim_dur=10000, buffer_time=5000, plot=False, peak=False):
        """
        Calculates the input resistance of the Purkinje model as per Roth and Hausser 2001
        
        @param stim_amp [float]: The amplitude of the current stimulus (nA)
        @param stim_delay [float]: The delay before stimulating (ms)
        @param stim_dur [float]: The duration of the stimulation and the following unstimulated periods (ms)
        @param buffer_time [float]: The time allowed for transients to decay after the stimulation starts and stops (ms)
        @param plot [bool]: If set the voltage traces are plotted for sanity check, otherwise just the estimated values are returned
        @param peak [bool]: If set the peak voltage for comparison is used instead of the steady state during the pulse
        
        @return [float]: The input resistance (MOhms) 
        """

        stim = nrn.IClamp(self.soma(0.5))
        stim.amp = stim_amp
        stim.delay = stim_delay
        stim.dur = stim_dur

        end_time = stim.delay + stim.dur * 2

        time_v = nrn.Vector()
        time_v.record(nrn._ref_t)

        voltage_v = nrn.Vector()
        voltage_v.record(self.soma(0.5)._ref_v)

        nrn.finitialize(-65)
        nrn_init()
        nrn_run(end_time)

        times = np.array(time_v)
        voltages = np.array(voltage_v)

        on_indices = np.nonzero(np.logical_and(times > (stim.delay + buffer_time), times <= (stim.delay + stim.dur)))
        off_indices = np.nonzero(times > (stim.delay + stim.dur + buffer_time))

        if peak:
            input_R = (np.min(voltages) - np.average(voltages[off_indices])) / stim_amp
        else:
            input_R = (np.average(voltages[on_indices]) - np.average(voltages[off_indices])) / stim_amp

        if plot:
            try:

                plt.figure()
                plt.plot(times, voltages)
                plt.show()
            except:
                print "Could not import matplotlib, so could not plot input resistance"

        return input_R



    def time_constant(self, stim_amp= -0.2, stim_delay=4000, stim_dur=.5, exp_time=1000, volt_tolerance=0.01, time_tolerance=100, plot=False):
        """
        Calculates the time constant of the Purkinje model as per Roth and Hausser 2001. WARNING!! Not sure if this is the 
        correct way to calculate the time_constant and/or useful.
        
        @param stim_amp [float]: The amplitude of the current stimulus (nA)
        @param stim_delay [float]: The delay before stimulating (ms)
        @param stim_dur [float]: The duration of the stimulation and the following unstimulated periods (ms)
        @param exp_time [float]: The time after the stimulation to record for
        @param volt_tolerance [float]: Defines the voltage range (i.e. +-volt_tolerance) over which the voltage trace is considered to intersect with the calculated decay point (mV)
        @param time_tolerance [float]: Defines the time period over which the baseline voltage is calculated (ms)
        @param plot [bool]: If set the voltage traces will be plotted for sanity check, otherwise just the value will be returned.
        @return [float]: The time constant of the neuron (ms)
        """

        stim = nrn.IClamp(self.soma(0.5))
        stim.amp = stim_amp
        stim.delay = stim_delay
        stim.dur = stim_dur

        end_time = stim.delay + stim.dur + exp_time

        time_v = nrn.Vector()
        time_v.record(nrn._ref_t)

        voltage_v = nrn.Vector()
        voltage_v.record(self.soma(0.5)._ref_v)

        nrn.finitialize(-65)
        nrn_init()
        nrn_run(end_time)

        times = np.array(time_v)
        voltages = np.array(voltage_v)

        baseline = np.average(voltages[np.nonzero(np.logical_and(times > (stim_delay - time_tolerance), times < stim_delay))])
        peak = np.max(voltages)

        decay_point = (peak - baseline) * math.exp(-1) + baseline

        time_of_peak = times[np.nonzero(voltages == peak)]
        decay_time = np.average(times[np.nonzero(np.logical_and(voltages > decay_point - volt_tolerance, voltages < decay_point + volt_tolerance))])

        tau = decay_time - time_of_peak[0]

        if plot:
            try:
                plt.figure()
                plt.plot(times, voltages)
                plt.show()
            except:
                print "Could not import matplotlib, so could not plot input resistance, set 'plot' parameter to false."

        return tau



    #=====================================================================================================================
    # Methods to set the electrical properties of the cell
    #=====================================================================================================================



    def _set_membrane_capacitance(self, cm):
        """
        Sets the capacitance for each section of the neuron.
        
        @param cm [float]: Membrane capacitance (F/cm^2)
        """

        for sec in self._sections:
            sec.cm = cm

        #If the cell is already initialised recalculate the number of segments per section.
        if self._initialised:
            self.set_segment_length(self._segment_length)

        return self



    def _set_passive_conductance(self, rm):
        """
        Sets the membrane for each section of the neuron.
        
        @param rm [float]: Membrane resistance (Ohm    cm^2)
        """

        g = rm

        for sec in self._sections:

            # Test to see if the current section has an passive conductance, if not add them
            try:
                tmp = sec.pas #@UnusedVariable, used only to test if the section is present or not
            except AttributeError:
                sec.insert('pas')

            for seg in sec:
                seg.pas.g = g

        return self



    def _set_axial_resistance (self, ra):
        """
        Sets the resistance for each section of the neuron.
        
        @param ra [float]: Axial (or intracellular) resistance (Ohm cm)
        """

        for sec in self._sections:
            sec.Ra = ra

        #If the cell is already initialised recalculate the number of segments per section.
        if self._initialised:
            self.set_segment_length(self._segment_length)

        return self



    #=====================================================================================================================
    # Methods to add receptors and stimulate them
    #=====================================================================================================================



    def _insert_exp2syn_receptor(self, sec, pos, rise_t, decay_t, reverse_v):
        """
        Inserts a Exp2Syn receptor into a section of the Purkinje cell
        
        @param sec [nrn.Section]: Section in which to insert the receptor (must belong to the same purkinje object)
        @param rise_t [float]: Rise time constant (ms)
        @param decay_t [float]: Decay time constant (ms)
        @param reverse_v [float]: Reversal potential (mV)
        @param pos [float]: Position along the section to insert the receptor
        
        @return [tuple(nrn.Exp2Syn,Location)]: A 2-tuple containing Reference to the inserted receptor and its location
        """

        if self._verbose:
            print 'Inserting receptor at ' + str(sec.name()) + ', position: ' + str(pos)

        if sec not in self._sections:
            raise Exception ('Given section does not belong to this Purkinje instance')

        #Insert receptor as specified position along the given section
        receptor = nrn.Exp2Syn(pos, sec=sec)
        receptor.tau1 = rise_t
        receptor.tau2 = decay_t
        receptor.e = reverse_v

        loc = Location(sec, pos)

        #Append receptor to list and dictionary
        self._receptors.append(receptor)

        return (receptor, loc)



    def insert_mechanism(self, mech_name):
        """
        Inserts a mechanism into the cell
        
        @param mech_name [String]: Mechanism name
        """
        print 'inserting ' + mech_name
        for sec in self._sections:

            # Test to see if the current section has an 'h' current, if not add one
#            try:
#                eval('tmp = sec.' + mech_name)
#            except AttributeError:
            sec.insert(mech_name)

        return self



    def get_receptors(self):
        """ 
        Returns a list of all receptors inserted into the cell
        
        @return [list(nrn.*Syn)]: List of receptors connected to the cell
        """

        return self._receptors()



    def clear_receptors(self):
        """ Clears all receptors"""

        self._receptors = list()



    def _poisson_stimulation(self, receptor, spike_start, weight, num_spikes, spike_interval, randomness):
        """
        Adds a spike train to a given receptor.
        
        @param receptor [nrn.Exp2Syn]: The receptor to provide input to (must belong to the given Purkinje cell)
        @param spike_start [float]: Time when the spike(s) begin (ms)
        @param weight [float]: The peak conductance assigned to the receptor during its connection (uS) 
        @param num_spikes [int]: The number of spikes to input
        @param spike_interval [float]: The mean time interval between spikes (ms)
        @param randomness [float]: How deterministic the spike interval is (0 deterministic, 1 random)
        
        @return [tuple(nrn.NetCon,nrn.NetStim)]: Connection and stimulation NEURON objects
        """

        if self._verbose:
            print 'Stimulating receptor with weight ' + str(weight)

        if receptor not in self._receptors:
            raise Exception ('Synapse does not belong to this Purkinje cell')

        # Create the net stim to the purkinje cell
        stim = nrn.NetStim()

        stim.start = spike_start #start
        stim.number = num_spikes # number
        stim.interval = spike_interval # mean interval
        stim.noise = randomness # level of randomness (0 deterministic, 1 poisson)

        # Connect the net stim to the receptor and set its weight
        netcon = nrn.NetCon(stim, receptor)

        # Set the weight of the receptor
        netcon.weight[0] = weight

        connection = Connection(receptor, stim, netcon)

        #Append the connections and stimulations to the purkinje object (required otherwise they will go out of scope and be destroyed)
        self._poisson_stims.append(stim)
        self._connections.append(connection)

        return connection



    def _set_connection_weights(self, mean, stddev):
        """
        Reset the synaptic weights for all synaptic stimulations attached to the Purkinje
        
        @param mean [float]: The mean of the weights
        @param stddev [float]: The standard deviation of the weights
        """

        for connection in self._connections:
            connection.netcon.weight[0] = random.gauss(mean, stddev)



    def _clear_receptors_and_stims(self):
        """
        Clears all receptors, connections and stimulations
        """

        self._receptors = list()
        self._connections = list()
        self._poisson_stims = list()
        self._arbitrary_inputs = list()



    def set_spike_trains(self, spike_trains, weights, receptors, spike_width=1, spike_on=50, spike_off= -70):
        """
        Stimulate the cell receptors with arbitrary trains of spikes.
        
        @param spike_trains [list[N](np.array(float))]: List of N spike trains to stimulate the purkinje receptors.
        @param weights [np.array[N](float)]: N Weights assigned to each connection
        @param receptors [list[N](nrn.Exp2syn)]: N receptors to connect the spike trains to. If left empty they are randomly selected from the self.receptors list.
        @param spike_width [float]: The width of the spikes
        @param spike_on [float]: Voltage of the input neuron membrane, when a spike is to have occured (mV)
        @param spike_off [float]: Voltage of the input neuron membrane, when a spike is not occuring (mV)
        """

        num_trains = len(spike_trains)

        if len(weights) != num_trains:
            raise Exception ('Length of synaptic weights (' + str(len(weights)) + ') does not match that of spike times (' + str(num_trains) + ')')

        if len(receptors) != num_trains:
            raise Exception ('Length of receptors (' + str(len(receptors)) + ') does not match that of spike times (' + str(num_trains) + ')')


        for (spike_train, weight, receptor) in zip(spike_trains, weights, receptors):

            if receptor not in self._receptors:
                raise Exception ("Provided receptor does not belong to this neuron")

            num_spikes = len(spike_train)

            # Create an "input neuron" (a basic section) to drive the receptor
            input_neuron = nrn.Section() #name=self._name + '_arbitrary_input_' + str(len(self._arbitrary_inputs)))

            # Create NEURON Nx2 arrays (to be flattened into 2Nx1 vectors) to hold the spike 'on' and 'off' times and values
            times_arr = np.zeros((num_spikes, 2))
            input_arr = np.zeros((num_spikes, 2))

            # Set the 'on' times for the 
            times_arr[:, 0] = sorted(spike_train)
            times_arr[:, 1] = times_arr[:, 0] + spike_width

            input_arr[:, 0] = spike_on
            input_arr[:, 1] = spike_off

            times_v = np.zeros((2 * num_spikes + 1))
            input_v = np.zeros((2 * num_spikes + 1))

            times_v[0] = 0
            times_v[1:(2 * num_spikes + 1)] = times_arr.flatten()

            input_v[0] = spike_off
            input_v[1:(2 * num_spikes + 1)] = input_arr.flatten()

            times_vector = nrn.Vector(times_v)
            input_vector = nrn.Vector(input_v)

            # "play" the spike time vectors into the state of the integrate-and-fire input neuron
            input_vector.play(input_neuron(0.5)._ref_v, times_vector)

            # Connect the new netcon to the same receptor as the original poisson connection
            netcon = nrn.NetCon(input_neuron(0.5)._ref_v, receptor, sec=input_neuron)

            # Set the same weight for the connection as the original poisson connection
            netcon.weight[0] = weight

            # Append all created objects to the Purkinje neuron to prevent them going out of scope and getting destroyed
            self._arbitrary_inputs.append(ArbitraryInput(times_vector, input_vector, input_neuron))
            self._connections.append(Connection(receptor, input_neuron, netcon))



    def set_barrage_input(self,
                                                barrage_times,
                                                num_stims,
                                                weights,
                                                receptors,
                                                barrage_fractions=list(),
                                                spike_start=3000,
                                                spike_dur=5000,
                                                spike_freq=1):
        """
        Loads the Purkinje model, populates its leaves with poisson synaptic stimulations with occasional barrages of simultaneous
        input and plots the voltage traces in the leaves and at the soma.
        
        @param barrage_times [list(float)]: The fraction of neurons active during the barrage
        @param num_stims [int]: The number stimulations to be placed on the Purkinje leaves (corresponds to number of "modelled receptors")
        @param weights [list[N](float)]: The synaptic weights applied to each of the "modelled receptors"
        @param receptors [list[N](nrn.Exp2Syn)]: The list of "NEURON receptors" on which to attach the "modelled receptors"
        @param barrage_fractions [list(float)]: The fraction of neurons active during the barrage
        @param spike_start [float]: The start of the stimulation (ms)
        @param spike_dur [float]: The length of the spike recording (ms)
        @param spike_freq [float]: Spike frequency (Hz)
        @param active [bool]: If set, active properties are included in the Purkinje cell
        @return [simulation.Recording]: The "Recording" tuple @see simulation.Recording
        """

        total_time = spike_start + spike_dur

        num_barrages = len(barrage_times)

        if not len(barrage_fractions):
            for barr_i in xrange(num_barrages): #@UnusedVariable 'barr_i'
                barrage_fractions.append(1.0)

        # Calculate the mean interval between spikes based on the spiking frequency
        spike_interval = 1000 / spike_freq

        # For each barrage time create a list (i.e. create a list of lists)
        selected_synapses = list()
        for barrage_fraction in barrage_fractions:
            # Determine the number of stimulations (modelled receptors) to be recruited in the barrage
            num_receptors = int(round(barrage_fraction * num_stims))
            selected = random.sample(range(num_stims), num_receptors)
            selected_synapses.append(selected)


        # A list containing the spike train for each input
        spike_trains = list()

        # Create the number 
        for stim_i in xrange(num_stims): #@UnusedVariable

            # Initialise the numpy array to a size that should be comfortably larger than the required 
            spike_train = list()

            #Initialise the spike time at the start of the simulation
            time = spike_start

            while time <= total_time:
                # Get the next spike time from the exponential distribution triggered from the previous spike
                spike_time = time + random.expovariate(1.0 / spike_interval)

                # Check to see if a barrage occurs before the spike_time and if so set the spike time to that
                for barrage_i in xrange(num_barrages):
                    barrage_time = barrage_times[barrage_i]

                    if barrage_time > time and barrage_time <= spike_time and stim_i in selected_synapses[barrage_i]:
                        spike_time = barrage_time
                        break

                spike_train.append(spike_time)
                time = spike_time

            # Remove the last element that will lie outside the record time
            spike_train.pop()

            # Append the spike train for the current stim to the list spike trains
            spike_trains.append(np.array(spike_train))

        # Set the spike trains
        self.set_spike_trains(spike_trains, weights, receptors)



def simulate(run_time, initial_v= -65, record_v=list(), record_i=list(), record_m=list()):
    """
    Runs the simulation and records the specified locations, returning them in numpy arrays contained within a 
    named Tuple ('Recording') along with legends to be used for plotting. Rows of the np.arrays correspond to 
    different recording locations, and columns correspond to common time points in the simulation.
    
    @param run_time [float]: Length of the run
    @param initial_v [float]: The initial voltage for the simulation
    @param record_v [list(tuple(nrn.Section,float))]: List of nrn.Sections to record voltage from
    @param record_i [list(nrn.*Syn)]: List of nrn.*Syn to record from (should be added with 'poisson_stimulation()').
    @param record_m [list(nrn.IntFire*)]: List of nrn.IntFire* from which to record their states.
    @param record_times [list(float)]; Times to record into the recording list. If none then return all the recording.
    
    @return [Recording]: Returns the recorded voltages, currents and states in a named tuple
    """

    num_volt_rec = len(record_v)
    num_current_rec = len(record_i)
    num_state_rec = len(record_m)

    if not num_volt_rec and not num_current_rec and not num_state_rec:
        raise Exception ('No recordings specified (see input parameters ''record_v'', ''record_i'', and ''record_m'')')

    # Record Time from NEURON (nrn._ref_t)
    time = nrn.Vector()
    time.record(nrn._ref_t)

    # Set up recordings from the list of sections to record voltages from
    volt_rec = list()
    volt_legend = list()

    count = 0;
    for (sec, pos) in record_v:

        # Record Voltage from the soma
        volt_rec.append(nrn.Vector())
        volt_rec[len(volt_rec) - 1].record(sec(pos)._ref_v)
        volt_legend.append('Voltage: %d' % count)
#        volt_legend.append(sec_name(sec, 2) + ':' + str(pos))
#        count = count + 1

    # Set up recordings from the list of sections to record voltages from
    current_rec = list()
    curr_legend = list()

    count = 0;
    for syn in record_i:

        # Record Voltage from the soma
        current_rec.append(nrn.Vector())
        current_rec[len(current_rec) - 1].record(syn._ref_i)
        curr_legend.append('Current: %d' % count)
        count = count + 1

    state_rec = list()
    state_legend = list()


    count = 0;
    for intfire in record_m:
        state_rec.append(nrn.Vector())
        state_rec[len(state_rec) - 1].record(intfire._ref_m)
        state_legend.append('Input neuron: %d' % count)
        count = count + 1



    # Initialises the neuron environment 
    nrn.finitialize(initial_v)
    nrn_init()
    nrn_run(run_time)

    # get values for times from NEURON vectors format into Python format
    times = np.array(time)
    time_length = times.shape[0]

    # get values for voltages from NEURON vectors format into Python format
    voltages = np.zeros((time_length, num_volt_rec))

    for sec_i in range(num_volt_rec):
        voltages[:, sec_i] = np.array(volt_rec[sec_i])

    # get values for synaptic current from NEURON vectors format into Python format
    currents = np.zeros((time_length, num_current_rec))

    for sec_i in range(num_current_rec):
        currents[:, sec_i] = np.array(current_rec[sec_i])

    # get values for synaptic state from NEURON vectors format into Python format
    states = np.zeros((time_length, num_state_rec))

    for sec_i in range(num_state_rec):
        states[:, sec_i] = np.array(state_rec[sec_i])

    #Return times, voltages, currents, states, volt_legend, curr_legend, state_legend in a namedtuple
    return Recording(times, voltages, currents, states, volt_legend, curr_legend, state_legend)
