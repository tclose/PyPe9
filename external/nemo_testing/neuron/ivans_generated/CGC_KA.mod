

TITLE CGC_KA


NEURON {
  RANGE comp633_vchold, comp633_vcbase, comp633_vcinc, comp633_vcsteps, comp633_vchdur, comp633_vcbdur, comp718_gbar, comp718_e, KA_m, KA_h
  RANGE i_KA
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp718_beta_a (v, Q10) {
  comp718_beta_a  =  
  Q10 * 
    comp718_Abeta_a / exp((v + -(comp718_V0beta_a)) / comp718_Kbeta_a)
}


FUNCTION comp718_beta_b (v, Q10) {
  comp718_beta_b  =  
  Q10 * comp718_Abeta_b * sigm(v + -(comp718_V0beta_b), comp718_Kbeta_b)
}


FUNCTION comp718_alpha_b (v, Q10) {
  comp718_alpha_b  =  
  Q10 * comp718_Aalpha_b * 
    sigm(v + -(comp718_V0alpha_b), comp718_Kalpha_b)
}


FUNCTION comp718_alpha_a (v, Q10) {
  comp718_alpha_a  =  
  Q10 * comp718_Aalpha_a * 
    sigm(v + -(comp718_V0alpha_a), comp718_Kalpha_a)
}


FUNCTION linoid (x, y) {
  LOCAL v3033
  if 
    (fabs(x / y) < 1e-06) 
     {v3033  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3033  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3033
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


PARAMETER {
  comp633_vchdur  =  30.0
  comp718_K_binf  =  8.4
  comp633_vcsteps  =  8.0
  comp718_Kbeta_b  =  -8.90123
  comp718_Kbeta_a  =  19.47175
  comp633_vchold  =  -71.0
  comp718_Kalpha_a  =  -23.32708
  comp718_Kalpha_b  =  12.8433
  comp633_vcbase  =  -69.0
  comp718_V0beta_b  =  -49.9537
  comp718_V0beta_a  =  -18.27914
  comp633_vcbdur  =  100.0
  comp718_Abeta_b  =  0.0345
  comp718_Abeta_a  =  0.1655
  comp718_K_ainf  =  -17.0
  comp718_V0_ainf  =  -38.0
  comp718_V0alpha_a  =  -9.17203
  comp718_V0alpha_b  =  -111.33209
  comp718_gbar  =  0.0032
  comp718_V0_binf  =  -78.8
  comp718_e  =  -84.69
  comp633_vcinc  =  10.0
  comp718_Aalpha_b  =  0.0368
  comp718_Aalpha_a  =  0.8147
}


STATE {
  KA_h
  KA_m
}


ASSIGNED {
  comp718_tau_a
  comp718_tau_b
  KA_h_inf
  comp718_a_inf
  KA_m_inf
  KA_m_tau
  KA_h_tau
  comp718_b_inf
  comp718_Q10
  v
  celsius
  ik
  ek
  i_KA
}


PROCEDURE asgns () {
  comp718_Q10  =  3.0 ^ ((celsius + -25.5) / 10.0)
  comp718_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp718_V0_binf)) / comp718_K_binf))
  comp718_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp718_V0_ainf)) / comp718_K_ainf))
  KA_m_inf  =  comp718_a_inf
  KA_h_inf  =  comp718_b_inf
  comp718_tau_b  =  
  1.0 / 
    (comp718_alpha_b(v, comp718_Q10) + comp718_beta_b(v, comp718_Q10))
  comp718_tau_a  =  
  1.0 / 
    (comp718_alpha_a(v, comp718_Q10) + comp718_beta_a(v, comp718_Q10))
  KA_h_tau  =  comp718_tau_b
  KA_m_tau  =  comp718_tau_a
}


BREAKPOINT {
  LOCAL v3035
  SOLVE states METHOD derivimplicit
  v3035  =  KA_m 
i_KA  =  (comp718_gbar * v3035 * v3035 * v3035 * KA_h) * (v - ek)
  ik  =  i_KA
}


DERIVATIVE states {
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
}


INITIAL {
  asgns ()
  KA_h  =  1.0 / (1.0 + exp((v + -(comp718_V0_binf)) / comp718_K_binf))
  KA_m  =  1.0 / (1.0 + exp((v + -(comp718_V0_ainf)) / comp718_K_ainf))
  ek  =  comp718_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KA_h = %g\n" , t, v,  KA_h)
  printf ("NMODL state: t = %g v = %g KA_m = %g\n" , t, v,  KA_m)
}
