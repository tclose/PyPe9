

TITLE CGC_CaHVA


NEURON {
  RANGE CaHVA_h, CaHVA_m, comp307_vcbdur, comp307_vchdur, comp307_vcsteps, comp307_vcinc, comp307_vcbase, comp307_vchold, comp33_e, comp33_gbar
  RANGE i_CaHVA
  RANGE ica
  USEION ca READ eca WRITE ica
}


FUNCTION comp33_alpha_u (v) {
  comp33_alpha_u  =  
  comp33_Q10 * comp33_Aalpha_u * 
    exp((v + -(comp33_V0alpha_u)) / comp33_Kalpha_u)
}


FUNCTION comp33_alpha_s (v) {
  comp33_alpha_s  =  
  comp33_Q10 * comp33_Aalpha_s * 
    exp((v + -(comp33_V0alpha_s)) / comp33_Kalpha_s)
}


FUNCTION comp33_beta_u (v) {
  comp33_beta_u  =  
  comp33_Q10 * comp33_Abeta_u * 
    exp((v + -(comp33_V0beta_u)) / comp33_Kbeta_u)
}


FUNCTION comp33_beta_s (v) {
  comp33_beta_s  =  
  comp33_Q10 * comp33_Abeta_s * 
    exp((v + -(comp33_V0beta_s)) / comp33_Kbeta_s)
}


PARAMETER {
  comp33_Kalpha_u  =  -18.183
  comp33_Kalpha_s  =  15.87301587302
  comp33_V0beta_u  =  -48.0
  comp33_V0beta_s  =  -18.66
  comp307_vcbdur  =  100.0
  comp33_Kbeta_u  =  83.33
  comp33_Kbeta_s  =  -25.641
  comp307_vcbase  =  -69.0
  comp307_vcinc  =  10.0
  fix_celsius  =  30.0
  comp307_vcsteps  =  8.0
  comp33_gbar  =  0.00046
  comp33_Aalpha_u  =  0.0013
  comp33_Aalpha_s  =  0.04944
  comp33_e  =  129.33
  comp307_vchold  =  -71.0
  comp33_V0alpha_u  =  -48.0
  comp33_V0alpha_s  =  -29.06
  comp33_Abeta_u  =  0.0013
  comp33_Abeta_s  =  0.08298
  comp307_vchdur  =  30.0
  comp33_Q10  =  3.0
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
  v
  ica
  eca
  i_CaHVA
}


PROCEDURE reactions () {
  CaHVA_h  =  CaHVA_hO
  CaHVA_m  =  CaHVA_mO
}


BREAKPOINT {
  LOCAL v455
  SOLVE states METHOD derivimplicit
  reactions ()
  v455  =  CaHVA_m 
i_CaHVA  =  (comp33_gbar * v455 * v455 * CaHVA_h) * (v - comp33_e)
  ica  =  i_CaHVA
}


DERIVATIVE states {
  LOCAL v450, v453
  v450  =  CaHVA_mO 
CaHVA_mO'  =  
    -(CaHVA_mO * comp33_beta_s(v)) + (1 - v450) * (comp33_alpha_s(v))
  v453  =  CaHVA_hO 
CaHVA_hO'  =  
    -(CaHVA_hO * comp33_beta_u(v)) + (1 - v453) * (comp33_alpha_u(v))
}


INITIAL {
  CaHVA_h  =  (comp33_alpha_u(v)) / (comp33_alpha_u(v) + comp33_beta_u(v))
  CaHVA_hO  =  CaHVA_h
  CaHVA_m  =  (comp33_alpha_s(v)) / (comp33_alpha_s(v) + comp33_beta_s(v))
  CaHVA_mO  =  CaHVA_m
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_hO = %g\n" , t, v,  CaHVA_hO)
  printf ("NMODL state: t = %g v = %g CaHVA_mO = %g\n" , t, v,  CaHVA_mO)
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
