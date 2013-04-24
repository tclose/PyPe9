

TITLE Granule_DeSouza10_KV


NEURON {
  RANGE comp410_celsius, comp410_V_t, comp411_C_m, comp412_vchold, comp412_vcbase, comp412_vcinc, comp412_vcsteps, comp412_vchdur, comp412_vcbdur, comp413_gbar
  RANGE comp413_e, KV_m
  RANGE i_KV
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp413_alpha_n (v, Q10) {
  comp413_alpha_n  =  
  Q10 * comp413_Aalpha_n * 
    comp413_linoid(v + -(comp413_V0alpha_n), comp413_Kalpha_n)
}


FUNCTION comp413_beta_n (v, Q10) {
  comp413_beta_n  =  
  Q10 * comp413_Abeta_n * 
    exp((v + -(comp413_V0beta_n)) / comp413_Kbeta_n)
}


FUNCTION comp413_linoid (x, y) {
  LOCAL v513
  if 
    (fabs(x / y) < 1e-06) 
     {v513  =  y * (1.0 + -(x / y / 2.0))} 
    else {v513  =  x / (exp(x / y) + -1.0)} 
comp413_linoid  =  v513
}


PARAMETER {
  comp412_vcbase  =  -69.0
  comp413_V0alpha_n  =  -25.0
  comp411_C_m  =  1.0
  comp413_gbar  =  0.003
  comp413_V0beta_n  =  -35.0
  comp412_vcsteps  =  8.0
  comp412_vchdur  =  30.0
  comp412_vcbdur  =  100.0
  comp413_Aalpha_n  =  -0.01
  comp413_Kbeta_n  =  -80.0
  comp410_celsius  =  30.0
  comp412_vcinc  =  10.0
  comp413_Kalpha_n  =  -10.0
  comp412_vchold  =  -71.0
  comp410_V_t  =  -35.0
  comp413_Abeta_n  =  0.125
  comp413_e  =  -84.69
}


STATE {
  KV_m
}


ASSIGNED {
  comp413_Q10
  KV_m_inf
  comp413_tau_n
  KV_m_tau
  comp413_n_inf
  celsius
  v
  ik
  ek
  i_KV
}


PROCEDURE asgns () {
  comp413_Q10  =  3.0 ^ ((comp410_celsius + -6.3) / 10.0)
  comp413_n_inf  =  
  (comp413_alpha_n(v, comp413_Q10)) / 
    (comp413_alpha_n(v, comp413_Q10) + comp413_beta_n(v, comp413_Q10))
  comp413_tau_n  =  
  1.0 / 
    (comp413_alpha_n(v, comp413_Q10) + comp413_beta_n(v, comp413_Q10))
  KV_m_tau  =  comp413_tau_n
  KV_m_inf  =  comp413_n_inf
  ek  =  comp413_e
}


BREAKPOINT {
  LOCAL x511
  SOLVE states METHOD derivimplicit
  x511  =  KV_m 
i_KV  =  (comp413_gbar * x511 * x511 * x511 * x511) * (v - comp413_e)
  ik  =  i_KV
}


DERIVATIVE states {
  asgns ()
  KV_m'  =  (KV_m_inf + -(KV_m)) / KV_m_tau
}


INITIAL {
  asgns ()
  KV_m  =  comp413_n_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KV_m = %g\n" , t, v,  KV_m)
}
