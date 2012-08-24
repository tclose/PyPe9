

TITLE CGC_KCa


NEURON {
  RANGE KCa_m, comp47_e, comp47_gbar
  RANGE i_KCa
  RANGE ik
  USEION k READ ek WRITE ik
}


FUNCTION comp47_beta_c (v, cai) {
  comp47_beta_c  =  
  (comp47_Q10 * comp47_Abeta_c) / 
    (1.0 + cai / (comp47_Bbeta_c * exp(v / comp47_Kbeta_c)))
}


FUNCTION comp47_alpha_c (v, cai) {
  comp47_alpha_c  =  
  (comp47_Q10 * comp47_Aalpha_c) / 
    (1.0 + (comp47_Balpha_c * exp(v / comp47_Kalpha_c)) / cai)
}


PARAMETER {
  comp47_Balpha_c  =  0.0015
  comp47_Abeta_c  =  1.5
  fix_celsius  =  30.0
  comp47_Bbeta_c  =  0.00015
  comp47_e  =  -84.69
  comp47_Aalpha_c  =  2.5
  comp47_Kbeta_c  =  -11.765
  comp47_Kalpha_c  =  -11.765
  Vrest  =  -68.0
  comp47_gbar  =  0.004
  comp47_Q10  =  1.0
}


STATE {
  KCa_m
}


ASSIGNED {
  KCa_m_inf
  KCa_m_tau
  v
  cai
  ica
  ik
  ek
  i_KCa
}


PROCEDURE asgns () {
  KCa_m_tau  =  comp47_beta_c(v, cai)
  KCa_m_inf  =  comp47_alpha_c(v, cai)
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KCa  =  (comp47_gbar * KCa_m) * (v - comp47_e)
  ik  =  i_KCa
}


DERIVATIVE states {
  asgns ()
  KCa_m'  =  (KCa_m_inf + -(KCa_m)) / KCa_m_tau
}


INITIAL {
  asgns ()
  KCa_m  =  
  (comp47_alpha_c(v, cai)) / 
    (comp47_alpha_c(v, cai) + comp47_beta_c(v, cai))
}


PROCEDURE print_state () {
  printf ("KCa_m = %g\n" ,  KCa_m)
}
