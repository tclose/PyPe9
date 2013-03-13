

TITLE Golgi_HCN2


NEURON {
  RANGE comp1719_vchold, comp1719_vcbase, comp1719_vcinc, comp1719_vcsteps, comp1719_vchdur, comp1719_vcbdur, comp1804_o_slow, comp1804_o_fast, comp1804_gbar, comp1804_e
  RANGE i_HCN2
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION comp1804_tau_fast (potential, t1, t2, t3) {
  comp1804_tau_fast  =  exp(t3 * (t1 * potential + -(t2)))
}


FUNCTION comp1804_tau_slow (potential, t1, t2, t3) {
  comp1804_tau_slow  =  exp(t3 * (t1 * potential + -(t2)))
}


FUNCTION comp1804_o_inf (potential, Ehalf, c) {
  comp1804_o_inf  =  1.0 / (1.0 + exp((potential + -(Ehalf)) * c))
}


FUNCTION comp1804_r (potential, r1, r2) {
  LOCAL v5285, v5286
  if 
    (potential >= -64.7) 
     {v5285  =  0.0} 
    else 
    {if 
          (potential <= -108.7) 
           {v5286  =  1.0} 
          else {v5286  =  r1 * potential + r2} 
      v5285  =  v5286} 
comp1804_r  =  v5285
}


PARAMETER {
  comp1804_tEs  =  2.3026
  comp1804_tEf  =  2.3026
  comp1804_tDs  =  -5.2944
  comp1804_tDf  =  -5.6111
  comp1804_tCs  =  0.0152
  comp1804_tCf  =  0.0269
  comp1719_vchold  =  -71.0
  comp1719_vchdur  =  30.0
  ca2o  =  2.0
  comp1804_Ehalf  =  -81.95
  comp1719_vcbdur  =  100.0
  comp1804_e  =  -20.0
  comp1804_c  =  0.1661
  comp1719_vcbase  =  -69.0
  comp1719_vcinc  =  10.0
  comp1719_vcsteps  =  8.0
  comp1804_rB  =  -1.4694
  comp1804_rA  =  -0.0227
  comp1804_gbar  =  8e-05
}


STATE {
  comp1804_o_slow
  comp1804_o_fast
}


ASSIGNED {
  comp1804_o_fast_inf
  comp1804_tau_s
  comp1804_tau_f
  comp1804_o_slow_inf
  celsius
  v
  i
  e
  i_HCN2
}


PROCEDURE asgns () {
  comp1804_o_slow_inf  =  
  (1.0 + -(comp1804_r(v, comp1804_rA, comp1804_rB))) * 
    (comp1804_o_inf(v, comp1804_Ehalf, comp1804_c))
  comp1804_tau_f  =  
  comp1804_tau_fast(v, comp1804_tCf, comp1804_tDf, comp1804_tEf)
  comp1804_tau_s  =  
  comp1804_tau_slow(v, comp1804_tCs, comp1804_tDs, comp1804_tEs)
  comp1804_o_fast_inf  =  
  comp1804_r(v, comp1804_rA, comp1804_rB) * 
    comp1804_o_inf(v, comp1804_Ehalf, comp1804_c)
  e  =  comp1804_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN2  =  
  (comp1804_gbar * (comp1804_o_slow + comp1804_o_fast)) * 
    (v - comp1804_e)
  i  =  i_HCN2
}


DERIVATIVE states {
  asgns ()
  comp1804_o_fast'  =  
  (comp1804_o_fast_inf + -(comp1804_o_fast)) / comp1804_tau_f
  comp1804_o_slow'  =  
  (comp1804_o_slow_inf + -(comp1804_o_slow)) / comp1804_tau_s
}


INITIAL {
  asgns ()
  comp1804_o_slow  =  comp1804_o_slow_inf
  comp1804_o_fast  =  comp1804_o_fast_inf
  e  =  comp1804_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp1804_o_fast = %g\n" , t, v,  comp1804_o_fast)
  printf ("NMODL state: t = %g v = %g comp1804_o_slow = %g\n" , t, v,  comp1804_o_slow)
}
