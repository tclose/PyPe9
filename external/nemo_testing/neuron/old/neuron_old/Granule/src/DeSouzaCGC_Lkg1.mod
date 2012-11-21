

TITLE DeSouzaCGC_Lkg1


NEURON {
  RANGE comp2683_gbar, comp2683_e
  RANGE i_Lkg1
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3333
  if 
    (fabs(x / y) < 1e-06) 
     {v3333  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3333  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3333
}


PARAMETER {
  comp2683_gbar  =  5.68e-05
  comp2683_e  =  -16.5
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
  i_Lkg1  =  comp2683_gbar * (v - comp2683_e)
  i  =  i_Lkg1
}


INITIAL {
  e  =  comp2683_e
}


PROCEDURE print_state () {
}
