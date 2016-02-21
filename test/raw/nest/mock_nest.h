#ifndef MOCK_NEST_H
#define MOCK_NEST_H

#include <cmath>
#include <vector>
#include <map>
#include <sstream>
#include <algorithm>
#include "name.h"


const Name DOUBLE_TYPE("double");
const Name LONG_TYPE("long");
const Name DICTIONARY_TYPE("dictionary");

class Datum {

  public:

    Datum(const Name* t) :
            type(t) {
    }

    Datum(const Datum& d) :
            type(d.type) {
    }

    virtual ~Datum() {
    }

    virtual Datum* clone() const = 0;

    virtual bool equals( const Datum* d ) const {
        return this == d;
    }

  protected:
    // Putting the following variables here, avoids a number of virtual
    // functions.

    const Name* type;       //!< Pointer to type object.

};

class Token {
  friend class Datum;

  private:
    Datum* p;

  public:
    ~Token() {
        delete p;
    }

    Token(const Token& t) :
            p( NULL) {
        if (t.p)
            p = t.p->clone();
    }

    Token(Datum* d = NULL) //!< use existing pointer to datum, token takes responsibility of the pointer.
    :
            p(d) {
    }

    Token(const Datum& d) //!< copy datum object and store its pointer.
            {
        p = d.clone();
    }

    Token(int);
    Token(unsigned int);
    Token(long);
    Token(bool);
    Token(unsigned long);
    Token(double);
    Token(const char*);
    Token(std::string);
    Token(const std::vector<double>&);
    Token(const std::vector<long>&);
    Token(const std::vector<size_t>&);
    Token(const std::ostream&);
    Token(const std::istream&);
    operator Datum*() const;
    operator size_t() const;
    operator long() const;
    operator double() const;
    operator float() const;
    operator bool() const;
    operator std::string() const;
    //  operator vector<double> const;
    //  operator vector<long> const;

    void clear(void) {
        delete p;
        p = NULL;
    }

    bool empty(void) const {
        return p == NULL;
    }

    bool operator!(void) const {
        return p == NULL;
    }

    Datum* datum(void) const {
        return p;
    }

    bool valid() const {
        return !empty();
    }

    Datum* operator->() const {
        //      assert(p!= NULL);
        return p;
    }

    Datum& operator*() const {
        //      assert(p != NULL);
        return *p;
    }

    Token& operator=(const Token& t) {
        if (t.p != p) {
            if (t.p == NULL)
                clear();
            else
                p = t.p->clone();
        }
        return *this;
    }

    Token& operator=(Datum* p_s) {
        if (p != p_s) {
            clear();
            p = p_s->clone();
        }

        return *this;
    }

    bool operator==(const Token& t) const {
        if (p == t.p)
            return true;

        return p and p->equals(t.p);
    }

    // define != explicitly --- HEP 2001-08-09
    bool operator!=(const Token& t) const {
        return !(*this == t);
    }

};


class Dictionary {
  public:

    const Token& operator[](const Name&) const;
    Token& operator[](const Name&);

    const Token& operator[](const char*) const;
    Token& operator[](const char*);

    Token& insert(const Name& n, const Token& t);
    Token& insert_move(const Name&, Token&);
    const Token& lookup(const Name& n) const;
};


class DictionaryDatum: public Datum {
  public:

    DictionaryDatum(Dictionary* dict) :
            Datum(&DICTIONARY_TYPE), dict(dict) {
    }

    Dictionary* operator->() const {
        return dict;
    }

    Dictionary* operator->() {
        return dict;
    }

    Dictionary& operator*() {
        return *dict;
    }

    Datum* clone() const {
        return new DictionaryDatum(dict);
    }

  protected:
    Dictionary* dict;
};

class DoubleDatum : public Datum {
  public:

    DoubleDatum(double dbl)
      : Datum(&DOUBLE_TYPE), dbl(dbl) {
      }

    const double* operator->() const {
        return &dbl;
    }

    double* operator->() {
        return &dbl;
    }

    double operator*() {
        return dbl;
    }

    Datum* clone() const {
        return new DoubleDatum(dbl);
    }

    double get() const {
        return dbl;
    }

  protected:
    double dbl;

};

class IntegerDatum : public Datum {
  public:

    IntegerDatum(long lng)
      : Datum(&LONG_TYPE), lng(lng) {
      }

    const long* operator->() const {
        return &lng;
    }

    long* operator->() {
        return &lng;
    }

