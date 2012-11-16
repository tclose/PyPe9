

TITLE Granule


NEURON {
  RANGE comp219_ca, comp304_gbar, comp304_e, comp580_vchold, comp580_vcbase, comp580_vcinc, comp580_vcsteps, comp580_vchdur, comp580_vcbdur, comp665_gbar
  RANGE comp665_e, comp1006_vchold, comp1006_vcbase, comp1006_vcinc, comp1006_vcsteps, comp1006_vchdur, comp1006_vcbdur, comp1091_gbar, comp1091_e, comp1248_vchold
  RANGE comp1248_vcbase, comp1248_vcinc, comp1248_vcsteps, comp1248_vchdur, comp1248_vcbdur, comp1333_gbar, comp1333_e, comp1487_vchold, comp1487_vcbase, comp1487_vcinc
  RANGE comp1487_vcsteps, comp1487_vchdur, comp1487_vcbdur, comp1572_gbar, comp1572_e, comp1754_vchold, comp1754_vcbase, comp1754_vcinc, comp1754_vcsteps, comp1754_vchdur
  RANGE comp1754_vcbdur, comp1839_gbar, comp1839_e, comp1996_vchold, comp1996_vcbase, comp1996_vcinc, comp1996_vcsteps, comp1996_vchdur, comp1996_vcbdur, comp2081_gbar
  RANGE comp2081_e, comp2112_ggaba, comp2112_egaba, comp2143_Na_z, comp2143_gbar, comp2143_e, comp2481_vchold, comp2481_vcbase, comp2481_vcinc, comp2481_vcsteps
  RANGE comp2481_vchdur, comp2481_vcbdur, CaHVA_m, CaHVA_h, KA_m, KA_h, KCa_m, Kir_m, KM_m, KV_m
  RANGE i_Na, i_Lkg2, i_Lkg1, i_KV, i_KA, i_KM, i_CaHVA, i_Kir, i_KCa
  RANGE ik
  RANGE ek
  RANGE ica
  RANGE eca
  RANGE e
  RANGE ina
  RANGE ena
  RANGE ica, cai
  RANGE cai
  USEION na READ ena WRITE ina
  NONSPECIFIC_CURRENT i
  USEION ca READ cai, ica WRITE cai, ica
  USEION k READ ek WRITE ik
}


FUNCTION comp2143_alfa (v, Q10) {
  comp2143_alfa  =  Q10 * comp2143_Aalfa * exp(v / comp2143_Valfa)
}


FUNCTION comp304_alpha_u (v, Q10) {
  comp304_alpha_u  =  
  Q10 * comp304_Aalpha_u * 
    exp((v + -(comp304_V0alpha_u)) / comp304_Kalpha_u)
}


FUNCTION comp304_alpha_s (v, Q10) {
  comp304_alpha_s  =  
  Q10 * comp304_Aalpha_s * 
    exp((v + -(comp304_V0alpha_s)) / comp304_Kalpha_s)
}


FUNCTION comp1572_alpha_n (v, Q10) {
  comp1572_alpha_n  =  
  Q10 * comp1572_Aalpha_n * 
    exp((v + -(comp1572_V0alpha_n)) / comp1572_Kalpha_n)
}


FUNCTION comp1839_alpha_n (v, Q10) {
  comp1839_alpha_n  =  
  Q10 * comp1839_Aalpha_n * 
    linoid(v + -(comp1839_V0alpha_n), comp1839_Kalpha_n)
}


FUNCTION comp1333_alpha_d (v, Q10) {
  comp1333_alpha_d  =  
  Q10 * comp1333_Aalpha_d * 
    exp((v + -(comp1333_V0alpha_d)) / comp1333_Kalpha_d)
}


FUNCTION comp1091_alpha_c (v, cai, Q10) {
  comp1091_alpha_c  =  
  (Q10 * comp1091_Aalpha_c) / 
    (1.0 + (comp1091_Balpha_c * exp(v / comp1091_Kalpha_c)) / cai)
}


FUNCTION comp665_alpha_b (v, Q10) {
  comp665_alpha_b  =  
  Q10 * comp665_Aalpha_b * 
    sigm(v + -(comp665_V0alpha_b), comp665_Kalpha_b)
}


