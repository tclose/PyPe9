

TITLE Golgi_CaLVA


NEURON {
  RANGE comp886_vchold, comp886_vcbase, comp886_vcinc, comp886_vcsteps, comp886_vchdur, comp886_vcbdur, comp971_gbar, comp971_e, comp971_valence, CaLVA_m
  RANGE CaLVA_h
  RANGE i_CaLVA
  RANGE ica2
  RANGE eca2
  USEION ca2 READ ca2i, ca2o WRITE ica2 VALENCE 2
}


PARAMETER {
  comp886_vchdur  =  200.0
  comp971_R  =  8.31342
  comp971_F  =  96485.3
  comp971_k_h_inf  =  5.0
  ca2o  =  2.0
  comp886_vcbdur  =  30.0
  comp971_valence  =  2.0
  comp886_vcinc  =  10.0
  comp971_C_tau_m  =  3.0
  comp971_C_tau_h  =  85.0
  comp971_v0_tau_m2  =  -100.0
  comp971_v0_tau_m1  =  -25.0
  comp971_v0_tau_h2  =  -405.0
  comp971_v0_tau_h1  =  -46.0
  comp886_vcbase  =  -69.0
  comp971_v0_m_inf  =  -50.0
  comp971_gbar  =  0.00025
  comp971_A_tau_m  =  1.0
  comp971_A_tau_h  =  1.0
  comp971_k_tau_m2  =  -15.0
  comp971_k_tau_m1  =  10.0
  comp971_k_tau_h2  =  -50.0
  comp971_k_tau_h1  =  4.0
  comp886_vcsteps  =  8.0
  comp971_shift  =  2.0
  comp971_k_m_inf  =  -7.4
  comp971_v0_h_inf  =  -78.0
  comp886_vchold  =  -71.0
}


STATE {
  CaLVA_h
  CaLVA_m
}


ASSIGNED {
  comp971_e
  CaLVA_m_tau
  comp971_m_inf
  CaLVA_m_inf
  comp971_phi_m
  comp971_phi_h
  comp971_tau_m
  comp971_tau_h
  CaLVA_h_tau
  comp971_h_inf
  CaLVA_h_inf
  celsius
  comp971_ca2o
  comp971_ca2i
  v
  ca2i
  ica2
  eca2
  i_CaLVA
}


PROCEDURE asgns () {
  comp971_h_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp971_shift + -(comp971_v0_h_inf)) / 
                  comp971_k_h_inf))
  comp971_phi_h  =  3.0 ^ ((celsius + -24.0) / 10.0)
  comp971_phi_m  =  5.0 ^ ((celsius + -24.0) / 10.0)
  comp971_m_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp971_shift + -(comp971_v0_m_inf)) / 
                  comp971_k_m_inf))
  comp971_e  =  
  (1000.0 * comp971_R * (celsius + 273.15)) / (2.0 * comp971_F) * 
    log(comp971_ca2o / comp971_ca2i)
  CaLVA_h_inf  =  comp971_h_inf
  comp971_tau_h  =  
  (comp971_C_tau_h + 
        comp971_A_tau_h / 
          (exp((v + comp971_shift + -(comp971_v0_tau_h1)) / 
                            comp971_k_tau_h1) 
              + 
              exp((v + comp971_shift + -(comp971_v0_tau_h2)) / 
                            comp971_k_tau_h2))) 
    / 
    comp971_phi_h
  comp971_tau_m  =  
  (comp971_C_tau_m + 
        comp971_A_tau_m / 
          (exp((v + comp971_shift + -(comp971_v0_tau_m1)) / 
                            comp971_k_tau_m1) 
              + 
              exp((v + comp971_shift + -(comp971_v0_tau_m2)) / 
                            comp971_k_tau_m2))) 
    / 
    comp971_phi_m
  CaLVA_m_inf  =  comp971_m_inf
  CaLVA_h_tau  =  comp971_tau_h
  CaLVA_m_tau  =  comp971_tau_m
  eca2  =  comp971_e
}


BREAKPOINT {
  LOCAL v5282
  SOLVE states METHOD derivimplicit
  v5282  =  CaLVA_m 
i_CaLVA  =  (comp971_gbar * v5282 * v5282 * CaLVA_h) * (v - eca2)
  ica2  =  i_CaLVA
}


DERIVATIVE states {
  comp971_ca2i  =  ca2i
  comp971_ca2o  =  ca2o
  asgns ()
  CaLVA_m'  =  (CaLVA_m_inf + -(CaLVA_m)) / CaLVA_m_tau
  CaLVA_h'  =  (CaLVA_h_inf + -(CaLVA_h)) / CaLVA_h_tau
}


INITIAL {
  comp971_ca2i  =  ca2i
  comp971_ca2o  =  ca2o
  asgns ()
  CaLVA_h  =  comp971_h_inf
  CaLVA_m  =  comp971_m_inf
  eca2  =  comp971_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaLVA_h = %g\n" , t, v,  CaLVA_h)
  printf ("NMODL state: t = %g v = %g CaLVA_m = %g\n" , t, v,  CaLVA_m)
}
