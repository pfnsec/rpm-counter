`include "adc_config.v"
//`include "gauss_config.v"

module gauss(
    input clk,

    output reg d_ready,

    input      d_valid,

	input [`ADC_WIDTH - 1:0] adc_value,
    //output reg [`ADC_WIDTH + `CONV_WIDTH - 1:0] conv_value
    output reg [20 - 1:0] conv_value
);

    reg [5 - 1:0][12 - 1:0] conv_window;

    reg [5 - 1:0][5 - 1:0] conv_coeffs;

    integer i;
    initial begin
        conv_coeffs[0] = 1;
        conv_coeffs[1] = 13;
        conv_coeffs[2] = 32;
        conv_coeffs[3] = 13;
        conv_coeffs[4] = 1;
        for(i = 0; i < 5; i = i + 1) begin
            conv_window[i] <= 0;
        end
    end

    always @(posedge clk) begin
        conv_window[0] <= adc_value;

        for(i = 0; i < 4; i = i + 1) begin
            conv_window[i + 1] <= conv_window[i];
        end

        conv_value = 0;
        for(i = 0; i < 5; i = i + 1) begin
            conv_value = conv_value + conv_window[i] * conv_coeffs[i];
        end
    end

endmodule
