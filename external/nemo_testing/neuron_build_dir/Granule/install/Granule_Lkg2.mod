

TITLE Granule_Lkg2


NEURON {
  RANGE comp2760_ggaba, comp2760_egaba
  RANGE i_Lkg2
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3335
  if 
    (fabs(x / y) < 1e-06) 
     {v3335  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3335  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3335
}


PARAMETER {
  comp2760_egaba  =  -65.0
  comp2760_ggaba  =  3e-05
}


STATE {
}


ASSIGNED {
  celsius
  v
  i
  e
  i_Lkg2
}


BREAKPOINT {
  i_Lkg2  =  comp2760_ggaba * (v - comp2760_egaba)
  i  =  i_Lkg2
}


INITIAL {
  e  =  comp2760_egaba
}


PROCEDURE print_state () {
}
