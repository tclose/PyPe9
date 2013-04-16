

TITLE Golgi_DeSouza10_HCN1


NEURON {
  RANGE comp317_celsius, comp317_V_t, comp318_c, comp319_vchold, comp319_vcbase, comp319_vcinc, comp319_vcsteps, comp319_vchdur, comp319_vcbdur, comp320_o_slow
  RANGE comp320_o_fast, comp320_gbar, comp320_e
  RANGE i_HCN1
  RANGE e
  RANGE F, R
  NONSPECIFIC_CURRENT i
}


FUNCTION comp320_r (potential) {
  comp320_r  =  comp320_rA * potential + comp320_rB
}


FUNCTION comp320_o_inf (potential, Ehalf, c) {
  comp320_o_inf  =  1.0 / (1.0 + exp((potential + -(Ehalf)) * c))
}


FUNCTION comp320_tau (potential, t1, t2, t3) {
  comp320_tau  =  exp((t1 * potential + -(t2)) * t3)
}


PARAMETER {
  comp319_vcbdur  =  100.0
  comp320_rB  =  0.97596
  comp320_rA  =  0.002096
  comp320_Ehalf  =  -72.49
  comp318_c  =  1.0
  comp319_vcinc  =  10.0
  comp319_vchold  =  -71.0
  comp317_V_t  =  -35.0
  comp319_vcsteps  =  8.0
  comp320_tEs  =  2.302585092
  comp320_tEf  =  2.302585092
  comp320_tDs  =  -4.056
  comp320_gbar  =  5e-05
  comp320_tDf  =  -3.368
  comp320_tCs  =  0.01451
  comp320_tCf  =  0.01371
  comp320_e  =  -20.0
  comp320_c  =  0.11305
  comp317_celsius  =  23.0
  comp319_vcbase  =  -69.0
  R  =  8.31342
  F  =  96485.3
  comp319_vchdur  =  30.0
}


STATE {
  comp320_o_fast
  comp320_o_slow
}


ASSIGNED {
  comp320_o_fast_inf
  comp320_tau_s
  comp320_tau_f
  comp320_o_slow_inf
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
  i_HCN1
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp317_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp317_celsius + 273.15)) / F * log(ko / ki)
  comp320_o_slow_inf  =  
  (1.0 + -(comp320_r(v))) * (comp320_o_inf(v, comp320_Ehalf, comp320_c))
  comp320_tau_f  =  comp320_tau(v, comp320_tCf, comp320_tDf, comp320_tEf)
  comp320_tau_s  =  comp320_tau(v, comp320_tCs, comp320_tDs, comp320_tEs)
  comp320_o_fast_inf  =  
  comp320_r(v) * comp320_o_inf(v, comp320_Ehalf, comp320_c)
  e  =  comp320_e
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  i_HCN1  =  
  (comp320_gbar * (comp320_o_slow + comp320_o_fast)) * (v - comp320_e)
  i  =  i_HCN1
}


DERIVATIVE states {
  asgns ()
  comp320_o_slow'  =  
  (comp320_o_slow_inf + -(comp320_o_slow)) / comp320_tau_s
  comp320_o_fast'  =  
  (comp320_o_fast_inf + -(comp320_o_fast)) / comp320_tau_f
}


INITIAL {
  asgns ()
  comp320_o_slow  =  comp320_o_slow_inf
  comp320_o_fast  =  comp320_o_fast_inf
  e  =  comp320_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp320_o_fast = %g\n" , t, v,  comp320_o_fast)
  printf ("NMODL state: t = %g v = %g comp320_o_slow = %g\n" , t, v,  comp320_o_slow)
}
