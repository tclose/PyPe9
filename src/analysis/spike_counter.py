"""

  This module defines a simple function for counting spikes in a spike train

  @file spike_counter.py
  @author Tom Close

"""

#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

def spike_counter(spike_train, threshold=0):
  """
  Counts the number of spikes in a given spike train. A spike is defined as a contiguous section of spike train data 
  that is at or above the specified threshold.
  
  @param spike_train [float array/list]: Train of spike data
  @param threshold [float]: The threshold, above which, a spike is judged to have occurred.  
  @return [int]: The number of spikes that occurred in the spike train. 
  """

  if spike_train[0] >= threshold:
    already_above = True
    spike_count = 1
  else:
    already_above = False
    spike_count = 0

  for elem in spike_train:

    if not already_above and (elem >= threshold):
      spike_count = spike_count + 1
      already_above = True
    elif already_above and (elem < threshold):
      already_above = False


  return spike_count


