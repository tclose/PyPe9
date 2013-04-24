

TITLE Granule_DeSouza10_Kir


NEURON {
  RANGE comp348_celsius, comp348_V_t, comp349_C_m, comp350_vchold, comp350_vcbase, comp350_vcinc, comp350_vcsteps, comp350_vchdur, comp350_vcbdur, comp351_gbar
  RANGE comp351_e, Kir_m
  RANGE i_Kir
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp351_alpha_d (v, Q10) {
  comp351_alpha_d  =  
  Q10 * comp351_Aalpha_d * 
    exp((v + -(comp351_V0alpha_d)) / comp351_Kalpha_d)
}


FUNCTION comp351_beta_d (v, Q10) {
  comp351_beta_d  =  
  Q10 * comp351_Abeta_d * 
    exp((v + -(comp351_V0beta_d)) / comp351_Kbeta_d)
}


PARAMETER {
  comp351_V0alpha_d  =  -83.94
  comp348_V_t  =  -35.0
  comp351_gbar  =  0.0009
  comp350_vcbase  =  -69.0
  comp351_V0beta_d  =  -83.94
  comp350_vcsteps  =  8.0
  comp350_vcinc  =  10.0
  comp351_Aalpha_d  =  0.13289
  comp350_vchdur  =  30.0
  comp349_C_m  =  1.0
  comp350_vcbdur  =  100.0
  comp348_celsius  =  30.0
  comp351_Kbeta_d  =  35.714
  comp351_Kalpha_d  =  -24.3902
  comp351_e  =  -84.69
  comp351_Abeta_d  =  0.16994
  comp350_vchold  =  -71.0
}


STATE {
  Kir_m
}


ASSIGNED {
  Kir_m_tau
  comp351_d_inf
  comp351_Q10
  Kir_m_inf
  comp351_tau_d
  celsius
  v
  ik
  ek
  i_Kir
}


PROCEDURE asgns () {
  comp351_Q10  =  3.0 ^ ((comp348_celsius + -20.0) / 10.0)
  comp351_tau_d  =  
  1.0 / 
    (comp351_alpha_d(v, comp351_Q10) + comp351_beta_d(v, comp351_Q10))
  comp351_d_inf  =  
  (comp351_alpha_d(v, comp351_Q10)) / 
    (comp351_alpha_d(v, comp351_Q10) + comp351_beta_d(v, comp351_Q10))
  Kir_m_inf  =  comp351_d_inf
  Kir_m_tau  =  comp351_tau_d
  ek  =  comp351_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_Kir  =  (comp351_gbar * Kir_m) * (v - comp351_e)
  ik  =  i_Kir
}


DERIVATIVE states {
  asgns ()
  Kir_m'  =  (Kir_m_inf + -(Kir_m)) / Kir_m_tau
}


INITIAL {
  asgns ()
  Kir_m  =  comp351_d_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g Kir_m = %g\n" , t, v,  Kir_m)
}
