
`include "adc_config.v"

module test_threshold;

    reg clk;

    always @(*) begin
    #500  clk <= ~clk;
    end


    reg [11:0]  adc_value;
    reg adc_value_change;

    wire pulse;

    threshold threshold_dut(clk, adc_value, adc_value_change, pulse);

    reg [5:0] sq_p;

    initial begin
        adc_value <= 0;
        adc_value_change <= 0;
        clk  <= 0;
        sq_p <= 0;
    end

    always @(posedge clk) begin
        if(sq_p == 0) begin
            adc_value <= adc_value + 4095;
            adc_value_change <= ~adc_value_change;
        end

        sq_p <= sq_p + 1;

        //$display(gauss_value);
        //$display(pulse);
    end

endmodule
