bin_PROGRAMS = raw-compare

raw_compare_CXXFLAGS = @AM_CXXFLAGS@ -I/usr/local/Cellar/gsl/1.16/include -I/usr/local/Cellar/gcc/5.3.0/include/c++/5.3.0
raw_compare_SOURCES =  main.cpp IzhikevichBranch.h IzhikevichBranch.cpp \
                       IzhikevichMaster.cpp IzhikevichMaster.h \
                       mock_nest.h mock_nest.cpp \
raw_compare_LDADD =  -lgsl -lgslcblas -lm
raw_compare_LDFLAGS = -L/usr/local/Cellar/gsl/1.16/lib -L/usr/local/Cellar/gcc/5.3.0/lib/gcc/5

MAKEFLAGS= @MAKE_FLAGS@

AM_CPPFLAGS= @INCLTDL@
