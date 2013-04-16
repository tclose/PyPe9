

TITLE Golgi_DeSouza10_Lkg


NEURON {
  RANGE comp690_celsius, comp690_V_t, comp691_c, comp692_gbar, comp692_e
  RANGE i_Lkg
  RANGE e
  RANGE F, R
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  comp692_e  =  -55.0
  comp690_V_t  =  -35.0
  comp692_gbar  =  2.1e-05
  comp690_celsius  =  23.0
  R  =  8.31342
  F  =  96485.3
  comp691_c  =  1.0
}


STATE {
}


ASSIGNED {
  ek
  ena
  ko
  ki
  celsius
  v
  nao
  nai
  i
  e
  i_Lkg
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp690_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp690_celsius + 273.15)) / F * log(ko / ki)
  e  =  comp692_e
}


BREAKPOINT {
  i_Lkg  =  comp692_gbar * (v - comp692_e)
  i  =  i_Lkg
}


INITIAL {
  asgns ()
  e  =  comp692_e
}


PROCEDURE print_state () {
}
