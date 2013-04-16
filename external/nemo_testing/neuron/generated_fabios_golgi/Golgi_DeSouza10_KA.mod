

TITLE Golgi_DeSouza10_KA


NEURON {
  RANGE comp385_celsius, comp385_V_t, comp386_c, comp387_vchold, comp387_vcbase, comp387_vcinc, comp387_vcsteps, comp387_vchdur, comp387_vcbdur, comp388_gbar
  RANGE comp388_e, KA_m, KA_h
  RANGE i_KA
  RANGE ik
  RANGE ek
  RANGE F, R
  USEION k READ ki, ko WRITE ik
}


FUNCTION comp388_alpha_b (v, Q10) {
  comp388_alpha_b  =  
  Q10 * comp388_Aalpha_b * 
    comp388_sigm(v + -(comp388_V0alpha_b), comp388_Kalpha_b)
}


FUNCTION comp388_alpha_a (v, Q10) {
  comp388_alpha_a  =  
  Q10 * comp388_Aalpha_a * 
    comp388_sigm(v + -(comp388_V0alpha_a), comp388_Kalpha_a)
}


FUNCTION comp388_sigm (x, y) {
  comp388_sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION comp388_beta_b (v, Q10) {
  comp388_beta_b  =  
  Q10 * comp388_Abeta_b * 
    comp388_sigm(v + -(comp388_V0beta_b), comp388_Kbeta_b)
}


FUNCTION comp388_beta_a (v, Q10) {
  comp388_beta_a  =  
  Q10 * 
    comp388_Abeta_a / exp((v + -(comp388_V0beta_a)) / comp388_Kbeta_a)
}


PARAMETER {
  comp388_V0_binf  =  -78.8
  comp388_V0alpha_b  =  -111.33209
  comp387_vchold  =  -71.0
  comp388_V0alpha_a  =  -9.17203
  comp388_V0beta_b  =  -49.9537
  comp388_V0beta_a  =  -18.27914
  comp388_K_binf  =  8.4
  comp387_vcinc  =  10.0
  comp388_V0_ainf  =  -38.0
  comp387_vcsteps  =  8.0
  comp385_V_t  =  -35.0
  comp387_vcbase  =  -69.0
  comp388_Aalpha_b  =  0.0368
  comp388_Aalpha_a  =  0.8147
  comp386_c  =  1.0
  comp388_gbar  =  0.008
  comp385_celsius  =  23.0
  comp388_K_ainf  =  -17.0
  comp388_Kbeta_b  =  -8.90123
  comp388_Kbeta_a  =  19.47175
  comp388_Kalpha_b  =  12.8433
  comp388_Kalpha_a  =  -23.32708
  R  =  8.31342
  F  =  96485.3
  comp387_vchdur  =  30.0
  comp388_Abeta_b  =  0.0345
  comp388_Abeta_a  =  0.1655
  comp387_vcbdur  =  100.0
}


STATE {
  KA_h
  KA_m
}


ASSIGNED {
  comp388_b_inf
  KA_h_inf
  KA_m_tau
  ek
  comp388_a_inf
  KA_h_tau
  ena
  comp388_Q10
  comp388_tau_b
  comp388_tau_a
  comp388_e
  KA_m_inf
  ko
  ki
  celsius
  v
  nao
  nai
  ik
  i_KA
}


PROCEDURE asgns () {
  comp388_Q10  =  3.0 ^ ((comp385_celsius + -25.5) / 10.0)
  ena  =  (1000.0 * R * (comp385_celsius + 273.15)) / F * log(nao / nai)
  comp388_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp388_V0_ainf)) / comp388_K_ainf))
  ek  =  (1000.0 * R * (comp385_celsius + 273.15)) / F * log(ko / ki)
  comp388_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp388_V0_binf)) / comp388_K_binf))
  KA_m_inf  =  comp388_a_inf
  comp388_e  =  ek
  comp388_tau_a  =  
  1.0 / 
    (comp388_alpha_a(v, comp388_Q10) + comp388_beta_a(v, comp388_Q10))
  comp388_tau_b  =  
  1.0 / 
    (comp388_alpha_b(v, comp388_Q10) + comp388_beta_b(v, comp388_Q10))
  KA_h_inf  =  comp388_b_inf
  KA_h_tau  =  comp388_tau_b
  KA_m_tau  =  comp388_tau_a
  ek  =  comp388_e
}


BREAKPOINT {
  LOCAL x701
  SOLVE states METHOD derivimplicit
  x701  =  KA_m 
i_KA  =  (comp388_gbar * x701 * x701 * x701 * KA_h) * (v - comp388_e)
  ik  =  i_KA
}


DERIVATIVE states {
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
}


INITIAL {
  asgns ()
  KA_m  =  comp388_a_inf
  KA_h  =  comp388_b_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KA_h = %g\n" , t, v,  KA_h)
  printf ("NMODL state: t = %g v = %g KA_m = %g\n" , t, v,  KA_m)
}
