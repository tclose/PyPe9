

TITLE Golgi_DeSouza10_NaP


NEURON {
  RANGE comp606_celsius, comp606_V_t, comp607_c, comp608_vchold, comp608_vcbase, comp608_vcinc, comp608_vcsteps, comp608_vchdur, comp608_vcbdur, comp609_gbar
  RANGE comp609_e, NaP_m
  RANGE i_NaP
  RANGE ina
  RANGE ena
  RANGE F, R
  USEION na READ nai, nao WRITE ina
}


FUNCTION comp609_linoid (x, y) {
  LOCAL v711
  if 
    (fabs(x / y) < 1e-06) 
     {v711  =  y * (1.0 + -(x / y / 2.0))} 
    else {v711  =  x / (exp(x / y) + -1.0)} 
comp609_linoid  =  v711
}


FUNCTION comp609_alpha_m (v, Q10) {
  comp609_alpha_m  =  
  Q10 * comp609_Aalpha_m * 
    comp609_linoid(v + -(comp609_V0alpha_m), comp609_Kalpha_m)
}


FUNCTION comp609_beta_m (v, Q10) {
  comp609_beta_m  =  
  Q10 * comp609_Abeta_m * 
    comp609_linoid(v + -(comp609_V0beta_m), comp609_Kbeta_m)
}


PARAMETER {
  comp607_c  =  1.0
  comp609_V0alpha_m  =  -40.0
  comp609_V0_minf  =  -43.0
  comp609_V0beta_m  =  -40.0
  comp608_vcbase  =  -60.0
  comp609_B_minf  =  5.0
  comp608_vcsteps  =  9.0
  comp608_vcinc  =  10.0
  comp609_Aalpha_m  =  -0.91
  comp608_vchdur  =  30.0
  comp608_vcbdur  =  100.0
  comp609_Kbeta_m  =  5.0
  comp606_V_t  =  -35.0
  comp606_celsius  =  23.0
  comp609_Kalpha_m  =  -5.0
  R  =  8.31342
  comp609_Abeta_m  =  0.62
  F  =  96485.3
  comp609_gbar  =  0.00019
  comp608_vchold  =  -71.0
}


STATE {
  NaP_m
}


ASSIGNED {
  comp609_e
  ek
  NaP_m_inf
  ena
  NaP_m_tau
  comp609_Q10
  ko
  ki
  celsius
  v
  nao
  nai
  ina
  i_NaP
}


PROCEDURE asgns () {
  comp609_Q10  =  3.0 ^ ((comp606_celsius + -30.0) / 10.0)
  ena  =  (1000.0 * R * (comp606_celsius + 273.15)) / F * log(nao / nai)
  NaP_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp609_V0_minf)) / comp609_B_minf))
  ek  =  (1000.0 * R * (comp606_celsius + 273.15)) / F * log(ko / ki)
  NaP_m_tau  =  
  5.0 / 
    (comp609_alpha_m(v, comp609_Q10) + comp609_beta_m(v, comp609_Q10))
  comp609_e  =  ena
  ena  =  comp609_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_NaP  =  (comp609_gbar * NaP_m) * (v - comp609_e)
  ina  =  i_NaP
}


DERIVATIVE states {
  asgns ()
  NaP_m'  =  (NaP_m_inf + -(NaP_m)) / NaP_m_tau
}


INITIAL {
  asgns ()
  NaP_m  =  1.0 / (1.0 + exp(-(v + -(comp609_V0_minf)) / comp609_B_minf))
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g NaP_m = %g\n" , t, v,  NaP_m)
}
