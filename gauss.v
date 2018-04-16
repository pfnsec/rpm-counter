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

    reg [8 - 1:0][12 - 1:0] conv_window;

    reg [8 - 1:0][8 - 1:0] conv_coeffs;

    integer i;
    initial begin
        conv_coeffs[0] = 1;
        conv_coeffs[1] = 15;
        conv_coeffs[2] = 92;
        conv_coeffs[3] = 228;
        conv_coeffs[4] = 228;
        conv_coeffs[5] = 92;
        conv_coeffs[6] = 15;
        conv_coeffs[7] = 1;
        for(i = 0; i < 8; i = i + 1) begin
            conv_window[i] <= 0;
        end
    end

    always @(posedge clk) begin
        conv_window[0] <= adc_value;
        conv_window[1] <= conv_window[0];
        conv_window[2] <= conv_window[1];
        conv_window[3] <= conv_window[2];
        conv_window[4] <= conv_window[3];
        conv_window[5] <= conv_window[4];
        conv_window[6] <= conv_window[5];
        conv_window[7] <= conv_window[6];

        for(i = 0; i < 7; i = i + 1) begin
        //    conv_window[i + 1] <= conv_window[i];
         //   $display(conv_window[i]);
        end

        conv_value = 0;
        for(i = 0; i < 8; i = i + 1) begin
            conv_value = conv_value + conv_window[i] * conv_coeffs[i];
            $display("%d, %d", conv_window[i], conv_coeffs[i]);
        end
    end

endmodule
