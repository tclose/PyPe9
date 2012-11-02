

TITLE CGC_Kir


NEURON {
  RANGE comp1464_vchold, comp1464_vcbase, comp1464_vcinc, comp1464_vcsteps, comp1464_vchdur, comp1464_vcbdur, comp1549_gbar, comp1549_e, Kir_m
  RANGE i_Kir
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3039
  if 
    (fabs(x / y) < 1e-06) 
     {v3039  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3039  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3039
}


FUNCTION comp1549_beta_d (v, Q10) {
  comp1549_beta_d  =  
  Q10 * comp1549_Abeta_d * 
    exp((v + -(comp1549_V0beta_d)) / comp1549_Kbeta_d)
}


FUNCTION comp1549_alpha_d (v, Q10) {
  comp1549_alpha_d  =  
  Q10 * comp1549_Aalpha_d * 
    exp((v + -(comp1549_V0alpha_d)) / comp1549_Kalpha_d)
}


PARAMETER {
  comp1549_e  =  -84.69
  comp1464_vcbdur  =  100.0
  comp1549_gbar  =  0.0009
  comp1464_vcinc  =  10.0
  comp1464_vcbase  =  -69.0
  comp1464_vchdur  =  30.0
  comp1464_vcsteps  =  8.0
  comp1464_vchold  =  -71.0
  comp1549_V0alpha_d  =  -83.94
  comp1549_V0beta_d  =  -83.94
  comp1549_Kalpha_d  =  -24.3902
  comp1549_Abeta_d  =  0.16994
  comp1549_Kbeta_d  =  35.714
  comp1549_Aalpha_d  =  0.13289
}


STATE {
  Kir_mC
  Kir_mO
  Kir_m
}


ASSIGNED {
  comp1549_Q10
  celsius
  v
  ik
  ek
  i_Kir
}


PROCEDURE asgns () {
  comp1549_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
}


PROCEDURE reactions () {
  Kir_m  =  Kir_mO
}


BREAKPOINT {
  SOLVE kstates METHOD sparse
  reactions ()
  i_Kir  =  (comp1549_gbar * Kir_m) * (v - ek)
  ik  =  i_Kir
}


KINETIC kstates {
  asgns ()
  ~ Kir_mC <-> Kir_mO (comp1549_alpha_d(v, comp1549_Q10) , comp1549_beta_d(v, comp1549_Q10))
  CONSERVE Kir_mC + Kir_mO = 1
}


INITIAL {
  asgns ()
  Kir_m  =  
  (comp1549_alpha_d(v, comp1549_Q10)) / 
    (comp1549_alpha_d(v, comp1549_Q10) + 
        comp1549_beta_d(v, comp1549_Q10))
  Kir_mO  =  Kir_m
  SOLVE kstates STEADYSTATE sparse
  ek  =  comp1549_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g Kir_m = %g\n" , t, v,  Kir_m)
}
