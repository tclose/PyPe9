"""

    This package contains general methods to initiate and plot simulations for both NEURON and NEST

    
    @author Tom Close

"""

#######################################################################################
#
#        Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################


try:
    import matplotlib.pyplot as plt
except:
    pass

import collections


## A named tuple to hold the return value of the 'run' method
##     - times [np.array]: simulated time
##     - voltages [list(np.array)]: recorded voltages (mV)
##     - currents [list(np.array)]: recorded currents (nA)
##     - states [list(np.array)]: recorded states (dimensionless between 0 and 1 for integrate and fire neurons)
##     - volt_legend [list(String)]: Legend for plotting the recorded voltages
##     - curr_legend [list(String)]: Legend for plotting the recorded currents
##     - state_legend [list(String)]: Legend for plotting the recorded states
Recording = collections.namedtuple('Recording', 'times voltages currents states volt_legend curr_legend state_legend')

def quit_figure(event):
    """
    Creates a shortcut to close the current window with the key 'q'
    """
    if event.key == 'q':
        plt.close(event.canvas.figure)

def plot_simulation(recording, time_window=None,
                    trigger_times=list(), volt_title='Recorded Voltages',
                    curr_title='Recorded Currents', state_title='Recorded States',
                    time_units='ms', volt_units='mV', curr_units='nA', show=True, fig_num=None,
                    save_plot=None):
    """
    Plots the output of the 'run' function.
    
    @param recording [Recording]: The 'Recording' namedtuple returned from the 'run' function
    @param time_window [tuple(2)[float]]: The time window to display the plots over (ms)
    @param trigger_times [list[float]]: Special times at which to mark with a vertical line (ms)
    @param volt_title [String]: The title of the voltage plot
    @param curr_title [String]: The title of the current plot
    @param state_title [String]: The title of the state plot
    @param time_units [String]: Units for the time axes
    @param volt_units [String]: Units for the votlage axis
    @param curr_units [String]: Units for the current axis
    @param show [bool]: If unset, the figure is plotted but not shown until the plt.show() function is called.
    @param fig_num [String]: Specifies the figure number to use
    """

    shortcut_events = []

    if recording.voltages.shape[1]:
        plt.figure(fig_num)     # plt.figure(1)
        shortcut_events.append(plt.gcf().canvas.mpl_connect('key_press_event', quit_figure)) # Register the 'q' -> close shortcut key with the current figure
        plt.plot(recording.times, recording.voltages)
        plt.title(volt_title)
        plt.xlabel("Time (" + time_units + ")")
        plt.ylabel("Voltage (" + volt_units + ")")
        plt.legend(recording.volt_legend)
        for trigger_i in trigger_times:
            plt.axvline(trigger_i, linestyle='--', color='black')

    if time_window:
        plt.axis(xmin=time_window[0], xmax=time_window[1])

    if not fig_num:
        fig_num = 1
    else:
        fig_num = fig_num + 1

    if recording.currents.shape[1]:
        # Plot the currents using MatPlotLib
        plt.figure(fig_num)
        shortcut_events.append(plt.gcf().canvas.mpl_connect('key_press_event', quit_figure)) # Register the 'q' -> close shortcut key with the current figure        
        plt.plot(recording.times, recording.currents)
        plt.title(curr_title)
        plt.xlabel("Time (" + time_units + ")")
        plt.ylabel("Current (" + curr_units + ")")
        plt.legend(recording.curr_legend)
        for trigger_i in trigger_times:
            plt.axvline(trigger_i, linestyle='--', color='black')

    if time_window:
        plt.axis(xmin=time_window[0], xmax=time_window[1])

    if recording.states.shape[1]:
        # Plot the states using MatPlotLib
        plt.figure(fig_num)
        shortcut_events.append(plt.gcf().canvas.mpl_connect('key_press_event', quit_figure)) # Register the 'q' -> close shortcut key with the current figure        
        plt.plot(recording.times, recording.states)
        plt.title(state_title)
        plt.xlabel("Time (" + time_units + ")")
        plt.ylabel("State (fire threshold: 1)")
        plt.legend(recording.state_legend)
        for trigger_i in trigger_times:
            plt.axvline(trigger_i, linestyle='--', color='black')

    if time_window:
        plt.axis(xmin=time_window[0], xmax=time_window[1])


    if show:
        plt.show()

    if save_plot:
        plt.savefig(save_plot)
        if not show:
            plt.close()