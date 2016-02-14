libdir= @libdir@/nest

bin_PROGRAMS = compare

compare_CXXFLAGS = @AM_CXXFLAGS@
compare_SOURCES =  main.cpp IzhikevichBranch.h IzhikevichBranch.cpp \
               	   IzhikevichMaster.cpp IzhikevichMaster.h

MAKEFLAGS= @MAKE_FLAGS@

AM_CPPFLAGS= @NEST_CPPFLAGS@ \
             @INCLTDL@
