

TITLE Golgi_KM


NEURON {
  RANGE KM_m, comp195_vcbdur, comp195_vchdur, comp195_vcsteps, comp195_vcinc, comp195_vcbase, comp195_vchold, comp19_e, comp19_gbar
  RANGE i_KM
  RANGE ik
  USEION k READ ek WRITE ik
}


FUNCTION comp19_beta_n (v, Q10) {
  comp19_beta_n  =  
  Q10 * comp19_Abeta_n * exp((v + -(comp19_V0beta_n)) / comp19_Kbeta_n)
}


FUNCTION comp19_alpha_n (v, Q10) {
  comp19_alpha_n  =  
  Q10 * comp19_Aalpha_n * 
    exp((v + -(comp19_V0alpha_n)) / comp19_Kalpha_n)
}


PARAMETER {
  comp19_Abeta_n  =  0.0033
  comp195_vchdur  =  30.0
  comp19_B_ninf  =  6.0
  comp19_V0_ninf  =  -35.0
  comp19_Kalpha_n  =  40.0
  comp19_Aalpha_n  =  0.0033
  comp195_vcsteps  =  8.0
  comp195_vcbase  =  -69.0
  comp19_V0beta_n  =  -30.0
  comp19_e  =  -84.69
  comp195_vchold  =  -71.0
  comp19_Kbeta_n  =  -20.0
  comp19_gbar  =  0.001
  comp195_vcinc  =  10.0
  comp19_V0alpha_n  =  -30.0
  comp195_vcbdur  =  100.0
}


STATE {
  KM_m
}


ASSIGNED {
  comp19_Q10
  KM_m_inf
  KM_m_tau
  v
  celsius
  ik
  ek
  i_KM
}


PROCEDURE asgns () {
  KM_m_inf  =  1.0 / (1.0 + exp(-(v + -(comp19_V0_ninf)) / comp19_B_ninf))
  comp19_Q10  =  3.0 ^ ((celsius + -22.0) / 10.0)
  KM_m_tau  =  
  1.0 / (comp19_alpha_n(v, comp19_Q10) + comp19_beta_n(v, comp19_Q10))
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KM  =  (comp19_gbar * KM_m) * (v - comp19_e)
  ik  =  i_KM
  print_state()
}


DERIVATIVE states {
  asgns ()
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
}


INITIAL {
  asgns ()
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp19_V0_ninf)) / comp19_B_ninf))
  print_state()
}


PROCEDURE print_state () {
  printf ("t = %g: KM_m = %g\n" , t,  KM_m)
}
