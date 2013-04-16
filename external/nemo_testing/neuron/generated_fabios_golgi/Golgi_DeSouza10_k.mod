

TITLE Golgi_DeSouza10_k


NEURON {
  RANGE comp238_celsius, comp238_V_t, comp239_c, comp240_ki, comp240_ko
  RANGE ki, ko
  RANGE F, R
  USEION k READ ik WRITE ki, ko
}


PARAMETER {
  comp240_ki0  =  140.0
  comp239_c  =  1.0
  comp240_d  =  0.2
  comp240_beta  =  0.075
  comp238_celsius  =  23.0
  comp238_V_t  =  -35.0
  R  =  8.31342
  comp240_ko0  =  5.0
  F  =  96485.3
}


STATE {
  comp240_ki
  comp240_ko
}


ASSIGNED {
  ek
  ena
  ko
  ki
  celsius
  v
  nao
  nai
  comp240_ik
  ik
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp238_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp238_celsius + 273.15)) / F * log(ko / ki)
}


PROCEDURE pools () {
  ki = comp240_ki
  ko = comp240_ko
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  pools ()
}


DERIVATIVE states {
  comp240_ik  =  ik
  asgns ()
  comp240_ko'  =  
  comp240_ik / (2.0 * F * comp240_d) * 10000.0 + 
    -(comp240_beta * (comp240_ko + -(comp240_ko0)))
  comp240_ki'  =  
  (-(comp240_ik)) / (2.0 * F * comp240_d) * 10000.0 + 
    -(comp240_beta * (comp240_ki + -(comp240_ki0)))
}


INITIAL {
  comp240_ik  =  ik
  asgns ()
  comp240_ko  =  5.0
  comp240_ki  =  140.0
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp240_ki = %g\n" , t, v,  comp240_ki)
  printf ("NMODL state: t = %g v = %g comp240_ko = %g\n" , t, v,  comp240_ko)
}
