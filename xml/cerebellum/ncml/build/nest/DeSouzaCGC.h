#include "nest.h"
#include "event.h"
#include "archiving_node.h"
#include "ring_buffer.h"
#include "connection.h"
#include "universal_data_logger.h"
#include "recordables_map.h"
#include <gsl/gsl_odeiv.h>

namespace nest {


extern "C" int DeSouzaCGC_dynamics (double, const double*, double*, void*) ;


class DeSouzaCGC: public Archiving_Node { 
  public: 
  ~DeSouzaCGC();
  DeSouzaCGC(const DeSouzaCGC&);
  DeSouzaCGC();
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
    friend int DeSouzaCGC_dynamics(double, const double*, double*, void*);

    // The next two classes need to be friends to access the State_ class/member
    friend class RecordablesMap<DeSouzaCGC>;
    friend class UniversalDataLogger<DeSouzaCGC>;
  

  struct Parameters_ { 
  double comp136_vchdur;
  double comp306_vchdur;
  double comp476_vchdur;
  double comp51_vchold;
  double comp221_vchold;
  double comp391_vchold;
  double comp561_vchold;
  double comp51_vcinc;
  double comp391_vcinc;
  double comp51_vchdur;
  double comp221_vchdur;
  double comp391_vchdur;
  double comp561_vchdur;
  double comp136_vcbdur;
  double comp306_vcbdur;
  double comp476_vcbdur;
  double comp306_vcinc;
  double comp136_vcbase;
  double comp306_vcbase;
  double comp476_vcbase;
  double comp51_vcbdur;
  double comp221_vcbdur;
  double comp391_vcbdur;
  double comp561_vcbdur;
  double comp136_vcinc;
  double comp476_vcinc;
  double comp51_vcbase;
  double comp221_vcbase;
  double comp391_vcbase;
  double comp561_vcbase;
  double comp51_vcsteps;
  double comp136_vcsteps;
  double comp221_vcsteps;
  double comp306_vcsteps;
  double comp391_vcsteps;
  double comp476_vcsteps;
  double comp561_vcsteps;
  double comp136_vchold;
  double comp306_vchold;
  double comp476_vchold;
  double comp221_vcinc;
  double comp561_vcinc;
  Parameters_();
  void get(DictionaryDatum&) const;
  void set(const DictionaryDatum&);
  };
  

  struct State_ { 
  

  enum StateVecElems {
  V = 0
  };
  double y_[1];
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
  

  Buffers_(DeSouzaCGC&);
  Buffers_(const Buffers_&, DeSouzaCGC&);
  UniversalDataLogger<DeSouzaCGC> logger_;
  

  
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
  static RecordablesMap<DeSouzaCGC> recordablesMap_;
  }; 
    inline
  port DeSouzaCGC::check_connection(Connection& c, port receptor_type)
  {
    SpikeEvent e;
    e.set_sender(*this);
    c.check_event(e);
    return c.get_target()->connect_sender(e, receptor_type);
  }

  inline
  port DeSouzaCGC::connect_sender(SpikeEvent&, port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return 0;
  }
 
  inline
  port DeSouzaCGC::connect_sender(CurrentEvent&, port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return 0;
  }

  inline
  port DeSouzaCGC::connect_sender(DataLoggingRequest& dlr, 
				      port receptor_type)
  {
    if (receptor_type != 0)
      throw UnknownReceptorType(receptor_type, get_name());
    return B_.logger_.connect_logging_device(dlr, recordablesMap_);
  }

  inline
    void DeSouzaCGC::get_status(DictionaryDatum &d) const
  {
    P_.get(d);
    S_.get(d);
    Archiving_Node::get_status(d);

    (*d)[names::recordables] = recordablesMap_.get_list();

    def<double_t>(d, names::t_spike, get_spiketime_ms());
  }

  inline
    void DeSouzaCGC::set_status(const DictionaryDatum &d)
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




