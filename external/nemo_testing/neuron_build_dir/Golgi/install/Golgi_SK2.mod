

TITLE Golgi_SK2


NEURON {
  RANGE comp3606_vchold, comp3606_vcbase, comp3606_vcinc, comp3606_vcsteps, comp3606_vchdur, comp3606_vcbdur, comp3691_SK2_z, comp3691_gbar, comp3691_e
  RANGE i_SK2
  RANGE ik
  RANGE ek
  RANGE cai
  USEION ca READ cai
  USEION k READ ek WRITE ik
}


PARAMETER {
  comp3606_vchdur  =  30.0
  comp3691_gbar  =  0.038
  comp3691_diro2  =  1.2
  comp3691_diro1  =  0.16
  comp3691_dirc4  =  80.0
  comp3691_dirc3  =  160.0
  comp3691_dirc2  =  200.0
  ca2o  =  2.0
  comp3606_vcbdur  =  100.0
  comp3606_vcinc  =  10.0
  comp3606_vcbase  =  -69.0
  comp3606_vcsteps  =  8.0
  comp3691_invo2  =  0.1
  comp3691_invo1  =  1.0
  comp3691_diff  =  3.0
  comp3691_invc3  =  0.2
  comp3691_invc2  =  0.08
  comp3691_invc1  =  0.08
  comp3691_e  =  -84.69
  comp3606_vchold  =  -71.0
}


STATE {
  comp3691_SK2_zc1
  comp3691_SK2_zc2
  comp3691_SK2_zc3
  comp3691_SK2_zc4
  comp3691_SK2_zo1
  comp3691_SK2_zo2
  comp3691_SK2_z
}


ASSIGNED {
  comp3691_dirc2_t_ca
  comp3691_dirc3_t_ca
  comp3691_invo2_t
  comp3691_invo1_t
  comp3691_dirc4_t
  comp3691_dirc3_t
  comp3691_dirc2_t
  comp3691_dirc4_t_ca
  comp3691_invc3_t
  comp3691_invc2_t
  comp3691_invc1_t
  comp3691_Q10
  comp3691_diro2_t
  comp3691_diro1_t
  celsius
  comp3691_cai
  v
  cai
  ik
  ek
  i_SK2
}


PROCEDURE asgns () {
  comp3691_Q10  =  3.0 ^ ((celsius + -23.0) / 10.0)
  comp3691_diro1_t  =  comp3691_diro1 * comp3691_Q10
  comp3691_diro2_t  =  comp3691_diro2 * comp3691_Q10
  comp3691_invc1_t  =  comp3691_invc1 * comp3691_Q10
  comp3691_invc2_t  =  comp3691_invc2 * comp3691_Q10
  comp3691_invc3_t  =  comp3691_invc3 * comp3691_Q10
  comp3691_dirc2_t  =  comp3691_dirc2 * comp3691_Q10
  comp3691_dirc3_t  =  comp3691_dirc3 * comp3691_Q10
  comp3691_dirc4_t  =  comp3691_dirc4 * comp3691_Q10
  comp3691_invo1_t  =  comp3691_invo1 * comp3691_Q10
  comp3691_invo2_t  =  comp3691_invo2 * comp3691_Q10
  comp3691_dirc4_t_ca  =  comp3691_dirc4_t * comp3691_cai / comp3691_diff
  comp3691_dirc3_t_ca  =  comp3691_dirc3_t * comp3691_cai / comp3691_diff
  comp3691_dirc2_t_ca  =  comp3691_dirc2_t * comp3691_cai / comp3691_diff
  ek  =  comp3691_e
}


PROCEDURE reactions () {
  comp3691_SK2_z  =  comp3691_SK2_zo1 + comp3691_SK2_zo2
}


BREAKPOINT {
  SOLVE states METHOD derivimplicit
  reactions ()
  i_SK2  =  (comp3691_gbar * comp3691_SK2_z) * (v - ek)
  ik  =  i_SK2
}


DERIVATIVE states {
  comp3691_cai  =  cai
  asgns ()
  comp3691_SK2_zc1'  =  
  -(comp3691_SK2_zc1 * comp3691_dirc2_t_ca) + 
    comp3691_SK2_zc2 * comp3691_invc1_t
  comp3691_SK2_zc2'  =  
  -(comp3691_SK2_zc2 * comp3691_dirc3_t_ca + 
            comp3691_SK2_zc2 * comp3691_invc1_t) 
    + 
    comp3691_SK2_zc3 * comp3691_invc2_t + 
      comp3691_SK2_zc1 * comp3691_dirc2_t_ca
  comp3691_SK2_zc3'  =  
  -(comp3691_SK2_zc3 * comp3691_diro1_t + 
              comp3691_SK2_zc3 * comp3691_dirc4_t_ca 
            + 
            comp3691_SK2_zc3 * comp3691_invc2_t) 
    + 
    comp3691_SK2_zo1 * comp3691_invo1_t + 
        comp3691_SK2_zc4 * comp3691_invc3_t 
      + 
      comp3691_SK2_zc2 * comp3691_dirc3_t_ca
  comp3691_SK2_zo1'  =  
  -(comp3691_SK2_zo1 * comp3691_invo1_t) + 
    comp3691_SK2_zc3 * comp3691_diro1_t
  comp3691_SK2_zc4'  =  
  -(comp3691_SK2_zc4 * comp3691_diro2_t + 
            comp3691_SK2_zc4 * comp3691_invc3_t) 
    + 
    comp3691_SK2_zo2 * comp3691_invo2_t + 
      comp3691_SK2_zc3 * comp3691_dirc4_t_ca
  comp3691_SK2_zo2'  =  
  -(comp3691_SK2_zo2 * comp3691_invo2_t) + 
    comp3691_SK2_zc4 * comp3691_diro2_t
}


INITIAL {
  comp3691_cai  =  cai
  asgns ()
  ek  =  comp3691_e
}


PROCEDURE print_state () {
  printf ("NMODL state: t = %g v = %g comp3691_SK2_zc1 = %g\n" , t, v,  comp3691_SK2_zc1)
  printf ("NMODL state: t = %g v = %g comp3691_SK2_zc2 = %g\n" , t, v,  comp3691_SK2_zc2)
  printf ("NMODL state: t = %g v = %g comp3691_SK2_zc3 = %g\n" , t, v,  comp3691_SK2_zc3)
  printf ("NMODL state: t = %g v = %g comp3691_SK2_zc4 = %g\n" , t, v,  comp3691_SK2_zc4)
  printf ("NMODL state: t = %g v = %g comp3691_SK2_zo1 = %g\n" , t, v,  comp3691_SK2_zo1)
  printf ("NMODL state: t = %g v = %g comp3691_SK2_zo2 = %g\n" , t, v,  comp3691_SK2_zo2)
  printf ("NMODL state: t = %g v = %g comp3691_SK2_z = %g\n" , t, v,  comp3691_SK2_z)
}
