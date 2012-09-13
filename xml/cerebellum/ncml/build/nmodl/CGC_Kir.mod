TITLE CGC_Kir


NEURON {
  RANGE Kir_m, comp207_vcbdur, comp207_vchdur, comp207_vcsteps, comp207_vcinc, comp207_vcbase, comp207_vchold, comp47_e, comp47_gbar
  RANGE i_Kir
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp47_alpha_d (v) {
  comp47_alpha_d  =  
  comp47_Q10 * comp47_Aalpha_d * 
    exp((v + -(comp47_V0alpha_d)) / comp47_Kalpha_d)
}


FUNCTION comp47_beta_d (v) {
  comp47_beta_d  =  
  comp47_Q10 * comp47_Abeta_d * 
    exp((v + -(comp47_V0beta_d)) / comp47_Kbeta_d)
}


PARAMETER {
  comp47_Kalpha_d  =  -24.3902
  comp47_V0beta_d  =  -83.94
  comp207_vcbdur  =  100.0
  comp47_Kbeta_d  =  35.714
  Vrest  =  -68.0
  comp207_vcbase  =  -69.0
  comp207_vcinc  =  10.0
  comp47_gbar  =  0.0009
  fix_celsius  =  30.0
  comp47_e  =  -84.69
  comp207_vcsteps  =  8.0
  comp47_Aalpha_d  =  0.13289
  comp207_vchold  =  -71.0
  comp47_V0alpha_d  =  -83.94
  comp47_Abeta_d  =  0.16994
  comp47_Q10  =  3.0
  comp207_vchdur  =  30.0
}


STATE {
  Kir_mC
  Kir_mO
  Kir_m
}


ASSIGNED {
  ica
  cai
  v
  ik
  ek
  i_Kir
}


PROCEDURE reactions () {
  Kir_m  =  Kir_mO
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_Kir  =  (comp47_gbar * Kir_m) * (v - ek)
  ik  =  i_Kir
}


DERIVATIVE states {
  LOCAL v336
  v336  =  Kir_mO 
Kir_mO'  =  
    -(Kir_mO * comp47_beta_d(v)) + (1 - v336) * (comp47_alpha_d(v))
}


INITIAL {
  Kir_m  =  (comp47_alpha_d(v)) / (comp47_alpha_d(v) + comp47_beta_d(v))
  Kir_mO  =  Kir_m
  ek  =  comp47_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g Kir_mO = %g\n" , t, v,  Kir_mO)
  printf ("NMODL state: t = %g v = %g Kir_m = %g\n" , t, v,  Kir_m)
}