    long& operator*() {
        return lng;
    }

    Datum* clone() const {
      return new IntegerDatum(lng);
    }

    long get() const {
        return lng;
    }

  protected:
    long lng;

};

template<typename FT> void def(DictionaryDatum& d, Name const n, FT const& value) {
    Token t(value); // we hope that we have a constructor for this.
    d->insert_move(n, t);
}

template < typename FT > FT getValue( const Token& t ) {
  FT* value = dynamic_cast< FT* >( t.datum() );
  if ( value == NULL )
      throw std::exception();
  return *value;
}

template < typename FT > void setValue( const Token& t, FT const& value ) {
  FT* old = dynamic_cast< FT* >( t.datum() );
  if ( value == NULL )
      throw std::exception();
  *old = value;
}

template < typename FT > Token newToken( FT const& value );

template <> double getValue< double >( const Token& t ) {
    DoubleDatum* id = dynamic_cast< DoubleDatum* >( t.datum() );
    if ( id == NULL )
        throw std::exception();
    return id->get();
}
template <> void setValue< double >( const Token& t, double const& value ) {
    DoubleDatum* id = dynamic_cast< DoubleDatum* >( t.datum() );
    if ( id == NULL )
        throw std::exception();
    (*id) = value;
}


template <> long getValue< long >( const Token& t ) {
  const IntegerDatum* id = dynamic_cast< const IntegerDatum* >( t.datum() );
  if ( id == NULL )
    throw std::exception();
  return id->get();
}
template <> void setValue< long >( const Token& t, long const& value ) {
    IntegerDatum* id = dynamic_cast< IntegerDatum* >( t.datum() );
    if ( id == NULL )
        throw std::exception();
    (*id) = value;
}

template <> Token newToken< long >( long const& value ) {
    return Token( new IntegerDatum( value ) );
}


template <> Token newToken< double >( double const& value ) {
    return Token( new DoubleDatum( value ) );
}

template < typename FT, typename VT > bool updateValue( DictionaryDatum const& d, Name const n, VT& value ) {
  // We will test for the name, and do nothing if it does not exist,
  // instead of simply trying to getValue() it and catching a possible
  // exception. The latter works, however, but non-existing names are
  // the rule with updateValue(), not the exception, hence using the
  // exception mechanism would be inappropriate. (Markus pointed this
  // out, 05.02.2001, Ruediger.)

  // We must take a reference, so that access information can be stored in the
  // token.
  const Token& t = d->lookup( n );

  if ( t.empty() )
    return false;

  value = getValue< FT >( t );
  return true;
}

typedef double double_t;


namespace librandom {

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

    typedef double delay;

    namespace names {
        extern const Name receptor_type;
        extern const Name t_spike;
        extern const Name recordables;
        extern const Name receptor_types;
    }

    typedef int synindex;
    typedef long long_t;
    typedef int port;

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

    class Time {

      public:
        Time(double_t ms) :
                ms_(ms) {
        }
        static double_t ms(double t);
        double get_ms() const {
            return ms_;
        }

        static Time get_resolution() {
            return Time(resolution);
        }

        static double_t step(long_t step) { return (double_t)step * resolution; }
        long_t get_steps() const { return 1; }

      protected:
        double_t ms_;
        static double resolution;

    };

    class SpikeEvent {
      public:
        void set_sender(Archiving_Node& node) {}
        void set_multiplicity(long_t m) {}
        double_t get_delay() const;
        double get_current() const;
        double get_weight() const;

    };

    class CurrentEvent {
      public:
        double_t get_delay() const;
        double get_current() const;
        double get_weight() const;
        int get_rel_delivery_steps(const Time& time) const;
        int get_rport() const;
    };

    class DataLoggingRequest {
      public:
        void handle(const SpikeEvent& e) {}
        void handle(const CurrentEvent& e) {}
    };


    template<class NodeType> class RecordablesMap {
      public:
        typedef double_t ( NodeType::*DataAccessFct )() const;

        Token get_list();
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
        void send(Node& node, SpikeEvent& se, long_t lag) {}
        librandom::RngPtr get_rng(int dummy);
        Time get_slice_origin();
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
        void set_spiketime(double t) {}
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
        virtual ~Archiving_Node() {}
        virtual void get_status(DictionaryDatum& d) const = 0;
        virtual void set_status(const DictionaryDatum& d) = 0;
        double_t get_spiketime_ms() const;
        void clear_history() {}

    };

}

#endif
