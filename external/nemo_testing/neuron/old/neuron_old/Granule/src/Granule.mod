

TITLE DeSouzaCGC


NEURON {
  RANGE comp51_vchold, comp51_vcbase, comp51_vcinc, comp51_vcsteps, comp51_vchdur, comp51_vcbdur, comp136_vchold, comp136_vcbase, comp136_vcinc, comp136_vcsteps
  RANGE comp136_vchdur, comp136_vcbdur, comp221_vchold, comp221_vcbase, comp221_vcinc, comp221_vcsteps, comp221_vchdur, comp221_vcbdur, comp306_vchold, comp306_vcbase
  RANGE comp306_vcinc, comp306_vcsteps, comp306_vchdur, comp306_vcbdur, comp391_vchold, comp391_vcbase, comp391_vcinc, comp391_vcsteps, comp391_vchdur, comp391_vcbdur
  RANGE comp476_vchold, comp476_vcbase, comp476_vcinc, comp476_vcsteps, comp476_vchdur, comp476_vcbdur, comp561_vchold, comp561_vcbase, comp561_vcinc, comp561_vcsteps
  RANGE comp561_vchdur, comp561_vcbdur
}


FUNCTION sigm (x, y) {
  sigm  =  1.0 / (exp(x / y) + 1.0)
}


FUNCTION linoid (x, y) {
  LOCAL v647
  if 
    (fabs(x / y) < 1e-06) 
     {v647  =  y * (1.0 + -(x / y / 2.0))} 
    else {v647  =  x / (exp(x / y) + -1.0)} 
linoid  =  v647
}


PARAMETER {
  comp136_vchdur  =  30.0
  comp306_vchdur  =  30.0
  comp476_vchdur  =  30.0
  comp51_vchold  =  -71.0
  comp221_vchold  =  -71.0
  comp391_vchold  =  -71.0
  comp561_vchold  =  -71.0
  comp51_vcinc  =  10.0
  comp391_vcinc  =  10.0
  comp51_vchdur  =  30.0
  comp221_vchdur  =  30.0
  comp391_vchdur  =  30.0
  comp561_vchdur  =  30.0
  comp136_vcbdur  =  100.0
  comp306_vcbdur  =  100.0
  comp476_vcbdur  =  100.0
  comp306_vcinc  =  10.0
  comp136_vcbase  =  -69.0
  comp306_vcbase  =  -69.0
  comp476_vcbase  =  -69.0
  comp51_vcbdur  =  100.0
  comp221_vcbdur  =  100.0
  comp391_vcbdur  =  100.0
  comp561_vcbdur  =  100.0
  comp136_vcinc  =  10.0
  comp476_vcinc  =  10.0
  comp51_vcbase  =  -69.0
  comp221_vcbase  =  -69.0
  comp391_vcbase  =  -69.0
  comp561_vcbase  =  -60.0
  comp51_vcsteps  =  8.0
  comp136_vcsteps  =  8.0
  comp221_vcsteps  =  8.0
  comp306_vcsteps  =  8.0
  comp391_vcsteps  =  8.0
  comp476_vcsteps  =  8.0
  comp561_vcsteps  =  9.0
  comp136_vchold  =  -71.0
  comp306_vchold  =  -71.0
  comp476_vchold  =  -71.0
  comp221_vcinc  =  10.0
  comp561_vcinc  =  10.0
}


STATE {
}


ASSIGNED {
  celsius
  v
}


BREAKPOINT {
}


INITIAL {
}


PROCEDURE print_state () {
}
