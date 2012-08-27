

TITLE Golgi_KV


NEURON {
  RANGE KV_m, comp183_vcbdur, comp183_vchdur, comp183_vcsteps, comp183_vcinc, comp183_vcbase, comp183_vchold, comp35_e, comp35_gbar
  RANGE i_KV
  RANGE ik
  USEION k READ ek WRITE ik
}


FUNCTION comp35_beta_n (v, Q10) {
  comp35_beta_n  =  
  Q10 * comp35_Abeta_n * exp((v + -(comp35_V0beta_n)) / comp35_Kbeta_n)
}


FUNCTION comp35_alpha_n (v, Q10) {
  comp35_alpha_n  =  
  Q10 * comp35_Aalpha_n * 
    linoid(v + -(comp35_V0alpha_n), comp35_Kalpha_n)
}


FUNCTION linoid (x, y) {
  LOCAL v314
  if 
    (fabs(x / y) < 1e-06) 
     {v314  =  y * (1.0 + -(x / y / 2.0))} 
    else {v314  =  x / (exp(x / y) + -1.0)} 
linoid  =  v314
}


PARAMETER {
  comp183_vcsteps  =  8.0
  comp183_vchdur  =  30.0
  comp35_V0beta_n  =  -36.0
  comp35_V0alpha_n  =  -26.0
  comp183_vcinc  =  10.0
  comp183_vcbdur  =  100.0
  comp35_Abeta_n  =  0.125
  comp183_vcbase  =  -69.0
  comp35_Kalpha_n  =  -10.0
  comp35_Kbeta_n  =  -80.0
  comp35_e  =  -84.69
  comp35_Aalpha_n  =  -0.01
  comp183_vchold  =  -71.0
  comp35_gbar  =  0.032
}


STATE {
  KV_mC
  KV_mO
  KV_m
}


ASSIGNED {
  comp35_Q10
  v
  celsius
  ik
  ek
  i_KV
}


PROCEDURE asgns () {
  comp35_Q10  =  3.0 ^ ((celsius + -6.3) / 10.0)
}


PROCEDURE reactions () {
  KV_m  =  KV_mO
}


BREAKPOINT {
  LOCAL v316
  SOLVE states METHOD derivimplicit
  reactions ()
  v316  =  KV_m 
i_KV  =  (comp35_gbar * v316 * v316 * v316 * v316) * (v - comp35_e)
  ik  =  i_KV
  print_state()
}


DERIVATIVE states {
  LOCAL v312
  asgns ()
  v312  =  KV_mO 
KV_mO'  =  
    -(KV_mO * comp35_beta_n(v, comp35_Q10)) + 
        (1 - v312) * (comp35_alpha_n(v, comp35_Q10))
}


INITIAL {
  asgns ()
  KV_m  =  
  (comp35_alpha_n(v, comp35_Q10)) / 
    (comp35_alpha_n(v, comp35_Q10) + comp35_beta_n(v, comp35_Q10))
  KV_mO  =  KV_m
  print_state()
}


PROCEDURE print_state () {
  printf ("state: %g KV_mO %g\n", t,  KV_mO)
  printf ("state: %g KV_m %g\n", t,  KV_m)
}
