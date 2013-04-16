

TITLE Golgi_DeSouza10_NaR


NEURON {
  RANGE comp645_celsius, comp645_V_t, comp646_c, comp647_vchold, comp647_vcbase, comp647_vcinc, comp647_vcsteps, comp647_vchdur, comp647_vcbdur, comp648_gbar
  RANGE comp648_e, NaR_m, NaR_h
  RANGE i_NaR
  RANGE ina
  RANGE ena
  RANGE F, R
  USEION na READ nai, nao WRITE ina
}


FUNCTION comp648_alpha_s (v, Q10) {
  comp648_alpha_s  =  
  Q10 * 
    (comp648_Shiftalpha_s + 
        (comp648_Aalpha_s * (v + comp648_V0alpha_s)) / 
          (exp((v + comp648_V0alpha_s) / comp648_Kalpha_s) + -1.0))
}


FUNCTION comp648_alpha_f (v, Q10) {
  comp648_alpha_f  =  
  Q10 * comp648_Aalpha_f * 
    exp((v + -(comp648_V0alpha_f)) / comp648_Kalpha_f)
}


FUNCTION comp648_beta_s (v, Q10) {
  LOCAL v714, v713
  v713  =  (v + comp648_V0beta_s) / comp648_Kbeta_s 
if (v713 > 200.0)  {v714  =  200.0} else {v714  =  v713} 
  comp648_beta_s  =  
      Q10 * 
          (comp648_Shiftbeta_s + 
              comp648_Abeta_s * 
                (v + comp648_V0beta_s) / (exp(v714) + -1.0))
}


FUNCTION comp648_beta_f (v, Q10) {
  comp648_beta_f  =  
  Q10 * comp648_Abeta_f * 
    exp((v + -(comp648_V0beta_f)) / comp648_Kbeta_f)
}


PARAMETER {
  comp648_V0alpha_s  =  -4.48754
  comp648_Shiftalpha_s  =  8e-05
  comp648_V0alpha_f  =  -80.0
  comp647_vchold  =  -71.0
  comp648_V0beta_s  =  43.97494
  comp648_V0beta_f  =  -83.3332
  comp647_vcinc  =  10.0
  comp647_vcsteps  =  9.0
  comp648_Aalpha_s  =  -0.00493
  comp647_vcbase  =  -60.0
  comp646_c  =  1.0
  comp648_Aalpha_f  =  0.31836
  comp648_Shiftbeta_s  =  0.04752
  comp648_Kbeta_s  =  0.10818
  comp645_celsius  =  23.0
  comp648_Kbeta_f  =  16.05379
  comp648_Kalpha_s  =  -6.81881
  comp648_Kalpha_f  =  -62.52621
  comp648_Abeta_s  =  0.01558
  R  =  8.31342
  comp648_Abeta_f  =  0.01014
  F  =  96485.3
  comp647_vchdur  =  30.0
  comp648_gbar  =  0.0017
  comp647_vcbdur  =  100.0
  comp645_V_t  =  -35.0
}


STATE {
  NaR_h
  NaR_m
}


ASSIGNED {
  NaR_m_tau
  comp648_s_inf
  comp648_Q10
  comp648_f_inf
  ek
  NaR_h_tau
  NaR_m_inf
  ena
  comp648_tau_s
  comp648_tau_f
  comp648_e
  NaR_h_inf
  ko
  ki
  celsius
  v
  nao
  nai
  ina
  i_NaR
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp645_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp645_celsius + 273.15)) / F * log(ko / ki)
  comp648_Q10  =  3.0 ^ ((comp645_celsius + -20.0) / 10.0)
  comp648_e  =  ena
  comp648_tau_f  =  
  1.0 / 
    (comp648_alpha_f(v, comp648_Q10) + comp648_beta_f(v, comp648_Q10))
  comp648_tau_s  =  
  1.0 / 
    (comp648_alpha_s(v, comp648_Q10) + comp648_beta_s(v, comp648_Q10))
  comp648_f_inf  =  
  (comp648_alpha_f(v, comp648_Q10)) / 
    (comp648_alpha_f(v, comp648_Q10) + comp648_beta_f(v, comp648_Q10))
  comp648_s_inf  =  
  (comp648_alpha_s(v, comp648_Q10)) / 
    (comp648_alpha_s(v, comp648_Q10) + comp648_beta_s(v, comp648_Q10))
  NaR_h_inf  =  comp648_f_inf
  NaR_m_inf  =  comp648_s_inf
  NaR_h_tau  =  comp648_tau_f
  NaR_m_tau  =  comp648_tau_s
  ena  =  comp648_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_NaR  =  (comp648_gbar * NaR_m * NaR_h) * (v - comp648_e)
  ina  =  i_NaR
}


DERIVATIVE states {
  asgns ()
  NaR_m'  =  (NaR_m_inf + -(NaR_m)) / NaR_m_tau
  NaR_h'  =  (NaR_h_inf + -(NaR_h)) / NaR_h_tau
}


INITIAL {
  asgns ()
  NaR_m  =  comp648_s_inf
  NaR_h  =  comp648_f_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g NaR_h = %g\n" , t, v,  NaR_h)
  printf ("NMODL state: t = %g v = %g NaR_m = %g\n" , t, v,  NaR_m)
}
