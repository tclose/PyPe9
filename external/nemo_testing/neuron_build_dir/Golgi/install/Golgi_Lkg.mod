

TITLE Golgi_Lkg


NEURON {
  RANGE comp5220_gbar, comp5220_e
  RANGE i_Lkg
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  ca2o  =  2.0
  comp5220_gbar  =  2.1e-05
  comp5220_e  =  -55.0
}


STATE {
}


ASSIGNED {
  celsius
  v
  i
  e
  i_Lkg
}


BREAKPOINT {
  i_Lkg  =  comp5220_gbar * (v - comp5220_e)
  i  =  i_Lkg
}


INITIAL {
  e  =  comp5220_e
}


PROCEDURE print_state () {
}
