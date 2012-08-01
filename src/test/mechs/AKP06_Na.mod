

TITLE Na


NEURON {
  RANGE Narsg_e, Narsg_gbar, Narsg_Na_z, Na_e, Na_gbar, Na_Na_z, comp0_C_m
  RANGE i_Narsg, i_Na
  RANGE ina
  USEION na READ ena WRITE ina
  RANGE temp_adj
}


PARAMETER {
  comp0_C_m  =  1.0
  Na_Na_gamma  =  150.0
  Narsg_Na_gamma  =  150.0
  temp_adj  =  1.24573093961552
  Na_Na_epsilon  =  1e-12
  Narsg_Na_epsilon  =  1.75
  Na_Na_zeta  =  0.03
  Narsg_Na_zeta  =  0.03
  Narsg_e  =  -88.0
  Narsg_Na_Oon  =  0.75
  Na_Na_delta  =  40.0
  Narsg_Na_delta  =  40.0
  Narsg_gbar  =  0.016
  Na_Na_alfac  =  4.63115650669757
  Narsg_Na_alfac  =  3.49963551158058
  Na_Na_x6  =  -25.0
  Na_gbar  =  0.016
  Na_Na_x5  =  1000000000000.0
  Na_Na_x4  =  -1000000000000.0
  Na_Na_x3  =  1000000000000.0
  Na_Na_alpha  =  150.0
  Na_Na_x2  =  -20.0
  Narsg_Na_alpha  =  150.0
  Na_Na_x1  =  20.0
  Narsg_Na_Con  =  0.005
  Na_Na_Ooff  =  0.005
  Narsg_Na_Ooff  =  0.005
  Na_Na_Oon  =  2.3
  Na_e  =  -88.0
  Na_Na_btfac  =  0.316227766016838
  Narsg_Na_btfac  =  0.316227766016838
  Narsg_Na_x6  =  -25.0
  Narsg_Na_x5  =  1000000000000.0
  Narsg_Na_x4  =  -1000000000000.0
  Narsg_Na_x3  =  1000000000000.0
  Narsg_Na_x2  =  -20.0
  Narsg_Na_x1  =  20.0
  Na_Na_beta  =  3.0
  Narsg_Na_beta  =  3.0
  Na_Na_Con  =  0.005
  Na_Na_Coff  =  0.5
  Narsg_Na_Coff  =  0.5
}


STATE {
  Na_Na_zC1
  Na_Na_zC2
  Na_Na_zC3
  Na_Na_zC4
  Na_Na_zC5
  Na_Na_zO
  Na_Na_zI1
  Na_Na_zI2
  Na_Na_zI3
  Na_Na_zI4
  Na_Na_zI5
  Na_Na_zB
  Na_Na_zI6
  Narsg_Na_zC1
  Narsg_Na_zC2
  Narsg_Na_zC3
  Narsg_Na_zC4
  Narsg_Na_zC5
  Narsg_Na_zO
  Narsg_Na_zI1
  Narsg_Na_zI2
  Narsg_Na_zI3
  Narsg_Na_zI4
  Narsg_Na_zI5
  Narsg_Na_zB
  Narsg_Na_zI6
  Na_Na_z
  Narsg_Na_z
}


ASSIGNED {
  Narsg_f14
  Narsg_f13
  Narsg_f12
  Na_b14
  Narsg_f11
  Na_b13
  Na_b12
  Na_b11
  Narsg_fi5
  Narsg_fi4
  Narsg_fi3
  Na_bi5
  Narsg_fi2
  Na_bi4
  Narsg_fi1
  Na_bi3
  Na_bi2
  Na_bi1
  Narsg_f04
  Narsg_f03
  Narsg_f02
  Na_b04
  Narsg_f01
  Na_b03
  Na_b02
  Na_b01
  Narsg_b1n
  Narsg_bip
  Narsg_bin
  Narsg_b0O
  Narsg_b14
  Narsg_b13
  Narsg_b12
  Narsg_b11
  Na_f1n
  Narsg_bi5
  Narsg_bi4
  Narsg_bi3
  Na_fip
  Narsg_bi2
  Narsg_bi1
  Na_fin
  Narsg_b04
  Narsg_b03
  Narsg_b02
  Narsg_b01
  Na_f0O
  Na_f14
  Na_f13
  Na_f12
  Na_f11
  Na_fi5
  Na_fi4
  Na_fi3
  Na_fi2
  Na_fi1
  Na_f04
  Na_f03
  Na_f02
  Na_f01
  Narsg_f1n
  Na_b1n
  Narsg_fip
  Narsg_fin
  Na_bip
  Na_bin
  Narsg_f0O
  Na_b0O
  v
  ina
  ena
  i_Narsg
  i_Na
}


