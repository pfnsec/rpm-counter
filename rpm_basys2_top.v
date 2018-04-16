module rpm_basys2_top(
    input mclk,

    output [6:0] seg,
    output [3:0] an,

    output adc_cs,
    input  adc_d0,
    input  adc_d1,
    output adc_clk
);

    wire d_ready;
    wire d_valid;

    adc adc_dut(clk, adc_clk, adc_cs, adc_data, d_ready, d_valid);

    wire [`RPM_WIDTH - 1:0] period; 

    wire pulse;

    rpm rpm_dut(clk, pulse, period);

    wire [3:0] dec0;
    wire [3:0] dec1;
    wire [3:0] dec2;
    wire [3:0] dec3;

    bcd bcd_dut(clk, period, dec0, dec1, dec2, dec3);

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;

    decode_seg decode_seg0(clk, dec0, seg0);
    decode_seg decode_seg1(clk, dec1, seg1);
    decode_seg decode_seg2(clk, dec2, seg2);
    decode_seg decode_seg3(clk, dec3, seg3);

    seg_mux sm(clk, seg0, seg1, seg2, seg3, seg, an);


endmodule