FUNCTION comp665_alpha_a (v, Q10) {
  comp665_alpha_a  =  
  Q10 * comp665_Aalpha_a * 
    sigm(v + -(comp665_V0alpha_a), comp665_Kalpha_a)
}


FUNCTION comp1333_beta_d (v, Q10) {
  comp1333_beta_d  =  
  Q10 * comp1333_Abeta_d * 
    exp((v + -(comp1333_V0beta_d)) / comp1333_Kbeta_d)
}


FUNCTION comp2143_teta (v, Q10) {
  comp2143_teta  =  Q10 * comp2143_Ateta * exp(-(v) / comp2143_Vteta)
}


FUNCTION comp1572_beta_n (v, Q10) {
  comp1572_beta_n  =  
  Q10 * comp1572_Abeta_n * 
    exp((v + -(comp1572_V0beta_n)) / comp1572_Kbeta_n)
}


FUNCTION comp1839_beta_n (v, Q10) {
  comp1839_beta_n  =  
  Q10 * comp1839_Abeta_n * 
    exp((v + -(comp1839_V0beta_n)) / comp1839_Kbeta_n)
}


FUNCTION comp1091_beta_c (v, cai, Q10) {
  comp1091_beta_c  =  
  (Q10 * comp1091_Abeta_c) / 
    (1.0 + cai / (comp1091_Bbeta_c * exp(v / comp1091_Kbeta_c)))
}


FUNCTION comp665_beta_b (v, Q10) {
  comp665_beta_b  =  
  Q10 * comp665_Abeta_b * sigm(v + -(comp665_V0beta_b), comp665_Kbeta_b)
}


FUNCTION comp665_beta_a (v, Q10) {
  comp665_beta_a  =  
  Q10 * 
    comp665_Abeta_a / exp((v + -(comp665_V0beta_a)) / comp665_Kbeta_a)
}


FUNCTION comp304_beta_u (v, Q10) {
  comp304_beta_u  =  
  Q10 * comp304_Abeta_u * 
    exp((v + -(comp304_V0beta_u)) / comp304_Kbeta_u)
}


FUNCTION comp304_beta_s (v, Q10) {
  comp304_beta_s  =  
  Q10 * comp304_Abeta_s * 
    exp((v + -(comp304_V0beta_s)) / comp304_Kbeta_s)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v2866
  if 
    (fabs(x / y) < 1e-06) 
     {v2866  =  y * (1.0 + -(x / y / 2.0))} 
    else {v2866  =  x / (exp(x / y) + -1.0)} 
linoid  =  v2866
}


FUNCTION comp2143_beta (v, Q10) {
  comp2143_beta  =  Q10 * comp2143_Abeta * exp(-(v) / comp2143_Vbeta)
}


