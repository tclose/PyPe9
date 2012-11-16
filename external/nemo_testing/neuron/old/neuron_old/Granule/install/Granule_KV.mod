

TITLE Granule_KV


NEURON {
  RANGE comp2353_vchold, comp2353_vcbase, comp2353_vcinc, comp2353_vcsteps, comp2353_vchdur, comp2353_vcbdur, comp2438_gbar, comp2438_e, KV_m
  RANGE i_KV
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp2438_alpha_n (v, Q10) {
  comp2438_alpha_n  =  
  Q10 * comp2438_Aalpha_n * 
    linoid(v + -(comp2438_V0alpha_n), comp2438_Kalpha_n)
}


FUNCTION comp2438_beta_n (v, Q10) {
  comp2438_beta_n  =  
  Q10 * comp2438_Abeta_n * 
    exp((v + -(comp2438_V0beta_n)) / comp2438_Kbeta_n)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3322
  if 
    (fabs(x / y) < 1e-06) 
     {v3322  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3322  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3322
}


PARAMETER {
  comp2438_Kalpha_n  =  -10.0
  comp2438_V0beta_n  =  -35.0
  comp2353_vcbdur  =  100.0
  comp2438_Kbeta_n  =  -80.0
  comp2353_vcbase  =  -69.0
  comp2438_e  =  -84.69
  comp2438_gbar  =  0.003
  comp2353_vcsteps  =  8.0
  comp2438_Aalpha_n  =  -0.01
  comp2353_vchold  =  -71.0
  comp2438_V0alpha_n  =  -25.0
  comp2438_Abeta_n  =  0.125
  comp2353_vchdur  =  30.0
  comp2353_vcinc  =  10.0
}


STATE {
  KV_mC
  KV_mO
  KV_m
}


ASSIGNED {
  comp2438_Q10
  celsius
  v
  ik
  ek
  i_KV
}


PROCEDURE asgns () {
  comp2438_Q10  =  3.0 ^ ((celsius + -6.3) / 10.0)
  ek  =  comp2438_e
}


PROCEDURE reactions () {
  KV_m  =  KV_mO
}


BREAKPOINT {
  LOCAL v3324
  SOLVE states METHOD derivimplicit
  reactions ()
  v3324  =  KV_m 
i_KV  =  (comp2438_gbar * v3324 * v3324 * v3324 * v3324) * (v - ek)
  ik  =  i_KV
}


DERIVATIVE states {
  LOCAL v3320
  asgns ()
  v3320  =  KV_mO 
KV_mO'  =  
    -(KV_mO * comp2438_beta_n(v, comp2438_Q10)) + 
        (1 - v3320) * (comp2438_alpha_n(v, comp2438_Q10))
}


INITIAL {
  asgns ()
  KV_m  =  
  (comp2438_alpha_n(v, comp2438_Q10)) / 
    (comp2438_alpha_n(v, comp2438_Q10) + 
        comp2438_beta_n(v, comp2438_Q10))
  KV_mO  =  KV_m
  ek  =  comp2438_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KV_mO = %g\n" , t, v,  KV_mO)
  printf ("NMODL state: t = %g v = %g KV_m = %g\n" , t, v,  KV_m)
}
