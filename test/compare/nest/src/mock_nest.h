#ifndef MOCK_NEST_H
#define MOCK_NEST_H

#include <cmath>
#include <vector>
#include <map>
#include <sstream>
#include <algorithm>
#include <cassert>
#include <valarray>
#include "nest_time.h"
#include "nest.h"
#include "mock_sli.h"

#define ARRAY_ALLOC_SIZE 64
#define LONG_MAX  __LONG_MAX__
#define DBL_MAX __DBL_MAX__
#define LDBL_MAX __LDBL_MAX__
#define double_t_max ( DBL_MAX ) // because C++ language designers are apes
#define double_t_min ( DBL_MIN ) // (only integral consts are compile time)


typedef long long_t;
typedef long_t rport;
typedef long_t port;
typedef double_t weight;
typedef long_t delay;

const long_t long_t_max = __LONG_MAX__;
const long_t long_t_min = (-__LONG_MAX__ -1L);
const long_t delay_max = long_t_max;
const long_t delay_min = long_t_min;
const rport invalid_port_ = -1;

typedef long tic_t;
const tic_t tic_t_max = LONG_MAX;
const tic_t tic_t_min = LONG_MIN;

namespace nest {
    class Time;
}

std::ostream& operator<<( std::ostream&, const nest::Time& );
typedef double double_t;


namespace librandom {

    class RngPtr;

    class RandomGen {
      public:
        /**
         * @note All classes derived from RandomGen should
         *       have only a single constructor, taking
         *       an unsigned long as seed value. Use
         *       RandomGen::DefaultSeed if you want to
         *       create a generator with a default seed value.
         */
        RandomGen() {}

        // ensures proper clean up
        virtual ~RandomGen() {}

        /**
         The following functions implement the user interface of the
         RandomGen class. The actual interface to the underlying
         random generator is provided by protected member functions below.
         */
        double drand(void);                    //!< draw from [0, 1)
        double operator()( void ) { return drand(); }                   //!< draw from [0, 1)
        double drandpos(void);                 //!< draw from (0, 1)

        RngPtr create_knuthlfg_rng(const unsigned long seed);

        const static unsigned long DefaultSeed;

    };

    class RngPtr {
      public:

        RngPtr() : rng(new RandomGen()) {}

        RngPtr(RandomGen* rng)
          : rng(rng) {}

        RandomGen* operator->() const {
            return rng;
        }

        RandomGen* operator->() {
            return rng;
        }

        RandomGen& operator*() {
            return *rng;
        }

      protected:
        RandomGen* rng;

    };

}

namespace nest {

    typedef double double_t;
    typedef long long_t;

    namespace names {
        extern const Name receptor_type;
        extern const Name t_spike;
        extern const Name recordables;
        extern const Name receptor_types;
    }



    class Node;
    class Archiving_Node;

    class KernelException: public std::exception {
      public:
        KernelException(const std::string& name) {
        }
    };

    class GSLSolverFailure : public KernelException {
      public:
        GSLSolverFailure(const std::string& name, int status) : KernelException(name) {}
    };

    class UnknownReceptorType: public std::exception {
      public:
        UnknownReceptorType(const port& port, const std::string& name) {
        }
    };

    class IncompatibleReceptorType: public std::exception {
      public:
        IncompatibleReceptorType(const port& port,
                const std::string& name, const std::string& msg) {
        }
    };

    class Scheduler {
      public:
        static double get_min_delay() { return min_delay; }
        static double min_delay;
    };


    class Event {
      public:
        Event() : d_(0), w_(0), rp_(0) {}
        void set_sender(Archiving_Node& node) {}
        double_t get_delay() const { return d_; }
        double get_weight() const { return w_; }
        long_t get_rel_delivery_steps(const Time& time) const;
        int get_rport() const { return rp_; }

        // Public members
        delay d_;
        weight w_;
        int rp_;
    };

    class SpikeEvent : public Event {
      public:
        SpikeEvent() : m_(0) {}
        void set_multiplicity(long_t m) { m_ = m; }
        double_t get_delay() const { return d_; }
        double get_weight() const { return w_; }

        // Public members
        long_t m_;

    };

    class CurrentEvent : public Event {
      public:
        CurrentEvent() : c_(0.0) {}
        double get_current() const { return c_; }

        //Public members
        double c_;

    };

    class DataLoggingRequest {
      public:
        void handle(const SpikeEvent& e) {}
        void handle(const CurrentEvent& e) {}
    };


    template<class NodeType> class RecordablesMap : public std::map< Name, double_t> {
        typedef std::map< Name, double_t> Base_;
      public:
        typedef double_t ( NodeType::*DataAccessFct )() const;

        ArrayDatum get_list() const {
          ArrayDatum recordables;
          for ( typename Base_::const_iterator it = this->begin(); it != this->end(); ++it )
            recordables.push_back( new LiteralDatum( it->first ) );
          return recordables;

          // the entire function should just be
          // return recordables_;
        }
        void create() {}
        void insert_(const char* name, DataAccessFct f) {}
    };

    template<class NodeType> class UniversalDataLogger {
      public:
        UniversalDataLogger(NodeType& node) {}
        port connect_logging_device(DataLoggingRequest& request,
                RecordablesMap<NodeType>& map);
        void init() {}
        void reset() {}
        void record_data(long_t step) {}
        void handle(const DataLoggingRequest& dlr) {}
    };

    class RingBuffer {
      public:
        void add_value(const long_t offs, const double_t);
        void set_value(const long_t offs, const double_t);
        double get_value(const long_t offs);
        void clear();
        void resize();
    };


    class Network {
      public:
        Network();
        ~Network();
        void send(Node& node, SpikeEvent& se, long_t lag) {}
        librandom::RngPtr get_rng(int dummy) { return rng_; }
        const Time& get_slice_origin() const;
        librandom::RngPtr rng_;
    };

    class Node {
      public:
        Node() : net_(new Network()) {}
        virtual ~Node() { delete net_; }
        void handle(SpikeEvent& event);
        void handle(CurrentEvent& event);
        port handles_test_event(nest::SpikeEvent& event, nest::port receptor_type);
        port handles_test_event(nest::CurrentEvent& event, nest::port receptor_type);

        std::string get_name() { return "TestNode"; }
        void set_spiketime(Time const& t_sp ) {}
        int get_thread() const { return 0; }

        template < typename ConcreteNode > const ConcreteNode& downcast( const Node& n ) {
          ConcreteNode const* tp = dynamic_cast< ConcreteNode const* >( &n );
          assert( tp != 0 );
          return *tp;
        }

        Network* network() { return net_; }

      protected:
        Network *net_;

    };

    class Archiving_Node: public Node {
      public:
        Archiving_Node() : last_spike_(-1.0) {}
        virtual ~Archiving_Node() {}
        virtual void get_status(DictionaryDatum& d) const = 0;
        virtual void set_status(const DictionaryDatum& d) = 0;
        double_t get_spiketime_ms() const { return last_spike_; }
        void set_spiketime_ms(double_t st) { last_spike_ = st; }
        void clear_history() {}

        double_t last_spike_;

    };

}


#endif
