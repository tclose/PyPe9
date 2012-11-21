

TITLE DeSouzaCGC_KA


NEURON {
  RANGE comp813_vchold, comp813_vcbase, comp813_vcinc, comp813_vcsteps, comp813_vchdur, comp813_vcbdur, comp898_gbar, comp898_e, KA_m, KA_h
  RANGE i_KA
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp898_alpha_b (v, Q10) {
  comp898_alpha_b  =  
  Q10 * comp898_Aalpha_b * 
    sigm(v + -(comp898_V0alpha_b), comp898_Kalpha_b)
}


FUNCTION comp898_alpha_a (v, Q10) {
  comp898_alpha_a  =  
  Q10 * comp898_Aalpha_a * 
    sigm(v + -(comp898_V0alpha_a), comp898_Kalpha_a)
}


FUNCTION comp898_beta_b (v, Q10) {
  comp898_beta_b  =  
  Q10 * comp898_Abeta_b * sigm(v + -(comp898_V0beta_b), comp898_Kbeta_b)
}


FUNCTION comp898_beta_a (v, Q10) {
  comp898_beta_a  =  
  Q10 * 
    comp898_Abeta_a / exp((v + -(comp898_V0beta_a)) / comp898_Kbeta_a)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3289
  if 
    (fabs(x / y) < 1e-06) 
     {v3289  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3289  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3289
}


PARAMETER {
  comp898_e  =  -84.69
  comp898_Kalpha_b  =  12.8433
  comp898_Kalpha_a  =  -23.32708
  comp898_gbar  =  0.0032
  comp898_V0beta_b  =  -49.9537
  comp898_V0beta_a  =  -18.27914
  comp813_vcbdur  =  100.0
  comp898_Kbeta_b  =  -8.90123
  comp898_Kbeta_a  =  19.47175
  comp813_vcbase  =  -69.0
  comp898_K_binf  =  8.4
  comp898_K_ainf  =  -17.0
  comp813_vcsteps  =  8.0
  comp898_V0_binf  =  -78.8
  comp898_Aalpha_b  =  0.0368
  comp898_Aalpha_a  =  0.8147
  comp813_vchold  =  -71.0
  comp898_V0_ainf  =  -38.0
  comp898_V0alpha_b  =  -111.33209
  comp898_V0alpha_a  =  -9.17203
  comp898_Abeta_b  =  0.0345
  comp898_Abeta_a  =  0.1655
  comp813_vchdur  =  30.0
  comp813_vcinc  =  10.0
}


STATE {
  KA_h
  KA_m
}


ASSIGNED {
  KA_m_tau
  KA_m_inf
  comp898_Q10
  comp898_b_inf
  comp898_tau_b
  comp898_tau_a
  KA_h_tau
  comp898_a_inf
  KA_h_inf
  celsius
  v
  ik
  ek
  i_KA
}


PROCEDURE asgns () {
  comp898_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp898_V0_ainf)) / comp898_K_ainf))
  comp898_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp898_V0_binf)) / comp898_K_binf))
  comp898_Q10  =  3.0 ^ ((celsius + -25.5) / 10.0)
  KA_h_inf  =  comp898_b_inf
  comp898_tau_a  =  
  1.0 / 
    (comp898_alpha_a(v, comp898_Q10) + comp898_beta_a(v, comp898_Q10))
  comp898_tau_b  =  
  1.0 / 
    (comp898_alpha_b(v, comp898_Q10) + comp898_beta_b(v, comp898_Q10))
  KA_m_inf  =  comp898_a_inf
  KA_h_tau  =  comp898_tau_b
  KA_m_tau  =  comp898_tau_a
  ek  =  comp898_e
}


BREAKPOINT {
  LOCAL v3291
  SOLVE states METHOD derivimplicit
  v3291  =  KA_m 
i_KA  =  (comp898_gbar * v3291 * v3291 * v3291 * KA_h) * (v - ek)
  ik  =  i_KA
}


DERIVATIVE states {
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
}


INITIAL {
  asgns ()
  KA_h  =  1.0 / (1.0 + exp((v + -(comp898_V0_binf)) / comp898_K_binf))
  KA_m  =  1.0 / (1.0 + exp((v + -(comp898_V0_ainf)) / comp898_K_ainf))
  ek  =  comp898_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KA_h = %g\n" , t, v,  KA_h)
  printf ("NMODL state: t = %g v = %g KA_m = %g\n" , t, v,  KA_m)
}
