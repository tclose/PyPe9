#include "mock_nest.h"
#include "nest_time.h"

#include <iostream>
#include <iomanip>
#include <vector>

const Name receptor_type( "receptor_type" );
const Name receptor_types( "receptor_types" );
const Name recordables( "recordables" );
const Name t_spike( "t_spike" );

const unsigned long librandom::RandomGen::DefaultSeed = 0xd37ca59fUL;

double min_delay = 0.1;
double max_delay = 1000.0;
unsigned int moduli_size = 100;

void nest::RingBuffer::add_value( const long_t offs, const double_t v ) {
  buffer_[ get_index_( offs ) ] += v;
}

void nest::RingBuffer::set_value( const long_t offs, const double_t v ) {
  buffer_[ get_index_( offs ) ] = v;
}

double nest::RingBuffer::get_value( const long_t offs ) {
  assert( 0 <= offs && ( size_t ) offs < buffer_.size() );
  assert( ( delay ) offs < min_delay );

  // offs == 0 is beginning of slice, but we have to
  // take modulo into account when indexing
  long_t idx = get_index_( offs );
  double_t val = buffer_[ idx ];
  buffer_[ idx ] = 0.0; // clear buffer after reading
  return val;
}

size_t nest::RingBuffer::get_index_( const delay d ) const {
  const long_t idx = get_modulo( d );
  assert( 0 <= idx );
  assert( ( size_t ) idx < buffer_.size() );
  return idx;
}

delay nest::RingBuffer::get_modulo( delay d ) {

  // Note, here d may be 0, since bin 0 represents the "current" time
  // when all evens due are read out.

  // This is usually read from the moduli_ buffer but we don't care about that
  // as we will only have the time "slice"
  return d;
}

nest::RingBuffer::RingBuffer()
  : buffer_( 0.0, min_delay + max_delay ) {}

void nest::RingBuffer::resize() {
  size_t size = min_delay + max_delay;
  if ( buffer_.size() != size )
  {
    buffer_.resize( size );
    buffer_ = 0.0;
  }
}

void nest::RingBuffer::clear() {
  resize();      // does nothing if size is fine
  buffer_ = 0.0; // clear all elements
}

void nest::Archiving_Node::set_status( const DictionaryDatum& d ) {
  // We need to preserve values in case invalid values are set
  double_t new_tau_minus = tau_minus_;
  double_t new_tau_minus_triplet = tau_minus_triplet_;
  updateValue< double_t >( d, names::tau_minus, new_tau_minus );
  updateValue< double_t >( d, names::tau_minus_triplet, new_tau_minus_triplet );

  if ( new_tau_minus <= 0 || new_tau_minus_triplet <= 0 )
    throw BadProperty( "All time constants must be strictly positive." );

  tau_minus_ = new_tau_minus;
  tau_minus_triplet_ = new_tau_minus_triplet;

  // check, if to clear spike history and K_minus
  bool clear = false;
  updateValue< bool >( d, names::clear, clear );
  if ( clear )
    clear_history();
}

nest::Time const& nest::Network::get_slice_origin() const {
  return TimeZero;
}

nest::Network::Network() {
    rng_ = librandom::RandomGen::create_knuthlfg_rng(librandom::RandomGen::DefaultSeed);
}

nest::Network:~Network{
    delete rng_;
}

librandom::RandomGen::create_knuthlfg_rng( unsigned long seed ) {
  return librandom::RngPtr( new librandom::KnuthLFG( seed ) );
}

inline long_t nest::Event::get_rel_delivery_steps( const nest::Time& t ) const
{
  return d_ - 1 - t.get_steps();
}

void nest::Archiving_Node::get_status( DictionaryDatum& d ) const {
  def< double >( d, names::t_spike, get_spiketime_ms() );
  def< double >( d, names::tau_minus, tau_minus_ );
  def< double >( d, names::tau_minus_triplet, tau_minus_triplet_ );
}
