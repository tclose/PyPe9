

TITLE Golgi_KA


NEURON {
  RANGE KA_h, KA_m, comp355_vcbdur, comp355_vchdur, comp355_vcsteps, comp355_vcinc, comp355_vcbase, comp355_vchold, comp35_e, comp35_gbar
  RANGE i_KA
  RANGE ik
  USEION k READ ek WRITE ik
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION comp35_beta_b (v, Q10) {
  comp35_beta_b  =  
  Q10 * comp35_Abeta_b * sigm(v + -(comp35_V0beta_b), comp35_Kbeta_b)
}


FUNCTION comp35_beta_a (v, Q10) {
  comp35_beta_a  =  
  Q10 * comp35_Abeta_a / exp((v + -(comp35_V0beta_a)) / comp35_Kbeta_a)
}


FUNCTION comp35_alpha_b (v, Q10) {
  comp35_alpha_b  =  
  Q10 * comp35_Aalpha_b * sigm(v + -(comp35_V0alpha_b), comp35_Kalpha_b)
}


FUNCTION comp35_alpha_a (v, Q10) {
  comp35_alpha_a  =  
  Q10 * comp35_Aalpha_a * sigm(v + -(comp35_V0alpha_a), comp35_Kalpha_a)
}


PARAMETER {
  comp35_V0_ainf  =  -38.0
  comp35_e  =  -84.69
  comp35_gbar  =  0.008
  comp355_vchold  =  -71.0
  comp35_V0beta_b  =  -49.9537
  comp35_V0beta_a  =  -18.27914
  comp355_vcinc  =  10.0
  comp355_vcbase  =  -69.0
  comp35_Abeta_b  =  0.0345
  comp35_Abeta_a  =  0.1655
  comp35_Kalpha_a  =  -23.32708
  comp35_Kbeta_a  =  19.47175
  comp35_Kalpha_b  =  12.8433
  comp35_Kbeta_b  =  -8.90123
  comp35_K_ainf  =  -17.0
  comp355_vchdur  =  30.0
  comp35_Aalpha_a  =  0.8147
  comp35_Aalpha_b  =  0.0368
  comp355_vcbdur  =  100.0
  comp355_vcsteps  =  8.0
  comp35_V0alpha_a  =  -9.17203
  comp35_V0alpha_b  =  -111.33209
  comp35_K_binf  =  8.4
  comp35_V0_binf  =  -78.8
}


STATE {
  KA_h
  KA_m
}


ASSIGNED {
  comp35_tau_b
  comp35_tau_a
  KA_m_tau
  KA_m_inf
  comp35_Q10
  comp35_b_inf
  KA_h_tau
  KA_h_inf
  comp35_a_inf
  v
  celsius
  ik
  ek
  i_KA
}


PROCEDURE asgns () {
  comp35_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp35_V0_ainf)) / comp35_K_ainf))
  comp35_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp35_V0_binf)) / comp35_K_binf))
  comp35_Q10  =  3.0 ^ ((celsius + -25.5) / 10.0)
  KA_h_inf  =  comp35_b_inf
  KA_m_inf  =  comp35_a_inf
  comp35_tau_a  =  
  1.0 / (comp35_alpha_a(v, comp35_Q10) + comp35_beta_a(v, comp35_Q10))
  comp35_tau_b  =  
  1.0 / (comp35_alpha_b(v, comp35_Q10) + comp35_beta_b(v, comp35_Q10))
  KA_h_tau  =  comp35_tau_b
  KA_m_tau  =  comp35_tau_a
}


BREAKPOINT {
  LOCAL v497
  SOLVE states METHOD derivimplicit
  v497  =  KA_m 
i_KA  =  (comp35_gbar * v497 * v497 * v497 * KA_h) * (v - comp35_e)
  ik  =  i_KA
}


DERIVATIVE states {
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
}


INITIAL {
  asgns ()
  KA_h  =  comp35_b_inf
  KA_m  =  comp35_a_inf
}


PROCEDURE print_state () {
  printf ("KA_h = %g\n" ,  KA_h)
  printf ("KA_m = %g\n" ,  KA_m)
}
