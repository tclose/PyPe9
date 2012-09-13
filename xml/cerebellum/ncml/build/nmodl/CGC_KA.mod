TITLE CGC_KA


NEURON {
  RANGE KA_h, KA_m, comp393_vcbdur, comp393_vchdur, comp393_vcsteps, comp393_vcinc, comp393_vcbase, comp393_vchold, comp63_e, comp63_gbar
  RANGE i_KA
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp63_alpha_b (v) {
  comp63_alpha_b  =  
  comp63_Q10 * comp63_Aalpha_b * 
    sigm(v + -(comp63_V0alpha_b), comp63_Kalpha_b)
}


FUNCTION comp63_alpha_a (v) {
  comp63_alpha_a  =  
  comp63_Q10 * comp63_Aalpha_a * 
    sigm(v + -(comp63_V0alpha_a), comp63_Kalpha_a)
}


FUNCTION comp63_beta_b (v) {
  comp63_beta_b  =  
  comp63_Q10 * comp63_Abeta_b * 
    sigm(v + -(comp63_V0beta_b), comp63_Kbeta_b)
}


FUNCTION comp63_beta_a (v) {
  comp63_beta_a  =  
  comp63_Q10 * 
    comp63_Abeta_a / exp((v + -(comp63_V0beta_a)) / comp63_Kbeta_a)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


PARAMETER {
  comp63_Kalpha_b  =  12.8433
  comp63_Kalpha_a  =  -23.32708
  comp63_V0beta_b  =  -49.9537
  comp63_V0beta_a  =  -18.27914
  comp63_e  =  -84.69
  comp393_vcbdur  =  100.0
  comp63_Kbeta_b  =  -8.90123
  comp63_Kbeta_a  =  19.47175
  Vrest  =  -68.0
  comp393_vcbase  =  -69.0
  comp63_gbar  =  0.004
  fix_celsius  =  30.0
  comp63_K_binf  =  8.4
  comp63_Q10  =  3.0
  comp393_vcsteps  =  8.0
  comp63_V0_binf  =  -78.8
  comp63_K_ainf  =  -19.8
  comp63_Aalpha_b  =  0.11042
  comp63_Aalpha_a  =  4.88826
  comp393_vchold  =  -71.0
  comp63_V0_ainf  =  -46.7
  comp63_V0alpha_b  =  -111.33209
  comp63_V0alpha_a  =  -9.17203
  comp63_Abeta_b  =  0.10353
  comp63_Abeta_a  =  0.99285
  comp393_vchdur  =  30.0
  comp393_vcinc  =  10.0
}


STATE {
  KA_h
  KA_m
}


ASSIGNED {
  KA_m_tau
  KA_m_inf
  KA_h_tau
  comp63_b_inf
  comp63_tau_b
  comp63_tau_a
  KA_h_inf
  comp63_a_inf
  ica
  cai
  v
  ik
  ek
  i_KA
}


PROCEDURE asgns () {
  comp63_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp63_V0_ainf)) / comp63_K_ainf))
  comp63_tau_a  =  1.0 / (comp63_alpha_a(v) + comp63_beta_a(v))
  comp63_tau_b  =  1.0 / (comp63_alpha_b(v) + comp63_beta_b(v))
  comp63_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp63_V0_binf)) / comp63_K_binf))
  KA_h_inf  =  comp63_b_inf
  KA_h_tau  =  comp63_tau_b
  KA_m_inf  =  comp63_a_inf
  KA_m_tau  =  comp63_tau_a
}


BREAKPOINT {
  LOCAL v535
  SOLVE states METHOD derivimplicit
  v535  =  KA_m 
i_KA  =  (comp63_gbar * v535 * v535 * v535 * KA_h) * (v - ek)
  ik  =  i_KA
}


DERIVATIVE states {
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
}


INITIAL {
  asgns ()
  KA_h  =  (comp63_alpha_b(v)) / (comp63_alpha_b(v) + comp63_beta_b(v))
  KA_m  =  (comp63_alpha_a(v)) / (comp63_alpha_a(v) + comp63_beta_a(v))
  ek  =  comp63_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KA_h = %g\n" , t, v,  KA_h)
  printf ("NMODL state: t = %g v = %g KA_m = %g\n" , t, v,  KA_m)
}
