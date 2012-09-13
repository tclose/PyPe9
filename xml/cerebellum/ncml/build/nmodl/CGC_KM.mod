

TITLE CGC_KM


NEURON {
  RANGE KM_m, comp235_vcbdur, comp235_vchdur, comp235_vcsteps, comp235_vcinc, comp235_vcbase, comp235_vchold, comp47_e, comp47_gbar
  RANGE i_KM
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp47_alpha_n (v) {
  comp47_alpha_n  =  
  comp47_Q10 * comp47_Aalpha_n * 
    exp((v + -(comp47_V0alpha_n)) / comp47_Kalpha_n)
}


FUNCTION comp47_beta_n (v) {
  comp47_beta_n  =  
  comp47_Q10 * comp47_Abeta_n * 
    exp((v + -(comp47_V0beta_n)) / comp47_Kbeta_n)
}


PARAMETER {
  comp47_Kalpha_n  =  40.0
  comp235_vchold  =  -71.0
  comp47_V0beta_n  =  -30.0
  comp47_V0_ninf  =  -30.0
  comp47_Kbeta_n  =  -20.0
  Vrest  =  -68.0
  comp235_vchdur  =  30.0
  comp47_gbar  =  0.00035
  comp47_B_ninf  =  6.0
  fix_celsius  =  30.0
  comp235_vcbdur  =  100.0
  comp235_vcbase  =  -69.0
  comp47_e  =  -84.69
  comp235_vcinc  =  10.0
  comp235_vcsteps  =  8.0
  comp47_Aalpha_n  =  0.0033
  comp47_V0alpha_n  =  -30.0
  comp47_Abeta_n  =  0.0033
  comp47_Q10  =  2.40822468528069
}


STATE {
  KM_m
}


ASSIGNED {
  KM_m_inf
  KM_m_tau
  ica
  cai
  v
  ik
  ek
  i_KM
}


PROCEDURE asgns () {
  KM_m_tau  =  1.0 / (comp47_alpha_n(v) + comp47_beta_n(v))
  KM_m_inf  =  1.0 / (1.0 + exp(-(v + -(comp47_V0_ninf)) / comp47_B_ninf))
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KM  =  (comp47_gbar * KM_m) * (v - ek)
  ik  =  i_KM
}


DERIVATIVE states {
  asgns ()
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
}


INITIAL {
  asgns ()
  KM_m  =  (comp47_alpha_n(v)) / (comp47_alpha_n(v) + comp47_beta_n(v))
  ek  =  comp47_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KM_m = %g\n" , t, v,  KM_m)
}
