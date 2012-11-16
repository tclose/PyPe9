

TITLE CGC_KV


NEURON {
  RANGE comp2134_vchold, comp2134_vcbase, comp2134_vcinc, comp2134_vcsteps, comp2134_vchdur, comp2134_vcbdur, comp2219_gbar, comp2219_e, KV_m
  RANGE i_KV
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
}


FUNCTION comp2219_beta_n (v, Q10) {
  comp2219_beta_n  =  
  Q10 * comp2219_Abeta_n * 
    exp((v + -(comp2219_V0beta_n)) / comp2219_Kbeta_n)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3043
  if 
    (fabs(x / y) < 1e-06) 
     {v3043  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3043  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3043
}


FUNCTION comp2219_alpha_n (v, Q10) {
  comp2219_alpha_n  =  
  Q10 * comp2219_Aalpha_n * 
    linoid(v + -(comp2219_V0alpha_n), comp2219_Kalpha_n)
}


PARAMETER {
  comp2219_V0beta_n  =  -35.0
  comp2134_vcbdur  =  100.0
  comp2134_vcinc  =  10.0
  comp2134_vchold  =  -71.0
  comp2134_vchdur  =  30.0
  comp2134_vcbase  =  -69.0
  comp2134_vcsteps  =  8.0
  comp2219_Kalpha_n  =  -10.0
  comp2219_gbar  =  0.003
  comp2219_Aalpha_n  =  -0.01
  comp2219_e  =  -84.69
  comp2219_V0alpha_n  =  -25.0
  comp2219_Abeta_n  =  0.125
  comp2219_Kbeta_n  =  -80.0
}


STATE {
  KV_mC
  KV_mO
  KV_m
}


ASSIGNED {
  comp2219_Q10
  celsius
  v
  ik
  ek
  i_KV
}


PROCEDURE asgns () {
  comp2219_Q10  =  3.0 ^ ((celsius + -6.3) / 10.0)
}


PROCEDURE reactions () {
  KV_m  =  KV_mO
}


BREAKPOINT {
  LOCAL v3045
  SOLVE kstates METHOD sparse
  reactions ()
  v3045  =  KV_m 
i_KV  =  (comp2219_gbar * v3045 * v3045 * v3045 * v3045) * (v - ek)
  ik  =  i_KV
}


KINETIC kstates {
  asgns ()
  ~ KV_mC <-> KV_mO (comp2219_alpha_n(v, comp2219_Q10) , comp2219_beta_n(v, comp2219_Q10))
  CONSERVE KV_mC + KV_mO = 1
}


INITIAL {
  asgns ()
  KV_m  =  
  (comp2219_alpha_n(v, comp2219_Q10)) / 
    (comp2219_alpha_n(v, comp2219_Q10) + 
        comp2219_beta_n(v, comp2219_Q10))
  KV_mO  =  KV_m
  SOLVE kstates STEADYSTATE sparse
  ek  =  comp2219_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KV_m = %g\n" , t, v,  KV_m)
}
