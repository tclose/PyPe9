

TITLE Granule_DeSouza10_soma


NEURON {
  RANGE comp187_celsius, comp187_V_t, comp188_C_m, comp189_diam, comp189_L
}


PARAMETER {
  comp189_L  =  11.8
  comp187_V_t  =  -35.0
  comp189_diam  =  11.8
  comp187_celsius  =  30.0
  comp188_C_m  =  1.0
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
