

TITLE Granule_KM


NEURON {
  RANGE comp1785_vchold, comp1785_vcbase, comp1785_vcinc, comp1785_vcsteps, comp1785_vchdur, comp1785_vcbdur, comp1870_gbar, comp1870_e, KM_m
  RANGE i_KM
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp1870_alpha_n (v, Q10) {
  comp1870_alpha_n  =  
  Q10 * comp1870_Aalpha_n * 
    exp((v + -(comp1870_V0alpha_n)) / comp1870_Kalpha_n)
}


FUNCTION linoid (x, y) {
  LOCAL v3041
  if 
    (fabs(x / y) < 1e-06) 
     {v3041  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3041  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3041
}


FUNCTION comp1870_beta_n (v, Q10) {
  comp1870_beta_n  =  
  Q10 * comp1870_Abeta_n * 
    exp((v + -(comp1870_V0beta_n)) / comp1870_Kbeta_n)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


PARAMETER {
  comp1870_gbar  =  0.00025
  comp1870_V0alpha_n  =  -30.0
  comp1785_vcsteps  =  8.0
  comp1870_V0_ninf  =  -35.0
  comp1870_V0beta_n  =  -30.0
  comp1870_B_ninf  =  6.0
  comp1785_vcbase  =  -69.0
  comp1870_e  =  -84.69
  comp1785_vcbdur  =  100.0
  comp1870_Kalpha_n  =  40.0
  comp1870_Kbeta_n  =  -20.0
  comp1870_Aalpha_n  =  0.0033
  comp1785_vchold  =  -71.0
  comp1785_vcinc  =  10.0
  comp1870_Abeta_n  =  0.0033
  comp1785_vchdur  =  30.0
}


STATE {
  KM_m
}


ASSIGNED {
  comp1870_Q10
  KM_m_tau
  KM_m_inf
  v
  celsius
  ik
  ek
  i_KM
}


PROCEDURE asgns () {
  KM_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp1870_V0_ninf)) / comp1870_B_ninf))
  comp1870_Q10  =  3.0 ^ ((celsius + -22.0) / 10.0)
  KM_m_tau  =  
  1.0 / 
    (comp1870_alpha_n(v, comp1870_Q10) + 
        comp1870_beta_n(v, comp1870_Q10))
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_KM  =  (comp1870_gbar * KM_m) * (v - ek)
  ik  =  i_KM
}


DERIVATIVE states {
  asgns ()
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
}


INITIAL {
  asgns ()
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp1870_V0_ninf)) / comp1870_B_ninf))
  ek  =  comp1870_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KM_m = %g\n" , t, v,  KM_m)
}
