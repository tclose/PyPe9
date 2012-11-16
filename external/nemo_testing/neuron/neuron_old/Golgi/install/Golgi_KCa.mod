

TITLE Golgi_KCa


NEURON {
  RANGE KCa_m, comp170_vcbdur, comp170_vchdur, comp170_vcsteps, comp170_vcinc, comp170_vcbase, comp170_vchold, comp19_e, comp19_gbar
  RANGE i_KCa
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
  RANGE cai
  USEION ca READ cai
}


FUNCTION comp19_beta_c (v, cai, Q10) {
  comp19_beta_c  =  
  (Q10 * comp19_Abeta_c) / 
    (1.0 + cai / (comp19_Bbeta_c * exp(v / comp19_Kbeta_c)))
}


FUNCTION comp19_alpha_c (v, cai, Q10) {
  comp19_alpha_c  =  
  (Q10 * comp19_Aalpha_c) / 
    (1.0 + (comp19_Balpha_c * exp(v / comp19_Kalpha_c)) / cai)
}


PARAMETER {
  comp170_vcbase  =  -69.0
  comp19_Kalpha_c  =  -11.765
  comp170_vchold  =  -71.0
  comp19_Bbeta_c  =  0.00015
  comp19_gbar  =  0.003
  comp170_vcbdur  =  100.0
  comp19_Aalpha_c  =  7.0
  comp19_Balpha_c  =  0.0015
  comp170_vcinc  =  10.0
  comp19_Abeta_c  =  1.0
  comp19_Kbeta_c  =  -11.765
  comp170_vchdur  =  30.0
  comp19_e  =  -84.69
  comp170_vcsteps  =  8.0
}


STATE {
  KCa_mC
  KCa_mO
  KCa_m
}


ASSIGNED {
  comp19_Q10
  celsius
  v
  cai
  ica
  ik
  ek
  i_KCa
}


PROCEDURE asgns () {
  comp19_Q10  =  3.0 ^ ((celsius + -30.0) / 10.0)
}


PROCEDURE reactions () {
  KCa_m  =  KCa_mO
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_KCa  =  (comp19_gbar * KCa_m) * (v - ek)
  ik  =  i_KCa
}


DERIVATIVE states {
  LOCAL v299
  asgns ()
  v299  =  KCa_mO 
KCa_mO'  =  
    -(KCa_mO * comp19_beta_c(v, cai, comp19_Q10)) + 
        (1 - v299) * (comp19_alpha_c(v, cai, comp19_Q10))
}


INITIAL {
  asgns ()
  KCa_m  =  
  (comp19_alpha_c(v, cai, comp19_Q10)) / 
    (comp19_alpha_c(v, cai, comp19_Q10) + 
        comp19_beta_c(v, cai, comp19_Q10))
  KCa_mO  =  KCa_m
  ek  =  comp19_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KCa_mO = %g\n" , t, v,  KCa_mO)
  printf ("NMODL state: t = %g v = %g KCa_m = %g\n" , t, v,  KCa_m)
}
