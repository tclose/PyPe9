

TITLE DeSouzaCGC_KCa


NEURON {
  RANGE comp1341_vchold, comp1341_vcbase, comp1341_vcinc, comp1341_vcsteps, comp1341_vchdur, comp1341_vcbdur, comp1426_gbar, comp1426_e, KCa_m
  RANGE i_KCa
  RANGE ik
  RANGE ek
  RANGE cai
  USEION ca READ cai
  USEION k READ ek WRITE ik
}


FUNCTION comp1426_alpha_c (v, cai, Q10) {
  comp1426_alpha_c  =  
  (Q10 * comp1426_Aalpha_c) / 
    (1.0 + (comp1426_Balpha_c * exp(v / comp1426_Kalpha_c)) / cai)
}


FUNCTION comp1426_beta_c (v, cai, Q10) {
  comp1426_beta_c  =  
  (Q10 * comp1426_Abeta_c) / 
    (1.0 + cai / (comp1426_Bbeta_c * exp(v / comp1426_Kbeta_c)))
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3298
  if 
    (fabs(x / y) < 1e-06) 
     {v3298  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3298  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3298
}


PARAMETER {
  comp1426_Kalpha_c  =  -11.765
  comp1341_vchold  =  -71.0
  comp1426_Kbeta_c  =  -11.765
  comp1426_Balpha_c  =  0.0015
  comp1426_gbar  =  0.04
  comp1341_vchdur  =  30.0
  comp1426_e  =  -84.69
  comp1341_vcbdur  =  100.0
  comp1341_vcbase  =  -69.0
  comp1341_vcsteps  =  8.0
  comp1341_vcinc  =  10.0
  comp1426_Aalpha_c  =  2.5
  comp1426_Bbeta_c  =  0.00015
  comp1426_Abeta_c  =  1.5
}


STATE {
  KCa_mC
  KCa_mO
  KCa_m
}


ASSIGNED {
  comp1426_cai1
  comp1426_Q10
  celsius
  comp1426_cai
  v
  cai
  ik
  ek
  i_KCa
}


PROCEDURE asgns () {
  LOCAL v3293
  comp1426_Q10  =  3.0 ^ ((celsius + -30.0) / 10.0)
  if 
    (comp1426_cai < 0.0001) 
     {v3293  =  0.0001} 
    else {v3293  =  comp1426_cai} 
comp1426_cai1  =  v3293
  ek  =  comp1426_e
}


PROCEDURE reactions () {
  KCa_m  =  KCa_mO
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_KCa  =  (comp1426_gbar * KCa_m) * (v - ek)
  ik  =  i_KCa
}


DERIVATIVE states {
  LOCAL v3296
  comp1426_cai  =  cai
  asgns ()
  v3296  =  KCa_mO 
KCa_mO'  =  
    -(KCa_mO * comp1426_beta_c(v, comp1426_cai1, comp1426_Q10)) + 
        (1 - v3296) * (comp1426_alpha_c(v, comp1426_cai1, comp1426_Q10))
}


INITIAL {
  comp1426_cai  =  cai
  asgns ()
  KCa_m  =  
  (comp1426_alpha_c(v, comp1426_cai1, comp1426_Q10)) / 
    (comp1426_alpha_c(v, comp1426_cai1, comp1426_Q10) + 
        comp1426_beta_c(v, comp1426_cai1, comp1426_Q10))
  KCa_mO  =  KCa_m
  ek  =  comp1426_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KCa_mO = %g\n" , t, v,  KCa_mO)
  printf ("NMODL state: t = %g v = %g KCa_m = %g\n" , t, v,  KCa_m)
}
