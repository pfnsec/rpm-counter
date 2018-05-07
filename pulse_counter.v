`include "rpm_config.v"
`define CLK_RATE 32'd50000000

module pulse_counter(
    input clk,

    input pulse,

    output reg [`RPM_WIDTH - 1:0] pulse_rate,
    output reg pulse_rate_change
);

    integer i;

    reg [31:0] second_clk_div;

    //pulses per second
    reg [`RPM_WIDTH - 1:0]    pulse_count;

    //Index into the array indicating the current entry
    reg [`NPOINT_AVG_2 - 1:0] schedule_index;

    //Array of time interval measurements to average over
    reg [`RPM_WIDTH - 1:0]    pulse_schedule[`NPOINT_AVG - 1:0];

    reg pulse_active;

    initial begin
        pulse_rate <= 0;
        pulse_rate_change <= 0;
        pulse_count   <= 0;
        schedule_index <= 0;
        pulse_active   <= 0;

        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            pulse_schedule[i] <= 0;
        end
    end

    always @(posedge clk) begin

    end

    always @(posedge clk) begin
        if(second_clk_div == `CLK_RATE) begin
            second_clk_div <= 0;

            pulse_rate <= pulse_count;
            pulse_rate_change <= ~pulse_rate_change;

            pulse_count <= 0;
        end else begin
            second_clk_div <= second_clk_div + 1;

            if(pulse & ~pulse_active) begin

                pulse_active <= 1;

                pulse_count <= pulse_count + 1;

//            pulse_schedule[schedule_index] <= period_timer;

            end else if(~pulse) begin
                pulse_active <= 0;
            end
        end
    end

endmodule
