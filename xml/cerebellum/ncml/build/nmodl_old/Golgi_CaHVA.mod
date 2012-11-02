

TITLE Golgi_CaHVA


NEURON {
  RANGE CaHVA_h, CaHVA_m, comp283_vcbdur, comp283_vchdur, comp283_vcsteps, comp283_vcinc, comp283_vcbase, comp283_vchold, comp19_e, comp19_gbar
  RANGE i_CaHVA
  RANGE ica
  RANGE eca
  USEION ca READ eca WRITE ica
}


FUNCTION comp19_beta_u (v, Q10) {
  comp19_beta_u  =  
  Q10 * comp19_Abeta_u * exp((v + -(comp19_V0beta_u)) / comp19_Kbeta_u)
}


FUNCTION comp19_beta_s (v, Q10) {
  comp19_beta_s  =  
  Q10 * comp19_Abeta_s * exp((v + -(comp19_V0beta_s)) / comp19_Kbeta_s)
}


FUNCTION comp19_alpha_s (v, Q10) {
  comp19_alpha_s  =  
  Q10 * comp19_Aalpha_s * 
    exp((v + -(comp19_V0alpha_s)) / comp19_Kalpha_s)
}


FUNCTION comp19_alpha_u (v, Q10) {
  comp19_alpha_u  =  
  Q10 * comp19_Aalpha_u * 
    exp((v + -(comp19_V0alpha_u)) / comp19_Kalpha_u)
}


PARAMETER {
  comp283_vchdur  =  30.0
  comp19_gbar  =  0.00046
  comp283_vchold  =  -71.0
  comp19_Abeta_s  =  0.08298
  comp19_Abeta_u  =  0.0013
  comp19_V0beta_s  =  -18.66
  comp19_V0beta_u  =  -48.0
  comp283_vcbase  =  -69.0
  comp19_Aalpha_s  =  0.04944
  comp19_Aalpha_u  =  0.0013
  comp19_e  =  129.33
  comp19_V0alpha_u  =  -48.0
  comp19_V0alpha_s  =  -29.06
  comp19_Kbeta_u  =  83.33
  comp19_Kbeta_s  =  -25.641
  comp283_vcbdur  =  100.0
  comp283_vcsteps  =  8.0
  comp283_vcinc  =  10.0
  comp19_Kalpha_s  =  15.87301587302
  comp19_Kalpha_u  =  -18.183
}


STATE {
  CaHVA_h
  CaHVA_m
}


ASSIGNED {
  CaHVA_m_tau
  comp19_Q10
  CaHVA_h_inf
  CaHVA_m_inf
  CaHVA_h_tau
  celsius
  v
  ica
  eca
  i_CaHVA
}


PROCEDURE asgns () {
  comp19_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  CaHVA_h_tau  =  
  1.0 / (comp19_alpha_u(v, comp19_Q10) + comp19_beta_u(v, comp19_Q10))
  CaHVA_m_inf  =  
  (comp19_alpha_s(v, comp19_Q10)) / 
    (comp19_alpha_s(v, comp19_Q10) + comp19_beta_s(v, comp19_Q10))
  CaHVA_h_inf  =  
  (comp19_alpha_u(v, comp19_Q10)) / 
    (comp19_alpha_u(v, comp19_Q10) + comp19_beta_u(v, comp19_Q10))
  CaHVA_m_tau  =  
  1.0 / (comp19_alpha_s(v, comp19_Q10) + comp19_beta_s(v, comp19_Q10))
}


BREAKPOINT {
  LOCAL v425
  SOLVE states METHOD derivimplicit
  v425  =  CaHVA_m 
i_CaHVA  =  (comp19_gbar * v425 * v425 * CaHVA_h) * (v - eca)
  ica  =  i_CaHVA
}


DERIVATIVE states {
  asgns ()
  CaHVA_m'  =  (CaHVA_m_inf + -(CaHVA_m)) / CaHVA_m_tau
  CaHVA_h'  =  (CaHVA_h_inf + -(CaHVA_h)) / CaHVA_h_tau
}


INITIAL {
  asgns ()
  CaHVA_h  =  
  (comp19_alpha_u(v, comp19_Q10)) / 
    (comp19_alpha_u(v, comp19_Q10) + comp19_beta_u(v, comp19_Q10))
  CaHVA_m  =  
  (comp19_alpha_s(v, comp19_Q10)) / 
    (comp19_alpha_s(v, comp19_Q10) + comp19_beta_s(v, comp19_Q10))
  eca  =  comp19_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
