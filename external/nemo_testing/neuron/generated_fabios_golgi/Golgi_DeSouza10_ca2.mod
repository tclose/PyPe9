

TITLE Golgi_DeSouza10_ca2


NEURON {
  RANGE comp204_celsius, comp204_V_t, comp205_c, comp206_ca2, comp206_ca2o, comp206_valence
  RANGE ca2i, ca2o
  RANGE F, R
  USEION ca2 READ ica2 WRITE ca2i, ca2o VALENCE 2
}


PARAMETER {
  comp206_valence  =  2.0
  comp206_ca2i0  =  5e-05
  comp204_V_t  =  -35.0
  comp206_ca2o  =  2.0
  comp205_c  =  1.0
  comp204_celsius  =  23.0
  R  =  8.31342
  comp206_d  =  0.2
  F  =  96485.3
  comp206_beta  =  1.3
}


STATE {
  comp206_ca2
}


ASSIGNED {
  ek
  ena
  ko
  ki
  comp206_ica2
  celsius
  v
  nao
  nai
  ica2
  ca2i
  ca2o
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp204_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp204_celsius + 273.15)) / F * log(ko / ki)
}


PROCEDURE pools () {
  ca2i = comp206_ca2
  ca2o = comp206_ca2o
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp206_ica2  =  ica2
  asgns ()
  comp206_ca2'  =  
  (-(comp206_ica2)) / (2.0 * F * comp206_d) * 10000.0 + 
    -(comp206_beta * (comp206_ca2 + -(comp206_ca2i0)))
}


INITIAL {
  comp206_ica2  =  ica2
  asgns ()
  comp206_ca2  =  5e-05
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp206_ca2 = %g\n" , t, v,  comp206_ca2)
}
