

TITLE CGC_Lkg2


NEURON {
  RANGE comp47_egaba, comp47_ggaba
  RANGE i_Lkg2
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  comp47_ggaba  =  3e-05
  Vrest  =  -68.0
  fix_celsius  =  30.0
  comp47_egaba  =  -65.0
}


STATE {
}


ASSIGNED {
  ica
  cai
  v
  i
  e
  i_Lkg2
}


BREAKPOINT {
  i_Lkg2  =  comp47_ggaba * (v - e)
  i  =  i_Lkg2
}


INITIAL {
  e  =  comp47_egaba
}


PROCEDURE print_state () {
}
