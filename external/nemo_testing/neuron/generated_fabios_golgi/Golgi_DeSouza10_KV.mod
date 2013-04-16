

TITLE Golgi_DeSouza10_KV


NEURON {
  RANGE comp502_celsius, comp502_V_t, comp503_c, comp504_vchold, comp504_vcbase, comp504_vcinc, comp504_vcsteps, comp504_vchdur, comp504_vcbdur, comp505_gbar
  RANGE comp505_e, KV_m
  RANGE i_KV
  RANGE ik
  RANGE ek
  RANGE F, R
  USEION k READ ki, ko WRITE ik
}


FUNCTION comp505_linoid (x, y) {
  LOCAL v704
  if 
    (fabs(x / y) < 1e-06) 
     {v704  =  y * (1.0 + -(x / y / 2.0))} 
    else {v704  =  x / (exp(x / y) + -1.0)} 
comp505_linoid  =  v704
}


FUNCTION comp505_alpha_n (v, Q10) {
  comp505_alpha_n  =  
  Q10 * comp505_Aalpha_n * 
    comp505_linoid(v + -(comp505_V0alpha_n), comp505_Kalpha_n)
}


FUNCTION comp505_beta_n (v, Q10) {
  comp505_beta_n  =  
  Q10 * comp505_Abeta_n * 
    exp((v + -(comp505_V0beta_n)) / comp505_Kbeta_n)
}


PARAMETER {
  comp504_vcinc  =  10.0
  comp505_V0alpha_n  =  -26.0
  comp505_V0beta_n  =  -36.0
  comp504_vcbase  =  -69.0
  comp504_vcsteps  =  8.0
  comp502_V_t  =  -35.0
  comp505_Aalpha_n  =  -0.01
  comp504_vchdur  =  30.0
  comp504_vcbdur  =  100.0
  comp505_Kbeta_n  =  -80.0
  comp502_celsius  =  23.0
  comp505_Kalpha_n  =  -10.0
  comp505_gbar  =  0.032
  R  =  8.31342
  comp505_Abeta_n  =  0.125
  F  =  96485.3
  comp503_c  =  1.0
  comp504_vchold  =  -71.0
}


STATE {
  KV_m
}


ASSIGNED {
  KV_m_inf
  comp505_e
  comp505_n_inf
  ek
  comp505_tau_n
  KV_m_tau
  ena
  comp505_Q10
  ko
  ki
  celsius
  v
  nao
  nai
  ik
  i_KV
}


PROCEDURE asgns () {
  comp505_Q10  =  3.0 ^ ((comp502_celsius + -6.3) / 10.0)
  ena  =  (1000.0 * R * (comp502_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp502_celsius + 273.15)) / F * log(ko / ki)
  comp505_tau_n  =  
  1.0 / 
    (comp505_alpha_n(v, comp505_Q10) + comp505_beta_n(v, comp505_Q10))
  comp505_n_inf  =  
  (comp505_alpha_n(v, comp505_Q10)) / 
    (comp505_alpha_n(v, comp505_Q10) + comp505_beta_n(v, comp505_Q10))
  comp505_e  =  ek
  KV_m_tau  =  comp505_tau_n
  KV_m_inf  =  comp505_n_inf
  ek  =  comp505_e
}


BREAKPOINT {
  LOCAL x702
  SOLVE states METHOD derivimplicit
  x702  =  KV_m 
i_KV  =  (comp505_gbar * x702 * x702 * x702 * x702) * (v - comp505_e)
  ik  =  i_KV
}


DERIVATIVE states {
  asgns ()
  KV_m'  =  (KV_m_inf + -(KV_m)) / KV_m_tau
}


INITIAL {
  asgns ()
  KV_m  =  comp505_n_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KV_m = %g\n" , t, v,  KV_m)
}
