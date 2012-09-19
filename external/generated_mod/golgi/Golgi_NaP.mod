

TITLE Golgi_NaP


NEURON {
  RANGE NaP_m, comp211_vcbdur, comp211_vchdur, comp211_vcsteps, comp211_vcinc, comp211_vcbase, comp211_vchold, comp35_e, comp35_gbar
  RANGE i_NaP
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION comp35_alpha_m (v, Q10) {
  comp35_alpha_m  =  
  Q10 * comp35_Aalpha_m * 
    linoid(v + -(comp35_V0alpha_m), comp35_Kalpha_m)
}


FUNCTION comp35_beta_m (v, Q10) {
  comp35_beta_m  =  
  Q10 * comp35_Abeta_m * linoid(v + -(comp35_V0beta_m), comp35_Kbeta_m)
}


FUNCTION linoid (x, y) {
  LOCAL v339
  if 
    (fabs(x / y) < 1e-06) 
     {v339  =  y * (1.0 + -(x / y / 2.0))} 
    else {v339  =  x / (exp(x / y) + -1.0)} 
linoid  =  v339
}


PARAMETER {
  comp35_Kalpha_m  =  -5.0
  comp211_vchold  =  -71.0
  comp35_V0beta_m  =  -40.0
  comp211_vcinc  =  10.0
  comp35_Kbeta_m  =  5.0
  comp211_vchdur  =  30.0
  comp35_V0_minf  =  -43.0
  comp211_vcbdur  =  100.0
  comp211_vcbase  =  -60.0
  comp211_vcsteps  =  9.0
  comp35_Aalpha_m  =  -0.91
  comp35_e  =  87.39
  comp35_B_minf  =  5.0
  comp35_V0alpha_m  =  -40.0
  comp35_Abeta_m  =  0.62
  comp35_gbar  =  0.00019
}


STATE {
  NaP_m
}


ASSIGNED {
  comp35_Q10
  NaP_m_tau
  NaP_m_inf
  celsius
  v
  ina
  ena
  i_NaP
}


PROCEDURE asgns () {
  NaP_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp35_V0_minf)) / comp35_B_minf))
  comp35_Q10  =  3.0 ^ ((celsius + -30.0) / 10.0)
  NaP_m_tau  =  
  5.0 / (comp35_alpha_m(v, comp35_Q10) + comp35_beta_m(v, comp35_Q10))
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_NaP  =  (comp35_gbar * NaP_m) * (v - ena)
  ina  =  i_NaP
}


DERIVATIVE states {
  asgns ()
  NaP_m'  =  (NaP_m_inf + -(NaP_m)) / NaP_m_tau
}


INITIAL {
  asgns ()
  NaP_m  =  1.0 / (1.0 + exp(-(v + -(comp35_V0_minf)) / comp35_B_minf))
  ena  =  comp35_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g NaP_m = %g\n" , t, v,  NaP_m)
}