PARAMETER {
  comp2143_ACoff  =  0.5
  comp304_Kalpha_u  =  -18.183
  comp304_Kalpha_s  =  15.87301587302
  comp1572_Kalpha_n  =  40.0
  comp1839_Kalpha_n  =  -10.0
  comp1333_Kalpha_d  =  -24.3902
  comp1091_Kalpha_c  =  -11.765
  comp665_Kalpha_b  =  12.8433
  comp665_Kalpha_a  =  -23.32708
  comp2143_Ateta  =  0.0201
  comp665_gbar  =  0.0032
  comp2143_AOon  =  0.75
  comp1006_vchdur  =  30.0
  comp1996_vchdur  =  30.0
  comp1091_e  =  -84.69
  comp2481_vchold  =  -71.0
  comp304_V0beta_u  =  -48.0
  comp304_V0beta_s  =  -18.66
  comp1572_V0beta_n  =  -30.0
  comp1839_V0beta_n  =  -35.0
  comp1333_V0beta_d  =  -83.94
  comp665_V0beta_b  =  -49.9537
  comp665_V0beta_a  =  -18.27914
  comp219_beta  =  1.5
  comp1572_V0_ninf  =  -35.0
  comp304_gbar  =  0.00046
  comp1487_vcbdur  =  100.0
  comp304_Kbeta_u  =  83.33
  comp304_Kbeta_s  =  -25.641
  comp1572_Kbeta_n  =  -20.0
  comp1839_Kbeta_n  =  -80.0
  comp1333_Kbeta_d  =  35.714
  comp1091_Kbeta_c  =  -11.765
  comp665_Kbeta_b  =  -8.90123
  comp665_Kbeta_a  =  19.47175
  comp1248_vcinc  =  10.0
  comp1091_Balpha_c  =  0.0015
  comp1487_vcbase  =  -69.0
  comp2143_ACon  =  0.005
  comp2481_vchdur  =  30.0
  comp580_vchold  =  -71.0
  comp1248_vchold  =  -71.0
  comp1754_vchold  =  -71.0
  comp1487_vcinc  =  10.0
  comp665_e  =  -84.69
  comp1006_vcbdur  =  100.0
  comp1996_vcbdur  =  100.0
  comp1006_vcinc  =  10.0
  comp2143_n4  =  0.738
  comp2143_n3  =  1.83
  comp2143_n2  =  3.279
  comp2143_n1  =  5.422
  comp1006_vcbase  =  -69.0
  comp1996_vcbase  =  -69.0
  comp2143_Agamma  =  150.0
  comp580_vchdur  =  30.0
  comp1248_vchdur  =  30.0
  comp1754_vchdur  =  30.0
  comp1333_e  =  -84.69
  comp304_e  =  132.457934
  comp2143_Vbeta  =  13.99
  comp2143_Adelta  =  40.0
  comp219_d  =  0.2
  comp219_F  =  96485.3
  comp2481_vcbdur  =  100.0
  comp1572_B_ninf  =  6.0
  comp2081_e  =  -16.5
  comp2112_egaba  =  -65.0
  comp2481_vcbase  =  -60.0
  comp2143_AOoff  =  0.005
  comp2143_Valfa  =  13.99
  comp580_vcsteps  =  8.0
  comp1006_vcsteps  =  8.0
  comp1248_vcsteps  =  8.0
  comp1487_vcsteps  =  8.0
  comp1754_vcsteps  =  8.0
  comp1996_vcsteps  =  8.0
  comp2481_vcsteps  =  9.0
  comp1572_gbar  =  0.00025
  comp580_vcbdur  =  100.0
  comp1248_vcbdur  =  100.0
  comp1754_vcbdur  =  100.0
  comp665_V0_binf  =  -78.8
  comp580_vcbase  =  -69.0
  comp1248_vcbase  =  -69.0
  comp1754_vcbase  =  -69.0
  comp2481_vcinc  =  10.0
  comp1839_gbar  =  0.003
  comp2143_Vteta  =  25.0
  comp304_Aalpha_u  =  0.0013
  comp304_Aalpha_s  =  0.04944
  comp1572_Aalpha_n  =  0.0033
  comp1839_Aalpha_n  =  -0.01
  comp1333_Aalpha_d  =  0.13289
  comp1091_Aalpha_c  =  2.5
  comp665_Aalpha_b  =  0.0368
  comp665_Aalpha_a  =  0.8147
  comp665_K_binf  =  8.4
  comp2143_Abeta  =  1.272
  comp1333_gbar  =  0.0009
  comp580_vcinc  =  10.0
  comp1487_vchold  =  -71.0
  comp1996_vcinc  =  10.0
  comp1839_e  =  -84.69
  comp1091_gbar  =  0.04
  comp1091_Bbeta_c  =  0.00015
  comp665_V0_ainf  =  -38.0
  comp2081_gbar  =  5.68e-05
  comp2112_ggaba  =  3e-05
  comp219_cao  =  2.0
  comp304_V0alpha_u  =  -48.0
  comp304_V0alpha_s  =  -29.06
  comp1572_V0alpha_n  =  -30.0
  comp1839_V0alpha_n  =  -25.0
  comp2143_Aalfa  =  353.91
  comp1333_V0alpha_d  =  -83.94
  comp665_V0alpha_b  =  -111.33209
  comp665_V0alpha_a  =  -9.17203
  comp304_Abeta_u  =  0.0013
  comp304_Abeta_s  =  0.08298
  comp1572_Abeta_n  =  0.0033
  comp1839_Abeta_n  =  0.125
  comp1333_Abeta_d  =  0.16994
  comp1091_Abeta_c  =  1.5
  comp665_Abeta_b  =  0.0345
  comp665_Abeta_a  =  0.1655
  comp2143_Aepsilon  =  1.75
  comp1487_vchdur  =  30.0
  comp1754_vcinc  =  10.0
  comp1006_vchold  =  -71.0
  comp1996_vchold  =  -71.0
  comp665_K_ainf  =  -17.0
  comp2143_e  =  87.39
  comp1572_e  =  -84.69
  comp219_cai0  =  0.0001
  comp2143_gbar  =  0.013
}


