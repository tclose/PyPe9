

TITLE Golgi_Ca


NEURON {
  RANGE comp19_ca
  RANGE ica, cai
  USEION ca READ ica WRITE cai
}


PARAMETER {
  comp19_cao  =  2.0
  comp19_d  =  0.2
  comp19_F  =  96485.0
  comp19_cai0  =  5e-05
  comp19_beta  =  1.3
}


STATE {
  comp19_ca
}


ASSIGNED {
  v
  ica
  cai
}


PROCEDURE pools () {
  cai = comp19_ca
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
  print_state()
}


DERIVATIVE states {
  comp19_ca'  =  
  (-(ica)) / (2.0 * comp19_F * comp19_d) * 10000.0 + 
    -(comp19_beta * (comp19_ca + -(comp19_cai0)))
}


INITIAL {
  comp19_ca  =  5e-05
  print_state()
}


PROCEDURE print_state () {
  printf ("state: %g Ca_comp19 %g\n", t,  comp19_ca)
}
