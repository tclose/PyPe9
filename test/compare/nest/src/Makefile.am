AM_CXXFLAGS = -I/usr/local/Cellar/gsl/1.16/include -I/usr/local/Cellar/gcc/5.3.0/include/c++/5.3.0 -Wall
LDADD = -L/usr/local/Cellar/gsl/1.16/lib -L/usr/local/Cellar/gcc/5.3.0/lib/gcc/5 -lgsl -lgslcblas -lm

bin_PROGRAMS = compare

compare_SOURCES =  main.cpp Branch.h Branch.cpp Master.cpp Master.h \
                   mock_nest.h mock_nest.cpp name.h name.cpp \
                   nest_time.h nest_time.cpp nest.h numerics.h numerics.cpp \
                   tarraryobj.h tarray.cpp tokenarray.h tokenarray.cpp

