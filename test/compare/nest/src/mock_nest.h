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
#include "arraydatum.h"

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

        static RngPtr create_knuthlfg_rng(const unsigned long seed);

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

    class KnuthLFG : public RandomGen
    {
    public:
      //! Create generator with given seed
      explicit KnuthLFG( unsigned long );

      ~KnuthLFG(){};

      RngPtr
      clone( unsigned long s )
      {
        return RngPtr( new KnuthLFG( s ) );
      }

    private:
      //! implements seeding for RandomGen
      void seed_( unsigned long );

      //! implements drawing a single [0,1) number for RandomGen
      double drand_();

    private:
      static const long KK_;          //!< the long lag
      static const long LL_;          //!< the short lag
      static const long MM_;          //!< the modulus
      static const long TT_;          //!< guaranteed separation between streams
      static const long QUALITY_;     //!< number of RNGs to fill for each cycle
      static const double I2DFactor_; //!< int to double factor

      static long mod_diff_( long, long ); //!< subtraction module MM
      static bool is_odd_( long );

      std::vector< long > ran_x_;                     //!< the generator state
      std::vector< long > ran_buffer_;                //!< generated numbers, 0..KK-1 are shipped
      const std::vector< long >::const_iterator end_; //!< marker past last to deliver
      std::vector< long >::const_iterator next_;      //!< next number to deliver

      /**
       * Generates numbers, refilling buffer.
       * @note Buffer must be passed as argument, since ran_start_() and
       *       self_test_() must pass other buffers than ran_buffer_.
       */
      void ran_array_( std::vector< long >& rbuff );
      void ran_start_( long seed ); //!< initializes buffer
      long ran_draw_();             //!< deliver integer random number from ran_buffer_

      /**
       * Perform minimal self-test given by Knuth.
       * The test will break an assertion if it fails. This is acceptable,
       * since failure indicates either lack of two's complement arithmetic
       * or problems with the size of data types.
       */
      void self_test_();
    };

    inline void
    KnuthLFG::seed_( unsigned long seed )
    {
      ran_start_( seed );
    }


    inline double
    KnuthLFG::drand_()
    {
      return I2DFactor_ * ran_draw_();
    }


    inline long
    KnuthLFG::mod_diff_( long x, long y )
    {
      // modulo computation assumes two's complement
      return ( x - y ) & ( MM_ - 1 );
    }

    inline bool
    KnuthLFG::is_odd_( long x )
    {
      return x & 1;
    }

    inline long
    KnuthLFG::ran_draw_()
    {
      if ( next_ == end_ )
      {
        ran_array_( ran_buffer_ ); // refill
        next_ = ran_buffer_.begin();
      }

      return *next_++; // return next and increment
    }


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
        static delay get_min_delay() { return min_delay; }
        static delay min_delay;
        static delay max_delay;
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


    template <class NodeType> class RecordablesMap : public std::map< Name, double_t (NodeType::*) () const> {
        typedef std::map< Name,  double_t (NodeType::*) () const> Base_;
      public:
        typedef double_t ( NodeType::*DataAccessFct )() const;
        virtual ~RecordablesMap() {}
        ArrayDatum get_list() const {
          ArrayDatum recordables;
          for ( typename Base_::const_iterator it = this->begin(); it != this->end(); ++it )
            recordables.push_back( new LiteralDatum( it->first ) );
          return recordables;

          // the entire function should just be
          // return recordables_;
        }
        void create() {}
        void insert_(const Name& n, const DataAccessFct f) {
            Base_::insert(std::make_pair(n, f));
        }
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
        RingBuffer();

        void add_value( const long_t offs, const double_t );
        void set_value( const long_t offs, const double_t );
        double get_value( const long_t offs );
        void clear();
        void resize();
        size_t size() const {
          return buffer_.size();
        }

        static delay get_modulo( delay d );

    private:
      //! Buffered data
      std::valarray< double_t > buffer_;

      /**
       * Obtain buffer index.
       * @param delay delivery delay for event
       * @returns index to buffer element into which event should be
       * recorded.
       */
      size_t get_index_( const delay d ) const;
    };


    class Network {
      public:
        Network();
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