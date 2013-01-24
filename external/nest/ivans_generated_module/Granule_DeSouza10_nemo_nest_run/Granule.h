#include "nest.h"
#include "event.h"
#include "archiving_node.h"
#include "ring_buffer.h"
#include "connection.h"
#include "universal_data_logger.h"
#include "recordables_map.h"

#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_sf_exp.h>
#include <gsl/gsl_odeiv.h>
#define Ith(v,i)    (v[i])


namespace nest {


extern "C" int Granule_dynamics (double, const double*, double*, void*) ;


class Granule: public Archiving_Node { 
  public: 
  ~Granule();
  Granule(const Granule&);
  Granule();
    using Node::connect_sender;
    using Node::handle;

    port check_connection(Connection&, port);
    
    void handle(SpikeEvent &);
    void handle(CurrentEvent &);
    void handle(DataLoggingRequest &); 
    
    port connect_sender(SpikeEvent &, port);
    port connect_sender(CurrentEvent &, port);
    port connect_sender(DataLoggingRequest &, port);
    
    void get_status(DictionaryDatum &) const;
    void set_status(const DictionaryDatum &);
    
    void init_node_(const Node& proto);
    void init_state_(const Node& proto);
    void init_buffers_();
    void calibrate();
    
    void update(Time const &, const long_t, const long_t);
friend int Granule_dynamics (double, const double*, double*, void*) ;


    // The next two classes need to be friends to access the State_ class/member
    friend class RecordablesMap<Granule>;
    friend class UniversalDataLogger<Granule>;
  

  struct Parameters_ { 
  double comp116_B_ninf;
  double comp21_F;
  double comp115_vcinc;
  double comp21_d;
  double comp101_Aalpha_d;
  double comp47_e;
  double comp173_vcsteps;
  double comp83_Kalpha_c;
  double comp47_Aalpha_a;
  double comp47_Aalpha_b;
  double comp22_Kalpha_u;
  double comp150_vcinc;
  double comp22_Kalpha_s;
  double comp19_V_t;
  double comp115_vcsteps;
  double comp47_V0beta_b;
  double comp47_V0beta_a;
  double comp157_AOon;
  double comp131_Abeta_n;
  double comp154_egaba;
  double comp151_gbar;
  double comp82_vchdur;
  double comp83_Bbeta_c;
  double comp21_beta;
  double comp100_vchold;
  double comp157_ACon;
  double comp173_vcbase;
  double comp82_vchold;
  double comp82_vcsteps;
  double comp101_Kbeta_d;
  double comp20_C_m;
  double comp22_Abeta_u;
  double comp22_gbar;
  double comp22_Abeta_s;
  double comp116_V0beta_n;
  double comp46_vcsteps;
  double comp150_vchdur;
  double comp22_R;
  double comp82_vcbdur;
  double comp22_F;
  double comp130_vcbdur;
  double comp83_Abeta_c;
  double comp22_V0beta_s;
  double comp22_V0beta_u;
  double comp22_Kbeta_s;
  double comp22_Kbeta_u;
  double comp101_Abeta_d;
  double comp46_vcbdur;
  double comp173_vchold;
  double comp116_e;
  double comp101_e;
  double comp157_Valfa;
  double comp131_gbar;
  double comp173_vchdur;
  double comp157_Adelta;
  double comp100_vcinc;
  double comp116_Abeta_n;
  double comp47_Kalpha_a;
  double comp47_Kalpha_b;
  double comp116_V0_ninf;
  double comp150_vchold;
  double comp46_vcinc;
  double comp150_vcsteps;
  double comp116_Aalpha_n;
  double comp46_vchdur;
  double comp47_K_binf;
  double comp19_celsius;
  double comp130_vchold;
  double comp100_vcsteps;
  double comp115_vchold;
  double comp116_Kalpha_n;
  double comp101_gbar;
  double comp131_Aalpha_n;
  double comp157_AOoff;
  double comp157_ACoff;
  double comp100_vchdur;
  double comp115_vcbdur;
  double comp150_vcbase;
  double comp157_Vteta;
  double comp83_Balpha_c;
  double comp47_V0_binf;
  double comp83_gbar;
  double comp101_V0beta_d;
  double comp83_Kbeta_c;
  double comp46_vcbase;
  double comp47_V0alpha_b;
  double comp47_V0alpha_a;
  double comp131_e;
  double comp157_Aalfa;
  double comp157_Aepsilon;
  double comp130_vcinc;
  double comp82_vcbase;
  double comp157_e;
  double comp83_Aalpha_c;
  double comp131_Kalpha_n;
  double comp47_K_ainf;
  double comp157_Agamma;
  double comp131_V0alpha_n;
  double comp115_vcbase;
  double comp101_V0alpha_d;
  double comp47_Abeta_a;
  double comp47_Abeta_b;
  double comp21_cao;
  double comp173_vcbdur;
  double comp22_Aalpha_u;
  double comp173_vcinc;
  double comp22_Aalpha_s;
  double comp46_vchold;
  double comp100_vcbase;
  double comp82_vcinc;
  double comp157_Vbeta;
  double comp157_gbar;
  double comp83_e;
  double comp130_vchdur;
  double comp47_Kbeta_b;
  double comp47_Kbeta_a;
  double comp21_cai0;
  double comp131_Kbeta_n;
  double comp116_gbar;
  double comp154_ggaba;
  double comp47_V0_ainf;
  double comp150_vcbdur;
  double comp22_V0alpha_s;
  double comp22_V0alpha_u;
  double comp157_n1;
  double comp116_V0alpha_n;
  double comp157_n4;
  double comp157_n2;
  double comp157_n3;
  double comp151_e;
  double comp116_Kbeta_n;
  double comp130_vcsteps;
  double comp131_V0beta_n;
  double comp157_Abeta;
  double comp115_vchdur;
  double comp157_Ateta;
  double comp47_gbar;
  double comp100_vcbdur;
  double comp101_Kalpha_d;
  double comp130_vcbase;
  double celsius;
  double V_t;
  Parameters_();
  void get(DictionaryDatum&) const;
  void set(const DictionaryDatum&);
  };
  