STATE {
  comp219_ca
  KA_h
  KA_m
  KM_m
  KV_mC
  KV_mO
  KCa_mC
  KCa_mO
  Kir_mC
  Kir_mO
  CaHVA_hC
  CaHVA_hO
  CaHVA_mC
  CaHVA_mO
  comp2143_Na_zC1
  comp2143_Na_zC2
  comp2143_Na_zC3
  comp2143_Na_zC4
  comp2143_Na_zC5
  comp2143_Na_zO
  comp2143_Na_zB
  comp2143_Na_zI1
  comp2143_Na_zI2
  comp2143_Na_zI3
  comp2143_Na_zI4
  comp2143_Na_zI5
  comp2143_Na_zI6
  KV_m
  KCa_m
  Kir_m
  CaHVA_h
  CaHVA_m
  comp2143_Na_z
}


ASSIGNED {
  comp2143_Con
  KM_m_inf
  KA_m_tau
  comp2143_Coff
  KA_m_inf
  comp2143_epsilon
  comp304_Q10
  comp2143_gamma
  comp2143_delta
  comp1839_Q10
  comp665_b_inf
  comp665_tau_b
  comp665_tau_a
  comp1572_Q10
  comp1091_Q10
  comp1091_cai1
  KA_h_tau
  comp1333_Q10
  comp2143_Ooff
  KA_h_inf
  comp665_a_inf
  comp2143_Oon
  comp2143_Q10
  KM_m_tau
  comp2143_b
  comp2143_a
  comp665_Q10
  celsius
  comp1091_cai
  comp219_ica
  comp219_cai
  v
  cai
  ica
  ik
  i
  ina
  ek
  eca
  e
  ena
  i_Na
  i_Lkg2
  i_Lkg1
  i_KV
  i_KA
  i_KM
  i_CaHVA
  i_Kir
  i_KCa
}


PROCEDURE asgns () {
  LOCAL v2847
  comp665_Q10  =  3.0 ^ ((celsius + -25.5) / 10.0)
  comp2143_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  comp665_a_inf  =  
  1.0 / (1.0 + exp((v + -(comp665_V0_ainf)) / comp665_K_ainf))
  comp1333_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  if 
    (comp1091_cai < 0.0001) 
     {v2847  =  0.0001} 
    else {v2847  =  comp1091_cai} 
comp1091_cai1  =  v2847
  comp1091_Q10  =  3.0 ^ ((celsius + -30.0) / 10.0)
  comp1572_Q10  =  3.0 ^ ((celsius + -22.0) / 10.0)
  comp665_b_inf  =  
  1.0 / (1.0 + exp((v + -(comp665_V0_binf)) / comp665_K_binf))
  comp1839_Q10  =  3.0 ^ ((celsius + -6.3) / 10.0)
  comp304_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  KM_m_inf  =  
  1.0 / (1.0 + exp(-(v + -(comp1572_V0_ninf)) / comp1572_B_ninf))
  KM_m_tau  =  
  1.0 / 
    (comp1572_alpha_n(v, comp1572_Q10) + 
        comp1572_beta_n(v, comp1572_Q10))
  comp2143_Oon  =  comp2143_Q10 * comp2143_AOon
  KA_h_inf  =  comp665_b_inf
  comp2143_Ooff  =  comp2143_Q10 * comp2143_AOoff
  comp665_tau_a  =  
  1.0 / 
    (comp665_alpha_a(v, comp665_Q10) + comp665_beta_a(v, comp665_Q10))
  comp665_tau_b  =  
  1.0 / 
    (comp665_alpha_b(v, comp665_Q10) + comp665_beta_b(v, comp665_Q10))
  comp2143_delta  =  comp2143_Q10 * comp2143_Adelta
  comp2143_gamma  =  comp2143_Q10 * comp2143_Agamma
  comp2143_epsilon  =  comp2143_Q10 * comp2143_Aepsilon
  KA_m_inf  =  comp665_a_inf
  comp2143_Coff  =  comp2143_Q10 * comp2143_ACoff
  comp2143_Con  =  comp2143_Q10 * comp2143_ACon
  comp2143_a  =  (comp2143_Oon / comp2143_Con) ^ (1.0 / 4.0)
  comp2143_b  =  (comp2143_Ooff / comp2143_Coff) ^ (1.0 / 4.0)
  KA_h_tau  =  comp665_tau_b
  KA_m_tau  =  comp665_tau_a
  ena  =  comp2143_e
  e  =  comp2112_egaba
  e  =  comp2081_e
  ek  =  comp1839_e
  ek  =  comp665_e
  ek  =  comp1572_e
  eca  =  comp304_e
  ek  =  comp1333_e
  ek  =  comp1091_e
}


