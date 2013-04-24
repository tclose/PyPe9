

TITLE Granule_DeSouza10_CaHVA


NEURON {
  RANGE comp221_celsius, comp221_V_t, comp222_C_m, comp223_vchold, comp223_vcbase, comp223_vcinc, comp223_vcsteps, comp223_vchdur, comp223_vcbdur, comp224_gbar
  RANGE comp224_e, CaHVA_m, CaHVA_h
  RANGE i_CaHVA
  RANGE ica
  RANGE eca
  USEION ca READ cai, cao WRITE ica
}


FUNCTION comp224_alpha_u (v, Q10) {
  comp224_alpha_u  =  
  Q10 * comp224_Aalpha_u * 
    exp((v + -(comp224_V0alpha_u)) / comp224_Kalpha_u)
}


FUNCTION comp224_alpha_s (v, Q10) {
  comp224_alpha_s  =  
  Q10 * comp224_Aalpha_s * 
    exp((v + -(comp224_V0alpha_s)) / comp224_Kalpha_s)
}


FUNCTION comp224_beta_u (v, Q10) {
  comp224_beta_u  =  
  Q10 * comp224_Abeta_u * 
    exp((v + -(comp224_V0beta_u)) / comp224_Kbeta_u)
}


FUNCTION comp224_beta_s (v, Q10) {
  comp224_beta_s  =  
  Q10 * comp224_Abeta_s * 
    exp((v + -(comp224_V0beta_s)) / comp224_Kbeta_s)
}


PARAMETER {
  comp224_V0alpha_u  =  -48.0
  comp224_V0alpha_s  =  -29.06
  comp223_vchold  =  -71.0
  comp223_vcinc  =  10.0
  comp224_V0beta_u  =  -48.0
  comp224_V0beta_s  =  -18.66
  comp223_vcsteps  =  8.0
  comp224_Aalpha_u  =  0.0013
  comp224_Aalpha_s  =  0.04944
  comp223_vcbase  =  -69.0
  comp221_V_t  =  -35.0
  comp224_Kbeta_u  =  83.33
  comp224_Kbeta_s  =  -25.641
  comp221_celsius  =  30.0
  comp224_Kalpha_u  =  -18.183
  comp224_Kalpha_s  =  15.87301587302
  comp224_Abeta_u  =  0.0013
  comp224_Abeta_s  =  0.08298
  comp223_vchdur  =  30.0
  comp224_R  =  8.31342
  comp223_vcbdur  =  100.0
  comp224_F  =  96485.3
  comp224_gbar  =  0.00046
  comp222_C_m  =  1.0
}


STATE {
  CaHVA_h
  CaHVA_m
}


ASSIGNED {
  comp224_s_inf
  comp224_u_inf
  CaHVA_h_tau
  CaHVA_m_inf
  comp224_tau_u
  comp224_tau_s
  comp224_e
  CaHVA_h_inf
  comp224_Q10
  CaHVA_m_tau
  comp224_cao
  comp224_cai
  celsius
  v
  cao
  cai
  ica
  eca
  i_CaHVA
}


PROCEDURE asgns () {
  comp224_Q10  =  3.0 ^ ((comp221_celsius + -20.0) / 10.0)
  comp224_e  =  
  (1000.0 * comp224_R * (comp221_celsius + 273.15)) / (2.0 * comp224_F) 
    * 
    log(comp224_cao / comp224_cai)
  comp224_tau_s  =  
  1.0 / 
    (comp224_alpha_s(v, comp224_Q10) + comp224_beta_s(v, comp224_Q10))
  comp224_tau_u  =  
  1.0 / 
    (comp224_alpha_u(v, comp224_Q10) + comp224_beta_u(v, comp224_Q10))
  comp224_u_inf  =  
  (comp224_alpha_u(v, comp224_Q10)) / 
    (comp224_alpha_u(v, comp224_Q10) + comp224_beta_u(v, comp224_Q10))
  comp224_s_inf  =  
  (comp224_alpha_s(v, comp224_Q10)) / 
    (comp224_alpha_s(v, comp224_Q10) + comp224_beta_s(v, comp224_Q10))
  CaHVA_m_tau  =  comp224_tau_s
  CaHVA_h_inf  =  comp224_u_inf
  CaHVA_m_inf  =  comp224_s_inf
  CaHVA_h_tau  =  comp224_tau_s
  eca  =  comp224_e
}


BREAKPOINT {
  LOCAL x505
  SOLVE states METHOD derivimplicit
  x505  =  CaHVA_m 
i_CaHVA  =  (comp224_gbar * x505 * x505 * CaHVA_h) * (v - comp224_e)
  ica  =  i_CaHVA
}


DERIVATIVE states {
  comp224_cai  =  cai
  comp224_cao  =  cao
  asgns ()
  CaHVA_m'  =  (CaHVA_m_inf + -(CaHVA_m)) / CaHVA_m_tau
  CaHVA_h'  =  (CaHVA_h_inf + -(CaHVA_h)) / CaHVA_h_tau
}


INITIAL {
  comp224_cai  =  cai
  comp224_cao  =  cao
  asgns ()
  CaHVA_m  =  comp224_s_inf
  CaHVA_h  =  comp224_u_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
