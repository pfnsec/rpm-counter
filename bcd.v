`include "rpm_config.v"

module bcd(
    input clk,
    input reset,

    input [`RPM_WIDTH - 1:0] period,

    output reg [3:0] dec0,
    output reg [3:0] dec1,
    output reg [3:0] dec2,
    output reg [3:0] dec3
);

    always @(posedge clk) begin
        if(reset) begin
            dec0 <= 0;
            dec1 <= 0;
            dec2 <= 0;
            dec3 <= 0;

        end else begin
            dec0 <=  period % 10;
            dec1 <= (period % 100) / 10;
            dec2 <= (period % 1000) / 100;
            dec3 <= (period % 10000) / 1000;
        end
    end


endmodule