PROCEDURE reactions () {
  KV_m  =  KV_mO
  KCa_m  =  KCa_mO
  Kir_m  =  Kir_mO
  CaHVA_h  =  CaHVA_hO
  CaHVA_m  =  CaHVA_mO
  comp2143_Na_z  =  comp2143_Na_zO
}


PROCEDURE pools () {
  cai = comp219_ca
}


BREAKPOINT {
  LOCAL v2872, v2870, v2868
  SOLVE states METHOD derivimplicit
  SOLVE kstates METHOD sparse
  reactions ()
  pools ()
  v2872  =  KV_m 
i_KV  =  (comp1839_gbar * v2872 * v2872 * v2872 * v2872) * (v - ek)
  v2870  =  KA_m 
i_KA  =  (comp665_gbar * v2870 * v2870 * v2870 * KA_h) * (v - ek)
  i_KM  =  (comp1572_gbar * KM_m) * (v - ek)
  i_Kir  =  (comp1333_gbar * Kir_m) * (v - ek)
  i_KCa  =  (comp1091_gbar * KCa_m) * (v - ek)
  ik  =  i_KV + i_KA + i_KM + i_Kir + i_KCa
  v2868  =  CaHVA_m 
i_CaHVA  =  (comp304_gbar * v2868 * v2868 * CaHVA_h) * (v - eca)
  ica  =  i_CaHVA
  i_Lkg2  =  comp2112_ggaba * (v - comp2112_egaba)
  i_Lkg1  =  comp2081_gbar * (v - comp2081_e)
  i  =  i_Lkg2 + i_Lkg1
  i_Na  =  (comp2143_gbar * comp2143_Na_z) * (v - ena)
  ina  =  i_Na
}


DERIVATIVE states {
  LOCAL v2850, v2853, v2856, v2859, v2862, v2864
  comp219_cai  =  cai
  comp219_ica  =  ica
  comp1091_cai  =  cai
  asgns ()
  KA_m'  =  (KA_m_inf + -(KA_m)) / KA_m_tau
  KA_h'  =  (KA_h_inf + -(KA_h)) / KA_h_tau
  KM_m'  =  (KM_m_inf + -(KM_m)) / KM_m_tau
  v2850  =  CaHVA_mO 
CaHVA_mO'  =  
    -(CaHVA_mO * comp304_beta_s(v, comp304_Q10)) + 
        (1 - v2850) * (comp304_alpha_s(v, comp304_Q10))
  v2853  =  CaHVA_hO 
CaHVA_hO'  =  
    -(CaHVA_hO * comp304_beta_u(v, comp304_Q10)) + 
        (1 - v2853) * (comp304_alpha_u(v, comp304_Q10))
  v2856  =  Kir_mO 
Kir_mO'  =  
    -(Kir_mO * comp1333_beta_d(v, comp1333_Q10)) + 
        (1 - v2856) * (comp1333_alpha_d(v, comp1333_Q10))
  v2859  =  KCa_mO 
KCa_mO'  =  
    -(KCa_mO * comp1091_beta_c(v, comp1091_cai1, comp1091_Q10)) + 
        (1 - v2859) * (comp1091_alpha_c(v, comp1091_cai1, comp1091_Q10))
  v2862  =  KV_mO 
KV_mO'  =  
    -(KV_mO * comp1839_beta_n(v, comp1839_Q10)) + 
        (1 - v2862) * (comp1839_alpha_n(v, comp1839_Q10))
  if 
    (comp219_ca < comp219_cai0) 
     {v2864  =  comp219_cai0} 
    else {v2864  =  comp219_ca} 
comp219_ca'  =  
    (-(comp219_ica)) / (2.0 * comp219_F * comp219_d) * 10000.0 + 
        -(comp219_beta * (v2864 + -(comp219_cai0)))
}


