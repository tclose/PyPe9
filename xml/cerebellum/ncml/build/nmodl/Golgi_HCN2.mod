

TITLE Golgi_HCN2


NEURON {
  RANGE comp289_vcbdur, comp289_vchdur, comp289_vcsteps, comp289_vcinc, comp289_vcbase, comp289_vchold, comp19_e, comp19_gbar, comp19_o_slow_plus_fast
  RANGE i_HCN2
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION comp19_o_inf (potential, Ehalf, c) {
  comp19_o_inf  =  1.0 / (1.0 + exp((potential + -(Ehalf)) * c))
}


FUNCTION comp19_r (potential, r1, r2) {
  LOCAL v376, v377
  if 
    (potential >= -64.7) 
     {v376  =  0.0} 
    else 
    {if 
          (potential <= -108.7) 
           {v377  =  1.0} 
          else {v377  =  r1 * potential + r2} 
      v376  =  v377} 
comp19_r  =  v376
}


FUNCTION comp19_tau_fast (potential, t1, t2, t3) {
  comp19_tau_fast  =  exp(t3 * (t1 * potential + -(t2)))
}


FUNCTION comp19_tau_slow (potential, t1, t2, t3) {
  comp19_tau_slow  =  exp(t3 * (t1 * potential + -(t2)))
}


PARAMETER {
  comp289_vcbdur  =  100.0
  comp19_rA  =  -0.0227
  comp19_rB  =  -1.4694
  comp19_tEf  =  2.3026
  comp289_vcbase  =  -69.0
  comp289_vcsteps  =  8.0
  comp19_tDf  =  -5.6111
  comp19_tCf  =  0.0269
  comp19_tEs  =  2.3026
  comp19_c  =  0.1661
  comp19_e  =  -20.0
  comp19_tDs  =  -5.2944
  comp289_vchold  =  -71.0
  comp19_gbar  =  8e-05
  comp19_Ehalf  =  -81.95
  comp289_vcinc  =  10.0
  comp289_vchdur  =  30.0
  comp19_tCs  =  0.0152
}


STATE {
  comp19_o_fast
  comp19_o_slow
}


ASSIGNED {
  comp19_o_slow_plus_fast
  comp19_o_slow_inf
  comp19_tau_f
  comp19_tau_s
  comp19_o_fast_inf
  v
  celsius
  i
  e
  i_HCN2
}


PROCEDURE asgns () {
  comp19_o_fast_inf  =  
  comp19_r(v, comp19_rA, comp19_rB) * 
    comp19_o_inf(v, comp19_Ehalf, comp19_c)
  comp19_tau_s  =  comp19_tau_slow(v, comp19_tCs, comp19_tDs, comp19_tEs)
  comp19_tau_f  =  comp19_tau_fast(v, comp19_tCf, comp19_tDf, comp19_tEf)
  comp19_o_slow_inf  =  
  (1.0 + -(comp19_r(v, comp19_rA, comp19_rB))) * 
    (comp19_o_inf(v, comp19_Ehalf, comp19_c))
  comp19_o_slow_plus_fast  =  comp19_o_slow + comp19_o_fast
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN2  =  (comp19_gbar * comp19_o_slow_plus_fast) * (v - comp19_e)
  i  =  i_HCN2
  print_state()
}


DERIVATIVE states {
  asgns ()
  comp19_o_slow'  =  (comp19_o_slow_inf + -(comp19_o_slow)) / comp19_tau_s
  comp19_o_fast'  =  (comp19_o_fast_inf + -(comp19_o_fast)) / comp19_tau_f
}


INITIAL {
  asgns ()
  comp19_o_fast  =  comp19_o_fast_inf
  comp19_o_slow  =  comp19_o_slow_inf
  print_state()
}


PROCEDURE print_state () {
  printf ("%g HCN2_comp19_o_fast %g\n", t  comp19_o_fast)
  printf ("%g HCN2_comp19_o_slow %g\n", t  comp19_o_slow)
}
