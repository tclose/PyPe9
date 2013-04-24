

TITLE Granule_DeSouza10_Lkg2


NEURON {
  RANGE comp465_celsius, comp465_V_t, comp466_C_m, comp467_ggaba, comp467_egaba
  RANGE i_Lkg2
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  comp467_egaba  =  -65.0
  comp467_ggaba  =  3e-05
  comp465_V_t  =  -35.0
  comp465_celsius  =  30.0
  comp466_C_m  =  1.0
}


STATE {
}


ASSIGNED {
  celsius
  v
  i
  e
  i_Lkg2
}


BREAKPOINT {
  i_Lkg2  =  comp467_ggaba * (v - comp467_egaba)
  i  =  i_Lkg2
}


INITIAL {
  e  =  comp467_egaba
}


PROCEDURE print_state () {
}
