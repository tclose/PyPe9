

TITLE Leak


NEURON {
  RANGE comp0_e_Leak, comp0_gbar_Leak
  RANGE i_Leak
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  comp0_e_Leak  =  -61.0
  temp_adj  =  1.24573093961552
  Vrest  =  -68.0
  comp0_gbar_Leak  =  9e-05
}


STATE {
}


ASSIGNED {
  v
  i
  e
  i_Leak
}


BREAKPOINT {
  i_Leak  =  comp0_gbar_Leak * (v - comp0_e_Leak)
  i  =  i_Leak
}


INITIAL {
}


PROCEDURE print_state () {
}
