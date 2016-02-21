#include "mock_nest.h"


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

