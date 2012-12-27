

TITLE Granule_Lkg2


NEURON {
  RANGE comp2532_ggaba, comp2532_egaba
  RANGE i_Lkg2
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION linoid (x, y) {
  LOCAL v3049
  if 
    (fabs(x / y) < 1e-06) 
     {v3049  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3049  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3049
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


PARAMETER {
  comp2532_egaba  =  -65.0
  comp2532_ggaba  =  3e-05
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
  i_Lkg2  =  comp2532_ggaba * (v - comp2532_egaba)
  i  =  i_Lkg2
}


INITIAL {
  e  =  comp2532_egaba
}


PROCEDURE print_state () {
}
