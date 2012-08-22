

TITLE Ih


NEURON {
  RANGE Ih_m, comp0_e_Ih, comp0_gbar_Ih
  RANGE i_Ih
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION comp0_Ih_inf (v) {
  LOCAL v29, v28
  v29  =  90.1 v28  =  -9.9 
comp0_Ih_inf  =  1.0 / (1.0 + exp(-((v + v29) / v28)))
}


FUNCTION comp0_Ih_tau (v) {
  LOCAL v35, v34, v33, v32, v31
  v34  =  0.19 v33  =  0.72 v32  =  81.5 v31  =  11.9 
v35  =  (v + v32) / v31 
  comp0_Ih_tau  =  1000.0 * (v34 + v33 * exp(-(v35 * v35)))
}


PARAMETER {
  comp0_gbar_Ih  =  0.0002
  comp0_e_Ih  =  -30.0
}


STATE {
  Ih_m
}


ASSIGNED {
  comp0_temp_adj
  Ih_m_inf
  Ih_m_tau
  v
  celsius
  i
  e
  i_Ih
}


PROCEDURE asgns () {
  Ih_m_inf  =  comp0_Ih_inf(v)
  comp0_temp_adj  =  3.0 ^ ((celsius + -22.0) / 10.0)
  Ih_m_tau  =  comp0_Ih_tau(v) / comp0_temp_adj
}


BREAKPOINT {
  SOLVE states METHOD cnexp
  i_Ih  =  (comp0_gbar_Ih * Ih_m) * (v - comp0_e_Ih)
  i  =  i_Ih
}


DERIVATIVE states {
  asgns ()
  Ih_m'  =  (Ih_m_inf + -(Ih_m)) / Ih_m_tau
}


INITIAL {
  asgns ()
  Ih_m  =  comp0_Ih_inf(v)
}


PROCEDURE print_state () {
  printf ("Ih_m = %g\n" ,  Ih_m)
}
