

TITLE Golgi_DeSouza10_KM


NEURON {
  RANGE comp471_celsius, comp471_V_t, comp472_c, comp473_vchold, comp473_vcbase, comp473_vcinc, comp473_vcsteps, comp473_vchdur, comp473_vcbdur, comp474_gbar
  RANGE comp474_e, KM_m
  RANGE i_KM
  RANGE ik
  RANGE ek
  RANGE F, R
  USEION k READ ki, ko WRITE ik
}


FUNCTION comp474_alpha_n (v, Q10) {
  comp474_alpha_n  =  
  Q10 * comp474_Aalpha_n * 
    exp((v + -(comp474_V0alpha_n)) / comp474_Kalpha_n)
}


FUNCTION comp474_beta_n (v, Q10) {
  comp474_beta_n  =  
  Q10 * comp474_Abeta_n * 
    exp((v + -(comp474_V0beta_n)) / comp474_Kbeta_n)
}


PARAMETER {
  comp474_V0alpha_n  =  -30.0
  comp474_e  =  -84.69
  comp474_gbar  =  0.001
  comp473_vchold  =  -71.0
  comp474_B_ninf  =  6.0
  comp474_V0beta_n  =  -30.0
  comp473_vcsteps  =  8.0
  comp473_vcbase  =  -69.0
  comp474_Aalpha_n  =  0.0033
  comp473_vcinc  =  10.0
  comp474_Kbeta_n  =  -20.0
  comp471_celsius  =  23.0
  comp474_Kalpha_n  =  40.0
  R  =  8.31342
  comp474_Abeta_n  =  0.0033
  comp472_c  =  1.0
  F  =  96485.3
  comp473_vchdur  =  30.0
  comp473_vcbdur  =  100.0
  comp474_V0_ninf  =  -35.0
  comp471_V_t  =  -35.0
}


STATE {
  KM_m
}


ASSIGNED {
  comp474_Q10
  KM_m_inf
  ek
  ena
  KM_m_tau
  ko
  ki
  celsius
  v
  nao
  nai
  ik
  i_KM
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp471_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp471_celsius + 273.15)) / F * log(ko / ki)
  KM_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp474_V0_ninf)) / comp474_B_ninf))
  comp474_Q10  =  3.0 ^ ((comp471_celsius + -22.0) / 10.0)
  KM_m_tau  =  
  1.0 / 
    (comp474_alpha_n(v, comp474_Q10) + comp474_beta_n(v, comp474_Q10))
  ek  =  comp474_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KM  =  (comp474_gbar * KM_m) * (v - comp474_e)
  ik  =  i_KM
}


DERIVATIVE states {
  asgns ()
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
}


INITIAL {
  asgns ()
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp474_V0_ninf)) / comp474_B_ninf))
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KM_m = %g\n" , t, v,  KM_m)
}
