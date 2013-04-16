

TITLE Golgi_DeSouza10_HCN2


NEURON {
  RANGE comp349_celsius, comp349_V_t, comp350_c, comp351_vchold, comp351_vcbase, comp351_vcinc, comp351_vcsteps, comp351_vchdur, comp351_vcbdur, comp352_o_slow
  RANGE comp352_o_fast, comp352_gbar, comp352_e
  RANGE i_HCN2
  RANGE e
  RANGE F, R
  NONSPECIFIC_CURRENT i
}


FUNCTION comp352_tau_slow (potential, t1, t2, t3) {
  comp352_tau_slow  =  exp(t3 * (t1 * potential + -(t2)))
}


FUNCTION comp352_o_inf (potential, Ehalf, c) {
  comp352_o_inf  =  1.0 / (1.0 + exp((potential + -(Ehalf)) * c))
}


FUNCTION comp352_tau_fast (potential, t1, t2, t3) {
  comp352_tau_fast  =  exp(t3 * (t1 * potential + -(t2)))
}


FUNCTION comp352_r (potential, r1, r2) {
  LOCAL v699, v700
  if 
    (potential >= -64.7) 
     {v699  =  0.0} 
    else 
    {if 
          (potential <= -108.7) 
           {v700  =  1.0} 
          else {v700  =  r1 * potential + r2} 
      v699  =  v700} 
comp352_r  =  v699
}


PARAMETER {
  comp351_vcbdur  =  100.0
  comp351_vchold  =  -71.0
  comp351_vcsteps  =  8.0
  comp351_vcinc  =  10.0
  comp350_c  =  1.0
  comp349_celsius  =  23.0
  comp352_gbar  =  8e-05
  comp351_vcbase  =  -69.0
  comp349_V_t  =  -35.0
  R  =  8.31342
  F  =  96485.3
  comp352_tEs  =  2.3026
  comp352_tEf  =  2.3026
  comp352_Ehalf  =  -81.95
  comp352_tDs  =  -5.2944
  comp352_tDf  =  -5.6111
  comp352_e  =  -20.0
  comp352_c  =  0.1661
  comp352_tCs  =  0.0152
  comp352_rB  =  -1.4694
  comp352_rA  =  -0.0227
  comp352_tCf  =  0.0269
  comp351_vchdur  =  30.0
}


STATE {
  comp352_o_fast
  comp352_o_slow
}


ASSIGNED {
  comp352_tau_s
  comp352_tau_f
  comp352_o_fast_inf
  comp352_o_slow_inf
  ek
  ena
  ko
  ki
  celsius
  v
  nao
  nai
  i
  e
  i_HCN2
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp349_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp349_celsius + 273.15)) / F * log(ko / ki)
  comp352_o_slow_inf  =  
  (1.0 + -(comp352_r(v, comp352_rA, comp352_rB))) * 
    (comp352_o_inf(v, comp352_Ehalf, comp352_c))
  comp352_o_fast_inf  =  
  comp352_r(v, comp352_rA, comp352_rB) * 
    comp352_o_inf(v, comp352_Ehalf, comp352_c)
  comp352_tau_f  =  
  comp352_tau_fast(v, comp352_tCf, comp352_tDf, comp352_tEf)
  comp352_tau_s  =  
  comp352_tau_slow(v, comp352_tCs, comp352_tDs, comp352_tEs)
  e  =  comp352_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN2  =  
  (comp352_gbar * (comp352_o_slow + comp352_o_fast)) * (v - comp352_e)
  i  =  i_HCN2
}


DERIVATIVE states {
  asgns ()
  comp352_o_slow'  =  
  (comp352_o_slow_inf + -(comp352_o_slow)) / comp352_tau_s
  comp352_o_fast'  =  
  (comp352_o_fast_inf + -(comp352_o_fast)) / comp352_tau_f
}


INITIAL {
  asgns ()
  comp352_o_slow  =  comp352_o_slow_inf
  comp352_o_fast  =  comp352_o_fast_inf
  e  =  comp352_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp352_o_fast = %g\n" , t, v,  comp352_o_fast)
  printf ("NMODL state: t = %g v = %g comp352_o_slow = %g\n" , t, v,  comp352_o_slow)
}
