#include "mock_nest.h"

const Name DOUBLE_TYPE("double");
const Name DICTIONARY_TYPE("dictionary");


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

Token::Token( bool value )
{
  p = new BoolDatum( value );
}

Token::Token( const char* value )
{
  p = new StringDatum( value );
}

Token::Token( std::string value )
{
  p = new StringDatum( value );
}

Token::Token( const std::vector< long >& value )
{
  p = new ArrayDatum( value );
}

Token::Token( const std::vector< size_t >& value )
{
  p = new ArrayDatum( value );
}

Token::Token( const std::vector< double >& value )
{
  p = new ArrayDatum( value );
}

Token::Token( const std::valarray< double >& value )
{
  p = new ArrayDatum( value );
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

Token::operator float() const
{
  return getValue< float >( *this );
}

Token::operator bool() const
{
  return getValue< bool >( *this );
}

Token::operator std::string() const
{
  return getValue< std::string >( *this );
}
