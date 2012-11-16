

TITLE Golgi_Na


NEURON {
  RANGE comp3920_vchold, comp3920_vcbase, comp3920_vcinc, comp3920_vcsteps, comp3920_vchdur, comp3920_vcbdur, comp4005_gbar, comp4005_e, Na_m, Na_h
  RANGE i_Na
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION comp4005_alpha_v (v, Q10) {
  comp4005_alpha_v  =  
  Q10 * comp4005_Aalpha_v * 
    exp((v + -(comp4005_V0alpha_v)) / comp4005_Kalpha_v)
}


FUNCTION comp4005_alpha_u (v, Q10) {
  comp4005_alpha_u  =  
  Q10 * comp4005_Aalpha_u * 
    comp4005_linoid(v + -(comp4005_V0alpha_u), comp4005_Kalpha_u)
}


FUNCTION comp4005_linoid (x, y) {
  LOCAL v5318
  if 
    (fabs(x / y) < 1e-06) 
     {v5318  =  y * (1.0 + -(x / y / 2.0))} 
    else {v5318  =  x / (1.0 + -(exp(x / y)))} 
comp4005_linoid  =  v5318
}


FUNCTION comp4005_beta_v (v, Q10) {
  comp4005_beta_v  =  
  (Q10 * comp4005_Abeta_v) / 
    (1.0 + exp((v + -(comp4005_V0beta_v)) / comp4005_Kbeta_v))
}


FUNCTION comp4005_beta_u (v, Q10) {
  comp4005_beta_u  =  
  Q10 * comp4005_Abeta_u * 
    exp((v + -(comp4005_V0beta_u)) / comp4005_Kbeta_u)
}


PARAMETER {
  comp4005_Kalpha_v  =  -3.333
  comp4005_Kalpha_u  =  -10.0
  comp3920_vcinc  =  10.0
  comp4005_V0beta_v  =  -17.0
  comp4005_V0beta_u  =  -50.0
  comp4005_Kbeta_v  =  -5.0
  comp4005_Kbeta_u  =  -18.182
  comp4005_gbar  =  0.048
  comp3920_vchold  =  -71.0
  ca2o  =  2.0
  comp3920_vchdur  =  30.0
  comp4005_e  =  87.39
  comp3920_vcsteps  =  9.0
  comp3920_vcbdur  =  100.0
  comp3920_vcbase  =  -60.0
  comp4005_Aalpha_v  =  0.21
  comp4005_Aalpha_u  =  0.3
  comp4005_V0alpha_v  =  -50.0
  comp4005_V0alpha_u  =  -25.0
  comp4005_Abeta_v  =  3.0
  comp4005_Abeta_u  =  12.0
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
  comp4005_Q10
  celsius
  v
  ina
  ena
  i_Na
}


PROCEDURE asgns () {
  comp4005_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  ena  =  comp4005_e
}


PROCEDURE reactions () {
  Na_h  =  Na_hO
  Na_m  =  Na_mO
}


BREAKPOINT {
  LOCAL v5320
  SOLVE states METHOD derivimplicit
  reactions ()
  v5320  =  Na_m 
i_Na  =  (comp4005_gbar * v5320 * v5320 * v5320 * Na_h) * (v - ena)
  ina  =  i_Na
}


DERIVATIVE states {
  LOCAL v5313, v5316
  asgns ()
  v5313  =  Na_mO 
Na_mO'  =  
    -(Na_mO * comp4005_beta_u(v, comp4005_Q10)) + 
        (1 - v5313) * (comp4005_alpha_u(v, comp4005_Q10))
  v5316  =  Na_hO 
Na_hO'  =  
    -(Na_hO * comp4005_beta_v(v, comp4005_Q10)) + 
        (1 - v5316) * (comp4005_alpha_v(v, comp4005_Q10))
}


INITIAL {
  asgns ()
  Na_h  =  
  (comp4005_alpha_v(v, comp4005_Q10)) / 
    (comp4005_alpha_v(v, comp4005_Q10) + 
        comp4005_beta_v(v, comp4005_Q10))
  Na_hO  =  Na_h
  Na_m  =  
  (comp4005_alpha_u(v, comp4005_Q10)) / 
    (comp4005_alpha_u(v, comp4005_Q10) + 
        comp4005_beta_u(v, comp4005_Q10))
  Na_mO  =  Na_m
  ena  =  comp4005_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g Na_hO = %g\n" , t, v,  Na_hO)
  printf ("NMODL state: t = %g v = %g Na_mO = %g\n" , t, v,  Na_mO)
  printf ("NMODL state: t = %g v = %g Na_h = %g\n" , t, v,  Na_h)
  printf ("NMODL state: t = %g v = %g Na_m = %g\n" , t, v,  Na_m)
}
