`include "rpm_config.v"
`include "adc_config.v"

module rpm_basys2_top(
    input mclk,

    output [6:0] seg,
    output [3:0] an,

    output adc_cs,
    input  adc_d0,
    input  adc_d1,
    output adc_clk
);


    wire [`ADC_WIDTH - 1:0] adc_value; 
    wire adc_change;

    adc adc_dut(mclk, adc_clk, adc_cs, adc_d0, adc_value, adc_change);

    wire pulse;

    threshold threshold_dut(mclk, adc_value, adc_change, pulse);

    wire [`RPM_WIDTH - 1:0] period; 
    wire period_change;

    wire [`RPM_WIDTH - 1:0] rpm; 
    wire rpm_change;

    rpm rpm_dut(mclk, pulse, period, period_change, rpm, rpm_change);

    wire [3:0] dec0;
    wire [3:0] dec1;
    wire [3:0] dec2;
    wire [3:0] dec3;

    bcd bcd_dut(mclk, rpm, rpm_change, dec0, dec1, dec2, dec3);

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;

    decode_seg decode_seg0(mclk, dec0, seg0);
    decode_seg decode_seg1(mclk, dec1, seg1);
    decode_seg decode_seg2(mclk, dec2, seg2);
    decode_seg decode_seg3(mclk, dec3, seg3);

    seg_mux sm(mclk, seg0, seg1, seg2, seg3, seg, an);


endmodule

