

TITLE Golgi_HCN1


NEURON {
  RANGE comp269_vcbdur, comp269_vchdur, comp269_vcsteps, comp269_vcinc, comp269_vcbase, comp269_vchold, comp19_e, comp19_gbar, comp19_o_slow_plus_o_fast
  RANGE i_HCN1
  RANGE e
  NONSPECIFIC_CURRENT i
}


FUNCTION comp19_o_inf (potential, Ehalf, c) {
  comp19_o_inf  =  1.0 / (1.0 + exp((potential + -(Ehalf)) * c))
}


FUNCTION comp19_r (potential) {
  comp19_r  =  comp19_rA * potential + comp19_rB
}


FUNCTION comp19_tau (potential, t1, t2, t3) {
  comp19_tau  =  exp((t1 * potential + -(t2)) * t3)
}


PARAMETER {
  comp19_tCf  =  0.01371
  comp269_vcinc  =  10.0
  comp19_tCs  =  0.01451
  comp19_tEf  =  2.302585092
  comp269_vchdur  =  30.0
  comp269_vcsteps  =  8.0
  comp19_tEs  =  2.302585092
  comp19_Ehalf  =  -72.49
  comp269_vcbdur  =  100.0
  comp19_rA  =  0.002096
  comp19_rB  =  0.97596
  comp19_tDf  =  -3.368
  comp19_e  =  -20.0
  comp269_vcbase  =  -69.0
  comp19_c  =  0.11305
  comp19_tDs  =  -4.056
  comp269_vchold  =  -71.0
  comp19_gbar  =  5e-05
}


STATE {
  comp19_o_fast
  comp19_o_slow
}


ASSIGNED {
  comp19_o_slow_inf
  comp19_o_fast_inf
  comp19_tau_s
  comp19_tau_f
  comp19_o_slow_plus_o_fast
  celsius
  v
  i
  e
  i_HCN1
}


PROCEDURE asgns () {
  comp19_o_slow_plus_o_fast  =  comp19_o_slow + comp19_o_fast
  comp19_tau_f  =  comp19_tau(v, comp19_tCf, comp19_tDf, comp19_tEf)
  comp19_tau_s  =  comp19_tau(v, comp19_tCs, comp19_tDs, comp19_tEs)
  comp19_o_fast_inf  =  
  comp19_r(v) * comp19_o_inf(v, comp19_Ehalf, comp19_c)
  comp19_o_slow_inf  =  
  (1.0 + -(comp19_r(v))) * (comp19_o_inf(v, comp19_Ehalf, comp19_c))
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN1  =  (comp19_gbar * comp19_o_slow_plus_o_fast) * (v - comp19_e)
  i  =  i_HCN1
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
  printf ("comp19_o_fast = %g\n" ,  comp19_o_fast)
  printf ("comp19_o_slow = %g\n" ,  comp19_o_slow)
}
