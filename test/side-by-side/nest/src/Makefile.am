bin_PROGRAMS = test_nest

AM_CPPFLAGS = -I/Users/tclose/git/nest/nestkernel \
              -I/Users/tclose/git/nest/libnestutil \
              -I/Users/tclose/git/nest/sli \
              -I/Users/tclose/git/nest/librandom \
              -I/usr/local/Cellar/gsl/1.16/include

test_nest_SOURCES = main.cpp main.cpp reference.cpp generated.cpp 
test_nest_LDADD =  ../../../../../nest/build/nestkernel/libnest.la ../../../../../nest/build/libnestutil/libnestutil.la ../../../../../nest/build/sli/libsli.la ../../../../../nest/build/librandom/librandom.la $(GSL_LIBS) -lgslcblas
test_nest_LDFLAGS = -L/usr/local/Cellar/gsl/1.16/lib
