#include "Golgi.h"
#include "exceptions.h"
#include "network.h"
#include "dict.h"
#include "integerdatum.h"
#include "doubledatum.h"
#include "dictutils.h"
#include "numerics.h"
#include <limits>

#include "universal_data_logger_impl.h"

#include <iomanip>
#include <iostream>
#include <cstdio>
#include <cmath>

#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_sf_exp.h>

#include <gsl/gsl_multimin.h>
namespace nest {




double comp1285_tau_fast (double potential, double t1, double t2, double t3, const void* params) ;




double comp949_o_inf (double potential, double Ehalf, double c, const void* params) ;




double comp3094_alpha_v (double v, double Q10, const void* params) ;




double comp217_alpha_u (double v, double Q10, const void* params) ;




double comp3094_alpha_u (double v, double Q10, const void* params) ;




double comp217_alpha_s (double v, double Q10, const void* params) ;




double comp3736_alpha_s (double v, double Q10, const void* params) ;




double comp2298_alpha_n (double v, double Q10, const void* params) ;




double comp2559_alpha_n (double v, double Q10, const void* params) ;




double comp3459_alpha_m (double v, double Q10, const void* params) ;




double comp3736_alpha_f (double v, double Q10, const void* params) ;




double comp2062_alpha_c (double v, double cai, double Q10, const void* params) ;




double comp1641_alpha_b (double v, double Q10, const void* params) ;




double comp1641_alpha_a (double v, double Q10, const void* params) ;




double comp2559_linoid (double x, double y, const void* params) ;




double comp3459_linoid (double x, double y, const void* params) ;




double comp1285_tau_slow (double potential, double t1, double t2, double t3, const void* params) ;




double comp217_beta_u (double v, double Q10, const void* params) ;




double comp217_beta_s (double v, double Q10, const void* params) ;




double comp1285_o_inf (double potential, double Ehalf, double c, const void* params) ;




double comp3094_linoid (double x, double y, const void* params) ;




double comp3736_beta_s (double v, double Q10, const void* params) ;




double comp3736_beta_f (double v, double Q10, const void* params) ;




double comp2062_beta_c (double v, double cai, double Q10, const void* params) ;




double comp2559_beta_n (double v, double Q10, const void* params) ;




double comp3459_beta_m (double v, double Q10, const void* params) ;




double comp1641_beta_b (double v, double Q10, const void* params) ;




double comp1641_beta_a (double v, double Q10, const void* params) ;




double comp1285_r (double potential, double r1, double r2, const void* params) ;




double comp3094_beta_v (double v, double Q10, const void* params) ;




double comp3094_beta_u (double v, double Q10, const void* params) ;




double comp2298_beta_n (double v, double Q10, const void* params) ;




double comp949_tau (double potential, double t1, double t2, double t3, const void* params) ;




double comp949_r (double potential, const void* params) ;




double comp1641_sigm (double x, double y, const void* params) ;




double comp1285_tau_fast (double potential, double t1, double t2, double t3, const void* params) {
  double rv4655 ;
  rv4655  =  0.0;
  return rv4655;
}




double comp949_o_inf (double potential, double Ehalf, double c, const void* params) {
  double rv4656 ;
  rv4656  =  0.0;
  return rv4656;
}




double comp3094_alpha_v (double v, double Q10, const void* params) {
  double rv4657 ;
  rv4657  =  0.0;
  return rv4657;
}




double comp217_alpha_u (double v, double Q10, const void* params) {
  double rv4658 ;
  rv4658  =  0.0;
  return rv4658;
}




double comp3094_alpha_u (double v, double Q10, const void* params) {
  double rv4659 ;
  rv4659  =  0.0;
  return rv4659;
}




double comp217_alpha_s (double v, double Q10, const void* params) {
  double rv4660 ;
  rv4660  =  0.0;
  return rv4660;
}




double comp3736_alpha_s (double v, double Q10, const void* params) {
  double rv4661 ;
  rv4661  =  0.0;
  return rv4661;
}




double comp2298_alpha_n (double v, double Q10, const void* params) {
  double rv4662 ;
  rv4662  =  0.0;
  return rv4662;
}




double comp2559_alpha_n (double v, double Q10, const void* params) {
  double rv4663 ;
  rv4663  =  0.0;
  return rv4663;
}




double comp3459_alpha_m (double v, double Q10, const void* params) {
  double rv4664 ;
  rv4664  =  0.0;
  return rv4664;
}




double comp3736_alpha_f (double v, double Q10, const void* params) {
  double rv4665 ;
  rv4665  =  0.0;
  return rv4665;
}




double comp2062_alpha_c (double v, double cai, double Q10, const void* params) {
  double rv4666 ;
  rv4666  =  0.0;
  return rv4666;
}




double comp1641_alpha_b (double v, double Q10, const void* params) {
  double rv4667 ;
  rv4667  =  0.0;
  return rv4667;
}




double comp1641_alpha_a (double v, double Q10, const void* params) {
  double rv4668 ;
  rv4668  =  0.0;
  return rv4668;
}




double comp2559_linoid (double x, double y, const void* params) {
  double rv4669 ;
  rv4669  =  0.0;
  return rv4669;
}




double comp3459_linoid (double x, double y, const void* params) {
  double rv4670 ;
  rv4670  =  0.0;
  return rv4670;
}




double comp1285_tau_slow (double potential, double t1, double t2, double t3, const void* params) {
  double rv4671 ;
  rv4671  =  0.0;
  return rv4671;
}




double comp217_beta_u (double v, double Q10, const void* params) {
  double rv4672 ;
  rv4672  =  0.0;
  return rv4672;
}




double comp217_beta_s (double v, double Q10, const void* params) {
  double rv4673 ;
  rv4673  =  0.0;
  return rv4673;
}




double comp1285_o_inf (double potential, double Ehalf, double c, const void* params) {
  double rv4674 ;
  rv4674  =  0.0;
  return rv4674;
}




double comp3094_linoid (double x, double y, const void* params) {
  double rv4675 ;
  rv4675  =  0.0;
  return rv4675;
}




double comp3736_beta_s (double v, double Q10, const void* params) {
  double rv4676 ;
  rv4676  =  0.0;
  return rv4676;
}




double comp3736_beta_f (double v, double Q10, const void* params) {
  double rv4677 ;
  rv4677  =  0.0;
  return rv4677;
}




double comp2062_beta_c (double v, double cai, double Q10, const void* params) {
  double rv4678 ;
  rv4678  =  0.0;
  return rv4678;
}




double comp2559_beta_n (double v, double Q10, const void* params) {
  double rv4679 ;
  rv4679  =  0.0;
  return rv4679;
}




double comp3459_beta_m (double v, double Q10, const void* params) {
  double rv4680 ;
  rv4680  =  0.0;
  return rv4680;
}




double comp1641_beta_b (double v, double Q10, const void* params) {
  double rv4681 ;
  rv4681  =  0.0;
  return rv4681;
}




double comp1641_beta_a (double v, double Q10, const void* params) {
  double rv4682 ;
  rv4682  =  0.0;
  return rv4682;
}




double comp1285_r (double potential, double r1, double r2, const void* params) {
  double rv4683 ;
  rv4683  =  0.0;
  return rv4683;
}




double comp3094_beta_v (double v, double Q10, const void* params) {
  double rv4684 ;
  rv4684  =  0.0;
  return rv4684;
}




double comp3094_beta_u (double v, double Q10, const void* params) {
  double rv4685 ;
  rv4685  =  0.0;
  return rv4685;
}




double comp2298_beta_n (double v, double Q10, const void* params) {
  double rv4686 ;
  rv4686  =  0.0;
  return rv4686;
}




double comp949_tau (double potential, double t1, double t2, double t3, const void* params) {
  double rv4687 ;
  rv4687  =  0.0;
  return rv4687;
}




double comp949_r (double potential, const void* params) {
  double rv4688 ;
  rv4688  =  0.0;
  return rv4688;
}




double comp1641_sigm (double x, double y, const void* params) {
  double rv4689 ;
  rv4689  =  0.0;
  return rv4689;
}




extern "C" int Golgi_dynamics (double t, const double y[], double f[], void* pnode) {
  double v4696, v4697, v4698, v4699, v4700, v4690, v4691, v4692, v4693, v4694, v4695, comp2808_diro1_t, comp949_tau_f, comp949_tau_s, comp2808_diro2_t, comp2559_Q10, CaLVA_h_inf, CaHVA_h_inf, KM_m_tau, comp3459_Q10, CaLVA_h_tau, CaHVA_h_tau, comp1641_a_inf, comp2808_invc1_t, KA_h_inf, comp2808_invc2_t, comp2808_invc3_t, comp217_Q10, KA_h_tau, comp566_h_inf, comp2062_Q10, comp566_e, comp1641_tau_a, comp1641_tau_b, NaP_m_inf, comp1641_b_inf, comp566_tau_h, comp566_tau_m, CaLVA_m_inf, CaHVA_m_inf, comp2808_dirc4_t_ca, comp2808_dirc2_t, comp2808_dirc3_t, comp2808_dirc4_t, comp1285_o_slow_inf, comp949_o_slow_inf, comp566_phi_h, comp3094_Q10, comp566_phi_m, NaP_m_tau, comp2808_invo1_t, comp2808_invo2_t, CaLVA_m_tau, CaHVA_m_tau, KA_m_inf, comp1641_Q10, comp2808_dirc3_t_ca, comp1285_tau_f, comp1285_tau_s, comp2298_Q10, comp3736_Q10, KA_m_tau, comp566_m_inf, comp2808_Q10, comp2808_dirc2_t_ca, KM_m_inf, comp1285_o_fast_inf, comp949_o_fast_inf, Na_hO, Na_h, Na_mO, Na_m, comp2808_SK2_zo2, comp2808_SK2_zo1, comp2808_SK2_z, NaR_hO, NaR_h, NaR_mO, NaR_m, KV_mO, KV_m, KCa_mO, KCa_m, comp33_ca, cai, comp118_ca2, ca2i, comp2808_cai, comp118_ica2, comp33_ica, comp2062_cai, comp566_ca2i, comp566_ca2o, comp1285_o_slow, comp949_o_slow, comp1285_o_fast, comp949_o_fast, comp2808_SK2_zc4, comp2808_SK2_zc3, comp2808_SK2_zc2, comp2808_SK2_zc1, CaLVA_h, CaLVA_m, KA_h, KA_m, KM_m, NaP_m, CaHVA_h, CaHVA_m, v, i_NaR, i_NaP, i_Na, ina, i_KCa, i_KA, i_SK2, i_KV, i_KM, ik, i_CaLVA, ica2, i_CaHVA, ica, i_HCN1, i_HCN2, i_Lkg, i, comp2559_gbar, comp3094_Kalpha_v, comp217_Kalpha_u, comp3094_Kalpha_u, comp217_Kalpha_s, comp3736_Kalpha_s, comp2298_Kalpha_n, comp2559_Kalpha_n, comp3459_Kalpha_m, comp3736_Kalpha_f, comp2062_Kalpha_c, comp1641_Kalpha_b, comp1641_Kalpha_a, comp1556_vchdur, comp949_gbar, comp481_vchold, comp3009_vchold, comp3651_vchold, comp118_beta, comp3009_vcinc, comp3094_V0beta_v, comp217_V0beta_u, comp3094_V0beta_u, comp217_V0beta_s, comp3736_V0beta_s, comp2298_V0beta_n, comp2559_V0beta_n, comp3459_V0beta_m, comp3736_V0beta_f, comp1641_V0beta_b, comp1641_V0beta_a, comp3651_vcinc, comp2298_V0_ninf, comp1977_vcbdur, comp2213_vcbdur, comp2723_vcbdur, comp2298_B_ninf, comp3094_Kbeta_v, comp217_Kbeta_u, comp3094_Kbeta_u, comp217_Kbeta_s, comp3736_Kbeta_s, comp2298_Kbeta_n, comp2559_Kbeta_n, comp3459_Kbeta_m, comp3736_Kbeta_f, comp2062_Kbeta_c, comp1641_Kbeta_b, comp1641_Kbeta_a, comp949_rB, comp949_rA, comp2062_Balpha_c, comp1977_vcbase, comp2213_vcbase, comp2723_vcbase, comp2062_gbar, comp4113_gbar, comp1285_Ehalf, comp481_vchdur, comp3009_vchdur, comp3651_vchdur, comp566_k_h_inf, comp864_vchold, comp1200_vchold, comp2474_vchold, comp3374_vchold, comp4028_vchold, comp2808_diro2, comp2808_diro1, comp2808_diff, comp2808_dirc4, comp2808_dirc3, comp2808_dirc2, ca2o, comp1641_e, comp3736_gbar, comp1556_vcbdur, comp118_valence, comp566_valence, comp566_C_tau_m, comp566_C_tau_h, comp566_v0_tau_m2, comp566_v0_tau_m1, comp566_v0_tau_h2, comp566_v0_tau_h1, comp1556_vcbase, comp3094_gbar, comp3459_V0_minf, comp566_v0_m_inf, comp864_vchdur, comp1200_vchdur, comp2474_vchdur, comp3374_vchdur, comp4028_vchdur, comp2298_gbar, comp566_gbar, comp3094_e, comp1977_vcinc, comp33_cai0, comp481_vcbdur, comp3009_vcbdur, comp3651_vcbdur, comp1641_gbar, comp2559_e, comp566_A_tau_m, comp566_A_tau_h, comp217_e, comp4028_vcinc, comp118_ca2i0, comp566_k_tau_m2, comp566_k_tau_m1, comp566_k_tau_h2, comp566_k_tau_h1, comp481_vcbase, comp3009_vcbase, comp3651_vcbase, comp3736_e, comp566_shift, comp3459_gbar, comp566_R, comp566_F, comp2298_e, comp33_beta, comp481_vcsteps, comp864_vcsteps, comp1200_vcsteps, comp1556_vcsteps, comp1977_vcsteps, comp2213_vcsteps, comp2474_vcsteps, comp2723_vcsteps, comp3009_vcsteps, comp3374_vcsteps, comp3651_vcsteps, comp4028_vcsteps, comp864_vcbdur, comp1200_vcbdur, comp2474_vcbdur, comp3374_vcbdur, comp4028_vcbdur, comp2808_e, comp2474_vcinc, comp3374_vcinc, comp1285_tEs, comp1641_V0_binf, comp1285_tEf, comp1285_tDs, comp1285_e, comp1285_c, comp1285_tDf, comp1285_tCs, comp1285_tCf, comp33_cao, comp864_vcbase, comp1200_vcbase, comp2474_vcbase, comp3374_vcbase, comp4028_vcbase, comp2808_invo2, comp2808_invo1, comp2808_invc3, comp2808_invc2, comp2808_invc1, comp481_vcinc, comp3094_Aalpha_v, comp217_Aalpha_u, comp3094_Aalpha_u, comp217_Aalpha_s, comp3736_Aalpha_s, comp2298_Aalpha_n, comp2559_Aalpha_n, comp3459_Aalpha_m, comp949_tEs, comp3736_Aalpha_f, comp2062_Aalpha_c, comp1641_Aalpha_b, comp1641_Aalpha_a, comp949_tEf, comp949_tDs, comp949_tDf, comp949_tCs, comp949_tCf, comp566_k_m_inf, comp2808_gbar, comp949_e, comp949_c, comp1641_K_binf, comp1200_vcinc, comp33_d, comp33_F, comp118_d, comp118_F, comp864_vcinc, comp217_gbar, comp1977_vchold, comp2213_vchold, comp2723_vchold, comp1556_vcinc, comp2062_Bbeta_c, comp3736_Shiftbeta_s, comp3459_B_minf, comp1641_V0_ainf, comp2723_vcinc, comp2062_e, comp566_v0_h_inf, comp3094_V0alpha_v, comp217_V0alpha_u, comp3094_V0alpha_u, comp217_V0alpha_s, comp3736_V0alpha_s, comp3736_Shiftalpha_s, comp2298_V0alpha_n, comp2559_V0alpha_n, comp3459_V0alpha_m, comp3736_V0alpha_f, comp1641_V0alpha_b, comp1641_V0alpha_a, comp3094_Abeta_v, comp217_Abeta_u, comp3094_Abeta_u, comp217_Abeta_s, comp3736_Abeta_s, comp2298_Abeta_n, comp2559_Abeta_n, comp3459_Abeta_m, comp3736_Abeta_f, comp2062_Abeta_c, comp1641_Abeta_b, comp1641_Abeta_a, comp1285_gbar, comp1977_vchdur, comp2213_vchdur, comp2723_vchdur, comp949_Ehalf, comp1556_vchold, comp1641_K_ainf, comp4113_e, comp3459_e, comp1285_rB, comp1285_rA, comp118_ca2o, comp2213_vcinc ;
  

  // S is shorthand for the type that describes the model state 
  typedef Golgi::State_ S;
  

  // cast the node ptr to an object of the proper type
  assert(pnode);
  const  Golgi & node =  *(reinterpret_cast< Golgi *>(pnode));
  

  // params is a reference to the model parameters 
  const struct Golgi::Parameters_ *params;
  params = &(node.P_);
  

  // y[] must be the state vector supplied by the integrator, 
  // not the state vector in the node, node.S_.y[]. 
  

  comp2808_cai  =  cai;
  comp118_ica2  =  ica2;
  comp33_ica  =  ica;
  comp2062_cai  =  cai;
  comp566_ca2i  =  ca2i;
  comp566_ca2o  =  ca2o;
  comp2559_gbar  =  params->comp2559_gbar;
  comp3094_Kalpha_v  =  params->comp3094_Kalpha_v;
  comp217_Kalpha_u  =  params->comp217_Kalpha_u;
  comp3094_Kalpha_u  =  params->comp3094_Kalpha_u;
  comp217_Kalpha_s  =  params->comp217_Kalpha_s;
  comp3736_Kalpha_s  =  params->comp3736_Kalpha_s;
  comp2298_Kalpha_n  =  params->comp2298_Kalpha_n;
  comp2559_Kalpha_n  =  params->comp2559_Kalpha_n;
  comp3459_Kalpha_m  =  params->comp3459_Kalpha_m;
  comp3736_Kalpha_f  =  params->comp3736_Kalpha_f;
  comp2062_Kalpha_c  =  params->comp2062_Kalpha_c;
  comp1641_Kalpha_b  =  params->comp1641_Kalpha_b;
  comp1641_Kalpha_a  =  params->comp1641_Kalpha_a;
  comp1556_vchdur  =  params->comp1556_vchdur;
  comp949_gbar  =  params->comp949_gbar;
  comp481_vchold  =  params->comp481_vchold;
  comp3009_vchold  =  params->comp3009_vchold;
  comp3651_vchold  =  params->comp3651_vchold;
  comp118_beta  =  params->comp118_beta;
  comp3009_vcinc  =  params->comp3009_vcinc;
  comp3094_V0beta_v  =  params->comp3094_V0beta_v;
  comp217_V0beta_u  =  params->comp217_V0beta_u;
  comp3094_V0beta_u  =  params->comp3094_V0beta_u;
  comp217_V0beta_s  =  params->comp217_V0beta_s;
  comp3736_V0beta_s  =  params->comp3736_V0beta_s;
  comp2298_V0beta_n  =  params->comp2298_V0beta_n;
  comp2559_V0beta_n  =  params->comp2559_V0beta_n;
  comp3459_V0beta_m  =  params->comp3459_V0beta_m;
  comp3736_V0beta_f  =  params->comp3736_V0beta_f;
  comp1641_V0beta_b  =  params->comp1641_V0beta_b;
  comp1641_V0beta_a  =  params->comp1641_V0beta_a;
  comp3651_vcinc  =  params->comp3651_vcinc;
  comp2298_V0_ninf  =  params->comp2298_V0_ninf;
  comp1977_vcbdur  =  params->comp1977_vcbdur;
  comp2213_vcbdur  =  params->comp2213_vcbdur;
  comp2723_vcbdur  =  params->comp2723_vcbdur;
  comp2298_B_ninf  =  params->comp2298_B_ninf;
  comp3094_Kbeta_v  =  params->comp3094_Kbeta_v;
  comp217_Kbeta_u  =  params->comp217_Kbeta_u;
  comp3094_Kbeta_u  =  params->comp3094_Kbeta_u;
  comp217_Kbeta_s  =  params->comp217_Kbeta_s;
  comp3736_Kbeta_s  =  params->comp3736_Kbeta_s;
  comp2298_Kbeta_n  =  params->comp2298_Kbeta_n;
  comp2559_Kbeta_n  =  params->comp2559_Kbeta_n;
  comp3459_Kbeta_m  =  params->comp3459_Kbeta_m;
  comp3736_Kbeta_f  =  params->comp3736_Kbeta_f;
  comp2062_Kbeta_c  =  params->comp2062_Kbeta_c;
  comp1641_Kbeta_b  =  params->comp1641_Kbeta_b;
  comp1641_Kbeta_a  =  params->comp1641_Kbeta_a;
  comp949_rB  =  params->comp949_rB;
  comp949_rA  =  params->comp949_rA;
  comp2062_Balpha_c  =  params->comp2062_Balpha_c;
  comp1977_vcbase  =  params->comp1977_vcbase;
  comp2213_vcbase  =  params->comp2213_vcbase;
  comp2723_vcbase  =  params->comp2723_vcbase;
  comp2062_gbar  =  params->comp2062_gbar;
  comp4113_gbar  =  params->comp4113_gbar;
  comp1285_Ehalf  =  params->comp1285_Ehalf;
  comp481_vchdur  =  params->comp481_vchdur;
  comp3009_vchdur  =  params->comp3009_vchdur;
  comp3651_vchdur  =  params->comp3651_vchdur;
  comp566_k_h_inf  =  params->comp566_k_h_inf;
  comp864_vchold  =  params->comp864_vchold;
  comp1200_vchold  =  params->comp1200_vchold;
  comp2474_vchold  =  params->comp2474_vchold;
  comp3374_vchold  =  params->comp3374_vchold;
  comp4028_vchold  =  params->comp4028_vchold;
  comp2808_diro2  =  params->comp2808_diro2;
  comp2808_diro1  =  params->comp2808_diro1;
  comp2808_diff  =  params->comp2808_diff;
  comp2808_dirc4  =  params->comp2808_dirc4;
  comp2808_dirc3  =  params->comp2808_dirc3;
  comp2808_dirc2  =  params->comp2808_dirc2;
  ca2o  =  params->ca2o;
  comp1641_e  =  params->comp1641_e;
  comp3736_gbar  =  params->comp3736_gbar;
  comp1556_vcbdur  =  params->comp1556_vcbdur;
  comp118_valence  =  params->comp118_valence;
  comp566_valence  =  params->comp566_valence;
  comp566_C_tau_m  =  params->comp566_C_tau_m;
  comp566_C_tau_h  =  params->comp566_C_tau_h;
  comp566_v0_tau_m2  =  params->comp566_v0_tau_m2;
  comp566_v0_tau_m1  =  params->comp566_v0_tau_m1;
  comp566_v0_tau_h2  =  params->comp566_v0_tau_h2;
  comp566_v0_tau_h1  =  params->comp566_v0_tau_h1;
  comp1556_vcbase  =  params->comp1556_vcbase;
  comp3094_gbar  =  params->comp3094_gbar;
  comp3459_V0_minf  =  params->comp3459_V0_minf;
  comp566_v0_m_inf  =  params->comp566_v0_m_inf;
  comp864_vchdur  =  params->comp864_vchdur;
  comp1200_vchdur  =  params->comp1200_vchdur;
  comp2474_vchdur  =  params->comp2474_vchdur;
  comp3374_vchdur  =  params->comp3374_vchdur;
  comp4028_vchdur  =  params->comp4028_vchdur;
  comp2298_gbar  =  params->comp2298_gbar;
  comp566_gbar  =  params->comp566_gbar;
  comp3094_e  =  params->comp3094_e;
  comp1977_vcinc  =  params->comp1977_vcinc;
  comp33_cai0  =  params->comp33_cai0;
  comp481_vcbdur  =  params->comp481_vcbdur;
  comp3009_vcbdur  =  params->comp3009_vcbdur;
  comp3651_vcbdur  =  params->comp3651_vcbdur;
  comp1641_gbar  =  params->comp1641_gbar;
  comp2559_e  =  params->comp2559_e;
  comp566_A_tau_m  =  params->comp566_A_tau_m;
  comp566_A_tau_h  =  params->comp566_A_tau_h;
  comp217_e  =  params->comp217_e;
  comp4028_vcinc  =  params->comp4028_vcinc;
  comp118_ca2i0  =  params->comp118_ca2i0;
  comp566_k_tau_m2  =  params->comp566_k_tau_m2;
  comp566_k_tau_m1  =  params->comp566_k_tau_m1;
  comp566_k_tau_h2  =  params->comp566_k_tau_h2;
  comp566_k_tau_h1  =  params->comp566_k_tau_h1;
  comp481_vcbase  =  params->comp481_vcbase;
  comp3009_vcbase  =  params->comp3009_vcbase;
  comp3651_vcbase  =  params->comp3651_vcbase;
  comp3736_e  =  params->comp3736_e;
  comp566_shift  =  params->comp566_shift;
  comp3459_gbar  =  params->comp3459_gbar;
  comp566_R  =  params->comp566_R;
  comp566_F  =  params->comp566_F;
  comp2298_e  =  params->comp2298_e;
  comp33_beta  =  params->comp33_beta;
  comp481_vcsteps  =  params->comp481_vcsteps;
  comp864_vcsteps  =  params->comp864_vcsteps;
  comp1200_vcsteps  =  params->comp1200_vcsteps;
  comp1556_vcsteps  =  params->comp1556_vcsteps;
  comp1977_vcsteps  =  params->comp1977_vcsteps;
  comp2213_vcsteps  =  params->comp2213_vcsteps;
  comp2474_vcsteps  =  params->comp2474_vcsteps;
  comp2723_vcsteps  =  params->comp2723_vcsteps;
  comp3009_vcsteps  =  params->comp3009_vcsteps;
  comp3374_vcsteps  =  params->comp3374_vcsteps;
  comp3651_vcsteps  =  params->comp3651_vcsteps;
  comp4028_vcsteps  =  params->comp4028_vcsteps;
  comp864_vcbdur  =  params->comp864_vcbdur;
  comp1200_vcbdur  =  params->comp1200_vcbdur;
  comp2474_vcbdur  =  params->comp2474_vcbdur;
  comp3374_vcbdur  =  params->comp3374_vcbdur;
  comp4028_vcbdur  =  params->comp4028_vcbdur;
  comp2808_e  =  params->comp2808_e;
  comp2474_vcinc  =  params->comp2474_vcinc;
  comp3374_vcinc  =  params->comp3374_vcinc;
  comp1285_tEs  =  params->comp1285_tEs;
  comp1641_V0_binf  =  params->comp1641_V0_binf;
  comp1285_tEf  =  params->comp1285_tEf;
  comp1285_tDs  =  params->comp1285_tDs;
  comp1285_e  =  params->comp1285_e;
  comp1285_c  =  params->comp1285_c;
  comp1285_tDf  =  params->comp1285_tDf;
  comp1285_tCs  =  params->comp1285_tCs;
  comp1285_tCf  =  params->comp1285_tCf;
  comp33_cao  =  params->comp33_cao;
  comp864_vcbase  =  params->comp864_vcbase;
  comp1200_vcbase  =  params->comp1200_vcbase;
  comp2474_vcbase  =  params->comp2474_vcbase;
  comp3374_vcbase  =  params->comp3374_vcbase;
  comp4028_vcbase  =  params->comp4028_vcbase;
  comp2808_invo2  =  params->comp2808_invo2;
  comp2808_invo1  =  params->comp2808_invo1;
  comp2808_invc3  =  params->comp2808_invc3;
  comp2808_invc2  =  params->comp2808_invc2;
  comp2808_invc1  =  params->comp2808_invc1;
  comp481_vcinc  =  params->comp481_vcinc;
  comp3094_Aalpha_v  =  params->comp3094_Aalpha_v;
  comp217_Aalpha_u  =  params->comp217_Aalpha_u;
  comp3094_Aalpha_u  =  params->comp3094_Aalpha_u;
  comp217_Aalpha_s  =  params->comp217_Aalpha_s;
  comp3736_Aalpha_s  =  params->comp3736_Aalpha_s;
  comp2298_Aalpha_n  =  params->comp2298_Aalpha_n;
  comp2559_Aalpha_n  =  params->comp2559_Aalpha_n;
  comp3459_Aalpha_m  =  params->comp3459_Aalpha_m;
  comp949_tEs  =  params->comp949_tEs;
  comp3736_Aalpha_f  =  params->comp3736_Aalpha_f;
  comp2062_Aalpha_c  =  params->comp2062_Aalpha_c;
  comp1641_Aalpha_b  =  params->comp1641_Aalpha_b;
  comp1641_Aalpha_a  =  params->comp1641_Aalpha_a;
  comp949_tEf  =  params->comp949_tEf;
  comp949_tDs  =  params->comp949_tDs;
  comp949_tDf  =  params->comp949_tDf;
  comp949_tCs  =  params->comp949_tCs;
  comp949_tCf  =  params->comp949_tCf;
  comp566_k_m_inf  =  params->comp566_k_m_inf;
  comp2808_gbar  =  params->comp2808_gbar;
  comp949_e  =  params->comp949_e;
  comp949_c  =  params->comp949_c;
  comp1641_K_binf  =  params->comp1641_K_binf;
  comp1200_vcinc  =  params->comp1200_vcinc;
  comp33_d  =  params->comp33_d;
  comp33_F  =  params->comp33_F;
  comp118_d  =  params->comp118_d;
  comp118_F  =  params->comp118_F;
  comp864_vcinc  =  params->comp864_vcinc;
  comp217_gbar  =  params->comp217_gbar;
  comp1977_vchold  =  params->comp1977_vchold;
  comp2213_vchold  =  params->comp2213_vchold;
  comp2723_vchold  =  params->comp2723_vchold;
  comp1556_vcinc  =  params->comp1556_vcinc;
  comp2062_Bbeta_c  =  params->comp2062_Bbeta_c;
  comp3736_Shiftbeta_s  =  params->comp3736_Shiftbeta_s;
  comp3459_B_minf  =  params->comp3459_B_minf;
  comp1641_V0_ainf  =  params->comp1641_V0_ainf;
  comp2723_vcinc  =  params->comp2723_vcinc;
  comp2062_e  =  params->comp2062_e;
  comp566_v0_h_inf  =  params->comp566_v0_h_inf;
  comp3094_V0alpha_v  =  params->comp3094_V0alpha_v;
  comp217_V0alpha_u  =  params->comp217_V0alpha_u;
  comp3094_V0alpha_u  =  params->comp3094_V0alpha_u;
  comp217_V0alpha_s  =  params->comp217_V0alpha_s;
  comp3736_V0alpha_s  =  params->comp3736_V0alpha_s;
  comp3736_Shiftalpha_s  =  params->comp3736_Shiftalpha_s;
  comp2298_V0alpha_n  =  params->comp2298_V0alpha_n;
  comp2559_V0alpha_n  =  params->comp2559_V0alpha_n;
  comp3459_V0alpha_m  =  params->comp3459_V0alpha_m;
  comp3736_V0alpha_f  =  params->comp3736_V0alpha_f;
  comp1641_V0alpha_b  =  params->comp1641_V0alpha_b;
  comp1641_V0alpha_a  =  params->comp1641_V0alpha_a;
  comp3094_Abeta_v  =  params->comp3094_Abeta_v;
  comp217_Abeta_u  =  params->comp217_Abeta_u;
  comp3094_Abeta_u  =  params->comp3094_Abeta_u;
  comp217_Abeta_s  =  params->comp217_Abeta_s;
  comp3736_Abeta_s  =  params->comp3736_Abeta_s;
  comp2298_Abeta_n  =  params->comp2298_Abeta_n;
  comp2559_Abeta_n  =  params->comp2559_Abeta_n;
  comp3459_Abeta_m  =  params->comp3459_Abeta_m;
  comp3736_Abeta_f  =  params->comp3736_Abeta_f;
  comp2062_Abeta_c  =  params->comp2062_Abeta_c;
  comp1641_Abeta_b  =  params->comp1641_Abeta_b;
  comp1641_Abeta_a  =  params->comp1641_Abeta_a;
  comp1285_gbar  =  params->comp1285_gbar;
  comp1977_vchdur  =  params->comp1977_vchdur;
  comp2213_vchdur  =  params->comp2213_vchdur;
  comp2723_vchdur  =  params->comp2723_vchdur;
  comp949_Ehalf  =  params->comp949_Ehalf;
  comp1556_vchold  =  params->comp1556_vchold;
  comp1641_K_ainf  =  params->comp1641_K_ainf;
  comp4113_e  =  params->comp4113_e;
  comp3459_e  =  params->comp3459_e;
  comp1285_rB  =  params->comp1285_rB;
  comp1285_rA  =  params->comp1285_rA;
  comp118_ca2o  =  params->comp118_ca2o;
  comp2213_vcinc  =  params->comp2213_vcinc;
  v  =  y[0];
  CaHVA_m  =  y[1];
  CaHVA_h  =  y[2];
  NaP_m  =  y[3];
  KM_m  =  y[4];
  KA_m  =  y[5];
  KA_h  =  y[6];
  CaLVA_m  =  y[7];
  CaLVA_h  =  y[8];
  comp118_ca2  =  y[9];
  KCa_mO  =  y[10];
  KV_mO  =  y[11];
  NaR_mO  =  y[12];
  NaR_hO  =  y[13];
  comp2808_SK2_zc1  =  y[14];
  comp2808_SK2_zc2  =  y[15];
  comp2808_SK2_zc3  =  y[16];
  comp2808_SK2_zo1  =  y[17];
  comp2808_SK2_zc4  =  y[18];
  comp2808_SK2_zo2  =  y[19];
  Na_mO  =  y[20];
  Na_hO  =  y[21];
  comp949_o_fast  =  y[22];
  comp1285_o_fast  =  y[23];
  comp33_ca  =  y[24];
  comp949_o_slow  =  y[25];
  comp1285_o_slow  =  y[26];
  comp2808_diro1_t  =  0.0;
  comp949_tau_f  =  0.0;
  comp949_tau_s  =  0.0;
  comp2808_diro2_t  =  0.0;
  comp2559_Q10  =  0.0;
  CaLVA_h_inf  =  0.0;
  CaHVA_h_inf  =  0.0;
  KM_m_tau  =  0.0;
  comp3459_Q10  =  0.0;
  CaLVA_h_tau  =  0.0;
  CaHVA_h_tau  =  0.0;
  comp1641_a_inf  =  0.0;
  comp2808_invc1_t  =  0.0;
  KA_h_inf  =  0.0;
  comp2808_invc2_t  =  0.0;
  comp2808_invc3_t  =  0.0;
  comp217_Q10  =  0.0;
  KA_h_tau  =  0.0;
  comp566_h_inf  =  0.0;
  comp2062_Q10  =  0.0;
  comp566_e  =  0.0;
  comp1641_tau_a  =  0.0;
  comp1641_tau_b  =  0.0;
  NaP_m_inf  =  0.0;
  comp1641_b_inf  =  0.0;
  comp566_tau_h  =  0.0;
  comp566_tau_m  =  0.0;
  CaLVA_m_inf  =  0.0;
  CaHVA_m_inf  =  0.0;
  comp2808_dirc4_t_ca  =  0.0;
  comp2808_dirc2_t  =  0.0;
  comp2808_dirc3_t  =  0.0;
  comp2808_dirc4_t  =  0.0;
  comp1285_o_slow_inf  =  0.0;
  comp949_o_slow_inf  =  0.0;
  comp566_phi_h  =  0.0;
  comp3094_Q10  =  0.0;
  comp566_phi_m  =  0.0;
  NaP_m_tau  =  0.0;
  comp2808_invo1_t  =  0.0;
  comp2808_invo2_t  =  0.0;
  CaLVA_m_tau  =  0.0;
  CaHVA_m_tau  =  0.0;
  KA_m_inf  =  0.0;
  comp1641_Q10  =  0.0;
  comp2808_dirc3_t_ca  =  0.0;
  comp1285_tau_f  =  0.0;
  comp1285_tau_s  =  0.0;
  comp2298_Q10  =  0.0;
  comp3736_Q10  =  0.0;
  KA_m_tau  =  0.0;
  comp566_m_inf  =  0.0;
  comp2808_Q10  =  0.0;
  comp2808_dirc2_t_ca  =  0.0;
  KM_m_inf  =  0.0;
  comp1285_o_fast_inf  =  0.0;
  comp949_o_fast_inf  =  0.0;
  Na_h  =  Na_hO;
  Na_m  =  Na_mO;
  comp2808_SK2_z  =  comp2808_SK2_zo1 + comp2808_SK2_zo2;
  NaR_h  =  NaR_hO;
  NaR_m  =  NaR_mO;
  KV_m  =  KV_mO;
  KCa_m  =  KCa_mO;
  cai  =  comp33_ca;
  ca2i  =  comp118_ca2;
  // rate equation CaHVA_m
  f[1]  =  (CaHVA_m_inf + -(CaHVA_m)) / CaHVA_m_tau;
  // rate equation CaHVA_h
  f[2]  =  (CaHVA_h_inf + -(CaHVA_h)) / CaHVA_h_tau;
  // rate equation NaP_m
  f[3]  =  (NaP_m_inf + -(NaP_m)) / NaP_m_tau;
  // rate equation KM_m
  f[4]  =  (KM_m_inf + -(KM_m)) / KM_m_tau;
  // rate equation KA_m
  f[5]  =  (KA_m_inf + -(KA_m)) / KA_m_tau;
  // rate equation KA_h
  f[6]  =  (KA_h_inf + -(KA_h)) / KA_h_tau;
  // rate equation CaLVA_m
  f[7]  =  (CaLVA_m_inf + -(CaLVA_m)) / CaLVA_m_tau;
  // rate equation CaLVA_h
  f[8]  =  (CaLVA_h_inf + -(CaLVA_h)) / CaLVA_h_tau;
  // rate equation comp118_ca2
  f[9]  =  0.0;
  // rate equation KCa_mO
  v4690  =  KCa_mO;; f[10]  =  -(KCa_mO * 0.0) + (1 - v4690) * 0.0;
  // rate equation KV_mO
  v4691  =  KV_mO;; f[11]  =  -(KV_mO * 0.0) + (1 - v4691) * 0.0;
  // rate equation NaR_mO
  v4692  =  NaR_mO;; f[12]  =  -(NaR_mO * 0.0) + (1 - v4692) * 0.0;
  // rate equation NaR_hO
  v4693  =  NaR_hO;; f[13]  =  -(NaR_hO * 0.0) + (1 - v4693) * 0.0;
  // rate equation comp2808_SK2_zc1
  f[14]  =  -(comp2808_SK2_zc1 * 0.0) + comp2808_SK2_zc2 * 0.0;
  // rate equation comp2808_SK2_zc2
  f[15]  =  -(comp2808_SK2_zc2 * 0.0 + comp2808_SK2_zc2 * 0.0) + comp2808_SK2_zc3 * 0.0 + comp2808_SK2_zc1 * 0.0;
  // rate equation comp2808_SK2_zc3
  f[16]  =  -(comp2808_SK2_zc3 * 0.0 + comp2808_SK2_zc3 * 0.0 + comp2808_SK2_zc3 * 0.0) + comp2808_SK2_zo1 * 0.0 + comp2808_SK2_zc4 * 0.0 + comp2808_SK2_zc2 * 0.0;
  // rate equation comp2808_SK2_zo1
  f[17]  =  -(comp2808_SK2_zo1 * 0.0) + comp2808_SK2_zc3 * 0.0;
  // rate equation comp2808_SK2_zc4
  f[18]  =  -(comp2808_SK2_zc4 * 0.0 + comp2808_SK2_zc4 * 0.0) + comp2808_SK2_zo2 * 0.0 + comp2808_SK2_zc3 * 0.0;
  // rate equation comp2808_SK2_zo2
  f[19]  =  -(comp2808_SK2_zo2 * 0.0) + comp2808_SK2_zc4 * 0.0;
  // rate equation Na_mO
  v4694  =  Na_mO;; f[20]  =  -(Na_mO * 0.0) + (1 - v4694) * 0.0;
  // rate equation Na_hO
  v4695  =  Na_hO;; f[21]  =  -(Na_hO * 0.0) + (1 - v4695) * 0.0;
  // rate equation comp949_o_fast
  f[22]  =  0.0;
  // rate equation comp1285_o_fast
  f[23]  =  0.0;
  // rate equation comp33_ca
  f[24]  =  0.0;
  // rate equation comp949_o_slow
  f[25]  =  0.0;
  // rate equation comp1285_o_slow
  f[26]  =  0.0;
  i_NaR  =  (comp3736_gbar * NaR_m * NaR_h) * (v - comp3736_e);
  i_NaP  =  (comp3459_gbar * NaP_m) * (v - comp3459_e);
  v4696  =  Na_m;; 
i_Na  =  (comp3094_gbar * v4696 * v4696 * v4696 * Na_h) * (v - comp3094_e);
  ina  =  i_NaR + i_NaP + i_Na;
  i_KCa  =  (comp2062_gbar * KCa_m) * (v - comp2062_e);
  v4697  =  KA_m;; 
i_KA  =  (comp1641_gbar * v4697 * v4697 * v4697 * KA_h) * (v - comp1641_e);
  i_SK2  =  (comp2808_gbar * comp2808_SK2_z) * (v - comp2808_e);
  v4698  =  KV_m;; 
i_KV  =  (comp2559_gbar * v4698 * v4698 * v4698 * v4698) * (v - comp2559_e);
  i_KM  =  (comp2298_gbar * KM_m) * (v - comp2298_e);
  ik  =  i_KCa + i_KA + i_SK2 + i_KV + i_KM;
  v4699  =  CaLVA_m;; 
i_CaLVA  =  (comp566_gbar * v4699 * v4699 * CaLVA_h) * (v - comp566_e);
  ica2  =  i_CaLVA;
  v4700  =  CaHVA_m;; 
i_CaHVA  =  (comp217_gbar * v4700 * v4700 * CaHVA_h) * (v - comp217_e);
  ica  =  i_CaHVA;
  i_HCN1  =  (comp949_gbar * (comp949_o_slow + comp949_o_fast)) * (v - comp949_e);
  i_HCN2  =  (comp1285_gbar * (comp1285_o_slow + comp1285_o_fast)) * (v - comp1285_e);
  i_Lkg  =  comp4113_gbar * (v - comp4113_e);
  i  =  i_HCN1 + i_HCN2 + i_Lkg;
  f[0]  =  0.0;
  

  return GSL_SUCCESS;
}


RecordablesMap<Golgi> Golgi::recordablesMap_;
template <> void RecordablesMap<Golgi>::create()
{
  insert_("comp1285_o_slow", &Golgi::get_y_elem_<Golgi::State_::COMP1285_O_SLOW>);
  insert_("comp949_o_slow", &Golgi::get_y_elem_<Golgi::State_::COMP949_O_SLOW>);
  insert_("comp33_ca", &Golgi::get_y_elem_<Golgi::State_::COMP33_CA>);
  insert_("comp1285_o_fast", &Golgi::get_y_elem_<Golgi::State_::COMP1285_O_FAST>);
  insert_("comp949_o_fast", &Golgi::get_y_elem_<Golgi::State_::COMP949_O_FAST>);
  insert_("Na_hO", &Golgi::get_y_elem_<Golgi::State_::NA_HO>);
  insert_("Na_mO", &Golgi::get_y_elem_<Golgi::State_::NA_MO>);
  insert_("comp2808_SK2_zo2", &Golgi::get_y_elem_<Golgi::State_::COMP2808_SK2_ZO2>);
  insert_("comp2808_SK2_zc4", &Golgi::get_y_elem_<Golgi::State_::COMP2808_SK2_ZC4>);
  insert_("comp2808_SK2_zo1", &Golgi::get_y_elem_<Golgi::State_::COMP2808_SK2_ZO1>);
  insert_("comp2808_SK2_zc3", &Golgi::get_y_elem_<Golgi::State_::COMP2808_SK2_ZC3>);
  insert_("comp2808_SK2_zc2", &Golgi::get_y_elem_<Golgi::State_::COMP2808_SK2_ZC2>);
  insert_("comp2808_SK2_zc1", &Golgi::get_y_elem_<Golgi::State_::COMP2808_SK2_ZC1>);
  insert_("NaR_hO", &Golgi::get_y_elem_<Golgi::State_::NAR_HO>);
  insert_("NaR_mO", &Golgi::get_y_elem_<Golgi::State_::NAR_MO>);
  insert_("KV_mO", &Golgi::get_y_elem_<Golgi::State_::KV_MO>);
  insert_("KCa_mO", &Golgi::get_y_elem_<Golgi::State_::KCA_MO>);
  insert_("comp118_ca2", &Golgi::get_y_elem_<Golgi::State_::COMP118_CA2>);
  insert_("CaLVA_h", &Golgi::get_y_elem_<Golgi::State_::CALVA_H>);
  insert_("CaLVA_m", &Golgi::get_y_elem_<Golgi::State_::CALVA_M>);
  insert_("KA_h", &Golgi::get_y_elem_<Golgi::State_::KA_H>);
  insert_("KA_m", &Golgi::get_y_elem_<Golgi::State_::KA_M>);
  insert_("KM_m", &Golgi::get_y_elem_<Golgi::State_::KM_M>);
  insert_("NaP_m", &Golgi::get_y_elem_<Golgi::State_::NAP_M>);
  insert_("CaHVA_h", &Golgi::get_y_elem_<Golgi::State_::CAHVA_H>);
  insert_("CaHVA_m", &Golgi::get_y_elem_<Golgi::State_::CAHVA_M>);
  insert_("v", &Golgi::get_y_elem_<Golgi::State_::V>);
  insert_(names::V_m, &Golgi::get_y_elem_<Golgi::State_::V>);
}




Golgi::Parameters_::Parameters_ () :
  comp2559_gbar  (0.032),
comp3094_Kalpha_v  (-3.333),
comp217_Kalpha_u  (-18.183),
comp3094_Kalpha_u  (-10.0),
comp217_Kalpha_s  (15.87301587302),
comp3736_Kalpha_s  (-6.81881),
comp2298_Kalpha_n  (40.0),
comp2559_Kalpha_n  (-10.0),
comp3459_Kalpha_m  (-5.0),
comp3736_Kalpha_f  (-62.52621),
comp2062_Kalpha_c  (-11.765),
comp1641_Kalpha_b  (12.8433),
comp1641_Kalpha_a  (-23.32708),
comp1556_vchdur  (30.0),
comp949_gbar  (5e-05),
comp481_vchold  (-71.0),
comp3009_vchold  (-71.0),
comp3651_vchold  (-71.0),
comp118_beta  (1.3),
comp3009_vcinc  (10.0),
comp3094_V0beta_v  (-17.0),
comp217_V0beta_u  (-48.0),
comp3094_V0beta_u  (-50.0),
comp217_V0beta_s  (-18.66),
comp3736_V0beta_s  (43.97494),
comp2298_V0beta_n  (-30.0),
comp2559_V0beta_n  (-36.0),
comp3459_V0beta_m  (-40.0),
comp3736_V0beta_f  (-83.3332),
comp1641_V0beta_b  (-49.9537),
comp1641_V0beta_a  (-18.27914),
comp3651_vcinc  (10.0),
comp2298_V0_ninf  (-35.0),
comp1977_vcbdur  (100.0),
comp2213_vcbdur  (100.0),
comp2723_vcbdur  (100.0),
comp2298_B_ninf  (6.0),
comp3094_Kbeta_v  (-5.0),
comp217_Kbeta_u  (83.33),
comp3094_Kbeta_u  (-18.182),
comp217_Kbeta_s  (-25.641),
comp3736_Kbeta_s  (0.10818),
comp2298_Kbeta_n  (-20.0),
comp2559_Kbeta_n  (-80.0),
comp3459_Kbeta_m  (5.0),
comp3736_Kbeta_f  (16.05379),
comp2062_Kbeta_c  (-11.765),
comp1641_Kbeta_b  (-8.90123),
comp1641_Kbeta_a  (19.47175),
comp949_rB  (0.97596),
comp949_rA  (0.002096),
comp2062_Balpha_c  (0.0015),
comp1977_vcbase  (-69.0),
comp2213_vcbase  (-69.0),
comp2723_vcbase  (-69.0),
comp2062_gbar  (0.003),
comp4113_gbar  (0.0),
comp1285_Ehalf  (-81.95),
comp481_vchdur  (30.0),
comp3009_vchdur  (30.0),
comp3651_vchdur  (30.0),
comp566_k_h_inf  (5.0),
comp864_vchold  (-71.0),
comp1200_vchold  (-71.0),
comp2474_vchold  (-71.0),
comp3374_vchold  (-71.0),
comp4028_vchold  (-71.0),
comp2808_diro2  (1.2),
comp2808_diro1  (0.16),
comp2808_diff  (3.0),
comp2808_dirc4  (80.0),
comp2808_dirc3  (160.0),
comp2808_dirc2  (200.0),
ca2o  (2.0),
comp1641_e  (-84.69),
comp3736_gbar  (0.0017),
comp1556_vcbdur  (100.0),
comp118_valence  (2.0),
comp566_valence  (2.0),
comp566_C_tau_m  (3.0),
comp566_C_tau_h  (85.0),
comp566_v0_tau_m2  (-100.0),
comp566_v0_tau_m1  (-25.0),
comp566_v0_tau_h2  (-405.0),
comp566_v0_tau_h1  (-46.0),
comp1556_vcbase  (-69.0),
comp3094_gbar  (0.048),
comp3459_V0_minf  (-43.0),
comp566_v0_m_inf  (-50.0),
comp864_vchdur  (200.0),
comp1200_vchdur  (30.0),
comp2474_vchdur  (30.0),
comp3374_vchdur  (30.0),
comp4028_vchdur  (30.0),
comp2298_gbar  (0.001),
comp566_gbar  (0.00025),
comp3094_e  (87.39),
comp1977_vcinc  (10.0),
comp33_cai0  (5e-05),
comp481_vcbdur  (100.0),
comp3009_vcbdur  (100.0),
comp3651_vcbdur  (100.0),
comp1641_gbar  (0.008),
comp2559_e  (-84.69),
comp566_A_tau_m  (1.0),
comp566_A_tau_h  (1.0),
comp217_e  (129.33),
comp4028_vcinc  (10.0),
comp118_ca2i0  (5e-05),
comp566_k_tau_m2  (-15.0),
comp566_k_tau_m1  (10.0),
comp566_k_tau_h2  (-50.0),
comp566_k_tau_h1  (4.0),
comp481_vcbase  (-69.0),
comp3009_vcbase  (-69.0),
comp3651_vcbase  (-60.0),
comp3736_e  (87.39),
comp566_shift  (2.0),
comp3459_gbar  (0.00019),
comp566_R  (8.31342),
comp566_F  (96485.3),
comp2298_e  (-84.69),
comp33_beta  (1.3),
comp481_vcsteps  (8.0),
comp864_vcsteps  (8.0),
comp1200_vcsteps  (8.0),
comp1556_vcsteps  (8.0),
comp1977_vcsteps  (8.0),
comp2213_vcsteps  (8.0),
comp2474_vcsteps  (8.0),
comp2723_vcsteps  (8.0),
comp3009_vcsteps  (8.0),
comp3374_vcsteps  (9.0),
comp3651_vcsteps  (9.0),
comp4028_vcsteps  (9.0),
comp864_vcbdur  (30.0),
comp1200_vcbdur  (100.0),
comp2474_vcbdur  (100.0),
comp3374_vcbdur  (100.0),
comp4028_vcbdur  (100.0),
comp2808_e  (-84.69),
comp2474_vcinc  (10.0),
comp3374_vcinc  (10.0),
comp1285_tEs  (2.3026),
comp1641_V0_binf  (-78.8),
comp1285_tEf  (2.3026),
comp1285_tDs  (-5.2944),
comp1285_e  (-20.0),
comp1285_c  (0.1661),
comp1285_tDf  (-5.6111),
comp1285_tCs  (0.0152),
comp1285_tCf  (0.0269),
comp33_cao  (2.0),
comp864_vcbase  (-69.0),
comp1200_vcbase  (-69.0),
comp2474_vcbase  (-69.0),
comp3374_vcbase  (-60.0),
comp4028_vcbase  (-60.0),
comp2808_invo2  (0.1),
comp2808_invo1  (1.0),
comp2808_invc3  (0.2),
comp2808_invc2  (0.08),
comp2808_invc1  (0.08),
comp481_vcinc  (10.0),
comp3094_Aalpha_v  (0.21),
comp217_Aalpha_u  (0.0013),
comp3094_Aalpha_u  (0.3),
comp217_Aalpha_s  (0.04944),
comp3736_Aalpha_s  (-0.00493),
comp2298_Aalpha_n  (0.0033),
comp2559_Aalpha_n  (-0.01),
comp3459_Aalpha_m  (-0.91),
comp949_tEs  (2.302585092),
comp3736_Aalpha_f  (0.31836),
comp2062_Aalpha_c  (7.0),
comp1641_Aalpha_b  (0.0368),
comp1641_Aalpha_a  (0.8147),
comp949_tEf  (2.302585092),
comp949_tDs  (-4.056),
comp949_tDf  (-3.368),
comp949_tCs  (0.01451),
comp949_tCf  (0.01371),
comp566_k_m_inf  (-7.4),
comp2808_gbar  (0.038),
comp949_e  (-20.0),
comp949_c  (0.11305),
comp1641_K_binf  (8.4),
comp1200_vcinc  (10.0),
comp33_d  (0.2),
comp33_F  (96485.3),
comp118_d  (0.2),
comp118_F  (96485.3),
comp864_vcinc  (10.0),
comp217_gbar  (0.00046),
comp1977_vchold  (-71.0),
comp2213_vchold  (-71.0),
comp2723_vchold  (-71.0),
comp1556_vcinc  (10.0),
comp2062_Bbeta_c  (0.00015),
comp3736_Shiftbeta_s  (0.04752),
comp3459_B_minf  (5.0),
comp1641_V0_ainf  (-38.0),
comp2723_vcinc  (10.0),
comp2062_e  (-84.69),
comp566_v0_h_inf  (-78.0),
comp3094_V0alpha_v  (-50.0),
comp217_V0alpha_u  (-48.0),
comp3094_V0alpha_u  (-25.0),
comp217_V0alpha_s  (-29.06),
comp3736_V0alpha_s  (-4.48754),
comp3736_Shiftalpha_s  (8e-05),
comp2298_V0alpha_n  (-30.0),
comp2559_V0alpha_n  (-26.0),
comp3459_V0alpha_m  (-40.0),
comp3736_V0alpha_f  (-80.0),
comp1641_V0alpha_b  (-111.33209),
comp1641_V0alpha_a  (-9.17203),
comp3094_Abeta_v  (3.0),
comp217_Abeta_u  (0.0013),
comp3094_Abeta_u  (12.0),
comp217_Abeta_s  (0.08298),
comp3736_Abeta_s  (0.01558),
comp2298_Abeta_n  (0.0033),
comp2559_Abeta_n  (0.125),
comp3459_Abeta_m  (0.62),
comp3736_Abeta_f  (0.01014),
comp2062_Abeta_c  (1.0),
comp1641_Abeta_b  (0.0345),
comp1641_Abeta_a  (0.1655),
comp1285_gbar  (8e-05),
comp1977_vchdur  (30.0),
comp2213_vchdur  (30.0),
comp2723_vchdur  (30.0),
comp949_Ehalf  (-72.49),
comp1556_vchold  (-71.0),
comp1641_K_ainf  (-17.0),
comp4113_e  (-55.0),
comp3459_e  (87.39),
comp1285_rB  (-1.4694),
comp1285_rA  (-0.0227),
comp118_ca2o  (2.0),
comp2213_vcinc  (10.0)
{}


Golgi::State_::State_ (const Parameters_& p) : r_(0)
{
  double v4701, v4702, v4703, v4704, v4705, comp2808_diro1_t, comp949_tau_f, comp949_tau_s, comp2808_diro2_t, comp2559_Q10, CaLVA_h_inf, CaHVA_h_inf, KM_m_tau, comp3459_Q10, CaLVA_h_tau, CaHVA_h_tau, comp1641_a_inf, comp2808_invc1_t, KA_h_inf, comp2808_invc2_t, comp2808_invc3_t, comp217_Q10, KA_h_tau, comp566_h_inf, comp2062_Q10, comp566_e, comp1641_tau_a, comp1641_tau_b, NaP_m_inf, comp1641_b_inf, comp566_tau_h, comp566_tau_m, CaLVA_m_inf, CaHVA_m_inf, comp2808_dirc4_t_ca, comp2808_dirc2_t, comp2808_dirc3_t, comp2808_dirc4_t, comp1285_o_slow_inf, comp949_o_slow_inf, comp566_phi_h, comp3094_Q10, comp566_phi_m, NaP_m_tau, comp2808_invo1_t, comp2808_invo2_t, CaLVA_m_tau, CaHVA_m_tau, KA_m_inf, comp1641_Q10, comp2808_dirc3_t_ca, comp1285_tau_f, comp1285_tau_s, comp2298_Q10, comp3736_Q10, KA_m_tau, comp566_m_inf, comp2808_Q10, comp2808_dirc2_t_ca, KM_m_inf, comp1285_o_fast_inf, comp949_o_fast_inf, comp118_ca2, KCa_m, KCa_mO, KV_m, KV_mO, NaR_m, NaR_mO, NaR_h, NaR_hO, Na_m, Na_mO, Na_h, Na_hO, comp949_o_fast, comp1285_o_fast, comp33_ca, comp949_o_slow, comp1285_o_slow, CaHVA_m, CaHVA_h, NaP_m, KM_m, KA_m, KA_h, CaLVA_m, CaLVA_h, cai, ca2i, comp2808_cai, comp118_ica2, comp33_ica, comp2062_cai, comp566_ca2i, comp566_ca2o, comp2808_SK2_zo2, comp2808_SK2_zc4, comp2808_SK2_zo1, comp2808_SK2_zc3, comp2808_SK2_zc2, comp2808_SK2_zc1, v, i_NaR, i_NaP, i_Na, ina, i_KCa, i_KA, i_SK2, i_KV, i_KM, ik, i_CaLVA, ica2, i_CaHVA, ica, i_HCN1, i_HCN2, i_Lkg, i, comp2559_gbar, comp3094_Kalpha_v, comp217_Kalpha_u, comp3094_Kalpha_u, comp217_Kalpha_s, comp3736_Kalpha_s, comp2298_Kalpha_n, comp2559_Kalpha_n, comp3459_Kalpha_m, comp3736_Kalpha_f, comp2062_Kalpha_c, comp1641_Kalpha_b, comp1641_Kalpha_a, comp1556_vchdur, comp949_gbar, comp481_vchold, comp3009_vchold, comp3651_vchold, comp118_beta, comp3009_vcinc, comp3094_V0beta_v, comp217_V0beta_u, comp3094_V0beta_u, comp217_V0beta_s, comp3736_V0beta_s, comp2298_V0beta_n, comp2559_V0beta_n, comp3459_V0beta_m, comp3736_V0beta_f, comp1641_V0beta_b, comp1641_V0beta_a, comp3651_vcinc, comp2298_V0_ninf, comp1977_vcbdur, comp2213_vcbdur, comp2723_vcbdur, comp2298_B_ninf, comp3094_Kbeta_v, comp217_Kbeta_u, comp3094_Kbeta_u, comp217_Kbeta_s, comp3736_Kbeta_s, comp2298_Kbeta_n, comp2559_Kbeta_n, comp3459_Kbeta_m, comp3736_Kbeta_f, comp2062_Kbeta_c, comp1641_Kbeta_b, comp1641_Kbeta_a, comp949_rB, comp949_rA, comp2062_Balpha_c, comp1977_vcbase, comp2213_vcbase, comp2723_vcbase, comp2062_gbar, comp4113_gbar, comp1285_Ehalf, comp481_vchdur, comp3009_vchdur, comp3651_vchdur, comp566_k_h_inf, comp864_vchold, comp1200_vchold, comp2474_vchold, comp3374_vchold, comp4028_vchold, comp2808_diro2, comp2808_diro1, comp2808_diff, comp2808_dirc4, comp2808_dirc3, comp2808_dirc2, ca2o, comp1641_e, comp3736_gbar, comp1556_vcbdur, comp118_valence, comp566_valence, comp566_C_tau_m, comp566_C_tau_h, comp566_v0_tau_m2, comp566_v0_tau_m1, comp566_v0_tau_h2, comp566_v0_tau_h1, comp1556_vcbase, comp3094_gbar, comp3459_V0_minf, comp566_v0_m_inf, comp864_vchdur, comp1200_vchdur, comp2474_vchdur, comp3374_vchdur, comp4028_vchdur, comp2298_gbar, comp566_gbar, comp3094_e, comp1977_vcinc, comp33_cai0, comp481_vcbdur, comp3009_vcbdur, comp3651_vcbdur, comp1641_gbar, comp2559_e, comp566_A_tau_m, comp566_A_tau_h, comp217_e, comp4028_vcinc, comp118_ca2i0, comp566_k_tau_m2, comp566_k_tau_m1, comp566_k_tau_h2, comp566_k_tau_h1, comp481_vcbase, comp3009_vcbase, comp3651_vcbase, comp3736_e, comp566_shift, comp3459_gbar, comp566_R, comp566_F, comp2298_e, comp33_beta, comp481_vcsteps, comp864_vcsteps, comp1200_vcsteps, comp1556_vcsteps, comp1977_vcsteps, comp2213_vcsteps, comp2474_vcsteps, comp2723_vcsteps, comp3009_vcsteps, comp3374_vcsteps, comp3651_vcsteps, comp4028_vcsteps, comp864_vcbdur, comp1200_vcbdur, comp2474_vcbdur, comp3374_vcbdur, comp4028_vcbdur, comp2808_e, comp2474_vcinc, comp3374_vcinc, comp1285_tEs, comp1641_V0_binf, comp1285_tEf, comp1285_tDs, comp1285_e, comp1285_c, comp1285_tDf, comp1285_tCs, comp1285_tCf, comp33_cao, comp864_vcbase, comp1200_vcbase, comp2474_vcbase, comp3374_vcbase, comp4028_vcbase, comp2808_invo2, comp2808_invo1, comp2808_invc3, comp2808_invc2, comp2808_invc1, comp481_vcinc, comp3094_Aalpha_v, comp217_Aalpha_u, comp3094_Aalpha_u, comp217_Aalpha_s, comp3736_Aalpha_s, comp2298_Aalpha_n, comp2559_Aalpha_n, comp3459_Aalpha_m, comp949_tEs, comp3736_Aalpha_f, comp2062_Aalpha_c, comp1641_Aalpha_b, comp1641_Aalpha_a, comp949_tEf, comp949_tDs, comp949_tDf, comp949_tCs, comp949_tCf, comp566_k_m_inf, comp2808_gbar, comp949_e, comp949_c, comp1641_K_binf, comp1200_vcinc, comp33_d, comp33_F, comp118_d, comp118_F, comp864_vcinc, comp217_gbar, comp1977_vchold, comp2213_vchold, comp2723_vchold, comp1556_vcinc, comp2062_Bbeta_c, comp3736_Shiftbeta_s, comp3459_B_minf, comp1641_V0_ainf, comp2723_vcinc, comp2062_e, comp566_v0_h_inf, comp3094_V0alpha_v, comp217_V0alpha_u, comp3094_V0alpha_u, comp217_V0alpha_s, comp3736_V0alpha_s, comp3736_Shiftalpha_s, comp2298_V0alpha_n, comp2559_V0alpha_n, comp3459_V0alpha_m, comp3736_V0alpha_f, comp1641_V0alpha_b, comp1641_V0alpha_a, comp3094_Abeta_v, comp217_Abeta_u, comp3094_Abeta_u, comp217_Abeta_s, comp3736_Abeta_s, comp2298_Abeta_n, comp2559_Abeta_n, comp3459_Abeta_m, comp3736_Abeta_f, comp2062_Abeta_c, comp1641_Abeta_b, comp1641_Abeta_a, comp1285_gbar, comp1977_vchdur, comp2213_vchdur, comp2723_vchdur, comp949_Ehalf, comp1556_vchold, comp1641_K_ainf, comp4113_e, comp3459_e, comp1285_rB, comp1285_rA, comp118_ca2o, comp2213_vcinc, comp2808_SK2_z ;
  const Parameters_ *params = &p;
  comp2559_gbar  =  p.comp2559_gbar;
  comp3094_Kalpha_v  =  p.comp3094_Kalpha_v;
  comp217_Kalpha_u  =  p.comp217_Kalpha_u;
  comp3094_Kalpha_u  =  p.comp3094_Kalpha_u;
  comp217_Kalpha_s  =  p.comp217_Kalpha_s;
  comp3736_Kalpha_s  =  p.comp3736_Kalpha_s;
  comp2298_Kalpha_n  =  p.comp2298_Kalpha_n;
  comp2559_Kalpha_n  =  p.comp2559_Kalpha_n;
  comp3459_Kalpha_m  =  p.comp3459_Kalpha_m;
  comp3736_Kalpha_f  =  p.comp3736_Kalpha_f;
  comp2062_Kalpha_c  =  p.comp2062_Kalpha_c;
  comp1641_Kalpha_b  =  p.comp1641_Kalpha_b;
  comp1641_Kalpha_a  =  p.comp1641_Kalpha_a;
  comp1556_vchdur  =  p.comp1556_vchdur;
  comp949_gbar  =  p.comp949_gbar;
  comp481_vchold  =  p.comp481_vchold;
  comp3009_vchold  =  p.comp3009_vchold;
  comp3651_vchold  =  p.comp3651_vchold;
  comp118_beta  =  p.comp118_beta;
  comp3009_vcinc  =  p.comp3009_vcinc;
  comp3094_V0beta_v  =  p.comp3094_V0beta_v;
  comp217_V0beta_u  =  p.comp217_V0beta_u;
  comp3094_V0beta_u  =  p.comp3094_V0beta_u;
  comp217_V0beta_s  =  p.comp217_V0beta_s;
  comp3736_V0beta_s  =  p.comp3736_V0beta_s;
  comp2298_V0beta_n  =  p.comp2298_V0beta_n;
  comp2559_V0beta_n  =  p.comp2559_V0beta_n;
  comp3459_V0beta_m  =  p.comp3459_V0beta_m;
  comp3736_V0beta_f  =  p.comp3736_V0beta_f;
  comp1641_V0beta_b  =  p.comp1641_V0beta_b;
  comp1641_V0beta_a  =  p.comp1641_V0beta_a;
  comp3651_vcinc  =  p.comp3651_vcinc;
  comp2298_V0_ninf  =  p.comp2298_V0_ninf;
  comp1977_vcbdur  =  p.comp1977_vcbdur;
  comp2213_vcbdur  =  p.comp2213_vcbdur;
  comp2723_vcbdur  =  p.comp2723_vcbdur;
  comp2298_B_ninf  =  p.comp2298_B_ninf;
  comp3094_Kbeta_v  =  p.comp3094_Kbeta_v;
  comp217_Kbeta_u  =  p.comp217_Kbeta_u;
  comp3094_Kbeta_u  =  p.comp3094_Kbeta_u;
  comp217_Kbeta_s  =  p.comp217_Kbeta_s;
  comp3736_Kbeta_s  =  p.comp3736_Kbeta_s;
  comp2298_Kbeta_n  =  p.comp2298_Kbeta_n;
  comp2559_Kbeta_n  =  p.comp2559_Kbeta_n;
  comp3459_Kbeta_m  =  p.comp3459_Kbeta_m;
  comp3736_Kbeta_f  =  p.comp3736_Kbeta_f;
  comp2062_Kbeta_c  =  p.comp2062_Kbeta_c;
  comp1641_Kbeta_b  =  p.comp1641_Kbeta_b;
  comp1641_Kbeta_a  =  p.comp1641_Kbeta_a;
  comp949_rB  =  p.comp949_rB;
  comp949_rA  =  p.comp949_rA;
  comp2062_Balpha_c  =  p.comp2062_Balpha_c;
  comp1977_vcbase  =  p.comp1977_vcbase;
  comp2213_vcbase  =  p.comp2213_vcbase;
  comp2723_vcbase  =  p.comp2723_vcbase;
  comp2062_gbar  =  p.comp2062_gbar;
  comp4113_gbar  =  p.comp4113_gbar;
  comp1285_Ehalf  =  p.comp1285_Ehalf;
  comp481_vchdur  =  p.comp481_vchdur;
  comp3009_vchdur  =  p.comp3009_vchdur;
  comp3651_vchdur  =  p.comp3651_vchdur;
  comp566_k_h_inf  =  p.comp566_k_h_inf;
  comp864_vchold  =  p.comp864_vchold;
  comp1200_vchold  =  p.comp1200_vchold;
  comp2474_vchold  =  p.comp2474_vchold;
  comp3374_vchold  =  p.comp3374_vchold;
  comp4028_vchold  =  p.comp4028_vchold;
  comp2808_diro2  =  p.comp2808_diro2;
  comp2808_diro1  =  p.comp2808_diro1;
  comp2808_diff  =  p.comp2808_diff;
  comp2808_dirc4  =  p.comp2808_dirc4;
  comp2808_dirc3  =  p.comp2808_dirc3;
  comp2808_dirc2  =  p.comp2808_dirc2;
  ca2o  =  p.ca2o;
  comp1641_e  =  p.comp1641_e;
  comp3736_gbar  =  p.comp3736_gbar;
  comp1556_vcbdur  =  p.comp1556_vcbdur;
  comp118_valence  =  p.comp118_valence;
  comp566_valence  =  p.comp566_valence;
  comp566_C_tau_m  =  p.comp566_C_tau_m;
  comp566_C_tau_h  =  p.comp566_C_tau_h;
  comp566_v0_tau_m2  =  p.comp566_v0_tau_m2;
  comp566_v0_tau_m1  =  p.comp566_v0_tau_m1;
  comp566_v0_tau_h2  =  p.comp566_v0_tau_h2;
  comp566_v0_tau_h1  =  p.comp566_v0_tau_h1;
  comp1556_vcbase  =  p.comp1556_vcbase;
  comp3094_gbar  =  p.comp3094_gbar;
  comp3459_V0_minf  =  p.comp3459_V0_minf;
  comp566_v0_m_inf  =  p.comp566_v0_m_inf;
  comp864_vchdur  =  p.comp864_vchdur;
  comp1200_vchdur  =  p.comp1200_vchdur;
  comp2474_vchdur  =  p.comp2474_vchdur;
  comp3374_vchdur  =  p.comp3374_vchdur;
  comp4028_vchdur  =  p.comp4028_vchdur;
  comp2298_gbar  =  p.comp2298_gbar;
  comp566_gbar  =  p.comp566_gbar;
  comp3094_e  =  p.comp3094_e;
  comp1977_vcinc  =  p.comp1977_vcinc;
  comp33_cai0  =  p.comp33_cai0;
  comp481_vcbdur  =  p.comp481_vcbdur;
  comp3009_vcbdur  =  p.comp3009_vcbdur;
  comp3651_vcbdur  =  p.comp3651_vcbdur;
  comp1641_gbar  =  p.comp1641_gbar;
  comp2559_e  =  p.comp2559_e;
  comp566_A_tau_m  =  p.comp566_A_tau_m;
  comp566_A_tau_h  =  p.comp566_A_tau_h;
  comp217_e  =  p.comp217_e;
  comp4028_vcinc  =  p.comp4028_vcinc;
  comp118_ca2i0  =  p.comp118_ca2i0;
  comp566_k_tau_m2  =  p.comp566_k_tau_m2;
  comp566_k_tau_m1  =  p.comp566_k_tau_m1;
  comp566_k_tau_h2  =  p.comp566_k_tau_h2;
  comp566_k_tau_h1  =  p.comp566_k_tau_h1;
  comp481_vcbase  =  p.comp481_vcbase;
  comp3009_vcbase  =  p.comp3009_vcbase;
  comp3651_vcbase  =  p.comp3651_vcbase;
  comp3736_e  =  p.comp3736_e;
  comp566_shift  =  p.comp566_shift;
  comp3459_gbar  =  p.comp3459_gbar;
  comp566_R  =  p.comp566_R;
  comp566_F  =  p.comp566_F;
  comp2298_e  =  p.comp2298_e;
  comp33_beta  =  p.comp33_beta;
  comp481_vcsteps  =  p.comp481_vcsteps;
  comp864_vcsteps  =  p.comp864_vcsteps;
  comp1200_vcsteps  =  p.comp1200_vcsteps;
  comp1556_vcsteps  =  p.comp1556_vcsteps;
  comp1977_vcsteps  =  p.comp1977_vcsteps;
  comp2213_vcsteps  =  p.comp2213_vcsteps;
  comp2474_vcsteps  =  p.comp2474_vcsteps;
  comp2723_vcsteps  =  p.comp2723_vcsteps;
  comp3009_vcsteps  =  p.comp3009_vcsteps;
  comp3374_vcsteps  =  p.comp3374_vcsteps;
  comp3651_vcsteps  =  p.comp3651_vcsteps;
  comp4028_vcsteps  =  p.comp4028_vcsteps;
  comp864_vcbdur  =  p.comp864_vcbdur;
  comp1200_vcbdur  =  p.comp1200_vcbdur;
  comp2474_vcbdur  =  p.comp2474_vcbdur;
  comp3374_vcbdur  =  p.comp3374_vcbdur;
  comp4028_vcbdur  =  p.comp4028_vcbdur;
  comp2808_e  =  p.comp2808_e;
  comp2474_vcinc  =  p.comp2474_vcinc;
  comp3374_vcinc  =  p.comp3374_vcinc;
  comp1285_tEs  =  p.comp1285_tEs;
  comp1641_V0_binf  =  p.comp1641_V0_binf;
  comp1285_tEf  =  p.comp1285_tEf;
  comp1285_tDs  =  p.comp1285_tDs;
  comp1285_e  =  p.comp1285_e;
  comp1285_c  =  p.comp1285_c;
  comp1285_tDf  =  p.comp1285_tDf;
  comp1285_tCs  =  p.comp1285_tCs;
  comp1285_tCf  =  p.comp1285_tCf;
  comp33_cao  =  p.comp33_cao;
  comp864_vcbase  =  p.comp864_vcbase;
  comp1200_vcbase  =  p.comp1200_vcbase;
  comp2474_vcbase  =  p.comp2474_vcbase;
  comp3374_vcbase  =  p.comp3374_vcbase;
  comp4028_vcbase  =  p.comp4028_vcbase;
  comp2808_invo2  =  p.comp2808_invo2;
  comp2808_invo1  =  p.comp2808_invo1;
  comp2808_invc3  =  p.comp2808_invc3;
  comp2808_invc2  =  p.comp2808_invc2;
  comp2808_invc1  =  p.comp2808_invc1;
  comp481_vcinc  =  p.comp481_vcinc;
  comp3094_Aalpha_v  =  p.comp3094_Aalpha_v;
  comp217_Aalpha_u  =  p.comp217_Aalpha_u;
  comp3094_Aalpha_u  =  p.comp3094_Aalpha_u;
  comp217_Aalpha_s  =  p.comp217_Aalpha_s;
  comp3736_Aalpha_s  =  p.comp3736_Aalpha_s;
  comp2298_Aalpha_n  =  p.comp2298_Aalpha_n;
  comp2559_Aalpha_n  =  p.comp2559_Aalpha_n;
  comp3459_Aalpha_m  =  p.comp3459_Aalpha_m;
  comp949_tEs  =  p.comp949_tEs;
  comp3736_Aalpha_f  =  p.comp3736_Aalpha_f;
  comp2062_Aalpha_c  =  p.comp2062_Aalpha_c;
  comp1641_Aalpha_b  =  p.comp1641_Aalpha_b;
  comp1641_Aalpha_a  =  p.comp1641_Aalpha_a;
  comp949_tEf  =  p.comp949_tEf;
  comp949_tDs  =  p.comp949_tDs;
  comp949_tDf  =  p.comp949_tDf;
  comp949_tCs  =  p.comp949_tCs;
  comp949_tCf  =  p.comp949_tCf;
  comp566_k_m_inf  =  p.comp566_k_m_inf;
  comp2808_gbar  =  p.comp2808_gbar;
  comp949_e  =  p.comp949_e;
  comp949_c  =  p.comp949_c;
  comp1641_K_binf  =  p.comp1641_K_binf;
  comp1200_vcinc  =  p.comp1200_vcinc;
  comp33_d  =  p.comp33_d;
  comp33_F  =  p.comp33_F;
  comp118_d  =  p.comp118_d;
  comp118_F  =  p.comp118_F;
  comp864_vcinc  =  p.comp864_vcinc;
  comp217_gbar  =  p.comp217_gbar;
  comp1977_vchold  =  p.comp1977_vchold;
  comp2213_vchold  =  p.comp2213_vchold;
  comp2723_vchold  =  p.comp2723_vchold;
  comp1556_vcinc  =  p.comp1556_vcinc;
  comp2062_Bbeta_c  =  p.comp2062_Bbeta_c;
  comp3736_Shiftbeta_s  =  p.comp3736_Shiftbeta_s;
  comp3459_B_minf  =  p.comp3459_B_minf;
  comp1641_V0_ainf  =  p.comp1641_V0_ainf;
  comp2723_vcinc  =  p.comp2723_vcinc;
  comp2062_e  =  p.comp2062_e;
  comp566_v0_h_inf  =  p.comp566_v0_h_inf;
  comp3094_V0alpha_v  =  p.comp3094_V0alpha_v;
  comp217_V0alpha_u  =  p.comp217_V0alpha_u;
  comp3094_V0alpha_u  =  p.comp3094_V0alpha_u;
  comp217_V0alpha_s  =  p.comp217_V0alpha_s;
  comp3736_V0alpha_s  =  p.comp3736_V0alpha_s;
  comp3736_Shiftalpha_s  =  p.comp3736_Shiftalpha_s;
  comp2298_V0alpha_n  =  p.comp2298_V0alpha_n;
  comp2559_V0alpha_n  =  p.comp2559_V0alpha_n;
  comp3459_V0alpha_m  =  p.comp3459_V0alpha_m;
  comp3736_V0alpha_f  =  p.comp3736_V0alpha_f;
  comp1641_V0alpha_b  =  p.comp1641_V0alpha_b;
  comp1641_V0alpha_a  =  p.comp1641_V0alpha_a;
  comp3094_Abeta_v  =  p.comp3094_Abeta_v;
  comp217_Abeta_u  =  p.comp217_Abeta_u;
  comp3094_Abeta_u  =  p.comp3094_Abeta_u;
  comp217_Abeta_s  =  p.comp217_Abeta_s;
  comp3736_Abeta_s  =  p.comp3736_Abeta_s;
  comp2298_Abeta_n  =  p.comp2298_Abeta_n;
  comp2559_Abeta_n  =  p.comp2559_Abeta_n;
  comp3459_Abeta_m  =  p.comp3459_Abeta_m;
  comp3736_Abeta_f  =  p.comp3736_Abeta_f;
  comp2062_Abeta_c  =  p.comp2062_Abeta_c;
  comp1641_Abeta_b  =  p.comp1641_Abeta_b;
  comp1641_Abeta_a  =  p.comp1641_Abeta_a;
  comp1285_gbar  =  p.comp1285_gbar;
  comp1977_vchdur  =  p.comp1977_vchdur;
  comp2213_vchdur  =  p.comp2213_vchdur;
  comp2723_vchdur  =  p.comp2723_vchdur;
  comp949_Ehalf  =  p.comp949_Ehalf;
  comp1556_vchold  =  p.comp1556_vchold;
  comp1641_K_ainf  =  p.comp1641_K_ainf;
  comp4113_e  =  p.comp4113_e;
  comp3459_e  =  p.comp3459_e;
  comp1285_rB  =  p.comp1285_rB;
  comp1285_rA  =  p.comp1285_rA;
  comp118_ca2o  =  p.comp118_ca2o;
  comp2213_vcinc  =  p.comp2213_vcinc;
  v  =  -65.0;
  comp2808_cai  =  cai;
  comp118_ica2  =  ica2;
  comp33_ica  =  ica;
  comp2062_cai  =  cai;
  comp566_ca2i  =  ca2i;
  comp566_ca2o  =  ca2o;
  comp2808_diro1_t  =  0.0;
  comp949_tau_f  =  0.0;
  comp949_tau_s  =  0.0;
  comp2808_diro2_t  =  0.0;
  comp2559_Q10  =  0.0;
  CaLVA_h_inf  =  0.0;
  CaHVA_h_inf  =  0.0;
  KM_m_tau  =  0.0;
  comp3459_Q10  =  0.0;
  CaLVA_h_tau  =  0.0;
  CaHVA_h_tau  =  0.0;
  comp1641_a_inf  =  0.0;
  comp2808_invc1_t  =  0.0;
  KA_h_inf  =  0.0;
  comp2808_invc2_t  =  0.0;
  comp2808_invc3_t  =  0.0;
  comp217_Q10  =  0.0;
  KA_h_tau  =  0.0;
  comp566_h_inf  =  0.0;
  comp2062_Q10  =  0.0;
  comp566_e  =  0.0;
  comp1641_tau_a  =  0.0;
  comp1641_tau_b  =  0.0;
  NaP_m_inf  =  0.0;
  comp1641_b_inf  =  0.0;
  comp566_tau_h  =  0.0;
  comp566_tau_m  =  0.0;
  CaLVA_m_inf  =  0.0;
  CaHVA_m_inf  =  0.0;
  comp2808_dirc4_t_ca  =  0.0;
  comp2808_dirc2_t  =  0.0;
  comp2808_dirc3_t  =  0.0;
  comp2808_dirc4_t  =  0.0;
  comp1285_o_slow_inf  =  0.0;
  comp949_o_slow_inf  =  0.0;
  comp566_phi_h  =  0.0;
  comp3094_Q10  =  0.0;
  comp566_phi_m  =  0.0;
  NaP_m_tau  =  0.0;
  comp2808_invo1_t  =  0.0;
  comp2808_invo2_t  =  0.0;
  CaLVA_m_tau  =  0.0;
  CaHVA_m_tau  =  0.0;
  KA_m_inf  =  0.0;
  comp1641_Q10  =  0.0;
  comp2808_dirc3_t_ca  =  0.0;
  comp1285_tau_f  =  0.0;
  comp1285_tau_s  =  0.0;
  comp2298_Q10  =  0.0;
  comp3736_Q10  =  0.0;
  KA_m_tau  =  0.0;
  comp566_m_inf  =  0.0;
  comp2808_Q10  =  0.0;
  comp2808_dirc2_t_ca  =  0.0;
  KM_m_inf  =  0.0;
  comp1285_o_fast_inf  =  0.0;
  comp949_o_fast_inf  =  0.0;
  comp118_ca2  =  0.0;
  KCa_m  =  0.0;
  KCa_mO  =  KCa_m;
  KV_m  =  0.0;
  KV_mO  =  KV_m;
  NaR_m  =  0.0;
  NaR_mO  =  NaR_m;
  NaR_h  =  0.0;
  NaR_hO  =  NaR_h;
  Na_m  =  0.0;
  Na_mO  =  Na_m;
  Na_h  =  0.0;
  Na_hO  =  Na_h;
  comp949_o_fast  =  0.0;
  comp1285_o_fast  =  0.0;
  comp33_ca  =  0.0;
  comp949_o_slow  =  0.0;
  comp1285_o_slow  =  0.0;
  CaHVA_m  =  0.0;
  CaHVA_h  =  0.0;
  NaP_m  =  0.0;
  KM_m  =  0.0;
  KA_m  =  0.0;
  KA_h  =  0.0;
  CaLVA_m  =  0.0;
  CaLVA_h  =  0.0;
  cai  =  comp33_ca;
  ca2i  =  comp118_ca2;
  y_[9]  =  comp118_ca2;
  y_[10]  =  KCa_mO;
  y_[11]  =  KV_mO;
  y_[12]  =  NaR_mO;
  y_[13]  =  NaR_hO;
  y_[20]  =  Na_mO;
  y_[21]  =  Na_hO;
  y_[22]  =  comp949_o_fast;
  y_[23]  =  comp1285_o_fast;
  y_[24]  =  comp33_ca;
  y_[25]  =  comp949_o_slow;
  y_[26]  =  comp1285_o_slow;
  y_[1]  =  CaHVA_m;
  y_[2]  =  CaHVA_h;
  y_[3]  =  NaP_m;
  y_[4]  =  KM_m;
  y_[5]  =  KA_m;
  y_[6]  =  KA_h;
  y_[7]  =  CaLVA_m;
  y_[8]  =  CaLVA_h;
  comp2808_SK2_z  =  comp2808_SK2_zo1 + comp2808_SK2_zo2;
  i_NaR  =  (comp3736_gbar * NaR_m * NaR_h) * (v - comp3736_e);
  i_NaP  =  (comp3459_gbar * NaP_m) * (v - comp3459_e);
  v4701  =  Na_m;; 
i_Na  =  (comp3094_gbar * v4701 * v4701 * v4701 * Na_h) * (v - comp3094_e);
  ina  =  i_NaR + i_NaP + i_Na;
  i_KCa  =  (comp2062_gbar * KCa_m) * (v - comp2062_e);
  v4702  =  KA_m;; 
i_KA  =  (comp1641_gbar * v4702 * v4702 * v4702 * KA_h) * (v - comp1641_e);
  i_SK2  =  (comp2808_gbar * comp2808_SK2_z) * (v - comp2808_e);
  v4703  =  KV_m;; 
i_KV  =  (comp2559_gbar * v4703 * v4703 * v4703 * v4703) * (v - comp2559_e);
  i_KM  =  (comp2298_gbar * KM_m) * (v - comp2298_e);
  ik  =  i_KCa + i_KA + i_SK2 + i_KV + i_KM;
  v4704  =  CaLVA_m;; 
i_CaLVA  =  (comp566_gbar * v4704 * v4704 * CaLVA_h) * (v - comp566_e);
  ica2  =  i_CaLVA;
  v4705  =  CaHVA_m;; 
i_CaHVA  =  (comp217_gbar * v4705 * v4705 * CaHVA_h) * (v - comp217_e);
  ica  =  i_CaHVA;
  i_HCN1  =  (comp949_gbar * (comp949_o_slow + comp949_o_fast)) * (v - comp949_e);
  i_HCN2  =  (comp1285_gbar * (comp1285_o_slow + comp1285_o_fast)) * (v - comp1285_e);
  i_Lkg  =  comp4113_gbar * (v - comp4113_e);
  i  =  i_HCN1 + i_HCN2 + i_Lkg;
  y_[0]  =  0.0;
}


Golgi::State_::State_ (const State_& s) : r_(s.r_)
{
  for ( int i = 0 ; i < 27 ; ++i ) y_[i] = s.y_[i];
}


Golgi::State_& Golgi::State_::operator=(const State_& s)
{
     assert(this != &s);  
     for ( size_t i = 0 ; i < 27 ; ++i )
       y_[i] = s.y_[i];
     r_ = s.r_;
     return *this;
}




void Golgi::Parameters_::get (DictionaryDatum &d) const
{
  def<double_t>(d, "comp2559_gbar", comp2559_gbar);
  def<double_t>(d, "comp3094_Kalpha_v", comp3094_Kalpha_v);
  def<double_t>(d, "comp217_Kalpha_u", comp217_Kalpha_u);
  def<double_t>(d, "comp3094_Kalpha_u", comp3094_Kalpha_u);
  def<double_t>(d, "comp217_Kalpha_s", comp217_Kalpha_s);
  def<double_t>(d, "comp3736_Kalpha_s", comp3736_Kalpha_s);
  def<double_t>(d, "comp2298_Kalpha_n", comp2298_Kalpha_n);
  def<double_t>(d, "comp2559_Kalpha_n", comp2559_Kalpha_n);
  def<double_t>(d, "comp3459_Kalpha_m", comp3459_Kalpha_m);
  def<double_t>(d, "comp3736_Kalpha_f", comp3736_Kalpha_f);
  def<double_t>(d, "comp2062_Kalpha_c", comp2062_Kalpha_c);
  def<double_t>(d, "comp1641_Kalpha_b", comp1641_Kalpha_b);
  def<double_t>(d, "comp1641_Kalpha_a", comp1641_Kalpha_a);
  def<double_t>(d, "comp1556_vchdur", comp1556_vchdur);
  def<double_t>(d, "comp949_gbar", comp949_gbar);
  def<double_t>(d, "comp481_vchold", comp481_vchold);
  def<double_t>(d, "comp3009_vchold", comp3009_vchold);
  def<double_t>(d, "comp3651_vchold", comp3651_vchold);
  def<double_t>(d, "comp118_beta", comp118_beta);
  def<double_t>(d, "comp3009_vcinc", comp3009_vcinc);
  def<double_t>(d, "comp3094_V0beta_v", comp3094_V0beta_v);
  def<double_t>(d, "comp217_V0beta_u", comp217_V0beta_u);
  def<double_t>(d, "comp3094_V0beta_u", comp3094_V0beta_u);
  def<double_t>(d, "comp217_V0beta_s", comp217_V0beta_s);
  def<double_t>(d, "comp3736_V0beta_s", comp3736_V0beta_s);
  def<double_t>(d, "comp2298_V0beta_n", comp2298_V0beta_n);
  def<double_t>(d, "comp2559_V0beta_n", comp2559_V0beta_n);
  def<double_t>(d, "comp3459_V0beta_m", comp3459_V0beta_m);
  def<double_t>(d, "comp3736_V0beta_f", comp3736_V0beta_f);
  def<double_t>(d, "comp1641_V0beta_b", comp1641_V0beta_b);
  def<double_t>(d, "comp1641_V0beta_a", comp1641_V0beta_a);
  def<double_t>(d, "comp3651_vcinc", comp3651_vcinc);
  def<double_t>(d, "comp2298_V0_ninf", comp2298_V0_ninf);
  def<double_t>(d, "comp1977_vcbdur", comp1977_vcbdur);
  def<double_t>(d, "comp2213_vcbdur", comp2213_vcbdur);
  def<double_t>(d, "comp2723_vcbdur", comp2723_vcbdur);
  def<double_t>(d, "comp2298_B_ninf", comp2298_B_ninf);
  def<double_t>(d, "comp3094_Kbeta_v", comp3094_Kbeta_v);
  def<double_t>(d, "comp217_Kbeta_u", comp217_Kbeta_u);
  def<double_t>(d, "comp3094_Kbeta_u", comp3094_Kbeta_u);
  def<double_t>(d, "comp217_Kbeta_s", comp217_Kbeta_s);
  def<double_t>(d, "comp3736_Kbeta_s", comp3736_Kbeta_s);
  def<double_t>(d, "comp2298_Kbeta_n", comp2298_Kbeta_n);
  def<double_t>(d, "comp2559_Kbeta_n", comp2559_Kbeta_n);
  def<double_t>(d, "comp3459_Kbeta_m", comp3459_Kbeta_m);
  def<double_t>(d, "comp3736_Kbeta_f", comp3736_Kbeta_f);
  def<double_t>(d, "comp2062_Kbeta_c", comp2062_Kbeta_c);
  def<double_t>(d, "comp1641_Kbeta_b", comp1641_Kbeta_b);
  def<double_t>(d, "comp1641_Kbeta_a", comp1641_Kbeta_a);
  def<double_t>(d, "comp949_rB", comp949_rB);
  def<double_t>(d, "comp949_rA", comp949_rA);
  def<double_t>(d, "comp2062_Balpha_c", comp2062_Balpha_c);
  def<double_t>(d, "comp1977_vcbase", comp1977_vcbase);
  def<double_t>(d, "comp2213_vcbase", comp2213_vcbase);
  def<double_t>(d, "comp2723_vcbase", comp2723_vcbase);
  def<double_t>(d, "comp2062_gbar", comp2062_gbar);
  def<double_t>(d, "comp4113_gbar", comp4113_gbar);
  def<double_t>(d, "comp1285_Ehalf", comp1285_Ehalf);
  def<double_t>(d, "comp481_vchdur", comp481_vchdur);
  def<double_t>(d, "comp3009_vchdur", comp3009_vchdur);
  def<double_t>(d, "comp3651_vchdur", comp3651_vchdur);
  def<double_t>(d, "comp566_k_h_inf", comp566_k_h_inf);
  def<double_t>(d, "comp864_vchold", comp864_vchold);
  def<double_t>(d, "comp1200_vchold", comp1200_vchold);
  def<double_t>(d, "comp2474_vchold", comp2474_vchold);
  def<double_t>(d, "comp3374_vchold", comp3374_vchold);
  def<double_t>(d, "comp4028_vchold", comp4028_vchold);
  def<double_t>(d, "comp2808_diro2", comp2808_diro2);
  def<double_t>(d, "comp2808_diro1", comp2808_diro1);
  def<double_t>(d, "comp2808_diff", comp2808_diff);
  def<double_t>(d, "comp2808_dirc4", comp2808_dirc4);
  def<double_t>(d, "comp2808_dirc3", comp2808_dirc3);
  def<double_t>(d, "comp2808_dirc2", comp2808_dirc2);
  def<double_t>(d, "ca2o", ca2o);
  def<double_t>(d, "comp1641_e", comp1641_e);
  def<double_t>(d, "comp3736_gbar", comp3736_gbar);
  def<double_t>(d, "comp1556_vcbdur", comp1556_vcbdur);
  def<double_t>(d, "comp118_valence", comp118_valence);
  def<double_t>(d, "comp566_valence", comp566_valence);
  def<double_t>(d, "comp566_C_tau_m", comp566_C_tau_m);
  def<double_t>(d, "comp566_C_tau_h", comp566_C_tau_h);
  def<double_t>(d, "comp566_v0_tau_m2", comp566_v0_tau_m2);
  def<double_t>(d, "comp566_v0_tau_m1", comp566_v0_tau_m1);
  def<double_t>(d, "comp566_v0_tau_h2", comp566_v0_tau_h2);
  def<double_t>(d, "comp566_v0_tau_h1", comp566_v0_tau_h1);
  def<double_t>(d, "comp1556_vcbase", comp1556_vcbase);
  def<double_t>(d, "comp3094_gbar", comp3094_gbar);
  def<double_t>(d, "comp3459_V0_minf", comp3459_V0_minf);
  def<double_t>(d, "comp566_v0_m_inf", comp566_v0_m_inf);
  def<double_t>(d, "comp864_vchdur", comp864_vchdur);
  def<double_t>(d, "comp1200_vchdur", comp1200_vchdur);
  def<double_t>(d, "comp2474_vchdur", comp2474_vchdur);
  def<double_t>(d, "comp3374_vchdur", comp3374_vchdur);
  def<double_t>(d, "comp4028_vchdur", comp4028_vchdur);
  def<double_t>(d, "comp2298_gbar", comp2298_gbar);
  def<double_t>(d, "comp566_gbar", comp566_gbar);
  def<double_t>(d, "comp3094_e", comp3094_e);
  def<double_t>(d, "comp1977_vcinc", comp1977_vcinc);
  def<double_t>(d, "comp33_cai0", comp33_cai0);
  def<double_t>(d, "comp481_vcbdur", comp481_vcbdur);
  def<double_t>(d, "comp3009_vcbdur", comp3009_vcbdur);
  def<double_t>(d, "comp3651_vcbdur", comp3651_vcbdur);
  def<double_t>(d, "comp1641_gbar", comp1641_gbar);
  def<double_t>(d, "comp2559_e", comp2559_e);
  def<double_t>(d, "comp566_A_tau_m", comp566_A_tau_m);
  def<double_t>(d, "comp566_A_tau_h", comp566_A_tau_h);
  def<double_t>(d, "comp217_e", comp217_e);
  def<double_t>(d, "comp4028_vcinc", comp4028_vcinc);
  def<double_t>(d, "comp118_ca2i0", comp118_ca2i0);
  def<double_t>(d, "comp566_k_tau_m2", comp566_k_tau_m2);
  def<double_t>(d, "comp566_k_tau_m1", comp566_k_tau_m1);
  def<double_t>(d, "comp566_k_tau_h2", comp566_k_tau_h2);
  def<double_t>(d, "comp566_k_tau_h1", comp566_k_tau_h1);
  def<double_t>(d, "comp481_vcbase", comp481_vcbase);
  def<double_t>(d, "comp3009_vcbase", comp3009_vcbase);
  def<double_t>(d, "comp3651_vcbase", comp3651_vcbase);
  def<double_t>(d, "comp3736_e", comp3736_e);
  def<double_t>(d, "comp566_shift", comp566_shift);
  def<double_t>(d, "comp3459_gbar", comp3459_gbar);
  def<double_t>(d, "comp566_R", comp566_R);
  def<double_t>(d, "comp566_F", comp566_F);
  def<double_t>(d, "comp2298_e", comp2298_e);
  def<double_t>(d, "comp33_beta", comp33_beta);
  def<double_t>(d, "comp481_vcsteps", comp481_vcsteps);
  def<double_t>(d, "comp864_vcsteps", comp864_vcsteps);
  def<double_t>(d, "comp1200_vcsteps", comp1200_vcsteps);
  def<double_t>(d, "comp1556_vcsteps", comp1556_vcsteps);
  def<double_t>(d, "comp1977_vcsteps", comp1977_vcsteps);
  def<double_t>(d, "comp2213_vcsteps", comp2213_vcsteps);
  def<double_t>(d, "comp2474_vcsteps", comp2474_vcsteps);
  def<double_t>(d, "comp2723_vcsteps", comp2723_vcsteps);
  def<double_t>(d, "comp3009_vcsteps", comp3009_vcsteps);
  def<double_t>(d, "comp3374_vcsteps", comp3374_vcsteps);
  def<double_t>(d, "comp3651_vcsteps", comp3651_vcsteps);
  def<double_t>(d, "comp4028_vcsteps", comp4028_vcsteps);
  def<double_t>(d, "comp864_vcbdur", comp864_vcbdur);
  def<double_t>(d, "comp1200_vcbdur", comp1200_vcbdur);
  def<double_t>(d, "comp2474_vcbdur", comp2474_vcbdur);
  def<double_t>(d, "comp3374_vcbdur", comp3374_vcbdur);
  def<double_t>(d, "comp4028_vcbdur", comp4028_vcbdur);
  def<double_t>(d, "comp2808_e", comp2808_e);
  def<double_t>(d, "comp2474_vcinc", comp2474_vcinc);
  def<double_t>(d, "comp3374_vcinc", comp3374_vcinc);
  def<double_t>(d, "comp1285_tEs", comp1285_tEs);
  def<double_t>(d, "comp1641_V0_binf", comp1641_V0_binf);
  def<double_t>(d, "comp1285_tEf", comp1285_tEf);
  def<double_t>(d, "comp1285_tDs", comp1285_tDs);
  def<double_t>(d, "comp1285_e", comp1285_e);
  def<double_t>(d, "comp1285_c", comp1285_c);
  def<double_t>(d, "comp1285_tDf", comp1285_tDf);
  def<double_t>(d, "comp1285_tCs", comp1285_tCs);
  def<double_t>(d, "comp1285_tCf", comp1285_tCf);
  def<double_t>(d, "comp33_cao", comp33_cao);
  def<double_t>(d, "comp864_vcbase", comp864_vcbase);
  def<double_t>(d, "comp1200_vcbase", comp1200_vcbase);
  def<double_t>(d, "comp2474_vcbase", comp2474_vcbase);
  def<double_t>(d, "comp3374_vcbase", comp3374_vcbase);
  def<double_t>(d, "comp4028_vcbase", comp4028_vcbase);
  def<double_t>(d, "comp2808_invo2", comp2808_invo2);
  def<double_t>(d, "comp2808_invo1", comp2808_invo1);
  def<double_t>(d, "comp2808_invc3", comp2808_invc3);
  def<double_t>(d, "comp2808_invc2", comp2808_invc2);
  def<double_t>(d, "comp2808_invc1", comp2808_invc1);
  def<double_t>(d, "comp481_vcinc", comp481_vcinc);
  def<double_t>(d, "comp3094_Aalpha_v", comp3094_Aalpha_v);
  def<double_t>(d, "comp217_Aalpha_u", comp217_Aalpha_u);
  def<double_t>(d, "comp3094_Aalpha_u", comp3094_Aalpha_u);
  def<double_t>(d, "comp217_Aalpha_s", comp217_Aalpha_s);
  def<double_t>(d, "comp3736_Aalpha_s", comp3736_Aalpha_s);
  def<double_t>(d, "comp2298_Aalpha_n", comp2298_Aalpha_n);
  def<double_t>(d, "comp2559_Aalpha_n", comp2559_Aalpha_n);
  def<double_t>(d, "comp3459_Aalpha_m", comp3459_Aalpha_m);
  def<double_t>(d, "comp949_tEs", comp949_tEs);
  def<double_t>(d, "comp3736_Aalpha_f", comp3736_Aalpha_f);
  def<double_t>(d, "comp2062_Aalpha_c", comp2062_Aalpha_c);
  def<double_t>(d, "comp1641_Aalpha_b", comp1641_Aalpha_b);
  def<double_t>(d, "comp1641_Aalpha_a", comp1641_Aalpha_a);
  def<double_t>(d, "comp949_tEf", comp949_tEf);
  def<double_t>(d, "comp949_tDs", comp949_tDs);
  def<double_t>(d, "comp949_tDf", comp949_tDf);
  def<double_t>(d, "comp949_tCs", comp949_tCs);
  def<double_t>(d, "comp949_tCf", comp949_tCf);
  def<double_t>(d, "comp566_k_m_inf", comp566_k_m_inf);
  def<double_t>(d, "comp2808_gbar", comp2808_gbar);
  def<double_t>(d, "comp949_e", comp949_e);
  def<double_t>(d, "comp949_c", comp949_c);
  def<double_t>(d, "comp1641_K_binf", comp1641_K_binf);
  def<double_t>(d, "comp1200_vcinc", comp1200_vcinc);
  def<double_t>(d, "comp33_d", comp33_d);
  def<double_t>(d, "comp33_F", comp33_F);
  def<double_t>(d, "comp118_d", comp118_d);
  def<double_t>(d, "comp118_F", comp118_F);
  def<double_t>(d, "comp864_vcinc", comp864_vcinc);
  def<double_t>(d, "comp217_gbar", comp217_gbar);
  def<double_t>(d, "comp1977_vchold", comp1977_vchold);
  def<double_t>(d, "comp2213_vchold", comp2213_vchold);
  def<double_t>(d, "comp2723_vchold", comp2723_vchold);
  def<double_t>(d, "comp1556_vcinc", comp1556_vcinc);
  def<double_t>(d, "comp2062_Bbeta_c", comp2062_Bbeta_c);
  def<double_t>(d, "comp3736_Shiftbeta_s", comp3736_Shiftbeta_s);
  def<double_t>(d, "comp3459_B_minf", comp3459_B_minf);
  def<double_t>(d, "comp1641_V0_ainf", comp1641_V0_ainf);
  def<double_t>(d, "comp2723_vcinc", comp2723_vcinc);
  def<double_t>(d, "comp2062_e", comp2062_e);
  def<double_t>(d, "comp566_v0_h_inf", comp566_v0_h_inf);
  def<double_t>(d, "comp3094_V0alpha_v", comp3094_V0alpha_v);
  def<double_t>(d, "comp217_V0alpha_u", comp217_V0alpha_u);
  def<double_t>(d, "comp3094_V0alpha_u", comp3094_V0alpha_u);
  def<double_t>(d, "comp217_V0alpha_s", comp217_V0alpha_s);
  def<double_t>(d, "comp3736_V0alpha_s", comp3736_V0alpha_s);
  def<double_t>(d, "comp3736_Shiftalpha_s", comp3736_Shiftalpha_s);
  def<double_t>(d, "comp2298_V0alpha_n", comp2298_V0alpha_n);
  def<double_t>(d, "comp2559_V0alpha_n", comp2559_V0alpha_n);
  def<double_t>(d, "comp3459_V0alpha_m", comp3459_V0alpha_m);
  def<double_t>(d, "comp3736_V0alpha_f", comp3736_V0alpha_f);
  def<double_t>(d, "comp1641_V0alpha_b", comp1641_V0alpha_b);
  def<double_t>(d, "comp1641_V0alpha_a", comp1641_V0alpha_a);
  def<double_t>(d, "comp3094_Abeta_v", comp3094_Abeta_v);
  def<double_t>(d, "comp217_Abeta_u", comp217_Abeta_u);
  def<double_t>(d, "comp3094_Abeta_u", comp3094_Abeta_u);
  def<double_t>(d, "comp217_Abeta_s", comp217_Abeta_s);
  def<double_t>(d, "comp3736_Abeta_s", comp3736_Abeta_s);
  def<double_t>(d, "comp2298_Abeta_n", comp2298_Abeta_n);
  def<double_t>(d, "comp2559_Abeta_n", comp2559_Abeta_n);
  def<double_t>(d, "comp3459_Abeta_m", comp3459_Abeta_m);
  def<double_t>(d, "comp3736_Abeta_f", comp3736_Abeta_f);
  def<double_t>(d, "comp2062_Abeta_c", comp2062_Abeta_c);
  def<double_t>(d, "comp1641_Abeta_b", comp1641_Abeta_b);
  def<double_t>(d, "comp1641_Abeta_a", comp1641_Abeta_a);
  def<double_t>(d, "comp1285_gbar", comp1285_gbar);
  def<double_t>(d, "comp1977_vchdur", comp1977_vchdur);
  def<double_t>(d, "comp2213_vchdur", comp2213_vchdur);
  def<double_t>(d, "comp2723_vchdur", comp2723_vchdur);
  def<double_t>(d, "comp949_Ehalf", comp949_Ehalf);
  def<double_t>(d, "comp1556_vchold", comp1556_vchold);
  def<double_t>(d, "comp1641_K_ainf", comp1641_K_ainf);
  def<double_t>(d, "comp4113_e", comp4113_e);
  def<double_t>(d, "comp3459_e", comp3459_e);
  def<double_t>(d, "comp1285_rB", comp1285_rB);
  def<double_t>(d, "comp1285_rA", comp1285_rA);
  def<double_t>(d, "comp118_ca2o", comp118_ca2o);
  def<double_t>(d, "comp2213_vcinc", comp2213_vcinc);
}


void Golgi::Parameters_::set (const DictionaryDatum &d)
{
  updateValue<double_t>(d, "comp2559_gbar", comp2559_gbar);
  updateValue<double_t>(d, "comp3094_Kalpha_v", comp3094_Kalpha_v);
  updateValue<double_t>(d, "comp217_Kalpha_u", comp217_Kalpha_u);
  updateValue<double_t>(d, "comp3094_Kalpha_u", comp3094_Kalpha_u);
  updateValue<double_t>(d, "comp217_Kalpha_s", comp217_Kalpha_s);
  updateValue<double_t>(d, "comp3736_Kalpha_s", comp3736_Kalpha_s);
  updateValue<double_t>(d, "comp2298_Kalpha_n", comp2298_Kalpha_n);
  updateValue<double_t>(d, "comp2559_Kalpha_n", comp2559_Kalpha_n);
  updateValue<double_t>(d, "comp3459_Kalpha_m", comp3459_Kalpha_m);
  updateValue<double_t>(d, "comp3736_Kalpha_f", comp3736_Kalpha_f);
  updateValue<double_t>(d, "comp2062_Kalpha_c", comp2062_Kalpha_c);
  updateValue<double_t>(d, "comp1641_Kalpha_b", comp1641_Kalpha_b);
  updateValue<double_t>(d, "comp1641_Kalpha_a", comp1641_Kalpha_a);
  updateValue<double_t>(d, "comp1556_vchdur", comp1556_vchdur);
  updateValue<double_t>(d, "comp949_gbar", comp949_gbar);
  updateValue<double_t>(d, "comp481_vchold", comp481_vchold);
  updateValue<double_t>(d, "comp3009_vchold", comp3009_vchold);
  updateValue<double_t>(d, "comp3651_vchold", comp3651_vchold);
  updateValue<double_t>(d, "comp118_beta", comp118_beta);
  updateValue<double_t>(d, "comp3009_vcinc", comp3009_vcinc);
  updateValue<double_t>(d, "comp3094_V0beta_v", comp3094_V0beta_v);
  updateValue<double_t>(d, "comp217_V0beta_u", comp217_V0beta_u);
  updateValue<double_t>(d, "comp3094_V0beta_u", comp3094_V0beta_u);
  updateValue<double_t>(d, "comp217_V0beta_s", comp217_V0beta_s);
  updateValue<double_t>(d, "comp3736_V0beta_s", comp3736_V0beta_s);
  updateValue<double_t>(d, "comp2298_V0beta_n", comp2298_V0beta_n);
  updateValue<double_t>(d, "comp2559_V0beta_n", comp2559_V0beta_n);
  updateValue<double_t>(d, "comp3459_V0beta_m", comp3459_V0beta_m);
  updateValue<double_t>(d, "comp3736_V0beta_f", comp3736_V0beta_f);
  updateValue<double_t>(d, "comp1641_V0beta_b", comp1641_V0beta_b);
  updateValue<double_t>(d, "comp1641_V0beta_a", comp1641_V0beta_a);
  updateValue<double_t>(d, "comp3651_vcinc", comp3651_vcinc);
  updateValue<double_t>(d, "comp2298_V0_ninf", comp2298_V0_ninf);
  updateValue<double_t>(d, "comp1977_vcbdur", comp1977_vcbdur);
  updateValue<double_t>(d, "comp2213_vcbdur", comp2213_vcbdur);
  updateValue<double_t>(d, "comp2723_vcbdur", comp2723_vcbdur);
  updateValue<double_t>(d, "comp2298_B_ninf", comp2298_B_ninf);
  updateValue<double_t>(d, "comp3094_Kbeta_v", comp3094_Kbeta_v);
  updateValue<double_t>(d, "comp217_Kbeta_u", comp217_Kbeta_u);
  updateValue<double_t>(d, "comp3094_Kbeta_u", comp3094_Kbeta_u);
  updateValue<double_t>(d, "comp217_Kbeta_s", comp217_Kbeta_s);
  updateValue<double_t>(d, "comp3736_Kbeta_s", comp3736_Kbeta_s);
  updateValue<double_t>(d, "comp2298_Kbeta_n", comp2298_Kbeta_n);
  updateValue<double_t>(d, "comp2559_Kbeta_n", comp2559_Kbeta_n);
  updateValue<double_t>(d, "comp3459_Kbeta_m", comp3459_Kbeta_m);
  updateValue<double_t>(d, "comp3736_Kbeta_f", comp3736_Kbeta_f);
  updateValue<double_t>(d, "comp2062_Kbeta_c", comp2062_Kbeta_c);
  updateValue<double_t>(d, "comp1641_Kbeta_b", comp1641_Kbeta_b);
  updateValue<double_t>(d, "comp1641_Kbeta_a", comp1641_Kbeta_a);
  updateValue<double_t>(d, "comp949_rB", comp949_rB);
  updateValue<double_t>(d, "comp949_rA", comp949_rA);
  updateValue<double_t>(d, "comp2062_Balpha_c", comp2062_Balpha_c);
  updateValue<double_t>(d, "comp1977_vcbase", comp1977_vcbase);
  updateValue<double_t>(d, "comp2213_vcbase", comp2213_vcbase);
  updateValue<double_t>(d, "comp2723_vcbase", comp2723_vcbase);
  updateValue<double_t>(d, "comp2062_gbar", comp2062_gbar);
  updateValue<double_t>(d, "comp4113_gbar", comp4113_gbar);
  updateValue<double_t>(d, "comp1285_Ehalf", comp1285_Ehalf);
  updateValue<double_t>(d, "comp481_vchdur", comp481_vchdur);
  updateValue<double_t>(d, "comp3009_vchdur", comp3009_vchdur);
  updateValue<double_t>(d, "comp3651_vchdur", comp3651_vchdur);
  updateValue<double_t>(d, "comp566_k_h_inf", comp566_k_h_inf);
  updateValue<double_t>(d, "comp864_vchold", comp864_vchold);
  updateValue<double_t>(d, "comp1200_vchold", comp1200_vchold);
  updateValue<double_t>(d, "comp2474_vchold", comp2474_vchold);
  updateValue<double_t>(d, "comp3374_vchold", comp3374_vchold);
  updateValue<double_t>(d, "comp4028_vchold", comp4028_vchold);
  updateValue<double_t>(d, "comp2808_diro2", comp2808_diro2);
  updateValue<double_t>(d, "comp2808_diro1", comp2808_diro1);
  updateValue<double_t>(d, "comp2808_diff", comp2808_diff);
  updateValue<double_t>(d, "comp2808_dirc4", comp2808_dirc4);
  updateValue<double_t>(d, "comp2808_dirc3", comp2808_dirc3);
  updateValue<double_t>(d, "comp2808_dirc2", comp2808_dirc2);
  updateValue<double_t>(d, "ca2o", ca2o);
  updateValue<double_t>(d, "comp1641_e", comp1641_e);
  updateValue<double_t>(d, "comp3736_gbar", comp3736_gbar);
  updateValue<double_t>(d, "comp1556_vcbdur", comp1556_vcbdur);
  updateValue<double_t>(d, "comp118_valence", comp118_valence);
  updateValue<double_t>(d, "comp566_valence", comp566_valence);
  updateValue<double_t>(d, "comp566_C_tau_m", comp566_C_tau_m);
  updateValue<double_t>(d, "comp566_C_tau_h", comp566_C_tau_h);
  updateValue<double_t>(d, "comp566_v0_tau_m2", comp566_v0_tau_m2);
  updateValue<double_t>(d, "comp566_v0_tau_m1", comp566_v0_tau_m1);
  updateValue<double_t>(d, "comp566_v0_tau_h2", comp566_v0_tau_h2);
  updateValue<double_t>(d, "comp566_v0_tau_h1", comp566_v0_tau_h1);
  updateValue<double_t>(d, "comp1556_vcbase", comp1556_vcbase);
  updateValue<double_t>(d, "comp3094_gbar", comp3094_gbar);
  updateValue<double_t>(d, "comp3459_V0_minf", comp3459_V0_minf);
  updateValue<double_t>(d, "comp566_v0_m_inf", comp566_v0_m_inf);
  updateValue<double_t>(d, "comp864_vchdur", comp864_vchdur);
  updateValue<double_t>(d, "comp1200_vchdur", comp1200_vchdur);
  updateValue<double_t>(d, "comp2474_vchdur", comp2474_vchdur);
  updateValue<double_t>(d, "comp3374_vchdur", comp3374_vchdur);
  updateValue<double_t>(d, "comp4028_vchdur", comp4028_vchdur);
  updateValue<double_t>(d, "comp2298_gbar", comp2298_gbar);
  updateValue<double_t>(d, "comp566_gbar", comp566_gbar);
  updateValue<double_t>(d, "comp3094_e", comp3094_e);
  updateValue<double_t>(d, "comp1977_vcinc", comp1977_vcinc);
  updateValue<double_t>(d, "comp33_cai0", comp33_cai0);
  updateValue<double_t>(d, "comp481_vcbdur", comp481_vcbdur);
  updateValue<double_t>(d, "comp3009_vcbdur", comp3009_vcbdur);
  updateValue<double_t>(d, "comp3651_vcbdur", comp3651_vcbdur);
  updateValue<double_t>(d, "comp1641_gbar", comp1641_gbar);
  updateValue<double_t>(d, "comp2559_e", comp2559_e);
  updateValue<double_t>(d, "comp566_A_tau_m", comp566_A_tau_m);
  updateValue<double_t>(d, "comp566_A_tau_h", comp566_A_tau_h);
  updateValue<double_t>(d, "comp217_e", comp217_e);
  updateValue<double_t>(d, "comp4028_vcinc", comp4028_vcinc);
  updateValue<double_t>(d, "comp118_ca2i0", comp118_ca2i0);
  updateValue<double_t>(d, "comp566_k_tau_m2", comp566_k_tau_m2);
  updateValue<double_t>(d, "comp566_k_tau_m1", comp566_k_tau_m1);
  updateValue<double_t>(d, "comp566_k_tau_h2", comp566_k_tau_h2);
  updateValue<double_t>(d, "comp566_k_tau_h1", comp566_k_tau_h1);
  updateValue<double_t>(d, "comp481_vcbase", comp481_vcbase);
  updateValue<double_t>(d, "comp3009_vcbase", comp3009_vcbase);
  updateValue<double_t>(d, "comp3651_vcbase", comp3651_vcbase);
  updateValue<double_t>(d, "comp3736_e", comp3736_e);
  updateValue<double_t>(d, "comp566_shift", comp566_shift);
  updateValue<double_t>(d, "comp3459_gbar", comp3459_gbar);
  updateValue<double_t>(d, "comp566_R", comp566_R);
  updateValue<double_t>(d, "comp566_F", comp566_F);
  updateValue<double_t>(d, "comp2298_e", comp2298_e);
  updateValue<double_t>(d, "comp33_beta", comp33_beta);
  updateValue<double_t>(d, "comp481_vcsteps", comp481_vcsteps);
  updateValue<double_t>(d, "comp864_vcsteps", comp864_vcsteps);
  updateValue<double_t>(d, "comp1200_vcsteps", comp1200_vcsteps);
  updateValue<double_t>(d, "comp1556_vcsteps", comp1556_vcsteps);
  updateValue<double_t>(d, "comp1977_vcsteps", comp1977_vcsteps);
  updateValue<double_t>(d, "comp2213_vcsteps", comp2213_vcsteps);
  updateValue<double_t>(d, "comp2474_vcsteps", comp2474_vcsteps);
  updateValue<double_t>(d, "comp2723_vcsteps", comp2723_vcsteps);
  updateValue<double_t>(d, "comp3009_vcsteps", comp3009_vcsteps);
  updateValue<double_t>(d, "comp3374_vcsteps", comp3374_vcsteps);
  updateValue<double_t>(d, "comp3651_vcsteps", comp3651_vcsteps);
  updateValue<double_t>(d, "comp4028_vcsteps", comp4028_vcsteps);
  updateValue<double_t>(d, "comp864_vcbdur", comp864_vcbdur);
  updateValue<double_t>(d, "comp1200_vcbdur", comp1200_vcbdur);
  updateValue<double_t>(d, "comp2474_vcbdur", comp2474_vcbdur);
  updateValue<double_t>(d, "comp3374_vcbdur", comp3374_vcbdur);
  updateValue<double_t>(d, "comp4028_vcbdur", comp4028_vcbdur);
  updateValue<double_t>(d, "comp2808_e", comp2808_e);
  updateValue<double_t>(d, "comp2474_vcinc", comp2474_vcinc);
  updateValue<double_t>(d, "comp3374_vcinc", comp3374_vcinc);
  updateValue<double_t>(d, "comp1285_tEs", comp1285_tEs);
  updateValue<double_t>(d, "comp1641_V0_binf", comp1641_V0_binf);
  updateValue<double_t>(d, "comp1285_tEf", comp1285_tEf);
  updateValue<double_t>(d, "comp1285_tDs", comp1285_tDs);
  updateValue<double_t>(d, "comp1285_e", comp1285_e);
  updateValue<double_t>(d, "comp1285_c", comp1285_c);
  updateValue<double_t>(d, "comp1285_tDf", comp1285_tDf);
  updateValue<double_t>(d, "comp1285_tCs", comp1285_tCs);
  updateValue<double_t>(d, "comp1285_tCf", comp1285_tCf);
  updateValue<double_t>(d, "comp33_cao", comp33_cao);
  updateValue<double_t>(d, "comp864_vcbase", comp864_vcbase);
  updateValue<double_t>(d, "comp1200_vcbase", comp1200_vcbase);
  updateValue<double_t>(d, "comp2474_vcbase", comp2474_vcbase);
  updateValue<double_t>(d, "comp3374_vcbase", comp3374_vcbase);
  updateValue<double_t>(d, "comp4028_vcbase", comp4028_vcbase);
  updateValue<double_t>(d, "comp2808_invo2", comp2808_invo2);
  updateValue<double_t>(d, "comp2808_invo1", comp2808_invo1);
  updateValue<double_t>(d, "comp2808_invc3", comp2808_invc3);
  updateValue<double_t>(d, "comp2808_invc2", comp2808_invc2);
  updateValue<double_t>(d, "comp2808_invc1", comp2808_invc1);
  updateValue<double_t>(d, "comp481_vcinc", comp481_vcinc);
  updateValue<double_t>(d, "comp3094_Aalpha_v", comp3094_Aalpha_v);
  updateValue<double_t>(d, "comp217_Aalpha_u", comp217_Aalpha_u);
  updateValue<double_t>(d, "comp3094_Aalpha_u", comp3094_Aalpha_u);
  updateValue<double_t>(d, "comp217_Aalpha_s", comp217_Aalpha_s);
  updateValue<double_t>(d, "comp3736_Aalpha_s", comp3736_Aalpha_s);
  updateValue<double_t>(d, "comp2298_Aalpha_n", comp2298_Aalpha_n);
  updateValue<double_t>(d, "comp2559_Aalpha_n", comp2559_Aalpha_n);
  updateValue<double_t>(d, "comp3459_Aalpha_m", comp3459_Aalpha_m);
  updateValue<double_t>(d, "comp949_tEs", comp949_tEs);
  updateValue<double_t>(d, "comp3736_Aalpha_f", comp3736_Aalpha_f);
  updateValue<double_t>(d, "comp2062_Aalpha_c", comp2062_Aalpha_c);
  updateValue<double_t>(d, "comp1641_Aalpha_b", comp1641_Aalpha_b);
  updateValue<double_t>(d, "comp1641_Aalpha_a", comp1641_Aalpha_a);
  updateValue<double_t>(d, "comp949_tEf", comp949_tEf);
  updateValue<double_t>(d, "comp949_tDs", comp949_tDs);
  updateValue<double_t>(d, "comp949_tDf", comp949_tDf);
  updateValue<double_t>(d, "comp949_tCs", comp949_tCs);
  updateValue<double_t>(d, "comp949_tCf", comp949_tCf);
  updateValue<double_t>(d, "comp566_k_m_inf", comp566_k_m_inf);
  updateValue<double_t>(d, "comp2808_gbar", comp2808_gbar);
  updateValue<double_t>(d, "comp949_e", comp949_e);
  updateValue<double_t>(d, "comp949_c", comp949_c);
  updateValue<double_t>(d, "comp1641_K_binf", comp1641_K_binf);
  updateValue<double_t>(d, "comp1200_vcinc", comp1200_vcinc);
  updateValue<double_t>(d, "comp33_d", comp33_d);
  updateValue<double_t>(d, "comp33_F", comp33_F);
  updateValue<double_t>(d, "comp118_d", comp118_d);
  updateValue<double_t>(d, "comp118_F", comp118_F);
  updateValue<double_t>(d, "comp864_vcinc", comp864_vcinc);
  updateValue<double_t>(d, "comp217_gbar", comp217_gbar);
  updateValue<double_t>(d, "comp1977_vchold", comp1977_vchold);
  updateValue<double_t>(d, "comp2213_vchold", comp2213_vchold);
  updateValue<double_t>(d, "comp2723_vchold", comp2723_vchold);
  updateValue<double_t>(d, "comp1556_vcinc", comp1556_vcinc);
  updateValue<double_t>(d, "comp2062_Bbeta_c", comp2062_Bbeta_c);
  updateValue<double_t>(d, "comp3736_Shiftbeta_s", comp3736_Shiftbeta_s);
  updateValue<double_t>(d, "comp3459_B_minf", comp3459_B_minf);
  updateValue<double_t>(d, "comp1641_V0_ainf", comp1641_V0_ainf);
  updateValue<double_t>(d, "comp2723_vcinc", comp2723_vcinc);
  updateValue<double_t>(d, "comp2062_e", comp2062_e);
  updateValue<double_t>(d, "comp566_v0_h_inf", comp566_v0_h_inf);
  updateValue<double_t>(d, "comp3094_V0alpha_v", comp3094_V0alpha_v);
  updateValue<double_t>(d, "comp217_V0alpha_u", comp217_V0alpha_u);
  updateValue<double_t>(d, "comp3094_V0alpha_u", comp3094_V0alpha_u);
  updateValue<double_t>(d, "comp217_V0alpha_s", comp217_V0alpha_s);
  updateValue<double_t>(d, "comp3736_V0alpha_s", comp3736_V0alpha_s);
  updateValue<double_t>(d, "comp3736_Shiftalpha_s", comp3736_Shiftalpha_s);
  updateValue<double_t>(d, "comp2298_V0alpha_n", comp2298_V0alpha_n);
  updateValue<double_t>(d, "comp2559_V0alpha_n", comp2559_V0alpha_n);
  updateValue<double_t>(d, "comp3459_V0alpha_m", comp3459_V0alpha_m);
  updateValue<double_t>(d, "comp3736_V0alpha_f", comp3736_V0alpha_f);
  updateValue<double_t>(d, "comp1641_V0alpha_b", comp1641_V0alpha_b);
  updateValue<double_t>(d, "comp1641_V0alpha_a", comp1641_V0alpha_a);
  updateValue<double_t>(d, "comp3094_Abeta_v", comp3094_Abeta_v);
  updateValue<double_t>(d, "comp217_Abeta_u", comp217_Abeta_u);
  updateValue<double_t>(d, "comp3094_Abeta_u", comp3094_Abeta_u);
  updateValue<double_t>(d, "comp217_Abeta_s", comp217_Abeta_s);
  updateValue<double_t>(d, "comp3736_Abeta_s", comp3736_Abeta_s);
  updateValue<double_t>(d, "comp2298_Abeta_n", comp2298_Abeta_n);
  updateValue<double_t>(d, "comp2559_Abeta_n", comp2559_Abeta_n);
  updateValue<double_t>(d, "comp3459_Abeta_m", comp3459_Abeta_m);
  updateValue<double_t>(d, "comp3736_Abeta_f", comp3736_Abeta_f);
  updateValue<double_t>(d, "comp2062_Abeta_c", comp2062_Abeta_c);
  updateValue<double_t>(d, "comp1641_Abeta_b", comp1641_Abeta_b);
  updateValue<double_t>(d, "comp1641_Abeta_a", comp1641_Abeta_a);
  updateValue<double_t>(d, "comp1285_gbar", comp1285_gbar);
  updateValue<double_t>(d, "comp1977_vchdur", comp1977_vchdur);
  updateValue<double_t>(d, "comp2213_vchdur", comp2213_vchdur);
  updateValue<double_t>(d, "comp2723_vchdur", comp2723_vchdur);
  updateValue<double_t>(d, "comp949_Ehalf", comp949_Ehalf);
  updateValue<double_t>(d, "comp1556_vchold", comp1556_vchold);
  updateValue<double_t>(d, "comp1641_K_ainf", comp1641_K_ainf);
  updateValue<double_t>(d, "comp4113_e", comp4113_e);
  updateValue<double_t>(d, "comp3459_e", comp3459_e);
  updateValue<double_t>(d, "comp1285_rB", comp1285_rB);
  updateValue<double_t>(d, "comp1285_rA", comp1285_rA);
  updateValue<double_t>(d, "comp118_ca2o", comp118_ca2o);
  updateValue<double_t>(d, "comp2213_vcinc", comp2213_vcinc);
}


void Golgi::State_::get (DictionaryDatum &d) const
{
  def<double_t>(d, "comp1285_o_slow", y_[26]);
  def<double_t>(d, "comp949_o_slow", y_[25]);
  def<double_t>(d, "comp33_ca", y_[24]);
  def<double_t>(d, "comp1285_o_fast", y_[23]);
  def<double_t>(d, "comp949_o_fast", y_[22]);
  def<double_t>(d, "Na_hO", y_[21]);
  def<double_t>(d, "Na_mO", y_[20]);
  def<double_t>(d, "comp2808_SK2_zo2", y_[19]);
  def<double_t>(d, "comp2808_SK2_zc4", y_[18]);
  def<double_t>(d, "comp2808_SK2_zo1", y_[17]);
  def<double_t>(d, "comp2808_SK2_zc3", y_[16]);
  def<double_t>(d, "comp2808_SK2_zc2", y_[15]);
  def<double_t>(d, "comp2808_SK2_zc1", y_[14]);
  def<double_t>(d, "NaR_hO", y_[13]);
  def<double_t>(d, "NaR_mO", y_[12]);
  def<double_t>(d, "KV_mO", y_[11]);
  def<double_t>(d, "KCa_mO", y_[10]);
  def<double_t>(d, "comp118_ca2", y_[9]);
  def<double_t>(d, "CaLVA_h", y_[8]);
  def<double_t>(d, "CaLVA_m", y_[7]);
  def<double_t>(d, "KA_h", y_[6]);
  def<double_t>(d, "KA_m", y_[5]);
  def<double_t>(d, "KM_m", y_[4]);
  def<double_t>(d, "NaP_m", y_[3]);
  def<double_t>(d, "CaHVA_h", y_[2]);
  def<double_t>(d, "CaHVA_m", y_[1]);
  def<double_t>(d, "v", y_[0]);
}


void Golgi::State_::set (const DictionaryDatum &d, const Parameters_&)
{
  updateValue<double_t>(d, "comp1285_o_slow", y_[26]);
  updateValue<double_t>(d, "comp949_o_slow", y_[25]);
  updateValue<double_t>(d, "comp33_ca", y_[24]);
  updateValue<double_t>(d, "comp1285_o_fast", y_[23]);
  updateValue<double_t>(d, "comp949_o_fast", y_[22]);
  updateValue<double_t>(d, "Na_hO", y_[21]);
  updateValue<double_t>(d, "Na_mO", y_[20]);
  updateValue<double_t>(d, "comp2808_SK2_zo2", y_[19]);
  updateValue<double_t>(d, "comp2808_SK2_zc4", y_[18]);
  updateValue<double_t>(d, "comp2808_SK2_zo1", y_[17]);
  updateValue<double_t>(d, "comp2808_SK2_zc3", y_[16]);
  updateValue<double_t>(d, "comp2808_SK2_zc2", y_[15]);
  updateValue<double_t>(d, "comp2808_SK2_zc1", y_[14]);
  updateValue<double_t>(d, "NaR_hO", y_[13]);
  updateValue<double_t>(d, "NaR_mO", y_[12]);
  updateValue<double_t>(d, "KV_mO", y_[11]);
  updateValue<double_t>(d, "KCa_mO", y_[10]);
  updateValue<double_t>(d, "comp118_ca2", y_[9]);
  updateValue<double_t>(d, "CaLVA_h", y_[8]);
  updateValue<double_t>(d, "CaLVA_m", y_[7]);
  updateValue<double_t>(d, "KA_h", y_[6]);
  updateValue<double_t>(d, "KA_m", y_[5]);
  updateValue<double_t>(d, "KM_m", y_[4]);
  updateValue<double_t>(d, "NaP_m", y_[3]);
  updateValue<double_t>(d, "CaHVA_h", y_[2]);
  updateValue<double_t>(d, "CaHVA_m", y_[1]);
  updateValue<double_t>(d, "v", y_[0]);
}




Golgi::Buffers_::Buffers_(Golgi& n)
    : logger_(n),
      s_(0),
      c_(0),
      e_(0)
{
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}


Golgi::Buffers_::Buffers_(const Buffers_&, Golgi& n)
    : logger_(n),
      s_(0),
      c_(0),
      e_(0)
{
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}


Golgi::Golgi()
    : Archiving_Node(), 
      P_(), 
      S_(P_),
      B_(*this)
{
    recordablesMap_.create();
}


Golgi::Golgi(const Golgi& n)
    : Archiving_Node(n), 
      P_(n.P_), 
      S_(n.S_),
      B_(n.B_, *this)
{
}
Golgi::~Golgi()
{
    // GSL structs only allocated by init_nodes_(), so we need to protect destruction
    if ( B_.s_ ) gsl_odeiv_step_free(B_.s_);
    if ( B_.c_ ) gsl_odeiv_control_free(B_.c_);
    if ( B_.e_ ) gsl_odeiv_evolve_free(B_.e_);
}


