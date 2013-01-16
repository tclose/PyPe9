#include "Granule.h"
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
#include <cstring>
#include <cmath>

namespace nest {




double comp47_beta_a (double v, double Q10, const void* params) ;




double comp22_beta_u (double v, double Q10, const void* params) ;




double comp22_beta_s (double v, double Q10, const void* params) ;




double comp131_beta_n (double v, double Q10, const void* params) ;




double comp47_sigm (double x, double y, const void* params) ;




double comp157_alfa (double v, double Q10, const void* params) ;




double comp101_alpha_d (double v, double Q10, const void* params) ;




double comp116_alpha_n (double v, double Q10, const void* params) ;




double comp83_alpha_c (double v, double cai, double Q10, const void* params) ;




double comp131_alpha_n (double v, double Q10, const void* params) ;




double comp157_beta (double v, double Q10, const void* params) ;




double comp47_alpha_a (double v, double Q10, const void* params) ;




double comp47_alpha_b (double v, double Q10, const void* params) ;




double comp157_teta (double v, double Q10, const void* params) ;




double comp47_beta_b (double v, double Q10, const void* params) ;




double comp116_beta_n (double v, double Q10, const void* params) ;




double comp22_alpha_s (double v, double Q10, const void* params) ;




double comp22_alpha_u (double v, double Q10, const void* params) ;




double comp101_beta_d (double v, double Q10, const void* params) ;




double comp83_beta_c (double v, double cai, double Q10, const void* params) ;




double comp131_linoid (double x, double y, const void* params) ;




double comp47_beta_a (double v, double Q10, const void* params) {
  double rv215 ;
  double comp47_Kbeta_a, comp47_V0beta_a, comp47_Abeta_a ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp47_Kbeta_a = p.comp47_Kbeta_a;
  comp47_V0beta_a = p.comp47_V0beta_a;
  comp47_Abeta_a = p.comp47_Abeta_a;
  rv215  =  Q10 * comp47_Abeta_a / exp((v + -(comp47_V0beta_a)) / comp47_Kbeta_a);
  return rv215;
}




double comp22_beta_u (double v, double Q10, const void* params) {
  double rv216 ;
  double comp22_Kbeta_u, comp22_V0beta_u, comp22_Abeta_u ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp22_Kbeta_u = p.comp22_Kbeta_u;
  comp22_V0beta_u = p.comp22_V0beta_u;
  comp22_Abeta_u = p.comp22_Abeta_u;
  rv216  =  Q10 * comp22_Abeta_u * exp((v + -(comp22_V0beta_u)) / comp22_Kbeta_u);
  return rv216;
}




double comp22_beta_s (double v, double Q10, const void* params) {
  double rv217 ;
  double comp22_Kbeta_s, comp22_V0beta_s, comp22_Abeta_s ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp22_Kbeta_s = p.comp22_Kbeta_s;
  comp22_V0beta_s = p.comp22_V0beta_s;
  comp22_Abeta_s = p.comp22_Abeta_s;
  rv217  =  Q10 * comp22_Abeta_s * exp((v + -(comp22_V0beta_s)) / comp22_Kbeta_s);
  return rv217;
}




double comp131_beta_n (double v, double Q10, const void* params) {
  double rv218 ;
  double comp131_Kbeta_n, comp131_V0beta_n, comp131_Abeta_n ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp131_Kbeta_n = p.comp131_Kbeta_n;
  comp131_V0beta_n = p.comp131_V0beta_n;
  comp131_Abeta_n = p.comp131_Abeta_n;
  rv218  =  Q10 * comp131_Abeta_n * exp((v + -(comp131_V0beta_n)) / comp131_Kbeta_n);
  return rv218;
}




double comp47_sigm (double x, double y, const void* params) {
  double rv219 ;
  rv219  =  1.0 / (exp(x / y) + 1.0);
  return rv219;
}




double comp157_alfa (double v, double Q10, const void* params) {
  double rv220 ;
  double comp157_Valfa, comp157_Aalfa ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp157_Valfa = p.comp157_Valfa;
  comp157_Aalfa = p.comp157_Aalfa;
  rv220  =  Q10 * comp157_Aalfa * exp(v / comp157_Valfa);
  return rv220;
}




double comp101_alpha_d (double v, double Q10, const void* params) {
  double rv221 ;
  double comp101_Kalpha_d, comp101_V0alpha_d, comp101_Aalpha_d ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp101_Kalpha_d = p.comp101_Kalpha_d;
  comp101_V0alpha_d = p.comp101_V0alpha_d;
  comp101_Aalpha_d = p.comp101_Aalpha_d;
  rv221  =  Q10 * comp101_Aalpha_d * exp((v + -(comp101_V0alpha_d)) / comp101_Kalpha_d);
  return rv221;
}




double comp116_alpha_n (double v, double Q10, const void* params) {
  double rv222 ;
  double comp116_Kalpha_n, comp116_V0alpha_n, comp116_Aalpha_n ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp116_Kalpha_n = p.comp116_Kalpha_n;
  comp116_V0alpha_n = p.comp116_V0alpha_n;
  comp116_Aalpha_n = p.comp116_Aalpha_n;
  rv222  =  Q10 * comp116_Aalpha_n * exp((v + -(comp116_V0alpha_n)) / comp116_Kalpha_n);
  return rv222;
}




double comp83_alpha_c (double v, double cai, double Q10, const void* params) {
  double rv223 ;
  double comp83_Kalpha_c, comp83_Balpha_c, comp83_Aalpha_c ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp83_Kalpha_c = p.comp83_Kalpha_c;
  comp83_Balpha_c = p.comp83_Balpha_c;
  comp83_Aalpha_c = p.comp83_Aalpha_c;
  rv223  =  (Q10 * comp83_Aalpha_c) / (1.0 + (comp83_Balpha_c * exp(v / comp83_Kalpha_c)) / cai);
  return rv223;
}




double comp131_alpha_n (double v, double Q10, const void* params) {
  double rv224 ;
  double comp131_Kalpha_n, comp131_V0alpha_n, comp131_Aalpha_n ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp131_Kalpha_n = p.comp131_Kalpha_n;
  comp131_V0alpha_n = p.comp131_V0alpha_n;
  comp131_Aalpha_n = p.comp131_Aalpha_n;
  rv224  =  Q10 * comp131_Aalpha_n * comp131_linoid(v + -(comp131_V0alpha_n), comp131_Kalpha_n, params);
  return rv224;
}




double comp157_beta (double v, double Q10, const void* params) {
  double rv225 ;
  double comp157_Vbeta, comp157_Abeta ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp157_Vbeta = p.comp157_Vbeta;
  comp157_Abeta = p.comp157_Abeta;
  rv225  =  Q10 * comp157_Abeta * exp(-(v) / comp157_Vbeta);
  return rv225;
}




double comp47_alpha_a (double v, double Q10, const void* params) {
  double rv226 ;
  double comp47_Kalpha_a, comp47_V0alpha_a, comp47_Aalpha_a ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp47_Kalpha_a = p.comp47_Kalpha_a;
  comp47_V0alpha_a = p.comp47_V0alpha_a;
  comp47_Aalpha_a = p.comp47_Aalpha_a;
  rv226  =  Q10 * comp47_Aalpha_a * comp47_sigm(v + -(comp47_V0alpha_a), comp47_Kalpha_a, params);
  return rv226;
}




double comp47_alpha_b (double v, double Q10, const void* params) {
  double rv227 ;
  double comp47_Kalpha_b, comp47_V0alpha_b, comp47_Aalpha_b ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp47_Kalpha_b = p.comp47_Kalpha_b;
  comp47_V0alpha_b = p.comp47_V0alpha_b;
  comp47_Aalpha_b = p.comp47_Aalpha_b;
  rv227  =  Q10 * comp47_Aalpha_b * comp47_sigm(v + -(comp47_V0alpha_b), comp47_Kalpha_b, params);
  return rv227;
}




double comp157_teta (double v, double Q10, const void* params) {
  double rv228 ;
  double comp157_Vteta, comp157_Ateta ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp157_Vteta = p.comp157_Vteta;
  comp157_Ateta = p.comp157_Ateta;
  rv228  =  Q10 * comp157_Ateta * exp(-(v) / comp157_Vteta);
  return rv228;
}




double comp47_beta_b (double v, double Q10, const void* params) {
  double rv229 ;
  double comp47_Kbeta_b, comp47_V0beta_b, comp47_Abeta_b ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp47_Kbeta_b = p.comp47_Kbeta_b;
  comp47_V0beta_b = p.comp47_V0beta_b;
  comp47_Abeta_b = p.comp47_Abeta_b;
  rv229  =  Q10 * comp47_Abeta_b * comp47_sigm(v + -(comp47_V0beta_b), comp47_Kbeta_b, params);
  return rv229;
}




double comp116_beta_n (double v, double Q10, const void* params) {
  double rv230 ;
  double comp116_Kbeta_n, comp116_V0beta_n, comp116_Abeta_n ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp116_Kbeta_n = p.comp116_Kbeta_n;
  comp116_V0beta_n = p.comp116_V0beta_n;
  comp116_Abeta_n = p.comp116_Abeta_n;
  rv230  =  Q10 * comp116_Abeta_n * exp((v + -(comp116_V0beta_n)) / comp116_Kbeta_n);
  return rv230;
}




double comp22_alpha_s (double v, double Q10, const void* params) {
  double rv231 ;
  double comp22_Kalpha_s, comp22_V0alpha_s, comp22_Aalpha_s ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp22_Kalpha_s = p.comp22_Kalpha_s;
  comp22_V0alpha_s = p.comp22_V0alpha_s;
  comp22_Aalpha_s = p.comp22_Aalpha_s;
  rv231  =  Q10 * comp22_Aalpha_s * exp((v + -(comp22_V0alpha_s)) / comp22_Kalpha_s);
  return rv231;
}




double comp22_alpha_u (double v, double Q10, const void* params) {
  double rv232 ;
  double comp22_Kalpha_u, comp22_V0alpha_u, comp22_Aalpha_u ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp22_Kalpha_u = p.comp22_Kalpha_u;
  comp22_V0alpha_u = p.comp22_V0alpha_u;
  comp22_Aalpha_u = p.comp22_Aalpha_u;
  rv232  =  Q10 * comp22_Aalpha_u * exp((v + -(comp22_V0alpha_u)) / comp22_Kalpha_u);
  return rv232;
}




double comp101_beta_d (double v, double Q10, const void* params) {
  double rv233 ;
  double comp101_Kbeta_d, comp101_V0beta_d, comp101_Abeta_d ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp101_Kbeta_d = p.comp101_Kbeta_d;
  comp101_V0beta_d = p.comp101_V0beta_d;
  comp101_Abeta_d = p.comp101_Abeta_d;
  rv233  =  Q10 * comp101_Abeta_d * exp((v + -(comp101_V0beta_d)) / comp101_Kbeta_d);
  return rv233;
}




double comp83_beta_c (double v, double cai, double Q10, const void* params) {
  double rv234 ;
  double comp83_Kbeta_c, comp83_Bbeta_c, comp83_Abeta_c ;
  const  Granule::Parameters_ & p =  *(reinterpret_cast< const  Granule::Parameters_ *>(params));
  comp83_Kbeta_c = p.comp83_Kbeta_c;
  comp83_Bbeta_c = p.comp83_Bbeta_c;
  comp83_Abeta_c = p.comp83_Abeta_c;
  rv234  =  (Q10 * comp83_Abeta_c) / (1.0 + cai / (comp83_Bbeta_c * exp(v / comp83_Kbeta_c)));
  return rv234;
}




double comp131_linoid (double x, double y, const void* params) {
  double rv235 ;
  double v237 ;
  if (fabs(x / y) < 1e-06) 
      {v237  =  y * (1.0 + -(x / y / 2.0));} 
      else 
        {v237  =  x / (exp(x / y) + -1.0);}; 
rv235  =  v237;
  return rv235;
}




extern "C" int Granule_dynamics (double t, const double y[], double f[], void* pnode) {
  double v257, v258, v259, v242, v241, v244, v243, v246, v245, v248, v247, v250, v249, v252, v251, v253, v256, v255, v240, v239, comp47_K_ainf, comp47_V0_ainf, v, comp47_a_inf, comp19_celsius, comp22_Q10, comp83_Q10, comp83_cai, comp83_cai1, comp47_Q10, comp116_B_ninf, comp116_V0_ninf, KM_m_inf, comp131_Q10, comp101_Q10, comp22_cai, comp22_cao, comp22_F, comp22_R, comp22_e, comp157_Q10, comp47_K_binf, comp47_V0_binf, comp47_b_inf, comp116_Q10, comp157_Adelta, comp157_delta, comp157_ACoff, comp157_Coff, KA_m_inf, comp157_ACon, comp157_Con, comp101_d_inf, comp157_AOoff, comp157_Ooff, comp157_Aepsilon, comp157_epsilon, comp22_s_inf, KM_m_tau, comp83_c_inf, comp83_tau_c, comp131_n_inf, KA_h_inf, comp22_u_inf, comp131_tau_n, comp101_tau_d, comp157_AOon, comp157_Oon, comp22_tau_s, comp22_tau_u, comp47_tau_a, comp47_tau_b, comp157_Agamma, comp157_gamma, KV_m_tau, KCa_m_tau, KA_m_tau, CaHVA_h_tau, comp157_b, comp157_a, KA_h_tau, CaHVA_m_tau, KV_m_inf, CaHVA_h_inf, Kir_m_inf, CaHVA_m_inf, KCa_m_inf, Kir_m_tau, comp157_Na_zO, comp157_Na_z, comp21_ca, cai, comp21_cao, cao, i_Lkg1, i_Lkg2, i, i_Na, ina, i_KV, i_KCa, i_Kir, i_KM, i_KA, ik, i_CaHVA, ica, comp21_cai, comp21_ica, KM_m, CaHVA_h, CaHVA_m, comp157_Na_zI6, comp157_Na_zC5, comp157_Na_zI5, comp157_Na_zC4, comp157_Na_zI4, comp157_Na_zC3, comp157_Na_zI3, comp157_Na_zC2, comp157_Na_zI2, comp157_Na_zC1, comp157_Na_zI1, KCa_m, KV_m, Kir_m, KA_h, KA_m, comp21_F, comp115_vcinc, comp21_d, comp101_Aalpha_d, comp47_e, comp173_vcsteps, comp83_Kalpha_c, comp47_Aalpha_a, comp47_Aalpha_b, comp22_Kalpha_u, comp150_vcinc, comp22_Kalpha_s, comp19_V_t, comp115_vcsteps, comp47_V0beta_b, comp47_V0beta_a, comp131_Abeta_n, comp154_egaba, comp151_gbar, comp82_vchdur, comp83_Bbeta_c, comp21_beta, comp100_vchold, comp173_vcbase, comp82_vchold, comp82_vcsteps, comp101_Kbeta_d, comp20_C_m, comp22_Abeta_u, comp22_gbar, comp22_Abeta_s, comp116_V0beta_n, comp46_vcsteps, comp150_vchdur, comp82_vcbdur, comp130_vcbdur, comp83_Abeta_c, comp22_V0beta_s, comp22_V0beta_u, comp22_Kbeta_s, comp22_Kbeta_u, comp101_Abeta_d, comp46_vcbdur, comp173_vchold, comp116_e, comp101_e, comp157_Valfa, comp131_gbar, comp173_vchdur, comp100_vcinc, comp116_Abeta_n, comp47_Kalpha_a, comp47_Kalpha_b, comp150_vchold, comp46_vcinc, comp150_vcsteps, comp116_Aalpha_n, comp46_vchdur, comp130_vchold, comp100_vcsteps, comp115_vchold, comp116_Kalpha_n, comp101_gbar, comp131_Aalpha_n, comp100_vchdur, comp115_vcbdur, comp150_vcbase, comp157_Vteta, comp83_Balpha_c, comp83_gbar, comp101_V0beta_d, comp83_Kbeta_c, comp46_vcbase, comp47_V0alpha_b, comp47_V0alpha_a, comp131_e, comp157_Aalfa, comp130_vcinc, comp82_vcbase, comp157_e, comp83_Aalpha_c, comp131_Kalpha_n, comp131_V0alpha_n, comp115_vcbase, comp101_V0alpha_d, comp47_Abeta_a, comp47_Abeta_b, comp173_vcbdur, comp22_Aalpha_u, comp173_vcinc, comp22_Aalpha_s, comp46_vchold, comp100_vcbase, comp82_vcinc, comp157_Vbeta, comp157_gbar, comp83_e, comp130_vchdur, comp47_Kbeta_b, comp47_Kbeta_a, comp21_cai0, comp131_Kbeta_n, comp116_gbar, comp154_ggaba, comp150_vcbdur, comp22_V0alpha_s, comp22_V0alpha_u, comp157_n1, comp116_V0alpha_n, comp157_n4, comp157_n2, comp157_n3, comp151_e, comp116_Kbeta_n, comp130_vcsteps, comp131_V0beta_n, comp157_Abeta, comp115_vchdur, comp157_Ateta, comp47_gbar, comp100_vcbdur, comp101_Kalpha_d, comp130_vcbase ;
  

  // S is shorthand for the type that describes the model state 
  typedef Granule::State_ S;
  

  // cast the node ptr to an object of the proper type
  assert(pnode);
  const  Granule & node =  *(reinterpret_cast< Granule *>(pnode));
  Granule & vnode =  *(reinterpret_cast< Granule *>(pnode));
  

  // params is a reference to the model parameters 
  const struct Granule::Parameters_ *params;
  params = &(node.P_);
  

  // state is a reference to the model state 
  struct Granule::State_ *state;
  state = &(vnode.S_);
  

  // y[] must be the state vector supplied by the integrator, 
  // not the state vector in the node, node.S_.y[]. 
  

  cai  =  state->cai;
  cao  =  state->cao;
  i_Lkg1  =  state->i_Lkg1;
  i_Lkg2  =  state->i_Lkg2;
  i  =  state->i;
  i_Na  =  state->i_Na;
  ina  =  state->ina;
  i_KV  =  state->i_KV;
  i_KCa  =  state->i_KCa;
  i_Kir  =  state->i_Kir;
  i_KM  =  state->i_KM;
  i_KA  =  state->i_KA;
  ik  =  state->ik;
  i_CaHVA  =  state->i_CaHVA;
  ica  =  state->ica;
  comp22_cai  =  cai;
  comp22_cao  =  cao;
  comp21_cai  =  cai;
  comp21_ica  =  ica;
  comp83_cai  =  cai;
  comp116_B_ninf  =  params->comp116_B_ninf;
  comp21_F  =  params->comp21_F;
  comp115_vcinc  =  params->comp115_vcinc;
  comp21_d  =  params->comp21_d;
  comp101_Aalpha_d  =  params->comp101_Aalpha_d;
  comp47_e  =  params->comp47_e;
  comp173_vcsteps  =  params->comp173_vcsteps;
  comp83_Kalpha_c  =  params->comp83_Kalpha_c;
  comp47_Aalpha_a  =  params->comp47_Aalpha_a;
  comp47_Aalpha_b  =  params->comp47_Aalpha_b;
  comp22_Kalpha_u  =  params->comp22_Kalpha_u;
  comp150_vcinc  =  params->comp150_vcinc;
  comp22_Kalpha_s  =  params->comp22_Kalpha_s;
  comp19_V_t  =  params->comp19_V_t;
  comp115_vcsteps  =  params->comp115_vcsteps;
  comp47_V0beta_b  =  params->comp47_V0beta_b;
  comp47_V0beta_a  =  params->comp47_V0beta_a;
  comp157_AOon  =  params->comp157_AOon;
  comp131_Abeta_n  =  params->comp131_Abeta_n;
  comp154_egaba  =  params->comp154_egaba;
  comp151_gbar  =  params->comp151_gbar;
  comp82_vchdur  =  params->comp82_vchdur;
  comp83_Bbeta_c  =  params->comp83_Bbeta_c;
  comp21_beta  =  params->comp21_beta;
  comp100_vchold  =  params->comp100_vchold;
  comp157_ACon  =  params->comp157_ACon;
  comp173_vcbase  =  params->comp173_vcbase;
  comp82_vchold  =  params->comp82_vchold;
  comp82_vcsteps  =  params->comp82_vcsteps;
  comp101_Kbeta_d  =  params->comp101_Kbeta_d;
  comp20_C_m  =  params->comp20_C_m;
  comp22_Abeta_u  =  params->comp22_Abeta_u;
  comp22_gbar  =  params->comp22_gbar;
  comp22_Abeta_s  =  params->comp22_Abeta_s;
  comp116_V0beta_n  =  params->comp116_V0beta_n;
  comp46_vcsteps  =  params->comp46_vcsteps;
  comp150_vchdur  =  params->comp150_vchdur;
  comp22_R  =  params->comp22_R;
  comp82_vcbdur  =  params->comp82_vcbdur;
  comp22_F  =  params->comp22_F;
  comp130_vcbdur  =  params->comp130_vcbdur;
  comp83_Abeta_c  =  params->comp83_Abeta_c;
  comp22_V0beta_s  =  params->comp22_V0beta_s;
  comp22_V0beta_u  =  params->comp22_V0beta_u;
  comp22_Kbeta_s  =  params->comp22_Kbeta_s;
  comp22_Kbeta_u  =  params->comp22_Kbeta_u;
  comp101_Abeta_d  =  params->comp101_Abeta_d;
  comp46_vcbdur  =  params->comp46_vcbdur;
  comp173_vchold  =  params->comp173_vchold;
  comp116_e  =  params->comp116_e;
  comp101_e  =  params->comp101_e;
  comp157_Valfa  =  params->comp157_Valfa;
  comp131_gbar  =  params->comp131_gbar;
  comp173_vchdur  =  params->comp173_vchdur;
  comp157_Adelta  =  params->comp157_Adelta;
  comp100_vcinc  =  params->comp100_vcinc;
  comp116_Abeta_n  =  params->comp116_Abeta_n;
  comp47_Kalpha_a  =  params->comp47_Kalpha_a;
  comp47_Kalpha_b  =  params->comp47_Kalpha_b;
  comp116_V0_ninf  =  params->comp116_V0_ninf;
  comp150_vchold  =  params->comp150_vchold;
  comp46_vcinc  =  params->comp46_vcinc;
  comp150_vcsteps  =  params->comp150_vcsteps;
  comp116_Aalpha_n  =  params->comp116_Aalpha_n;
  comp46_vchdur  =  params->comp46_vchdur;
  comp47_K_binf  =  params->comp47_K_binf;
  comp19_celsius  =  params->comp19_celsius;
  comp130_vchold  =  params->comp130_vchold;
  comp100_vcsteps  =  params->comp100_vcsteps;
  comp115_vchold  =  params->comp115_vchold;
  comp116_Kalpha_n  =  params->comp116_Kalpha_n;
  comp101_gbar  =  params->comp101_gbar;
  comp131_Aalpha_n  =  params->comp131_Aalpha_n;
  comp157_AOoff  =  params->comp157_AOoff;
  comp157_ACoff  =  params->comp157_ACoff;
  comp100_vchdur  =  params->comp100_vchdur;
  comp115_vcbdur  =  params->comp115_vcbdur;
  comp150_vcbase  =  params->comp150_vcbase;
  comp157_Vteta  =  params->comp157_Vteta;
  comp83_Balpha_c  =  params->comp83_Balpha_c;
  comp47_V0_binf  =  params->comp47_V0_binf;
  comp83_gbar  =  params->comp83_gbar;
  comp101_V0beta_d  =  params->comp101_V0beta_d;
  comp83_Kbeta_c  =  params->comp83_Kbeta_c;
  comp46_vcbase  =  params->comp46_vcbase;
  comp47_V0alpha_b  =  params->comp47_V0alpha_b;
  comp47_V0alpha_a  =  params->comp47_V0alpha_a;
  comp131_e  =  params->comp131_e;
  comp157_Aalfa  =  params->comp157_Aalfa;
  comp157_Aepsilon  =  params->comp157_Aepsilon;
  comp130_vcinc  =  params->comp130_vcinc;
  comp82_vcbase  =  params->comp82_vcbase;
  comp157_e  =  params->comp157_e;
  comp83_Aalpha_c  =  params->comp83_Aalpha_c;
  comp131_Kalpha_n  =  params->comp131_Kalpha_n;
  comp47_K_ainf  =  params->comp47_K_ainf;
  comp157_Agamma  =  params->comp157_Agamma;
  comp131_V0alpha_n  =  params->comp131_V0alpha_n;
  comp115_vcbase  =  params->comp115_vcbase;
  comp101_V0alpha_d  =  params->comp101_V0alpha_d;
  comp47_Abeta_a  =  params->comp47_Abeta_a;
  comp47_Abeta_b  =  params->comp47_Abeta_b;
  comp21_cao  =  params->comp21_cao;
  comp173_vcbdur  =  params->comp173_vcbdur;
  comp22_Aalpha_u  =  params->comp22_Aalpha_u;
  comp173_vcinc  =  params->comp173_vcinc;
  comp22_Aalpha_s  =  params->comp22_Aalpha_s;
  comp46_vchold  =  params->comp46_vchold;
  comp100_vcbase  =  params->comp100_vcbase;
  comp82_vcinc  =  params->comp82_vcinc;
  comp157_Vbeta  =  params->comp157_Vbeta;
  comp157_gbar  =  params->comp157_gbar;
  comp83_e  =  params->comp83_e;
  comp130_vchdur  =  params->comp130_vchdur;
  comp47_Kbeta_b  =  params->comp47_Kbeta_b;
  comp47_Kbeta_a  =  params->comp47_Kbeta_a;
  comp21_cai0  =  params->comp21_cai0;
  comp131_Kbeta_n  =  params->comp131_Kbeta_n;
  comp116_gbar  =  params->comp116_gbar;
  comp154_ggaba  =  params->comp154_ggaba;
  comp47_V0_ainf  =  params->comp47_V0_ainf;
  comp150_vcbdur  =  params->comp150_vcbdur;
  comp22_V0alpha_s  =  params->comp22_V0alpha_s;
  comp22_V0alpha_u  =  params->comp22_V0alpha_u;
  comp157_n1  =  params->comp157_n1;
  comp116_V0alpha_n  =  params->comp116_V0alpha_n;
  comp157_n4  =  params->comp157_n4;
  comp157_n2  =  params->comp157_n2;
  comp157_n3  =  params->comp157_n3;
  comp151_e  =  params->comp151_e;
  comp116_Kbeta_n  =  params->comp116_Kbeta_n;
  comp130_vcsteps  =  params->comp130_vcsteps;
  comp131_V0beta_n  =  params->comp131_V0beta_n;
  comp157_Abeta  =  params->comp157_Abeta;
  comp115_vchdur  =  params->comp115_vchdur;
  comp157_Ateta  =  params->comp157_Ateta;
  comp47_gbar  =  params->comp47_gbar;
  comp100_vcbdur  =  params->comp100_vcbdur;
  comp101_Kalpha_d  =  params->comp101_Kalpha_d;
  comp130_vcbase  =  params->comp130_vcbase;
  v  =  Ith(y,0);
  KA_m  =  Ith(y,1);
  KA_h  =  Ith(y,2);
  Kir_m  =  Ith(y,3);
  KV_m  =  Ith(y,4);
  KCa_m  =  Ith(y,5);
  comp157_Na_zI1  =  Ith(y,6);
  comp157_Na_zC1  =  Ith(y,7);
  comp157_Na_zI2  =  Ith(y,8);
  comp157_Na_zC2  =  Ith(y,9);
  comp157_Na_zI3  =  Ith(y,10);
  comp157_Na_zC3  =  Ith(y,11);
  comp157_Na_zI4  =  Ith(y,12);
  comp157_Na_zC4  =  Ith(y,13);
  comp157_Na_zI5  =  Ith(y,14);
  comp157_Na_zC5  =  Ith(y,15);
  comp157_Na_zI6  =  Ith(y,16);
  comp157_Na_zO  =  Ith(y,17);
  CaHVA_m  =  Ith(y,18);
  CaHVA_h  =  Ith(y,19);
  KM_m  =  Ith(y,20);
  comp21_ca  =  Ith(y,21);
  comp47_a_inf  =  1.0 / (1.0 + exp((v + -(comp47_V0_ainf)) / comp47_K_ainf));
  comp22_Q10  =  pow(3.0, (comp19_celsius + -20.0) / 10.0);
  comp83_Q10  =  pow(3.0, (comp19_celsius + -30.0) / 10.0);
  if (comp83_cai < 0.0001) {v240  =  0.0001;} else {v240  =  comp83_cai;}; 
v239  =  v240;; comp83_cai1  =  v239;
  comp47_Q10  =  pow(3.0, (comp19_celsius + -25.5) / 10.0);
  KM_m_inf  =  1.0 / (1.0 + exp(-(v + -(comp116_V0_ninf)) / comp116_B_ninf));
  comp131_Q10  =  pow(3.0, (comp19_celsius + -6.3) / 10.0);
  comp101_Q10  =  pow(3.0, (comp19_celsius + -20.0) / 10.0);
  comp22_e  =  (1000.0 * comp22_R * (comp19_celsius + 273.15)) / (2.0 * comp22_F) * log(comp22_cao / comp22_cai);
  comp157_Q10  =  pow(3.0, (comp19_celsius + -20.0) / 10.0);
  comp47_b_inf  =  1.0 / (1.0 + exp((v + -(comp47_V0_binf)) / comp47_K_binf));
  comp116_Q10  =  pow(3.0, (comp19_celsius + -22.0) / 10.0);
  comp157_delta  =  comp157_Q10 * comp157_Adelta;
  comp157_Coff  =  comp157_Q10 * comp157_ACoff;
  KA_m_inf  =  comp47_a_inf;
  comp157_Con  =  comp157_Q10 * comp157_ACon;
  comp101_d_inf  =  (comp101_alpha_d(v, comp101_Q10, params)) / (comp101_alpha_d(v, comp101_Q10, params) + comp101_beta_d(v, comp101_Q10, params));
  comp157_Ooff  =  comp157_Q10 * comp157_AOoff;
  comp157_epsilon  =  comp157_Q10 * comp157_Aepsilon;
  comp22_s_inf  =  (comp22_alpha_s(v, comp22_Q10, params)) / (comp22_alpha_s(v, comp22_Q10, params) + comp22_beta_s(v, comp22_Q10, params));
  KM_m_tau  =  1.0 / (comp116_alpha_n(v, comp116_Q10, params) + comp116_beta_n(v, comp116_Q10, params));
  comp83_c_inf  =  (comp83_alpha_c(v, comp83_cai, comp83_Q10, params)) / (comp83_alpha_c(v, comp83_cai, comp83_Q10, params) + comp83_beta_c(v, comp83_cai, comp83_Q10, params));
  comp83_tau_c  =  1.0 / (comp83_alpha_c(v, comp83_cai, comp83_Q10, params) + comp83_beta_c(v, comp83_cai, comp83_Q10, params));
  comp131_n_inf  =  (comp131_alpha_n(v, comp131_Q10, params)) / (comp131_alpha_n(v, comp131_Q10, params) + comp131_beta_n(v, comp131_Q10, params));
  KA_h_inf  =  comp47_b_inf;
  comp22_u_inf  =  (comp22_alpha_u(v, comp22_Q10, params)) / (comp22_alpha_u(v, comp22_Q10, params) + comp22_beta_u(v, comp22_Q10, params));
  comp131_tau_n  =  1.0 / (comp131_alpha_n(v, comp131_Q10, params) + comp131_beta_n(v, comp131_Q10, params));
  comp101_tau_d  =  1.0 / (comp101_alpha_d(v, comp101_Q10, params) + comp101_beta_d(v, comp101_Q10, params));
  comp157_Oon  =  comp157_Q10 * comp157_AOon;
  comp22_tau_s  =  1.0 / (comp22_alpha_s(v, comp22_Q10, params) + comp22_beta_s(v, comp22_Q10, params));
  comp22_tau_u  =  1.0 / (comp22_alpha_u(v, comp22_Q10, params) + comp22_beta_u(v, comp22_Q10, params));
  comp47_tau_a  =  1.0 / (comp47_alpha_a(v, comp47_Q10, params) + comp47_beta_a(v, comp47_Q10, params));
  comp47_tau_b  =  1.0 / (comp47_alpha_b(v, comp47_Q10, params) + comp47_beta_b(v, comp47_Q10, params));
  comp157_gamma  =  comp157_Q10 * comp157_Agamma;
  KV_m_tau  =  comp131_tau_n;
  KCa_m_tau  =  comp83_tau_c;
  KA_m_tau  =  comp47_tau_a;
  CaHVA_h_tau  =  comp22_tau_s;
  comp157_b  =  pow(comp157_Ooff / comp157_Coff, 1.0 / 4.0);
  comp157_a  =  pow(comp157_Oon / comp157_Con, 1.0 / 4.0);
  KA_h_tau  =  comp47_tau_b;
  CaHVA_m_tau  =  comp22_tau_s;
  KV_m_inf  =  comp131_n_inf;
  CaHVA_h_inf  =  comp22_u_inf;
  Kir_m_inf  =  comp101_d_inf;
  CaHVA_m_inf  =  comp22_s_inf;
  KCa_m_inf  =  comp83_c_inf;
  Kir_m_tau  =  comp101_tau_d;
  comp157_Na_z  =  comp157_Na_zO;
  cai  =  comp21_ca;
  cao  =  comp21_cao;
  // rate equation KA_m
  Ith(f,1)  =  (KA_m_inf + -(KA_m)) / KA_m_tau;
  // rate equation KA_h
  Ith(f,2)  =  (KA_h_inf + -(KA_h)) / KA_h_tau;
  // rate equation Kir_m
  Ith(f,3)  =  (Kir_m_inf + -(Kir_m)) / Kir_m_tau;
  // rate equation KV_m
  Ith(f,4)  =  (KV_m_inf + -(KV_m)) / KV_m_tau;
  // rate equation KCa_m
  Ith(f,5)  =  (KCa_m_inf + -(KCa_m)) / KCa_m_tau;
  // rate equation comp157_Na_zI1
  Ith(f,6)  =  -(comp157_Na_zI1 * comp157_Coff + comp157_Na_zI1 * comp157_n1 * comp157_alfa(v, comp157_Q10, params) * comp157_a) + comp157_Na_zC1 * comp157_Con + comp157_Na_zI2 * comp157_n4 * comp157_beta(v, comp157_Q10, params) * comp157_b;
  // rate equation comp157_Na_zC1
  Ith(f,7)  =  -(comp157_Na_zC1 * comp157_Con + comp157_Na_zC1 * comp157_n1 * comp157_alfa(v, comp157_Q10, params)) + comp157_Na_zI1 * comp157_Coff + comp157_Na_zC2 * comp157_n4 * comp157_beta(v, comp157_Q10, params);
  // rate equation comp157_Na_zI2
  Ith(f,8)  =  -(comp157_Na_zI2 * comp157_Coff * comp157_b + comp157_Na_zI2 * comp157_n2 * comp157_alfa(v, comp157_Q10, params) * comp157_a + comp157_Na_zI2 * comp157_n4 * comp157_beta(v, comp157_Q10, params) * comp157_b) + comp157_Na_zC2 * comp157_Con * comp157_a + comp157_Na_zI3 * comp157_n3 * comp157_beta(v, comp157_Q10, params) * comp157_b + comp157_Na_zI1 * comp157_n1 * comp157_alfa(v, comp157_Q10, params) * comp157_a;
  // rate equation comp157_Na_zC2
  Ith(f,9)  =  -(comp157_Na_zC2 * comp157_Con * comp157_a + comp157_Na_zC2 * comp157_n2 * comp157_alfa(v, comp157_Q10, params) + comp157_Na_zC2 * comp157_n4 * comp157_beta(v, comp157_Q10, params)) + comp157_Na_zI2 * comp157_Coff * comp157_b + comp157_Na_zC3 * comp157_n3 * comp157_beta(v, comp157_Q10, params) + comp157_Na_zC1 * comp157_n1 * comp157_alfa(v, comp157_Q10, params);
  // rate equation comp157_Na_zI3
  v242  =  comp157_b; v241  =  comp157_a;; 
Ith(f,10)  =  -(comp157_Na_zI3 * comp157_Coff * v242 * v242 + comp157_Na_zI3 * comp157_n3 * comp157_alfa(v, comp157_Q10, params) * comp157_a + comp157_Na_zI3 * comp157_n3 * comp157_beta(v, comp157_Q10, params) * comp157_b) + comp157_Na_zC3 * comp157_Con * v241 * v241 + comp157_Na_zI4 * comp157_n2 * comp157_beta(v, comp157_Q10, params) * comp157_b + comp157_Na_zI2 * comp157_n2 * comp157_alfa(v, comp157_Q10, params) * comp157_a;
  // rate equation comp157_Na_zC3
  v244  =  comp157_a; v243  =  comp157_b;; 
Ith(f,11)  =  -(comp157_Na_zC3 * comp157_Con * v244 * v244 + comp157_Na_zC3 * comp157_n3 * comp157_alfa(v, comp157_Q10, params) + comp157_Na_zC3 * comp157_n3 * comp157_beta(v, comp157_Q10, params)) + comp157_Na_zI3 * comp157_Coff * v243 * v243 + comp157_Na_zC4 * comp157_n2 * comp157_beta(v, comp157_Q10, params) + comp157_Na_zC2 * comp157_n2 * comp157_alfa(v, comp157_Q10, params);
  // rate equation comp157_Na_zI4
  v246  =  comp157_b; v245  =  comp157_a;; 
Ith(f,12)  =  -(comp157_Na_zI4 * comp157_Coff * v246 * v246 * v246 + comp157_Na_zI4 * comp157_n4 * comp157_alfa(v, comp157_Q10, params) * comp157_a + comp157_Na_zI4 * comp157_n2 * comp157_beta(v, comp157_Q10, params) * comp157_b) + comp157_Na_zC4 * comp157_Con * v245 * v245 * v245 + comp157_Na_zI5 * comp157_n1 * comp157_beta(v, comp157_Q10, params) * comp157_b + comp157_Na_zI3 * comp157_n3 * comp157_alfa(v, comp157_Q10, params) * comp157_a;
  // rate equation comp157_Na_zC4
  v248  =  comp157_a; v247  =  comp157_b;; 
Ith(f,13)  =  -(comp157_Na_zC4 * comp157_Con * v248 * v248 * v248 + comp157_Na_zC4 * comp157_n4 * comp157_alfa(v, comp157_Q10, params) + comp157_Na_zC4 * comp157_n2 * comp157_beta(v, comp157_Q10, params)) + comp157_Na_zI4 * comp157_Coff * v247 * v247 * v247 + comp157_Na_zC5 * comp157_n1 * comp157_beta(v, comp157_Q10, params) + comp157_Na_zC3 * comp157_n3 * comp157_alfa(v, comp157_Q10, params);
  // rate equation comp157_Na_zI5
  v250  =  comp157_b; v249  =  comp157_a;; 
Ith(f,14)  =  -(comp157_Na_zI5 * comp157_Coff * v250 * v250 * v250 * v250 + comp157_Na_zI5 * comp157_gamma + comp157_Na_zI5 * comp157_n1 * comp157_beta(v, comp157_Q10, params) * comp157_b) + comp157_Na_zC5 * comp157_Con * v249 * v249 * v249 * v249 + comp157_Na_zI6 * comp157_delta + comp157_Na_zI4 * comp157_n4 * comp157_alfa(v, comp157_Q10, params) * comp157_a;
  // rate equation comp157_Na_zC5
  v252  =  comp157_a; v251  =  comp157_b;; 
Ith(f,15)  =  -(comp157_Na_zC5 * comp157_Con * v252 * v252 * v252 * v252 + comp157_Na_zC5 * comp157_gamma + comp157_Na_zC5 * comp157_n1 * comp157_beta(v, comp157_Q10, params)) + comp157_Na_zI5 * comp157_Coff * v251 * v251 * v251 * v251 + comp157_Na_zO * comp157_delta + comp157_Na_zC4 * comp157_n4 * comp157_alfa(v, comp157_Q10, params);
  // rate equation comp157_Na_zI6
  Ith(f,16)  =  -(comp157_Na_zI6 * comp157_Ooff + comp157_Na_zI6 * comp157_delta) + comp157_Na_zO * comp157_Oon + comp157_Na_zI5 * comp157_gamma;
  // rate equation comp157_Na_zO
  v253  =  comp157_Na_zI6 + comp157_Na_zI5 + comp157_Na_zI4 + comp157_Na_zI3 + comp157_Na_zI2 + comp157_Na_zI1 + comp157_Na_zO + comp157_Na_zC5 + comp157_Na_zC4 + comp157_Na_zC3 + comp157_Na_zC2 + comp157_Na_zC1;; 
Ith(f,17)  =  -(comp157_Na_zO * comp157_Oon + comp157_Na_zO * comp157_epsilon + comp157_Na_zO * comp157_delta) + comp157_Na_zI6 * comp157_Ooff + (1 - v253) * (comp157_teta(v, comp157_Q10, params)) + comp157_Na_zC5 * comp157_gamma;
  // rate equation CaHVA_m
  Ith(f,18)  =  (CaHVA_m_inf + -(CaHVA_m)) / CaHVA_m_tau;
  // rate equation CaHVA_h
  Ith(f,19)  =  (CaHVA_h_inf + -(CaHVA_h)) / CaHVA_h_tau;
  // rate equation KM_m
  Ith(f,20)  =  (KM_m_inf + -(KM_m)) / KM_m_tau;
  // rate equation comp21_ca
  if (comp21_ca < comp21_cai0) 
      {v256  =  comp21_cai0;} 
      else 
        {v256  =  comp21_ca;}; 
v255  =  v256;; 
  Ith(f,21)  =  (-(comp21_ica)) / (2.0 * comp21_F * comp21_d) * 10000.0 + -(comp21_beta * (v255 + -(comp21_cai0)));
  i_Lkg1  =  comp151_gbar * (v - comp151_e);
  i_Lkg2  =  comp154_ggaba * (v - comp154_egaba);
  i  =  i_Lkg1 + i_Lkg2;
  i_Na  =  (comp157_gbar * comp157_Na_z) * (v - comp157_e);
  ina  =  i_Na;
  v257  =  KV_m;; 
i_KV  =  (comp131_gbar * v257 * v257 * v257 * v257) * (v - comp131_e);
  i_KCa  =  (comp83_gbar * KCa_m) * (v - comp83_e);
  i_Kir  =  (comp101_gbar * Kir_m) * (v - comp101_e);
  i_KM  =  (comp116_gbar * KM_m) * (v - comp116_e);
  v258  =  KA_m;; 
i_KA  =  (comp47_gbar * v258 * v258 * v258 * KA_h) * (v - comp47_e);
  ik  =  i_KV + i_KCa + i_Kir + i_KM + i_KA;
  v259  =  CaHVA_m;; 
i_CaHVA  =  (comp22_gbar * v259 * v259 * CaHVA_h) * (v - comp22_e);
  ica  =  i_CaHVA;
  Ith(f,0)  =  ((node.B_.I_stim_) + -(ik + ica + i + ina)) / comp20_C_m;
  state->cai  =  cai;
  state->cao  =  cao;
  state->i_Lkg1  =  i_Lkg1;
  state->i_Lkg2  =  i_Lkg2;
  state->i  =  i;
  state->i_Na  =  i_Na;
  state->ina  =  ina;
  state->i_KV  =  i_KV;
  state->i_KCa  =  i_KCa;
  state->i_Kir  =  i_Kir;
  state->i_KM  =  i_KM;
  state->i_KA  =  i_KA;
  state->ik  =  ik;
  state->i_CaHVA  =  i_CaHVA;
  state->ica  =  ica;
  i_Lkg1  =  state->i_Lkg1;
  i_Lkg2  =  state->i_Lkg2;
  i  =  state->i;
  i_Na  =  state->i_Na;
  ina  =  state->ina;
  i_KV  =  state->i_KV;
  i_KCa  =  state->i_KCa;
  i_Kir  =  state->i_Kir;
  i_KM  =  state->i_KM;
  i_KA  =  state->i_KA;
  ik  =  state->ik;
  i_CaHVA  =  state->i_CaHVA;
  ica  =  state->ica;
  

  return GSL_SUCCESS;
}


RecordablesMap<Granule> Granule::recordablesMap_;
template <> void RecordablesMap<Granule>::create()
{
  insert_("comp21_ca", &Granule::get_y_elem_<Granule::State_::COMP21_CA>);
  insert_("KM_m", &Granule::get_y_elem_<Granule::State_::KM_M>);
  insert_("CaHVA_h", &Granule::get_y_elem_<Granule::State_::CAHVA_H>);
  insert_("CaHVA_m", &Granule::get_y_elem_<Granule::State_::CAHVA_M>);
  insert_("comp157_Na_zO", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZO>);
  insert_("comp157_Na_zI6", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZI6>);
  insert_("comp157_Na_zC5", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZC5>);
  insert_("comp157_Na_zI5", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZI5>);
  insert_("comp157_Na_zC4", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZC4>);
  insert_("comp157_Na_zI4", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZI4>);
  insert_("comp157_Na_zC3", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZC3>);
  insert_("comp157_Na_zI3", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZI3>);
  insert_("comp157_Na_zC2", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZC2>);
  insert_("comp157_Na_zI2", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZI2>);
  insert_("comp157_Na_zC1", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZC1>);
  insert_("comp157_Na_zI1", &Granule::get_y_elem_<Granule::State_::COMP157_NA_ZI1>);
  insert_("KCa_m", &Granule::get_y_elem_<Granule::State_::KCA_M>);
  insert_("KV_m", &Granule::get_y_elem_<Granule::State_::KV_M>);
  insert_("Kir_m", &Granule::get_y_elem_<Granule::State_::KIR_M>);
  insert_("KA_h", &Granule::get_y_elem_<Granule::State_::KA_H>);
  insert_("KA_m", &Granule::get_y_elem_<Granule::State_::KA_M>);
  insert_("v", &Granule::get_y_elem_<Granule::State_::V>);
  insert_(names::V_m, &Granule::get_y_elem_<Granule::State_::V>);
}




Granule::Parameters_::Parameters_ () :
  comp116_B_ninf  (6.0),
comp21_F  (96485.3),
comp115_vcinc  (10.0),
comp21_d  (0.2),
comp101_Aalpha_d  (0.13289),
comp47_e  (-84.69),
comp173_vcsteps  (9.0),
comp83_Kalpha_c  (-11.765),
comp47_Aalpha_a  (0.8147),
comp47_Aalpha_b  (0.0368),
comp22_Kalpha_u  (-18.183),
comp150_vcinc  (10.0),
comp22_Kalpha_s  (15.87301587302),
comp19_V_t  (-35.0),
comp115_vcsteps  (8.0),
comp47_V0beta_b  (-49.9537),
comp47_V0beta_a  (-18.27914),
comp157_AOon  (0.75),
comp131_Abeta_n  (0.125),
comp154_egaba  (-65.0),
comp151_gbar  (5.68e-05),
comp82_vchdur  (30.0),
comp83_Bbeta_c  (0.00015),
comp21_beta  (1.5),
comp100_vchold  (-71.0),
comp157_ACon  (0.005),
comp173_vcbase  (-60.0),
comp82_vchold  (-71.0),
comp82_vcsteps  (8.0),
comp101_Kbeta_d  (35.714),
comp20_C_m  (0.001),
comp22_Abeta_u  (0.0013),
comp22_gbar  (0.00046),
comp22_Abeta_s  (0.08298),
comp116_V0beta_n  (-30.0),
comp46_vcsteps  (8.0),
comp150_vchdur  (30.0),
comp22_R  (8.31342),
comp82_vcbdur  (100.0),
comp22_F  (96485.3),
comp130_vcbdur  (100.0),
comp83_Abeta_c  (1.5),
comp22_V0beta_s  (-18.66),
comp22_V0beta_u  (-48.0),
comp22_Kbeta_s  (-25.641),
comp22_Kbeta_u  (83.33),
comp101_Abeta_d  (0.16994),
comp46_vcbdur  (100.0),
comp173_vchold  (-71.0),
comp116_e  (-84.69),
comp101_e  (-84.69),
comp157_Valfa  (13.99),
comp131_gbar  (0.003),
comp173_vchdur  (30.0),
comp157_Adelta  (40.0),
comp100_vcinc  (10.0),
comp116_Abeta_n  (0.0033),
comp47_Kalpha_a  (-23.32708),
comp47_Kalpha_b  (12.8433),
comp116_V0_ninf  (-35.0),
comp150_vchold  (-71.0),
comp46_vcinc  (10.0),
comp150_vcsteps  (8.0),
comp116_Aalpha_n  (0.0033),
comp46_vchdur  (30.0),
comp47_K_binf  (8.4),
comp19_celsius  (30.0),
comp130_vchold  (-71.0),
comp100_vcsteps  (8.0),
comp115_vchold  (-71.0),
comp116_Kalpha_n  (40.0),
comp101_gbar  (0.0009),
comp131_Aalpha_n  (-0.01),
comp157_AOoff  (0.005),
comp157_ACoff  (0.5),
comp100_vchdur  (30.0),
comp115_vcbdur  (100.0),
comp150_vcbase  (-69.0),
comp157_Vteta  (25.0),
comp83_Balpha_c  (0.0015),
comp47_V0_binf  (-78.8),
comp83_gbar  (0.04),
comp101_V0beta_d  (-83.94),
comp83_Kbeta_c  (-11.765),
comp46_vcbase  (-69.0),
comp47_V0alpha_b  (-111.33209),
comp47_V0alpha_a  (-9.17203),
comp131_e  (-84.69),
comp157_Aalfa  (353.91),
comp157_Aepsilon  (1.75),
comp130_vcinc  (10.0),
comp82_vcbase  (-69.0),
comp157_e  (87.39),
comp83_Aalpha_c  (2.5),
comp131_Kalpha_n  (-10.0),
comp47_K_ainf  (-17.0),
comp157_Agamma  (150.0),
comp131_V0alpha_n  (-25.0),
comp115_vcbase  (-69.0),
comp101_V0alpha_d  (-83.94),
comp47_Abeta_a  (0.1655),
comp47_Abeta_b  (0.0345),
comp21_cao  (2.0),
comp173_vcbdur  (100.0),
comp22_Aalpha_u  (0.0013),
comp173_vcinc  (10.0),
comp22_Aalpha_s  (0.04944),
comp46_vchold  (-71.0),
comp100_vcbase  (-69.0),
comp82_vcinc  (10.0),
comp157_Vbeta  (13.99),
comp157_gbar  (0.013),
comp83_e  (-84.69),
comp130_vchdur  (30.0),
comp47_Kbeta_b  (-8.90123),
comp47_Kbeta_a  (19.47175),
comp21_cai0  (0.0001),
comp131_Kbeta_n  (-80.0),
comp116_gbar  (0.00025),
comp154_ggaba  (3e-05),
comp47_V0_ainf  (-38.0),
comp150_vcbdur  (100.0),
comp22_V0alpha_s  (-29.06),
comp22_V0alpha_u  (-48.0),
comp157_n1  (5.422),
comp116_V0alpha_n  (-30.0),
comp157_n4  (0.738),
comp157_n2  (3.279),
comp157_n3  (1.83),
comp151_e  (-16.5),
comp116_Kbeta_n  (-20.0),
comp130_vcsteps  (8.0),
comp131_V0beta_n  (-35.0),
comp157_Abeta  (1.272),
comp115_vchdur  (30.0),
comp157_Ateta  (0.0201),
comp47_gbar  (0.0032),
comp100_vcbdur  (100.0),
comp101_Kalpha_d  (-24.3902),
comp130_vcbase  (-69.0)
{
celsius  =  comp19_celsius;
V_t  =  comp19_V_t;
}


Granule::State_::State_ (const Parameters_& p) : r_(0)
{
  double v262, v261, v263, v264, v265, comp21_ca, comp22_cai, comp21_cao, comp22_cao, comp21_cai, comp21_ica, comp83_cai, comp47_K_ainf, comp47_V0_ainf, v, comp47_a_inf, comp19_celsius, comp22_Q10, comp83_Q10, comp83_cai1, comp47_Q10, comp116_B_ninf, comp116_V0_ninf, KM_m_inf, comp131_Q10, comp101_Q10, comp22_F, comp22_R, comp22_e, comp157_Q10, comp47_K_binf, comp47_V0_binf, comp47_b_inf, comp116_Q10, comp157_Adelta, comp157_delta, comp157_ACoff, comp157_Coff, KA_m_inf, comp157_ACon, comp157_Con, comp101_d_inf, comp157_AOoff, comp157_Ooff, comp157_Aepsilon, comp157_epsilon, comp22_s_inf, KM_m_tau, comp83_c_inf, comp83_tau_c, comp131_n_inf, KA_h_inf, comp22_u_inf, comp131_tau_n, comp101_tau_d, comp157_AOon, comp157_Oon, comp22_tau_s, comp22_tau_u, comp47_tau_a, comp47_tau_b, comp157_Agamma, comp157_gamma, KV_m_tau, KCa_m_tau, KA_m_tau, CaHVA_h_tau, comp157_b, comp157_a, KA_h_tau, CaHVA_m_tau, KV_m_inf, CaHVA_h_inf, Kir_m_inf, CaHVA_m_inf, KCa_m_inf, Kir_m_tau, KM_m, KA_m, KA_h, Kir_m, KV_m, KCa_m, CaHVA_m, CaHVA_h, i_Lkg1, i_Lkg2, i, i_Na, ina, i_KV, i_KCa, i_Kir, i_KM, i_KA, ik, i_CaHVA, comp157_Na_zO, comp157_Na_zI6, comp157_Na_zC5, comp157_Na_zI5, comp157_Na_zC4, comp157_Na_zI4, comp157_Na_zC3, comp157_Na_zI3, comp157_Na_zC2, comp157_Na_zI2, comp157_Na_zC1, comp157_Na_zI1, comp21_F, comp115_vcinc, comp21_d, comp101_Aalpha_d, comp47_e, comp173_vcsteps, comp83_Kalpha_c, comp47_Aalpha_a, comp47_Aalpha_b, comp22_Kalpha_u, comp150_vcinc, comp22_Kalpha_s, comp19_V_t, comp115_vcsteps, comp47_V0beta_b, comp47_V0beta_a, comp131_Abeta_n, comp154_egaba, comp151_gbar, comp82_vchdur, comp83_Bbeta_c, comp21_beta, comp100_vchold, comp173_vcbase, comp82_vchold, comp82_vcsteps, comp101_Kbeta_d, comp20_C_m, comp22_Abeta_u, comp22_gbar, comp22_Abeta_s, comp116_V0beta_n, comp46_vcsteps, comp150_vchdur, comp82_vcbdur, comp130_vcbdur, comp83_Abeta_c, comp22_V0beta_s, comp22_V0beta_u, comp22_Kbeta_s, comp22_Kbeta_u, comp101_Abeta_d, comp46_vcbdur, comp173_vchold, comp116_e, comp101_e, comp157_Valfa, comp131_gbar, comp173_vchdur, comp100_vcinc, comp116_Abeta_n, comp47_Kalpha_a, comp47_Kalpha_b, comp150_vchold, comp46_vcinc, comp150_vcsteps, comp116_Aalpha_n, comp46_vchdur, comp130_vchold, comp100_vcsteps, comp115_vchold, comp116_Kalpha_n, comp101_gbar, comp131_Aalpha_n, comp100_vchdur, comp115_vcbdur, comp150_vcbase, comp157_Vteta, comp83_Balpha_c, comp83_gbar, comp101_V0beta_d, comp83_Kbeta_c, comp46_vcbase, comp47_V0alpha_b, comp47_V0alpha_a, comp131_e, comp157_Aalfa, comp130_vcinc, comp82_vcbase, comp157_e, comp83_Aalpha_c, comp131_Kalpha_n, comp131_V0alpha_n, comp115_vcbase, comp101_V0alpha_d, comp47_Abeta_a, comp47_Abeta_b, comp173_vcbdur, comp22_Aalpha_u, comp173_vcinc, comp22_Aalpha_s, comp46_vchold, comp100_vcbase, comp82_vcinc, comp157_Vbeta, comp157_gbar, comp83_e, comp130_vchdur, comp47_Kbeta_b, comp47_Kbeta_a, comp21_cai0, comp131_Kbeta_n, comp116_gbar, comp154_ggaba, comp150_vcbdur, comp22_V0alpha_s, comp22_V0alpha_u, comp157_n1, comp116_V0alpha_n, comp157_n4, comp157_n2, comp157_n3, comp151_e, comp116_Kbeta_n, comp130_vcsteps, comp131_V0beta_n, comp157_Abeta, comp115_vchdur, comp157_Ateta, comp47_gbar, comp100_vcbdur, comp101_Kalpha_d, comp130_vcbase, comp157_Na_z ;
  const Parameters_ *params = &p;
  memset(y_,0,22*sizeof(double));
  comp116_B_ninf  =  p.comp116_B_ninf;
  comp21_F  =  p.comp21_F;
  comp115_vcinc  =  p.comp115_vcinc;
  comp21_d  =  p.comp21_d;
  comp101_Aalpha_d  =  p.comp101_Aalpha_d;
  comp47_e  =  p.comp47_e;
  comp173_vcsteps  =  p.comp173_vcsteps;
  comp83_Kalpha_c  =  p.comp83_Kalpha_c;
  comp47_Aalpha_a  =  p.comp47_Aalpha_a;
  comp47_Aalpha_b  =  p.comp47_Aalpha_b;
  comp22_Kalpha_u  =  p.comp22_Kalpha_u;
  comp150_vcinc  =  p.comp150_vcinc;
  comp22_Kalpha_s  =  p.comp22_Kalpha_s;
  comp19_V_t  =  p.comp19_V_t;
  comp115_vcsteps  =  p.comp115_vcsteps;
  comp47_V0beta_b  =  p.comp47_V0beta_b;
  comp47_V0beta_a  =  p.comp47_V0beta_a;
  comp157_AOon  =  p.comp157_AOon;
  comp131_Abeta_n  =  p.comp131_Abeta_n;
  comp154_egaba  =  p.comp154_egaba;
  comp151_gbar  =  p.comp151_gbar;
  comp82_vchdur  =  p.comp82_vchdur;
  comp83_Bbeta_c  =  p.comp83_Bbeta_c;
  comp21_beta  =  p.comp21_beta;
  comp100_vchold  =  p.comp100_vchold;
  comp157_ACon  =  p.comp157_ACon;
  comp173_vcbase  =  p.comp173_vcbase;
  comp82_vchold  =  p.comp82_vchold;
  comp82_vcsteps  =  p.comp82_vcsteps;
  comp101_Kbeta_d  =  p.comp101_Kbeta_d;
  comp20_C_m  =  p.comp20_C_m;
  comp22_Abeta_u  =  p.comp22_Abeta_u;
  comp22_gbar  =  p.comp22_gbar;
  comp22_Abeta_s  =  p.comp22_Abeta_s;
  comp116_V0beta_n  =  p.comp116_V0beta_n;
  comp46_vcsteps  =  p.comp46_vcsteps;
  comp150_vchdur  =  p.comp150_vchdur;
  comp22_R  =  p.comp22_R;
  comp82_vcbdur  =  p.comp82_vcbdur;
  comp22_F  =  p.comp22_F;
  comp130_vcbdur  =  p.comp130_vcbdur;
  comp83_Abeta_c  =  p.comp83_Abeta_c;
  comp22_V0beta_s  =  p.comp22_V0beta_s;
  comp22_V0beta_u  =  p.comp22_V0beta_u;
  comp22_Kbeta_s  =  p.comp22_Kbeta_s;
  comp22_Kbeta_u  =  p.comp22_Kbeta_u;
  comp101_Abeta_d  =  p.comp101_Abeta_d;
  comp46_vcbdur  =  p.comp46_vcbdur;
  comp173_vchold  =  p.comp173_vchold;
  comp116_e  =  p.comp116_e;
  comp101_e  =  p.comp101_e;
  comp157_Valfa  =  p.comp157_Valfa;
  comp131_gbar  =  p.comp131_gbar;
  comp173_vchdur  =  p.comp173_vchdur;
  comp157_Adelta  =  p.comp157_Adelta;
  comp100_vcinc  =  p.comp100_vcinc;
  comp116_Abeta_n  =  p.comp116_Abeta_n;
  comp47_Kalpha_a  =  p.comp47_Kalpha_a;
  comp47_Kalpha_b  =  p.comp47_Kalpha_b;
  comp116_V0_ninf  =  p.comp116_V0_ninf;
  comp150_vchold  =  p.comp150_vchold;
  comp46_vcinc  =  p.comp46_vcinc;
  comp150_vcsteps  =  p.comp150_vcsteps;
  comp116_Aalpha_n  =  p.comp116_Aalpha_n;
  comp46_vchdur  =  p.comp46_vchdur;
  comp47_K_binf  =  p.comp47_K_binf;
  comp19_celsius  =  p.comp19_celsius;
  comp130_vchold  =  p.comp130_vchold;
  comp100_vcsteps  =  p.comp100_vcsteps;
  comp115_vchold  =  p.comp115_vchold;
  comp116_Kalpha_n  =  p.comp116_Kalpha_n;
  comp101_gbar  =  p.comp101_gbar;
  comp131_Aalpha_n  =  p.comp131_Aalpha_n;
  comp157_AOoff  =  p.comp157_AOoff;
  comp157_ACoff  =  p.comp157_ACoff;
  comp100_vchdur  =  p.comp100_vchdur;
  comp115_vcbdur  =  p.comp115_vcbdur;
  comp150_vcbase  =  p.comp150_vcbase;
  comp157_Vteta  =  p.comp157_Vteta;
  comp83_Balpha_c  =  p.comp83_Balpha_c;
  comp47_V0_binf  =  p.comp47_V0_binf;
  comp83_gbar  =  p.comp83_gbar;
  comp101_V0beta_d  =  p.comp101_V0beta_d;
  comp83_Kbeta_c  =  p.comp83_Kbeta_c;
  comp46_vcbase  =  p.comp46_vcbase;
  comp47_V0alpha_b  =  p.comp47_V0alpha_b;
  comp47_V0alpha_a  =  p.comp47_V0alpha_a;
  comp131_e  =  p.comp131_e;
  comp157_Aalfa  =  p.comp157_Aalfa;
  comp157_Aepsilon  =  p.comp157_Aepsilon;
  comp130_vcinc  =  p.comp130_vcinc;
  comp82_vcbase  =  p.comp82_vcbase;
  comp157_e  =  p.comp157_e;
  comp83_Aalpha_c  =  p.comp83_Aalpha_c;
  comp131_Kalpha_n  =  p.comp131_Kalpha_n;
  comp47_K_ainf  =  p.comp47_K_ainf;
  comp157_Agamma  =  p.comp157_Agamma;
  comp131_V0alpha_n  =  p.comp131_V0alpha_n;
  comp115_vcbase  =  p.comp115_vcbase;
  comp101_V0alpha_d  =  p.comp101_V0alpha_d;
  comp47_Abeta_a  =  p.comp47_Abeta_a;
  comp47_Abeta_b  =  p.comp47_Abeta_b;
  comp21_cao  =  p.comp21_cao;
  comp173_vcbdur  =  p.comp173_vcbdur;
  comp22_Aalpha_u  =  p.comp22_Aalpha_u;
  comp173_vcinc  =  p.comp173_vcinc;
  comp22_Aalpha_s  =  p.comp22_Aalpha_s;
  comp46_vchold  =  p.comp46_vchold;
  comp100_vcbase  =  p.comp100_vcbase;
  comp82_vcinc  =  p.comp82_vcinc;
  comp157_Vbeta  =  p.comp157_Vbeta;
  comp157_gbar  =  p.comp157_gbar;
  comp83_e  =  p.comp83_e;
  comp130_vchdur  =  p.comp130_vchdur;
  comp47_Kbeta_b  =  p.comp47_Kbeta_b;
  comp47_Kbeta_a  =  p.comp47_Kbeta_a;
  comp21_cai0  =  p.comp21_cai0;
  comp131_Kbeta_n  =  p.comp131_Kbeta_n;
  comp116_gbar  =  p.comp116_gbar;
  comp154_ggaba  =  p.comp154_ggaba;
  comp47_V0_ainf  =  p.comp47_V0_ainf;
  comp150_vcbdur  =  p.comp150_vcbdur;
  comp22_V0alpha_s  =  p.comp22_V0alpha_s;
  comp22_V0alpha_u  =  p.comp22_V0alpha_u;
  comp157_n1  =  p.comp157_n1;
  comp116_V0alpha_n  =  p.comp116_V0alpha_n;
  comp157_n4  =  p.comp157_n4;
  comp157_n2  =  p.comp157_n2;
  comp157_n3  =  p.comp157_n3;
  comp151_e  =  p.comp151_e;
  comp116_Kbeta_n  =  p.comp116_Kbeta_n;
  comp130_vcsteps  =  p.comp130_vcsteps;
  comp131_V0beta_n  =  p.comp131_V0beta_n;
  comp157_Abeta  =  p.comp157_Abeta;
  comp115_vchdur  =  p.comp115_vchdur;
  comp157_Ateta  =  p.comp157_Ateta;
  comp47_gbar  =  p.comp47_gbar;
  comp100_vcbdur  =  p.comp100_vcbdur;
  comp101_Kalpha_d  =  p.comp101_Kalpha_d;
  comp130_vcbase  =  p.comp130_vcbase;
  v  =  -65.0;
  comp21_ca  =  0.0001;
  cai  =  comp21_ca;
  comp22_cai  =  cai;
  cao  =  comp21_cao;
  comp22_cao  =  cao;
  comp21_cai  =  cai;
  comp21_ica  =  ica;
  comp83_cai  =  cai;
  comp47_a_inf  =  1.0 / (1.0 + exp((v + -(comp47_V0_ainf)) / comp47_K_ainf));
  comp22_Q10  =  pow(3.0, (comp19_celsius + -20.0) / 10.0);
  comp83_Q10  =  pow(3.0, (comp19_celsius + -30.0) / 10.0);
  if (comp83_cai < 0.0001) {v262  =  0.0001;} else {v262  =  comp83_cai;}; 
v261  =  v262;; comp83_cai1  =  v261;
  comp47_Q10  =  pow(3.0, (comp19_celsius + -25.5) / 10.0);
  KM_m_inf  =  1.0 / (1.0 + exp(-(v + -(comp116_V0_ninf)) / comp116_B_ninf));
  comp131_Q10  =  pow(3.0, (comp19_celsius + -6.3) / 10.0);
  comp101_Q10  =  pow(3.0, (comp19_celsius + -20.0) / 10.0);
  comp22_e  =  (1000.0 * comp22_R * (comp19_celsius + 273.15)) / (2.0 * comp22_F) * log(comp22_cao / comp22_cai);
  comp157_Q10  =  pow(3.0, (comp19_celsius + -20.0) / 10.0);
  comp47_b_inf  =  1.0 / (1.0 + exp((v + -(comp47_V0_binf)) / comp47_K_binf));
  comp116_Q10  =  pow(3.0, (comp19_celsius + -22.0) / 10.0);
  comp157_delta  =  comp157_Q10 * comp157_Adelta;
  comp157_Coff  =  comp157_Q10 * comp157_ACoff;
  KA_m_inf  =  comp47_a_inf;
  comp157_Con  =  comp157_Q10 * comp157_ACon;
  comp101_d_inf  =  (comp101_alpha_d(v, comp101_Q10, params)) / (comp101_alpha_d(v, comp101_Q10, params) + comp101_beta_d(v, comp101_Q10, params));
  comp157_Ooff  =  comp157_Q10 * comp157_AOoff;
  comp157_epsilon  =  comp157_Q10 * comp157_Aepsilon;
  comp22_s_inf  =  (comp22_alpha_s(v, comp22_Q10, params)) / (comp22_alpha_s(v, comp22_Q10, params) + comp22_beta_s(v, comp22_Q10, params));
  KM_m_tau  =  1.0 / (comp116_alpha_n(v, comp116_Q10, params) + comp116_beta_n(v, comp116_Q10, params));
  comp83_c_inf  =  (comp83_alpha_c(v, comp83_cai, comp83_Q10, params)) / (comp83_alpha_c(v, comp83_cai, comp83_Q10, params) + comp83_beta_c(v, comp83_cai, comp83_Q10, params));
  comp83_tau_c  =  1.0 / (comp83_alpha_c(v, comp83_cai, comp83_Q10, params) + comp83_beta_c(v, comp83_cai, comp83_Q10, params));
  comp131_n_inf  =  (comp131_alpha_n(v, comp131_Q10, params)) / (comp131_alpha_n(v, comp131_Q10, params) + comp131_beta_n(v, comp131_Q10, params));
  KA_h_inf  =  comp47_b_inf;
  comp22_u_inf  =  (comp22_alpha_u(v, comp22_Q10, params)) / (comp22_alpha_u(v, comp22_Q10, params) + comp22_beta_u(v, comp22_Q10, params));
  comp131_tau_n  =  1.0 / (comp131_alpha_n(v, comp131_Q10, params) + comp131_beta_n(v, comp131_Q10, params));
  comp101_tau_d  =  1.0 / (comp101_alpha_d(v, comp101_Q10, params) + comp101_beta_d(v, comp101_Q10, params));
  comp157_Oon  =  comp157_Q10 * comp157_AOon;
  comp22_tau_s  =  1.0 / (comp22_alpha_s(v, comp22_Q10, params) + comp22_beta_s(v, comp22_Q10, params));
  comp22_tau_u  =  1.0 / (comp22_alpha_u(v, comp22_Q10, params) + comp22_beta_u(v, comp22_Q10, params));
  comp47_tau_a  =  1.0 / (comp47_alpha_a(v, comp47_Q10, params) + comp47_beta_a(v, comp47_Q10, params));
  comp47_tau_b  =  1.0 / (comp47_alpha_b(v, comp47_Q10, params) + comp47_beta_b(v, comp47_Q10, params));
  comp157_gamma  =  comp157_Q10 * comp157_Agamma;
  KV_m_tau  =  comp131_tau_n;
  KCa_m_tau  =  comp83_tau_c;
  KA_m_tau  =  comp47_tau_a;
  CaHVA_h_tau  =  comp22_tau_s;
  comp157_b  =  pow(comp157_Ooff / comp157_Coff, 1.0 / 4.0);
  comp157_a  =  pow(comp157_Oon / comp157_Con, 1.0 / 4.0);
  KA_h_tau  =  comp47_tau_b;
  CaHVA_m_tau  =  comp22_tau_s;
  KV_m_inf  =  comp131_n_inf;
  CaHVA_h_inf  =  comp22_u_inf;
  Kir_m_inf  =  comp101_d_inf;
  CaHVA_m_inf  =  comp22_s_inf;
  KCa_m_inf  =  comp83_c_inf;
  Kir_m_tau  =  comp101_tau_d;
  KM_m  =  1.0 / (1.0 + exp(-(v + -(comp116_V0_ninf)) / comp116_B_ninf));
  KA_m  =  1.0 / (1.0 + exp((v + -(comp47_V0_ainf)) / comp47_K_ainf));
  KA_h  =  1.0 / (1.0 + exp((v + -(comp47_V0_binf)) / comp47_K_binf));
  Kir_m  =  comp101_d_inf;
  KV_m  =  comp131_n_inf;
  KCa_m  =  comp83_c_inf;
  CaHVA_m  =  comp22_s_inf;
  CaHVA_h  =  comp22_u_inf;
  y_[21]  =  comp21_ca;
  y_[20]  =  KM_m;
  y_[1]  =  KA_m;
  y_[2]  =  KA_h;
  y_[3]  =  Kir_m;
  y_[4]  =  KV_m;
  y_[5]  =  KCa_m;
  y_[18]  =  CaHVA_m;
  y_[19]  =  CaHVA_h;
  comp157_Na_z  =  comp157_Na_zO;
  i_Lkg1  =  comp151_gbar * (v - comp151_e);
  i_Lkg2  =  comp154_ggaba * (v - comp154_egaba);
  i  =  i_Lkg1 + i_Lkg2;
  i_Na  =  (comp157_gbar * comp157_Na_z) * (v - comp157_e);
  ina  =  i_Na;
  v263  =  KV_m;; 
i_KV  =  (comp131_gbar * v263 * v263 * v263 * v263) * (v - comp131_e);
  i_KCa  =  (comp83_gbar * KCa_m) * (v - comp83_e);
  i_Kir  =  (comp101_gbar * Kir_m) * (v - comp101_e);
  i_KM  =  (comp116_gbar * KM_m) * (v - comp116_e);
  v264  =  KA_m;; 
i_KA  =  (comp47_gbar * v264 * v264 * v264 * KA_h) * (v - comp47_e);
  ik  =  i_KV + i_KCa + i_Kir + i_KM + i_KA;
  v265  =  CaHVA_m;; 
i_CaHVA  =  (comp22_gbar * v265 * v265 * CaHVA_h) * (v - comp22_e);
  ica  =  i_CaHVA;
  y_[0]  =  v;
}


Granule::State_::State_ (const State_& s) : 
r_(s.r_),
cai(s.cai),
cao(s.cao)
{
  for ( int i = 0 ; i < 22 ; ++i ) y_[i] = s.y_[i];
}


Granule::State_& Granule::State_::operator=(const State_& s)
{
     assert(this != &s);  
     for ( size_t i = 0 ; i < 22 ; ++i )
       y_[i] = s.y_[i];
  r_  =  s.r_;
cai  =  s.cai;
cao  =  s.cao;
  return *this;
}




void Granule::Parameters_::get (DictionaryDatum &d) const
{
  def<double_t>(d, "comp116_B_ninf", comp116_B_ninf);
  def<double_t>(d, "comp21_F", comp21_F);
  def<double_t>(d, "comp115_vcinc", comp115_vcinc);
  def<double_t>(d, "comp21_d", comp21_d);
  def<double_t>(d, "comp101_Aalpha_d", comp101_Aalpha_d);
  def<double_t>(d, "comp47_e", comp47_e);
  def<double_t>(d, "comp173_vcsteps", comp173_vcsteps);
  def<double_t>(d, "comp83_Kalpha_c", comp83_Kalpha_c);
  def<double_t>(d, "comp47_Aalpha_a", comp47_Aalpha_a);
  def<double_t>(d, "comp47_Aalpha_b", comp47_Aalpha_b);
  def<double_t>(d, "comp22_Kalpha_u", comp22_Kalpha_u);
  def<double_t>(d, "comp150_vcinc", comp150_vcinc);
  def<double_t>(d, "comp22_Kalpha_s", comp22_Kalpha_s);
  def<double_t>(d, "comp19_V_t", comp19_V_t);
  def<double_t>(d, "comp115_vcsteps", comp115_vcsteps);
  def<double_t>(d, "comp47_V0beta_b", comp47_V0beta_b);
  def<double_t>(d, "comp47_V0beta_a", comp47_V0beta_a);
  def<double_t>(d, "comp157_AOon", comp157_AOon);
  def<double_t>(d, "comp131_Abeta_n", comp131_Abeta_n);
  def<double_t>(d, "comp154_egaba", comp154_egaba);
  def<double_t>(d, "comp151_gbar", comp151_gbar);
  def<double_t>(d, "comp82_vchdur", comp82_vchdur);
  def<double_t>(d, "comp83_Bbeta_c", comp83_Bbeta_c);
  def<double_t>(d, "comp21_beta", comp21_beta);
  def<double_t>(d, "comp100_vchold", comp100_vchold);
  def<double_t>(d, "comp157_ACon", comp157_ACon);
  def<double_t>(d, "comp173_vcbase", comp173_vcbase);
  def<double_t>(d, "comp82_vchold", comp82_vchold);
  def<double_t>(d, "comp82_vcsteps", comp82_vcsteps);
  def<double_t>(d, "comp101_Kbeta_d", comp101_Kbeta_d);
  def<double_t>(d, "comp20_C_m", comp20_C_m);
  def<double_t>(d, "comp22_Abeta_u", comp22_Abeta_u);
  def<double_t>(d, "comp22_gbar", comp22_gbar);
  def<double_t>(d, "comp22_Abeta_s", comp22_Abeta_s);
  def<double_t>(d, "comp116_V0beta_n", comp116_V0beta_n);
  def<double_t>(d, "comp46_vcsteps", comp46_vcsteps);
  def<double_t>(d, "comp150_vchdur", comp150_vchdur);
  def<double_t>(d, "comp22_R", comp22_R);
  def<double_t>(d, "comp82_vcbdur", comp82_vcbdur);
  def<double_t>(d, "comp22_F", comp22_F);
  def<double_t>(d, "comp130_vcbdur", comp130_vcbdur);
  def<double_t>(d, "comp83_Abeta_c", comp83_Abeta_c);
  def<double_t>(d, "comp22_V0beta_s", comp22_V0beta_s);
  def<double_t>(d, "comp22_V0beta_u", comp22_V0beta_u);
  def<double_t>(d, "comp22_Kbeta_s", comp22_Kbeta_s);
  def<double_t>(d, "comp22_Kbeta_u", comp22_Kbeta_u);
  def<double_t>(d, "comp101_Abeta_d", comp101_Abeta_d);
  def<double_t>(d, "comp46_vcbdur", comp46_vcbdur);
  def<double_t>(d, "comp173_vchold", comp173_vchold);
  def<double_t>(d, "comp116_e", comp116_e);
  def<double_t>(d, "comp101_e", comp101_e);
  def<double_t>(d, "comp157_Valfa", comp157_Valfa);
  def<double_t>(d, "comp131_gbar", comp131_gbar);
  def<double_t>(d, "comp173_vchdur", comp173_vchdur);
  def<double_t>(d, "comp157_Adelta", comp157_Adelta);
  def<double_t>(d, "comp100_vcinc", comp100_vcinc);
  def<double_t>(d, "comp116_Abeta_n", comp116_Abeta_n);
  def<double_t>(d, "comp47_Kalpha_a", comp47_Kalpha_a);
  def<double_t>(d, "comp47_Kalpha_b", comp47_Kalpha_b);
  def<double_t>(d, "comp116_V0_ninf", comp116_V0_ninf);
  def<double_t>(d, "comp150_vchold", comp150_vchold);
  def<double_t>(d, "comp46_vcinc", comp46_vcinc);
  def<double_t>(d, "comp150_vcsteps", comp150_vcsteps);
  def<double_t>(d, "comp116_Aalpha_n", comp116_Aalpha_n);
  def<double_t>(d, "comp46_vchdur", comp46_vchdur);
  def<double_t>(d, "comp47_K_binf", comp47_K_binf);
  def<double_t>(d, "comp19_celsius", comp19_celsius);
  def<double_t>(d, "comp130_vchold", comp130_vchold);
  def<double_t>(d, "comp100_vcsteps", comp100_vcsteps);
  def<double_t>(d, "comp115_vchold", comp115_vchold);
  def<double_t>(d, "comp116_Kalpha_n", comp116_Kalpha_n);
  def<double_t>(d, "comp101_gbar", comp101_gbar);
  def<double_t>(d, "comp131_Aalpha_n", comp131_Aalpha_n);
  def<double_t>(d, "comp157_AOoff", comp157_AOoff);
  def<double_t>(d, "comp157_ACoff", comp157_ACoff);
  def<double_t>(d, "comp100_vchdur", comp100_vchdur);
  def<double_t>(d, "comp115_vcbdur", comp115_vcbdur);
  def<double_t>(d, "comp150_vcbase", comp150_vcbase);
  def<double_t>(d, "comp157_Vteta", comp157_Vteta);
  def<double_t>(d, "comp83_Balpha_c", comp83_Balpha_c);
  def<double_t>(d, "comp47_V0_binf", comp47_V0_binf);
  def<double_t>(d, "comp83_gbar", comp83_gbar);
  def<double_t>(d, "comp101_V0beta_d", comp101_V0beta_d);
  def<double_t>(d, "comp83_Kbeta_c", comp83_Kbeta_c);
  def<double_t>(d, "comp46_vcbase", comp46_vcbase);
  def<double_t>(d, "comp47_V0alpha_b", comp47_V0alpha_b);
  def<double_t>(d, "comp47_V0alpha_a", comp47_V0alpha_a);
  def<double_t>(d, "comp131_e", comp131_e);
  def<double_t>(d, "comp157_Aalfa", comp157_Aalfa);
  def<double_t>(d, "comp157_Aepsilon", comp157_Aepsilon);
  def<double_t>(d, "comp130_vcinc", comp130_vcinc);
  def<double_t>(d, "comp82_vcbase", comp82_vcbase);
  def<double_t>(d, "comp157_e", comp157_e);
  def<double_t>(d, "comp83_Aalpha_c", comp83_Aalpha_c);
  def<double_t>(d, "comp131_Kalpha_n", comp131_Kalpha_n);
  def<double_t>(d, "comp47_K_ainf", comp47_K_ainf);
  def<double_t>(d, "comp157_Agamma", comp157_Agamma);
  def<double_t>(d, "comp131_V0alpha_n", comp131_V0alpha_n);
  def<double_t>(d, "comp115_vcbase", comp115_vcbase);
  def<double_t>(d, "comp101_V0alpha_d", comp101_V0alpha_d);
  def<double_t>(d, "comp47_Abeta_a", comp47_Abeta_a);
  def<double_t>(d, "comp47_Abeta_b", comp47_Abeta_b);
  def<double_t>(d, "comp21_cao", comp21_cao);
  def<double_t>(d, "comp173_vcbdur", comp173_vcbdur);
  def<double_t>(d, "comp22_Aalpha_u", comp22_Aalpha_u);
  def<double_t>(d, "comp173_vcinc", comp173_vcinc);
  def<double_t>(d, "comp22_Aalpha_s", comp22_Aalpha_s);
  def<double_t>(d, "comp46_vchold", comp46_vchold);
  def<double_t>(d, "comp100_vcbase", comp100_vcbase);
  def<double_t>(d, "comp82_vcinc", comp82_vcinc);
  def<double_t>(d, "comp157_Vbeta", comp157_Vbeta);
  def<double_t>(d, "comp157_gbar", comp157_gbar);
  def<double_t>(d, "comp83_e", comp83_e);
  def<double_t>(d, "comp130_vchdur", comp130_vchdur);
  def<double_t>(d, "comp47_Kbeta_b", comp47_Kbeta_b);
  def<double_t>(d, "comp47_Kbeta_a", comp47_Kbeta_a);
  def<double_t>(d, "comp21_cai0", comp21_cai0);
  def<double_t>(d, "comp131_Kbeta_n", comp131_Kbeta_n);
  def<double_t>(d, "comp116_gbar", comp116_gbar);
  def<double_t>(d, "comp154_ggaba", comp154_ggaba);
  def<double_t>(d, "comp47_V0_ainf", comp47_V0_ainf);
  def<double_t>(d, "comp150_vcbdur", comp150_vcbdur);
  def<double_t>(d, "comp22_V0alpha_s", comp22_V0alpha_s);
  def<double_t>(d, "comp22_V0alpha_u", comp22_V0alpha_u);
  def<double_t>(d, "comp157_n1", comp157_n1);
  def<double_t>(d, "comp116_V0alpha_n", comp116_V0alpha_n);
  def<double_t>(d, "comp157_n4", comp157_n4);
  def<double_t>(d, "comp157_n2", comp157_n2);
  def<double_t>(d, "comp157_n3", comp157_n3);
  def<double_t>(d, "comp151_e", comp151_e);
  def<double_t>(d, "comp116_Kbeta_n", comp116_Kbeta_n);
  def<double_t>(d, "comp130_vcsteps", comp130_vcsteps);
  def<double_t>(d, "comp131_V0beta_n", comp131_V0beta_n);
  def<double_t>(d, "comp157_Abeta", comp157_Abeta);
  def<double_t>(d, "comp115_vchdur", comp115_vchdur);
  def<double_t>(d, "comp157_Ateta", comp157_Ateta);
  def<double_t>(d, "comp47_gbar", comp47_gbar);
  def<double_t>(d, "comp100_vcbdur", comp100_vcbdur);
  def<double_t>(d, "comp101_Kalpha_d", comp101_Kalpha_d);
  def<double_t>(d, "comp130_vcbase", comp130_vcbase);
}


void Granule::Parameters_::set (const DictionaryDatum &d)
{
  updateValue<double_t>(d, "comp116_B_ninf", comp116_B_ninf);
  updateValue<double_t>(d, "comp21_F", comp21_F);
  updateValue<double_t>(d, "comp115_vcinc", comp115_vcinc);
  updateValue<double_t>(d, "comp21_d", comp21_d);
  updateValue<double_t>(d, "comp101_Aalpha_d", comp101_Aalpha_d);
  updateValue<double_t>(d, "comp47_e", comp47_e);
  updateValue<double_t>(d, "comp173_vcsteps", comp173_vcsteps);
  updateValue<double_t>(d, "comp83_Kalpha_c", comp83_Kalpha_c);
  updateValue<double_t>(d, "comp47_Aalpha_a", comp47_Aalpha_a);
  updateValue<double_t>(d, "comp47_Aalpha_b", comp47_Aalpha_b);
  updateValue<double_t>(d, "comp22_Kalpha_u", comp22_Kalpha_u);
  updateValue<double_t>(d, "comp150_vcinc", comp150_vcinc);
  updateValue<double_t>(d, "comp22_Kalpha_s", comp22_Kalpha_s);
  updateValue<double_t>(d, "comp19_V_t", comp19_V_t);
  updateValue<double_t>(d, "comp115_vcsteps", comp115_vcsteps);
  updateValue<double_t>(d, "comp47_V0beta_b", comp47_V0beta_b);
  updateValue<double_t>(d, "comp47_V0beta_a", comp47_V0beta_a);
  updateValue<double_t>(d, "comp157_AOon", comp157_AOon);
  updateValue<double_t>(d, "comp131_Abeta_n", comp131_Abeta_n);
  updateValue<double_t>(d, "comp154_egaba", comp154_egaba);
  updateValue<double_t>(d, "comp151_gbar", comp151_gbar);
  updateValue<double_t>(d, "comp82_vchdur", comp82_vchdur);
  updateValue<double_t>(d, "comp83_Bbeta_c", comp83_Bbeta_c);
  updateValue<double_t>(d, "comp21_beta", comp21_beta);
  updateValue<double_t>(d, "comp100_vchold", comp100_vchold);
  updateValue<double_t>(d, "comp157_ACon", comp157_ACon);
  updateValue<double_t>(d, "comp173_vcbase", comp173_vcbase);
  updateValue<double_t>(d, "comp82_vchold", comp82_vchold);
  updateValue<double_t>(d, "comp82_vcsteps", comp82_vcsteps);
  updateValue<double_t>(d, "comp101_Kbeta_d", comp101_Kbeta_d);
  updateValue<double_t>(d, "comp20_C_m", comp20_C_m);
  updateValue<double_t>(d, "comp22_Abeta_u", comp22_Abeta_u);
  updateValue<double_t>(d, "comp22_gbar", comp22_gbar);
  updateValue<double_t>(d, "comp22_Abeta_s", comp22_Abeta_s);
  updateValue<double_t>(d, "comp116_V0beta_n", comp116_V0beta_n);
  updateValue<double_t>(d, "comp46_vcsteps", comp46_vcsteps);
  updateValue<double_t>(d, "comp150_vchdur", comp150_vchdur);
  updateValue<double_t>(d, "comp22_R", comp22_R);
  updateValue<double_t>(d, "comp82_vcbdur", comp82_vcbdur);
  updateValue<double_t>(d, "comp22_F", comp22_F);
  updateValue<double_t>(d, "comp130_vcbdur", comp130_vcbdur);
  updateValue<double_t>(d, "comp83_Abeta_c", comp83_Abeta_c);
  updateValue<double_t>(d, "comp22_V0beta_s", comp22_V0beta_s);
  updateValue<double_t>(d, "comp22_V0beta_u", comp22_V0beta_u);
  updateValue<double_t>(d, "comp22_Kbeta_s", comp22_Kbeta_s);
  updateValue<double_t>(d, "comp22_Kbeta_u", comp22_Kbeta_u);
  updateValue<double_t>(d, "comp101_Abeta_d", comp101_Abeta_d);
  updateValue<double_t>(d, "comp46_vcbdur", comp46_vcbdur);
  updateValue<double_t>(d, "comp173_vchold", comp173_vchold);
  updateValue<double_t>(d, "comp116_e", comp116_e);
  updateValue<double_t>(d, "comp101_e", comp101_e);
  updateValue<double_t>(d, "comp157_Valfa", comp157_Valfa);
  updateValue<double_t>(d, "comp131_gbar", comp131_gbar);
  updateValue<double_t>(d, "comp173_vchdur", comp173_vchdur);
  updateValue<double_t>(d, "comp157_Adelta", comp157_Adelta);
  updateValue<double_t>(d, "comp100_vcinc", comp100_vcinc);
  updateValue<double_t>(d, "comp116_Abeta_n", comp116_Abeta_n);
  updateValue<double_t>(d, "comp47_Kalpha_a", comp47_Kalpha_a);
  updateValue<double_t>(d, "comp47_Kalpha_b", comp47_Kalpha_b);
  updateValue<double_t>(d, "comp116_V0_ninf", comp116_V0_ninf);
  updateValue<double_t>(d, "comp150_vchold", comp150_vchold);
  updateValue<double_t>(d, "comp46_vcinc", comp46_vcinc);
  updateValue<double_t>(d, "comp150_vcsteps", comp150_vcsteps);
  updateValue<double_t>(d, "comp116_Aalpha_n", comp116_Aalpha_n);
  updateValue<double_t>(d, "comp46_vchdur", comp46_vchdur);
  updateValue<double_t>(d, "comp47_K_binf", comp47_K_binf);
  updateValue<double_t>(d, "comp19_celsius", comp19_celsius);
  updateValue<double_t>(d, "comp130_vchold", comp130_vchold);
  updateValue<double_t>(d, "comp100_vcsteps", comp100_vcsteps);
  updateValue<double_t>(d, "comp115_vchold", comp115_vchold);
  updateValue<double_t>(d, "comp116_Kalpha_n", comp116_Kalpha_n);
  updateValue<double_t>(d, "comp101_gbar", comp101_gbar);
  updateValue<double_t>(d, "comp131_Aalpha_n", comp131_Aalpha_n);
  updateValue<double_t>(d, "comp157_AOoff", comp157_AOoff);
  updateValue<double_t>(d, "comp157_ACoff", comp157_ACoff);
  updateValue<double_t>(d, "comp100_vchdur", comp100_vchdur);
  updateValue<double_t>(d, "comp115_vcbdur", comp115_vcbdur);
  updateValue<double_t>(d, "comp150_vcbase", comp150_vcbase);
  updateValue<double_t>(d, "comp157_Vteta", comp157_Vteta);
  updateValue<double_t>(d, "comp83_Balpha_c", comp83_Balpha_c);
  updateValue<double_t>(d, "comp47_V0_binf", comp47_V0_binf);
  updateValue<double_t>(d, "comp83_gbar", comp83_gbar);
  updateValue<double_t>(d, "comp101_V0beta_d", comp101_V0beta_d);
  updateValue<double_t>(d, "comp83_Kbeta_c", comp83_Kbeta_c);
  updateValue<double_t>(d, "comp46_vcbase", comp46_vcbase);
  updateValue<double_t>(d, "comp47_V0alpha_b", comp47_V0alpha_b);
  updateValue<double_t>(d, "comp47_V0alpha_a", comp47_V0alpha_a);
  updateValue<double_t>(d, "comp131_e", comp131_e);
  updateValue<double_t>(d, "comp157_Aalfa", comp157_Aalfa);
  updateValue<double_t>(d, "comp157_Aepsilon", comp157_Aepsilon);
  updateValue<double_t>(d, "comp130_vcinc", comp130_vcinc);
  updateValue<double_t>(d, "comp82_vcbase", comp82_vcbase);
  updateValue<double_t>(d, "comp157_e", comp157_e);
  updateValue<double_t>(d, "comp83_Aalpha_c", comp83_Aalpha_c);
  updateValue<double_t>(d, "comp131_Kalpha_n", comp131_Kalpha_n);
  updateValue<double_t>(d, "comp47_K_ainf", comp47_K_ainf);
  updateValue<double_t>(d, "comp157_Agamma", comp157_Agamma);
  updateValue<double_t>(d, "comp131_V0alpha_n", comp131_V0alpha_n);
  updateValue<double_t>(d, "comp115_vcbase", comp115_vcbase);
  updateValue<double_t>(d, "comp101_V0alpha_d", comp101_V0alpha_d);
  updateValue<double_t>(d, "comp47_Abeta_a", comp47_Abeta_a);
  updateValue<double_t>(d, "comp47_Abeta_b", comp47_Abeta_b);
  updateValue<double_t>(d, "comp21_cao", comp21_cao);
  updateValue<double_t>(d, "comp173_vcbdur", comp173_vcbdur);
  updateValue<double_t>(d, "comp22_Aalpha_u", comp22_Aalpha_u);
  updateValue<double_t>(d, "comp173_vcinc", comp173_vcinc);
  updateValue<double_t>(d, "comp22_Aalpha_s", comp22_Aalpha_s);
  updateValue<double_t>(d, "comp46_vchold", comp46_vchold);
  updateValue<double_t>(d, "comp100_vcbase", comp100_vcbase);
  updateValue<double_t>(d, "comp82_vcinc", comp82_vcinc);
  updateValue<double_t>(d, "comp157_Vbeta", comp157_Vbeta);
  updateValue<double_t>(d, "comp157_gbar", comp157_gbar);
  updateValue<double_t>(d, "comp83_e", comp83_e);
  updateValue<double_t>(d, "comp130_vchdur", comp130_vchdur);
  updateValue<double_t>(d, "comp47_Kbeta_b", comp47_Kbeta_b);
  updateValue<double_t>(d, "comp47_Kbeta_a", comp47_Kbeta_a);
  updateValue<double_t>(d, "comp21_cai0", comp21_cai0);
  updateValue<double_t>(d, "comp131_Kbeta_n", comp131_Kbeta_n);
  updateValue<double_t>(d, "comp116_gbar", comp116_gbar);
  updateValue<double_t>(d, "comp154_ggaba", comp154_ggaba);
  updateValue<double_t>(d, "comp47_V0_ainf", comp47_V0_ainf);
  updateValue<double_t>(d, "comp150_vcbdur", comp150_vcbdur);
  updateValue<double_t>(d, "comp22_V0alpha_s", comp22_V0alpha_s);
  updateValue<double_t>(d, "comp22_V0alpha_u", comp22_V0alpha_u);
  updateValue<double_t>(d, "comp157_n1", comp157_n1);
  updateValue<double_t>(d, "comp116_V0alpha_n", comp116_V0alpha_n);
  updateValue<double_t>(d, "comp157_n4", comp157_n4);
  updateValue<double_t>(d, "comp157_n2", comp157_n2);
  updateValue<double_t>(d, "comp157_n3", comp157_n3);
  updateValue<double_t>(d, "comp151_e", comp151_e);
  updateValue<double_t>(d, "comp116_Kbeta_n", comp116_Kbeta_n);
  updateValue<double_t>(d, "comp130_vcsteps", comp130_vcsteps);
  updateValue<double_t>(d, "comp131_V0beta_n", comp131_V0beta_n);
  updateValue<double_t>(d, "comp157_Abeta", comp157_Abeta);
  updateValue<double_t>(d, "comp115_vchdur", comp115_vchdur);
  updateValue<double_t>(d, "comp157_Ateta", comp157_Ateta);
  updateValue<double_t>(d, "comp47_gbar", comp47_gbar);
  updateValue<double_t>(d, "comp100_vcbdur", comp100_vcbdur);
  updateValue<double_t>(d, "comp101_Kalpha_d", comp101_Kalpha_d);
  updateValue<double_t>(d, "comp130_vcbase", comp130_vcbase);
}


void Granule::State_::get (DictionaryDatum &d) const
{
  def<double_t>(d, "i_Lkg1", i_Lkg1);
  def<double_t>(d, "i_Lkg2", i_Lkg2);
  def<double_t>(d, "i", i);
  def<double_t>(d, "i_Na", i_Na);
  def<double_t>(d, "ina", ina);
  def<double_t>(d, "i_KV", i_KV);
  def<double_t>(d, "i_KCa", i_KCa);
  def<double_t>(d, "i_Kir", i_Kir);
  def<double_t>(d, "i_KM", i_KM);
  def<double_t>(d, "i_KA", i_KA);
  def<double_t>(d, "ik", ik);
  def<double_t>(d, "i_CaHVA", i_CaHVA);
  def<double_t>(d, "ica", ica);
  def<double_t>(d, "cai", cai);
  def<double_t>(d, "cao", cao);
  def<double_t>(d, "comp21_ca", y_[21]);
  def<double_t>(d, "KM_m", y_[20]);
  def<double_t>(d, "CaHVA_h", y_[19]);
  def<double_t>(d, "CaHVA_m", y_[18]);
  def<double_t>(d, "comp157_Na_zO", y_[17]);
  def<double_t>(d, "comp157_Na_zI6", y_[16]);
  def<double_t>(d, "comp157_Na_zC5", y_[15]);
  def<double_t>(d, "comp157_Na_zI5", y_[14]);
  def<double_t>(d, "comp157_Na_zC4", y_[13]);
  def<double_t>(d, "comp157_Na_zI4", y_[12]);
  def<double_t>(d, "comp157_Na_zC3", y_[11]);
  def<double_t>(d, "comp157_Na_zI3", y_[10]);
  def<double_t>(d, "comp157_Na_zC2", y_[9]);
  def<double_t>(d, "comp157_Na_zI2", y_[8]);
  def<double_t>(d, "comp157_Na_zC1", y_[7]);
  def<double_t>(d, "comp157_Na_zI1", y_[6]);
  def<double_t>(d, "KCa_m", y_[5]);
  def<double_t>(d, "KV_m", y_[4]);
  def<double_t>(d, "Kir_m", y_[3]);
  def<double_t>(d, "KA_h", y_[2]);
  def<double_t>(d, "KA_m", y_[1]);
  def<double_t>(d, "v", y_[0]);
}


void Granule::State_::set (const DictionaryDatum &d, const Parameters_&)
{
  updateValue<double_t>(d, "i_Lkg1", i_Lkg1);
  updateValue<double_t>(d, "i_Lkg2", i_Lkg2);
  updateValue<double_t>(d, "i", i);
  updateValue<double_t>(d, "i_Na", i_Na);
  updateValue<double_t>(d, "ina", ina);
  updateValue<double_t>(d, "i_KV", i_KV);
  updateValue<double_t>(d, "i_KCa", i_KCa);
  updateValue<double_t>(d, "i_Kir", i_Kir);
  updateValue<double_t>(d, "i_KM", i_KM);
  updateValue<double_t>(d, "i_KA", i_KA);
  updateValue<double_t>(d, "ik", ik);
  updateValue<double_t>(d, "i_CaHVA", i_CaHVA);
  updateValue<double_t>(d, "ica", ica);
  updateValue<double_t>(d, "cai", cai);
  updateValue<double_t>(d, "cao", cao);
  updateValue<double_t>(d, "comp21_ca", y_[21]);
  updateValue<double_t>(d, "KM_m", y_[20]);
  updateValue<double_t>(d, "CaHVA_h", y_[19]);
  updateValue<double_t>(d, "CaHVA_m", y_[18]);
  updateValue<double_t>(d, "comp157_Na_zO", y_[17]);
  updateValue<double_t>(d, "comp157_Na_zI6", y_[16]);
  updateValue<double_t>(d, "comp157_Na_zC5", y_[15]);
  updateValue<double_t>(d, "comp157_Na_zI5", y_[14]);
  updateValue<double_t>(d, "comp157_Na_zC4", y_[13]);
  updateValue<double_t>(d, "comp157_Na_zI4", y_[12]);
  updateValue<double_t>(d, "comp157_Na_zC3", y_[11]);
  updateValue<double_t>(d, "comp157_Na_zI3", y_[10]);
  updateValue<double_t>(d, "comp157_Na_zC2", y_[9]);
  updateValue<double_t>(d, "comp157_Na_zI2", y_[8]);
  updateValue<double_t>(d, "comp157_Na_zC1", y_[7]);
  updateValue<double_t>(d, "comp157_Na_zI1", y_[6]);
  updateValue<double_t>(d, "KCa_m", y_[5]);
  updateValue<double_t>(d, "KV_m", y_[4]);
  updateValue<double_t>(d, "Kir_m", y_[3]);
  updateValue<double_t>(d, "KA_h", y_[2]);
  updateValue<double_t>(d, "KA_m", y_[1]);
  updateValue<double_t>(d, "v", y_[0]);
}




Granule::Buffers_::Buffers_(Granule& n)
    : logger_(n),
      s_(0),
      c_(0),
      e_(0)
{
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}
Granule::Buffers_::Buffers_(const Buffers_&, Granule& n)
    : logger_(n),
      s_(0),
      c_(0),
      e_(0)
{
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}


Granule::Granule()
    : Archiving_Node(), 
      P_(), 
      S_(P_),
      B_(*this)
{
    recordablesMap_.create();
}


Granule::Granule(const Granule& n)
    : Archiving_Node(n), 
      P_(n.P_), 
      S_(n.S_),
      B_(n.B_, *this)
{
}
Granule::~Granule()
{
    // GSL structs only allocated by init_nodes_(), so we need to protect destruction
    if ( B_.s_ ) gsl_odeiv_step_free(B_.s_);
    if ( B_.c_ ) gsl_odeiv_control_free(B_.c_);
    if ( B_.e_ ) gsl_odeiv_evolve_free(B_.e_);
}


