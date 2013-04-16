

TITLE Golgi_DeSouza10_SK2


NEURON {
  RANGE comp538_celsius, comp538_V_t, comp539_c, comp540_vchold, comp540_vcbase, comp540_vcinc, comp540_vcsteps, comp540_vchdur, comp540_vcbdur, comp541_SK2_z
  RANGE comp541_gbar, comp541_e
  RANGE i_SK2
  RANGE ik
  RANGE ek
  RANGE cai
  RANGE F, R
  USEION ca READ cai
  USEION k READ ki, ko WRITE ik
}


PARAMETER {
  comp541_invc3  =  0.2
  comp541_invc2  =  0.08
  comp541_invc1  =  0.08
  comp541_diff  =  3.0
  comp540_vcbase  =  -69.0
  comp541_gbar  =  0.038
  comp540_vcsteps  =  8.0
  comp541_invo2  =  0.1
  comp541_invo1  =  1.0
  comp541_dirc4  =  80.0
  comp541_dirc3  =  160.0
  comp541_dirc2  =  200.0
  comp540_vchdur  =  30.0
  comp540_vcbdur  =  100.0
  comp538_celsius  =  23.0
  comp540_vcinc  =  10.0
  R  =  8.31342
  F  =  96485.3
  comp539_c  =  1.0
  comp541_diro2  =  1.2
  comp541_diro1  =  0.16
  comp540_vchold  =  -71.0
  comp538_V_t  =  -35.0
}


STATE {
  comp541_SK2_zc1
  comp541_SK2_zc2
  comp541_SK2_zc3
  comp541_SK2_zc4
  comp541_SK2_zo1
  comp541_SK2_zo2
  comp541_SK2_z
}


ASSIGNED {
  comp541_diro2_t
  comp541_dirc4_t_ca
  comp541_invc3_t
  comp541_e
  comp541_dirc2_t
  comp541_dirc2_t_ca
  comp541_dirc3_t
  ek
  comp541_Q10
  comp541_dirc4_t
  comp541_dirc3_t_ca
  comp541_invo1_t
  ena
  comp541_invc1_t
  comp541_invo2_t
  comp541_diro1_t
  comp541_invc2_t
  ko
  ki
  celsius
  v
  comp541_cai
  nao
  nai
  cai
  ik
  i_SK2
}


PROCEDURE asgns () {
  ena  =  (1000.0 * R * (comp538_celsius + 273.15)) / F * log(nao / nai)
  comp541_Q10  =  3.0 ^ ((comp538_celsius + -23.0) / 10.0)
  ek  =  (1000.0 * R * (comp538_celsius + 273.15)) / F * log(ko / ki)
  comp541_invc2_t  =  comp541_invc2 * comp541_Q10
  comp541_diro1_t  =  comp541_diro1 * comp541_Q10
  comp541_invo2_t  =  comp541_invo2 * comp541_Q10
  comp541_invc1_t  =  comp541_invc1 * comp541_Q10
  comp541_invo1_t  =  comp541_invo1 * comp541_Q10
  comp541_dirc4_t  =  comp541_dirc4 * comp541_Q10
  comp541_dirc3_t  =  comp541_dirc3 * comp541_Q10
  comp541_dirc2_t  =  comp541_dirc2 * comp541_Q10
  comp541_e  =  ek
  comp541_invc3_t  =  comp541_invc3 * comp541_Q10
  comp541_diro2_t  =  comp541_diro2 * comp541_Q10
  comp541_dirc3_t_ca  =  comp541_dirc3_t * comp541_cai / comp541_diff
  comp541_dirc2_t_ca  =  comp541_dirc2_t * comp541_cai / comp541_diff
  comp541_dirc4_t_ca  =  comp541_dirc4_t * comp541_cai / comp541_diff
  ek  =  comp541_e
}


PROCEDURE reactions () {
  comp541_SK2_z  =  comp541_SK2_zo1 + comp541_SK2_zo2
}


BREAKPOINT {
  SOLVE kstates METHOD sparse
  reactions ()
  i_SK2  =  (comp541_gbar * comp541_SK2_z) * (v - comp541_e)
  ik  =  i_SK2
}


KINETIC kstates {
  comp541_cai  =  cai
  asgns ()
  ~ comp541_SK2_zc1 <-> comp541_SK2_zc2 (comp541_dirc2_t_ca , comp541_invc1_t)
  ~ comp541_SK2_zc2 <-> comp541_SK2_zc3 (comp541_dirc3_t_ca , comp541_invc2_t)
  ~ comp541_SK2_zc3 <-> comp541_SK2_zc4 (comp541_dirc4_t_ca , comp541_invc3_t)
  ~ comp541_SK2_zc3 <-> comp541_SK2_zo1 (comp541_diro1_t , comp541_invo1_t)
  ~ comp541_SK2_zc4 <-> comp541_SK2_zo2 (comp541_diro2_t , comp541_invo2_t)
  CONSERVE comp541_SK2_zc1 + comp541_SK2_zc2 + comp541_SK2_zc3 + comp541_SK2_zc4 + comp541_SK2_zo1 + comp541_SK2_zo2 = 1
}


INITIAL {
  comp541_cai  =  cai
  asgns ()
  SOLVE kstates STEADYSTATE sparse
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp541_SK2_z = %g\n" , t, v,  comp541_SK2_z)
}
