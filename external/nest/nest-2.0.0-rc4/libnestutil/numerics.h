/*
 *  numerics.h
 *
 *  This file is part of NEST
 *
 *  Copyright (C) 2004 by
 *  The NEST Initiative
 *
 *  See the file AUTHORS for details.
 *
 *  Permission is granted to compile and modify
 *  this file for non-commercial use.
 *  See the file LICENSE for details.
 *
 */

#ifndef NUMERICS_H
#define NUMERICS_H

#include <limits>
#include <cmath>

#if HAVE_EXPM1
#  include <math.h>
#endif

namespace numerics {

  extern  const double e;
  extern  const double pi;

/** Supply expm1() function independent of system.
 *  @note Implemented inline for efficiency.
 */
  inline
  double expm1(double x)
  { 
#if HAVE_EXPM1
    return ::expm1(x);  // use library implementation if available
#else
    // compute using Taylor series, see GSL
    // e^x-1 = x + x^2/2! + x^3/3! + ...
    if ( x == 0 )
      return 0;
    if ( std::abs(x) > std::log(2.0) )
      return std::exp(x) - 1;
    else
    {
      double sum = x;
      double term = x*x/2;
      long n = 2;
      
      while ( std::abs(term) > 
	      std::abs(sum) * std::numeric_limits<double>::epsilon() )
      {
	sum += term;
	++n;
	term *= x/n; 
      }

      return sum;
    }
#endif
  }

}


// later also in namespace
/**
 * Round to nearest int, rounding midpoints upwards.
 *
 * @return Result as long
 * @note [-1/2, 1/2) -> 0 and in general [ (2n-1)/2, (2n+1)/2 ) -> n
 * @see dround
 */
long   ld_round(double);

/**
 * Round to nearest int, rounding midpoints upwards.
 *
 * @return Result as double
 * @note [-1/2, 1/2) -> 0 and in general [ (2n-1)/2, (2n+1)/2 ) -> n
 * @see ld_round
 */
double dround(double);

/**
 * Return integer part of argument.
 */
double dtruncate(double);


# endif
