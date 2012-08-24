

TITLE CGC_Nar


NEURON {
  RANGE Nar_h, Nar_m, comp349_vcbdur, comp349_vchdur, comp349_vcsteps, comp349_vcinc, comp349_vcbase, comp349_vchold, comp47_e, comp47_gbar
  RANGE i_Nar
  RANGE ina
  USEION na READ ena WRITE ina
}


FUNCTION comp47_beta_f (v) {
  comp47_beta_f  =  
  comp47_Q10 * comp47_Abeta_f * 
    exp((v + -(comp47_V0beta_f)) / comp47_Kbeta_f)
}


FUNCTION comp47_alpha_f (v) {
  comp47_alpha_f  =  
  comp47_Q10 * comp47_Aalpha_f * 
    exp((v + -(comp47_V0alpha_f)) / comp47_Kalpha_f)
}


FUNCTION comp47_alpha_s (v) {
  comp47_alpha_s  =  
  (comp47_Q10 * 
        (comp47_Shiftalpha_s + 
            comp47_Aalpha_s * (v + comp47_V0alpha_s))) 
    / 
    (exp((v + comp47_V0alpha_s) / comp47_Kalpha_s) + -1.0)
}


FUNCTION comp47_beta_s (v) {
  comp47_beta_s  =  
  comp47_Q10 * 
    (comp47_Shiftbeta_s + 
        comp47_Abeta_s * 
          (v + comp47_V0beta_s) / 
            (exp((v + comp47_V0beta_s) / comp47_Kbeta_s) + -1.0))
}


PARAMETER {
  comp47_Kalpha_s  =  -6.81881
  comp47_Abeta_f  =  0.01014
  comp47_Shiftalpha_s  =  8e-05
  fix_celsius  =  30.0
  comp47_Abeta_s  =  0.01558
  comp47_Kbeta_s  =  0.10818
  comp47_V0alpha_f  =  -80.0
  comp47_V0beta_f  =  -83.3332
  comp47_V0alpha_s  =  -4.48754
  comp47_V0beta_s  =  43.97494
  comp349_vchdur  =  30.0
  comp47_e  =  87.39
  comp349_vcinc  =  10.0
  comp349_vcbase  =  -60.0
  comp349_vcbdur  =  100.0
  comp349_vcsteps  =  9.0
  comp47_Aalpha_f  =  0.31836
  comp47_Shiftbeta_s  =  0.04752
  comp47_Kbeta_f  =  16.05379
  comp47_Aalpha_s  =  -0.00493
  comp349_vchold  =  -71.0
  Vrest  =  -68.0
  comp47_gbar  =  0.0005
  comp47_Q10  =  3.0
  comp47_Kalpha_f  =  -62.52621
}


STATE {
  Nar_hC
  Nar_hO
  Nar_mC
  Nar_mO
  Nar_h
  Nar_m
}


ASSIGNED {
  v
  cai
  ica
  ina
  ena
  i_Nar
}


PROCEDURE reactions () {
  Nar_h  =  Nar_hO
  Nar_m  =  Nar_mO
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_Nar  =  (comp47_gbar * Nar_m * Nar_h) * (v - comp47_e)
  ina  =  i_Nar
}


DERIVATIVE states {
  LOCAL v492, v495
  v492  =  Nar_mO 
Nar_mO'  =  
    -(Nar_mO * comp47_beta_s(v)) + (1 - v492) * (comp47_alpha_s(v))
  v495  =  Nar_hO 
Nar_hO'  =  
    -(Nar_hO * comp47_beta_f(v)) + (1 - v495) * (comp47_alpha_f(v))
}


INITIAL {
  Nar_h  =  (comp47_alpha_f(v)) / (comp47_alpha_f(v) + comp47_beta_f(v))
  Nar_hO  =  Nar_h
  Nar_m  =  (comp47_alpha_s(v)) / (comp47_alpha_s(v) + comp47_beta_s(v))
  Nar_mO  =  Nar_m
}


PROCEDURE print_state () {
  printf ("Nar_hO = %g\n" ,  Nar_hO)
  printf ("Nar_mO = %g\n" ,  Nar_mO)
}
