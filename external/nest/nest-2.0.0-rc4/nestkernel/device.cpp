/*
 *  device.cpp
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

#include "device.h"
#include "dictutils.h"
#include "exceptions.h"

#include <limits>
#include <climits>

#include "node.h"
#include "network.h"
#include "nest_names.h"

/* ---------------------------------------------------------------- 
 * Default constructor defining default parameters
 * ---------------------------------------------------------------- */
    
nest::Device::Parameters_::Parameters_()
  : origin_(Time::step(0)),
    start_(Time::step(0)),
    stop_(Time::pos_inf())
{}

nest::Device::Parameters_::Parameters_(const Parameters_& p)
  : origin_(p.origin_),
    start_(p.start_),
    stop_(p.stop_)
{
  /* The resolution of the simulation may have changed since the
     original parameters were set. We thus must calibrate the copies
     to ensure consistency of the time values.
  */
  origin_.calibrate();
  start_.calibrate();
  stop_.calibrate();
}


/* ---------------------------------------------------------------- 
 * Parameter extraction and manipulation functions
 * ---------------------------------------------------------------- */

void nest::Device::Parameters_::get(DictionaryDatum &d) const
{
  (*d)[names::origin] = origin_.get_ms();
  (*d)[names::start]  = start_.get_ms();
  (*d)[names::stop]   = stop_.get_ms();
}  

void nest::Device::Parameters_::set(const DictionaryDatum& d)
{
  double_t v;

  /* We cannot update the Time values directly, since updateValue()
     doesn't support Time objects. We thus read the value in ms into
     a double first and then update the time object if a value was 
     given.
  */
  if(updateValue<double_t>(d, names::origin, v))
    origin_ = Time::ms(v);

  if(updateValue<double_t>(d, names::start, v))
    start_ = Time::ms(v);

  if(updateValue<double_t>(d, names::stop, v))
    stop_ = Time::ms(v);
}


/* ---------------------------------------------------------------- 
 * Default and copy constructor for device
 * ---------------------------------------------------------------- */

nest::Device::Device()
  : P_()
{}

nest::Device::Device(const Device& n)
  : P_(n.P_)
{}


/* ---------------------------------------------------------------- 
 * Device initialization functions
 * ---------------------------------------------------------------- */

void nest::Device::init_parameters(const Device& proto)
{
  P_ = Parameters_(proto.P_);  // force recalibration of Time objects
}

void nest::Device::calibrate()
{
  // We do not need to recalibrate time objects, since they are 
  // recalibrated on instance construction and resolution cannot
  // change after a single node instance has been created.
  
  // by adding time objects, all overflows will be handled gracefully
  V_.t_min_ = (P_.origin_ + P_.start_).get_steps();
  V_.t_max_ = (P_.origin_ + P_.stop_).get_steps();
}
