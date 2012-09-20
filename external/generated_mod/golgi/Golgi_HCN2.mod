

TITLE Golgi_HCN2


NEURON {
  RANGE comp290_vcbdur, comp290_vchdur, comp290_vcsteps, comp290_vcinc, comp290_vcbase, comp290_vchold, comp19_e, comp19_gbar, comp19_o_fast, comp19_o_slow
  RANGE i_HCN2
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION comp19_tau_fast (potential, t1, t2, t3) {
  comp19_tau_fast  =  exp(t3 * (t1 * potential + -(t2)))
}


FUNCTION comp19_o_inf (potential, Ehalf, c) {
  comp19_o_inf  =  1.0 / (1.0 + exp((potential + -(Ehalf)) * c))
}


FUNCTION comp19_tau_slow (potential, t1, t2, t3) {
  comp19_tau_slow  =  exp(t3 * (t1 * potential + -(t2)))
}


FUNCTION comp19_r (potential, r1, r2) {
  LOCAL v377, v378
  if 
    (potential >= -64.7) 
     {v377  =  0.0} 
    else 
    {if 
          (potential <= -108.7) 
           {v378  =  1.0} 
          else {v378  =  r1 * potential + r2} 
      v377  =  v378} 
comp19_r  =  v377
}


PARAMETER {
  comp290_vchold  =  -71.0
  comp19_gbar  =  8e-05
  comp290_vcbdur  =  100.0
  comp19_rA  =  -0.0227
  comp19_rB  =  -1.4694
  comp19_Ehalf  =  -81.95
  comp290_vchdur  =  30.0
  comp290_vcinc  =  10.0
  comp19_e  =  -20.0
  comp19_c  =  0.1661
  comp290_vcsteps  =  8.0
  comp290_vcbase  =  -69.0
  comp19_tEf  =  2.3026
  comp19_tEs  =  2.3026
  comp19_tDf  =  -5.6111
  comp19_tDs  =  -5.2944
  comp19_tCf  =  0.0269
  comp19_tCs  =  0.0152
}


STATE {
  comp19_o_slow
  comp19_o_fast
}


ASSIGNED {
  comp19_tau_s
  comp19_tau_f
  comp19_o_fast_inf
  comp19_o_slow_inf
  celsius
  v
  i
  e
  i_HCN2
}


PROCEDURE asgns () {
  comp19_o_slow_inf  =  
  (1.0 + -(comp19_r(v, comp19_rA, comp19_rB))) * 
    (comp19_o_inf(v, comp19_Ehalf, comp19_c))
  comp19_o_fast_inf  =  
  comp19_r(v, comp19_rA, comp19_rB) * 
    comp19_o_inf(v, comp19_Ehalf, comp19_c)
  comp19_tau_f  =  comp19_tau_fast(v, comp19_tCf, comp19_tDf, comp19_tEf)
  comp19_tau_s  =  comp19_tau_slow(v, comp19_tCs, comp19_tDs, comp19_tEs)
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN2  =  (comp19_gbar * (comp19_o_slow + comp19_o_fast)) * (v - e)
  i  =  i_HCN2
}


DERIVATIVE states {
  asgns ()
  comp19_o_fast'  =  (comp19_o_fast_inf + -(comp19_o_fast)) / comp19_tau_f
  comp19_o_slow'  =  (comp19_o_slow_inf + -(comp19_o_slow)) / comp19_tau_s
}


INITIAL {
  asgns ()
  comp19_o_slow  =  comp19_o_slow_inf
  comp19_o_fast  =  comp19_o_fast_inf
  e  =  comp19_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp19_o_fast = %g\n" , t, v,  comp19_o_fast)
  printf ("NMODL state: t = %g v = %g comp19_o_slow = %g\n" , t, v,  comp19_o_slow)
}
