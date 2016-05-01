

/* This file was generated by PyPe9 version 0.1 on Sun 17 Apr 16 12:41:47AM */

#include <limits>
#include <iomanip>
#include <iostream>
#include <cstdio>
#include <cstring>
#include <cmath>

#include "PyNNLeakyIntegrateAndFire.h"
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

nest::RecordablesMap<nineml::PyNNLeakyIntegrateAndFire> nineml::PyNNLeakyIntegrateAndFire::recordablesMap_;

namespace nest{
  template <> void RecordablesMap<nineml::PyNNLeakyIntegrateAndFire>::create() {
    insert_("end_refractory", &nineml::PyNNLeakyIntegrateAndFire::get_y_elem_<nineml::PyNNLeakyIntegrateAndFire::State_::end_refractory_INDEX>);
    insert_("v", &nineml::PyNNLeakyIntegrateAndFire::get_y_elem_<nineml::PyNNLeakyIntegrateAndFire::State_::v_INDEX>);
  }
}

/************************************************
 * Evaluation of dynamics for a single timestep *
 ************************************************/

namespace nineml {

std::string PyNNLeakyIntegrateAndFire::ExceededMaximumSimultaneousTransitions::message() {
    std::ostringstream msg;
    msg << "Exceeded maxium number of simultaneous transitions (" << num_transitions << ")";
    msg << " in " << model << " at " << t << " ms. Probable infinite loop.";
    return msg.str();
}


PyNNLeakyIntegrateAndFire::Regime_::~Regime_() {
    for (std::vector<OnCondition_*>::iterator it = on_conditions.begin(); it != on_conditions.end(); ++it)
        delete *it;
    for (std::vector<OnEvent_*>::iterator it = on_events.begin(); it != on_events.end(); ++it)    
        delete *it;
}

PyNNLeakyIntegrateAndFire::Transition_* PyNNLeakyIntegrateAndFire::Regime_::transition(nest::Time const& origin, const nest::long_t& lag) {
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


void PyNNLeakyIntegrateAndFire::Regime_::set_triggers(double t) {
    // Reset the vector of active transitions
    active_on_conditions.clear();
    
    // Add OnConditions to the list of active transitions if their trigger condition evaluates to false
    for (std::vector<OnCondition_*>::iterator it = on_conditions.begin(); it != on_conditions.end(); ++it)
        if (!(*it)->condition(t))
            active_on_conditions.push_back(*it);
        
}



/**
 *  Dynamics and transitions for refractory regime
 */

    
/* Jacobian for the refractory regime if required by the solver */

PyNNLeakyIntegrateAndFire::refractoryRegime_::refractoryRegime_(PyNNLeakyIntegrateAndFire* cell)
  : Regime_(cell) {
  
    // Construct OnConditions specific to the regime.
    on_conditions.push_back(new refractoryOnCondition0(this, "subthreshold"));
	
    // Construct OnConditions specific to the regime.

}

PyNNLeakyIntegrateAndFire::refractoryRegime_::~refractoryRegime_() {
}

void PyNNLeakyIntegrateAndFire::refractoryRegime_::init_solver() {
    
}

void PyNNLeakyIntegrateAndFire::refractoryRegime_::step_ode() {
}

// Transition methods for refractory regime


bool PyNNLeakyIntegrateAndFire::refractoryOnCondition0::body(double t) {
    // Map all variables/expressions to the local namespace that are required to evaluate the state assignments that were not required for the triggers


    State_& S_ = regime->cell->S_;
    Buffers_& B_ = regime->cell->B_;
    const Parameters_& P_ = regime->cell->P_;
    Variables_& V_ = regime->cell->V_;
    
    
    // State Variables
        
    
    // Parameters
    
    // Analog receive ports
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    // State assignments
	        
    // Output events
        
    return false;  // Transition doesn't contain discontinuous changes in state
}

bool PyNNLeakyIntegrateAndFire::refractoryOnCondition0::condition(double t) {
	    
    const State_& S_ = regime->cell->S_;
    const Buffers_& B_ = regime->cell->B_;
    const Parameters_& P_ = regime->cell->P_;
        
    // State Variables
    const double_t& end_refractory = S_.y_[PyNNLeakyIntegrateAndFire::State_::end_refractory_INDEX];  // (ms)
        
    
    // Parameters
    
    // Analog receive ports
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    return t > end_refractory;

}

double PyNNLeakyIntegrateAndFire::refractoryOnCondition0::time_occurred(nest::Time const& origin, const nest::long_t& lag) {

    const State_& S_ = regime->cell->S_;
    const Buffers_& B_ = regime->cell->B_;
    const Parameters_& P_ = regime->cell->P_;
       
    // State Variables
    const double_t& end_refractory = S_.y_[PyNNLeakyIntegrateAndFire::State_::end_refractory_INDEX];  // (ms)
        
    
    // Parameters
    
    // Analog receive ports
    
    // Constants
    
    // Random variables
    
    // Aliases
           
    // The trigger expression depends on 't' so determine the exact time that the threshold was crossed.
    return end_refractory;
}


/**
 *  Dynamics and transitions for subthreshold regime
 */

extern "C" int PyNNLeakyIntegrateAndFire_subthreshold_dynamics(double t, const double y_[], double f_[], void* pnode_) {

    // Get references to the members of the model
    assert(pnode_);
    const PyNNLeakyIntegrateAndFire& node_ = *(reinterpret_cast<PyNNLeakyIntegrateAndFire*>(pnode_));
    const PyNNLeakyIntegrateAndFire::Parameters_& P_ = node_.P_;
    const PyNNLeakyIntegrateAndFire::State_& S_ = node_.S_;
    const PyNNLeakyIntegrateAndFire::Buffers_& B_ = node_.B_;

    // State Variables
    const double_t& v = S_.y_[PyNNLeakyIntegrateAndFire::State_::v_INDEX];  // (mV)
        
    
    // Parameters
    const double_t& Cm = P_.Cm;  // (pF)
    const double_t& g_leak = P_.g_leak;  // (nS)
    const double_t& e_leak = P_.e_leak;  // (mV)
    
    // Analog receive ports
    const double_t& i_synaptic = B_.i_synaptic_value;  // (pA)
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    // Evaluate differential equations
    ITEM(f_, PyNNLeakyIntegrateAndFire::State_::v_INDEX) = (g_leak*(e_leak - v) + i_synaptic)/Cm;  // (mV/ms)
	
    //std::cout << "Success at t=" << t << ": " << GSL_SUCCESS << std::endl;
    return GSL_SUCCESS;}        
    
/* Jacobian for the subthreshold regime if required by the solver */
/** Diagonal Jacobian approximation (for GSL): (f(s+.01) - f(s))/.001 */
extern "C" int PyNNLeakyIntegrateAndFire_subthreshold_jacobian(double t, const double y[], double *dfdy, double dfdt[], void* node) {
    // cast the node ptr to PyNNLeakyIntegrateAndFire object
    assert(node);
    PyNNLeakyIntegrateAndFire& cell =    *(reinterpret_cast<PyNNLeakyIntegrateAndFire*>(node));
    PyNNLeakyIntegrateAndFire::subthresholdRegime_& regime = *(reinterpret_cast<PyNNLeakyIntegrateAndFire::subthresholdRegime_*>(cell.get_regime("subthreshold")));

    for (unsigned int i = 0; i < regime.N; i++)
        regime.u[i] = y[i] + 0.01;

    PyNNLeakyIntegrateAndFire_subthreshold_dynamics(t, regime.u, regime.jac, node);
    for (unsigned int i = 0; i < regime.N; i++)
        dfdt[i*regime.N + i] = (regime.jac[i] - dfdy[i]) / .001;
    return 0;
}
PyNNLeakyIntegrateAndFire::subthresholdRegime_::subthresholdRegime_(PyNNLeakyIntegrateAndFire* cell)
  : Regime_(cell, PyNNLeakyIntegrateAndFire_subthreshold_dynamics),
      IntegrationStep_(0),
      s_(0),
      c_(0),
      e_(0),
      N(0),
      u(0),
      jac(0) {
  
    // Construct OnConditions specific to the regime.
    on_conditions.push_back(new subthresholdOnCondition0(this, "refractory"));
	
    // Construct OnConditions specific to the regime.

}

PyNNLeakyIntegrateAndFire::subthresholdRegime_::~subthresholdRegime_() {
    
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

void PyNNLeakyIntegrateAndFire::subthresholdRegime_::init_solver() {
    

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

    sys_.function  = PyNNLeakyIntegrateAndFire_subthreshold_dynamics;
    sys_.jacobian  = PyNNLeakyIntegrateAndFire_subthreshold_jacobian;
    sys_.dimension = N;
    sys_.params    = reinterpret_cast<void*>(this->cell);

    if (u == 0)
        u = (double *)malloc(sizeof(double) * N);
        assert (u);
    if (jac == 0)
        jac = (double *)malloc(sizeof(double) * N);
        assert (jac);    
}

void PyNNLeakyIntegrateAndFire::subthresholdRegime_::step_ode() {
    PyNNLeakyIntegrateAndFire::State_& S_ = cell->S_;
    //FIXME: Clamping of vars should be replaced by the resizing of the state
    //       vector that is solved to only the states that have time-derivatives
    //       in the regime.
    /***** Set clamp vars for state variables that don't have a time derivative in this regime *****/
    double end_refractory_clamp_ = S_.y_[PyNNLeakyIntegrateAndFire::State_::end_refractory_INDEX];

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
            cell->S_.y_); // neuron state
        if (status != GSL_SUCCESS)
          throw nest::GSLSolverFailure(cell->get_name(), status);
    }    
    /***** Reset state variables from clamp vars for state variables that don't have a time derivative in this regime *****/
    S_.y_[PyNNLeakyIntegrateAndFire::State_::end_refractory_INDEX] = end_refractory_clamp_;
}

// Transition methods for subthreshold regime


bool PyNNLeakyIntegrateAndFire::subthresholdOnCondition0::body(double t) {
    // Map all variables/expressions to the local namespace that are required to evaluate the state assignments that were not required for the triggers


    State_& S_ = regime->cell->S_;
    Buffers_& B_ = regime->cell->B_;
    const Parameters_& P_ = regime->cell->P_;
    Variables_& V_ = regime->cell->V_;
    
    
    // State Variables
        
    
    // Parameters
    const double_t& refractory_period = P_.refractory_period;  // (ms)
    const double_t& v_reset = P_.v_reset;  // (mV)
    
    // Analog receive ports
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    // State assignments
    S_.y_[PyNNLeakyIntegrateAndFire::State_::end_refractory_INDEX] = refractory_period + t;  // (ms)
    S_.y_[PyNNLeakyIntegrateAndFire::State_::v_INDEX] = v_reset;  // (mV)
	        
    // Output events
    ++B_.num_spikeoutput_events;

        
    return true;  // Transition contains discontinuous changes in state
}

bool PyNNLeakyIntegrateAndFire::subthresholdOnCondition0::condition(double t) {
	    
    const State_& S_ = regime->cell->S_;
    const Buffers_& B_ = regime->cell->B_;
    const Parameters_& P_ = regime->cell->P_;
        
    // State Variables
    const double_t& v = S_.y_[PyNNLeakyIntegrateAndFire::State_::v_INDEX];  // (mV)
        
    
    // Parameters
    const double_t& v_threshold = P_.v_threshold;  // (mV)
    
    // Analog receive ports
    
    // Constants
    
    // Random variables
    
    // Aliases
    

    return v > v_threshold;

}

double PyNNLeakyIntegrateAndFire::subthresholdOnCondition0::time_occurred(nest::Time const& origin, const nest::long_t& lag) {
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

PyNNLeakyIntegrateAndFire::PyNNLeakyIntegrateAndFire()
    : Archiving_Node(),
      P_(),
      S_(P_),
      B_(*this) {

    recordablesMap_.create();
    construct_regimes();
        
}

PyNNLeakyIntegrateAndFire::PyNNLeakyIntegrateAndFire(const PyNNLeakyIntegrateAndFire& n)
    : Archiving_Node(n),
      P_(n.P_),
      S_(n.S_),
      B_(n.B_, *this) {
      
    construct_regimes();
}

/**
 * Constructs all regimes (and their transitions) in the component class
 */      
void PyNNLeakyIntegrateAndFire::construct_regimes() {

    // Construct all regimes
    regimes["refractory"] = new refractoryRegime_(this);
    regimes["subthreshold"] = new subthresholdRegime_(this);

    // Set target regimes in all transitions
    Regime_* regime;

    regime = get_regime("refractory");
    for (std::vector<OnEvent_*>::iterator it = regime->on_events.begin(); it != regime->on_events.end(); ++it)
        (*it)->set_target_regime(regimes);
    for (std::vector<OnCondition_*>::iterator it = regime->on_conditions.begin(); it != regime->on_conditions.end(); ++it)
        (*it)->set_target_regime(regimes);   
    regime = get_regime("subthreshold");
    for (std::vector<OnEvent_*>::iterator it = regime->on_events.begin(); it != regime->on_events.end(); ++it)
        (*it)->set_target_regime(regimes);
    for (std::vector<OnCondition_*>::iterator it = regime->on_conditions.begin(); it != regime->on_conditions.end(); ++it)
        (*it)->set_target_regime(regimes);   
}

void PyNNLeakyIntegrateAndFire::init_node_(const Node& proto) {
    const PyNNLeakyIntegrateAndFire& pr = downcast<PyNNLeakyIntegrateAndFire>(proto);
    P_ = pr.P_;
    S_ = State_(P_);
}

void PyNNLeakyIntegrateAndFire::init_state_(const Node& proto) {
    const PyNNLeakyIntegrateAndFire& pr = downcast<PyNNLeakyIntegrateAndFire>(proto);
    S_ = State_(pr.P_);
}

/**************
 * Destructor *
 **************/

PyNNLeakyIntegrateAndFire::~PyNNLeakyIntegrateAndFire () {
    // Destruct all regimes
    for (std::map<std::string, Regime_*>::iterator it = regimes.begin(); it != regimes.end(); ++it)
        delete it->second;
    regimes.clear();
}


/**********************************
 * Define parameters of the model *
 **********************************/

PyNNLeakyIntegrateAndFire::Parameters_::Parameters_():
    g_leak (0.0),
    Cm (0.0),
    refractory_period (0.0),
    v_threshold (0.0),
    v_reset (0.0),
    e_leak (0.0) {
// Check constraints on parameters
}

/************************************
 * Construct state from parameters.
 ************************************/

PyNNLeakyIntegrateAndFire::State_::State_(const Parameters_& p) {

    const Parameters_ *params = &p;

    // FIXME: need to add initial state here
    y_[end_refractory_INDEX] = 0.0;
    y_[v_INDEX] = 0.0;

}

/***********************************
 * Copy constructor for State class
 ***********************************/
PyNNLeakyIntegrateAndFire::State_::State_(const State_& s) {
  for (int i = 0 ; i < 2 ; ++i)
      y_[i] = s.y_[i];
}

/********************************************
 * Assignment of a State from another State *
 ********************************************/

PyNNLeakyIntegrateAndFire::State_& PyNNLeakyIntegrateAndFire::State_::operator=(const State_& s) {
  assert(this != &s);
  for (size_t i = 0 ; i < 2 ; ++i)
       y_[i] = s.y_[i];

  return *this;
}

void PyNNLeakyIntegrateAndFire::calibrate() {
    B_.logger_.init();
    V_.rng_ = net_->get_rng( get_thread() );
}

/***************************
 * Accessors and Modifiers *
 ***************************/

void PyNNLeakyIntegrateAndFire::Parameters_::get (DictionaryDatum &d_) const {

    // Update dictionary from internal parameters, scaling if required.
    def<double_t>(d_, "g_leak", g_leak);
    def<double_t>(d_, "Cm", Cm);
    def<double_t>(d_, "refractory_period", refractory_period);
    def<double_t>(d_, "v_threshold", v_threshold);
    def<double_t>(d_, "v_reset", v_reset);
    def<double_t>(d_, "e_leak", e_leak);

}

void PyNNLeakyIntegrateAndFire::Parameters_::set (const DictionaryDatum &d_) {

    // Update internal parameters from dictionary
    updateValue<double_t>(d_, "g_leak", g_leak);
    updateValue<double_t>(d_, "Cm", Cm);
    updateValue<double_t>(d_, "refractory_period", refractory_period);
    updateValue<double_t>(d_, "v_threshold", v_threshold);
    updateValue<double_t>(d_, "v_reset", v_reset);
    updateValue<double_t>(d_, "e_leak", e_leak);

    // Scale parameters as required
}

void PyNNLeakyIntegrateAndFire::State_::get (DictionaryDatum &d_) const {
    // Get states from internal variables
    def<double_t>(d_, "end_refractory", y_[0]);
    def<double_t>(d_, "v", y_[1]);
}

void PyNNLeakyIntegrateAndFire::State_::set (const DictionaryDatum &d_, const Parameters_&) {
    // Set internal state variables from dictionary values
    updateValue<double_t>(d_, "end_refractory", y_[0]);
    updateValue<double_t>(d_, "v", y_[1]);
}

/***********
 * Buffers *
 ***********/

PyNNLeakyIntegrateAndFire::Buffers_::Buffers_(PyNNLeakyIntegrateAndFire& n)
    : logger_(n) {
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}

PyNNLeakyIntegrateAndFire::Buffers_::Buffers_(const Buffers_&, PyNNLeakyIntegrateAndFire& n)
    : logger_(n) {
    // Initialization of the remaining members is deferred to
    // init_buffers_().
}

void PyNNLeakyIntegrateAndFire::init_buffers_() {

    // Clear event buffers

    // Clear analog buffers
    B_.i_synaptic_analog_port.clear();

    Archiving_Node::clear_history();

    B_.logger_.reset();

    B_.step_ = nest::Time::get_resolution().get_ms();

    B_.i_synaptic_value = 0.0;

    B_.current_regime = get_regime("refractory");
    B_.current_regime->set_triggers(0);
    B_.current_regime->init_solver();

}


void PyNNLeakyIntegrateAndFire::refresh_events(const nest::long_t& lag) {
    B_.num_spikeoutput_events = 0;
}

/************************************************************************
 * Function to be solved for its roots be solver to exact trigger times *
 ************************************************************************/


/***********************
 * Evaluate the update *
 ***********************/

void PyNNLeakyIntegrateAndFire::update(nest::Time const & origin, const nest::long_t from, const nest::long_t to) {

    assert(to >= 0 && (nest::delay) from < nest::Scheduler::get_min_delay());
    assert(from < to);

    nest::long_t current_steps = origin.get_steps();

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
            if (t == prev_t) {
                ++simultaneous_transition_count;
                if (simultaneous_transition_count > MAX_SIMULTANEOUS_TRANSITIONS)
                    throw ExceededMaximumSimultaneousTransitions("PyNNLeakyIntegrateAndFire", simultaneous_transition_count, t);
            } else
                simultaneous_transition_count = 0;
            // Execute body of transition, flagging a discontinuity in the ODE system
            // if either the body contains state assignments (i.e. not just output
            // events) or the regime changes
            bool discontinuous = transition->body(t) || (transition->get_target_regime() != B_.current_regime);
            // Update the current regime
            B_.current_regime = transition->get_target_regime();
            // Set all triggers, i.e. activate all triggers for which their trigger condition 
            // evaluates to false.
            B_.current_regime->set_triggers(t);
            // Reinitialise the solve if the is a discontinuity in the ODE system
            if (discontinuous)
                B_.current_regime->init_solver();  // Reset the solver if the transition contains state assignments or switches to a new regime.
        }
        
        /***** Send output events for each event send port *****/
        // FIXME: Need to specify different output ports in a way that can be read by the receiving nodes
        // Output events        
        if (B_.num_spikeoutput_events) {
		    set_spiketime(nest::Time::step(origin.get_steps()+lag+1));
		    nest::SpikeEvent se;
		    se.set_multiplicity(B_.num_spikeoutput_events);
		    network()->send(*this, se, lag); 
        }

        /***** Get analog port values *****/
        B_.i_synaptic_value = B_.i_synaptic_analog_port.get_value(lag);

        /***** Record data *****/
        B_.logger_.record_data(current_steps + lag);
    }
}

/*****************
 * Event Handles *
 *****************/

void PyNNLeakyIntegrateAndFire::handle(nest::SpikeEvent & e) {
    assert(e.get_delay() > 0);
    // Loop through event receive ports
}

void PyNNLeakyIntegrateAndFire::handle(nest::CurrentEvent& e) {
    assert(e.get_delay() > 0);

    const double_t c = e.get_current();
    const double_t w = e.get_weight();    
    // Loop through analog receive ports
    if (e.get_rport() == i_synaptic_ANALOG_PORT) {
        B_.i_synaptic_analog_port.add_value(
            e.get_rel_delivery_steps(network()->get_slice_origin()), w * c);
    }
}

void PyNNLeakyIntegrateAndFire::handle(nest::DataLoggingRequest& e) {
    B_.logger_.handle(e);
}

}  // End 'nineml' namespace
