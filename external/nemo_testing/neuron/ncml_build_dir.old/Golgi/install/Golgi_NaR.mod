

TITLE Golgi_NaR


NEURON {
  RANGE comp4743_vchold, comp4743_vcbase, comp4743_vcinc, comp4743_vcsteps, comp4743_vchdur, comp4743_vcbdur, comp4828_gbar, comp4828_e, NaR_m, NaR_h
  RANGE i_NaR
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION comp4828_alpha_s (v, Q10) {
  comp4828_alpha_s  =  
  Q10 * 
    (comp4828_Shiftalpha_s + 
        (comp4828_Aalpha_s * (v + comp4828_V0alpha_s)) / 
          (exp((v + comp4828_V0alpha_s) / comp4828_Kalpha_s) + -1.0))
}


FUNCTION comp4828_alpha_f (v, Q10) {
  comp4828_alpha_f  =  
  Q10 * comp4828_Aalpha_f * 
    exp((v + -(comp4828_V0alpha_f)) / comp4828_Kalpha_f)
}


FUNCTION comp4828_beta_s (v, Q10) {
  LOCAL v5348, v5347
  v5347  =  (v + comp4828_V0beta_s) / comp4828_Kbeta_s 
if (v5347 > 200.0)  {v5348  =  200.0} else {v5348  =  v5347} 
  comp4828_beta_s  =  
      Q10 * 
          (comp4828_Shiftbeta_s + 
              comp4828_Abeta_s * 
                (v + comp4828_V0beta_s) / (exp(v5348) + -1.0))
}


FUNCTION comp4828_beta_f (v, Q10) {
  comp4828_beta_f  =  
  Q10 * comp4828_Abeta_f * 
    exp((v + -(comp4828_V0beta_f)) / comp4828_Kbeta_f)
}


PARAMETER {
  comp4828_Kalpha_s  =  -6.81881
  comp4828_Kalpha_f  =  -62.52621
  comp4828_V0beta_s  =  43.97494
  comp4828_V0beta_f  =  -83.3332
  comp4743_vcbdur  =  100.0
  comp4828_Kbeta_s  =  0.10818
  comp4828_Kbeta_f  =  16.05379
  comp4743_vcbase  =  -60.0
  ca2o  =  2.0
  comp4743_vcinc  =  10.0
  comp4828_e  =  87.39
  comp4743_vcsteps  =  9.0
  comp4828_gbar  =  0.0017
  comp4828_Aalpha_s  =  -0.00493
  comp4828_Aalpha_f  =  0.31836
  comp4743_vchold  =  -71.0
  comp4828_Shiftbeta_s  =  0.04752
  comp4828_V0alpha_s  =  -4.48754
  comp4828_Shiftalpha_s  =  8e-05
  comp4828_V0alpha_f  =  -80.0
  comp4828_Abeta_s  =  0.01558
  comp4828_Abeta_f  =  0.01014
  comp4743_vchdur  =  30.0
}


STATE {
  NaR_hC
  NaR_hO
  NaR_mC
  NaR_mO
  NaR_h
  NaR_m
}


ASSIGNED {
  comp4828_Q10
  celsius
  v
  ina
  ena
  i_NaR
}


PROCEDURE asgns () {
  comp4828_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  ena  =  comp4828_e
}


PROCEDURE reactions () {
  NaR_h  =  NaR_hO
  NaR_m  =  NaR_mO
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_NaR  =  (comp4828_gbar * NaR_m * NaR_h) * (v - ena)
  ina  =  i_NaR
}


DERIVATIVE states {
  LOCAL v5342, v5345
  asgns ()
  v5342  =  NaR_mO 
NaR_mO'  =  
    -(NaR_mO * comp4828_beta_s(v, comp4828_Q10)) + 
        (1 - v5342) * (comp4828_alpha_s(v, comp4828_Q10))
  v5345  =  NaR_hO 
NaR_hO'  =  
    -(NaR_hO * comp4828_beta_f(v, comp4828_Q10)) + 
        (1 - v5345) * (comp4828_alpha_f(v, comp4828_Q10))
}


INITIAL {
  asgns ()
  NaR_h  =  
  (comp4828_alpha_f(v, comp4828_Q10)) / 
    (comp4828_alpha_f(v, comp4828_Q10) + 
        comp4828_beta_f(v, comp4828_Q10))
  NaR_hO  =  NaR_h
  NaR_m  =  
  (comp4828_alpha_s(v, comp4828_Q10)) / 
    (comp4828_alpha_s(v, comp4828_Q10) + 
        comp4828_beta_s(v, comp4828_Q10))
  NaR_mO  =  NaR_m
  ena  =  comp4828_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g NaR_hO = %g\n" , t, v,  NaR_hO)
  printf ("NMODL state: t = %g v = %g NaR_mO = %g\n" , t, v,  NaR_mO)
  printf ("NMODL state: t = %g v = %g NaR_h = %g\n" , t, v,  NaR_h)
  printf ("NMODL state: t = %g v = %g NaR_m = %g\n" , t, v,  NaR_m)
}
