

TITLE Golgi_SK2


NEURON {
  RANGE comp220_vcbdur, comp220_vchdur, comp220_vcsteps, comp220_vcinc, comp220_vcbase, comp220_vchold, comp19_e, comp19_gbar, comp19_SK2_z
  RANGE i_SK2
  RANGE ik
  RANGE ek
  USEION k READ ek WRITE ik
  RANGE cai
  USEION ca READ cai
}


PARAMETER {
  comp19_invo2  =  0.1
  comp19_invo1  =  1.0
  comp19_invc3  =  0.2
  comp19_invc2  =  0.08
  comp19_invc1  =  0.08
  comp220_vcinc  =  10.0
  comp19_e  =  -84.69
  comp220_vchold  =  -71.0
  comp19_diff  =  3.0
  comp220_vchdur  =  30.0
  comp220_vcsteps  =  8.0
  comp220_vcbdur  =  100.0
  comp19_diro2  =  1.2
  comp19_diro1  =  0.16
  comp19_dirc4  =  80.0
  comp19_dirc3  =  160.0
  comp19_dirc2  =  200.0
  comp220_vcbase  =  -69.0
  comp19_gbar  =  0.038
}


STATE {
  comp19_SK2_zc1
  comp19_SK2_zc2
  comp19_SK2_zc3
  comp19_SK2_zc4
  comp19_SK2_zo1
  comp19_SK2_zo2
  comp19_SK2_z
}


ASSIGNED {
  comp19_dirc2_t_ca
  comp19_dirc3_t_ca
  comp19_invo2_t
  comp19_invo1_t
  comp19_dirc4_t
  comp19_dirc3_t
  comp19_dirc2_t
  comp19_dirc4_t_ca
  comp19_Q10
  comp19_invc3_t
  comp19_invc2_t
  comp19_invc1_t
  comp19_diro2_t
  comp19_diro1_t
  celsius
  ica
  cai
  v
  ik
  ek
  i_SK2
}


PROCEDURE asgns () {
  comp19_Q10  =  3.0 ^ ((celsius + -23.0) / 10.0)
  comp19_diro1_t  =  comp19_diro1 * comp19_Q10
  comp19_diro2_t  =  comp19_diro2 * comp19_Q10
  comp19_invc1_t  =  comp19_invc1 * comp19_Q10
  comp19_invc2_t  =  comp19_invc2 * comp19_Q10
  comp19_invc3_t  =  comp19_invc3 * comp19_Q10
  comp19_dirc2_t  =  comp19_dirc2 * comp19_Q10
  comp19_dirc3_t  =  comp19_dirc3 * comp19_Q10
  comp19_dirc4_t  =  comp19_dirc4 * comp19_Q10
  comp19_invo1_t  =  comp19_invo1 * comp19_Q10
  comp19_invo2_t  =  comp19_invo2 * comp19_Q10
  comp19_dirc4_t_ca  =  comp19_dirc4_t * cai / comp19_diff
  comp19_dirc3_t_ca  =  comp19_dirc3_t * cai / comp19_diff
  comp19_dirc2_t_ca  =  comp19_dirc2_t * cai / comp19_diff
}


PROCEDURE reactions () {
  comp19_SK2_z  =  comp19_SK2_zo1 + comp19_SK2_zo2
}


BREAKPOINT {
  SOLVE kstates METHOD sparse
  reactions ()
  i_SK2  =  (comp19_gbar * comp19_SK2_z) * (v - ek)
  ik  =  i_SK2
}


KINETIC kstates {
  asgns ()
  ~ comp19_SK2_zc1 <-> comp19_SK2_zc2 (comp19_dirc2_t_ca , comp19_invc1_t)
  ~ comp19_SK2_zc2 <-> comp19_SK2_zc3 (comp19_dirc3_t_ca , comp19_invc2_t)
  ~ comp19_SK2_zc3 <-> comp19_SK2_zc4 (comp19_dirc4_t_ca , comp19_invc3_t)
  ~ comp19_SK2_zc3 <-> comp19_SK2_zo1 (comp19_diro1_t , comp19_invo1_t)
  ~ comp19_SK2_zc4 <-> comp19_SK2_zo2 (comp19_diro2_t , comp19_invo2_t)
  CONSERVE comp19_SK2_zc1 + comp19_SK2_zc2 + comp19_SK2_zc3 + comp19_SK2_zc4 + comp19_SK2_zo2 + comp19_SK2_zo1 = 1
}


INITIAL {
  asgns ()
  SOLVE kstates STEADYSTATE sparse
  ek  =  comp19_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp19_SK2_z = %g\n" , t, v,  comp19_SK2_z)
}
