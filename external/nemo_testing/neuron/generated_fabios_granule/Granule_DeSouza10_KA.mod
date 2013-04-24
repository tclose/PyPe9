

TITLE Granule_DeSouza10_KA


NEURON {
  RANGE comp262_celsius, comp262_V_t, comp263_C_m, comp264_vchold, comp264_vcbase, comp264_vcinc, comp264_vcsteps, comp264_vchdur, comp264_vcbdur, comp265_gbar
  RANGE comp265_e, KA_m, KA_h
  RANGE i_KA
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp265_alpha_b (v, Q10) {
  comp265_alpha_b  =  
  Q10 * comp265_Aalpha_b * 
    comp265_sigm(v + -(comp265_V0alpha_b), comp265_Kalpha_b)
}


FUNCTION comp265_alpha_a (v, Q10) {
  comp265_alpha_a  =  
  Q10 * comp265_Aalpha_a * 
    comp265_sigm(v + -(comp265_V0alpha_a), comp265_Kalpha_a)
}


FUNCTION comp265_sigm (x, y) {
  comp265_sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION comp265_beta_b (v, Q10) {
  comp265_beta_b  =  
  Q10 * comp265_Abeta_b * 
    comp265_sigm(v + -(comp265_V0beta_b), comp265_Kbeta_b)
}


FUNCTION comp265_beta_a (v, Q10) {
  comp265_beta_a  =  
  Q10 * 
    comp265_Abeta_a / exp((v + -(comp265_V0beta_a)) / comp265_Kbeta_a)
}


PARAMETER {
  comp265_V0_binf  =  -78.8
  comp265_K_binf  =  8.4
  comp265_V0alpha_b  =  -111.33209
  comp265_V0alpha_a  =  -9.17203
  comp263_C_m  =  1.0
  comp264_vcinc  =  10.0
  comp264_vcbase  =  -69.0
  comp265_V0beta_b  =  -49.9537
  comp265_V0beta_a  =  -18.27914
  comp265_V0_ainf  =  -38.0
  comp264_vcsteps  =  8.0
  comp265_K_ainf  =  -17.0
  comp265_Aalpha_b  =  0.0368
  comp265_Aalpha_a  =  0.8147
  comp265_e  =  -84.69
  comp264_vchdur  =  30.0
  comp264_vcbdur  =  100.0
  comp262_celsius  =  30.0
  comp265_gbar  =  0.0032
  comp265_Kbeta_b  =  -8.90123
  comp265_Kbeta_a  =  19.47175
  comp265_Kalpha_b  =  12.8433
  comp265_Kalpha_a  =  -23.32708
  comp265_Abeta_b  =  0.0345
  comp265_Abeta_a  =  0.1655
  comp262_V_t  =  -35.0
  comp264_vchold  =  -71.0
}


STATE {
  KA_h
  KA_m
}


ASSIGNED {
  comp265_b_inf
  comp265_Q10
  KA_h_inf
  KA_m_tau
  comp265_a_inf
  KA_h_tau
  comp265_tau_b
  comp265_tau_a
  KA_m_inf
  celsius
  v
  ik
  ek
  i_KA
}


PROCEDURE asgns () {
  comp265_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp265_V0_ainf)) / comp265_K_ainf))
  comp265_Q10  =  3.0 ^ ((comp262_celsius + -25.5) / 10.0)
  comp265_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp265_V0_binf)) / comp265_K_binf))
  KA_m_inf  =  comp265_a_inf
  comp265_tau_a  =  
  1.0 / 
    (comp265_alpha_a(v, comp265_Q10) + comp265_beta_a(v, comp265_Q10))
  comp265_tau_b  =  
  1.0 / 
    (comp265_alpha_b(v, comp265_Q10) + comp265_beta_b(v, comp265_Q10))
  KA_h_inf  =  comp265_b_inf
  KA_h_tau  =  comp265_tau_b
  KA_m_tau  =  comp265_tau_a
  ek  =  comp265_e
}


BREAKPOINT {
  LOCAL x506
  SOLVE states METHOD derivimplicit
  x506  =  KA_m 
i_KA  =  (comp265_gbar * x506 * x506 * x506 * KA_h) * (v - comp265_e)
  ik  =  i_KA
}


DERIVATIVE states {
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
}


INITIAL {
  asgns ()
  KA_m  =  1.0 / (1.0 + exp((v + -(comp265_V0_ainf)) / comp265_K_ainf))
  KA_h  =  1.0 / (1.0 + exp((v + -(comp265_V0_binf)) / comp265_K_binf))
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KA_h = %g\n" , t, v,  KA_h)
  printf ("NMODL state: t = %g v = %g KA_m = %g\n" , t, v,  KA_m)
}
