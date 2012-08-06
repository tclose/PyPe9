

TITLE Golgi_CaLVA


NEURON {
  RANGE CaLVA_h, CaLVA_m, comp303_vcbdur, comp303_vchdur, comp303_vcsteps, comp303_vcinc, comp303_vcbase, comp303_vchold, comp19_e, comp19_gbar
  RANGE i_CaLVA
  RANGE ica2
  USEION ca2 READ eca2, ca2i, ca2o WRITE ica2
}


PARAMETER {
  comp19_R  =  8.3145
  comp303_vchold  =  -71.0
  comp19_k_m_inf  =  -7.4
  comp303_vcinc  =  10.0
  comp19_k_tau_h2  =  -50.0
  comp19_k_tau_h1  =  4.0
  comp19_v0_tau_h2  =  -405.0
  comp19_v0_tau_h1  =  -46.0
  comp303_vcsteps  =  8.0
  comp303_vcbdur  =  30.0
  comp19_C_tau_m  =  3.0
  comp19_C_tau_h  =  85.0
  comp19_k_tau_m2  =  -15.0
  comp19_k_tau_m1  =  10.0
  comp303_vcbase  =  -69.0
  comp19_v0_tau_m1  =  -25.0
  comp19_v0_tau_m2  =  -100.0
  comp19_F  =  96485.0
  comp19_v0_h_inf  =  -78.0
  comp19_k_h_inf  =  5.0
  comp19_shift  =  2.0
  comp19_gbar  =  0.00025
  comp19_A_tau_m  =  1.0
  comp19_v0_m_inf  =  -50.0
  comp19_A_tau_h  =  1.0
  comp303_vchdur  =  200.0
}


STATE {
  CaLVA_h
  CaLVA_m
}


ASSIGNED {
  comp19_h_inf
  comp19_e
  comp19_phi_m
  comp19_phi_h
  CaLVA_h_tau
  CaLVA_m_inf
  CaLVA_h_inf
  CaLVA_m_tau
  comp19_m_inf
  comp19_tau_m
  comp19_tau_h
  ica2
  celsius
  ca2o
  v
  ca2i
  eca2
  i_CaLVA
}


PROCEDURE asgns () {
  comp19_m_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp19_shift + -(comp19_v0_m_inf)) / comp19_k_m_inf))
  comp19_phi_h  =  3.0 ^ ((celsius + -24.0) / 10.0)
  comp19_phi_m  =  5.0 ^ ((celsius + -24.0) / 10.0)
  comp19_e  =  
  (1000.0 * comp19_R * (celsius + 273.15)) / (2.0 * comp19_F) * 
    log10(ca2o / ca2i)
  comp19_h_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp19_shift + -(comp19_v0_h_inf)) / comp19_k_h_inf))
  comp19_tau_h  =  
  (comp19_C_tau_h + 
        comp19_A_tau_h / 
          (exp((v + comp19_shift + -(comp19_v0_tau_h1)) / 
                            comp19_k_tau_h1) 
              + 
              exp((v + comp19_shift + -(comp19_v0_tau_h2)) / 
                            comp19_k_tau_h2))) 
    / 
    comp19_phi_h
  comp19_tau_m  =  
  (comp19_C_tau_m + 
        comp19_A_tau_m / 
          (exp((v + comp19_shift + -(comp19_v0_tau_m1)) / 
                            comp19_k_tau_m1) 
              + 
              exp((v + comp19_shift + -(comp19_v0_tau_m2)) / 
                            comp19_k_tau_m2))) 
    / 
    comp19_phi_m
  CaLVA_h_inf  =  comp19_h_inf
  CaLVA_m_inf  =  comp19_m_inf
  CaLVA_m_tau  =  comp19_tau_m
  CaLVA_h_tau  =  comp19_tau_h
}


BREAKPOINT {
  LOCAL v445
  SOLVE states METHOD derivimplicit
  v445  =  CaLVA_m 
i_CaLVA  =  (comp19_gbar * v445 * v445 * CaLVA_h) * (v - comp19_e)
  ica2  =  i_CaLVA
}


DERIVATIVE states {
  asgns ()
  CaLVA_m'  =  (CaLVA_m_inf + -(CaLVA_m)) / CaLVA_m_tau
  CaLVA_h'  =  (CaLVA_h_inf + -(CaLVA_h)) / CaLVA_h_tau
}


INITIAL {
  asgns ()
  CaLVA_h  =  comp19_h_inf
  CaLVA_m  =  comp19_m_inf
}


PROCEDURE print_state () {
  printf ("CaLVA_h = %g\n" ,  CaLVA_h)
  printf ("CaLVA_m = %g\n" ,  CaLVA_m)
}
