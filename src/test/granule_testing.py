#!/usr/bin/env python
"""
  This script creates and runs a minimal network in the NINEML+ framework with only one cell 
  in it

  @author Tom Close
  @date 17/9/2012
"""
#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################
import argparse
import ninemlp
import os.path
PROJECT_PATH = os.path.normpath(os.path.join(ninemlp.SRC_PATH, '..'))
def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build', type=str, default=ninemlp.DEFAULT_BUILD_MODE,
                        metavar='BUILD_MODE',
                        help='Option to build the NMODL files before running (can be one of {}.'.\
                        format(ninemlp.BUILD_MODE_OPTIONS))
    parser.add_argument('--time', type=float, default=2000.0,
                        help='The run time of the simulation (ms)')
    parser.add_argument('--output', type=str,
                        default=os.path.join(PROJECT_PATH, 'output', 'single_cell.'),
                        help='The output location of the recording files')
    parser.add_argument('--min_delay', type=float, default=0.05,
                        help='The minimum synaptic delay in the network')
    parser.add_argument('--timestep', type=float, default=0.025,
                        help='The timestep used for the simulation')
    parser.add_argument('--temperature', type=float, default=23.0,
                        help='The temperature of the simulation')
    parser.add_argument('--silent_build', action='store_true', help='Suppresses all build output')
    parser.add_argument('--input_spikes', nargs='+', type=float, default=[1000.0],
                        help='The timing of input spikes into the granule cell')
    parser.add_argument('--synaptic_weight', type=float, default=1.4e-3, 
                        help="The weight of the synaptic connection between the input and the " \
                             "granule cell.")
    args = parser.parse_args(arguments)
    ninemlp.BUILD_MODE = args.build
    import ninemlp.neuron as nine
    from pyNN.neuron.cells import VectorSpikeSource
    nine.setup(args.timestep, args.min_delay, 1.0)
    nine.h.celsius = args.temperature
    Granule = nine.ncml.load_cell_type('Granule',
                             os.path.join(PROJECT_PATH, 'xml/cerebellum/ncml/Granule.xml'),
                             build_mode=args.build)
    granule = Granule()
    stim = VectorSpikeSource(args.input_spikes)
    netcon = nine.h.NetCon(stim, granule.soma_seg.GABA, -20, 0, args.synaptic_weight, #@UnusedVariable
                           sec=granule.soma_seg)
    nine.neuron.h.psection(sec=granule.soma_seg)
    granule.record('v', os.path.join(PROJECT_PATH, 'output', 'SoloGranule.v'))
    print "celsius: " + str(nine.h.celsius)
    print "Starting run"
    nine.run(args.time)
    nine.end()
    print "Simulated granule cell for %f milliseconds" % args.time

def granule_testing(arguments):
    import shlex
    main(shlex.split(arguments))

if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
