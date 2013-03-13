

TITLE Golgi_ca2


NEURON {
  RANGE comp314_ca2, comp314_valence
  RANGE ica2, ca2i
  USEION ca2 READ ica2 WRITE ca2i VALENCE 2
}


PARAMETER {
  comp314_beta  =  1.3
  comp314_d  =  0.2
  comp314_F  =  96485.3
  ca2o  =  2.0
  comp314_valence  =  2.0
  comp314_ca2i0  =  5e-05
  comp314_ca2o  =  2.0
}


STATE {
  comp314_ca2
}


ASSIGNED {
  celsius
  comp314_ica2
  v
  ica2
  ca2i
}


PROCEDURE pools () {
  ca2i = comp314_ca2
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp314_ica2  =  ica2
  comp314_ca2'  =  
  (-(comp314_ica2)) / (2.0 * comp314_F * comp314_d) * 10000.0 + 
    -(comp314_beta * (comp314_ca2 + -(comp314_ca2i0)))
}


INITIAL {
  comp314_ica2  =  ica2
  comp314_ca2  =  5e-05
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp314_ca2 = %g\n" , t, v,  comp314_ca2)
}
