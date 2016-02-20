/* This file was generated by PyPe9 version 0.1 on Thu 11 Feb 16 11:18:06PM */

#ifndef IZHIKEVICHBRANCH_H
#define IZHIKEVICHBRANCH_H

//#include "nest.h"
//#include "event.h"
////#include "node.h"
//#include "archiving_node.h"
//#include "ring_buffer.h"
//#include "connection.h"
//#include "universal_data_logger.h"
//#include "recordables_map.h"
//#include "exceptions.h"

#include "mock_nest.h"

#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_sf_exp.h>
#include <gsl/gsl_odeiv2.h>

#define ITEM(v,i)  (v[i])
namespace nineml {

    class ExceededMaximumSimultaneousTransitions : public nest::KernelException {
    
      public:
        ExceededMaximumSimultaneousTransitions(const std::string& model, int num_transitions, double t)
          : KernelException("ExceededMaximumSimultaneousTransitions"), model(model), num_transitions(num_transitions), t(t) {}
        ~ExceededMaximumSimultaneousTransitions() throw () {}
        std::string message();
      protected:
         const std::string& model;
         int num_transitions;
         double t;
    };
    


    class IzhikevichBranch;

    /**
     * Create a typedef for the function that represents the system of ODEs
     */ 
    typedef int (*dynamics_function_type)(double t, const double y_[], double f_[], void* pnode_);

    /**
     * Declaration of dynamics and residual signatures
     */
    extern "C" int IzhikevichBranch_subthreshold_regime_dynamics(double t, const double y_[], double f_[], void* pnode_);
    extern "C" int IzhikevichBranch_subthreshold_regime_jacobian(double t, const double y[], double *dfdy, double dfdt[], void* node);
    class IzhikevichBranch : public nest::Archiving_Node {

      public:

        static const int MAX_SIMULTANEOUS_TRANSITIONS = 1000;

        class Regime_;
        class Transition_;
        class OnEvent_;
        class OnCondition_;
        class subthreshold_regimeOnCondition0;
      

        ~IzhikevichBranch();
	    IzhikevichBranch(const IzhikevichBranch &);
	    IzhikevichBranch();

	    /**
	     * Import sets of overloaded virtual functions.
	     * This is necessary to ensure proper overload and overriding resolution.
	     * @see http://www.gotw.ca/gotw/005.htm.
	     */
	    using nest::Node::handle;
	    using nest::Node::handles_test_event;

	    nest::port send_test_event(nest::Node&, nest::port, nest::synindex, bool);

	    void handle(nest::SpikeEvent &);
	    void handle(nest::CurrentEvent &);
	    void handle(nest::DataLoggingRequest &);

	    nest::port handles_test_event(nest::SpikeEvent &, nest::port);
	    nest::port handles_test_event(nest::CurrentEvent &, nest::port);
	    nest::port handles_test_event(nest::DataLoggingRequest &, nest::port);

	    void get_status(DictionaryDatum &) const;
	    void set_status(const DictionaryDatum &);

	    void init_node_(const nest::Node& proto);
	    void init_state_(const nest::Node& proto);
	    void init_buffers_();
	    void calibrate();
	    Regime_* get_regime(const std::string& regime_name);
	    
	    void refresh_events(const nest::long_t& lag);
	    
        /* Inline random distribution methods */
        double random_uniform_(double low, double high);
        double random_normal_(double mu, double sigma);
        double random_exponential_(double lambda); 

	    void update(nest::Time const &, const nest::long_t, const nest::long_t);

    // Set dynamics methods (the ones that actually model the dynamics) as friends
	    friend int IzhikevichBranch_subthreshold_regime_dynamics(double t, const double y_[], double f_[], void* pnode_);


	    /* Event port ids
	     * @note Start with 1 so we can forbid port 0 to avoid accidental
	     *     creation of connections with no receptor type set.
	     */
	    static const nest::port MIN_EVENT_PORT_ = 1;
	    enum EventPorts {
	        SUP_EVENT_PORT_
	    };

	    // On event ids
	    enum OnEvents {
	        SUP_ON_EVENT_
	    };

