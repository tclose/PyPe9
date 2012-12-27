

TITLE Golgi_KA


NEURON {
  RANGE comp2103_vchold, comp2103_vcbase, comp2103_vcinc, comp2103_vcsteps, comp2103_vchdur, comp2103_vcbdur, comp2188_gbar, comp2188_e, KA_m, KA_h
  RANGE i_KA
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp2188_sigm (x, y) {
  comp2188_sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION comp2188_alpha_b (v, Q10) {
  comp2188_alpha_b  =  
  Q10 * comp2188_Aalpha_b * 
    comp2188_sigm(v + -(comp2188_V0alpha_b), comp2188_Kalpha_b)
}


FUNCTION comp2188_alpha_a (v, Q10) {
  comp2188_alpha_a  =  
  Q10 * comp2188_Aalpha_a * 
    comp2188_sigm(v + -(comp2188_V0alpha_a), comp2188_Kalpha_a)
}


FUNCTION comp2188_beta_b (v, Q10) {
  comp2188_beta_b  =  
  Q10 * comp2188_Abeta_b * 
    comp2188_sigm(v + -(comp2188_V0beta_b), comp2188_Kbeta_b)
}


FUNCTION comp2188_beta_a (v, Q10) {
  comp2188_beta_a  =  
  Q10 * 
    comp2188_Abeta_a / 
      exp((v + -(comp2188_V0beta_a)) / comp2188_Kbeta_a)
}


PARAMETER {
  comp2188_Kalpha_b  =  12.8433
  comp2188_Kalpha_a  =  -23.32708
  comp2188_e  =  -84.69
  comp2188_V0beta_b  =  -49.9537
  comp2188_V0beta_a  =  -18.27914
  comp2103_vcbdur  =  100.0
  comp2188_Kbeta_b  =  -8.90123
  comp2188_Kbeta_a  =  19.47175
  comp2103_vcbase  =  -69.0
  comp2188_K_binf  =  8.4
  ca2o  =  2.0
  comp2188_K_ainf  =  -17.0
  comp2103_vcinc  =  10.0
  comp2103_vcsteps  =  8.0
  comp2188_gbar  =  0.008
  comp2188_V0_binf  =  -78.8
  comp2188_Aalpha_b  =  0.0368
  comp2188_Aalpha_a  =  0.8147
  comp2103_vchold  =  -71.0
  comp2188_V0_ainf  =  -38.0
  comp2188_V0alpha_b  =  -111.33209
  comp2188_V0alpha_a  =  -9.17203
  comp2188_Abeta_b  =  0.0345
  comp2188_Abeta_a  =  0.1655
  comp2103_vchdur  =  30.0
}


STATE {
  KA_h
  KA_m
}


ASSIGNED {
  comp2188_b_inf
  comp2188_tau_b
  comp2188_tau_a
  comp2188_Q10
  KA_m_tau
  KA_m_inf
  comp2188_a_inf
  KA_h_tau
  KA_h_inf
  celsius
  v
  ik
  ek
  i_KA
}


PROCEDURE asgns () {
  comp2188_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp2188_V0_ainf)) / comp2188_K_ainf))
  comp2188_Q10  =  3.0 ^ ((celsius + -25.5) / 10.0)
  comp2188_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp2188_V0_binf)) / comp2188_K_binf))
  KA_h_inf  =  comp2188_b_inf
  KA_m_inf  =  comp2188_a_inf
  comp2188_tau_a  =  
  1.0 / 
    (comp2188_alpha_a(v, comp2188_Q10) + 
        comp2188_beta_a(v, comp2188_Q10))
  comp2188_tau_b  =  
  1.0 / 
    (comp2188_alpha_b(v, comp2188_Q10) + 
        comp2188_beta_b(v, comp2188_Q10))
  KA_h_tau  =  comp2188_tau_b
  KA_m_tau  =  comp2188_tau_a
  ek  =  comp2188_e
}


BREAKPOINT {
  LOCAL v5288
  SOLVE states METHOD derivimplicit
  v5288  =  KA_m 
i_KA  =  (comp2188_gbar * v5288 * v5288 * v5288 * KA_h) * (v - ek)
  ik  =  i_KA
}


DERIVATIVE states {
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
}


INITIAL {
  asgns ()
  KA_h  =  comp2188_b_inf
  KA_m  =  comp2188_a_inf
  ek  =  comp2188_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KA_h = %g\n" , t, v,  KA_h)
  printf ("NMODL state: t = %g v = %g KA_m = %g\n" , t, v,  KA_m)
}
