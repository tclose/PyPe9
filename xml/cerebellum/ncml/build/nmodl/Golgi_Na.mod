

TITLE Golgi_Na


NEURON {
  RANGE Na_h, Na_m, comp299_vcbdur, comp299_vchdur, comp299_vcsteps, comp299_vcinc, comp299_vcbase, comp299_vchold, comp35_e, comp35_gbar
  RANGE i_Na
  RANGE ina
  USEION na READ ena WRITE ina
}


FUNCTION comp35_alpha_m (v, Q10) {
  comp35_alpha_m  =  
  Q10 * comp35_Aalpha_m * 
    linoid(v + -(comp35_V0alpha_m), comp35_Kalpha_m)
}


FUNCTION comp35_alpha_h (v, Q10) {
  comp35_alpha_h  =  
  Q10 * comp35_Aalpha_h * 
    exp((v + -(comp35_V0alpha_h)) / comp35_Kalpha_h)
}


FUNCTION comp35_beta_h (v, Q10) {
  comp35_beta_h  =  
  (Q10 * comp35_Abeta_h) / 
    (1.0 + exp((v + -(comp35_V0beta_h)) / comp35_Kbeta_h))
}


FUNCTION linoid (x, y) {
  LOCAL v447
  if 
    (fabs(x / y) < 1e-06) 
     {v447  =  y * (1.0 + -(x / y / 2.0))} 
    else {v447  =  x / (1.0 + -(exp(x / y)))} 
linoid  =  v447
}


FUNCTION comp35_beta_m (v, Q10) {
  comp35_beta_m  =  
  Q10 * comp35_Abeta_m * exp((v + -(comp35_V0beta_m)) / comp35_Kbeta_m)
}


PARAMETER {
  comp299_vchold  =  -71.0
  comp299_vcbase  =  -60.0
  comp35_V0beta_m  =  -50.0
  comp35_V0beta_h  =  -17.0
  comp299_vchdur  =  30.0
  comp35_V0alpha_h  =  -50.0
  comp35_e  =  87.39
  comp35_V0alpha_m  =  -25.0
  comp35_Aalpha_h  =  0.21
  comp35_Aalpha_m  =  0.3
  comp35_Kalpha_m  =  -10.0
  comp35_Kalpha_h  =  -3.333
  comp299_vcinc  =  10.0
  comp35_Abeta_h  =  3.0
  comp35_Abeta_m  =  12.0
  comp35_gbar  =  0.048
  comp299_vcbdur  =  100.0
  comp299_vcsteps  =  9.0
  comp35_Kbeta_h  =  -5.0
  comp35_Kbeta_m  =  -18.182
}


STATE {
  Na_mC
  Na_mO
  Na_hC
  Na_hO
  Na_m
  Na_h
}


ASSIGNED {
  comp35_Q10
  celsius
  v
  ina
  ena
  i_Na
}


PROCEDURE asgns () {
  comp35_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
}


PROCEDURE reactions () {
  Na_m  =  Na_mO
  Na_h  =  Na_hO
}


BREAKPOINT {
  LOCAL v449
  SOLVE states METHOD derivimplicit
  reactions ()
  v449  =  Na_m 
i_Na  =  (comp35_gbar * v449 * v449 * v449 * Na_h) * (v - comp35_e)
  ina  =  i_Na
}


DERIVATIVE states {
  LOCAL v442, v445
  asgns ()
  v442  =  Na_hO 
Na_hO'  =  
    -(Na_hO * comp35_beta_h(v, comp35_Q10)) + 
        (1 - v442) * (comp35_alpha_h(v, comp35_Q10))
  v445  =  Na_mO 
Na_mO'  =  
    -(Na_mO * comp35_beta_m(v, comp35_Q10)) + 
        (1 - v445) * (comp35_alpha_m(v, comp35_Q10))
}


INITIAL {
  asgns ()
  Na_m  =  
  (comp35_alpha_m(v, comp35_Q10)) / 
    (comp35_alpha_m(v, comp35_Q10) + comp35_beta_m(v, comp35_Q10))
  Na_mO  =  Na_m
  Na_h  =  
  (comp35_alpha_h(v, comp35_Q10)) / 
    (comp35_alpha_h(v, comp35_Q10) + comp35_beta_h(v, comp35_Q10))
  Na_hO  =  Na_h
  print_state()
 
}


PROCEDURE print_state () {
  printf ("Na_hO = %g\n" ,  Na_hO)
  printf ("Na_mO = %g\n" ,  Na_mO)
}