	    //Analog port ids
	    static const nest::port MIN_ANALOG_PORT_ = 1;
	    enum AnalogPorts {
            Isyn_ANALOG_PORT = MIN_ANALOG_PORT_,
            SUP_ANALOG_PORT_
        };

        // Synaptic event function definitions

	    // The next two classes need to be friends to access the State_ class/member
	    friend class nest::RecordablesMap<IzhikevichBranch>;
	    friend class nest::UniversalDataLogger<IzhikevichBranch>;

        struct Parameters_ {
            double a;
            double c;
            double b;
            double d;
            double C_m;
            double beta;
            double theta;
            double alpha;
            double zeta;
	        Parameters_();
	        void get(DictionaryDatum&) const;
	        void set(const DictionaryDatum&);
	    }; // end struct Parameters_

	    struct State_ {

            enum StateVecElems {
                U_INDEX = 0,
                V_INDEX,
                STATE_VEC_SIZE_
            };

            double y_[STATE_VEC_SIZE_];

	        State_(const Parameters_& p);
	        State_(const State_& s);
	        State_& operator=(const State_& s);
	        void get(DictionaryDatum&) const;
	        void set(const DictionaryDatum&, const Parameters_&);
	    }; // end struct State_

        struct Variables_ {
		    librandom::RngPtr rng_;           // random number generator of thread
        };

        struct Buffers_ {
	        Buffers_(IzhikevichBranch&);
	        Buffers_(const Buffers_&, IzhikevichBranch&);
	        nest::UniversalDataLogger<IzhikevichBranch> logger_;

	        // Timesteps
	        double_t step_;       //!< step size in ms

	        // Event receive port buffers

            int num_spike_events;

            // Analog receive port buffers
            nest::RingBuffer Isyn_analog_port;

            // Variables to hold the last value of the analog receive port buffers
            double_t Isyn_value;

            Regime_* current_regime;

	    }; // end struct Buffers_
	    
	    class Regime_ {
	     
	      public:
	        Regime_(IzhikevichBranch* cell, dynamics_function_type dynamics_function)
	          : cell(cell), dynamics_function(dynamics_function) {}
	        virtual ~Regime_();    
	        dynamics_function_type get_dynamics_function();
	        Transition_* transition(nest::Time const & origin, const nest::long_t& lag);
	        void set_triggers(double t);
	        virtual void init_solver() = 0;
	        virtual void step_ode() = 0;
	        
	       
	      protected:
	        IzhikevichBranch* cell;
	        dynamics_function_type dynamics_function;
            std::vector<OnCondition_*> on_conditions;
            std::vector<OnEvent_*> on_events;
            std::vector<OnCondition_*> active_on_conditions;
           
          friend class IzhikevichBranch;
          friend class Transition_;
          friend class OnEvent_;
          friend class OnCondition_;
          friend class subthreshold_regimeOnCondition0;
         
	    
	    };
	    
        /*
         * Create a specific class for each regime in order to override the 
         * default constructor and initialise its transitions
         */
        class subthreshold_regimeRegime_ : public Regime_ {
            
          public:
            subthreshold_regimeRegime_(IzhikevichBranch* cell);
            virtual ~subthreshold_regimeRegime_();
            virtual void init_solver();
            virtual void step_ode();
            
          protected:
            // Structures required by the solver
            double   IntegrationStep_;//!< current integration time step, updated by solver
	        gsl_odeiv2_step*  s_;  //!< stepping function
	        gsl_odeiv2_control* c_;  //!< adaptive stepsize control function
	        gsl_odeiv2_evolve*  e_;  //!< evolution function
	        gsl_odeiv2_system   sys_;  //!< struct describing system
            unsigned int N;  // size of state vector used by Jacobian
            double *u, *jac;  // intermediate state vectors used for Jacobian approximation	            

          friend int IzhikevichBranch_subthreshold_regime_jacobian(double t, const double y[], double *dfdy, double dfdt[], void* node);
        };
	    
	    
	    /**
	     * Set up an abstract base class to define a common interface for all
	     * transitions (both OnEvent and OnCondition).
	     */
	    class Transition_ {

