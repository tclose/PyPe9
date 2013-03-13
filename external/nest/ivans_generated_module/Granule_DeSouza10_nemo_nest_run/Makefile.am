
# Automake file for external dynamic modules for NEST
#
# Hans Ekkehard Plesser, April 2008
# Automake file for the Developer Module
# 
# libGranule_DeSouza10 is built as a normal, installable library.
# It will be installed to $prefix/lib by make install.
# 
# Headers from this directory are not to be installed upon
# make install. They are therefore included in _SOURCES.


libdir= @libdir@/nest

lib_LTLIBRARIES=      Granule_DeSouza10.la libGranule_DeSouza10.la

Granule_DeSouza10_la_CXXFLAGS= @AM_CXXFLAGS@
Granule_DeSouza10_la_SOURCES=  Granule_DeSouza10.cpp      Granule_DeSouza10.h \
                      Granule.cpp Granule.h \

Granule_DeSouza10_la_LDFLAGS=  -module

libGranule_DeSouza10_la_CXXFLAGS= $(Granule_DeSouza10_la_CXXFLAGS) -DLINKED_MODULE
libGranule_DeSouza10_la_SOURCES=  $(Granule_DeSouza10_la_SOURCES)

MAKEFLAGS= @MAKE_FLAGS@

AM_CPPFLAGS= @NEST_CPPFLAGS@ \
             @SUNDIALS_CPPFLAGS@ \
             @INCLTDL@

AM_LDFLAGS = @SUNDIALS_LDFLAGS@

.PHONY: install-slidoc

nobase_pkgdata_DATA=\
    Granule_DeSouza10.sli

install-slidoc:
    NESTRCFILENAME=/dev/null $(DESTDIR)$(NEST_PREFIX)/bin/sli --userargs="@HELPDIRS@" $(NEST_PREFIX)/share/nest/sli/install-help.sli

install-data-hook: install-exec install-slidoc

EXTRA_DIST= sli
