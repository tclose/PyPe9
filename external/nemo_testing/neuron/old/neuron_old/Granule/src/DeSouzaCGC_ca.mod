

TITLE DeSouzaCGC_ca


NEURON {
  RANGE comp219_ca
  RANGE ica, cai
  USEION ca READ ica WRITE cai
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3263
  if 
    (fabs(x / y) < 1e-06) 
     {v3263  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3263  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3263
}


PARAMETER {
  comp219_beta  =  1.5
  comp219_d  =  0.2
  comp219_F  =  96485.3
  comp219_cao  =  2.0
  comp219_cai0  =  0.0001
}


STATE {
  comp219_ca
}


ASSIGNED {
  celsius
  comp219_ica
  comp219_cai
  v
  ica
  cai
}


PROCEDURE pools () {
  cai = comp219_ca
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  LOCAL v3261
  comp219_cai  =  cai
  comp219_ica  =  ica
  if 
    (comp219_ca < comp219_cai0) 
     {v3261  =  comp219_cai0} 
    else {v3261  =  comp219_ca} 
comp219_ca'  =  
    (-(comp219_ica)) / (2.0 * comp219_F * comp219_d) * 10000.0 + 
        -(comp219_beta * (v3261 + -(comp219_cai0)))
}


INITIAL {
  comp219_cai  =  cai
  comp219_ica  =  ica
  comp219_ca  =  0.0001
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp219_ca = %g\n" , t, v,  comp219_ca)
}
