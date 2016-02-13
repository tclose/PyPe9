dnl Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT(src/main.cpp, 1.0)

PACKAGE=test_nest
VERSION=0.1.0

AC_CANONICAL_SYSTEM
AM_INIT_AUTOMAKE($PACKAGE, $VERSION)

AC_CHECK_LIB([m],[cos])
AC_CHECK_LIB([gslcblas],[cblas_dgemm])
AC_CHECK_LIB([gsl],[gsl_blas_dgemm])

AC_C_INLINE
if test "$ac_cv_c_inline" != no ; then
  AC_DEFINE(HAVE_INLINE,1)
  AC_SUBST(HAVE_INLINE)
fi

AC_PROG_CXX

AC_CONFIG_FILES(Makefile src/Makefile)
AC_OUTPUT

