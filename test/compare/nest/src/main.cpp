/*
 ============================================================================
 Name        : TestNestPype.cpp
 Author      : 
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C++,
 ============================================================================
 */

#include <iostream>

#include "branch.h"
#include "master.h"
#include "mock_nest.h"
#include "conditions.h"


int main(void) {

    std::cout << "Create model objects" << std::endl;
    
    // Initialise models
    nineml::Master master;
    //nineml::Branch branch;
    
    std::cout << "Set Status" << std::endl;
    
    Dictionary status;
    set_status(status);  // From custom "status.h"
    DictionaryDatum status_datum(&status);

    master.set_status(status_datum);
    //branch.set_status(status_datum);

    std::cout << "Initialise buffers" << std::endl;
    
    // Init Buffers of models
    master.init_buffers_();
    //branch.init_buffers_();

    std::cout << "Calibrate" << std::endl;
    
    master.calibrate();
    //branch.calibrate();

    double dt = 0.025;
    
    std::cout << "Set up ring buffers" << std::endl;
    
    set_ring_buffers<nineml::Master>(master);
    //set_ring_buffers<nineml::Branch>(branch);
    
    std::cout << "Run update steps" << std::endl;

    nest::Time origin(nest::Time::ms(0.0));
    
    for (int i = 0; i < NUM_SLICES; ++i) {

        master.update(origin, nest::Scheduler::min_delay * i, nest::Scheduler::min_delay * (i + 1));
        //branch.update(origin, from, to);

    }

	return 0;
}
