

TITLE Kv4


NEURON {
  RANGE Kv4_h, Kv4_m, comp0_e_Kv4, comp0_gbar_Kv4
  RANGE i_Kv4
  RANGE ik
  USEION k READ ek WRITE ik
}


FUNCTION comp0_Kv4_bmf (v) {
  LOCAL v56, v55, v54
  v56  =  0.15743 v55  =  37.51346 v54  =  57.0 
comp0_Kv4_bmf  =  v56 * exp(-((v + v54) / v55))
}


FUNCTION comp0_Kv4_ahf (v) {
  LOCAL v59, v58, v57
  v59  =  0.01342 v58  =  -7.86476 v57  =  60.0 
comp0_Kv4_ahf  =  v59 / (1.0 + exp(-((v + v57) / v58)))
}


FUNCTION comp0_Kv4_bhf (v) {
  LOCAL v62, v61, v60
  v62  =  0.04477 v61  =  11.3615 v60  =  54.0 
comp0_Kv4_bhf  =  v62 / (1.0 + exp(-((v + v60) / v61)))
}


FUNCTION comp0_Kv4_amf (v) {
  LOCAL v65, v64, v63
  v65  =  0.15743 v64  =  -32.19976 v63  =  57.0 
comp0_Kv4_amf  =  v65 * exp(-((v + v63) / v64))
}


PARAMETER {
  comp0_gbar_Kv4  =  0.0039
  comp0_e_Kv4  =  -85.0
}


STATE {
  Kv4_hC
  Kv4_hO
  Kv4_mC
  Kv4_mO
  Kv4_h
  Kv4_m
}


ASSIGNED {
  comp0_temp_adj
  ica
  cai
  v
  celsius
  ik
  ek
  i_Kv4
}


PROCEDURE asgns () {
  comp0_temp_adj  =  3.0 ^ ((celsius + -22.0) / 10.0)
}


PROCEDURE reactions () {
  Kv4_h  =  Kv4_hO
  Kv4_m  =  Kv4_mO
}


BREAKPOINT {
  LOCAL v67
  SOLVE states METHOD cnexp
  reactions ()
  v67  =  Kv4_m 
i_Kv4  =  (comp0_gbar_Kv4 * v67 * v67 * v67 * v67 * Kv4_h) * (v - ek)
  ik  =  i_Kv4
}


DERIVATIVE states {
  asgns ()
  Kv4_mO'  =  
  -(Kv4_mO * comp0_temp_adj * comp0_Kv4_bmf(v)) + 
    (1 - Kv4_mO) * (comp0_temp_adj * comp0_Kv4_amf(v))
  Kv4_hO'  =  
  -(Kv4_hO * comp0_temp_adj * comp0_Kv4_bhf(v)) + 
    (1 - Kv4_hO) * (comp0_temp_adj * comp0_Kv4_ahf(v))
}


INITIAL {
  asgns ()
  Kv4_h  =  (comp0_Kv4_ahf(v)) / (comp0_Kv4_ahf(v) + comp0_Kv4_bhf(v))
  Kv4_hO  =  Kv4_h
  Kv4_m  =  (comp0_Kv4_amf(v)) / (comp0_Kv4_amf(v) + comp0_Kv4_bmf(v))
  Kv4_mO  =  Kv4_m
}


PROCEDURE print_state () {
  printf ("Kv4_hO = %g\n" ,  Kv4_hO)
  printf ("Kv4_mO = %g\n" ,  Kv4_mO)
}
