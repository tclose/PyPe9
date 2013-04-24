

TITLE Golgi_DeSouza10_na


NEURON {
  RANGE comp221_celsius, comp221_V_t, comp222_c, comp223_nai, comp223_nao
  RANGE nai, nao
  RANGE F, R
  USEION na READ ina WRITE nai, nao
}


PARAMETER {
  comp223_nao0  =  140.0
  comp222_c  =  1.0
  comp221_V_t  =  -35.0
  comp223_d  =  0.2
  comp221_celsius  =  23.0
  comp223_nai0  =  5.0
  comp223_beta  =  0.075
  R  =  8.31342
  F  =  96485.3
}


STATE {
  comp223_nai
  comp223_nao
}


ASSIGNED {
  ek
  ena
  comp223_ina
  ko
  ki
  celsius
  v
  nao
  nai
  ina
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp221_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp221_celsius + 273.15)) / F * log(ko / ki)
}


PROCEDURE pools () {
  nai = comp223_nai
  nao = comp223_nao
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp223_ina  =  ina
  asgns ()
  comp223_nao'  =  
  comp223_ina / (2.0 * F * comp223_d) * 10000.0 + 
    -(comp223_beta * (comp223_nao + -(comp223_nao0)))
  comp223_nai'  =  
  (-(comp223_ina)) / (2.0 * F * comp223_d) * 10000.0 + 
    -(comp223_beta * (comp223_nai + -(comp223_nai0)))
}


INITIAL {
  comp223_ina  =  ina
  asgns ()
  comp223_nao  =  140.0
  comp223_nai  =  5.0
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp223_nai = %g\n" , t, v,  comp223_nai)
  printf ("NMODL state: t = %g v = %g comp223_nao = %g\n" , t, v,  comp223_nao)
}
