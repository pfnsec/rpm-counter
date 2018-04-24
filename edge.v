//Edge detector (optical reflectance transitions)


module laplacian(
    input clk,

    //output reg [`ADC_WIDTH + `CONV_WIDTH - 1:0] conv_value
    input [20 - 1:0] gauss_value,

    output pulse
);


    reg signed [24 - 1:0] conv_value;

    assign pulse = (conv_value == 0 ? 1 : 0);

    reg [3 - 1:0][20 - 1:0] conv_window;

    reg signed [3 - 1:0][3 - 1:0] conv_coeffs;

    integer i;
    initial begin
        conv_coeffs[0] = 1;
        conv_coeffs[1] = -2;
        conv_coeffs[2] = 1;
        for(i = 0; i < 3; i = i + 1) begin
            conv_window[i] <= 0;
        end
    end

    always @(posedge clk) begin
        conv_window[0] <= gauss_value;

        for(i = 0; i < 3; i = i + 1) begin
            conv_window[i + 1] <= conv_window[i];
        end

        conv_value = 0;
        for(i = 0; i < 3; i = i + 1) begin
            conv_value = conv_value + conv_window[i] * conv_coeffs[i];

        end
            $display(conv_value);
    end
endmodule


