#include "DeSouzaCGC.h"
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

namespace nest {




double sigm (double x, double y, const void* params) ;




double linoid (double x, double y, const void* params) ;




double sigm (double x, double y, const void* params) {
  double rv648 ;
  rv648  =  0.0;
  return rv648;
}




double linoid (double x, double y, const void* params) {
  double rv649 ;
  rv649  =  0.0;
  return rv649;
}




extern "C" int DeSouzaCGC_dynamics (double t, const double y[], double f[], void* pnode) {
  double v, comp136_vchdur, comp306_vchdur, comp476_vchdur, comp51_vchold, comp221_vchold, comp391_vchold, comp561_vchold, comp51_vcinc, comp391_vcinc, comp51_vchdur, comp221_vchdur, comp391_vchdur, comp561_vchdur, comp136_vcbdur, comp306_vcbdur, comp476_vcbdur, comp306_vcinc, comp136_vcbase, comp306_vcbase, comp476_vcbase, comp51_vcbdur, comp221_vcbdur, comp391_vcbdur, comp561_vcbdur, comp136_vcinc, comp476_vcinc, comp51_vcbase, comp221_vcbase, comp391_vcbase, comp561_vcbase, comp51_vcsteps, comp136_vcsteps, comp221_vcsteps, comp306_vcsteps, comp391_vcsteps, comp476_vcsteps, comp561_vcsteps, comp136_vchold, comp306_vchold, comp476_vchold, comp221_vcinc, comp561_vcinc ;
  

  // S is shorthand for the type that describes the model state 
  typedef DeSouzaCGC::State_ S;
  

  // cast the node ptr to an object of the proper type
  assert(pnode);
  const  DeSouzaCGC & node =  *(reinterpret_cast< DeSouzaCGC *>(pnode));
  

  // params is a reference to the model parameters 
  const struct DeSouzaCGC::Parameters_ *params;
  params = &(node.P_);
  

  // y[] must be the state vector supplied by the integrator, 
  // not the state vector in the node, node.S_.y[]. 
  

  comp136_vchdur  =  params->comp136_vchdur;
  comp306_vchdur  =  params->comp306_vchdur;
  comp476_vchdur  =  params->comp476_vchdur;
  comp51_vchold  =  params->comp51_vchold;
  comp221_vchold  =  params->comp221_vchold;
  comp391_vchold  =  params->comp391_vchold;
  comp561_vchold  =  params->comp561_vchold;
  comp51_vcinc  =  params->comp51_vcinc;
  comp391_vcinc  =  params->comp391_vcinc;
  comp51_vchdur  =  params->comp51_vchdur;
  comp221_vchdur  =  params->comp221_vchdur;
  comp391_vchdur  =  params->comp391_vchdur;
  comp561_vchdur  =  params->comp561_vchdur;
  comp136_vcbdur  =  params->comp136_vcbdur;
  comp306_vcbdur  =  params->comp306_vcbdur;
  comp476_vcbdur  =  params->comp476_vcbdur;
  comp306_vcinc  =  params->comp306_vcinc;
  comp136_vcbase  =  params->comp136_vcbase;
  comp306_vcbase  =  params->comp306_vcbase;
  comp476_vcbase  =  params->comp476_vcbase;
  comp51_vcbdur  =  params->comp51_vcbdur;
  comp221_vcbdur  =  params->comp221_vcbdur;
  comp391_vcbdur  =  params->comp391_vcbdur;
  comp561_vcbdur  =  params->comp561_vcbdur;
  comp136_vcinc  =  params->comp136_vcinc;
  comp476_vcinc  =  params->comp476_vcinc;
  comp51_vcbase  =  params->comp51_vcbase;
  comp221_vcbase  =  params->comp221_vcbase;
  comp391_vcbase  =  params->comp391_vcbase;
  comp561_vcbase  =  params->comp561_vcbase;
  comp51_vcsteps  =  params->comp51_vcsteps;
  comp136_vcsteps  =  params->comp136_vcsteps;
  comp221_vcsteps  =  params->comp221_vcsteps;
  comp306_vcsteps  =  params->comp306_vcsteps;
  comp391_vcsteps  =  params->comp391_vcsteps;
  comp476_vcsteps  =  params->comp476_vcsteps;
  comp561_vcsteps  =  params->comp561_vcsteps;
  comp136_vchold  =  params->comp136_vchold;
  comp306_vchold  =  params->comp306_vchold;
  comp476_vchold  =  params->comp476_vchold;
  comp221_vcinc  =  params->comp221_vcinc;
  comp561_vcinc  =  params->comp561_vcinc;
  v  =  y[0];
  f[0]  =  0.0;
  

  return GSL_SUCCESS;
}


RecordablesMap<DeSouzaCGC> DeSouzaCGC::recordablesMap_;
template <> void RecordablesMap<DeSouzaCGC>::create()
{
  insert_("v", &DeSouzaCGC::get_y_elem_<DeSouzaCGC::State_::V>);
  insert_(names::V_m, &DeSouzaCGC::get_y_elem_<DeSouzaCGC::State_::V>);
}




DeSouzaCGC::Parameters_::Parameters_ () :
  comp136_vchdur  (30.0),
comp306_vchdur  (30.0),
comp476_vchdur  (30.0),
comp51_vchold  (-71.0),
comp221_vchold  (-71.0),
comp391_vchold  (-71.0),
comp561_vchold  (-71.0),
comp51_vcinc  (10.0),
comp391_vcinc  (10.0),
comp51_vchdur  (30.0),
comp221_vchdur  (30.0),
comp391_vchdur  (30.0),
comp561_vchdur  (30.0),
comp136_vcbdur  (100.0),
comp306_vcbdur  (100.0),
comp476_vcbdur  (100.0),
comp306_vcinc  (10.0),
comp136_vcbase  (-69.0),
comp306_vcbase  (-69.0),
comp476_vcbase  (-69.0),
comp51_vcbdur  (100.0),
comp221_vcbdur  (100.0),
comp391_vcbdur  (100.0),
comp561_vcbdur  (100.0),
comp136_vcinc  (10.0),
comp476_vcinc  (10.0),
comp51_vcbase  (-69.0),
comp221_vcbase  (-69.0),
comp391_vcbase  (-69.0),
comp561_vcbase  (-60.0),
comp51_vcsteps  (8.0),
comp136_vcsteps  (8.0),
comp221_vcsteps  (8.0),
comp306_vcsteps  (8.0),
comp391_vcsteps  (8.0),
comp476_vcsteps  (8.0),
comp561_vcsteps  (9.0),
comp136_vchold  (-71.0),
comp306_vchold  (-71.0),
comp476_vchold  (-71.0),
comp221_vcinc  (10.0),
comp561_vcinc  (10.0)
{}


DeSouzaCGC::State_::State_ (const Parameters_& p) : r_(0)
{
  double v, comp136_vchdur, comp306_vchdur, comp476_vchdur, comp51_vchold, comp221_vchold, comp391_vchold, comp561_vchold, comp51_vcinc, comp391_vcinc, comp51_vchdur, comp221_vchdur, comp391_vchdur, comp561_vchdur, comp136_vcbdur, comp306_vcbdur, comp476_vcbdur, comp306_vcinc, comp136_vcbase, comp306_vcbase, comp476_vcbase, comp51_vcbdur, comp221_vcbdur, comp391_vcbdur, comp561_vcbdur, comp136_vcinc, comp476_vcinc, comp51_vcbase, comp221_vcbase, comp391_vcbase, comp561_vcbase, comp51_vcsteps, comp136_vcsteps, comp221_vcsteps, comp306_vcsteps, comp391_vcsteps, comp476_vcsteps, comp561_vcsteps, comp136_vchold, comp306_vchold, comp476_vchold, comp221_vcinc, comp561_vcinc ;
  const Parameters_ *params = &p;
  comp136_vchdur  =  p.comp136_vchdur;
  comp306_vchdur  =  p.comp306_vchdur;
  comp476_vchdur  =  p.comp476_vchdur;
  comp51_vchold  =  p.comp51_vchold;
  comp221_vchold  =  p.comp221_vchold;
  comp391_vchold  =  p.comp391_vchold;
  comp561_vchold  =  p.comp561_vchold;
  comp51_vcinc  =  p.comp51_vcinc;
  comp391_vcinc  =  p.comp391_vcinc;
  comp51_vchdur  =  p.comp51_vchdur;
  comp221_vchdur  =  p.comp221_vchdur;
  comp391_vchdur  =  p.comp391_vchdur;
  comp561_vchdur  =  p.comp561_vchdur;
  comp136_vcbdur  =  p.comp136_vcbdur;
  comp306_vcbdur  =  p.comp306_vcbdur;
  comp476_vcbdur  =  p.comp476_vcbdur;
  comp306_vcinc  =  p.comp306_vcinc;
  comp136_vcbase  =  p.comp136_vcbase;
  comp306_vcbase  =  p.comp306_vcbase;
  comp476_vcbase  =  p.comp476_vcbase;
  comp51_vcbdur  =  p.comp51_vcbdur;
  comp221_vcbdur  =  p.comp221_vcbdur;
  comp391_vcbdur  =  p.comp391_vcbdur;
  comp561_vcbdur  =  p.comp561_vcbdur;
  comp136_vcinc  =  p.comp136_vcinc;
  comp476_vcinc  =  p.comp476_vcinc;
  comp51_vcbase  =  p.comp51_vcbase;
  comp221_vcbase  =  p.comp221_vcbase;
  comp391_vcbase  =  p.comp391_vcbase;
  comp561_vcbase  =  p.comp561_vcbase;
  comp51_vcsteps  =  p.comp51_vcsteps;
  comp136_vcsteps  =  p.comp136_vcsteps;
  comp221_vcsteps  =  p.comp221_vcsteps;
  comp306_vcsteps  =  p.comp306_vcsteps;
  comp391_vcsteps  =  p.comp391_vcsteps;
  comp476_vcsteps  =  p.comp476_vcsteps;
  comp561_vcsteps  =  p.comp561_vcsteps;
  comp136_vchold  =  p.comp136_vchold;
  comp306_vchold  =  p.comp306_vchold;
  comp476_vchold  =  p.comp476_vchold;
  comp221_vcinc  =  p.comp221_vcinc;
  comp561_vcinc  =  p.comp561_vcinc;
  v  =  -65.0;
  y_[0]  =  0.0;
}


DeSouzaCGC::State_::State_ (const State_& s) : r_(s.r_)
{
  for ( int i = 0 ; i < 1 ; ++i ) y_[i] = s.y_[i];
}


DeSouzaCGC::State_& DeSouzaCGC::State_::operator=(const State_& s)
{
     assert(this != &s);  
     for ( size_t i = 0 ; i < 1 ; ++i )
       y_[i] = s.y_[i];
     r_ = s.r_;
     return *this;
}




void DeSouzaCGC::Parameters_::get (DictionaryDatum &d) const
{
  def<double_t>(d, "comp136_vchdur", comp136_vchdur);
  def<double_t>(d, "comp306_vchdur", comp306_vchdur);
  def<double_t>(d, "comp476_vchdur", comp476_vchdur);
  def<double_t>(d, "comp51_vchold", comp51_vchold);
  def<double_t>(d, "comp221_vchold", comp221_vchold);
  def<double_t>(d, "comp391_vchold", comp391_vchold);
  def<double_t>(d, "comp561_vchold", comp561_vchold);
  def<double_t>(d, "comp51_vcinc", comp51_vcinc);
  def<double_t>(d, "comp391_vcinc", comp391_vcinc);
  def<double_t>(d, "comp51_vchdur", comp51_vchdur);
  def<double_t>(d, "comp221_vchdur", comp221_vchdur);
  def<double_t>(d, "comp391_vchdur", comp391_vchdur);
  def<double_t>(d, "comp561_vchdur", comp561_vchdur);
  def<double_t>(d, "comp136_vcbdur", comp136_vcbdur);
  def<double_t>(d, "comp306_vcbdur", comp306_vcbdur);
  def<double_t>(d, "comp476_vcbdur", comp476_vcbdur);
  def<double_t>(d, "comp306_vcinc", comp306_vcinc);
  def<double_t>(d, "comp136_vcbase", comp136_vcbase);
  def<double_t>(d, "comp306_vcbase", comp306_vcbase);
  def<double_t>(d, "comp476_vcbase", comp476_vcbase);
  def<double_t>(d, "comp51_vcbdur", comp51_vcbdur);
  def<double_t>(d, "comp221_vcbdur", comp221_vcbdur);
  def<double_t>(d, "comp391_vcbdur", comp391_vcbdur);
  def<double_t>(d, "comp561_vcbdur", comp561_vcbdur);
  def<double_t>(d, "comp136_vcinc", comp136_vcinc);
  def<double_t>(d, "comp476_vcinc", comp476_vcinc);
  def<double_t>(d, "comp51_vcbase", comp51_vcbase);
  def<double_t>(d, "comp221_vcbase", comp221_vcbase);
  def<double_t>(d, "comp391_vcbase", comp391_vcbase);
  def<double_t>(d, "comp561_vcbase", comp561_vcbase);
  def<double_t>(d, "comp51_vcsteps", comp51_vcsteps);
  def<double_t>(d, "comp136_vcsteps", comp136_vcsteps);
  def<double_t>(d, "comp221_vcsteps", comp221_vcsteps);
  def<double_t>(d, "comp306_vcsteps", comp306_vcsteps);
  def<double_t>(d, "comp391_vcsteps", comp391_vcsteps);
  def<double_t>(d, "comp476_vcsteps", comp476_vcsteps);
  def<double_t>(d, "comp561_vcsteps", comp561_vcsteps);
  def<double_t>(d, "comp136_vchold", comp136_vchold);
  def<double_t>(d, "comp306_vchold", comp306_vchold);
  def<double_t>(d, "comp476_vchold", comp476_vchold);
  def<double_t>(d, "comp221_vcinc", comp221_vcinc);
  def<double_t>(d, "comp561_vcinc", comp561_vcinc);
}


void DeSouzaCGC::Parameters_::set (const DictionaryDatum &d)
{
  updateValue<double_t>(d, "comp136_vchdur", comp136_vchdur);
  updateValue<double_t>(d, "comp306_vchdur", comp306_vchdur);
  updateValue<double_t>(d, "comp476_vchdur", comp476_vchdur);
  updateValue<double_t>(d, "comp51_vchold", comp51_vchold);
  updateValue<double_t>(d, "comp221_vchold", comp221_vchold);
  updateValue<double_t>(d, "comp391_vchold", comp391_vchold);
  updateValue<double_t>(d, "comp561_vchold", comp561_vchold);
  updateValue<double_t>(d, "comp51_vcinc", comp51_vcinc);
  updateValue<double_t>(d, "comp391_vcinc", comp391_vcinc);
  updateValue<double_t>(d, "comp51_vchdur", comp51_vchdur);
  updateValue<double_t>(d, "comp221_vchdur", comp221_vchdur);
  updateValue<double_t>(d, "comp391_vchdur", comp391_vchdur);
  updateValue<double_t>(d, "comp561_vchdur", comp561_vchdur);
  updateValue<double_t>(d, "comp136_vcbdur", comp136_vcbdur);
  updateValue<double_t>(d, "comp306_vcbdur", comp306_vcbdur);
  updateValue<double_t>(d, "comp476_vcbdur", comp476_vcbdur);
  updateValue<double_t>(d, "comp306_vcinc", comp306_vcinc);
  updateValue<double_t>(d, "comp136_vcbase", comp136_vcbase);
  updateValue<double_t>(d, "comp306_vcbase", comp306_vcbase);
  updateValue<double_t>(d, "comp476_vcbase", comp476_vcbase);
  updateValue<double_t>(d, "comp51_vcbdur", comp51_vcbdur);
  updateValue<double_t>(d, "comp221_vcbdur", comp221_vcbdur);
  updateValue<double_t>(d, "comp391_vcbdur", comp391_vcbdur);
  updateValue<double_t>(d, "comp561_vcbdur", comp561_vcbdur);
  updateValue<double_t>(d, "comp136_vcinc", comp136_vcinc);
  updateValue<double_t>(d, "comp476_vcinc", comp476_vcinc);
  updateValue<double_t>(d, "comp51_vcbase", comp51_vcbase);
  updateValue<double_t>(d, "comp221_vcbase", comp221_vcbase);
  updateValue<double_t>(d, "comp391_vcbase", comp391_vcbase);
  updateValue<double_t>(d, "comp561_vcbase", comp561_vcbase);
  updateValue<double_t>(d, "comp51_vcsteps", comp51_vcsteps);
  updateValue<double_t>(d, "comp136_vcsteps", comp136_vcsteps);
  updateValue<double_t>(d, "comp221_vcsteps", comp221_vcsteps);
  updateValue<double_t>(d, "comp306_vcsteps", comp306_vcsteps);
  updateValue<double_t>(d, "comp391_vcsteps", comp391_vcsteps);
  updateValue<double_t>(d, "comp476_vcsteps", comp476_vcsteps);
  updateValue<double_t>(d, "comp561_vcsteps", comp561_vcsteps);
  updateValue<double_t>(d, "comp136_vchold", comp136_vchold);
  updateValue<double_t>(d, "comp306_vchold", comp306_vchold);
  updateValue<double_t>(d, "comp476_vchold", comp476_vchold);
  updateValue<double_t>(d, "comp221_vcinc", comp221_vcinc);
  updateValue<double_t>(d, "comp561_vcinc", comp561_vcinc);
}


void DeSouzaCGC::State_::get (DictionaryDatum &d) const
{
  def<double_t>(d, "v", y_[0]);
}


void DeSouzaCGC::State_::set (const DictionaryDatum &d, const Parameters_&)
{
  updateValue<double_t>(d, "v", y_[0]);
}




DeSouzaCGC::Buffers_::Buffers_(DeSouzaCGC& n)
    : logger_(n),
      s_(0),
      c_(0),
      e_(0)
{
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}


DeSouzaCGC::Buffers_::Buffers_(const Buffers_&, DeSouzaCGC& n)
    : logger_(n),
      s_(0),
      c_(0),
      e_(0)
{
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}


DeSouzaCGC::DeSouzaCGC()
    : Archiving_Node(), 
      P_(), 
      S_(P_),
      B_(*this)
{
    recordablesMap_.create();
}


DeSouzaCGC::DeSouzaCGC(const DeSouzaCGC& n)
    : Archiving_Node(n), 
      P_(n.P_), 
      S_(n.S_),
      B_(n.B_, *this)
{
}
DeSouzaCGC::~DeSouzaCGC()
{
    // GSL structs only allocated by init_nodes_(), so we need to protect destruction
    if ( B_.s_ ) gsl_odeiv_step_free(B_.s_);
    if ( B_.c_ ) gsl_odeiv_control_free(B_.c_);
    if ( B_.e_ ) gsl_odeiv_evolve_free(B_.e_);
}