KINETIC kstates {
  comp219_cai  =  cai
  comp219_ica  =  ica
  comp1091_cai  =  cai
  asgns ()
  ~ comp2143_Na_zC1 <-> comp2143_Na_zC2 (comp2143_n1 * comp2143_alfa(v, comp2143_Q10) , comp2143_n4 * comp2143_beta(v, comp2143_Q10))
  ~ comp2143_Na_zC2 <-> comp2143_Na_zC3 (comp2143_n2 * comp2143_alfa(v, comp2143_Q10) , comp2143_n3 * comp2143_beta(v, comp2143_Q10))
  ~ comp2143_Na_zC3 <-> comp2143_Na_zC4 (comp2143_n3 * comp2143_alfa(v, comp2143_Q10) , comp2143_n2 * comp2143_beta(v, comp2143_Q10))
  ~ comp2143_Na_zC4 <-> comp2143_Na_zC5 (comp2143_n4 * comp2143_alfa(v, comp2143_Q10) , comp2143_n1 * comp2143_beta(v, comp2143_Q10))
  ~ comp2143_Na_zC5 <-> comp2143_Na_zO (comp2143_gamma , comp2143_delta)
  ~ comp2143_Na_zO <-> comp2143_Na_zB (comp2143_epsilon , comp2143_teta(v, comp2143_Q10))
  ~ comp2143_Na_zI1 <-> comp2143_Na_zI2 (comp2143_n1 * comp2143_alfa(v, comp2143_Q10) * comp2143_a , comp2143_n4 * comp2143_beta(v, comp2143_Q10) * comp2143_b)
  ~ comp2143_Na_zI2 <-> comp2143_Na_zI3 (comp2143_n2 * comp2143_alfa(v, comp2143_Q10) * comp2143_a , comp2143_n3 * comp2143_beta(v, comp2143_Q10) * comp2143_b)
  ~ comp2143_Na_zI3 <-> comp2143_Na_zI4 (comp2143_n3 * comp2143_alfa(v, comp2143_Q10) * comp2143_a , comp2143_n2 * comp2143_beta(v, comp2143_Q10) * comp2143_b)
  ~ comp2143_Na_zI4 <-> comp2143_Na_zI5 (comp2143_n4 * comp2143_alfa(v, comp2143_Q10) * comp2143_a , comp2143_n1 * comp2143_beta(v, comp2143_Q10) * comp2143_b)
  ~ comp2143_Na_zI5 <-> comp2143_Na_zI6 (comp2143_gamma , comp2143_delta)
  ~ comp2143_Na_zC1 <-> comp2143_Na_zI1 (comp2143_Con , comp2143_Coff)
  ~ comp2143_Na_zC2 <-> comp2143_Na_zI2 (comp2143_Con * comp2143_a , comp2143_Coff * comp2143_b)
  ~ comp2143_Na_zC3 <-> comp2143_Na_zI3 (comp2143_Con * comp2143_a ^ 2.0 , comp2143_Coff * comp2143_b ^ 2.0)
  ~ comp2143_Na_zC4 <-> comp2143_Na_zI4 (comp2143_Con * comp2143_a ^ 3.0 , comp2143_Coff * comp2143_b ^ 3.0)
  ~ comp2143_Na_zC5 <-> comp2143_Na_zI5 (comp2143_Con * comp2143_a ^ 4.0 , comp2143_Coff * comp2143_b ^ 4.0)
  ~ comp2143_Na_zO <-> comp2143_Na_zI6 (comp2143_Oon , comp2143_Ooff)
}


