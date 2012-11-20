

TITLE Golgi_ca


NEURON {
  RANGE comp201_ca
  RANGE ica, cai
  USEION ca READ ica WRITE cai
}


PARAMETER {
  comp201_cao  =  2.0
  ca2o  =  2.0
  comp201_cai0  =  5e-05
  comp201_beta  =  1.3
  comp201_d  =  0.2
  comp201_F  =  96485.3
}


STATE {
  comp201_ca
}


ASSIGNED {
  comp201_ica
  celsius
  v
  ica
  cai
}


PROCEDURE pools () {
  cai = comp201_ca
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp201_ica  =  ica
  comp201_ca'  =  
  (-(comp201_ica)) / (2.0 * comp201_F * comp201_d) * 10000.0 + 
    -(comp201_beta * (comp201_ca + -(comp201_cai0)))
}


INITIAL {
  comp201_ica  =  ica
  comp201_ca  =  5e-05
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp201_ca = %g\n" , t, v,  comp201_ca)
}
