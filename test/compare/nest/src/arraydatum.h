#ifndef ARRAYDATUM_H
#define ARRAYDATUM_H

#include "tokenarray.h"

class ArrayDatum : public Datum, public TokenArray {

  public:

    ArrayDatum()
      : Datum(&ARRAY_TYPE) {
    }

    Datum* clone() const {
        return new ArrayDatum();
    }

};


#endif
