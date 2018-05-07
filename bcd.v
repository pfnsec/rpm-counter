`include "rpm_config.v"

module bcd(
    input clk,

    input [`RPM_WIDTH - 1:0] rpm,
    input [4:0] rpm_order,
    input rpm_change,

    output reg [3:0] dec0,
    output reg [3:0] dec1,
    output reg [3:0] dec2,
    output reg [3:0] dec3,

    output reg [3:0] dp,

    output reg [7:0] led
);
    integer i;

    reg change;
    reg rpm_changed;
    reg [4:0] order;
    reg [`RPM_WIDTH_2:0] shift_count;
    reg [15:0] dec;
    reg [`RPM_WIDTH - 1:0] p;

    `define BCD_IDLE 0
    `define BCD_RUN  1
    reg state;

    initial begin
        shift_count <= 0;
        rpm_changed <= 0;
        state <= `BCD_IDLE;

        dec  <= 0;
        
        dec0 <= 0;
        dec1 <= 0;
        dec2 <= 0;
        dec3 <= 0;
    end


    always @(posedge clk) begin    
        case(state) 
            `BCD_IDLE: begin
                if(rpm_change != rpm_changed) begin
                    state <= `BCD_RUN;
                    p   = rpm;
                    order <= rpm_order;
                    dec = 0;
                    shift_count = 0;
                end
            end

            `BCD_RUN: begin
                if(shift_count < `RPM_WIDTH) begin
                    $display("?");
                    shift_count = shift_count + 1;

                    if(dec[3:0] >= 5)
                        dec[3:0] = dec[3:0] + 3;

                    if(dec[7:4] >= 5)
                        dec[7:4] = dec[7:4] + 3;

                    if(dec[11:8] >= 5)
                        dec[11:8] = dec[11:8] + 3;

                    if(dec[15:12] >= 5)
                        dec[15:12] = dec[15:12] + 3;

                    {dec, p} = {dec, p} << 1;

                end else begin
                    dec0  = dec[3:0];
                    dec1  = dec[7:4];
                    dec2  = dec[11:8];
                    dec3  = dec[15:12];


                    //for(i = 0; i < 32; i = i + 1) begin
                        //if(order > 3)


                    //end

                    $display("%d %d %d %d", dec0, dec1, dec2, dec3);
                    state <= `BCD_IDLE;
                end
            end
        endcase

    end

    always @(posedge clk) begin
    end




endmodule
