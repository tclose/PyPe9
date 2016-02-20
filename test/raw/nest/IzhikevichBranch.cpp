

/* This file was generated by PyPe9 version 0.1 on Thu 11 Feb 16 11:18:06PM */

#include "../../raw/nest/IzhikevichBranch.h"

#include <limits>
#include <iomanip>
#include <iostream>
#include <cstdio>
#include <cstring>
#include <math>

#include "exceptions.h"
#include "network.h"
#include "dict.h"
#include "integerdatum.h"
#include "doubledatum.h"
#include "dictutils.h"
#include "numerics.h"
#include "universal_data_logger_impl.h"

/******************************************************************
 * Template specialization that needs to be in the nest namesapce *
 ******************************************************************/

nest::RecordablesMap<nineml::IzhikevichBranch> nineml::IzhikevichBranch::recordablesMap_;

namespace nest{
  template <> void RecordablesMap<nineml::IzhikevichBranch>::create() {
    insert_("U", &nineml::IzhikevichBranch::get_y_elem_<nineml::IzhikevichBranch::State_::U_INDEX>);
    insert_("V", &nineml::IzhikevichBranch::get_y_elem_<nineml::IzhikevichBranch::State_::V_INDEX>);
  }
}

/************************************************
 * Evaluation of dynamics for a single timestep *
 ************************************************/

