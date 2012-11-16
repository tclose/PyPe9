

TITLE Golgi_NaP


NEURON {
  RANGE comp4384_vchold, comp4384_vcbase, comp4384_vcinc, comp4384_vcsteps, comp4384_vchdur, comp4384_vcbdur, comp4469_gbar, comp4469_e, NaP_m
  RANGE i_NaP
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION comp4469_alpha_m (v, Q10) {
  comp4469_alpha_m  =  
  Q10 * comp4469_Aalpha_m * 
    comp4469_linoid(v + -(comp4469_V0alpha_m), comp4469_Kalpha_m)
}


FUNCTION comp4469_linoid (x, y) {
  LOCAL v5334
  if 
    (fabs(x / y) < 1e-06) 
     {v5334  =  y * (1.0 + -(x / y / 2.0))} 
    else {v5334  =  x / (exp(x / y) + -1.0)} 
comp4469_linoid  =  v5334
}


FUNCTION comp4469_beta_m (v, Q10) {
  comp4469_beta_m  =  
  Q10 * comp4469_Abeta_m * 
    comp4469_linoid(v + -(comp4469_V0beta_m), comp4469_Kbeta_m)
}


PARAMETER {
  comp4469_Kalpha_m  =  -5.0
  comp4469_V0beta_m  =  -40.0
  comp4469_Kbeta_m  =  5.0
  comp4384_vchold  =  -71.0
  ca2o  =  2.0
  comp4469_V0_minf  =  -43.0
  comp4384_vchdur  =  30.0
  comp4384_vcinc  =  10.0
  comp4469_gbar  =  0.00019
  comp4384_vcsteps  =  9.0
  comp4384_vcbdur  =  100.0
  comp4384_vcbase  =  -60.0
  comp4469_Aalpha_m  =  -0.91
  comp4469_B_minf  =  5.0
  comp4469_V0alpha_m  =  -40.0
  comp4469_Abeta_m  =  0.62
  comp4469_e  =  87.39
}


STATE {
  NaP_m
}


ASSIGNED {
  NaP_m_tau
  NaP_m_inf
  comp4469_Q10
  celsius
  v
  ina
  ena
  i_NaP
}


PROCEDURE asgns () {
  comp4469_Q10  =  3.0 ^ ((celsius + -30.0) / 10.0)
  NaP_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp4469_V0_minf)) / comp4469_B_minf))
  NaP_m_tau  =  
  5.0 / 
    (comp4469_alpha_m(v, comp4469_Q10) + 
        comp4469_beta_m(v, comp4469_Q10))
  ena  =  comp4469_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_NaP  =  (comp4469_gbar * NaP_m) * (v - ena)
  ina  =  i_NaP
}


DERIVATIVE states {
  asgns ()
  NaP_m'  =  (NaP_m_inf + -(NaP_m)) / NaP_m_tau
}


INITIAL {
  asgns ()
  NaP_m  =  
  1.0 / (1.0 + exp(-(v + -(comp4469_V0_minf)) / comp4469_B_minf))
  ena  =  comp4469_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g NaP_m = %g\n" , t, v,  NaP_m)
}
