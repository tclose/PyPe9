

TITLE Golgi_Lkg


NEURON {
  RANGE comp19_e, comp19_gbar
  RANGE i_Lkg
  RANGE el
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  comp19_e  =  -55.0
  comp19_gbar  =  2.1e-05
}


STATE {
}


ASSIGNED {
  v
  i
  el
  i_Lkg
}


BREAKPOINT {
  i_Lkg  =  comp19_gbar * (v - el)
  i  =  i_Lkg
}


INITIAL {
}


PROCEDURE print_state () {
}