PROCEDURE asgns () {
  Na_b0O  =  Na_Na_delta * exp(v / Na_Na_x4) * temp_adj
  Narsg_f0O  =  Narsg_Na_gamma * exp(v / Narsg_Na_x3) * temp_adj
  Na_bin  =  Na_Na_Ooff * temp_adj
  Na_bip  =  Na_Na_zeta * exp(v / Na_Na_x6) * temp_adj
  Narsg_fin  =  Narsg_Na_Oon * temp_adj
  Narsg_fip  =  Narsg_Na_epsilon * exp(v / Narsg_Na_x5) * temp_adj
  Na_b1n  =  Na_Na_delta * exp(v / Na_Na_x4) * temp_adj
  Narsg_f1n  =  Narsg_Na_gamma * exp(v / Narsg_Na_x3) * temp_adj
  Na_f01  =  4.0 * Na_Na_alpha * exp(v / Na_Na_x1) * temp_adj
  Na_f02  =  3.0 * Na_Na_alpha * exp(v / Na_Na_x1) * temp_adj
  Na_f03  =  2.0 * Na_Na_alpha * exp(v / Na_Na_x1) * temp_adj
  Na_f04  =  Na_Na_alpha * exp(v / Na_Na_x1) * temp_adj
  Na_fi1  =  Na_Na_Con * temp_adj
  Na_fi2  =  Na_Na_Con * Na_Na_alfac * temp_adj
  Na_fi3  =  Na_Na_Con * Na_Na_alfac * Na_Na_alfac * temp_adj
  Na_fi4  =  
  Na_Na_Con * Na_Na_alfac * Na_Na_alfac * Na_Na_alfac * temp_adj
  Na_fi5  =  
  Na_Na_Con * Na_Na_alfac * Na_Na_alfac * Na_Na_alfac * Na_Na_alfac * 
    temp_adj
  Na_f11  =  
  4.0 * Na_Na_alpha * Na_Na_alfac * exp(v / Na_Na_x1) * temp_adj
  Na_f12  =  
  3.0 * Na_Na_alpha * Na_Na_alfac * exp(v / Na_Na_x1) * temp_adj
  Na_f13  =  
  2.0 * Na_Na_alpha * Na_Na_alfac * exp(v / Na_Na_x1) * temp_adj
  Na_f14  =  Na_Na_alpha * Na_Na_alfac * exp(v / Na_Na_x1) * temp_adj
  Na_f0O  =  Na_Na_gamma * exp(v / Na_Na_x3) * temp_adj
  Narsg_b01  =  Narsg_Na_beta * exp(v / Narsg_Na_x2) * temp_adj
  Narsg_b02  =  2.0 * Narsg_Na_beta * exp(v / Narsg_Na_x2) * temp_adj
  Narsg_b03  =  3.0 * Narsg_Na_beta * exp(v / Narsg_Na_x2) * temp_adj
  Narsg_b04  =  4.0 * Narsg_Na_beta * exp(v / Narsg_Na_x2) * temp_adj
  Na_fin  =  Na_Na_Oon * temp_adj
  Narsg_bi1  =  Narsg_Na_Coff * temp_adj
  Narsg_bi2  =  Narsg_Na_Coff * Narsg_Na_btfac * temp_adj
  Na_fip  =  Na_Na_epsilon * exp(v / Na_Na_x5) * temp_adj
  Narsg_bi3  =  Narsg_Na_Coff * Narsg_Na_btfac * Narsg_Na_btfac * temp_adj
  Narsg_bi4  =  
  Narsg_Na_Coff * Narsg_Na_btfac * Narsg_Na_btfac * Narsg_Na_btfac * 
    temp_adj
  Narsg_bi5  =  
  Narsg_Na_Coff * Narsg_Na_btfac * Narsg_Na_btfac * Narsg_Na_btfac * 
      Narsg_Na_btfac 
    * 
    temp_adj
  Na_f1n  =  Na_Na_gamma * exp(v / Na_Na_x3) * temp_adj
  Narsg_b11  =  
  Narsg_Na_beta * Narsg_Na_btfac * exp(v / Narsg_Na_x2) * temp_adj
  Narsg_b12  =  
  2.0 * Narsg_Na_beta * Narsg_Na_btfac * exp(v / Narsg_Na_x2) * temp_adj
  Narsg_b13  =  
  3.0 * Narsg_Na_beta * Narsg_Na_btfac * exp(v / Narsg_Na_x2) * temp_adj
  Narsg_b14  =  
  4.0 * Narsg_Na_beta * Narsg_Na_btfac * exp(v / Narsg_Na_x2) * temp_adj
  Narsg_b0O  =  Narsg_Na_delta * exp(v / Narsg_Na_x4) * temp_adj
  Narsg_bin  =  Narsg_Na_Ooff * temp_adj
  Narsg_bip  =  Narsg_Na_zeta * exp(v / Narsg_Na_x6) * temp_adj
  Narsg_b1n  =  Narsg_Na_delta * exp(v / Narsg_Na_x4) * temp_adj
  Na_b01  =  Na_Na_beta * exp(v / Na_Na_x2) * temp_adj
  Na_b02  =  2.0 * Na_Na_beta * exp(v / Na_Na_x2) * temp_adj
  Na_b03  =  3.0 * Na_Na_beta * exp(v / Na_Na_x2) * temp_adj
  Narsg_f01  =  4.0 * Narsg_Na_alpha * exp(v / Narsg_Na_x1) * temp_adj
  Na_b04  =  4.0 * Na_Na_beta * exp(v / Na_Na_x2) * temp_adj
  Narsg_f02  =  3.0 * Narsg_Na_alpha * exp(v / Narsg_Na_x1) * temp_adj
  Narsg_f03  =  2.0 * Narsg_Na_alpha * exp(v / Narsg_Na_x1) * temp_adj
  Narsg_f04  =  Narsg_Na_alpha * exp(v / Narsg_Na_x1) * temp_adj
  Na_bi1  =  Na_Na_Coff * temp_adj
  Na_bi2  =  Na_Na_Coff * Na_Na_btfac * temp_adj
  Na_bi3  =  Na_Na_Coff * Na_Na_btfac * Na_Na_btfac * temp_adj
  Narsg_fi1  =  Narsg_Na_Con * temp_adj
  Na_bi4  =  
  Na_Na_Coff * Na_Na_btfac * Na_Na_btfac * Na_Na_btfac * temp_adj
  Narsg_fi2  =  Narsg_Na_Con * Narsg_Na_alfac * temp_adj
  Na_bi5  =  
  Na_Na_Coff * Na_Na_btfac * Na_Na_btfac * Na_Na_btfac * Na_Na_btfac * 
    temp_adj
  Narsg_fi3  =  Narsg_Na_Con * Narsg_Na_alfac * Narsg_Na_alfac * temp_adj
  Narsg_fi4  =  
  Narsg_Na_Con * Narsg_Na_alfac * Narsg_Na_alfac * Narsg_Na_alfac * 
    temp_adj
  Narsg_fi5  =  
  Narsg_Na_Con * Narsg_Na_alfac * Narsg_Na_alfac * Narsg_Na_alfac * 
      Narsg_Na_alfac 
    * 
    temp_adj
  Na_b11  =  Na_Na_beta * Na_Na_btfac * exp(v / Na_Na_x2) * temp_adj
  Na_b12  =  2.0 * Na_Na_beta * Na_Na_btfac * exp(v / Na_Na_x2) * temp_adj
  Na_b13  =  3.0 * Na_Na_beta * Na_Na_btfac * exp(v / Na_Na_x2) * temp_adj
  Narsg_f11  =  
  4.0 * Narsg_Na_alpha * Narsg_Na_alfac * exp(v / Narsg_Na_x1) * 
    temp_adj
  Na_b14  =  4.0 * Na_Na_beta * Na_Na_btfac * exp(v / Na_Na_x2) * temp_adj
  Narsg_f12  =  
  3.0 * Narsg_Na_alpha * Narsg_Na_alfac * exp(v / Narsg_Na_x1) * 
    temp_adj
  Narsg_f13  =  
  2.0 * Narsg_Na_alpha * Narsg_Na_alfac * exp(v / Narsg_Na_x1) * 
    temp_adj
  Narsg_f14  =  
  Narsg_Na_alpha * Narsg_Na_alfac * exp(v / Narsg_Na_x1) * temp_adj
}