	      public:
	        Transition_(Regime_* regime, const std::string& target_regime_name)
	          : regime(regime), target_regime(NULL), target_regime_name(target_regime_name) {}
	        virtual ~Transition_() {}
            void set_target_regime(std::map<std::string, Regime_*>& regimes);
            Regime_* get_target_regime();	        
	        virtual double time_occurred(nest::Time const & origin, const nest::long_t& lag) = 0;
	        virtual bool body(double t) = 0;
	        
            /* Inline random distribution methods */
	        double random_uniform_(double low, double high);
	        double random_normal_(double mu, double sigma);
	        double random_exponential_(double lambda);   

	      protected:
	        Regime_* regime;
	        Regime_* target_regime;
	        std::string target_regime_name;
	    };
	    
	    
	    /**
	     * The base OnEvent class from which all OnEvent classes are derived
	     */
	    class OnEvent_ : public Transition_ {
	    
	      public:
	        OnEvent_(Regime_* regime, const std::string& target_regime_name) : Transition_(regime, target_regime_name) {}
            virtual ~OnEvent_() {}
            virtual bool received(nest::Time const & origin, const nest::long_t& lag) = 0;
	    
	    };

        /**
         * The base OnCondition class from which all OnCondition classes are derived
         */
	    class OnCondition_ : public Transition_ {
	      public:
	        OnCondition_(Regime_* regime, const std::string& target_regime_name) : Transition_(regime, target_regime_name) {}
	        virtual ~OnCondition_() {}
            virtual bool condition(double t) = 0;
	    };
	    
	    /*
	     * Create a specific class for each OnEvent and OnCondition that will
	     * specify its trigger condition, state assignments and output events
	     */
        class subthreshold_regimeOnCondition0 : public OnCondition_ {

          public:
            subthreshold_regimeOnCondition0(Regime_* regime, const std::string& target_regime_name) : OnCondition_(regime, target_regime_name) {}
            virtual ~subthreshold_regimeOnCondition0() {}
            virtual bool condition(double t);
            virtual double time_occurred(nest::Time const & origin, const nest::long_t& lag);
            virtual bool body(double t);
     
        };


		template <State_::StateVecElems elem>
		double_t get_y_elem_() const { return S_.y_[elem]; }

		Parameters_ P_;
		State_      S_;
		Variables_  V_;
		Buffers_    B_;

	    //! Mapping of recordables names to access functions	
		static nest::RecordablesMap<IzhikevichBranch> recordablesMap_;
		
	  protected:
	    void construct_regimes();
        std::map<std::string, Regime_*> regimes;		
    
	}; // end class IzhikevichBranch
	
	inline IzhikevichBranch::Regime_* IzhikevichBranch::get_regime(const std::string& regime_name) {
	   return regimes[regime_name];
	}
	
	inline dynamics_function_type IzhikevichBranch::Regime_::get_dynamics_function() {
	    return this->dynamics_function;
    }

    inline void IzhikevichBranch::Transition_::set_target_regime(std::map<std::string, IzhikevichBranch::Regime_*>& regimes) {
        this->target_regime = regimes[this->target_regime_name];   
    }

    inline IzhikevichBranch::Regime_* IzhikevichBranch::Transition_::get_target_regime() {
        return this->target_regime;   
    }

    inline nest::port IzhikevichBranch::send_test_event(nest::Node& target, nest::port receptor_type, nest::synindex, bool) {
		nest::SpikeEvent e;
		e.set_sender(*this);
		return target.handles_test_event(e, receptor_type);
    }

    inline nest::port IzhikevichBranch::handles_test_event(nest::SpikeEvent&, nest::port receptor_type) {
	    if (receptor_type < 0 || receptor_type >= SUP_EVENT_PORT_)
            throw nest::UnknownReceptorType(receptor_type, this->get_name());
        else if (receptor_type < MIN_EVENT_PORT_)
            throw nest::IncompatibleReceptorType(receptor_type, this->get_name(), "SpikeEvent");
		return receptor_type;
    }

