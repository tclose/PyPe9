/*
 *  pseudo_recording_device.h
 *
 *  This file is part of NEST
 *
 *  Copyright (C) 2004-2008 by
 *  The NEST Initiative
 *
 *  See the file AUTHORS for details.
 *
 *  Permission is granted to compile and modify
 *  this file for non-commercial use.
 *  See the file LICENSE for details.
 *
 */

#ifndef PSEUDO_RECORDING_DEVICE_H
#define PSEUDO_RECORDING_DEVICE_H

#include "nest.h"
#include "dictdatum.h"
#include "dictutils.h"
#include "lockptr.h"
#include "device.h"

#include <vector>
#include <fstream>

namespace nest {

  /*BeginDocumentation
    Name: PseudoRecordingDevice - Common properties of all pseudo-recording devices.
    Description:

    Pseudo recording devices are used to measure properties of or signals emitted
    by network nodes. In contrast to fully flegded recording devices, they only
    register data in memory, but do not write data to file or screen.

    Parameters:
    The following parameters are shared with all devices:
    /start  - Actication time, relative to origin.
    /stop   - Inactivation time, relative to origin. 
    /origin - Reference time for start and stop.
                                          
    SeeAlso: Device, StimulatingDevice, RecordingDevice
  */


  /** 
   * Base class for all pseudo recording devices.
   *
   * Pseudo-recording devices collect data. The data is only collected
   * in memory an only available through GetStatus.
   *
   * If the device is configured to record from start to stop, this
   * is interpreted as (start, stop], i.e., the earliest recorded
   * event will have time stamp start+1, as it was generated during
   * the update step (start, start+1].
   *
   * @note The sole purpose of this class is to provide an implementation
   *       of is_active(). 
   *
   * @ingroup Devices
   *
   * @author HEP 2002-07-22, 2008-03-21, 2008-07-01
   */
  class PseudoRecordingDevice : public Device 
  {

  public:
    PseudoRecordingDevice();
    PseudoRecordingDevice(const PseudoRecordingDevice&);
    virtual ~PseudoRecordingDevice() {}

    /** Indicate if recording device is active.
     *  The argument is the time stamp of the event, and the
     *  device is active if start_ < T <= stop_.
     */
    bool is_active(Time const & T) const;
  };

  inline
  PseudoRecordingDevice::PseudoRecordingDevice()
    : Device()
  {}

  inline
  PseudoRecordingDevice::PseudoRecordingDevice(const PseudoRecordingDevice& prd)
    : Device(prd)
  {}

  inline
  bool PseudoRecordingDevice::is_active(Time const & T) const
  {
    const long_t stamp = T.get_steps();
  
    return get_t_min_() < stamp && stamp <= get_t_max_();
  }

} // namespace

#endif  // PSEUDO_RECORDING_DEVICE_H