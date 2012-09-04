

TITLE CGC_Lkg1


NEURON {
  RANGE comp47_e, comp47_gbar
  RANGE i_Lkg1
  RANGE e
  NONSPECIFIC_CURRENT i
}


PARAMETER {
  Vrest  =  -68.0
  comp47_gbar  =  5.68e-05
  fix_celsius  =  30.0
  comp47_e  =  -58.0
}


STATE {
}


ASSIGNED {
  ica
  cai
  v
  i
  e
  i_Lkg1
}


BREAKPOINT {
  i_Lkg1  =  comp47_gbar * (v - e)
  i  =  i_Lkg1
}


INITIAL {
}


PROCEDURE print_state () {
}
