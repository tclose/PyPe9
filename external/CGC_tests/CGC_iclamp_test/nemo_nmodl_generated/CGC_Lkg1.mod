

TITLE CGC_Lkg1


NEURON {
  RANGE comp2455_gbar, comp2455_e
  RANGE i_Lkg1
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION linoid (x, y) {
  LOCAL v3047
  if 
    (fabs(x / y) < 1e-06) 
     {v3047  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3047  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3047
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


PARAMETER {
  comp2455_gbar  =  5.68e-05
  comp2455_e  =  -16.5
}


STATE {
}


ASSIGNED {
  v
  celsius
  i
  e
  i_Lkg1
}


BREAKPOINT {
  i_Lkg1  =  comp2455_gbar * (v - comp2455_e)
  i  =  i_Lkg1
}


INITIAL {
  e  =  comp2455_e
}


PROCEDURE print_state () {
}
