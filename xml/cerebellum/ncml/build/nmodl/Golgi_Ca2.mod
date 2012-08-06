

TITLE Golgi_Ca2


NEURON {
  RANGE comp19_valence, comp19_ca2
  RANGE ica2, ca2i
  USEION ca2 READ ica2 WRITE ca2i VALENCE 2
}


PARAMETER {
  comp19_beta  =  1.3
  comp19_d  =  0.2
  comp19_ca2o  =  2.0
  comp19_ca2i0  =  0.0001
  comp19_valence  =  2.0
  comp19_F  =  96485.0
}


STATE {
  comp19_ca2
}


ASSIGNED {
  ica2
  v
  ca2i
}


PROCEDURE pools () {
  ca2i = comp19_ca2
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp19_ca2'  =  
  (-(ica2)) / (2.0 * comp19_F * comp19_d * 10000.0) + 
    -(comp19_beta * (ca2i + -(comp19_ca2i0)))
}


INITIAL {
  comp19_ca2  =  0.0001
}


PROCEDURE print_state () {
  printf ("comp19_ca2 = %g\n" ,  comp19_ca2)
}
