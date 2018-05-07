`include "rpm_config.v"

module pulse_timer(
    input clk,

    input pulse,
    output reg [`RPM_WIDTH - 1:0] period,
    output reg period_change
);

    integer i;

    //Count-up time since last pulse
    reg [`RPM_WIDTH - 1:0]    period_timer;

    //Index into the array indicating the current entry
    reg [`NPOINT_AVG_2 - 1:0] schedule_index;

    //Array of time interval measurements to average over
    reg [`RPM_WIDTH - 1:0]    pulse_schedule[`NPOINT_AVG - 1:0];

    reg pulse_active;

    initial begin
        period <= 0;
        period_change <= 0;
        period_timer   <= 0;
        schedule_index <= 0;
        pulse_active   <= 0;

        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            pulse_schedule[i] <= 0;
        end
    end

    always @(posedge clk) begin
        period = 0;

        //Sum over all period measurements
        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            period = period + pulse_schedule[i];
        end

        //Divide by N and signal fresh data
        period = period/`NPOINT_AVG;
        period_change <= ~period_change;
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
