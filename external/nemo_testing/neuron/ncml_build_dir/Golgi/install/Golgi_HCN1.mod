

TITLE Golgi_HCN1


NEURON {
  RANGE comp1353_vchold, comp1353_vcbase, comp1353_vcinc, comp1353_vcsteps, comp1353_vchdur, comp1353_vcbdur, comp1438_o_slow, comp1438_o_fast, comp1438_gbar, comp1438_e
  RANGE i_HCN1
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION comp1438_r (potential) {
  comp1438_r  =  comp1438_rA * potential + comp1438_rB
}


FUNCTION comp1438_o_inf (potential, Ehalf, c) {
  comp1438_o_inf  =  1.0 / (1.0 + exp((potential + -(Ehalf)) * c))
}


FUNCTION comp1438_tau (potential, t1, t2, t3) {
  comp1438_tau  =  exp((t1 * potential + -(t2)) * t3)
}


PARAMETER {
  comp1438_e  =  -20.0
  comp1438_c  =  0.11305
  comp1353_vcbdur  =  100.0
  comp1438_Ehalf  =  -72.49
  comp1353_vcbase  =  -69.0
  comp1438_rB  =  0.97596
  comp1438_rA  =  0.002096
  ca2o  =  2.0
  comp1438_gbar  =  5e-05
  comp1353_vcsteps  =  8.0
  comp1438_tEs  =  2.302585092
  comp1438_tEf  =  2.302585092
  comp1438_tDs  =  -4.056
  comp1438_tDf  =  -3.368
  comp1438_tCs  =  0.01451
  comp1438_tCf  =  0.01371
  comp1353_vchold  =  -71.0
  comp1353_vchdur  =  30.0
  comp1353_vcinc  =  10.0
}


STATE {
  comp1438_o_slow
  comp1438_o_fast
}


ASSIGNED {
  comp1438_o_fast_inf
  comp1438_tau_s
  comp1438_tau_f
  comp1438_o_slow_inf
  celsius
  v
  i
  e
  i_HCN1
}


PROCEDURE asgns () {
  comp1438_o_slow_inf  =  
  (1.0 + -(comp1438_r(v))) * 
    (comp1438_o_inf(v, comp1438_Ehalf, comp1438_c))
  comp1438_tau_f  =  
  comp1438_tau(v, comp1438_tCf, comp1438_tDf, comp1438_tEf)
  comp1438_tau_s  =  
  comp1438_tau(v, comp1438_tCs, comp1438_tDs, comp1438_tEs)
  comp1438_o_fast_inf  =  
  comp1438_r(v) * comp1438_o_inf(v, comp1438_Ehalf, comp1438_c)
  e  =  comp1438_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN1  =  
  (comp1438_gbar * (comp1438_o_slow + comp1438_o_fast)) * 
    (v - comp1438_e)
  i  =  i_HCN1
}


DERIVATIVE states {
  asgns ()
  comp1438_o_fast'  =  
  (comp1438_o_fast_inf + -(comp1438_o_fast)) / comp1438_tau_f
  comp1438_o_slow'  =  
  (comp1438_o_slow_inf + -(comp1438_o_slow)) / comp1438_tau_s
}


INITIAL {
  asgns ()
  comp1438_o_slow  =  comp1438_o_slow_inf
  comp1438_o_fast  =  comp1438_o_fast_inf
  e  =  comp1438_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp1438_o_fast = %g\n" , t, v,  comp1438_o_fast)
  printf ("NMODL state: t = %g v = %g comp1438_o_slow = %g\n" , t, v,  comp1438_o_slow)
}