namespace nineml {

std::string ExceededMaximumSimultaneousTransitions::message() {
    std::ostringstream msg;
    msg << "Exceeded maxium number of simultaneous transitions (" << num_transitions << ")";
    msg << " in " << model << " at " << t << " ms. Probable infinite loop.";
    return msg.str();
}


IzhikevichBranch::Regime_::~Regime_() {
    for (std::vector<OnCondition_*>::iterator it = on_conditions.begin(); it != on_conditions.end(); ++it)
        delete *it;
    for (std::vector<OnEvent_*>::iterator it = on_events.begin(); it != on_events.end(); ++it)    
        delete *it;
}

IzhikevichBranch::Transition_* IzhikevichBranch::Regime_::transition(nest::Time const& origin, const nest::long_t& lag) {
    // Set the time to the end of the current timestep
    double t = origin.get_ms() + lag * nest::Time::get_resolution().get_ms();

    // Get vector of transitions (both OnConditions and OnEvents) that are triggered in the current timestep
    std::vector<Transition_*> occurred;
    for (std::vector<OnCondition_*>::iterator it = active_on_conditions.begin(); it != active_on_conditions.end(); ++it)
        if ((*it)->condition(t))
            occurred.push_back(*it);
            
    for (std::vector<OnEvent_*>::iterator it = on_events.begin(); it != on_events.end(); ++it)
        if ((*it)->received(origin, lag))
            occurred.push_back(*it);

    // Get the earliest transition to be triggered
    Transition_* transition;
    if (!occurred.size())
        transition = NULL;
    else if (occurred.size() == 1)
        transition = occurred[0];
    else {
        std::vector<double> times;
        for (std::vector<Transition_*>::iterator it = occurred.begin(); it != occurred.end(); ++it) 
            times.push_back((*it)->time_occurred(origin, lag));
        int min_index = std::min_element(times.begin(), times.end()) - times.begin();
        transition = occurred[min_index];
    }
    return transition;
}


void IzhikevichBranch::Regime_::set_triggers(double t) {
    // Reset the vector of active transitions
    active_on_conditions.clear();
    
    // Add OnConditions to the list of active transitions if their trigger condition evaluates to false
    for (std::vector<OnCondition_*>::iterator it = on_conditions.begin(); it != on_conditions.end(); ++it)
        if (!(*it)->condition(t))
            active_on_conditions.push_back(*it);
        
}



/**
 *  Dynamics and transitions for subthreshold_regime regime
 */

extern "C" int IzhikevichBranch_subthreshold_regime_dynamics(double t, const double y_[], double f_[], void* pnode_) {

    // Get references to the members of the model
    assert(pnode_);
    const IzhikevichBranch& node_ = *(reinterpret_cast<IzhikevichBranch*>(pnode_));
    const IzhikevichBranch::Parameters_& P_ = node_.P_;
    const IzhikevichBranch::State_& S_ = node_.S_;
    const IzhikevichBranch::Buffers_& B_ = node_.B_;

    // State Variables
    const double_t& U = S_.y_[IzhikevichBranch::State_::U_INDEX];  // (mV/ms)
    const double_t& V = S_.y_[IzhikevichBranch::State_::V_INDEX];  // (mV)
        
    
    // Parameters
    const double_t& b = P_.b;  // (1/ms)
    const double_t& zeta = P_.zeta;  // (mV/ms)
    const double_t& alpha = P_.alpha;  // (1/ms*mV)
    const double_t& a = P_.a;  // (1/ms)
    const double_t& C_m = P_.C_m;  // (pF)
    const double_t& beta = P_.beta;  // (1/ms)
    
    // Analog receive ports
    const double_t& Isyn = B_.Isyn_value;  // (pA)
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    // Evaluate differential equations
    ITEM(f_, IzhikevichBranch::State_::U_INDEX) = a*(-U + V*b);  // (mV/ms^2)
    ITEM(f_, IzhikevichBranch::State_::V_INDEX) = -U + V*beta + alpha*(V*V) + zeta + Isyn/C_m;  // (mV/ms)
	
    //std::cout << "Success at t=" << t << ": " << GSL_SUCCESS << std::endl;
    return GSL_SUCCESS;}        
    
/* Jacobian for the subthreshold_regime regime if required by the solver */
/** Diagonal Jacobian approximation (for GSL): (f(s+.01) - f(s))/.001 */
extern "C" int IzhikevichBranch_subthreshold_regime_jacobian(double t, const double y[], double *dfdy, double dfdt[], void* node) {
    // cast the node ptr to IzhikevichBranch object
    assert(node);
    IzhikevichBranch& cell =    *(reinterpret_cast<IzhikevichBranch*>(node));
    IzhikevichBranch::subthreshold_regimeRegime_& regime = *(reinterpret_cast<IzhikevichBranch::subthreshold_regimeRegime_*>(cell.get_regime("subthreshold_regime")));

    for (int i = 0; i < regime.N; i++)
        regime.u[i] = y[i] + 0.01;

    IzhikevichBranch_subthreshold_regime_dynamics(t, regime.u, regime.jac, node);
    for (int i = 0; i < regime.N; i++)
        dfdt[i*regime.N + i] = (regime.jac[i] - dfdy[i]) / .001;
    return 0;
}
IzhikevichBranch::subthreshold_regimeRegime_::subthreshold_regimeRegime_(IzhikevichBranch* cell)
  : Regime_(cell, IzhikevichBranch_subthreshold_regime_dynamics),
      IntegrationStep_(0),
      s_(0),
      c_(0),
      e_(0),
      N(0),
      u(0),
      jac(0) {
  
    // Construct OnConditions specific to the regime.
    on_conditions.push_back(new subthreshold_regimeOnCondition0(this, "subthreshold_regime"));
	
    // Construct OnConditions specific to the regime.

}

IzhikevichBranch::subthreshold_regimeRegime_::~subthreshold_regimeRegime_() {
    
    // GSL structs only allocated by init_nodes_(),
    // so we need to protect destruction
    if ( s_ != NULL)
        gsl_odeiv2_step_free (s_);
    if ( c_ != NULL)
        gsl_odeiv2_control_free (c_);
    if ( e_ != NULL)
        gsl_odeiv2_evolve_free (e_);
    if ( u != NULL)
        free (u);
    if ( jac != NULL)
        free (jac);}

void IzhikevichBranch::subthreshold_regimeRegime_::init_solver() {
    

    IntegrationStep_ = cell->B_.step_;

    static const gsl_odeiv2_step_type* T1 = gsl_odeiv2_step_rk2;
    //FIXME: Could be reduced to include only the states which have a time
    //       derivative
    N = 2;

    if ( s_ == 0 )
        s_ = gsl_odeiv2_step_alloc (T1, N);
    else
        gsl_odeiv2_step_reset(s_);

    if ( c_ == 0 )
        c_ = gsl_odeiv2_control_standard_new (0.001, 0.0, 1.0, 0.0);
    else
        gsl_odeiv2_control_init(c_, 0.001, 0.0, 1.0, 0.0);

    if ( e_ == 0 )
        e_ = gsl_odeiv2_evolve_alloc(N);
    else
        gsl_odeiv2_evolve_reset(e_);

    sys_.function  = IzhikevichBranch_subthreshold_regime_dynamics;
    sys_.jacobian  = IzhikevichBranch_subthreshold_regime_jacobian;
    sys_.dimension = N;
    sys_.params    = reinterpret_cast<void*>(this);

    if (u == 0)
        u = (double *)malloc(sizeof(double) * N);
        assert (u);
    if (jac == 0)
        jac = (double *)malloc(sizeof(double) * N);
        assert (jac);    
}

void IzhikevichBranch::subthreshold_regimeRegime_::step_ode() {
    IzhikevichBranch::State_& S_ = cell->S_;
    //FIXME: Clamping of vars should be replaced by the resizing of the state
    //       vector that is solved to only the states that have time-derivatives
    //       in the regime.
    /***** Set clamp vars for state variables that don't have a time derivative in this regime *****/

    // Step ODE solver
    double dt = nest::Time::get_resolution().get_ms();
    double tt = 0.0;
    while (tt < dt) {
        const int status =  gsl_odeiv2_evolve_apply(
            e_, c_, s_,
            &sys_, // system of ODE
            &tt, // from t...
            dt, // ...to t= t + dt
            &IntegrationStep_, // integration window (written on!)
            this->cell->S_.y_); // neuron state
        if (status != GSL_SUCCESS)
          throw nest::GSLSolverFailure(this->cell->get_name(), status);
    }    
    /***** Reset state variables from clamp vars for state variables that don't have a time derivative in this regime *****/
}

// Transition methods for subthreshold_regime regime


bool IzhikevichBranch::subthreshold_regimeOnCondition0::body(double t) {
    // Map all variables/expressions to the local namespace that are required to evaluate the state assignments that were not required for the triggers


    State_& S_ = regime->cell->S_;
    Buffers_& B_ = regime->cell->B_;
    const Parameters_& P_ = regime->cell->P_;
    Variables_& V_ = regime->cell->V_;
    
    
    // State Variables
    const double_t& U = S_.y_[IzhikevichBranch::State_::U_INDEX];  // (mV/ms)
        
    
    // Parameters
    const double_t& d = P_.d;  // (mV/ms)
    const double_t& c = P_.c;  // (mV)
    
    // Analog receive ports
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    // State assignments
    S_.y_[IzhikevichBranch::State_::U_INDEX] = U + d;  // (mV/ms)
    S_.y_[IzhikevichBranch::State_::V_INDEX] = c;  // (mV)
	        
    // Output events
    ++B_.num_spike_events;

        
    return true;  // Transition contains discontinuous changes in state
}

bool IzhikevichBranch::subthreshold_regimeOnCondition0::condition(double t) {
	    
    const State_& S_ = regime->cell->S_;
    const Buffers_& B_ = regime->cell->B_;
    const Parameters_& P_ = regime->cell->P_;
        
    // State Variables
    const double_t& V = S_.y_[IzhikevichBranch::State_::V_INDEX];  // (mV)
        
    
    // Parameters
    const double_t& theta = P_.theta;  // (mV)
    
    // Analog receive ports
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    return V > theta;

}

double IzhikevichBranch::subthreshold_regimeOnCondition0::time_occurred(nest::Time const& origin, const nest::long_t& lag) {
    return origin.get_ms() + lag * nest::Time::get_resolution().get_ms();
}



/**********************************************
 * Calculation of the residual for IDA solver *
 **********************************************/


/***********************
 * Steady-sate solvers *
 ***********************/




/****************
 * Constructors *
 ****************/

IzhikevichBranch::IzhikevichBranch()
    : Archiving_Node(),
      P_(),
      S_(P_),
      B_(*this) {

    recordablesMap_.create();
    construct_regimes();
        
}

IzhikevichBranch::IzhikevichBranch(const IzhikevichBranch& n)
    : Archiving_Node(n),
      P_(n.P_),
      S_(n.S_),
      B_(n.B_, *this) {
      
    construct_regimes();
}

/**
 * Constructs all regimes (and their transitions) in the component class
 */      
void IzhikevichBranch::construct_regimes() {

    // Construct all regimes
    regimes["subthreshold_regime"] = new subthreshold_regimeRegime_(this);

    // Set target regimes in all transitions
    Regime_* regime;

    regime = get_regime("subthreshold_regime");
    for (std::vector<OnEvent_*>::iterator it = regime->on_events.begin(); it != regime->on_events.end(); ++it)
        (*it)->set_target_regime(regimes);
    for (std::vector<OnCondition_*>::iterator it = regime->on_conditions.begin(); it != regime->on_conditions.end(); ++it)
        (*it)->set_target_regime(regimes);   
}

void IzhikevichBranch::init_node_(const Node& proto) {
    const IzhikevichBranch& pr = downcast<IzhikevichBranch>(proto);
    P_ = pr.P_;
    S_ = State_(P_);
}

void IzhikevichBranch::init_state_(const Node& proto) {
    const IzhikevichBranch& pr = downcast<IzhikevichBranch>(proto);
    S_ = State_(pr.P_);
}

/**************
 * Destructor *
 **************/

IzhikevichBranch::~IzhikevichBranch () {
    // Destruct all regimes
    for (std::map<std::string, Regime_*>::iterator it = regimes.begin(); it != regimes.end(); ++it)
        delete it->second;
    regimes.clear();
}


/**********************************
 * Define parameters of the model *
 **********************************/

IzhikevichBranch::Parameters_::Parameters_():
    a (0.0),
    c (0.0),
    b (0.0),
    d (0.0),
    C_m (0.0),
    beta (0.0),
    theta (0.0),
    alpha (0.0),
    zeta (0.0) {
// Check constraints on parameters
}

/************************************
 * Construct state from parameters.
 ************************************/

IzhikevichBranch::State_::State_(const Parameters_& p) {

    const Parameters_ *params = &p;

    // FIXME: need to add initial state here
    y_[U_INDEX] = 0.0;
    y_[V_INDEX] = 0.0;

}

/***********************************
 * Copy constructor for State class
 ***********************************/
IzhikevichBranch::State_::State_(const State_& s) {
  for (int i = 0 ; i < 2 ; ++i)
      y_[i] = s.y_[i];
}

/********************************************
 * Assignment of a State from another State *
 ********************************************/

IzhikevichBranch::State_& IzhikevichBranch::State_::operator=(const State_& s) {
  assert(this != &s);
  for (size_t i = 0 ; i < 2 ; ++i)
       y_[i] = s.y_[i];

  return *this;
}

void IzhikevichBranch::calibrate() {
    B_.logger_.init();
    V_.rng_ = net_->get_rng( get_thread() );
}

/***************************
 * Accessors and Modifiers *
 ***************************/

void IzhikevichBranch::Parameters_::get (DictionaryDatum &d_) const {

    // Update dictionary from internal parameters, scaling if required.
    def<double_t>(d_, "a", a);
    def<double_t>(d_, "c", c);
    def<double_t>(d_, "b", b);
    def<double_t>(d_, "d", d);
    def<double_t>(d_, "C_m", C_m);
    def<double_t>(d_, "beta", beta);
    def<double_t>(d_, "theta", theta);
    def<double_t>(d_, "alpha", alpha);
    def<double_t>(d_, "zeta", zeta);

}

void IzhikevichBranch::Parameters_::set (const DictionaryDatum &d_) {

    // Update internal parameters from dictionary
    updateValue<double_t>(d_, "a", a);
    updateValue<double_t>(d_, "c", c);
    updateValue<double_t>(d_, "b", b);
    updateValue<double_t>(d_, "d", d);
    updateValue<double_t>(d_, "C_m", C_m);
    updateValue<double_t>(d_, "beta", beta);
    updateValue<double_t>(d_, "theta", theta);
    updateValue<double_t>(d_, "alpha", alpha);
    updateValue<double_t>(d_, "zeta", zeta);

    // Scale parameters as required
}

void IzhikevichBranch::State_::get (DictionaryDatum &d_) const {
    // Get states from internal variables
    def<double_t>(d_, "U", y_[0]);
    def<double_t>(d_, "V", y_[1]);
}

void IzhikevichBranch::State_::set (const DictionaryDatum &d_, const Parameters_&) {
    // Set internal state variables from dictionary values
    updateValue<double_t>(d_, "U", y_[0]);
    updateValue<double_t>(d_, "V", y_[1]);
}

/***********
 * Buffers *
 ***********/

IzhikevichBranch::Buffers_::Buffers_(IzhikevichBranch& n)
    : logger_(n) {
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}

IzhikevichBranch::Buffers_::Buffers_(const Buffers_&, IzhikevichBranch& n)
    : logger_(n) {
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}

void IzhikevichBranch::init_buffers_() {

    // Clear event buffers

    // Clear analog buffers
    B_.Isyn_analog_port.clear();

    Archiving_Node::clear_history();

    B_.logger_.reset();

    B_.step_ = nest::Time::get_resolution().get_ms();

    B_.Isyn_value = 0.0;

    B_.current_regime = get_regime("subthreshold_regime");
    B_.current_regime->set_triggers(0);
    B_.current_regime->init_solver();

}


void IzhikevichBranch::refresh_events(const nest::long_t& lag) {
    B_.num_spike_events = 0;
}

/************************************************************************
 * Function to be solved for its roots be solver to exact trigger times *
 ************************************************************************/


/***********************
 * Evaluate the update *
 ***********************/

void IzhikevichBranch::update(nest::Time const & origin, const nest::long_t from, const nest::long_t to) {

    assert(to >= 0 && (nest::delay) from < nest::Scheduler::get_min_delay());
    assert(from < to);

    double dt = nest::Time::get_resolution().get_ms();
    nest::long_t current_steps = origin.get_steps();

    double f_[IzhikevichBranch::State_::STATE_VEC_SIZE_];  // Vector to hold the time derivatives

    for (nest::long_t lag = from; lag < to; ++lag) {

        /***** Solve ODE over timestep *****/
        B_.current_regime->step_ode();

        /***** Transition handling *****/
        // Get multiplicity incoming events for the current lag and reset multiplicity of outgoing events
        refresh_events(lag);
        
        Transition_* transition;
        int simultaneous_transition_count = 0;
        double prev_t = origin.get_ms();
        while ((transition = B_.current_regime->transition(origin, lag))) {  // Check for a transition (i.e. the output of current_regime->transition is not NULL) and record it in the 'transition' variable.
            double t = transition->time_occurred(origin, lag);  // Get the exact time the transition occurred.
            if (t == prev_t)
                ++simultaneous_transition_count;
            else
                simultaneous_transition_count = 0;
            if (simultaneous_transition_count > MAX_SIMULTANEOUS_TRANSITIONS)
                throw ExceededMaximumSimultaneousTransitions("IzhikevichBranch", simultaneous_transition_count, t);
            bool discontinuous = transition->body(t) || (transition->get_target_regime() != B_.current_regime);
            B_.current_regime = transition->get_target_regime();
            B_.current_regime->set_triggers(t);
            if (discontinuous)
                B_.current_regime->init_solver();  // Reset the solver if the transition contains state assignments or switches to a new regime.
        }
        
        
        /***** Send output events for each event send port *****/
        // FIXME: Need to specify different output ports in a way that can be read by the receiving nodes
        // Output events        
        if (B_.num_spike_events) {
		    set_spiketime(nest::Time::step(origin.get_steps()+lag+1));
		    nest::SpikeEvent se;
		    se.set_multiplicity(B_.num_spike_events);
		    network()->send(*this, se, lag); 
        }

        /***** Get analog port values *****/
        B_.Isyn_value = B_.Isyn_analog_port.get_value(lag);

        /***** Record data *****/
        B_.logger_.record_data(current_steps + lag);
    }
}

/*****************
 * Event Handles *
 *****************/

void IzhikevichBranch::handle(nest::SpikeEvent & e) {
    assert(e.get_delay() > 0);
    // Loop through event receive ports
}

void IzhikevichBranch::handle(nest::CurrentEvent& e) {
    assert(e.get_delay() > 0);

    const double_t c = e.get_current();
    const double_t w = e.get_weight();    
    // Loop through analog receive ports
    if (e.get_rport() == Isyn_ANALOG_PORT) {
        B_.Isyn_analog_port.add_value(
            e.get_rel_delivery_steps(network()->get_slice_origin()), w * c);
    }
}

void IzhikevichBranch::handle(nest::DataLoggingRequest& e) {
    B_.logger_.handle(e);
}

}  // End 'nineml' namespace
