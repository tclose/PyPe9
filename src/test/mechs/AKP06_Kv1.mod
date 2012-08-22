

TITLE Kv1


NEURON {
  RANGE Kv1_m, comp0_e_Kv1, comp0_gbar_Kv1
  RANGE i_Kv1
  RANGE ik
  USEION k READ ek WRITE ik
}


FUNCTION comp0_Kv1_amf (v) {
  LOCAL v32, v31, v30
  v32  =  0.12889 v31  =  -33.90877 v30  =  45.0 
comp0_Kv1_amf  =  v32 * exp(-((v + v30) / v31))
}


FUNCTION comp0_Kv1_bmf (v) {
  LOCAL v35, v34, v33
  v35  =  0.12889 v34  =  12.42101 v33  =  45.0 
comp0_Kv1_bmf  =  v35 * exp(-((v + v33) / v34))
}


PARAMETER {
  comp0_gbar_Kv1  =  0.011
  comp0_e_Kv1  =  -85.0
}


STATE {
  Kv1_mC
  Kv1_mO
  Kv1_m
}


ASSIGNED {
  comp0_temp_adj
  v
  celsius
  ik
  ek
  i_Kv1
}


PROCEDURE asgns () {
  comp0_temp_adj  =  3.0 ^ ((celsius + -22.0) / 10.0)
}


PROCEDURE reactions () {
  Kv1_m  =  Kv1_mO
}


BREAKPOINT {
  LOCAL v37
  SOLVE states METHOD cnexp
  reactions ()
  v37  =  Kv1_m 
i_Kv1  =  (comp0_gbar_Kv1 * v37 * v37 * v37 * v37) * (v - ek)
  ik  =  i_Kv1
}


DERIVATIVE states {
  asgns ()
  Kv1_mO'  =  
  -(Kv1_mO * comp0_temp_adj * comp0_Kv1_bmf(v)) + 
    (1 - Kv1_mO) * (comp0_temp_adj * comp0_Kv1_amf(v))
}


INITIAL {
  asgns ()
  Kv1_m  =  (comp0_Kv1_amf(v)) / (comp0_Kv1_amf(v) + comp0_Kv1_bmf(v))
  Kv1_mO  =  Kv1_m
}


PROCEDURE print_state () {
  printf ("Kv1_mO = %g\n" ,  Kv1_mO)
}
