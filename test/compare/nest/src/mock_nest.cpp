#include "mock_nest.h"
#include "nest_time.h"

#include <iostream>
#include <iomanip>

const Name receptor_type( "receptor_type" );
const Name receptor_types( "receptor_types" );
const Name recordables( "recordables" );
const Name t_spike( "t_spike" );

const unsigned long librandom::RandomGen::DefaultSeed = 0xd37ca59fUL;

double min_delay = 0.1;
void nest::RingBuffer::clear()
{
  resize();      // does nothing if size is fine
  buffer_ = 0.0; // clear all elements
}

void nest::RingBuffer::add_value( const long_t offs, const double_t v )
{
 buffer_[ get_index_( offs ) ] += v;
}

double nest::RingBuffer::get_value( const long_t offs ) {
  assert( 0 <= offs && ( size_t ) offs < buffer_.size() );
  assert( ( delay ) offs < Scheduler::get_min_delay() );

  // offs == 0 is beginning of slice, but we have to
  // take modulo into account when indexing
  long_t idx = get_index_( offs );
  double_t val = buffer_[ idx ];
  buffer_[ idx ] = 0.0; // clear buffer after reading
  return val;
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
  return Time(0);
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


