`include "rpm_config.v"

module bcd(
    input clk,

    input [`RPM_WIDTH - 1:0] period,
    input period_change,

    output reg [3:0] dec0,
    output reg [3:0] dec1,
    output reg [3:0] dec2,
    output reg [3:0] dec3
);

    reg change;
    reg period_changed;
    reg [6:0] shift_count;
    reg [15:0] dec;
    reg [`RPM_WIDTH - 1:0] p;

    `define BCD_IDLE 0
    `define BCD_RUN  1
    reg state;

    initial begin
        shift_count <= 0;
        period_changed <= 0;
        state <= `BCD_IDLE;

        dec  <= 0;
        
        dec0 <= 0;
        dec1 <= 0;
        dec2 <= 0;
        dec3 <= 0;
    end

    always @(posedge clk) begin
        //dec0 <=  period % 10;
        //dec1 <= (period % 100) / 10;
        //dec2 <= (period % 1000) / 100;
        //dec3 <= (period % 10000) / 1000;
    end




    always @(posedge clk) begin    
        case(state) 
            `BCD_IDLE: begin
                if(period_change != period_changed) begin
                    $display("!");
                    period_changed <= period_change;
                    p = period;
                    state <= `BCD_RUN;
                    dec    = 0;
                    shift_count = 0;
                end
            end

            `BCD_RUN: begin
                if(shift_count < `RPM_WIDTH) begin
                    $display("?");
                    {dec, p} = {dec, p} << 1;
                    shift_count = shift_count + 1;

                    if(dec[3:0] >= 5)
                        dec[3:0] = dec[3:0] + 3;

                    if(dec[7:4] >= 5)
                        dec[7:4] = dec[7:4] + 3;

                    if(dec[11:8] >= 5)
                        dec[11:8] = dec[11:8] + 3;

                    if(dec[15:12] >= 5)
                        dec[15:12] = dec[15:12] + 3;

                    $display("%b", {dec,p});
                end else begin
                    dec0  <= dec[3:0];
                    dec1  <= dec[7:4];
                    dec2  <= dec[11:8];
                    dec3  <= dec[15:12];
                    state <= `BCD_IDLE;
                end
            end
        endcase

    end

    always @(posedge clk) begin
    end




endmodule
