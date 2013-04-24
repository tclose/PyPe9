

TITLE Golgi_DeSouza10_KCa


NEURON {
  RANGE comp437_celsius, comp437_V_t, comp438_c, comp439_vchold, comp439_vcbase, comp439_vcinc, comp439_vcsteps, comp439_vchdur, comp439_vcbdur, comp440_gbar
  RANGE comp440_e, KCa_m
  RANGE i_KCa
  RANGE ik
  RANGE ek
  RANGE cai
  RANGE F, R
  USEION ca READ cai
  USEION k READ ki, ko WRITE ik
}


FUNCTION comp440_alpha_c (v, cai, Q10) {
  comp440_alpha_c  =  
  (Q10 * comp440_Aalpha_c) / 
    (1.0 + (comp440_Balpha_c * exp(v / comp440_Kalpha_c)) / cai)
}


FUNCTION comp440_beta_c (v, cai, Q10) {
  comp440_beta_c  =  
  (Q10 * comp440_Abeta_c) / 
    (1.0 + cai / (comp440_Bbeta_c * exp(v / comp440_Kbeta_c)))
}


PARAMETER {
  comp439_vcbdur  =  100.0
  comp440_gbar  =  0.003
  comp439_vcinc  =  10.0
  comp438_c  =  1.0
  comp440_Balpha_c  =  0.0015
  comp437_V_t  =  -35.0
  comp439_vchold  =  -71.0
  comp439_vcsteps  =  8.0
  comp440_Aalpha_c  =  7.0
  comp437_celsius  =  23.0
  comp440_Kbeta_c  =  -11.765
  comp439_vcbase  =  -69.0
  comp440_Kalpha_c  =  -11.765
  R  =  8.31342
  F  =  96485.3
  comp440_Abeta_c  =  1.0
  comp440_Bbeta_c  =  0.00015
  comp439_vchdur  =  30.0
}


STATE {
  KCa_m
}


ASSIGNED {
  comp440_c_inf
  KCa_m_inf
  comp440_tau_c
  ek
  comp440_e
  KCa_m_tau
  ena
  comp440_Q10
  ko
  ki
  comp440_cai
  celsius
  v
  nao
  nai
  cai
  ik
  i_KCa
}


PROCEDURE asgns () {
  comp440_Q10  =  3.0 ^ ((comp437_celsius + -30.0) / 10.0)
  ena  =  (1000.0 * R * (comp437_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp437_celsius + 273.15)) / F * log(ko / ki)
  comp440_e  =  ek
  comp440_tau_c  =  
  1.0 / 
    (comp440_alpha_c(v, comp440_cai, comp440_Q10) + 
        comp440_beta_c(v, comp440_cai, comp440_Q10))
  comp440_c_inf  =  
  (comp440_alpha_c(v, comp440_cai, comp440_Q10)) / 
    (comp440_alpha_c(v, comp440_cai, comp440_Q10) + 
        comp440_beta_c(v, comp440_cai, comp440_Q10))
  KCa_m_tau  =  comp440_tau_c
  KCa_m_inf  =  comp440_c_inf
  ek  =  comp440_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KCa  =  (comp440_gbar * KCa_m) * (v - comp440_e)
  ik  =  i_KCa
}


DERIVATIVE states {
  comp440_cai  =  cai
  asgns ()
  KCa_m'  =  (KCa_m_inf + -(KCa_m)) / KCa_m_tau
}


INITIAL {
  comp440_cai  =  cai
  asgns ()
  KCa_m  =  comp440_c_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KCa_m = %g\n" , t, v,  KCa_m)
}
