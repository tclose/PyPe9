

TITLE Golgi_KM


NEURON {
  RANGE comp2941_vchold, comp2941_vcbase, comp2941_vcinc, comp2941_vcsteps, comp2941_vchdur, comp2941_vcbdur, comp3026_gbar, comp3026_e, KM_m
  RANGE i_KM
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp3026_alpha_n (v, Q10) {
  comp3026_alpha_n  =  
  Q10 * comp3026_Aalpha_n * 
    exp((v + -(comp3026_V0alpha_n)) / comp3026_Kalpha_n)
}


FUNCTION comp3026_beta_n (v, Q10) {
  comp3026_beta_n  =  
  Q10 * comp3026_Abeta_n * 
    exp((v + -(comp3026_V0beta_n)) / comp3026_Kbeta_n)
}


PARAMETER {
  comp3026_Kalpha_n  =  40.0
  comp2941_vchold  =  -71.0
  comp3026_V0beta_n  =  -30.0
  comp3026_V0_ninf  =  -35.0
  comp3026_Kbeta_n  =  -20.0
  comp3026_gbar  =  0.001
  comp2941_vchdur  =  30.0
  ca2o  =  2.0
  comp2941_vcbdur  =  100.0
  comp3026_B_ninf  =  6.0
  comp2941_vcbase  =  -69.0
  comp2941_vcsteps  =  8.0
  comp2941_vcinc  =  10.0
  comp3026_Aalpha_n  =  0.0033
  comp3026_e  =  -84.69
  comp3026_V0alpha_n  =  -30.0
  comp3026_Abeta_n  =  0.0033
}


STATE {
  KM_m
}


ASSIGNED {
  KM_m_inf
  comp3026_Q10
  KM_m_tau
  celsius
  v
  ik
  ek
  i_KM
}


PROCEDURE asgns () {
  comp3026_Q10  =  3.0 ^ ((celsius + -22.0) / 10.0)
  KM_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp3026_V0_ninf)) / comp3026_B_ninf))
  KM_m_tau  =  
  1.0 / 
    (comp3026_alpha_n(v, comp3026_Q10) + 
        comp3026_beta_n(v, comp3026_Q10))
  ek  =  comp3026_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KM  =  (comp3026_gbar * KM_m) * (v - ek)
  ik  =  i_KM
}


DERIVATIVE states {
  asgns ()
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
}


INITIAL {
  asgns ()
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp3026_V0_ninf)) / comp3026_B_ninf))
  ek  =  comp3026_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KM_m = %g\n" , t, v,  KM_m)
}
