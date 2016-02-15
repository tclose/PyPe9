bin_PROGRAMS = compare

compare_CXXFLAGS = @AM_CXXFLAGS@
compare_SOURCES =  main.cpp IzhikevichBranch.h IzhikevichBranch.cpp \
               	   IzhikevichMaster.cpp IzhikevichMaster.h
compare_LDADD =  ../../../../../nest/build-no-mpi/nestkernel/libnest.la ../../../../../nest/build-no-mpi/libnestutil/libnestutil.la ../../../../../nest/build-no-mpi/sli/libsli.la ../../../../../nest/build-no-mpi/librandom/librandom.la -lgsl -lgslcblas
compare_LDFLAGS = -L/usr/local/Cellar/gsl/1.16/lib

MAKEFLAGS= @MAKE_FLAGS@

AM_CPPFLAGS= @NEST_CPPFLAGS@ \
             @INCLTDL@
