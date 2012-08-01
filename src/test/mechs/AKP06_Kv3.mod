

TITLE Kv3


NEURON {
  RANGE Kv3_m, comp0_i_gate_Kv3, comp0_e_Kv3, comp0_gbar_Kv3
  RANGE i_Kv3, i_comp28
  RANGE e
  NONSPECIFIC_CURRENT i
  RANGE ik
  USEION k READ ek WRITE ik
}


FUNCTION comp0_gate_flip_Kv3 (v, m) {
  LOCAL v51, v50, v49, v48
  v51  =  comp0_Kv3_amf(v) 
  v50  =  v51 + comp0_Kv3_bmf(v) v49  =  1.0 / v50 v48  =  v51 / v50 
comp0_gate_flip_Kv3  =  (v48 + -(m)) / v49
}


FUNCTION comp0_Kv3_amf (v) {
  LOCAL v54, v53, v52
  v54  =  0.22 v53  =  16.0 v52  =  -26.5 
comp0_Kv3_amf  =  v54 * exp(-(v + v53) / v52)
}


FUNCTION comp0_Kv3_bmf (v) {
  LOCAL v57, v56, v55
  v57  =  0.22 v56  =  16.0 v55  =  26.5 
comp0_Kv3_bmf  =  v57 * exp(-(v + v56) / v55)
}


PARAMETER {
  comp0_gbar_Kv3  =  0.005
  comp0_zn  =  1.9196
  comp0_e0  =  1.60217646e-19
  comp0_gunit  =  16.0
  comp0_switch_Kv3  =  0.0
  comp0_e_Kv3  =  -85.0
  comp0_nc  =  312500000.0
}


STATE {
  Kv3_mC
  Kv3_mO
  Kv3_m
}


ASSIGNED {
  comp0_temp_adj
  comp0_i_gate_Kv3
  v
  celsius
  i
  ik
  e
  ek
  i_Kv3
  i_comp28
}


PROCEDURE asgns () {
  LOCAL v45
  if 
    (comp0_switch_Kv3 > 0.0) 
     
    {v45  =  
        comp0_nc * 1000000.0 * comp0_e0 * 4.0 * comp0_zn * 
          comp0_gate_flip_Kv3(v, Kv3_m)} 
    else {v45  =  0.0} 
comp0_i_gate_Kv3  =  v45
  comp0_temp_adj  =  3.0 ^ ((celsius + -22.0) / 10.0)
}


PROCEDURE reactions () {
  Kv3_m  =  Kv3_mO
}


BREAKPOINT {
  LOCAL v59
  SOLVE states METHOD cnexp
  reactions ()
  i_comp28  =  comp0_i_gate_Kv3
  i  =  i_comp28
  v59  =  Kv3_m 
i_Kv3  =  (comp0_gbar_Kv3 * v59 * v59 * v59 * v59) * (v - ek)
  ik  =  i_Kv3
}


DERIVATIVE states {
  asgns ()
  Kv3_mO'  =  
  -(Kv3_mO * comp0_temp_adj * comp0_Kv3_bmf(v)) + 
    (1 - Kv3_mO) * (comp0_temp_adj * comp0_Kv3_amf(v))
}


INITIAL {
  asgns ()
  Kv3_m  =  (comp0_Kv3_amf(v)) / (comp0_Kv3_amf(v) + comp0_Kv3_bmf(v))
  Kv3_mO  =  Kv3_m
}


PROCEDURE print_state () {
  printf ("Kv3_mO = %g\n" ,  Kv3_mO)
}
