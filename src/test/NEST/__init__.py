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

from copy import deepcopy
from test import Recording
import nest
import numpy as np

class _BaseCell:
    """
    Just a stub at this stage
    """

    def __init__(self, cell_type):
        """Initialises the base cell"""

        self.id = nest.Create(cell_type)[0]



    def inject_soma_current(self, amplitudes, times):
        """
        Injects an arbitrary current into the soma of the cell
        
        @param amplitudes [np.array]: The amplitudes of the current to be injected
        @param times [np.array]: The time points corresponding to the amplitudes vector
        """

        self._dc_source = nest.Create('step_current_generator')

        amplitudes_cpy = deepcopy(amplitudes)
        times_cpy = deepcopy(times)

        # A work around for a bug in NEST
        try:
            times_cpy.append(1e12)
        except AttributeError:
            np.append(times_cpy, 1e12)
        try:
            amplitudes_cpy.append(amplitudes_cpy[-1])
        except AttributeError:
            np.append(amplitudes_cpy, amplitudes_cpy[-1])


        nest.SetStatus(self._dc_source, {'amplitude_times': np.array(times_cpy, 'float'),
                                        'amplitude_values': 1000.0 * np.array(amplitudes_cpy, 'float')})


        nest.Connect(self._dc_source, [self.id])




def simulate(run_time, initial_v=None, record_v=list(), record_i=list(), record_m=list()): #@UnusedVariable
    """
    Runs the simulation and records the specified locations, returning them in numpy arrays contained within a 
    named Tuple ('Recording') along with legends to be used for plotting. Rows of the np.arrays correspond to 
    different recording locations, and columns correspond to common time points in the simulation.
    
    @param run_time [float]: Length of the run
    @param initial_v [float]: The initial voltage for the simulation
    @param record_v [list(tuple(nrn.Section,float))]: List of nrn.Sections to record voltage from
    @param record_i [list(nrn.*Syn)]: List of nrn.*Syn to record from (should be added with 'poisson_stimulation()').
    @param record_m [list(nrn.IntFire*)]: List of nrn.IntFire* from which to record their states.
    @param selected_times [list(float)]; Times to record into the recording list. If none then return all the recording.

    
    @return [Recording]: Returns the recorded voltages, currents and states in a named tuple
    """

    num_volt_rec = len(record_v)
    num_current_rec = len(record_i)
    num_state_rec = len(record_m)

    if num_current_rec > 0:
        raise Exception ("Current recording is not implemented yet.")

    if not num_volt_rec and not num_current_rec and not num_state_rec:
        raise Exception ('No recordings specified (see input parameters ''record_v'', ''record_i'', and ''record_m'')')


    # Set up recordings from the list of sections to record voltages from
    volt_legend = list()

    dt = nest.GetKernelStatus('ms_per_tic')
    times = np.arange(0, run_time - dt * 1000, dt * 1000)

    voltmeters = list()

    for cell in record_v:

        vm = nest.Create('voltmeter')
        nest.Connect(vm, [cell.id])

        voltmeters.append(vm)

    nest.Simulate(run_time)

    voltages = np.zeros((len(times), len(record_v)))

    for i in xrange(len(record_v)):

        events = nest.GetStatus(voltmeters[i], 'events')[0]
        voltages[:, i] = events['V_m']


    currents = np.zeros((0, 0))
    states = np.zeros((0, 0))
    curr_legend = list()
    state_legend = list()

    #Return times, voltages, currents, states, volt_legend, curr_legend, state_legend in a namedtuple
    return Recording(times, voltages, currents, states, volt_legend, curr_legend, state_legend)