  void Granule::init_node_(const Node& proto)
{
    const Granule& pr = downcast<Granule>(proto);
    P_ = pr.P_;
    S_ = State_(P_);
}


void Granule::init_state_(const Node& proto)
{
    const Granule& pr = downcast<Granule>(proto);
    S_ = State_(pr.P_);
}


void Granule::init_buffers_()
{
      B_.currents_.clear();           
    Archiving_Node::clear_history();

    B_.logger_.reset();

    B_.step_ = Time::get_resolution().get_ms();
    B_.IntegrationStep_ = B_.step_;

    B_.I_stim_ = 0.0;
  
    int N = 22;
    static const gsl_odeiv_step_type* T1 = gsl_odeiv_step_rk4;
  
    if ( B_.s_ == 0 )
      B_.s_ = gsl_odeiv_step_alloc (T1, N);
    else 
      gsl_odeiv_step_reset(B_.s_);
    
    if ( B_.c_ == 0 )  
      B_.c_ = gsl_odeiv_control_y_new (1e-4, 1e-4);
    else
      gsl_odeiv_control_init(B_.c_, 1e-4, 1e-4, 1.0, 0.0);
    
    if ( B_.e_ == 0 )  
      B_.e_ = gsl_odeiv_evolve_alloc(N);
    else 
      gsl_odeiv_evolve_reset(B_.e_);
  
    B_.sys_.function  = Granule_dynamics; 
    B_.sys_.jacobian  = 0;
    B_.sys_.dimension = N;
    B_.sys_.params    = reinterpret_cast<void*>(this);


}


void Granule::calibrate()
{
    B_.logger_.init();  
    V_.RefractoryCounts_ = 20;
    V_.U_old_ = S_.y_[0];
}


void Granule::update(Time const & origin, const long_t from, const long_t to)
{
  assert(to >= 0 && (delay) from < Scheduler::get_min_delay());
    assert(from < to);

    double tout;
    long_t current_steps = origin.get_steps();

    for ( long_t lag = from ; lag < to ; ++lag )
      {
        double h = B_.step_;    
	double tt = 0.0 ; 
	V_.U_old_ = S_.y_[0];
  			      
	// adaptive step integration
	while (tt < h)
	{
	  const int status = gsl_odeiv_evolve_apply(B_.e_, B_.c_, B_.s_, 
				 &B_.sys_,              // system of ODE
				 &tt,                   // from t...
				  h,             // ...to t=t+h
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
           	    // (threshold && maximum)
	    if (S_.y_[0] >= P_.V_t && V_.U_old_ > S_.y_[0])
	      {
		S_.r_ = V_.RefractoryCounts_;
		
		set_spiketime(Time::step(origin.get_steps()+lag+1));
		
		SpikeEvent se;
		network()->send(*this, se, lag);
	      }
	  }
    
	// set new input current
	B_.I_stim_ = B_.currents_.get_value(lag);

	// log state data
	B_.logger_.record_data(current_steps + lag);

      }
}




void Granule::handle(SpikeEvent & e)
  {
    int flag;
    assert(e.get_delay() > 0);
    flag = 0;


}




void Granule::handle(CurrentEvent& e)
  {
    assert(e.get_delay() > 0);

    const double_t c=e.get_current();
    const double_t w=e.get_weight();

    B_.currents_.add_value(e.get_rel_delivery_steps(network()->get_slice_origin()), 
			w *c);
  }

void Granule::handle(DataLoggingRequest& e)
  {
    B_.logger_.handle(e);
  }


}


