
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
    wire rpm_change;

    rpm rpm_dut(clk, pulse, period, period_change, rpm, rpm_change);


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
//        $display(period);
//        $display(rpm);
    end

endmodule
