

TITLE CaP


NEURON {
  RANGE CaP_m, comp30_pca
  RANGE i_CaP
  RANGE ica
  USEION ca READ cai, cao WRITE ica
}


FUNCTION comp30_CaP_inf (v) {
  LOCAL v52, v51
  v52  =  19.0 v51  =  5.5 
comp30_CaP_inf  =  1.0 / (1.0 + exp(-((v + v52) / v51)))
}


FUNCTION ghk (v, celsius, ci, co) {
  LOCAL v74, v71, v70, v72, v73, v66, v60, v59, v58, v57, v56
  v60  =  96485.0 
  v59  =  8.3145 v58  =  celsius + 273.19 v57  =  2.0 v56  =  0.001 * v 
v66  =  (v57 * v60 * v56) / (v59 * v58) 
  v72  =  v57 v73  =  v60 
    v71  =  exp(-(v66)) 
        v70  =  (v72 * v72 * v56 * v73 * v73) / (v59 * v58) 
      if 
            (fabs(1.0 + -(v71)) < 1e-06) 
             
            {v74  =  
                ((v57 * v60) * (ci + -(co * v71))) * (1.0 + -(v66))} 
            else {v74  =  (v70 * (ci + -(co * v71))) / (1.0 + -(v71))} 
        ghk  =  1e-06 * v74
}


FUNCTION comp30_CaP_tau (v) {
  LOCAL v77, v78
  if 
    (v > -50.0) 
     
    {v78  =  exp(-((v + 41.9) / 27.8)) 
      v77  =  0.000191 + 0.00376 * v78 * v78} 
    else {v77  =  0.00026367 + 0.1278 * exp(0.10327 * v)} 
comp30_CaP_tau  =  v77
}


PARAMETER {
  comp30_pcabar  =  6e-05
}


STATE {
  CaP_m
}


ASSIGNED {
  comp30_temp_adj
  comp30_pca
  CaP_m_inf
  CaP_m_tau
  ica
  cao
  cai
  v
  celsius
  eca
  i_CaP
}


PROCEDURE asgns () {
  CaP_m_inf  =  comp30_CaP_inf(v)
  comp30_pca  =  1000.0 * comp30_pcabar * ghk(v, celsius, cai, cao)
  comp30_temp_adj  =  3.0 ^ ((celsius + -22.0) / 10.0)
  CaP_m_tau  =  (1000.0 * comp30_CaP_tau(v)) / comp30_temp_adj
}


BREAKPOINT {
  SOLVE states METHOD cnexp
  i_CaP  =  comp30_pca * CaP_m
  ica  =  i_CaP
}


DERIVATIVE states {
  asgns ()
  CaP_m'  =  (CaP_m_inf + -(CaP_m)) / CaP_m_tau
}


INITIAL {
  asgns ()
  CaP_m  =  comp30_CaP_inf(v)
}


PROCEDURE print_state () {
  printf ("CaP_m = %g\n" ,  CaP_m)
}
