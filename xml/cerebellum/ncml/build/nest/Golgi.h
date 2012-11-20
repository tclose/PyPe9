#include "nest.h"
#include "event.h"
#include "archiving_node.h"
#include "ring_buffer.h"
#include "connection.h"
#include "universal_data_logger.h"
#include "recordables_map.h"
#include <gsl/gsl_odeiv.h>

namespace nest {


extern "C" int Golgi_dynamics (double, const double*, double*, void*) ;


class Golgi: public Archiving_Node { 
  public: 
  ~Golgi();
  Golgi(const Golgi&);
  Golgi();
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
    // make dynamics function quasi-member
    friend int Golgi_dynamics(double, const double*, double*, void*);

    // The next two classes need to be friends to access the State_ class/member
    friend class RecordablesMap<Golgi>;
    friend class UniversalDataLogger<Golgi>;
  

  struct Parameters_ { 
  double comp2559_gbar;
  double comp3094_Kalpha_v;
  double comp217_Kalpha_u;
  double comp3094_Kalpha_u;
  double comp217_Kalpha_s;
  double comp3736_Kalpha_s;
  double comp2298_Kalpha_n;
  double comp2559_Kalpha_n;
  double comp3459_Kalpha_m;
  double comp3736_Kalpha_f;
  double comp2062_Kalpha_c;
  double comp1641_Kalpha_b;
  double comp1641_Kalpha_a;
  double comp1556_vchdur;
  double comp949_gbar;
  double comp481_vchold;
  double comp3009_vchold;
  double comp3651_vchold;
  double comp118_beta;
  double comp3009_vcinc;
  double comp3094_V0beta_v;
  double comp217_V0beta_u;
  double comp3094_V0beta_u;
  double comp217_V0beta_s;
  double comp3736_V0beta_s;
  double comp2298_V0beta_n;
  double comp2559_V0beta_n;
  double comp3459_V0beta_m;
  double comp3736_V0beta_f;
  double comp1641_V0beta_b;
  double comp1641_V0beta_a;
  double comp3651_vcinc;
  double comp2298_V0_ninf;
  double comp1977_vcbdur;
  double comp2213_vcbdur;
  double comp2723_vcbdur;
  double comp2298_B_ninf;
  double comp3094_Kbeta_v;
  double comp217_Kbeta_u;
  double comp3094_Kbeta_u;
  double comp217_Kbeta_s;
  double comp3736_Kbeta_s;
  double comp2298_Kbeta_n;
  double comp2559_Kbeta_n;
  double comp3459_Kbeta_m;
  double comp3736_Kbeta_f;
  double comp2062_Kbeta_c;
  double comp1641_Kbeta_b;
  double comp1641_Kbeta_a;
  double comp949_rB;
  double comp949_rA;
  double comp2062_Balpha_c;
  double comp1977_vcbase;
  double comp2213_vcbase;
  double comp2723_vcbase;
  double comp2062_gbar;
  double comp4113_gbar;
  double comp1285_Ehalf;
  double comp481_vchdur;
  double comp3009_vchdur;
  double comp3651_vchdur;
  double comp566_k_h_inf;
  double comp864_vchold;
  double comp1200_vchold;
  double comp2474_vchold;
  double comp3374_vchold;
  double comp4028_vchold;
  double comp2808_diro2;
  double comp2808_diro1;
  double comp2808_diff;
  double comp2808_dirc4;
  double comp2808_dirc3;
  double comp2808_dirc2;
  double ca2o;
  double comp1641_e;
  double comp3736_gbar;
  double comp1556_vcbdur;
  double comp118_valence;
  double comp566_valence;
  double comp566_C_tau_m;
  double comp566_C_tau_h;
  double comp566_v0_tau_m2;
  double comp566_v0_tau_m1;
  double comp566_v0_tau_h2;
  double comp566_v0_tau_h1;
  double comp1556_vcbase;
  double comp3094_gbar;
  double comp3459_V0_minf;
  double comp566_v0_m_inf;
  double comp864_vchdur;
  double comp1200_vchdur;
  double comp2474_vchdur;
  double comp3374_vchdur;
  double comp4028_vchdur;
  double comp2298_gbar;
  double comp566_gbar;
  double comp3094_e;
  double comp1977_vcinc;
  double comp33_cai0;
  double comp481_vcbdur;
  double comp3009_vcbdur;
  double comp3651_vcbdur;
  double comp1641_gbar;
  double comp2559_e;
  double comp566_A_tau_m;
  double comp566_A_tau_h;
  double comp217_e;
  double comp4028_vcinc;
  double comp118_ca2i0;
  double comp566_k_tau_m2;
  double comp566_k_tau_m1;
  double comp566_k_tau_h2;
  double comp566_k_tau_h1;
  double comp481_vcbase;
  double comp3009_vcbase;
  double comp3651_vcbase;
  double comp3736_e;
  double comp566_shift;
  double comp3459_gbar;
  double comp566_R;
  double comp566_F;
  double comp2298_e;
  double comp33_beta;
  double comp481_vcsteps;
  double comp864_vcsteps;
  double comp1200_vcsteps;
  double comp1556_vcsteps;
  double comp1977_vcsteps;
  double comp2213_vcsteps;
  double comp2474_vcsteps;
  double comp2723_vcsteps;
  double comp3009_vcsteps;
  double comp3374_vcsteps;
  double comp3651_vcsteps;
  double comp4028_vcsteps;
  double comp864_vcbdur;
  double comp1200_vcbdur;
  double comp2474_vcbdur;
  double comp3374_vcbdur;
  double comp4028_vcbdur;
  double comp2808_e;
  double comp2474_vcinc;
  double comp3374_vcinc;
  double comp1285_tEs;
  double comp1641_V0_binf;
  double comp1285_tEf;
  double comp1285_tDs;
  double comp1285_e;
  double comp1285_c;
  double comp1285_tDf;
  double comp1285_tCs;
  double comp1285_tCf;
  double comp33_cao;
  double comp864_vcbase;
  double comp1200_vcbase;
  double comp2474_vcbase;
  double comp3374_vcbase;
  double comp4028_vcbase;
  double comp2808_invo2;
  double comp2808_invo1;
  double comp2808_invc3;
  double comp2808_invc2;
  double comp2808_invc1;
  double comp481_vcinc;
  double comp3094_Aalpha_v;
  double comp217_Aalpha_u;
  double comp3094_Aalpha_u;
  double comp217_Aalpha_s;
  double comp3736_Aalpha_s;
  double comp2298_Aalpha_n;
  double comp2559_Aalpha_n;
  double comp3459_Aalpha_m;
  double comp949_tEs;
  double comp3736_Aalpha_f;
  double comp2062_Aalpha_c;
  double comp1641_Aalpha_b;
  double comp1641_Aalpha_a;
  double comp949_tEf;
  double comp949_tDs;
  double comp949_tDf;
  double comp949_tCs;
  double comp949_tCf;
  double comp566_k_m_inf;
  double comp2808_gbar;
  double comp949_e;
  double comp949_c;
  double comp1641_K_binf;
  double comp1200_vcinc;
  double comp33_d;
  double comp33_F;
  double comp118_d;
  double comp118_F;
  double comp864_vcinc;
  double comp217_gbar;
  double comp1977_vchold;
  double comp2213_vchold;
  double comp2723_vchold;
  double comp1556_vcinc;
  double comp2062_Bbeta_c;
  double comp3736_Shiftbeta_s;
  double comp3459_B_minf;
  double comp1641_V0_ainf;
  double comp2723_vcinc;
  double comp2062_e;
  double comp566_v0_h_inf;
  double comp3094_V0alpha_v;
  double comp217_V0alpha_u;
  double comp3094_V0alpha_u;
  double comp217_V0alpha_s;
  double comp3736_V0alpha_s;
  double comp3736_Shiftalpha_s;
  double comp2298_V0alpha_n;
  double comp2559_V0alpha_n;
  double comp3459_V0alpha_m;
  double comp3736_V0alpha_f;
  double comp1641_V0alpha_b;
  double comp1641_V0alpha_a;
  double comp3094_Abeta_v;
  double comp217_Abeta_u;
  double comp3094_Abeta_u;
  double comp217_Abeta_s;
  double comp3736_Abeta_s;
  double comp2298_Abeta_n;
  double comp2559_Abeta_n;
  double comp3459_Abeta_m;
  double comp3736_Abeta_f;
  double comp2062_Abeta_c;
  double comp1641_Abeta_b;
  double comp1641_Abeta_a;
  double comp1285_gbar;
  double comp1977_vchdur;
  double comp2213_vchdur;
  double comp2723_vchdur;
  double comp949_Ehalf;
  double comp1556_vchold;
  double comp1641_K_ainf;
  double comp4113_e;
  double comp3459_e;
  double comp1285_rB;
  double comp1285_rA;
  double comp118_ca2o;
  double comp2213_vcinc;
  Parameters_();
  void get(DictionaryDatum&) const;
  void set(const DictionaryDatum&);
  };
  

