`include "adc_config.v"

module test_rpm;

    reg clk;

    always @(*) begin
    #500  clk <= ~clk;
    end

    wire adc_ready;
    wire adc_valid;

    reg [11:0] adc_value;
    wire [19:0] gauss_value;

    gauss gauss_dut(clk, adc_ready, adc_valid, adc_value, gauss_value);

    reg [5:0] sq_p;

    initial begin
        adc_value <= 0;
        clk  <= 0;
        sq_p <= 0;
    end

    always @(posedge clk) begin
        if(sq_p == 0)
            adc_value <= adc_value + 2048;

        sq_p <= sq_p + 1;

        $display(gauss_value);
    end

endmodule
