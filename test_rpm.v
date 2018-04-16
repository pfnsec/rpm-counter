`include "rpm_config.v"

module test_rpm;

    reg clk;
    reg test_clk;
    reg reset;
    wire [`RPM_WIDTH - 1:0] period;
    integer test_period;
    integer i;

    reg pulse;

    initial begin
        test_clk = 0;
        test_period = 47;
        i = 0;

        clk   = 0;
        pulse = 0;

        reset = 1;

#5000   reset = 0;
    end

    always @(*) begin
    #500  clk <= ~clk;
    end

    always @(*) begin
    #274  test_clk <= ~test_clk;
    end


    rpm rpm_dut(clk, reset, pulse, period);

    wire [3:0] dec0;
    wire [3:0] dec1;
    wire [3:0] dec2;
    wire [3:0] dec3;

    bcd bcd_dut(clk, reset, period, dec0, dec1, dec2, dec3);

    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;

    decode_seg decode_seg0(clk, reset, dec0, seg0);
    decode_seg decode_seg1(clk, reset, dec1, seg1);
    decode_seg decode_seg2(clk, reset, dec2, seg2);
    decode_seg decode_seg3(clk, reset, dec3, seg3);

    always @(posedge test_clk) begin
        if(i == test_period) begin
            $display("Period : %d", period);
            pulse <= 1;
            i = 0;
        end else begin
            pulse <= 0;
            i = i + 1;
        end
    end

endmodule
