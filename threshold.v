//Threshold-based edge detection with hysteresis
//(Back to sanity!)
`include "adc_config.v"

`define NPOINT_AVG_2 4
`define NPOINT_AVG   2**`NPOINT_AVG_2

module threshold(
    input clk,
	input [`ADC_WIDTH - 1:0] adc_value,
    input adc_value_change,

	output reg [`ADC_WIDTH + `NPOINT_AVG_2 - 1:0] adc_average,
    output reg pulse
);
    reg adc_value_changed;

	reg [`ADC_WIDTH - 1:0] value;


	reg [`ADC_WIDTH - 1:0] threshold;
	reg [`ADC_WIDTH - 3:0] hysteresis;


	//reg [`ADC_WIDTH + `NPOINT_AVG_2 - 1:0] adc_average;

    //Array of intensity measurements to average over
    reg [`NPOINT_AVG_2 - 1:0] adc_average_index;
    reg [`ADC_WIDTH - 1:0] adc_average_buffer[`NPOINT_AVG - 1:0];

	reg [`ADC_WIDTH - 1:0] adc_min;
	reg [`ADC_WIDTH - 1:0] adc_max;

    `define ADC_AVERAGE_INTERVAL 510023
    reg [19:0] adc_average_interval;

    integer i;
    initial begin
        adc_average_interval <= 0;
        adc_average_index    <= 0;
        adc_average          <= 0;

        for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
            adc_average_buffer[i] <= 0;
        end

        adc_value_changed <= 0;
        pulse <= 0;

        //Initial threshold at 50% of max value
        threshold <= (1 << (`ADC_WIDTH - 1));

        //Initial hysteresis at +/- 6.25% of max value
        //hysteresis <= (1 << (`ADC_WIDTH - 4));
        hysteresis <= (1 << (`ADC_WIDTH - 9));
        //hysteresis <= 4;
    end

    always @(posedge clk) begin

        if(adc_average_interval == `ADC_AVERAGE_INTERVAL) begin

            adc_average_buffer[adc_average_index] <= adc_value;

            adc_average_index <= adc_average_index + 1;

            adc_average_interval <= 0;



            adc_average = 0;
            for(i = 0; i < `NPOINT_AVG; i = i + 1) begin
                adc_average = adc_average + adc_average_buffer[i];

                if(adc_average_buffer[i] > adc_max)
                    adc_max <= adc_average_buffer[i];

                if(adc_average_buffer[i] < adc_max)
                    adc_min <= adc_average_buffer[i];
            end

            adc_average = adc_average/`NPOINT_AVG;


            if(adc_max - 8 < adc_min)
                hysteresis <= 8;
            else
                hysteresis <= (adc_max - adc_min)/4;

            threshold <= adc_average;

        end else begin
            adc_average_interval <= adc_average_interval + 1;
        end
    end

    always @(posedge clk) begin
        if(adc_value_changed != adc_value_change) begin
            adc_value_changed <= adc_value_change;
            value <= adc_value;

            if(pulse) begin
                if(adc_value <= threshold - hysteresis)
                    pulse <= 0;
            end else begin
                if(adc_value >= threshold + hysteresis)
                    pulse <= 1;
            end
        end
    end

endmodule
