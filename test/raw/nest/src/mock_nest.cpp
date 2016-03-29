#include "mock_nest.h"

#include <iostream>
#include <iomanip>


Token::Token( int value )
{
  p = new IntegerDatum( value );
}

Token::Token( unsigned int value )
{
  p = new IntegerDatum( value );
}

Token::Token( long value )
{
  p = new IntegerDatum( value );
}

Token::Token( unsigned long value )
{
  p = new IntegerDatum( value );
}

Token::Token( double value )
{
  p = new DoubleDatum( value );
}


Token::operator long() const
{
  return getValue< long >( *this );
}

Token::operator size_t() const
{
  return getValue< long >( *this );
}

Token::operator double() const
{
  return getValue< double >( *this );
}

double nest::Time::resolution = 0.0;


//Dictionary::insert_move(Name const&, Token&), referenced from:
//    void def<double>(DictionaryDatum&, Name, double const&) in raw_compare-IzhikevichBranch.o
//    void def<double>(DictionaryDatum&, Name, double const&) in raw_compare-IzhikevichMaster.o
//Dictionary::insert(Name const&, Token const&), referenced from:
//    _main in raw_compare-main.o
//Dictionary::operator[](Name const&), referenced from:
//    nineml::IzhikevichBranch::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichMaster.o
//Name::insert(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&), referenced from:
//    Name::Name(char const*) in raw_compare-main.o
//    Name::Name(char const*) in raw_compare-IzhikevichBranch.o
//    Name::Name(char const*) in raw_compare-IzhikevichMaster.o
//    Name::Name(char const*) in raw_compare-mock_nest.o
//nest::RingBuffer::clear(), referenced from:
//    nineml::IzhikevichBranch::init_buffers_()      in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::init_buffers_()      in raw_compare-IzhikevichMaster.o
//nest::RingBuffer::add_value(long, double), referenced from:
//    nineml::IzhikevichBranch::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichMaster.o
//nest::RingBuffer::get_value(long), referenced from:
//    nineml::IzhikevichBranch::update(nest::Time const&, long, long) in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::update(nest::Time const&, long, long) in raw_compare-IzhikevichMaster.o
//nest::Archiving_Node::set_status(DictionaryDatum const&), referenced from:
//    nineml::IzhikevichBranch::set_status(DictionaryDatum const&)  in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::set_status(DictionaryDatum const&)  in raw_compare-IzhikevichMaster.o
//nest::RecordablesMap<nineml::IzhikevichBranch>::get_list(), referenced from:
//    nineml::IzhikevichBranch::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichBranch.o
//nest::RecordablesMap<nineml::IzhikevichMaster>::get_list(), referenced from:
//    nineml::IzhikevichMaster::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichMaster.o
//nest::Time::ms(double), referenced from:
//    _main in raw_compare-main.o
//nest::names::recordables, referenced from:
//    nineml::IzhikevichBranch::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichMaster.o
//nest::names::receptor_types, referenced from:
//    nineml::IzhikevichBranch::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichMaster.o
//nest::names::t_spike, referenced from:
//    nineml::IzhikevichBranch::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichMaster.o
//nest::Network::get_slice_origin(), referenced from:
//    nineml::IzhikevichBranch::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichMaster.o
//nest::Network::get_rng(int), referenced from:
//    nineml::IzhikevichBranch::calibrate()     in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::calibrate()     in raw_compare-IzhikevichMaster.o
//nest::Scheduler::min_delay, referenced from:
//    nest::Scheduler::get_min_delay()     in raw_compare-IzhikevichBranch.o
//    nest::Scheduler::get_min_delay()     in raw_compare-IzhikevichMaster.o
//Dictionary::lookup(Name const&) const, referenced from:
//    bool updateValue<double, double>(DictionaryDatum const&, Name, double&) in raw_compare-IzhikevichBranch.o
//    bool updateValue<double, double>(DictionaryDatum const&, Name, double&) in raw_compare-IzhikevichMaster.o
//nest::SpikeEvent::get_delay() const, referenced from:
//    nineml::IzhikevichBranch::handle(nest::SpikeEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::SpikeEvent&)       in raw_compare-IzhikevichMaster.o
//nest::CurrentEvent::get_weight() const, referenced from:
//    nineml::IzhikevichBranch::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichMaster.o
//nest::CurrentEvent::get_current() const, referenced from:
//    nineml::IzhikevichBranch::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichMaster.o
//nest::CurrentEvent::get_rel_delivery_steps(nest::Time const&) const, referenced from:
//    nineml::IzhikevichBranch::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichMaster.o
//nest::CurrentEvent::get_delay() const, referenced from:
//    nineml::IzhikevichBranch::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichMaster.o
//nest::CurrentEvent::get_rport() const, referenced from:
//    nineml::IzhikevichBranch::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::handle(nest::CurrentEvent&)       in raw_compare-IzhikevichMaster.o
//nest::Archiving_Node::get_status(DictionaryDatum&) const, referenced from:
//    nineml::IzhikevichBranch::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichMaster.o
//nest::Archiving_Node::get_spiketime_ms() const, referenced from:
//    nineml::IzhikevichBranch::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichBranch.o
//    nineml::IzhikevichMaster::get_status(DictionaryDatum&) const  in raw_compare-IzhikevichMaster.o