PROCEDURE reactions () {
  Na_Na_z  =  Na_Na_zO
  Narsg_Na_z  =  Narsg_Na_zO
}


BREAKPOINT {
  SOLVE states METHOD cnexp
  reactions ()
  i_Narsg  =  (Narsg_gbar * Narsg_Na_z) * (v - ena)
  i_Na  =  (Na_gbar * Na_Na_z) * (v - ena)
  ina  =  i_Narsg + i_Na
}


DERIVATIVE states {
  asgns ()
  Narsg_Na_zO'  =  
  -(Narsg_Na_zO * Narsg_fin + Narsg_Na_zO * Narsg_fip + 
            Narsg_Na_zO * Narsg_b0O) 
    + 
    Narsg_Na_zI6 * Narsg_bin + 
        (1 - 
              Narsg_Na_zI6 + Narsg_Na_zI5 + 
                Narsg_Na_zI4 + Narsg_Na_zI3 + 
                  Narsg_Na_zI2 + Narsg_Na_zI1 + 
                    Narsg_Na_zO + Narsg_Na_zC5 + 
                      Narsg_Na_zC4 + Narsg_Na_zC3 + 
                        Narsg_Na_zC2 + Narsg_Na_zC1) 
          * 
          Narsg_bip 
      + 
      Narsg_Na_zC5 * Narsg_f0O
  Narsg_Na_zI6'  =  
  -(Narsg_Na_zI6 * Narsg_b1n + Narsg_Na_zI6 * Narsg_bin) + 
    Narsg_Na_zI5 * Narsg_f1n + Narsg_Na_zO * Narsg_fin
  Narsg_Na_zI1'  =  
  -(Narsg_Na_zI1 * Narsg_bi1 + Narsg_Na_zI1 * Narsg_f11) + 
    Narsg_Na_zC1 * Narsg_fi1 + Narsg_Na_zI2 * Narsg_b11
  Narsg_Na_zC1'  =  
  -(Narsg_Na_zC1 * Narsg_fi1 + Narsg_Na_zC1 * Narsg_f01) + 
    Narsg_Na_zI1 * Narsg_bi1 + Narsg_Na_zC2 * Narsg_b01
  Narsg_Na_zI2'  =  
  -(Narsg_Na_zI2 * Narsg_bi2 + Narsg_Na_zI2 * Narsg_f12 + 
            Narsg_Na_zI2 * Narsg_b11) 
    + 
    Narsg_Na_zC2 * Narsg_fi2 + Narsg_Na_zI3 * Narsg_b12 + 
      Narsg_Na_zI1 * Narsg_f11
  Narsg_Na_zC2'  =  
  -(Narsg_Na_zC2 * Narsg_fi2 + Narsg_Na_zC2 * Narsg_f02 + 
            Narsg_Na_zC2 * Narsg_b01) 
    + 
    Narsg_Na_zI2 * Narsg_bi2 + Narsg_Na_zC3 * Narsg_b02 + 
      Narsg_Na_zC1 * Narsg_f01
  Narsg_Na_zI3'  =  
  -(Narsg_Na_zI3 * Narsg_bi3 + Narsg_Na_zI3 * Narsg_f13 + 
            Narsg_Na_zI3 * Narsg_b12) 
    + 
    Narsg_Na_zC3 * Narsg_fi3 + Narsg_Na_zI4 * Narsg_b13 + 
      Narsg_Na_zI2 * Narsg_f12
  Narsg_Na_zC3'  =  
  -(Narsg_Na_zC3 * Narsg_fi3 + Narsg_Na_zC3 * Narsg_f03 + 
            Narsg_Na_zC3 * Narsg_b02) 
    + 
    Narsg_Na_zI3 * Narsg_bi3 + Narsg_Na_zC4 * Narsg_b03 + 
      Narsg_Na_zC2 * Narsg_f02
  Narsg_Na_zI4'  =  
  -(Narsg_Na_zI4 * Narsg_bi4 + Narsg_Na_zI4 * Narsg_f14 + 
            Narsg_Na_zI4 * Narsg_b13) 
    + 
    Narsg_Na_zC4 * Narsg_fi4 + Narsg_Na_zI5 * Narsg_b14 + 
      Narsg_Na_zI3 * Narsg_f13
  Narsg_Na_zC4'  =  
  -(Narsg_Na_zC4 * Narsg_fi4 + Narsg_Na_zC4 * Narsg_f04 + 
            Narsg_Na_zC4 * Narsg_b03) 
    + 
    Narsg_Na_zI4 * Narsg_bi4 + Narsg_Na_zC5 * Narsg_b04 + 
      Narsg_Na_zC3 * Narsg_f03
  Narsg_Na_zI5'  =  
  -(Narsg_Na_zI5 * Narsg_bi5 + Narsg_Na_zI5 * Narsg_f1n + 
            Narsg_Na_zI5 * Narsg_b14) 
    + 
    Narsg_Na_zC5 * Narsg_fi5 + Narsg_Na_zI6 * Narsg_b1n + 
      Narsg_Na_zI4 * Narsg_f14
  Narsg_Na_zC5'  =  
  -(Narsg_Na_zC5 * Narsg_fi5 + Narsg_Na_zC5 * Narsg_f0O + 
            Narsg_Na_zC5 * Narsg_b04) 
    + 
    Narsg_Na_zI5 * Narsg_bi5 + Narsg_Na_zO * Narsg_b0O + 
      Narsg_Na_zC4 * Narsg_f04
  Na_Na_zO'  =  
  -(Na_Na_zO * Na_fin + Na_Na_zO * Na_fip + Na_Na_zO * Na_b0O) + 
    Na_Na_zI6 * Na_bin + 
        (1 - 
              Na_Na_zI6 + Na_Na_zI5 + 
                Na_Na_zI4 + Na_Na_zI3 + 
                  Na_Na_zI2 + Na_Na_zI1 + 
                    Na_Na_zO + Na_Na_zC5 + 
                      Na_Na_zC4 + Na_Na_zC3 + Na_Na_zC2 + Na_Na_zC1) 
          * 
          Na_bip 
      + 
      Na_Na_zC5 * Na_f0O
  Na_Na_zI6'  =  
  -(Na_Na_zI6 * Na_b1n + Na_Na_zI6 * Na_bin) + 
    Na_Na_zI5 * Na_f1n + Na_Na_zO * Na_fin
  Na_Na_zI1'  =  
  -(Na_Na_zI1 * Na_bi1 + Na_Na_zI1 * Na_f11) + 
    Na_Na_zC1 * Na_fi1 + Na_Na_zI2 * Na_b11
  Na_Na_zC1'  =  
  -(Na_Na_zC1 * Na_fi1 + Na_Na_zC1 * Na_f01) + 
    Na_Na_zI1 * Na_bi1 + Na_Na_zC2 * Na_b01
  Na_Na_zI2'  =  
  -(Na_Na_zI2 * Na_bi2 + Na_Na_zI2 * Na_f12 + Na_Na_zI2 * Na_b11) + 
    Na_Na_zC2 * Na_fi2 + Na_Na_zI3 * Na_b12 + Na_Na_zI1 * Na_f11
  Na_Na_zC2'  =  
  -(Na_Na_zC2 * Na_fi2 + Na_Na_zC2 * Na_f02 + Na_Na_zC2 * Na_b01) + 
    Na_Na_zI2 * Na_bi2 + Na_Na_zC3 * Na_b02 + Na_Na_zC1 * Na_f01
  Na_Na_zI3'  =  
  -(Na_Na_zI3 * Na_bi3 + Na_Na_zI3 * Na_f13 + Na_Na_zI3 * Na_b12) + 
    Na_Na_zC3 * Na_fi3 + Na_Na_zI4 * Na_b13 + Na_Na_zI2 * Na_f12
  Na_Na_zC3'  =  
  -(Na_Na_zC3 * Na_fi3 + Na_Na_zC3 * Na_f03 + Na_Na_zC3 * Na_b02) + 
    Na_Na_zI3 * Na_bi3 + Na_Na_zC4 * Na_b03 + Na_Na_zC2 * Na_f02
  Na_Na_zI4'  =  
  -(Na_Na_zI4 * Na_bi4 + Na_Na_zI4 * Na_f14 + Na_Na_zI4 * Na_b13) + 
    Na_Na_zC4 * Na_fi4 + Na_Na_zI5 * Na_b14 + Na_Na_zI3 * Na_f13
  Na_Na_zC4'  =  
  -(Na_Na_zC4 * Na_fi4 + Na_Na_zC4 * Na_f04 + Na_Na_zC4 * Na_b03) + 
    Na_Na_zI4 * Na_bi4 + Na_Na_zC5 * Na_b04 + Na_Na_zC3 * Na_f03
  Na_Na_zI5'  =  
  -(Na_Na_zI5 * Na_bi5 + Na_Na_zI5 * Na_f1n + Na_Na_zI5 * Na_b14) + 
    Na_Na_zC5 * Na_fi5 + Na_Na_zI6 * Na_b1n + Na_Na_zI4 * Na_f14
  Na_Na_zC5'  =  
  -(Na_Na_zC5 * Na_fi5 + Na_Na_zC5 * Na_f0O + Na_Na_zC5 * Na_b04) + 
    Na_Na_zI5 * Na_bi5 + Na_Na_zO * Na_b0O + Na_Na_zC4 * Na_f04
}


