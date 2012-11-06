

TITLE CGC_Na


NEURON {
  RANGE comp2609_vchold, comp2609_vcbase, comp2609_vcinc, comp2609_vcsteps, comp2609_vchdur, comp2609_vcbdur, comp2694_Na_z, comp2694_gbar, comp2694_e
  RANGE i_Na
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION linoid (x, y) {
  LOCAL v3051
  if 
    (fabs(x / y) < 1e-06) 
     {v3051  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3051  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3051
}


FUNCTION comp2694_alfa (v, Q10) {
  comp2694_alfa  =  Q10 * comp2694_Aalfa * exp(v / comp2694_Valfa)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION comp2694_teta (v, Q10) {
  comp2694_teta  =  Q10 * comp2694_Ateta * exp(-(v) / comp2694_Vteta)
}


FUNCTION comp2694_beta (v, Q10) {
  comp2694_beta  =  Q10 * comp2694_Abeta * exp(-(v) / comp2694_Vbeta)
}


PARAMETER {
  comp2609_vcbdur  =  100.0
  comp2694_Vteta  =  25.0
  comp2694_Adelta  =  40.0
  comp2694_Valfa  =  13.99
  comp2609_vcinc  =  10.0
  comp2694_Aepsilon  =  1.75
  comp2694_Agamma  =  150.0
  comp2609_vcsteps  =  9.0
  comp2694_Vbeta  =  13.99
  comp2694_ACoff  =  0.5
  comp2609_vchold  =  -71.0
  comp2694_AOoff  =  0.005
  comp2609_vchdur  =  30.0
  comp2609_vcbase  =  -60.0
  comp2694_n4  =  0.738
  comp2694_n2  =  3.279
  comp2694_n3  =  1.83
  comp2694_n1  =  5.422
  comp2694_gbar  =  0.013
  comp2694_e  =  87.39
  comp2694_AOon  =  0.75
  comp2694_Abeta  =  1.272
  comp2694_Ateta  =  0.0201
  comp2694_Aalfa  =  353.91
  comp2694_ACon  =  0.005
}


STATE {
  comp2694_Na_zC1
  comp2694_Na_zC2
  comp2694_Na_zC3
  comp2694_Na_zC4
  comp2694_Na_zC5
  comp2694_Na_zO
  comp2694_Na_zI1
  comp2694_Na_zI2
  comp2694_Na_zI3
  comp2694_Na_zI4
  comp2694_Na_zI5
  comp2694_Na_zB
  comp2694_Na_zI6
  comp2694_Na_z
}


ASSIGNED {
  comp2694_epsilon
  comp2694_Q10
  comp2694_Coff
  comp2694_delta
  comp2694_Oon
  comp2694_Ooff
  comp2694_Con
  comp2694_b
  comp2694_a
  comp2694_gamma
  v
  celsius
  ina
  ena
  i_Na
}


PROCEDURE asgns () {
  comp2694_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  comp2694_gamma  =  comp2694_Q10 * comp2694_Agamma
  comp2694_Con  =  comp2694_Q10 * comp2694_ACon
  comp2694_Ooff  =  comp2694_Q10 * comp2694_AOoff
  comp2694_Oon  =  comp2694_Q10 * comp2694_AOon
  comp2694_delta  =  comp2694_Q10 * comp2694_Adelta
  comp2694_Coff  =  comp2694_Q10 * comp2694_ACoff
  comp2694_epsilon  =  comp2694_Q10 * comp2694_Aepsilon
  comp2694_a  =  (comp2694_Oon / comp2694_Con) ^ (1.0 / 4.0)
  comp2694_b  =  (comp2694_Ooff / comp2694_Coff) ^ (1.0 / 4.0)
}


PROCEDURE reactions () {
  comp2694_Na_z  =  comp2694_Na_zO
}


BREAKPOINT {
  SOLVE kstates METHOD sparse
  reactions ()
  i_Na  =  (comp2694_gbar * comp2694_Na_z) * (v - ena)
  ina  =  i_Na
}


KINETIC kstates {
  asgns ()
  ~ comp2694_Na_zC1 <-> comp2694_Na_zC2 (comp2694_n1 * comp2694_alfa(v, comp2694_Q10) , comp2694_n4 * comp2694_beta(v, comp2694_Q10))
  ~ comp2694_Na_zC2 <-> comp2694_Na_zC3 (comp2694_n2 * comp2694_alfa(v, comp2694_Q10) , comp2694_n3 * comp2694_beta(v, comp2694_Q10))
  ~ comp2694_Na_zC3 <-> comp2694_Na_zC4 (comp2694_n3 * comp2694_alfa(v, comp2694_Q10) , comp2694_n2 * comp2694_beta(v, comp2694_Q10))
  ~ comp2694_Na_zC4 <-> comp2694_Na_zC5 (comp2694_n4 * comp2694_alfa(v, comp2694_Q10) , comp2694_n1 * comp2694_beta(v, comp2694_Q10))
  ~ comp2694_Na_zC5 <-> comp2694_Na_zO (comp2694_gamma , comp2694_delta)
  ~ comp2694_Na_zO <-> comp2694_Na_zB (comp2694_epsilon , comp2694_teta(v, comp2694_Q10))
  ~ comp2694_Na_zI1 <-> comp2694_Na_zI2 (comp2694_n1 * comp2694_alfa(v, comp2694_Q10) * comp2694_a , comp2694_n4 * comp2694_beta(v, comp2694_Q10) * comp2694_b)
  ~ comp2694_Na_zI2 <-> comp2694_Na_zI3 (comp2694_n2 * comp2694_alfa(v, comp2694_Q10) * comp2694_a , comp2694_n3 * comp2694_beta(v, comp2694_Q10) * comp2694_b)
  ~ comp2694_Na_zI3 <-> comp2694_Na_zI4 (comp2694_n3 * comp2694_alfa(v, comp2694_Q10) * comp2694_a , comp2694_n2 * comp2694_beta(v, comp2694_Q10) * comp2694_b)
  ~ comp2694_Na_zI4 <-> comp2694_Na_zI5 (comp2694_n4 * comp2694_alfa(v, comp2694_Q10) * comp2694_a , comp2694_n1 * comp2694_beta(v, comp2694_Q10) * comp2694_b)
  ~ comp2694_Na_zI5 <-> comp2694_Na_zI6 (comp2694_gamma , comp2694_delta)
  ~ comp2694_Na_zC1 <-> comp2694_Na_zI1 (comp2694_Con , comp2694_Coff)
  ~ comp2694_Na_zC2 <-> comp2694_Na_zI2 (comp2694_Con * comp2694_a , comp2694_Coff * comp2694_b)
  ~ comp2694_Na_zC3 <-> comp2694_Na_zI3 (comp2694_Con * comp2694_a ^ 2.0 , comp2694_Coff * comp2694_b ^ 2.0)
  ~ comp2694_Na_zC4 <-> comp2694_Na_zI4 (comp2694_Con * comp2694_a ^ 3.0 , comp2694_Coff * comp2694_b ^ 3.0)
  ~ comp2694_Na_zC5 <-> comp2694_Na_zI5 (comp2694_Con * comp2694_a ^ 4.0 , comp2694_Coff * comp2694_b ^ 4.0)
  ~ comp2694_Na_zO <-> comp2694_Na_zI6 (comp2694_Oon , comp2694_Ooff)
  CONSERVE comp2694_Na_zC1 + comp2694_Na_zC2 + comp2694_Na_zC3 + comp2694_Na_zC4 + comp2694_Na_zC5 + comp2694_Na_zO + comp2694_Na_zB + comp2694_Na_zI1 + comp2694_Na_zI2 + comp2694_Na_zI3 + comp2694_Na_zI4 + comp2694_Na_zI5 + comp2694_Na_zI6 = 1
}


INITIAL {
  asgns ()
  SOLVE kstates STEADYSTATE sparse
  ena  =  comp2694_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp2694_Na_z = %g\n" , t, v,  comp2694_Na_z)
}
