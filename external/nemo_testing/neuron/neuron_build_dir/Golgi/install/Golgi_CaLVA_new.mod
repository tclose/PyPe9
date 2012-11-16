

TITLE Golgi_CaLVA_new


NEURON {
  RANGE comp886_gbar, comp886_e, comp886_valence, CaLVA_m, CaLVA_h
  RANGE i_CaLVA_new
  RANGE ica2
  RANGE eca2
  USEION ca2 READ ca2i, ca2o WRITE ica2 VALENCE 2
}


PARAMETER {
  comp886_shift  =  2.0
  comp886_k_h_inf  =  5.0
  comp886_R  =  8.31342
  comp886_F  =  96485.3
  ca2o  =  2.0
  comp886_valence  =  2.0
  comp886_C_tau_m  =  3.0
  comp886_C_tau_h  =  85.0
  comp886_v0_tau_m2  =  -100.0
  comp886_v0_tau_m1  =  -25.0
  comp886_v0_tau_h2  =  -405.0
  comp886_v0_tau_h1  =  -46.0
  comp886_v0_m_inf  =  -50.0
  comp886_A_tau_m  =  1.0
  comp886_A_tau_h  =  1.0
  comp886_k_tau_m2  =  -15.0
  comp886_k_tau_m1  =  10.0
  comp886_k_tau_h2  =  -50.0
  comp886_k_tau_h1  =  4.0
  comp886_k_m_inf  =  -7.4
  comp886_gbar  =  0.00025
  comp886_v0_h_inf  =  -78.0
}


STATE {
  CaLVA_h
  CaLVA_m
}


ASSIGNED {
  comp886_phi_m
  comp886_phi_h
  comp886_tau_m
  comp886_tau_h
  comp886_e
  CaLVA_m_tau
  comp886_h_inf
  CaLVA_m_inf
  CaLVA_h_tau
  comp886_m_inf
  CaLVA_h_inf
  celsius
  comp886_ca2o
  comp886_ca2i
  v
  ca2i
  ica2
  eca2
  i_CaLVA_new
}


PROCEDURE asgns () {
  comp886_m_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp886_shift + -(comp886_v0_m_inf)) / 
                  comp886_k_m_inf))
  comp886_h_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp886_shift + -(comp886_v0_h_inf)) / 
                  comp886_k_h_inf))
  comp886_e  =  
  (1000.0 * comp886_R * (celsius + 273.15)) / (2.0 * comp886_F) * 
    log(comp886_ca2o / comp886_ca2i)
  comp886_phi_h  =  3.0 ^ ((celsius + -24.0) / 10.0)
  comp886_phi_m  =  5.0 ^ ((celsius + -24.0) / 10.0)
  CaLVA_h_inf  =  comp886_h_inf
  CaLVA_m_inf  =  comp886_m_inf
  comp886_tau_h  =  
  (comp886_C_tau_h + 
        comp886_A_tau_h / 
          (exp((v + comp886_shift + -(comp886_v0_tau_h1)) / 
                            comp886_k_tau_h1) 
              + 
              exp((v + comp886_shift + -(comp886_v0_tau_h2)) / 
                            comp886_k_tau_h2))) 
    / 
    comp886_phi_h
  comp886_tau_m  =  
  (comp886_C_tau_m + 
        comp886_A_tau_m / 
          (exp((v + comp886_shift + -(comp886_v0_tau_m1)) / 
                            comp886_k_tau_m1) 
              + 
              exp((v + comp886_shift + -(comp886_v0_tau_m2)) / 
                            comp886_k_tau_m2))) 
    / 
    comp886_phi_m
  CaLVA_h_tau  =  comp886_tau_h
  CaLVA_m_tau  =  comp886_tau_m
  eca2  =  comp886_e
}


BREAKPOINT {
  LOCAL v5310
  SOLVE states METHOD derivimplicit
  v5310  =  CaLVA_m 
i_CaLVA_new  =  (comp886_gbar * v5310 * v5310 * CaLVA_h) * (v - eca2)
  ica2  =  i_CaLVA_new
}


DERIVATIVE states {
  comp886_ca2i  =  ca2i
  comp886_ca2o  =  ca2o
  asgns ()
  CaLVA_m'  =  (CaLVA_m_inf + -(CaLVA_m)) / CaLVA_m_tau
  CaLVA_h'  =  (CaLVA_h_inf + -(CaLVA_h)) / CaLVA_h_tau
}


INITIAL {
  comp886_ca2i  =  ca2i
  comp886_ca2o  =  ca2o
  asgns ()
  CaLVA_h  =  comp886_h_inf
  CaLVA_m  =  comp886_m_inf
  eca2  =  comp886_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaLVA_h = %g\n" , t, v,  CaLVA_h)
  printf ("NMODL state: t = %g v = %g CaLVA_m = %g\n" , t, v,  CaLVA_m)
}
