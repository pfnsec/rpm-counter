`define RPM_WIDTH_2 5
`define RPM_WIDTH 2**`RPM_WIDTH_2

//Log to the base 2 of the number of points 
// to average, E.G. 3 for an 8-point moving-average filter.
`define NPOINT_AVG_2 5
`define NPOINT_AVG   2**`NPOINT_AVG_2


//50MHz clock frequency implies that each period 'tick' represents 1/50e6
//seconds; 
//To convert to RPM with a quarter-partitioned encoder (2 black, 2 white
//quarters):
//
//The total 'ticks' represent ticks per quarter. 
//Multiplying this by 4 gives ticks per revolution. 
//Multiplying this by (seconds/tick) produces seconds per revolution.
//Dividing this by 60 produces minutes/revolution.
//Inverting this produces revolutions/minute.
//
//`define RPM_DIV_CONV 32'd((50000000 * 60)/4)
//`define RPM_DIV_CONV 32'd((50000000 * 60)/14)
`define RPM_DIV_CONV 32'd750000000