INITIAL {
  asgns ()
}


PROCEDURE print_state () {
  printf ("Na_Na_zC1 = %g\n" ,  Na_Na_zC1)
  printf ("Na_Na_zC2 = %g\n" ,  Na_Na_zC2)
  printf ("Na_Na_zC3 = %g\n" ,  Na_Na_zC3)
  printf ("Na_Na_zC4 = %g\n" ,  Na_Na_zC4)
  printf ("Na_Na_zC5 = %g\n" ,  Na_Na_zC5)
  printf ("Na_Na_zI1 = %g\n" ,  Na_Na_zI1)
  printf ("Na_Na_zI2 = %g\n" ,  Na_Na_zI2)
  printf ("Na_Na_zI3 = %g\n" ,  Na_Na_zI3)
  printf ("Na_Na_zI4 = %g\n" ,  Na_Na_zI4)
  printf ("Na_Na_zI5 = %g\n" ,  Na_Na_zI5)
  printf ("Na_Na_zI6 = %g\n" ,  Na_Na_zI6)
  printf ("Na_Na_zO = %g\n" ,  Na_Na_zO)
  printf ("Narsg_Na_zC1 = %g\n" ,  Narsg_Na_zC1)
  printf ("Narsg_Na_zC2 = %g\n" ,  Narsg_Na_zC2)
  printf ("Narsg_Na_zC3 = %g\n" ,  Narsg_Na_zC3)
  printf ("Narsg_Na_zC4 = %g\n" ,  Narsg_Na_zC4)
  printf ("Narsg_Na_zC5 = %g\n" ,  Narsg_Na_zC5)
  printf ("Narsg_Na_zI1 = %g\n" ,  Narsg_Na_zI1)
  printf ("Narsg_Na_zI2 = %g\n" ,  Narsg_Na_zI2)
  printf ("Narsg_Na_zI3 = %g\n" ,  Narsg_Na_zI3)
  printf ("Narsg_Na_zI4 = %g\n" ,  Narsg_Na_zI4)
  printf ("Narsg_Na_zI5 = %g\n" ,  Narsg_Na_zI5)
  printf ("Narsg_Na_zI6 = %g\n" ,  Narsg_Na_zI6)
  printf ("Narsg_Na_zO = %g\n" ,  Narsg_Na_zO)
}
