

TITLE Granule_DeSouza10_Lkg1


NEURON {
  RANGE comp446_celsius, comp446_V_t, comp447_C_m, comp448_gbar, comp448_e
  RANGE i_Lkg1
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  comp446_V_t  =  -35.0
  comp448_gbar  =  5.68e-05
  comp447_C_m  =  1.0
  comp446_celsius  =  30.0
  comp448_e  =  -16.5
}


STATE {
}


ASSIGNED {
  celsius
  v
  i
  e
  i_Lkg1
}


BREAKPOINT {
  i_Lkg1  =  comp448_gbar * (v - comp448_e)
  i  =  i_Lkg1
}


INITIAL {
  e  =  comp448_e
}


PROCEDURE print_state () {
}
