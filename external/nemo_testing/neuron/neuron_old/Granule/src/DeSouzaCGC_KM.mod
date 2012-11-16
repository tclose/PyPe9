

TITLE DeSouzaCGC_KM


NEURON {
  RANGE comp1998_vchold, comp1998_vcbase, comp1998_vcinc, comp1998_vcsteps, comp1998_vchdur, comp1998_vcbdur, comp2083_gbar, comp2083_e, KM_m
  RANGE i_KM
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp2083_alpha_n (v, Q10) {
  comp2083_alpha_n  =  
  Q10 * comp2083_Aalpha_n * 
    exp((v + -(comp2083_V0alpha_n)) / comp2083_Kalpha_n)
}


FUNCTION comp2083_beta_n (v, Q10) {
  comp2083_beta_n  =  
  Q10 * comp2083_Abeta_n * 
    exp((v + -(comp2083_V0beta_n)) / comp2083_Kbeta_n)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3317
  if 
    (fabs(x / y) < 1e-06) 
     {v3317  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3317  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3317
}


PARAMETER {
  comp2083_Kalpha_n  =  40.0
  comp2083_V0beta_n  =  -30.0
  comp2083_V0_ninf  =  -35.0
  comp2083_Kbeta_n  =  -20.0
  comp2083_gbar  =  0.00025
  comp1998_vchold  =  -71.0
  comp2083_B_ninf  =  6.0
  comp1998_vchdur  =  30.0
  comp2083_e  =  -84.69
  comp1998_vcsteps  =  8.0
  comp1998_vcbdur  =  100.0
  comp1998_vcinc  =  10.0
  comp1998_vcbase  =  -69.0
  comp2083_Aalpha_n  =  0.0033
  comp2083_V0alpha_n  =  -30.0
  comp2083_Abeta_n  =  0.0033
}


STATE {
  KM_m
}


ASSIGNED {
  KM_m_inf
  comp2083_Q10
  KM_m_tau
  celsius
  v
  ik
  ek
  i_KM
}


PROCEDURE asgns () {
  comp2083_Q10  =  3.0 ^ ((celsius + -22.0) / 10.0)
  KM_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp2083_V0_ninf)) / comp2083_B_ninf))
  KM_m_tau  =  
  1.0 / 
    (comp2083_alpha_n(v, comp2083_Q10) + 
        comp2083_beta_n(v, comp2083_Q10))
  ek  =  comp2083_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KM  =  (comp2083_gbar * KM_m) * (v - ek)
  ik  =  i_KM
}


DERIVATIVE states {
  asgns ()
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
}


INITIAL {
  asgns ()
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp2083_V0_ninf)) / comp2083_B_ninf))
  ek  =  comp2083_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KM_m = %g\n" , t, v,  KM_m)
}
