

TITLE CaBK


NEURON {
  RANGE CaBK_h, CaBK_m, comp0_e_CaBK, comp0_gbar_CaBK, comp0_CaBK_z
  RANGE i_CaBK
  RANGE ik
  USEION k READ ek WRITE ik
  RANGE temp_adj
}


FUNCTION comp0_CaBK_minf (v) {
  LOCAL v60, v59
  v60  =  28.9 v59  =  6.2 
comp0_CaBK_minf  =  1.0 / (1.0 + exp(-((v + 5.0 + v60) / v59)))
}


FUNCTION comp0_CaBK_hinf (v) {
  LOCAL v63, v62, v61
  v63  =  0.085 v62  =  32.0 v61  =  -5.8 
comp0_CaBK_hinf  =  
    v63 + (1.0 + -(v63)) / (1.0 + exp(-((v + 5.0 + v62) / v61)))
}


FUNCTION comp0_CaBK_zinf (ca) {
  LOCAL v64
  v64  =  0.001 comp0_CaBK_zinf  =  1.0 / (1.0 + v64 / ca)
}


FUNCTION comp0_CaBK_mtau (v) {
  LOCAL v69, v68, v67, v66, v65
  v69  =  0.000505 v68  =  86.4 v67  =  -10.1 v66  =  -33.3 v65  =  10.0 
comp0_CaBK_mtau  =  
    v69 + 
        1.0 / 
          (exp(-((v + 5.0 + v68) / v67)) + 
              exp(-((v + 5.0 + v66) / v65)))
}


FUNCTION comp0_CaBK_htau (v) {
  LOCAL v74, v73, v72, v71, v70
  v74  =  0.0019 v73  =  48.5 v72  =  -5.2 v71  =  -54.2 v70  =  12.9 
comp0_CaBK_htau  =  
    v74 + 1.0 / (exp(-((v + v73) / v72)) + exp(-((v + v71) / v70)))
}


PARAMETER {
  temp_adj  =  1.24573093961552
  comp0_gbar_CaBK  =  0.014
  comp0_e_CaBK  =  -85.0
  comp0_CaBK_ztau  =  1.0
}


STATE {
  CaBK_h
  CaBK_m
  comp0_CaBK_zC
  comp0_CaBK_zO
  comp0_CaBK_z
}


ASSIGNED {
  CaBK_m_tau
  CaBK_h_inf
  CaBK_h_tau
  CaBK_m_inf
  cai
  v
  ik
  ek
  i_CaBK
}


PROCEDURE asgns () {
  CaBK_m_inf  =  comp0_CaBK_minf(v) / temp_adj
  CaBK_h_tau  =  comp0_CaBK_htau(v) / temp_adj
  CaBK_h_inf  =  comp0_CaBK_hinf(v) / temp_adj
  CaBK_m_tau  =  comp0_CaBK_mtau(v) / temp_adj
}


PROCEDURE reactions () {
  comp0_CaBK_z  =  comp0_CaBK_zO
}


BREAKPOINT {
  LOCAL v76
  SOLVE states METHOD cnexp
  reactions ()
  v76  =  comp0_CaBK_z 
i_CaBK  =  (comp0_gbar_CaBK * v76 * v76 * CaBK_m * CaBK_h) * (v - ek)
  ik  =  i_CaBK
}


DERIVATIVE states {
  asgns ()
  CaBK_m'  =  (CaBK_m_inf + -(CaBK_m)) / CaBK_m_tau
  CaBK_h'  =  (CaBK_h_inf + -(CaBK_h)) / CaBK_h_tau
  comp0_CaBK_zO'  =  
  -(comp0_CaBK_zO * (1.0 + -(comp0_CaBK_zinf(cai))) / comp0_CaBK_ztau) + 
    comp0_CaBK_zC * comp0_CaBK_zinf(cai) / comp0_CaBK_ztau
  comp0_CaBK_zC'  =  
  -(comp0_CaBK_zC * comp0_CaBK_zinf(cai) / comp0_CaBK_ztau) + 
    comp0_CaBK_zO * (1.0 + -(comp0_CaBK_zinf(cai))) / comp0_CaBK_ztau
}


INITIAL {
  asgns ()
  comp0_CaBK_z  =  0.0909090909090909
  comp0_CaBK_zO  =  comp0_CaBK_z
  CaBK_h  =  comp0_CaBK_hinf(v) / temp_adj
  CaBK_m  =  comp0_CaBK_minf(v) / temp_adj
}


PROCEDURE print_state () {
  printf ("CaBK_h = %g\n" ,  CaBK_h)
  printf ("CaBK_m = %g\n" ,  CaBK_m)
  printf ("comp0_CaBK_zC = %g\n" ,  comp0_CaBK_zC)
  printf ("comp0_CaBK_zO = %g\n" ,  comp0_CaBK_zO)
}
