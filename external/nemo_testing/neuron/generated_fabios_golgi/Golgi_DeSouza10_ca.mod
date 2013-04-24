

TITLE Golgi_DeSouza10_ca


NEURON {
  RANGE comp187_celsius, comp187_V_t, comp188_c, comp189_ca, comp189_cao
  RANGE cai, cao
  RANGE F, R
  USEION ca READ ica WRITE cai, cao
}


PARAMETER {
  comp189_cai0  =  5e-05
  comp187_V_t  =  -35.0
  comp189_cao  =  2.0
  comp189_beta  =  1.3
  comp187_celsius  =  23.0
  R  =  8.31342
  F  =  96485.3
  comp188_c  =  1.0
  comp189_d  =  0.2
}


STATE {
  comp189_ca
}


ASSIGNED {
  ek
  ena
  ko
  ki
  comp189_ica
  celsius
  v
  nao
  nai
  ica
  cai
  cao
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp187_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp187_celsius + 273.15)) / F * log(ko / ki)
}


PROCEDURE pools () {
  cai = comp189_ca
  cao = comp189_cao
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp189_ica  =  ica
  asgns ()
  comp189_ca'  =  
  (-(comp189_ica)) / (2.0 * F * comp189_d) * 10000.0 + 
    -(comp189_beta * (comp189_ca + -(comp189_cai0)))
}


INITIAL {
  comp189_ica  =  ica
  asgns ()
  comp189_ca  =  5e-05
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp189_ca = %g\n" , t, v,  comp189_ca)
}
