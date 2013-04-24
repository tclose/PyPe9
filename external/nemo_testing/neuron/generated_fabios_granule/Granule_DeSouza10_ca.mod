

TITLE Granule_DeSouza10_ca


NEURON {
  RANGE comp204_celsius, comp204_V_t, comp205_C_m, comp206_ca, comp206_cao
  RANGE cai, cao
  USEION ca READ ica WRITE cai, cao
}


PARAMETER {
  comp204_V_t  =  -35.0
  comp206_cao  =  2.0
  comp206_cai0  =  0.0001
  comp205_C_m  =  1.0
  comp204_celsius  =  30.0
  comp206_d  =  0.2
  comp206_beta  =  1.5
  comp206_F  =  96485.3
}


STATE {
  comp206_ca
}


ASSIGNED {
  comp206_ica
  comp206_cai
  celsius
  v
  ica
  cai
  cao
}


PROCEDURE pools () {
  cai = comp206_ca
  cao = comp206_cao
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  LOCAL if503
  comp206_cai  =  cai
  comp206_ica  =  ica
  if 
    (comp206_ca < comp206_cai0) 
     {if503  =  comp206_cai0} 
    else {if503  =  comp206_ca} 
comp206_ca'  =  
    (-(comp206_ica)) / (2.0 * comp206_F * comp206_d) * 10000.0 + 
        -(comp206_beta * (if503 + -(comp206_cai0)))
}


INITIAL {
  comp206_cai  =  cai
  comp206_ica  =  ica
  comp206_ca  =  0.0001
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp206_ca = %g\n" , t, v,  comp206_ca)
}
