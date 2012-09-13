

TITLE CGC_KV


NEURON {
  RANGE KV_m, comp223_vcbdur, comp223_vchdur, comp223_vcsteps, comp223_vcinc, comp223_vcbase, comp223_vchold, comp63_e, comp63_gbar
  RANGE i_KV
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp63_alpha_n (v) {
  comp63_alpha_n  =  
  comp63_Q10 * comp63_Aalpha_n * 
    linoid(v + -(comp63_V0alpha_n), comp63_Kalpha_n)
}


FUNCTION comp63_beta_n (v) {
  comp63_beta_n  =  
  comp63_Q10 * comp63_Abeta_n * 
    exp((v + -(comp63_V0beta_n)) / comp63_Kbeta_n)
}


FUNCTION linoid (x, y) {
  LOCAL v354
  if 
    (fabs(x / y) < 1e-06) 
     {v354  =  y * (1.0 + -(x / y / 2.0))} 
    else {v354  =  x / (exp(x / y) + -1.0)} 
linoid  =  v354
}


PARAMETER {
  comp63_Kalpha_n  =  -10.0
  comp63_V0beta_n  =  -35.0
  comp63_e  =  -84.69
  comp223_vcbdur  =  100.0
  comp63_Kbeta_n  =  -80.0
  Vrest  =  -68.0
  comp223_vcbase  =  -69.0
  comp63_gbar  =  0.003
  fix_celsius  =  30.0
  comp63_Q10  =  13.5137964673603
  comp223_vcsteps  =  8.0
  comp63_Aalpha_n  =  -0.01
  comp223_vchold  =  -71.0
  comp223_vcinc  =  10.0
  comp63_V0alpha_n  =  -25.0
  comp63_Abeta_n  =  0.125
  comp223_vchdur  =  30.0
}


STATE {
  KV_mC
  KV_mO
  KV_m
}


ASSIGNED {
  ica
  cai
  v
  ik
  ek
  i_KV
}


PROCEDURE reactions () {
  KV_m  =  KV_mO
}


BREAKPOINT {
  LOCAL v356
  SOLVE states METHOD derivimplicit
  reactions ()
  v356  =  KV_m 
i_KV  =  (comp63_gbar * v356 * v356 * v356 * v356) * (v - ek)
  ik  =  i_KV
}


DERIVATIVE states {
  LOCAL v352
  v352  =  KV_mO 
KV_mO'  =  
    -(KV_mO * comp63_beta_n(v)) + (1 - v352) * (comp63_alpha_n(v))
}


INITIAL {
  KV_m  =  (comp63_alpha_n(v)) / (comp63_alpha_n(v) + comp63_beta_n(v))
  KV_mO  =  KV_m
  ek  =  comp63_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KV_mO = %g\n" , t, v,  KV_mO)
  printf ("NMODL state: t = %g v = %g KV_m = %g\n" , t, v,  KV_m)
}
