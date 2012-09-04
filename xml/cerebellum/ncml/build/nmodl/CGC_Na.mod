

TITLE CGC_Na


NEURON {
  RANGE Na_h, Na_m, comp337_vcbdur, comp337_vchdur, comp337_vcsteps, comp337_vcinc, comp337_vcbase, comp337_vchold, comp63_e, comp63_gbar
  RANGE i_Na
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION comp63_alpha_m (v) {
  comp63_alpha_m  =  
  comp63_Q10 * comp63_Aalpha_m * 
    linoid(v + -(comp63_V0alpha_m), comp63_Kalpha_m)
}


FUNCTION comp63_alpha_h (v) {
  comp63_alpha_h  =  
  comp63_Q10 * comp63_Aalpha_h * 
    exp((v + -(comp63_V0alpha_h)) / comp63_Kalpha_h)
}


FUNCTION comp63_beta_m (v) {
  comp63_beta_m  =  
  comp63_Q10 * comp63_Abeta_m * 
    exp((v + -(comp63_V0beta_m)) / comp63_Kbeta_m)
}


FUNCTION comp63_beta_h (v) {
  comp63_beta_h  =  
  (comp63_Q10 * comp63_Abeta_h) / 
    (1.0 + exp((v + -(comp63_V0beta_h)) / comp63_Kbeta_h))
}


FUNCTION linoid (x, y) {
  LOCAL v485
  if 
    (fabs(x / y) < 1e-06) 
     {v485  =  y * (1.0 + -(x / y / 2.0))} 
    else {v485  =  x / (exp(x / y) + -1.0)} 
linoid  =  v485
}


PARAMETER {
  comp63_Kalpha_m  =  -10.0
  comp63_Kalpha_h  =  -3.333
  comp63_V0beta_m  =  -44.0
  comp63_V0beta_h  =  -11.0
  comp63_e  =  87.39
  comp337_vcbdur  =  100.0
  comp63_Kbeta_m  =  -18.182
  comp63_Kbeta_h  =  -5.0
  Vrest  =  -68.0
  comp337_vcbase  =  -60.0
  comp63_gbar  =  0.013
  comp337_vcinc  =  10.0
  fix_celsius  =  30.0
  comp63_Q10  =  3.0
  comp337_vcsteps  =  9.0
  comp63_Aalpha_m  =  -0.3
  comp63_Aalpha_h  =  0.105
  comp337_vchold  =  -71.0
  comp63_V0alpha_m  =  -19.0
  comp63_V0alpha_h  =  -44.0
  comp63_Abeta_m  =  12.0
  comp63_Abeta_h  =  1.5
  comp337_vchdur  =  30.0
}


STATE {
  Na_hC
  Na_hO
  Na_mC
  Na_mO
  Na_h
  Na_m
}


ASSIGNED {
  ica
  cai
  v
  ina
  ena
  i_Na
}


PROCEDURE reactions () {
  Na_h  =  Na_hO
  Na_m  =  Na_mO
}


BREAKPOINT {
  LOCAL v487
  SOLVE states METHOD derivimplicit
  reactions ()
  v487  =  Na_m 
i_Na  =  (comp63_gbar * v487 * v487 * v487 * Na_h) * (v - ena)
  ina  =  i_Na
}


DERIVATIVE states {
  LOCAL v480, v483
  v480  =  Na_mO 
Na_mO'  =  
    -(Na_mO * comp63_beta_m(v)) + (1 - v480) * (comp63_alpha_m(v))
  v483  =  Na_hO 
Na_hO'  =  
    -(Na_hO * comp63_beta_h(v)) + (1 - v483) * (comp63_alpha_h(v))
}


INITIAL {
  Na_h  =  (comp63_alpha_h(v)) / (comp63_alpha_h(v) + comp63_beta_h(v))
  Na_hO  =  Na_h
  Na_m  =  (comp63_alpha_m(v)) / (comp63_alpha_m(v) + comp63_beta_m(v))
  Na_mO  =  Na_m
  ena  =  comp63_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g Na_hO = %g\n" , t, v,  Na_hO)
  printf ("NMODL state: t = %g v = %g Na_mO = %g\n" , t, v,  Na_mO)
  printf ("NMODL state: t = %g v = %g Na_h = %g\n" , t, v,  Na_h)
  printf ("NMODL state: t = %g v = %g Na_m = %g\n" , t, v,  Na_m)
}
