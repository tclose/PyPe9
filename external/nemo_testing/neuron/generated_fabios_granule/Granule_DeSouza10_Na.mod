

TITLE Granule_DeSouza10_Na


NEURON {
  RANGE comp484_celsius, comp484_V_t, comp485_C_m, comp486_vchold, comp486_vcbase, comp486_vcinc, comp486_vcsteps, comp486_vchdur, comp486_vcbdur, comp487_Na_z
  RANGE comp487_gbar, comp487_e
  RANGE i_Na
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION comp487_alfa (v, Q10) {
  comp487_alfa  =  Q10 * comp487_Aalfa * exp(v / comp487_Valfa)
}


FUNCTION comp487_teta (v, Q10) {
  comp487_teta  =  Q10 * comp487_Ateta * exp(-(v) / comp487_Vteta)
}


FUNCTION comp487_beta (v, Q10) {
  comp487_beta  =  Q10 * comp487_Abeta * exp(-(v) / comp487_Vbeta)
}


PARAMETER {
  comp487_Valfa  =  13.99
  comp486_vcbase  =  -60.0
  comp486_vcinc  =  10.0
  comp487_e  =  87.39
  comp487_Adelta  =  40.0
  comp485_C_m  =  1.0
  comp486_vcsteps  =  9.0
  comp486_vchdur  =  30.0
  comp486_vcbdur  =  100.0
  comp487_n4  =  0.738
  comp487_n3  =  1.83
  comp487_n2  =  3.279
  comp487_n1  =  5.422
  comp487_gbar  =  0.013
  comp487_Ateta  =  0.0201
  comp487_AOoff  =  0.005
  comp484_celsius  =  30.0
  comp487_AOon  =  0.75
  comp487_ACon  =  0.005
  comp487_Vteta  =  25.0
  comp487_ACoff  =  0.5
  comp486_vchold  =  -71.0
  comp487_Abeta  =  1.272
  comp487_Agamma  =  150.0
  comp487_Vbeta  =  13.99
  comp487_Aepsilon  =  1.75
  comp484_V_t  =  -35.0
  comp487_Aalfa  =  353.91
}


STATE {
  comp487_Na_zC1
  comp487_Na_zC2
  comp487_Na_zC3
  comp487_Na_zC4
  comp487_Na_zC5
  comp487_Na_zO
  comp487_Na_zB
  comp487_Na_zI1
  comp487_Na_zI2
  comp487_Na_zI3
  comp487_Na_zI4
  comp487_Na_zI5
  comp487_Na_zI6
  comp487_Na_z
}


ASSIGNED {
  comp487_b
  comp487_a
  comp487_Q10
  comp487_delta
  comp487_Oon
  comp487_Con
  comp487_epsilon
  comp487_Ooff
  comp487_Coff
  comp487_gamma
  celsius
  v
  ina
  ena
  i_Na
}


PROCEDURE asgns () {
  comp487_Q10  =  3.0 ^ ((comp484_celsius + -20.0) / 10.0)
  comp487_gamma  =  comp487_Q10 * comp487_Agamma
  comp487_Coff  =  comp487_Q10 * comp487_ACoff
  comp487_Ooff  =  comp487_Q10 * comp487_AOoff
  comp487_epsilon  =  comp487_Q10 * comp487_Aepsilon
  comp487_Con  =  comp487_Q10 * comp487_ACon
  comp487_Oon  =  comp487_Q10 * comp487_AOon
  comp487_delta  =  comp487_Q10 * comp487_Adelta
  comp487_a  =  (comp487_Oon / comp487_Con) ^ (1.0 / 4.0)
  comp487_b  =  (comp487_Ooff / comp487_Coff) ^ (1.0 / 4.0)
  ena  =  comp487_e
}


PROCEDURE reactions () {
  comp487_Na_z  =  comp487_Na_zO
}


BREAKPOINT {
  SOLVE kstates METHOD sparse
  reactions ()
  i_Na  =  (comp487_gbar * comp487_Na_z) * (v - comp487_e)
  ina  =  i_Na
}


KINETIC kstates {
  asgns ()
  ~ comp487_Na_zC1 <-> comp487_Na_zC2 (comp487_n1 * comp487_alfa(v, comp487_Q10) , comp487_n4 * comp487_beta(v, comp487_Q10))
  ~ comp487_Na_zC2 <-> comp487_Na_zC3 (comp487_n2 * comp487_alfa(v, comp487_Q10) , comp487_n3 * comp487_beta(v, comp487_Q10))
  ~ comp487_Na_zC3 <-> comp487_Na_zC4 (comp487_n3 * comp487_alfa(v, comp487_Q10) , comp487_n2 * comp487_beta(v, comp487_Q10))
  ~ comp487_Na_zC4 <-> comp487_Na_zC5 (comp487_n4 * comp487_alfa(v, comp487_Q10) , comp487_n1 * comp487_beta(v, comp487_Q10))
  ~ comp487_Na_zC5 <-> comp487_Na_zO (comp487_gamma , comp487_delta)
  ~ comp487_Na_zO <-> comp487_Na_zB (comp487_epsilon , comp487_teta(v, comp487_Q10))
  ~ comp487_Na_zI1 <-> comp487_Na_zI2 (comp487_n1 * comp487_alfa(v, comp487_Q10) * comp487_a , comp487_n4 * comp487_beta(v, comp487_Q10) * comp487_b)
  ~ comp487_Na_zI2 <-> comp487_Na_zI3 (comp487_n2 * comp487_alfa(v, comp487_Q10) * comp487_a , comp487_n3 * comp487_beta(v, comp487_Q10) * comp487_b)
  ~ comp487_Na_zI3 <-> comp487_Na_zI4 (comp487_n3 * comp487_alfa(v, comp487_Q10) * comp487_a , comp487_n2 * comp487_beta(v, comp487_Q10) * comp487_b)
  ~ comp487_Na_zI4 <-> comp487_Na_zI5 (comp487_n4 * comp487_alfa(v, comp487_Q10) * comp487_a , comp487_n1 * comp487_beta(v, comp487_Q10) * comp487_b)
  ~ comp487_Na_zI5 <-> comp487_Na_zI6 (comp487_gamma , comp487_delta)
  ~ comp487_Na_zC1 <-> comp487_Na_zI1 (comp487_Con , comp487_Coff)
  ~ comp487_Na_zC2 <-> comp487_Na_zI2 (comp487_Con * comp487_a , comp487_Coff * comp487_b)
  ~ comp487_Na_zC3 <-> comp487_Na_zI3 (comp487_Con * comp487_a ^ 2.0 , comp487_Coff * comp487_b ^ 2.0)
  ~ comp487_Na_zC4 <-> comp487_Na_zI4 (comp487_Con * comp487_a ^ 3.0 , comp487_Coff * comp487_b ^ 3.0)
  ~ comp487_Na_zC5 <-> comp487_Na_zI5 (comp487_Con * comp487_a ^ 4.0 , comp487_Coff * comp487_b ^ 4.0)
  ~ comp487_Na_zO <-> comp487_Na_zI6 (comp487_Oon , comp487_Ooff)
  CONSERVE comp487_Na_zC1 + comp487_Na_zC2 + comp487_Na_zC3 + comp487_Na_zC4 + comp487_Na_zC5 + comp487_Na_zO + comp487_Na_zB + comp487_Na_zI1 + comp487_Na_zI2 + comp487_Na_zI3 + comp487_Na_zI4 + comp487_Na_zI5 + comp487_Na_zI6 = 1
}


INITIAL {
  asgns ()
  SOLVE kstates STEADYSTATE sparse
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp487_Na_z = %g\n" , t, v,  comp487_Na_z)
}
