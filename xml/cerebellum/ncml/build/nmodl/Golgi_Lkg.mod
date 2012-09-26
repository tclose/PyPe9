

TITLE Golgi_Lkg


NEURON {
  RANGE comp19_e, comp19_gbar
  RANGE i_Lkg
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  comp19_gbar  =  2.1e-05
  comp19_e  =  -55.0
}


STATE {
}


ASSIGNED {
  v
  i
  e
  i_Lkg
}


BREAKPOINT {
  i_Lkg  =  comp19_gbar * (v - e)
  i  =  i_Lkg
}


INITIAL {
  e  =  comp19_e
}


PROCEDURE print_state () {
}
