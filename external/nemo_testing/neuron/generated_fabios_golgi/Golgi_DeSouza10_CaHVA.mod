

TITLE Golgi_DeSouza10_CaHVA


NEURON {
  RANGE comp255_celsius, comp255_V_t, comp256_c, comp257_vchold, comp257_vcbase, comp257_vcinc, comp257_vcsteps, comp257_vchdur, comp257_vcbdur, comp258_gbar
  RANGE comp258_e, CaHVA_m, CaHVA_h
  RANGE i_CaHVA
  RANGE ica
  RANGE eca
  RANGE F, R
  USEION ca READ cai, cao WRITE ica
}


FUNCTION comp258_alpha_u (v, Q10) {
  comp258_alpha_u  =  
  Q10 * comp258_Aalpha_u * 
    exp((v + -(comp258_V0alpha_u)) / comp258_Kalpha_u)
}


FUNCTION comp258_alpha_s (v, Q10) {
  comp258_alpha_s  =  
  Q10 * comp258_Aalpha_s * 
    exp((v + -(comp258_V0alpha_s)) / comp258_Kalpha_s)
}


FUNCTION comp258_beta_u (v, Q10) {
  comp258_beta_u  =  
  Q10 * comp258_Abeta_u * 
    exp((v + -(comp258_V0beta_u)) / comp258_Kbeta_u)
}


FUNCTION comp258_beta_s (v, Q10) {
  comp258_beta_s  =  
  Q10 * comp258_Abeta_s * 
    exp((v + -(comp258_V0beta_s)) / comp258_Kbeta_s)
}


PARAMETER {
  comp256_c  =  1.0
  comp258_V0alpha_u  =  -48.0
  comp258_V0alpha_s  =  -29.06
  comp257_vcinc  =  10.0
  comp257_vchold  =  -71.0
  comp258_V0beta_u  =  -48.0
  comp258_V0beta_s  =  -18.66
  comp257_vcsteps  =  8.0
  comp258_Aalpha_u  =  0.0013
  comp258_Aalpha_s  =  0.04944
  comp257_vcbase  =  -69.0
  comp258_Kbeta_u  =  83.33
  comp258_Kbeta_s  =  -25.641
  comp255_celsius  =  23.0
  comp258_Kalpha_u  =  -18.183
  comp258_Kalpha_s  =  15.87301587302
  comp258_Abeta_u  =  0.0013
  comp258_Abeta_s  =  0.08298
  R  =  8.31342
  F  =  96485.3
  comp257_vchdur  =  30.0
  comp257_vcbdur  =  100.0
  comp258_gbar  =  0.00046
  comp255_V_t  =  -35.0
}


STATE {
  CaHVA_h
  CaHVA_m
}


ASSIGNED {
  comp258_u_inf
  CaHVA_h_tau
  comp258_Q10
  comp258_e
  ek
  CaHVA_m_inf
  comp258_tau_u
  comp258_tau_s
  ena
  CaHVA_h_inf
  CaHVA_m_tau
  comp258_s_inf
  ko
  ki
  celsius
  v
  comp258_cao
  comp258_cai
  nao
  nai
  cao
  cai
  ica
  eca
  i_CaHVA
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp255_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp255_celsius + 273.15)) / F * log(ko / ki)
  comp258_e  =  
  (1000.0 * R * (comp255_celsius + 273.15)) / (2.0 * F) * 
    log(comp258_cao / comp258_cai)
  comp258_Q10  =  3.0 ^ ((comp255_celsius + -20.0) / 10.0)
  comp258_s_inf  =  
  (comp258_alpha_s(v, comp258_Q10)) / 
    (comp258_alpha_s(v, comp258_Q10) + comp258_beta_s(v, comp258_Q10))
  comp258_tau_s  =  
  1.0 / 
    (comp258_alpha_s(v, comp258_Q10) + comp258_beta_s(v, comp258_Q10))
  comp258_tau_u  =  
  1.0 / 
    (comp258_alpha_u(v, comp258_Q10) + comp258_beta_u(v, comp258_Q10))
  comp258_u_inf  =  
  (comp258_alpha_u(v, comp258_Q10)) / 
    (comp258_alpha_u(v, comp258_Q10) + comp258_beta_u(v, comp258_Q10))
  CaHVA_m_tau  =  comp258_tau_s
  CaHVA_h_inf  =  comp258_u_inf
  CaHVA_m_inf  =  comp258_s_inf
  CaHVA_h_tau  =  comp258_tau_u
  eca  =  comp258_e
}


BREAKPOINT {
  LOCAL x695
  SOLVE states METHOD derivimplicit
  x695  =  CaHVA_m 
i_CaHVA  =  (comp258_gbar * x695 * x695 * CaHVA_h) * (v - comp258_e)
  ica  =  i_CaHVA
}


DERIVATIVE states {
  comp258_cai  =  cai
  comp258_cao  =  cao
  asgns ()
  CaHVA_m'  =  (CaHVA_m_inf + -(CaHVA_m)) / CaHVA_m_tau
  CaHVA_h'  =  (CaHVA_h_inf + -(CaHVA_h)) / CaHVA_h_tau
}


INITIAL {
  comp258_cai  =  cai
  comp258_cao  =  cao
  asgns ()
  CaHVA_m  =  comp258_s_inf
  CaHVA_h  =  comp258_u_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
