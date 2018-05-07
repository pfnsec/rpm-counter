`include "rpm_config.v"

module rpm(
    input clk,

    input [`RPM_WIDTH - 1:0] period,
    input period_change,

    input [7:0] stripe_count,

    output reg [`RPM_WIDTH - 1:0] rpm,
    output reg [4:0] rpm_order,
    output reg rpm_change
);

    integer i;

    reg [1:0] rpm_div_state;
    `define RPM_DIV_IDLE  0
    `define RPM_DIV_RUN   1
    `define RPM_DIV_DONE  2

    reg [4:0] order;

    reg [`DIV_WIDTH_2 + 1:0] div_i;

    reg [`DIV_WIDTH - 1:0]   dividend, divider;
    reg [`DIV_WIDTH:0]   diff;

    reg stripe_divided;
    reg period_changed;

    initial begin
        rpm <= 0;
        rpm_change <= 0;
        period_changed <= 0;
        
        rpm_div_state <= `RPM_DIV_IDLE;
    end

    always @(posedge clk) begin

        case(rpm_div_state) 
            `RPM_DIV_IDLE: begin
                if(period_change != period_changed) begin
                    period_changed <= period_change;
                    stripe_divided <= 0;
                    divider  <= period;
                    dividend = `RPM_DIV_CONV;
                    order <= 0;
                    div_i <= 0;
                    diff  = 0;

                    rpm_div_state <= `RPM_DIV_RUN;
                end
            end

            `RPM_DIV_RUN: begin
                if(div_i < `DIV_WIDTH) begin
                    div_i <= div_i + 1;

                    diff = {diff[`DIV_WIDTH - 2:0], dividend[`DIV_WIDTH - 1]};
                    //dividend[32-1:1] = dividend[32-2:0];
                    dividend = dividend << 1;

                    diff = diff - divider;

                    if(diff[`DIV_WIDTH - 1] == 1) begin
                        dividend[0] = 0;
                        diff = diff + divider;   
                    end else begin
                        dividend[0] = 1;
                    end
                end else begin
                    div_i <= 0;
                    rpm_div_state <= `RPM_DIV_DONE;
                end

            end 

            `RPM_DIV_DONE: begin

                if(diff >= 5)
                    dividend = dividend + 1;

                if(~stripe_divided) begin
                    divider <= stripe_count;
                    stripe_divided <= 1;
                    rpm_div_state <= `RPM_DIV_RUN;
                end else if(dividend >= 10000) begin
                    divider <= 10;
                    order <= order + 1;
                    rpm_div_state <= `RPM_DIV_RUN;
                end else begin
                    rpm <= dividend;
                    rpm_change <= ~rpm_change;
                    rpm_order <= order;
                    rpm_div_state <= `RPM_DIV_IDLE;
                end

            end
        endcase
    end



endmodule
