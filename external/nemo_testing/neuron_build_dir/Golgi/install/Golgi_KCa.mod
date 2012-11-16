

TITLE Golgi_KCa


NEURON {
  RANGE comp2629_vchold, comp2629_vcbase, comp2629_vcinc, comp2629_vcsteps, comp2629_vchdur, comp2629_vcbdur, comp2714_gbar, comp2714_e, KCa_m
  RANGE i_KCa
  RANGE ik
  RANGE ek
  RANGE cai
  USEION ca READ cai
  USEION k READ ek WRITE ik
}


FUNCTION comp2714_alpha_c (v, cai, Q10) {
  comp2714_alpha_c  =  
  (Q10 * comp2714_Aalpha_c) / 
    (1.0 + (comp2714_Balpha_c * exp(v / comp2714_Kalpha_c)) / cai)
}


FUNCTION comp2714_beta_c (v, cai, Q10) {
  comp2714_beta_c  =  
  (Q10 * comp2714_Abeta_c) / 
    (1.0 + cai / (comp2714_Bbeta_c * exp(v / comp2714_Kbeta_c)))
}


PARAMETER {
  comp2714_Kalpha_c  =  -11.765
  comp2714_gbar  =  0.003
  comp2629_vchold  =  -71.0
  comp2714_Kbeta_c  =  -11.765
  comp2714_Balpha_c  =  0.0015
  comp2629_vchdur  =  30.0
  ca2o  =  2.0
  comp2629_vcinc  =  10.0
  comp2629_vcbdur  =  100.0
  comp2629_vcbase  =  -69.0
  comp2629_vcsteps  =  8.0
  comp2714_Aalpha_c  =  7.0
  comp2714_e  =  -84.69
  comp2714_Bbeta_c  =  0.00015
  comp2714_Abeta_c  =  1.0
}


STATE {
  KCa_mC
  KCa_mO
  KCa_m
}


ASSIGNED {
  comp2714_Q10
  celsius
  comp2714_cai
  v
  cai
  ik
  ek
  i_KCa
}


PROCEDURE asgns () {
  comp2714_Q10  =  3.0 ^ ((celsius + -30.0) / 10.0)
  ek  =  comp2714_e
}


PROCEDURE reactions () {
  KCa_m  =  KCa_mO
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_KCa  =  (comp2714_gbar * KCa_m) * (v - ek)
  ik  =  i_KCa
}


DERIVATIVE states {
  LOCAL v5291
  comp2714_cai  =  cai
  asgns ()
  v5291  =  KCa_mO 
KCa_mO'  =  
    -(KCa_mO * comp2714_beta_c(v, comp2714_cai, comp2714_Q10)) + 
        (1 - v5291) * (comp2714_alpha_c(v, comp2714_cai, comp2714_Q10))
}


INITIAL {
  comp2714_cai  =  cai
  asgns ()
  KCa_m  =  
  (comp2714_alpha_c(v, comp2714_cai, comp2714_Q10)) / 
    (comp2714_alpha_c(v, comp2714_cai, comp2714_Q10) + 
        comp2714_beta_c(v, comp2714_cai, comp2714_Q10))
  KCa_mO  =  KCa_m
  ek  =  comp2714_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KCa_mO = %g\n" , t, v,  KCa_mO)
  printf ("NMODL state: t = %g v = %g KCa_m = %g\n" , t, v,  KCa_m)
}
