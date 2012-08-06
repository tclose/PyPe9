

TITLE Golgi_Ca


NEURON {
  RANGE comp19_ca
  RANGE ica, cai
  USEION ca READ ica WRITE cai
}


PARAMETER {
  comp19_beta  =  1.3
  comp19_d  =  0.2
  comp19_cao  =  2.0
  comp19_cai0  =  0.0001
  comp19_F  =  96485.0
}


STATE {
  comp19_ca
}


ASSIGNED {
  ica
  cai
  v
}


PROCEDURE pools () {
  cai = comp19_ca
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp19_ca'  =  
  (-(ica)) / (2.0 * comp19_F * comp19_d) + 
    -(comp19_beta * (cai + -(comp19_cai0)))
}


INITIAL {
  comp19_ca  =  0.0001
}


PROCEDURE print_state () {
  printf ("comp19_ca = %g\n" ,  comp19_ca)
}
