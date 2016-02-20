#ifndef MOCK_NEST_H
#define MOCK_NEST_H

#include <cmath>
#include <vector>
#include <map>
#include "name.h"

const Name DOUBLE_TYPE;
const Name LONG_TYPE;
const Name DICTIONARY_TYPE;

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

    DoubleDatum(double* dbl)
      : Datum(&DOUBLE_TYPE), dbl(dbl) {
      }

      double* operator->() const {
          return dbl;
      }

      double* operator->() {
          return dbl;
      }

      double& operator*() {
          return *dbl;
      }

      Datum* clone() const {
          return new DoubleDatum(dbl);
      }

    protected:
      double* dbl;

};

class LongDatum : public Datum {
  public:

    LongDatum(long* lng)
      : Datum(&LONG_TYPE), lng(lng) {
      }

    long* operator->() const {
          return lng;
      }

    long* operator->() {
          return lng;
      }

    long& operator*() {
          return *lng;
      }

      Datum* clone() const {
          return new LongDatum(lng);
      }

  protected:
    long* lng;

};

template<typename FT>
void def(DictionaryDatum& d, Name const n, FT const& value) {
    Token t(value); // we hope that we have a constructor for this.
    d->insert_move(n, t);
}

typedef double double_t;

namespace nest {

    namespace names {
        extern const Name receptor_type;
        extern const Name t_spike;
        extern const Name recordables;
        extern const Name receptor_types;
    }

    typedef int synindex;
    typedef long long_t;
    typedef int port;

    class Archiving_Node;

    class KernelException: public std::exception {
      public:
        KernelException(const std::string& name) {
        }
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

    class DataLoggingRequest {

    };

    class Time {

      public:
        Time(double_t ms) :
                ms_(ms) {
        }
        static double_t ms(double t);

      protected:
        double_t ms_;

    };

    class SpikeEvent {
      public:
        void set_sender(Archiving_Node& node);
    };

    class CurrentEvent {

    };

    template<class NodeType> class RecordablesMap {
      public:
        Token get_list();
    };

    template<class NodeType> class UniversalDataLogger {
      public:
        port connect_logging_device(DataLoggingRequest& request,
                RecordablesMap<NodeType>& map);
    };

    class RingBuffer {
      public:
        void add_value(const long_t offs, const double_t);
        void set_value(const long_t offs, const double_t);
        double get_value(const long_t offs);
        void clear();
        void resize();
    };

    class Node {
      public:
        void handle(SpikeEvent& event);
        void handle(CurrentEvent& event);
        port handles_test_event(nest::SpikeEvent& event,
                nest::port receptor_type);
        port handles_test_event(nest::CurrentEvent& event,
                nest::port receptor_type);
        std::string get_name() {
            return "TestNode";
        }

        template < typename ConcreteNode > const ConcreteNode& downcast( const Node& n ) {
          ConcreteNode const* tp = dynamic_cast< ConcreteNode const* >( &n );
          assert( tp != 0 );
          return *tp;
        }

    };

    class Archiving_Node: public Node {
      public:
        void get_status(DictionaryDatum& d) const;
        void set_status(const DictionaryDatum& d);
        double_t get_spiketime_ms() const;

    };

}

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
        RandomGen() {
        }
        ;

        // ensures proper clean up
        virtual ~RandomGen() {
        }
        ;

        /**
         The following functions implement the user interface of the
         RandomGen class. The actual interface to the underlying
         random generator is provided by protected member functions below.
         */
        double drand(void);                    //!< draw from [0, 1)
//      double operator()( void );                   //!< draw from [0, 1)
        double drandpos(void);                 //!< draw from (0, 1)
//      unsigned long ulrand( const unsigned long ); //!< draw from [0, n-1]

//      void seed( const unsigned long ); //!< set random seed to a new value
//
//      /**
//       * Create built-in Knuth Lagged Fibonacci random generator.
//       * This function is provided so that RNGs can be created in places
//       * where the SLI rngdict is not accessible.
//       * @see KnuthLFG
//       */
//      static RngPtr create_knuthlfg_rng( unsigned long );
//
//      //! Default value for seeding generators in places where no seed is supplied.
//      static const unsigned long DefaultSeed;
//
//      //! clone a random number generator of same type initialized with given seed
//      virtual RngPtr clone( const unsigned long ) = 0;

    };

    class RngPtr {
      public:

        RngPtr(RandomGen* rng) :
                rng(rng) {
        }

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

#endif
