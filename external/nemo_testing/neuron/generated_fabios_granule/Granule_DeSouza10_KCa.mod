

TITLE Granule_DeSouza10_KCa


NEURON {
  RANGE comp314_celsius, comp314_V_t, comp315_C_m, comp316_vchold, comp316_vcbase, comp316_vcinc, comp316_vcsteps, comp316_vchdur, comp316_vcbdur, comp317_gbar
  RANGE comp317_e, KCa_m
  RANGE i_KCa
  RANGE ik
  RANGE ek
  RANGE cai
  USEION ca READ cai
  USEION k READ ek WRITE ik
}


FUNCTION comp317_alpha_c (v, cai, Q10) {
  comp317_alpha_c  =  
  (Q10 * comp317_Aalpha_c) / 
    (1.0 + (comp317_Balpha_c * exp(v / comp317_Kalpha_c)) / cai)
}


FUNCTION comp317_beta_c (v, cai, Q10) {
  comp317_beta_c  =  
  (Q10 * comp317_Abeta_c) / 
    (1.0 + cai / (comp317_Bbeta_c * exp(v / comp317_Kbeta_c)))
}


PARAMETER {
  comp316_vcinc  =  10.0
  comp316_vcbase  =  -69.0
  comp317_e  =  -84.69
  comp315_C_m  =  1.0
  comp317_Balpha_c  =  0.0015
  comp316_vcsteps  =  8.0
  comp316_vchdur  =  30.0
  comp316_vcbdur  =  100.0
  comp317_gbar  =  0.04
  comp317_Aalpha_c  =  2.5
  comp314_celsius  =  30.0
  comp317_Kbeta_c  =  -11.765
  comp317_Kalpha_c  =  -11.765
  comp316_vchold  =  -71.0
  comp314_V_t  =  -35.0
  comp317_Abeta_c  =  1.5
  comp317_Bbeta_c  =  0.00015
}


STATE {
  KCa_m
}


ASSIGNED {
  KCa_m_inf
  comp317_Q10
  comp317_c_inf
  comp317_cai1
  comp317_tau_c
  KCa_m_tau
  comp317_cai
  celsius
  v
  cai
  ik
  ek
  i_KCa
}


PROCEDURE asgns () {
  LOCAL v508
  if (comp317_cai < 0.0001)  {v508  =  0.0001} else {v508  =  comp317_cai} 
comp317_cai1  =  v508
  comp317_Q10  =  3.0 ^ ((comp314_celsius + -30.0) / 10.0)
  comp317_tau_c  =  
  1.0 / 
    (comp317_alpha_c(v, comp317_cai, comp317_Q10) + 
        comp317_beta_c(v, comp317_cai, comp317_Q10))
  comp317_c_inf  =  
  (comp317_alpha_c(v, comp317_cai, comp317_Q10)) / 
    (comp317_alpha_c(v, comp317_cai, comp317_Q10) + 
        comp317_beta_c(v, comp317_cai, comp317_Q10))
  KCa_m_tau  =  comp317_tau_c
  KCa_m_inf  =  comp317_c_inf
  ek  =  comp317_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KCa  =  (comp317_gbar * KCa_m) * (v - comp317_e)
  ik  =  i_KCa
}


DERIVATIVE states {
  comp317_cai  =  cai
  asgns ()
  KCa_m'  =  (KCa_m_inf + -(KCa_m)) / KCa_m_tau
}


INITIAL {
  comp317_cai  =  cai
  asgns ()
  KCa_m  =  comp317_c_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KCa_m = %g\n" , t, v,  KCa_m)
}