INITIAL {
  comp219_cai  =  cai
  comp219_ica  =  ica
  comp1091_cai  =  cai
  asgns ()
  comp219_ca  =  0.0001
  KV_m  =  
  (comp1839_alpha_n(v, comp1839_Q10)) / 
    (comp1839_alpha_n(v, comp1839_Q10) + 
        comp1839_beta_n(v, comp1839_Q10))
  KV_mO  =  KV_m
  KCa_m  =  
  (comp1091_alpha_c(v, comp1091_cai1, comp1091_Q10)) / 
    (comp1091_alpha_c(v, comp1091_cai1, comp1091_Q10) + 
        comp1091_beta_c(v, comp1091_cai1, comp1091_Q10))
  KCa_mO  =  KCa_m
  Kir_m  =  
  (comp1333_alpha_d(v, comp1333_Q10)) / 
    (comp1333_alpha_d(v, comp1333_Q10) + 
        comp1333_beta_d(v, comp1333_Q10))
  Kir_mO  =  Kir_m
  CaHVA_h  =  
  (comp304_alpha_u(v, comp304_Q10)) / 
    (comp304_alpha_u(v, comp304_Q10) + comp304_beta_u(v, comp304_Q10))
  CaHVA_hO  =  CaHVA_h
  CaHVA_m  =  
  (comp304_alpha_s(v, comp304_Q10)) / 
    (comp304_alpha_s(v, comp304_Q10) + comp304_beta_s(v, comp304_Q10))
  CaHVA_mO  =  CaHVA_m
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp1572_V0_ninf)) / comp1572_B_ninf))
  KA_h  =  1.0 / (1.0 + exp((v + -(comp665_V0_binf)) / comp665_K_binf))
  KA_m  =  1.0 / (1.0 + exp((v + -(comp665_V0_ainf)) / comp665_K_ainf))
  SOLVE kstates STEADYSTATE sparse
  ena  =  comp2143_e
  e  =  comp2112_egaba
  e  =  comp2081_e
  ek  =  comp1839_e
  ek  =  comp665_e
  ek  =  comp1572_e
  eca  =  comp304_e
  ek  =  comp1333_e
  ek  =  comp1091_e
  pools ()
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g CaHVA_hO = %g\n" , t, v,  CaHVA_hO)
  printf ("NMODL state: t = %g v = %g CaHVA_mO = %g\n" , t, v,  CaHVA_mO)
  printf ("NMODL state: t = %g v = %g KA_h = %g\n" , t, v,  KA_h)
  printf ("NMODL state: t = %g v = %g KA_m = %g\n" , t, v,  KA_m)
  printf ("NMODL state: t = %g v = %g KCa_mO = %g\n" , t, v,  KCa_mO)
  printf ("NMODL state: t = %g v = %g KM_m = %g\n" , t, v,  KM_m)
  printf ("NMODL state: t = %g v = %g KV_mO = %g\n" , t, v,  KV_mO)
  printf ("NMODL state: t = %g v = %g Kir_mO = %g\n" , t, v,  Kir_mO)
  printf ("NMODL state: t = %g v = %g comp219_ca = %g\n" , t, v,  comp219_ca)
  printf ("NMODL state: t = %g v = %g CaHVA_h = %g\n" , t, v,  CaHVA_h)
  printf ("NMODL state: t = %g v = %g CaHVA_m = %g\n" , t, v,  CaHVA_m)
  printf ("NMODL state: t = %g v = %g KCa_m = %g\n" , t, v,  KCa_m)
  printf ("NMODL state: t = %g v = %g KV_m = %g\n" , t, v,  KV_m)
  printf ("NMODL state: t = %g v = %g Kir_m = %g\n" , t, v,  Kir_m)
  printf ("NMODL state: t = %g v = %g comp2143_Na_z = %g\n" , t, v,  comp2143_Na_z)
}
