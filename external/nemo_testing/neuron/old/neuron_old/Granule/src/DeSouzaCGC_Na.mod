

TITLE DeSouzaCGC_Na


NEURON {
  RANGE comp2837_vchold, comp2837_vcbase, comp2837_vcinc, comp2837_vcsteps, comp2837_vchdur, comp2837_vcbdur, comp2922_Na_z, comp2922_gbar, comp2922_e
  RANGE i_Na
  RANGE ina
  RANGE ena
  USEION na READ ena WRITE ina
}


FUNCTION comp2922_alfa (v, Q10) {
  comp2922_alfa  =  Q10 * comp2922_Aalfa * exp(v / comp2922_Valfa)
}


FUNCTION comp2922_teta (v, Q10) {
  comp2922_teta  =  Q10 * comp2922_Ateta * exp(-(v) / comp2922_Vteta)
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION comp2922_beta (v, Q10) {
  comp2922_beta  =  Q10 * comp2922_Abeta * exp(-(v) / comp2922_Vbeta)
}


FUNCTION linoid (x, y) {
  LOCAL v3337
  if 
    (fabs(x / y) < 1e-06) 
     {v3337  =  y * (1.0 + -(x / y / 2.0))} 
    else {v3337  =  x / (exp(x / y) + -1.0)} 
linoid  =  v3337
}


PARAMETER {
  comp2922_AOon  =  0.75
  comp2922_Vteta  =  25.0
  comp2922_Abeta  =  1.272
  comp2837_vcbdur  =  100.0
  comp2922_ACon  =  0.005
  comp2837_vcbase  =  -60.0
  comp2922_Aalfa  =  353.91
  comp2837_vcinc  =  10.0
  comp2922_ACoff  =  0.5
  comp2922_Ateta  =  0.0201
  comp2922_Agamma  =  150.0
  comp2837_vcsteps  =  9.0
  comp2922_Adelta  =  40.0
  comp2922_n4  =  0.738
  comp2922_n3  =  1.83
  comp2922_n2  =  3.279
  comp2922_n1  =  5.422
  comp2837_vchold  =  -71.0
  comp2922_Vbeta  =  13.99
  comp2922_Aepsilon  =  1.75
  comp2837_vchdur  =  30.0
  comp2922_AOoff  =  0.005
  comp2922_Valfa  =  13.99
  comp2922_gbar  =  0.013
  comp2922_e  =  87.39
}


STATE {
  comp2922_Na_zC1
  comp2922_Na_zC2
  comp2922_Na_zC3
  comp2922_Na_zC4
  comp2922_Na_zC5
  comp2922_Na_zO
  comp2922_Na_zB
  comp2922_Na_zI1
  comp2922_Na_zI2
  comp2922_Na_zI3
  comp2922_Na_zI4
  comp2922_Na_zI5
  comp2922_Na_zI6
  comp2922_Na_z
}


ASSIGNED {
  comp2922_Coff
  comp2922_Oon
  comp2922_Q10
  comp2922_epsilon
  comp2922_Con
  comp2922_Ooff
  comp2922_gamma
  comp2922_delta
  comp2922_b
  comp2922_a
  celsius
  v
  ina
  ena
  i_Na
}


PROCEDURE asgns () {
  comp2922_Q10  =  3.0 ^ ((celsius + -20.0) / 10.0)
  comp2922_delta  =  comp2922_Q10 * comp2922_Adelta
  comp2922_gamma  =  comp2922_Q10 * comp2922_Agamma
  comp2922_Ooff  =  comp2922_Q10 * comp2922_AOoff
  comp2922_Con  =  comp2922_Q10 * comp2922_ACon
  comp2922_epsilon  =  comp2922_Q10 * comp2922_Aepsilon
  comp2922_Oon  =  comp2922_Q10 * comp2922_AOon
  comp2922_Coff  =  comp2922_Q10 * comp2922_ACoff
  comp2922_a  =  (comp2922_Oon / comp2922_Con) ^ (1.0 / 4.0)
  comp2922_b  =  (comp2922_Ooff / comp2922_Coff) ^ (1.0 / 4.0)
  ena  =  comp2922_e
}


PROCEDURE reactions () {
  comp2922_Na_z  =  comp2922_Na_zO
}


BREAKPOINT {
  SOLVE kstates METHOD sparse
  reactions ()
  i_Na  =  (comp2922_gbar * comp2922_Na_z) * (v - ena)
  ina  =  i_Na
}


KINETIC kstates {
  asgns ()
  ~ comp2922_Na_zC1 <-> comp2922_Na_zC2 (comp2922_n1 * comp2922_alfa(v, comp2922_Q10) , comp2922_n4 * comp2922_beta(v, comp2922_Q10))
  ~ comp2922_Na_zC2 <-> comp2922_Na_zC3 (comp2922_n2 * comp2922_alfa(v, comp2922_Q10) , comp2922_n3 * comp2922_beta(v, comp2922_Q10))
  ~ comp2922_Na_zC3 <-> comp2922_Na_zC4 (comp2922_n3 * comp2922_alfa(v, comp2922_Q10) , comp2922_n2 * comp2922_beta(v, comp2922_Q10))
  ~ comp2922_Na_zC4 <-> comp2922_Na_zC5 (comp2922_n4 * comp2922_alfa(v, comp2922_Q10) , comp2922_n1 * comp2922_beta(v, comp2922_Q10))
  ~ comp2922_Na_zC5 <-> comp2922_Na_zO (comp2922_gamma , comp2922_delta)
  ~ comp2922_Na_zO <-> comp2922_Na_zB (comp2922_epsilon , comp2922_teta(v, comp2922_Q10))
  ~ comp2922_Na_zI1 <-> comp2922_Na_zI2 (comp2922_n1 * comp2922_alfa(v, comp2922_Q10) * comp2922_a , comp2922_n4 * comp2922_beta(v, comp2922_Q10) * comp2922_b)
  ~ comp2922_Na_zI2 <-> comp2922_Na_zI3 (comp2922_n2 * comp2922_alfa(v, comp2922_Q10) * comp2922_a , comp2922_n3 * comp2922_beta(v, comp2922_Q10) * comp2922_b)
  ~ comp2922_Na_zI3 <-> comp2922_Na_zI4 (comp2922_n3 * comp2922_alfa(v, comp2922_Q10) * comp2922_a , comp2922_n2 * comp2922_beta(v, comp2922_Q10) * comp2922_b)
  ~ comp2922_Na_zI4 <-> comp2922_Na_zI5 (comp2922_n4 * comp2922_alfa(v, comp2922_Q10) * comp2922_a , comp2922_n1 * comp2922_beta(v, comp2922_Q10) * comp2922_b)
  ~ comp2922_Na_zI5 <-> comp2922_Na_zI6 (comp2922_gamma , comp2922_delta)
  ~ comp2922_Na_zC1 <-> comp2922_Na_zI1 (comp2922_Con , comp2922_Coff)
  ~ comp2922_Na_zC2 <-> comp2922_Na_zI2 (comp2922_Con * comp2922_a , comp2922_Coff * comp2922_b)
  ~ comp2922_Na_zC3 <-> comp2922_Na_zI3 (comp2922_Con * comp2922_a ^ 2.0 , comp2922_Coff * comp2922_b ^ 2.0)
  ~ comp2922_Na_zC4 <-> comp2922_Na_zI4 (comp2922_Con * comp2922_a ^ 3.0 , comp2922_Coff * comp2922_b ^ 3.0)
  ~ comp2922_Na_zC5 <-> comp2922_Na_zI5 (comp2922_Con * comp2922_a ^ 4.0 , comp2922_Coff * comp2922_b ^ 4.0)
  ~ comp2922_Na_zO <-> comp2922_Na_zI6 (comp2922_Oon , comp2922_Ooff)
}


INITIAL {
  asgns ()
  SOLVE kstates STEADYSTATE sparse
  ena  =  comp2922_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp2922_Na_z = %g\n" , t, v,  comp2922_Na_z)
}
