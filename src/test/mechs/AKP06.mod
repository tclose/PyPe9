

TITLE AKP06


NEURON {
  RANGE comp1_ca, comp0_C_m
  RANGE ica, cai
  USEION ca READ ica WRITE cai
}


PARAMETER {
  comp0_C_m  =  0.001
  temp_adj  =  1.24573093961552
  comp1_ca_initial  =  0.0001
  comp1_F  =  96485.0
  Vrest  =  -68.0
  comp1_ca_depth  =  0.1
  comp1_ca_beta  =  1.0
}


STATE {
  comp1_ca
}


ASSIGNED {
  ica
  v
  cai
}


PROCEDURE pools () {
  cai = comp1_ca
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp1_ca'  =  
  (-(ica)) / (2.0 * comp1_F * comp1_ca_initial * comp1_ca_depth) + 
    -(comp1_ca * comp1_ca_beta * temp_adj)
}


INITIAL {
  comp1_ca  =  0.0001
}


PROCEDURE print_state () {
  printf ("comp1_ca = %g\n" ,  comp1_ca)
}
