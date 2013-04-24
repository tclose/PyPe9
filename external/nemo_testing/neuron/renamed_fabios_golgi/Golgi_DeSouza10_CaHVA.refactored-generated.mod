

TITLE Golgi_DeSouza10_CaHVA


NEURON {
  RANGE celsius, V_t, c, vchold, vcbase, vcinc, vcsteps, vchdur, vcbdur, gbar
  RANGE e, CaHVA_m, CaHVA_h
  RANGE i_CaHVA
  RANGE ica
  RANGE eca
  RANGE F, R
  USEION ca READ cai, cao WRITE ica
}




PARAMETER {
  c  =  1.0
  V0alpha_u  =  -48.0
  V0alpha_s  =  -29.06
  vcinc  =  10.0
  vchold  =  -71.0
  V0beta_u  =  -48.0
  V0beta_s  =  -18.66
  vcsteps  =  8.0
  Aalpha_u  =  0.0013
  Aalpha_s  =  0.04944
  vcbase  =  -69.0
  Kbeta_u  =  83.33
  Kbeta_s  =  -25.641
  celsius  =  23.0
  Kalpha_u  =  -18.183
  Kalpha_s  =  15.87301587302
  Abeta_u  =  0.0013
  Abeta_s  =  0.08298
  R  =  8.31342
  F  =  96485.3
  vchdur  =  30.0
  vcbdur  =  100.0
  gbar  =  0.00046
  V_t  =  -35.0
}


STATE {
  CaHVA_h
  CaHVA_m
}


ASSIGNED {
  u_inf
  CaHVA_h_tau
  Q10
  e
  ek
  CaHVA_m_inf
  tau_u
  tau_s
  ena
  CaHVA_h_inf
  CaHVA_m_tau
  s_inf
  ko
  ki
  celsius
  v
  cao
  cai
  nao
  nai
  cao
  cai
  ica
  eca
  i_CaHVA
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (celsius + 273.15)) / F * log(ko / ki)
  e  =  
  (1000.0 * R * (celsius + 273.15)) / (2.0 * F) * 
    log(cao / cai)
  Q10  =  3.0 ^ ((celsius -20.0) / 10.0)
  s_inf  =  
  (alpha_s(v, Q10)) / 
    (alpha_s(v, Q10) + beta_s(v, Q10))
  tau_s  =  
  1.0 / 
    (alpha_s(v, Q10) + beta_s(v, Q10))
  tau_u  =  
  1.0 / 
    (alpha_u(v, Q10) + beta_u(v, Q10))
  u_inf  =  
  (alpha_u(v, Q10)) / 
    (alpha_u(v, Q10) + beta_u(v, Q10))
  CaHVA_m_tau  =  tau_s
  CaHVA_h_inf  =  u_inf
  CaHVA_m_inf  =  s_inf
  CaHVA_h_tau  =  tau_u
  eca  =  e
}


BREAKPOINT {
  LOCAL x695
  SOLVE states METHOD derivimplicit
  x695  =  CaHVA_m 
i_CaHVA  =  (gbar * x695 * x695 * CaHVA_h) * (v - e)
  ica  =  i_CaHVA
}


DERIVATIVE states {
  cai  =  cai
  cao  =  cao
  asgns ()
  CaHVA_m'  =  (CaHVA_m_inf + -(CaHVA_m)) / CaHVA_m_tau
  CaHVA_h'  =  (CaHVA_h_inf + -(CaHVA_h)) / CaHVA_h_tau
}


INITIAL {
  cai  =  cai
  cao  =  cao
  asgns ()
  CaHVA_m  =  s_inf
  CaHVA_h  =  u_inf
}


FUNCTION alpha_u (v, Q10) {
  alpha_u  =  
  Q10 * Aalpha_u * 
    exp((v + -V0alpha_u) / Kalpha_u)
}


FUNCTION alpha_s (v, Q10) {
  alpha_s  =  
  Q10 * Aalpha_s * 
    exp((v + -V0alpha_s) / Kalpha_s)
}


FUNCTION beta_u (v, Q10) {
  beta_u  =  
  Q10 * Abeta_u * 
    exp((v + -V0beta_u) / Kbeta_u)
}


FUNCTION beta_s (v, Q10) {
  beta_s  =  
  Q10 * Abeta_s * 
    exp((v + -V0beta_s) / Kbeta_s)
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
