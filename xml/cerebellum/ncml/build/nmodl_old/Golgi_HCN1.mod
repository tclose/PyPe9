

TITLE Golgi_HCN1


NEURON {
  RANGE comp270_vcbdur, comp270_vchdur, comp270_vcsteps, comp270_vcinc, comp270_vcbase, comp270_vchold, comp19_e, comp19_gbar, comp19_o_fast, comp19_o_slow
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
  comp270_vchdur  =  30.0
  comp19_gbar  =  5e-05
  comp270_vcbdur  =  100.0
  comp19_rA  =  0.002096
  comp19_rB  =  0.97596
  comp19_Ehalf  =  -72.49
  comp270_vchold  =  -71.0
  comp19_e  =  -20.0
  comp19_c  =  0.11305
  comp270_vcsteps  =  8.0
  comp270_vcinc  =  10.0
  comp19_tEf  =  2.302585092
  comp19_tEs  =  2.302585092
  comp19_tDf  =  -3.368
  comp19_tDs  =  -4.056
  comp19_tCf  =  0.01371
  comp19_tCs  =  0.01451
  comp270_vcbase  =  -69.0
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
  i_HCN1
}


PROCEDURE asgns () {
  comp19_o_slow_inf  =  
  (1.0 + -(comp19_r(v))) * (comp19_o_inf(v, comp19_Ehalf, comp19_c))
  comp19_o_fast_inf  =  
  comp19_r(v) * comp19_o_inf(v, comp19_Ehalf, comp19_c)
  comp19_tau_f  =  comp19_tau(v, comp19_tCf, comp19_tDf, comp19_tEf)
  comp19_tau_s  =  comp19_tau(v, comp19_tCs, comp19_tDs, comp19_tEs)
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN1  =  (comp19_gbar * (comp19_o_slow + comp19_o_fast)) * (v - e)
  i  =  i_HCN1
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