  void DeSouzaCGC::init_node_(const Node& proto)
{
    const DeSouzaCGC& pr = downcast<DeSouzaCGC>(proto);
    P_ = pr.P_;
    S_ = pr.S_;
}


void DeSouzaCGC::init_state_(const Node& proto)
{
    const DeSouzaCGC& pr = downcast<DeSouzaCGC>(proto);
    S_ = pr.S_;
}


void DeSouzaCGC::init_buffers_()
{
      B_.currents_.clear();           
    Archiving_Node::clear_history();

    B_.logger_.reset();

    B_.step_ = Time::get_resolution().get_ms();
    B_.IntegrationStep_ = B_.step_;

    B_.I_stim_ = 0.0;

    static const gsl_odeiv_step_type* T1 = gsl_odeiv_step_rkf45;
  
    if ( B_.s_ == 0 )
      B_.s_ = gsl_odeiv_step_alloc (T1, 1);
    else 
      gsl_odeiv_step_reset(B_.s_);
    
    if ( B_.c_ == 0 )  
      B_.c_ = gsl_odeiv_control_y_new (1e-3, 0.0);
    else
      gsl_odeiv_control_init(B_.c_, 1e-3, 0.0, 1.0, 0.0);
    
    if ( B_.e_ == 0 )  
      B_.e_ = gsl_odeiv_evolve_alloc(1);
    else 
      gsl_odeiv_evolve_reset(B_.e_);
  
    B_.sys_.function  = DeSouzaCGC_dynamics; 
    B_.sys_.jacobian  = 0;
    B_.sys_.dimension = 1;
    B_.sys_.params    = reinterpret_cast<void*>(this);
}


void DeSouzaCGC::calibrate()
{
    B_.logger_.init();  
    V_.RefractoryCounts_ = 20;
    V_.U_old_ = S_.y_[0];
}


void DeSouzaCGC::update(Time const & origin, const long_t from, const long_t to)
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




void DeSouzaCGC::handle(SpikeEvent & e)
  {
    int flag;
    assert(e.get_delay() > 0);
    flag = 0;


}




void DeSouzaCGC::handle(CurrentEvent& e)
  {
    assert(e.get_delay() > 0);

    const double_t c=e.get_current();
    const double_t w=e.get_weight();

    B_.currents_.add_value(e.get_rel_delivery_steps(network()->get_slice_origin()), 
			w *c);
  }

void DeSouzaCGC::handle(DataLoggingRequest& e)
  {
    B_.logger_.handle(e);
  }


}


