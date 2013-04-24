

TITLE Golgi_DeSouza10_Na


NEURON {
  RANGE comp560_celsius, comp560_V_t, comp561_c, comp562_vchold, comp562_vcbase, comp562_vcinc, comp562_vcsteps, comp562_vchdur, comp562_vcbdur, comp563_gbar
  RANGE comp563_e, Na_m, Na_h
  RANGE i_Na
  RANGE ina
  RANGE ena
  RANGE F, R
  USEION na READ nai, nao WRITE ina
}


FUNCTION comp563_alpha_v (v, Q10) {
  comp563_alpha_v  =  
  Q10 * comp563_Aalpha_v * 
    exp((v + -(comp563_V0alpha_v)) / comp563_Kalpha_v)
}


FUNCTION comp563_alpha_u (v, Q10) {
  comp563_alpha_u  =  
  Q10 * comp563_Aalpha_u * 
    comp563_linoid(v + -(comp563_V0alpha_u), comp563_Kalpha_u)
}


FUNCTION comp563_beta_v (v, Q10) {
  comp563_beta_v  =  
  (Q10 * comp563_Abeta_v) / 
    (1.0 + exp((v + -(comp563_V0beta_v)) / comp563_Kbeta_v))
}


FUNCTION comp563_beta_u (v, Q10) {
  comp563_beta_u  =  
  Q10 * comp563_Abeta_u * 
    exp((v + -(comp563_V0beta_u)) / comp563_Kbeta_u)
}


FUNCTION comp563_linoid (x, y) {
  LOCAL v709
  if 
    (fabs(x / y) < 1e-06) 
     {v709  =  y * (1.0 + -(x / y / 2.0))} 
    else {v709  =  x / (1.0 + -(exp(x / y)))} 
comp563_linoid  =  v709
}


PARAMETER {
  comp560_V_t  =  -35.0
  comp563_V0alpha_v  =  -50.0
  comp563_V0alpha_u  =  -25.0
  comp562_vcinc  =  10.0
  comp562_vcbase  =  -60.0
  comp563_V0beta_v  =  -17.0
  comp563_V0beta_u  =  -50.0
  comp563_gbar  =  0.048
  comp562_vcsteps  =  9.0
  comp562_vchdur  =  30.0
  comp562_vcbdur  =  100.0
  comp561_c  =  1.0
  comp563_Aalpha_v  =  0.21
  comp563_Aalpha_u  =  0.3
  comp563_Kbeta_v  =  -5.0
  comp563_Kbeta_u  =  -18.182
  comp560_celsius  =  23.0
  comp563_Kalpha_v  =  -3.333
  comp563_Kalpha_u  =  -10.0
  comp562_vchold  =  -71.0
  comp563_Abeta_v  =  3.0
  comp563_Abeta_u  =  12.0
  R  =  8.31342
  F  =  96485.3
}


STATE {
  Na_h
  Na_m
}


ASSIGNED {
  Na_h_inf
  Na_m_tau
  ek
  comp563_Q10
  Na_h_tau
  comp563_tau_v
  comp563_tau_u
  comp563_v_inf
  Na_m_inf
  ena
  comp563_e
  comp563_u_inf
  ko
  ki
  celsius
  v
  nao
  nai
  ina
  i_Na
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp560_celsius + 273.15)) / F * log(nao / nai)
  comp563_Q10  =  3.0 ^ ((comp560_celsius + -20.0) / 10.0)
  ek  =  (1000.0 * R * (comp560_celsius + 273.15)) / F * log(ko / ki)
  comp563_u_inf  =  
  (comp563_alpha_u(v, comp563_Q10)) / 
    (comp563_alpha_u(v, comp563_Q10) + comp563_beta_u(v, comp563_Q10))
  comp563_e  =  ena
  comp563_v_inf  =  
  (comp563_alpha_v(v, comp563_Q10)) / 
    (comp563_alpha_v(v, comp563_Q10) + comp563_beta_v(v, comp563_Q10))
  comp563_tau_u  =  
  1.0 / 
    (comp563_alpha_u(v, comp563_Q10) + comp563_beta_u(v, comp563_Q10))
  comp563_tau_v  =  
  1.0 / 
    (comp563_alpha_v(v, comp563_Q10) + comp563_beta_v(v, comp563_Q10))
  Na_m_inf  =  comp563_u_inf
  Na_h_tau  =  comp563_tau_v
  Na_m_tau  =  comp563_tau_u
  Na_h_inf  =  comp563_v_inf
  ena  =  comp563_e
}


BREAKPOINT {
  LOCAL x707
  SOLVE states METHOD derivimplicit
  x707  =  Na_m 
i_Na  =  (comp563_gbar * x707 * x707 * x707 * Na_h) * (v - comp563_e)
  ina  =  i_Na
}


DERIVATIVE states {
  asgns ()
  Na_m'  =  (Na_m_inf + -(Na_m)) / Na_m_tau
  Na_h'  =  (Na_h_inf + -(Na_h)) / Na_h_tau
}


INITIAL {
  asgns ()
  Na_m  =  comp563_u_inf
  Na_h  =  comp563_v_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g Na_h = %g\n" , t, v,  Na_h)
  printf ("NMODL state: t = %g v = %g Na_m = %g\n" , t, v,  Na_m)
}
