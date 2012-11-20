

TITLE Golgi_CaHVA


NEURON {
  RANGE comp441_vchold, comp441_vcbase, comp441_vcinc, comp441_vcsteps, comp441_vchdur, comp441_vcbdur, comp526_gbar, comp526_e, CaHVA_m, CaHVA_h
  RANGE i_CaHVA
  RANGE ica
  RANGE eca
  USEION ca READ eca WRITE ica
}


FUNCTION comp526_alpha_u (v, Q10) {
  comp526_alpha_u  =  
  Q10 * comp526_Aalpha_u * 
    exp((v + -(comp526_V0alpha_u)) / comp526_Kalpha_u)
}


FUNCTION comp526_alpha_s (v, Q10) {
  comp526_alpha_s  =  
  Q10 * comp526_Aalpha_s * 
    exp((v + -(comp526_V0alpha_s)) / comp526_Kalpha_s)
}


FUNCTION comp526_beta_u (v, Q10) {
  comp526_beta_u  =  
  Q10 * comp526_Abeta_u * 
    exp((v + -(comp526_V0beta_u)) / comp526_Kbeta_u)
}


FUNCTION comp526_beta_s (v, Q10) {
  comp526_beta_s  =  
  Q10 * comp526_Abeta_s * 
    exp((v + -(comp526_V0beta_s)) / comp526_Kbeta_s)
}


PARAMETER {
  comp526_Kalpha_u  =  -18.183
  comp526_Kalpha_s  =  15.87301587302
  comp441_vchold  =  -71.0
  comp526_V0beta_u  =  -48.0
  comp526_V0beta_s  =  -18.66
  comp526_Kbeta_u  =  83.33
  comp526_Kbeta_s  =  -25.641
  comp441_vchdur  =  30.0
  ca2o  =  2.0
  comp526_e  =  129.33
  comp441_vcbdur  =  100.0
  comp441_vcbase  =  -69.0
  comp441_vcsteps  =  8.0
  comp526_gbar  =  0.00046
  comp441_vcinc  =  10.0
  comp526_Aalpha_u  =  0.0013
  comp526_Aalpha_s  =  0.04944
  comp526_V0alpha_u  =  -48.0
  comp526_V0alpha_s  =  -29.06
  comp526_Abeta_u  =  0.0013
  comp526_Abeta_s  =  0.08298
}


STATE {
  CaHVA_h
  CaHVA_m
}


ASSIGNED {
  comp526_Q10
  CaHVA_m_tau
  CaHVA_m_inf
  CaHVA_h_tau
  CaHVA_h_inf
  celsius
  v
  ica
  eca
  i_CaHVA
}


PROCEDURE asgns () {
  comp526_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  CaHVA_h_inf  =  
  (comp526_alpha_u(v, comp526_Q10)) / 
    (comp526_alpha_u(v, comp526_Q10) + comp526_beta_u(v, comp526_Q10))
  CaHVA_h_tau  =  
  1.0 / 
    (comp526_alpha_u(v, comp526_Q10) + comp526_beta_u(v, comp526_Q10))
  CaHVA_m_inf  =  
  (comp526_alpha_s(v, comp526_Q10)) / 
    (comp526_alpha_s(v, comp526_Q10) + comp526_beta_s(v, comp526_Q10))
  CaHVA_m_tau  =  
  1.0 / 
    (comp526_alpha_s(v, comp526_Q10) + comp526_beta_s(v, comp526_Q10))
  eca  =  comp526_e
}


BREAKPOINT {
  LOCAL v5266
  SOLVE states METHOD derivimplicit
  v5266  =  CaHVA_m 
i_CaHVA  =  (comp526_gbar * v5266 * v5266 * CaHVA_h) * (v - eca)
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
  (comp526_alpha_u(v, comp526_Q10)) / 
    (comp526_alpha_u(v, comp526_Q10) + comp526_beta_u(v, comp526_Q10))
  CaHVA_m  =  
  (comp526_alpha_s(v, comp526_Q10)) / 
    (comp526_alpha_s(v, comp526_Q10) + comp526_beta_s(v, comp526_Q10))
  eca  =  comp526_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
