

TITLE DeSouzaCGC_CaHVA


NEURON {
  RANGE comp350_vchold, comp350_vcbase, comp350_vcinc, comp350_vcsteps, comp350_vchdur, comp350_vcbdur, comp435_gbar, comp435_e, CaHVA_m, CaHVA_h
  RANGE i_CaHVA
  RANGE ica
  RANGE eca
  USEION ca READ eca WRITE ica
}


FUNCTION comp435_alpha_u (v, Q10) {
  comp435_alpha_u  =  
  Q10 * comp435_Aalpha_u * 
    exp((v + -(comp435_V0alpha_u)) / comp435_Kalpha_u)
}


FUNCTION comp435_alpha_s (v, Q10) {
  comp435_alpha_s  =  
  Q10 * comp435_Aalpha_s * 
    exp((v + -(comp435_V0alpha_s)) / comp435_Kalpha_s)
}


FUNCTION comp435_beta_u (v, Q10) {
  comp435_beta_u  =  
  Q10 * comp435_Abeta_u * 
    exp((v + -(comp435_V0beta_u)) / comp435_Kbeta_u)
}


FUNCTION comp435_beta_s (v, Q10) {
  comp435_beta_s  =  
  Q10 * comp435_Abeta_s * 
    exp((v + -(comp435_V0beta_s)) / comp435_Kbeta_s)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v3273
  if 
    (fabs(x / y) < 1e-06) 
     {v3273  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3273  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3273
}


PARAMETER {
  comp435_Kalpha_u  =  -18.183
  comp435_Kalpha_s  =  15.87301587302
  comp435_V0beta_u  =  -48.0
  comp435_V0beta_s  =  -18.66
  comp435_Kbeta_u  =  83.33
  comp435_Kbeta_s  =  -25.641
  comp350_vcinc  =  10.0
  comp350_vchold  =  -71.0
  comp350_vchdur  =  30.0
  comp435_e  =  132.457934
  comp350_vcsteps  =  8.0
  comp350_vcbdur  =  100.0
  comp350_vcbase  =  -69.0
  comp435_Aalpha_u  =  0.0013
  comp435_Aalpha_s  =  0.04944
  comp435_V0alpha_u  =  -48.0
  comp435_V0alpha_s  =  -29.06
  comp435_Abeta_u  =  0.0013
  comp435_Abeta_s  =  0.08298
  comp435_gbar  =  0.00046
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
  comp435_Q10
  celsius
  v
  ica
  eca
  i_CaHVA
}


PROCEDURE asgns () {
  comp435_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  eca  =  comp435_e
}


PROCEDURE reactions () {
  CaHVA_h  =  CaHVA_hO
  CaHVA_m  =  CaHVA_mO
}


BREAKPOINT {
  LOCAL v3275
  SOLVE states METHOD derivimplicit
  reactions ()
  v3275  =  CaHVA_m 
i_CaHVA  =  (comp435_gbar * v3275 * v3275 * CaHVA_h) * (v - eca)
  ica  =  i_CaHVA
}


DERIVATIVE states {
  LOCAL v3268, v3271
  asgns ()
  v3268  =  CaHVA_mO 
CaHVA_mO'  =  
    -(CaHVA_mO * comp435_beta_s(v, comp435_Q10)) + 
        (1 - v3268) * (comp435_alpha_s(v, comp435_Q10))
  v3271  =  CaHVA_hO 
CaHVA_hO'  =  
    -(CaHVA_hO * comp435_beta_u(v, comp435_Q10)) + 
        (1 - v3271) * (comp435_alpha_u(v, comp435_Q10))
}


INITIAL {
  asgns ()
  CaHVA_h  =  
  (comp435_alpha_u(v, comp435_Q10)) / 
    (comp435_alpha_u(v, comp435_Q10) + comp435_beta_u(v, comp435_Q10))
  CaHVA_hO  =  CaHVA_h
  CaHVA_m  =  
  (comp435_alpha_s(v, comp435_Q10)) / 
    (comp435_alpha_s(v, comp435_Q10) + comp435_beta_s(v, comp435_Q10))
  CaHVA_mO  =  CaHVA_m
  eca  =  comp435_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_hO = %g\n" , t, v,  CaHVA_hO)
  printf ("NMODL state: t = %g v = %g CaHVA_mO = %g\n" , t, v,  CaHVA_mO)
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
}
