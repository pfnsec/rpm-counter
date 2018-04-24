`include "rpm_config.v"

module rpm(
    input clk,

    input pulse,
    output reg [`RPM_WIDTH - 1:0] period,
    output reg period_change,
    output reg [`RPM_WIDTH - 1:0] rpm,
    output reg rpm_change
);

    //Count-up time since last pulse
    reg [`RPM_WIDTH - 1:0]    period_timer;

    //Index into the array indicating the current entry
    reg [`NPOINT_AVG_2 - 1:0] schedule_index;

    //Array of time interval measurements to average over
    reg [`RPM_WIDTH - 1:0]    pulse_schedule[`NPOINT_AVG - 1:0];

    reg pulse_active;

    integer i;
    initial begin
        period = 0;
        period_change = 0;
        period_timer   <= 0;
        schedule_index <= 0;
        pulse_active   <= 0;

        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            pulse_schedule[i] <= 0;
        end
    end

    reg rpm_div_state;
    `define RPM_DIV_IDLE 0
    `define RPM_DIV_RUN  1

    reg period_changed;
    initial begin
        period_changed <= 0;
        
        rpm_div_state <= `RPM_DIV_IDLE;
    end

    reg  [31:0]   quotient;
    reg  [31:0]   dividend, divider, subdiv;
    reg  [32:0]   diff;

    reg [`RPM_WIDTH_2:0] b_s, b_e;

    //initial bit = 0;

    always @(posedge clk) begin

        case(rpm_div_state) 
            `RPM_DIV_IDLE: begin
                if(period_change != period_changed) begin
                    period_changed <= period_change;
                    divider  <= period;
                    $display(dividend);
                    $display(period);
                    dividend = `RPM_DIV_CONV;
                 
                    diff = 0;
                    rpm_div_state <= `RPM_DIV_RUN;
                end
            end

            `RPM_DIV_RUN: begin
                for(i=0; i < 32; i=i+1) begin
                    diff = {diff[30:0], dividend[31]};
                    //dividend[32-1:1] = dividend[32-2:0];
                    dividend = dividend << 1;

                    diff = diff - divider;

                    if(diff[31] == 1) begin
                        dividend[0] = 0;
                        diff = diff + divider;   
                    end else begin
                        dividend[0] = 1;
                    end
                end

                rpm_div_state <= `RPM_DIV_IDLE;
            end
        endcase
    end


    always @(posedge clk) begin
        period = 0;

        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            period = period + pulse_schedule[i];
        end

        period = period/`NPOINT_AVG;
        period_change <= ~period_change;

        //rpm <= `RPM_DIV_CONV / (period);
//        $display(`RPM_DIV_CONV / (period ));
        //$display(`RPM_DIV_CONV);

    end

    always @(posedge clk) begin
        if(pulse & ~pulse_active) begin

            pulse_active <= 1;

            pulse_schedule[schedule_index] <= period_timer;

            period_timer <= 0;

            schedule_index <= schedule_index + 1;

        end else if(~pulse) begin
            pulse_active <= 0;
            period_timer <= period_timer + 1;
        end else begin
            period_timer <= period_timer + 1;
        end
    end

endmodule
