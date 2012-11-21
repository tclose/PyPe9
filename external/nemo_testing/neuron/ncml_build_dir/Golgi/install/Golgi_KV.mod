

TITLE Golgi_KV


NEURON {
  RANGE comp3278_vchold, comp3278_vcbase, comp3278_vcinc, comp3278_vcsteps, comp3278_vchdur, comp3278_vcbdur, comp3363_gbar, comp3363_e, KV_m
  RANGE i_KV
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp3363_alpha_n (v, Q10) {
  comp3363_alpha_n  =  
  Q10 * comp3363_Aalpha_n * 
    comp3363_linoid(v + -(comp3363_V0alpha_n), comp3363_Kalpha_n)
}


FUNCTION comp3363_beta_n (v, Q10) {
  comp3363_beta_n  =  
  Q10 * comp3363_Abeta_n * 
    exp((v + -(comp3363_V0beta_n)) / comp3363_Kbeta_n)
}


FUNCTION comp3363_linoid (x, y) {
  LOCAL v5301
  if 
    (fabs(x / y) < 1e-06) 
     {v5301  =  y * (1.0 + -(x / y / 2.0))} 
    else {v5301  =  x / (exp(x / y) + -1.0)} 
comp3363_linoid  =  v5301
}


PARAMETER {
  comp3363_Kalpha_n  =  -10.0
  comp3363_V0beta_n  =  -36.0
  comp3363_e  =  -84.69
  comp3363_Kbeta_n  =  -80.0
  comp3278_vchold  =  -71.0
  ca2o  =  2.0
  comp3278_vcinc  =  10.0
  comp3278_vchdur  =  30.0
  comp3363_gbar  =  0.032
  comp3278_vcsteps  =  8.0
  comp3278_vcbdur  =  100.0
  comp3278_vcbase  =  -69.0
  comp3363_Aalpha_n  =  -0.01
  comp3363_V0alpha_n  =  -26.0
  comp3363_Abeta_n  =  0.125
}


STATE {
  KV_mC
  KV_mO
  KV_m
}


ASSIGNED {
  comp3363_Q10
  celsius
  v
  ik
  ek
  i_KV
}


PROCEDURE asgns () {
  comp3363_Q10  =  3.0 ^ ((celsius + -6.3) / 10.0)
  ek  =  comp3363_e
}


PROCEDURE reactions () {
  KV_m  =  KV_mO
}


BREAKPOINT {
  LOCAL v5303
  SOLVE states METHOD derivimplicit
  reactions ()
  v5303  =  KV_m 
i_KV  =  (comp3363_gbar * v5303 * v5303 * v5303 * v5303) * (v - ek)
  ik  =  i_KV
}


DERIVATIVE states {
  LOCAL v5299
  asgns ()
  v5299  =  KV_mO 
KV_mO'  =  
    -(KV_mO * comp3363_beta_n(v, comp3363_Q10)) + 
        (1 - v5299) * (comp3363_alpha_n(v, comp3363_Q10))
}


INITIAL {
  asgns ()
  KV_m  =  
  (comp3363_alpha_n(v, comp3363_Q10)) / 
    (comp3363_alpha_n(v, comp3363_Q10) + 
        comp3363_beta_n(v, comp3363_Q10))
  KV_mO  =  KV_m
  ek  =  comp3363_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KV_mO = %g\n" , t, v,  KV_mO)
  printf ("NMODL state: t = %g v = %g KV_m = %g\n" , t, v,  KV_m)
}