    inline nest::port IzhikevichBranch::handles_test_event(nest::CurrentEvent&, nest::port receptor_type) {
		if (receptor_type < 0 || receptor_type >= SUP_ANALOG_PORT_)
		    throw nest::UnknownReceptorType(receptor_type, this->get_name());
		else if (receptor_type < MIN_ANALOG_PORT_)
		    throw nest::IncompatibleReceptorType(receptor_type, this->get_name(), "SpikeEvent");
	    return receptor_type;
	}

	inline nest::port IzhikevichBranch::handles_test_event(nest::DataLoggingRequest& dlr, nest::port receptor_type) {
	    if (receptor_type != 0)
            throw nest::UnknownReceptorType(receptor_type, this->get_name());
		return B_.logger_.connect_logging_device( dlr, recordablesMap_ );
    }

    inline void IzhikevichBranch::get_status(DictionaryDatum &d) const {
		P_.get(d);
		S_.get(d);
		nest::Archiving_Node::get_status(d);
		(*d)[nest::names::recordables] = recordablesMap_.get_list();
		def<double_t>(d, nest::names::t_spike, get_spiketime_ms());
		DictionaryDatum receptor_dict_ = new Dictionary();
		// Synaptic event dictionary
        (*receptor_dict_)[Name("Isyn")]  = Isyn_ANALOG_PORT;
        (*d)[nest::names::receptor_types] = receptor_dict_;
    }

    inline void IzhikevichBranch::set_status(const DictionaryDatum &d) {
	    Parameters_ ptmp = P_;  // temporary copy in case of errors
	    ptmp.set(d);             // throws if BadProperty
	    State_    stmp = S_;  // temporary copy in case of errors
	    stmp.set(d, ptmp);         // throws if BadProperty
	    // We now know that (ptmp, stmp) are consistent. We do not
	    // write them back to (P_, S_) before we are also sure that
		// the properties to be set in the parent class are internally
		// consistent.
		nest::Archiving_Node::set_status(d);
		// if we get here, temporaries contain consistent set of properties
		P_ = ptmp;
		S_ = stmp;	
	    calibrate();
    }
    
    /* Inline random distributions (for deprecated format random.*), copied
       from the corresponding NEST random deviate implementations in librandom
       but stripped from RandomDeviate boiler plate */
    
    inline double IzhikevichBranch::random_uniform_(double low, double high) {
        return low + (high - low) * V_.rng_->drand();
    }

    inline double IzhikevichBranch::random_normal_(double mu, double sigma) {
        // Box-Muller algorithm, see Knuth TAOCP, vol 2, 3rd ed, p 122
        // we waste one number
        double V1;
        double V2;
        double S;

        do {
            V1 = 2 * V_.rng_->drand() - 1;
            V2 = 2 * V_.rng_->drand() - 1;
            S = V1 * V1 + V2 * V2;
        } while ( S >= 1 );

        if ( S != 0 )
            S = V1 * std::sqrt( -2 * std::log( S ) / S );
        return mu + sigma * S;
    }
    
    inline double IzhikevichBranch::random_exponential_(double lambda) {
        return -std::log(V_.rng_->drandpos()) / lambda;
    }
    
    
    inline double IzhikevichBranch::Transition_::random_uniform_(double low, double high) {
        return low + (high - low) * this->regime->cell->V_.rng_->drand();
    }

    inline double IzhikevichBranch::Transition_::random_normal_(double mu, double sigma) {
        // Box-Muller algorithm, see Knuth TAOCP, vol 2, 3rd ed, p 122
        // we waste one number
        double V1;
        double V2;
        double S;

        do {
            V1 = 2 * this->regime->cell->V_.rng_->drand() - 1;
            V2 = 2 * this->regime->cell->V_.rng_->drand() - 1;
            S = V1 * V1 + V2 * V2;
        } while ( S >= 1 );

        if ( S != 0 )
            S = V1 * std::sqrt( -2 * std::log( S ) / S );
        return mu + sigma * S;
    }
    
    inline double IzhikevichBranch::Transition_::random_exponential_(double lambda) {
        return -std::log(this->regime->cell->V_.rng_->drandpos()) / lambda;
    }
    

} // end namespace nineml

#endif // IZHIKEVICHBRANCH_H