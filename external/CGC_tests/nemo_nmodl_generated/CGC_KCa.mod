

TITLE CGC_KCa


NEURON {
  RANGE comp1140_vchold, comp1140_vcbase, comp1140_vcinc, comp1140_vcsteps, comp1140_vchdur, comp1140_vcbdur, comp1225_gbar, comp1225_e, KCa_m
  RANGE i_KCa
  RANGE ik
  RANGE ek
  RANGE cai
  USEION ca READ cai
  USEION k READ ek WRITE ik
}


FUNCTION comp1225_beta_c (v, cai, Q10) {
  comp1225_beta_c  =  
  (Q10 * comp1225_Abeta_c) / 
    (1.0 + cai / (comp1225_Bbeta_c * exp(v / comp1225_Kbeta_c)))
}


FUNCTION comp1225_alpha_c (v, cai, Q10) {
  comp1225_alpha_c  =  
  (Q10 * comp1225_Aalpha_c) / 
    (1.0 + (comp1225_Balpha_c * exp(v / comp1225_Kalpha_c)) / cai)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3037
  if 
    (fabs(x / y) < 1e-06) 
     {v3037  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3037  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3037
}


PARAMETER {
  comp1225_gbar  =  0.04
  comp1140_vcbase  =  -69.0
  comp1225_Aalpha_c  =  2.5
  comp1225_Abeta_c  =  1.5
  comp1140_vcbdur  =  100.0
  comp1140_vchdur  =  30.0
  comp1225_Kalpha_c  =  -11.765
  comp1140_vcinc  =  10.0
  comp1225_Kbeta_c  =  -11.765
  comp1140_vchold  =  -71.0
  comp1225_e  =  -84.69
  comp1225_Bbeta_c  =  0.00015
  comp1140_vcsteps  =  8.0
  comp1225_Balpha_c  =  0.0015
}


STATE {
  KCa_mC
  KCa_mO
  KCa_m
}


ASSIGNED {
  comp1225_Q10
  v
  comp1225_cai
  celsius
  cai
  ik
  ek
  i_KCa
}


PROCEDURE asgns () {
  comp1225_Q10  =  3.0 ^ ((celsius + -30.0) / 10.0)
}


PROCEDURE reactions () {
  KCa_m  =  KCa_mO
}


BREAKPOINT {
  SOLVE kstates METHOD sparse
  reactions ()
  i_KCa  =  (comp1225_gbar * KCa_m) * (v - ek)
  ik  =  i_KCa
}


KINETIC kstates {
  comp1225_cai  =  cai
  asgns ()
  ~ KCa_mC <-> KCa_mO (comp1225_alpha_c(v, comp1225_cai, comp1225_Q10) , comp1225_beta_c(v, comp1225_cai, comp1225_Q10))
  CONSERVE KCa_mC + KCa_mO = 1
}


INITIAL {
  comp1225_cai  =  cai
  asgns ()
  KCa_m  =  
  (comp1225_alpha_c(v, comp1225_cai, comp1225_Q10)) / 
    (comp1225_alpha_c(v, comp1225_cai, comp1225_Q10) + 
        comp1225_beta_c(v, comp1225_cai, comp1225_Q10))
  KCa_mO  =  KCa_m
  SOLVE kstates STEADYSTATE sparse
  ek  =  comp1225_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g KCa_m = %g\n" , t, v,  KCa_m)
}
