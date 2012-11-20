

TITLE Granule_Kir


NEURON {
  RANGE comp1671_vchold, comp1671_vcbase, comp1671_vcinc, comp1671_vcsteps, comp1671_vchdur, comp1671_vcbdur, comp1756_gbar, comp1756_e, Kir_m
  RANGE i_Kir
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp1756_alpha_d (v, Q10) {
  comp1756_alpha_d  =  
  Q10 * comp1756_Aalpha_d * 
    exp((v + -(comp1756_V0alpha_d)) / comp1756_Kalpha_d)
}


FUNCTION comp1756_beta_d (v, Q10) {
  comp1756_beta_d  =  
  Q10 * comp1756_Abeta_d * 
    exp((v + -(comp1756_V0beta_d)) / comp1756_Kbeta_d)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3310
  if 
    (fabs(x / y) < 1e-06) 
     {v3310  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3310  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3310
}


PARAMETER {
  comp1756_Kalpha_d  =  -24.3902
  comp1671_vchold  =  -71.0
  comp1756_V0beta_d  =  -83.94
  comp1756_gbar  =  0.0009
  comp1756_Kbeta_d  =  35.714
  comp1671_vchdur  =  30.0
  comp1671_vcbdur  =  100.0
  comp1671_vcbase  =  -69.0
  comp1671_vcsteps  =  8.0
  comp1756_Aalpha_d  =  0.13289
  comp1756_e  =  -84.69
  comp1671_vcinc  =  10.0
  comp1756_V0alpha_d  =  -83.94
  comp1756_Abeta_d  =  0.16994
}


STATE {
  Kir_mC
  Kir_mO
  Kir_m
}


ASSIGNED {
  comp1756_Q10
  celsius
  v
  ik
  ek
  i_Kir
}


PROCEDURE asgns () {
  comp1756_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  ek  =  comp1756_e
}


PROCEDURE reactions () {
  Kir_m  =  Kir_mO
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_Kir  =  (comp1756_gbar * Kir_m) * (v - ek)
  ik  =  i_Kir
}


DERIVATIVE states {
  LOCAL v3308
  asgns ()
  v3308  =  Kir_mO 
Kir_mO'  =  
    -(Kir_mO * comp1756_beta_d(v, comp1756_Q10)) + 
        (1 - v3308) * (comp1756_alpha_d(v, comp1756_Q10))
}


INITIAL {
  asgns ()
  Kir_m  =  
  (comp1756_alpha_d(v, comp1756_Q10)) / 
    (comp1756_alpha_d(v, comp1756_Q10) + 
        comp1756_beta_d(v, comp1756_Q10))
  Kir_mO  =  Kir_m
  ek  =  comp1756_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g Kir_mO = %g\n" , t, v,  Kir_mO)
  printf ("NMODL state: t = %g v = %g Kir_m = %g\n" , t, v,  Kir_m)
}
