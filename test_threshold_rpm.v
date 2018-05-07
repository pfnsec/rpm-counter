
`include "adc_config.v"
`include "rpm_config.v"

module test_threshold_rpm;

    reg clk;

    always @(*) begin
    #500  clk <= ~clk;
    end

    reg [11:0]  adc_value;
    reg adc_value_change;

    wire pulse;

    threshold threshold_dut(clk, adc_value, adc_value_change, pulse);

    wire [`RPM_WIDTH - 1:0] period;
    wire period_change;
    wire [`RPM_WIDTH - 1:0] rpm;
    wire [4:0] rpm_order;
    wire rpm_change;

    rpm rpm_dut(clk, pulse, period, period_change, rpm, rpm_order, rpm_change);


    reg [12:0] sq_p;

    initial begin
        adc_value <= 0;
        adc_value_change <= 0;
        clk  <= 0;
        sq_p <= 0;
    end

    always @(posedge clk) begin
        if(sq_p == 2048) begin
            sq_p <= 0;
            adc_value <= adc_value + 4095;
            adc_value_change <= ~adc_value_change;
        end

        sq_p <= sq_p + 1;

        //$display(gauss_value);
        //$display(pulse);
//        $display(period);
//        $display(rpm);
    end

    wire [3:0] dec0;
    wire [3:0] dec1;
    wire [3:0] dec2;
    wire [3:0] dec3;

    bcd bcd_dut(clk, rpm, rpm_change, dec0, dec1, dec2, dec3);

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;

    decode_seg decode_seg0(clk, dec0, seg0);
    decode_seg decode_seg1(clk, dec1, seg1);
    decode_seg decode_seg2(clk, dec2, seg2);
    decode_seg decode_seg3(clk, dec3, seg3);

endmodule
