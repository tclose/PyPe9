

TITLE CGC_Lkg2


NEURON {
  RANGE comp47_egaba, comp47_ggaba
  RANGE i_Lkg2
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  fix_celsius  =  30.0
  comp47_ggaba  =  2.17e-05
  comp47_egaba  =  -65.0
  Vrest  =  -68.0
}


STATE {
}


ASSIGNED {
  v
  cai
  ica
  i
  e
  i_Lkg2
}


BREAKPOINT {
  i_Lkg2  =  comp47_ggaba * (v - comp47_egaba)
  i  =  i_Lkg2
}


INITIAL {
}


PROCEDURE print_state () {
}
