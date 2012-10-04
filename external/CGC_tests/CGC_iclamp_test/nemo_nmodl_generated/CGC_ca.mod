

TITLE CGC_ca


NEURON {
  RANGE comp51_ca
  RANGE ica, cai
  USEION ca READ ica WRITE cai
}


FUNCTION linoid (x, y) {
  LOCAL v3027
  if 
    (fabs(x / y) < 1e-06) 
     {v3027  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3027  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3027
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


PARAMETER {
  comp51_cai0  =  0.0001
  comp51_cao  =  2.0
  comp51_F  =  96485.0
  comp51_d  =  0.2
  comp51_beta  =  1.5
}


STATE {
  comp51_ca
}


ASSIGNED {
  v
  comp51_cai
  celsius
  comp51_ica
  cai
  ica
}


PROCEDURE pools () {
  cai = comp51_ca
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp51_ica  =  ica
  comp51_cai  =  cai
  comp51_ca'  =  
  (-(comp51_ica)) / (2.0 * comp51_F * comp51_d) * 10000.0 + 
    -(comp51_beta * (comp51_cai + -(comp51_cai0)))
}


INITIAL {
  comp51_ica  =  ica
  comp51_cai  =  cai
  comp51_ca  =  0.0001
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp51_ca = %g\n" , t, v,  comp51_ca)
}