  struct State_ { 
  

  enum StateVecElems {
  COMP1285_O_SLOW = 26, COMP949_O_SLOW = 25, COMP33_CA = 24, COMP1285_O_FAST = 23, COMP949_O_FAST = 22, NA_HO = 21, NA_MO = 20, COMP2808_SK2_ZO2 = 19, COMP2808_SK2_ZC4 = 18, COMP2808_SK2_ZO1 = 17, COMP2808_SK2_ZC3 = 16, COMP2808_SK2_ZC2 = 15, COMP2808_SK2_ZC1 = 14, NAR_HO = 13, NAR_MO = 12, KV_MO = 11, KCA_MO = 10, COMP118_CA2 = 9, CALVA_H = 8, CALVA_M = 7, KA_H = 6, KA_M = 5, KM_M = 4, NAP_M = 3, CAHVA_H = 2, CAHVA_M = 1, V = 0
  };
  double y_[27];
  int_t     r_;
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
  

  Buffers_(Golgi&);
  Buffers_(const Buffers_&, Golgi&);
  UniversalDataLogger<Golgi> logger_;
  

  
  RingBuffer currents_;

  gsl_odeiv_step*    s_;    //!< stepping function
  gsl_odeiv_control* c_;    //!< adaptive stepsize control function
  gsl_odeiv_evolve*  e_;    //!< evolution function
  gsl_odeiv_system   sys_;  //!< struct describing system

  double_t step_;           //!< step size in ms
  double   IntegrationStep_;//!< current integration time step, updated by GSL

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
  static RecordablesMap<Golgi> recordablesMap_;
  }; 
    inline
  port Golgi::check_connection(Connection& c, port receptor_type)
  {
    SpikeEvent e;
    e.set_sender(*this);
    c.check_event(e);
    return c.get_target()->connect_sender(e, receptor_type);
  }

  inline
  port Golgi::connect_sender(SpikeEvent&, port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return 0;
  }
 
  inline
  port Golgi::connect_sender(CurrentEvent&, port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return 0;
  }

  inline
  port Golgi::connect_sender(DataLoggingRequest& dlr, 
				      port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return B_.logger_.connect_logging_device(dlr, recordablesMap_);
  }

  inline
    void Golgi::get_status(DictionaryDatum &d) const
  {
    P_.get(d);
    S_.get(d);
    Archiving_Node::get_status(d);

    (*d)[names::recordables] = recordablesMap_.get_list();

    def<double_t>(d, names::t_spike, get_spiketime_ms());
  }

  inline
    void Golgi::set_status(const DictionaryDatum &d)
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




