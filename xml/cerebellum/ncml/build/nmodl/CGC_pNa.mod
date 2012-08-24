

TITLE CGC_pNa


NEURON {
  RANGE pNa_m, comp251_vcbdur, comp251_vchdur, comp251_vcsteps, comp251_vcinc, comp251_vcbase, comp251_vchold, comp63_e, comp63_gbar
  RANGE i_pNa
  RANGE ina
  USEION na READ ena WRITE ina
}


FUNCTION comp63_beta_m (v) {
  comp63_beta_m  =  
  comp63_Q10 * comp63_Abeta_m * 
    linoid(v + -(comp63_V0beta_m), comp63_Kbeta_m)
}


FUNCTION comp63_alpha_m (v) {
  comp63_alpha_m  =  
  comp63_Q10 * comp63_Aalpha_m * 
    linoid(v + -(comp63_V0alpha_m), comp63_Kalpha_m)
}


FUNCTION linoid (x, y) {
  LOCAL v379
  if 
    (fabs(x / y) < 1e-06) 
     {v379  =  y * (1.0 + -(x / y / 2.0))} 
    else {v379  =  x / (exp(x / y) + -1.0)} 
linoid  =  v379
}


PARAMETER {
  comp251_vcbdur  =  100.0
  comp251_vcinc  =  10.0
  fix_celsius  =  30.0
  comp63_Aalpha_m  =  -0.091
  comp63_gbar  =  2e-05
  comp251_vchold  =  -71.0
  comp63_Abeta_m  =  0.062
  comp63_V0alpha_m  =  -42.0
  comp63_V0beta_m  =  -42.0
  comp63_Q10  =  1.0
  comp63_V0_minf  =  -42.0
  comp63_Kbeta_m  =  5.0
  comp63_Kalpha_m  =  -5.0
  comp251_vcsteps  =  9.0
  comp63_B_minf  =  5.0
  Vrest  =  -68.0
  comp251_vcbase  =  -60.0
  comp63_e  =  87.39
  comp251_vchdur  =  30.0
}


STATE {
  pNa_m
}


ASSIGNED {
  pNa_m_inf
  pNa_m_tau
  v
  cai
  ica
  ina
  ena
  i_pNa
}


PROCEDURE asgns () {
  pNa_m_tau  =  5.0 / (comp63_alpha_m(v) + comp63_beta_m(v))
  pNa_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp63_V0_minf)) / comp63_B_minf))
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_pNa  =  (comp63_gbar * pNa_m) * (v - comp63_e)
  ina  =  i_pNa
}


DERIVATIVE states {
  asgns ()
  pNa_m'  =  (pNa_m_inf + -(pNa_m)) / pNa_m_tau
}


INITIAL {
  asgns ()
  pNa_m  =  (comp63_alpha_m(v)) / (comp63_alpha_m(v) + comp63_beta_m(v))
}


PROCEDURE print_state () {
  printf ("pNa_m = %g\n" ,  pNa_m)
}
