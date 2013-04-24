

TITLE Granule_DeSouza10_KM


NEURON {
  RANGE comp379_celsius, comp379_V_t, comp380_C_m, comp381_vchold, comp381_vcbase, comp381_vcinc, comp381_vcsteps, comp381_vchdur, comp381_vcbdur, comp382_gbar
  RANGE comp382_e, KM_m
  RANGE i_KM
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp382_beta_n (v, Q10) {
  comp382_beta_n  =  
  Q10 * comp382_Abeta_n * 
    exp((v + -(comp382_V0beta_n)) / comp382_Kbeta_n)
}


FUNCTION comp382_alpha_n (v, Q10) {
  comp382_alpha_n  =  
  Q10 * comp382_Aalpha_n * 
    exp((v + -(comp382_V0alpha_n)) / comp382_Kalpha_n)
}


PARAMETER {
  comp381_vcbdur  =  100.0
  comp379_V_t  =  -35.0
  comp382_V0alpha_n  =  -30.0
  comp382_V0beta_n  =  -30.0
  comp381_vchold  =  -71.0
  comp381_vcsteps  =  8.0
  comp382_B_ninf  =  6.0
  comp382_Aalpha_n  =  0.0033
  comp380_C_m  =  1.0
  comp382_Kbeta_n  =  -20.0
  comp379_celsius  =  30.0
  comp381_vcbase  =  -69.0
  comp382_Kalpha_n  =  40.0
  comp382_Abeta_n  =  0.0033
  comp381_vcinc  =  10.0
  comp382_e  =  -84.69
  comp382_V0_ninf  =  -35.0
  comp382_gbar  =  0.00025
  comp381_vchdur  =  30.0
}


STATE {
  KM_m
}


ASSIGNED {
  KM_m_inf
  comp382_Q10
  KM_m_tau
  celsius
  v
  ik
  ek
  i_KM
}


PROCEDURE asgns () {
  comp382_Q10  =  3.0 ^ ((comp379_celsius + -22.0) / 10.0)
  KM_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp382_V0_ninf)) / comp382_B_ninf))
  KM_m_tau  =  
  1.0 / 
    (comp382_alpha_n(v, comp382_Q10) + comp382_beta_n(v, comp382_Q10))
  ek  =  comp382_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KM  =  (comp382_gbar * KM_m) * (v - comp382_e)
  ik  =  i_KM
}


DERIVATIVE states {
  asgns ()
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
}


INITIAL {
  asgns ()
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp382_V0_ninf)) / comp382_B_ninf))
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KM_m = %g\n" , t, v,  KM_m)
}
