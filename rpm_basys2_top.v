`include "rpm_config.v"
`include "adc_config.v"

module rpm_basys2_top(
    input mclk,

    output [6:0] seg,
    output       dp,
    output [3:0] an,
    input [3:0] btn,
    input  [7:0] sw,
    output [7:0] led,

    output adc_cs,
    input  adc_d0,
    input  adc_d1,
    output adc_clk
);



    wire [`ADC_WIDTH - 1:0] adc_value; 
    wire adc_change;

    adc adc_dut(mclk, adc_clk, adc_cs, adc_d0, adc_value, adc_change);


    wire [`ADC_WIDTH - 1:0] hz_real; 
    wire hz_real_change; 
    wire hz_p; 

    /*
    hz_square instance_name (
    .clk(mclk),
    .count_stop(btn[3]),
    .pulse(hz_pulse),
    .pulse_real(hz_real),
    .pulse_real_change(hz_real_change)
    );

    */

    wire pulse;
    //assign led = adc_value;
    assign led = 0 | pulse;

    //wire [`ADC_WIDTH - 1:0] threshold_input = btn[1] ? hz_real : adc_value; 
    //wire threshold_input_change = btn[1] ? hz_real_change : adc_change;

    wire [16:0] avg; 
    threshold threshold_dut(mclk, adc_value, adc_change, avg,  pulse);
    //threshold threshold_dut(mclk, threshold_input, threshold_input_change, avg,  pulse);


    wire [`RPM_WIDTH - 1:0] period; 
    wire period_change;

    wire [`RPM_WIDTH - 1:0] pulse_rate; 
    wire pulse_rate_change;

    //wire pulse_input = btn[2] ? hz_p: pulse;
    //wire pulse_input = btn[2] ? 0 : pulse;

    //pulse_timer pt(mclk, pulse_input, period, period_change);
    //pulse_timer pt(mclk, pulse_input, period, period_change);
    //
    pulse_counter pt(mclk, pulse, pulse_rate, pulse_rate_change);

    wire [`RPM_WIDTH - 1:0] rpm; 
    wire [4:0] rpm_order; 
    wire rpm_change;
    wire [7:0] stripe_count;
    assign stripe_count = sw;


    //wire [`RPM_WIDTH - 1:0] period_input = btn[2] ? 50000000 : period;

    //rpm rpm_dut(mclk, period_input, period_change, stripe_count, rpm, rpm_order, rpm_change);
//    assign led = 0 |  rpm_order;


    wire [3:0] dec0;
    wire [3:0] dec1;
    wire [3:0] dec2;
    wire [3:0] dec3;

    wire [3:0] dp_i;
    wire [7:0] led_i;

    wire [`RPM_WIDTH - 1:0] bcd_in = btn[0] ? period : rpm;
    wire  bcd_in_c = btn[0] ? period_change : rpm_change;

    //bcd bcd_dut(mclk, bcd_in, rpm_order, bcd_in_c, dec0, dec1, dec2, dec3, dp_i, led_i);
    bcd bcd_dut(mclk, 60*pulse_rate, rpm_order, pulse_rate_change, dec0, dec1, dec2, dec3, dp_i, led_i);
    //bcd bcd_dut(mclk, rpm, rpm_order, rpm_change, dec0, dec1, dec2, dec3, dp_i, led_i);
    //bcd bcd_dut(mclk, {4'd0, adc_value}, rpm_order, adc_change, dec0, dec1, dec2, dec3, dp_i, led_i);
    //bcd bcd_dut(mclk, avg, rpm_order, adc_change, dec0, dec1, dec2, dec3, dp_i, led_i);
    //bcd bcd_dut(mclk, period, rpm_order, period_change, dec0, dec1, dec2, dec3, dp_i, led_i);


    wire [3:0] dp_j;
    wire [7:0] led_j;

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;

    wire dp0;
    wire dp1;
    wire dp2;
    wire dp3;

    wire [3:0] dp_k;
    wire [7:0] led_k;

    decode_seg decode_seg0(mclk, dec0, dp_i[0], dp_j[0], seg0);
    decode_seg decode_seg1(mclk, dec1, dp_i[1], dp_j[1], seg1);
    decode_seg decode_seg2(mclk, dec2, dp_i[2], dp_j[2], seg2);
    decode_seg decode_seg3(mclk, dec3, dp_i[3], dp_j[3], seg3);


    seg_mux sm(mclk, 
               seg0, seg1, seg2, seg3, 
               dp_j,
               dp, seg, an);

endmodule