  void Golgi::init_node_(const Node& proto)
{
    const Golgi& pr = downcast<Golgi>(proto);
    P_ = pr.P_;
    S_ = pr.S_;
}


void Golgi::init_state_(const Node& proto)
{
    const Golgi& pr = downcast<Golgi>(proto);
    S_ = pr.S_;
}


void Golgi::init_buffers_()
{
      B_.currents_.clear();           
    Archiving_Node::clear_history();

    B_.logger_.reset();

    B_.step_ = Time::get_resolution().get_ms();
    B_.IntegrationStep_ = B_.step_;

    B_.I_stim_ = 0.0;

    static const gsl_odeiv_step_type* T1 = gsl_odeiv_step_rkf45;
  
    if ( B_.s_ == 0 )
      B_.s_ = gsl_odeiv_step_alloc (T1, 27);
    else 
      gsl_odeiv_step_reset(B_.s_);
    
    if ( B_.c_ == 0 )  
      B_.c_ = gsl_odeiv_control_y_new (1e-3, 0.0);
    else
      gsl_odeiv_control_init(B_.c_, 1e-3, 0.0, 1.0, 0.0);
    
    if ( B_.e_ == 0 )  
      B_.e_ = gsl_odeiv_evolve_alloc(27);
    else 
      gsl_odeiv_evolve_reset(B_.e_);
  
    B_.sys_.function  = Golgi_dynamics; 
    B_.sys_.jacobian  = 0;
    B_.sys_.dimension = 27;
    B_.sys_.params    = reinterpret_cast<void*>(this);
}


void Golgi::calibrate()
{
    B_.logger_.init();  
    V_.RefractoryCounts_ = 20;
    V_.U_old_ = S_.y_[0];
}


void Golgi::update(Time const & origin, const long_t from, const long_t to)
{
  assert(to >= 0 && (delay) from < Scheduler::get_min_delay());
    assert(from < to);

    for ( long_t lag = from ; lag < to ; ++lag )
      {
    
	double tt = 0.0 ; //it's all relative!
	V_.U_old_ = S_.y_[0];

   
	// adaptive step integration
	while (tt < B_.step_)
	{
	  const int status = gsl_odeiv_evolve_apply(B_.e_, B_.c_, B_.s_, 
				 &B_.sys_,              // system of ODE
				 &tt,                   // from t...
				  B_.step_,             // ...to t=t+h
				 &B_.IntegrationStep_ , // integration window (written on!)
				  S_.y_);	        // neuron state

	  if ( status != GSL_SUCCESS )
	    throw GSLSolverFailure(get_name(), status);
	}
  	// sending spikes: crossing 0 mV, pseudo-refractoriness and local maximum...
	// refractory?
	if (S_.r_)
	  {
	    --S_.r_;
	  }
	else
	  {
           
	  }
    
	// set new input current
	B_.I_stim_ = B_.currents_.get_value(lag);

	// log state data
	B_.logger_.record_data(origin.get_steps() + lag);

      }
}




void Golgi::handle(SpikeEvent & e)
  {
    int flag;
    assert(e.get_delay() > 0);
    flag = 0;


}




void Golgi::handle(CurrentEvent& e)
  {
    assert(e.get_delay() > 0);

    const double_t c=e.get_current();
    const double_t w=e.get_weight();

    B_.currents_.add_value(e.get_rel_delivery_steps(network()->get_slice_origin()), 
			w *c);
  }

void Golgi::handle(DataLoggingRequest& e)
  {
    B_.logger_.handle(e);
  }


}


