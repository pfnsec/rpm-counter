`include "rpm_config.v"

module rpm(
    input clk,

    input pulse,
    output reg [`RPM_WIDTH - 1:0] period
);

    reg [`RPM_WIDTH - 1:0] period_timer;
    reg [`NPOINT_AVG_2 - 1:0] schedule_index;
    reg [`RPM_WIDTH - 1:0][`NPOINT_AVG - 1:0] pulse_schedule;

    reg pulse_active;

    initial begin
        period = 0;
        
        period_timer <= 0;
        schedule_index <= 0;
        pulse_active <= 0;

        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            pulse_schedule[i] <= 0;
        end
    end

    integer i;
    always @(posedge clk) begin
        period = 0;

        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            period = period + pulse_schedule[i];
        end

        period = period/`NPOINT_AVG;

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
