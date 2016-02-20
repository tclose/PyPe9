bin_PROGRAMS = raw-compare

raw_compare_CXXFLAGS = @AM_CXXFLAGS@ -I/usr/local/Cellar/gsl/1.16/include
raw_compare_SOURCES =  main.cpp IzhikevichBranch.h IzhikevichBranch.cpp \
                       IzhikevichMaster.cpp IzhikevichMaster.h \
                       mock_nest.h mock_nest.cpp \
raw_compare_LDADD =  -lgsl -lgslcblas
raw_compare_LDFLAGS = -L/usr/local/Cellar/gsl/1.16/lib

MAKEFLAGS= @MAKE_FLAGS@

AM_CPPFLAGS= @INCLTDL@