  struct State_ { 
  

  enum StateVecElems {
  COMP21_CA = 21, KM_M = 20, CAHVA_H = 19, CAHVA_M = 18, COMP157_NA_ZO = 17, COMP157_NA_ZI6 = 16, COMP157_NA_ZC5 = 15, COMP157_NA_ZI5 = 14, COMP157_NA_ZC4 = 13, COMP157_NA_ZI4 = 12, COMP157_NA_ZC3 = 11, COMP157_NA_ZI3 = 10, COMP157_NA_ZC2 = 9, COMP157_NA_ZI2 = 8, COMP157_NA_ZC1 = 7, COMP157_NA_ZI1 = 6, KCA_M = 5, KV_M = 4, KIR_M = 3, KA_H = 2, KA_M = 1, V = 0
  };
  int_t     r_;
  double y_[22];
  double cai, cao, i_Lkg1, i_Lkg2, i, i_Na, ina, i_KV, i_KCa, i_Kir, i_KM, i_KA, ik, i_CaHVA, ica;
  State_(const Parameters_& p);
  State_(const State_& s);
  State_& operator=(const State_& s);
  void get(DictionaryDatum&) const;
  void set(const DictionaryDatum&, const Parameters_&);
  };
  

  struct Variables_ {
      int_t    RefractoryCounts_;
      double   U_old_; // for spike-detection
};
  

  struct Buffers_ { 
  

  Buffers_(Granule&);
  Buffers_(const Buffers_&, Granule&);
  UniversalDataLogger<Granule> logger_;
  

    gsl_odeiv_step*    s_;    //!< stepping function
  gsl_odeiv_control* c_;    //!< adaptive stepsize control function
  gsl_odeiv_evolve*  e_;    //!< evolution function
  gsl_odeiv_system   sys_;  //!< struct describing system
  

    RingBuffer currents_;

  double_t step_;           //!< step size in ms
  double   IntegrationStep_;//!< current integration time step, updated by solver

  /** 
   * Input current injected by CurrentEvent.
   * This variable is used to transport the current applied into the
   * _dynamics function computing the derivative of the state vector.
   * It must be a part of Buffers_, since it is initialized once before
   * the first simulation, but not modified before later Simulate calls.
   */
  double_t I_stim_;
  };
  template <State_::StateVecElems elem>
  double_t get_y_elem_() const { return S_.y_[elem]; }
  Parameters_ P_;
  State_      S_;
  Variables_  V_;
  Buffers_    B_;
  static RecordablesMap<Granule> recordablesMap_;
  }; 
    inline
  port Granule::check_connection(Connection& c, port receptor_type)
  {
    SpikeEvent e;
    e.set_sender(*this);
    c.check_event(e);
    return c.get_target()->connect_sender(e, receptor_type);
  }

  inline
  port Granule::connect_sender(SpikeEvent&, port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return 0;
  }
 
  inline
  port Granule::connect_sender(CurrentEvent&, port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return 0;
  }

  inline
  port Granule::connect_sender(DataLoggingRequest& dlr, 
				      port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return B_.logger_.connect_logging_device(dlr, recordablesMap_);
  }

  inline
    void Granule::get_status(DictionaryDatum &d) const
  {
    P_.get(d);
    S_.get(d);
    Archiving_Node::get_status(d);

    (*d)[names::recordables] = recordablesMap_.get_list();

    def<double_t>(d, names::t_spike, get_spiketime_ms());
  }

  inline
    void Granule::set_status(const DictionaryDatum &d)
  {
    Parameters_ ptmp = P_;  // temporary copy in case of errors
    ptmp.set(d);                       // throws if BadProperty
    State_      stmp = S_;  // temporary copy in case of errors
    stmp.set(d, ptmp);                 // throws if BadProperty

    // We now know that (ptmp, stmp) are consistent. We do not 
    // write them back to (P_, S_) before we are also sure that 
    // the properties to be set in the parent class are internally 
    // consistent.
    Archiving_Node::set_status(d);

    // if we get here, temporaries contain consistent set of properties
    P_ = ptmp;
    S_ = stmp;

    calibrate();
  }
}




