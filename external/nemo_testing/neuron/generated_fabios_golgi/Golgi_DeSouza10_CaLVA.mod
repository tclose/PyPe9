

TITLE Golgi_DeSouza10_CaLVA


NEURON {
  RANGE comp296_celsius, comp296_V_t, comp297_c, comp298_vchold, comp298_vcbase, comp298_vcinc, comp298_vcsteps, comp298_vchdur, comp298_vcbdur, comp299_gbar
  RANGE comp299_e, comp299_valence, CaLVA_m, CaLVA_h
  RANGE i_CaLVA
  RANGE ica2
  RANGE eca2
  RANGE F, R
  USEION ca2 READ ca2i, ca2o WRITE ica2 VALENCE 2
}


PARAMETER {
  comp299_k_tau_h2  =  -50.0
  comp299_k_tau_h1  =  4.0
  comp299_valence  =  2.0
  comp299_A_tau_m  =  1.0
  comp299_A_tau_h  =  1.0
  comp298_vcinc  =  10.0
  comp299_v0_tau_m2  =  -100.0
  comp299_v0_tau_m1  =  -25.0
  comp299_v0_h_inf  =  -78.0
  comp298_vcbase  =  -69.0
  comp296_V_t  =  -35.0
  comp299_C_tau_m  =  3.0
  comp299_C_tau_h  =  85.0
  comp299_shift  =  2.0
  comp298_vcsteps  =  8.0
  comp299_k_m_inf  =  -7.4
  comp299_v0_tau_h2  =  -405.0
  comp299_v0_tau_h1  =  -46.0
  comp298_vchdur  =  200.0
  comp298_vcbdur  =  30.0
  comp296_celsius  =  23.0
  comp299_gbar  =  0.00025
  R  =  8.31342
  F  =  96485.3
  comp299_k_tau_m2  =  -15.0
  comp299_k_h_inf  =  5.0
  comp299_k_tau_m1  =  10.0
  comp297_c  =  1.0
  comp299_v0_m_inf  =  -50.0
  comp298_vchold  =  -71.0
}


STATE {
  CaLVA_h
  CaLVA_m
}


ASSIGNED {
  comp299_phi_m
  comp299_phi_h
  comp299_e
  comp299_h_inf
  CaLVA_h_tau
  ek
  CaLVA_m_inf
  comp299_tau_m
  comp299_tau_h
  ena
  CaLVA_h_inf
  comp299_m_inf
  CaLVA_m_tau
  ko
  ki
  comp299_ca2o
  comp299_ca2i
  celsius
  v
  nao
  nai
  ca2o
  ca2i
  ica2
  eca2
  i_CaLVA
}


PROCEDURE asgns () {
  comp299_m_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp299_shift + -(comp299_v0_m_inf)) / 
                  comp299_k_m_inf))
  ena  =  (1000.0 * R * (comp296_celsius + 273.15)) / F * log(nao / nai)
  ek  =  (1000.0 * R * (comp296_celsius + 273.15)) / F * log(ko / ki)
  comp299_h_inf  =  
  1.0 / 
    (1.0 + 
        exp((v + comp299_shift + -(comp299_v0_h_inf)) / 
                  comp299_k_h_inf))
  comp299_e  =  
  (1000.0 * R * (comp296_celsius + 273.15)) / (2.0 * F) * 
    log(comp299_ca2o / comp299_ca2i)
  comp299_phi_h  =  3.0 ^ ((comp296_celsius + -24.0) / 10.0)
  comp299_phi_m  =  5.0 ^ ((comp296_celsius + -24.0) / 10.0)
  CaLVA_h_inf  =  comp299_h_inf
  comp299_tau_h  =  
  (comp299_C_tau_h + 
        comp299_A_tau_h / 
          (exp((v + comp299_shift + -(comp299_v0_tau_h1)) / 
                            comp299_k_tau_h1) 
              + 
              exp((v + comp299_shift + -(comp299_v0_tau_h2)) / 
                            comp299_k_tau_h2))) 
    / 
    comp299_phi_h
  comp299_tau_m  =  
  (comp299_C_tau_m + 
        comp299_A_tau_m / 
          (exp((v + comp299_shift + -(comp299_v0_tau_m1)) / 
                            comp299_k_tau_m1) 
              + 
              exp((v + comp299_shift + -(comp299_v0_tau_m2)) / 
                            comp299_k_tau_m2))) 
    / 
    comp299_phi_m
  CaLVA_m_inf  =  comp299_m_inf
  CaLVA_m_tau  =  comp299_tau_m
  CaLVA_h_tau  =  comp299_tau_h
  eca2  =  comp299_e
}


BREAKPOINT {
  LOCAL x696
  SOLVE states METHOD derivimplicit
  x696  =  CaLVA_m 
i_CaLVA  =  (comp299_gbar * x696 * x696 * CaLVA_h) * (v - comp299_e)
  ica2  =  i_CaLVA
}


DERIVATIVE states {
  comp299_ca2i  =  ca2i
  comp299_ca2o  =  ca2o
  asgns ()
  CaLVA_m'  =  (CaLVA_m_inf + -(CaLVA_m)) / CaLVA_m_tau
  CaLVA_h'  =  (CaLVA_h_inf + -(CaLVA_h)) / CaLVA_h_tau
}


INITIAL {
  comp299_ca2i  =  ca2i
  comp299_ca2o  =  ca2o
  asgns ()
  CaLVA_m  =  comp299_m_inf
  CaLVA_h  =  comp299_h_inf
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaLVA_h = %g\n" , t, v,  CaLVA_h)
  printf ("NMODL state: t = %g v = %g CaLVA_m = %g\n" , t, v,  CaLVA_m)
}
