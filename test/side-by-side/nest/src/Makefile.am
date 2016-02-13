bin_PROGRAMS = test_nest

AM_CXXFLAGS = -I/Users/tclose/git/nest/nestkernel -I/Users/tclose/git/nest/libnestutil -I/Users/tclose/git/nest/sli -I/Users/tclose/git/nest/librandom -I/usr/local/Cellar/gsl/1.16/include -L/usr/local/Cellar/gsl/1.16/lib

test_nest_SOURCES = main.cpp reference.cpp generated.cpp 
test_nest_LDADD = $(GSL_LIBS) -lgslcblas

