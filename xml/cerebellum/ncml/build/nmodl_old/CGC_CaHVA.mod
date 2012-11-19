

TITLE CGC_CaHVA


NEURON {
  RANGE comp182_vchold, comp182_vcbase, comp182_vcinc, comp182_vcsteps, comp182_vchdur, comp182_vcbdur, comp267_gbar, comp267_e, CaHVA_m, CaHVA_h
  RANGE i_CaHVA
  RANGE ica
  RANGE eca
  USEION ca READ eca WRITE ica
}


FUNCTION comp267_beta_u (v, Q10) {
  comp267_beta_u  =  
  Q10 * comp267_Abeta_u * 
    exp((v + -(comp267_V0beta_u)) / comp267_Kbeta_u)
}


FUNCTION comp267_beta_s (v, Q10) {
  comp267_beta_s  =  
  Q10 * comp267_Abeta_s * 
    exp((v + -(comp267_V0beta_s)) / comp267_Kbeta_s)
}


FUNCTION linoid (x, y) {
  LOCAL v3029
  if 
    (fabs(x / y) < 1e-06) 
     {v3029  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3029  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3029
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION comp267_alpha_u (v, Q10) {
  comp267_alpha_u  =  
  Q10 * comp267_Aalpha_u * 
    exp((v + -(comp267_V0alpha_u)) / comp267_Kalpha_u)
}


FUNCTION comp267_alpha_s (v, Q10) {
  comp267_alpha_s  =  
  Q10 * comp267_Aalpha_s * 
    exp((v + -(comp267_V0alpha_s)) / comp267_Kalpha_s)
}


PARAMETER {
  comp182_vcinc  =  10.0
  comp267_e  =  129.33
  comp267_gbar  =  0.00046
  comp267_V0beta_s  =  -18.66
  comp267_V0beta_u  =  -48.0
  comp267_V0alpha_u  =  -48.0
  comp267_V0alpha_s  =  -29.06
  comp182_vcsteps  =  8.0
  comp182_vcbdur  =  100.0
  comp267_Kalpha_u  =  -18.183
  comp267_Kalpha_s  =  15.87301587302
  comp182_vcbase  =  -69.0
  comp182_vchdur  =  30.0
  comp267_Abeta_u  =  0.0013
  comp267_Abeta_s  =  0.08298
  comp182_vchold  =  -71.0
  comp267_Aalpha_u  =  0.0013
  comp267_Aalpha_s  =  0.04944
  comp267_Kbeta_u  =  83.33
  comp267_Kbeta_s  =  -25.641
}


STATE {
  CaHVA_hC
  CaHVA_hO
  CaHVA_mC
  CaHVA_mO
  CaHVA_h
  CaHVA_m
}


ASSIGNED {
  comp267_Q10
  v
  celsius
  ica
  eca
  i_CaHVA
}


PROCEDURE asgns () {
  comp267_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
}


PROCEDURE reactions () {
  CaHVA_h  =  CaHVA_hO
  CaHVA_m  =  CaHVA_mO
}


BREAKPOINT {
  LOCAL v3031
  SOLVE kstates METHOD sparse
  reactions ()
  v3031  =  CaHVA_m 
i_CaHVA  =  (comp267_gbar * v3031 * v3031 * CaHVA_h) * (v - eca)
  ica  =  i_CaHVA
}


KINETIC kstates {
  asgns ()
  ~ CaHVA_hC <-> CaHVA_hO (comp267_alpha_u(v, comp267_Q10) , comp267_beta_u(v, comp267_Q10))
  CONSERVE CaHVA_hC + CaHVA_hO = 1
  ~ CaHVA_mC <-> CaHVA_mO (comp267_alpha_s(v, comp267_Q10) , comp267_beta_s(v, comp267_Q10))
  CONSERVE CaHVA_mC + CaHVA_mO = 1
}


INITIAL {
  asgns ()
  CaHVA_h  =  
  (comp267_alpha_u(v, comp267_Q10)) / 
    (comp267_alpha_u(v, comp267_Q10) + comp267_beta_u(v, comp267_Q10))
  CaHVA_hO  =  CaHVA_h
  CaHVA_m  =  
  (comp267_alpha_s(v, comp267_Q10)) / 
    (comp267_alpha_s(v, comp267_Q10) + comp267_beta_s(v, comp267_Q10))
  CaHVA_mO  =  CaHVA_m
  SOLVE kstates STEADYSTATE sparse
  eca  =  comp267_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
