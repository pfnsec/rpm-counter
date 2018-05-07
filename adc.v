`include "adc_config.v"

module adc(
    input clk,

    output reg adc_clk,
    output reg adc_cs,
    input      adc_data,


	output reg [`ADC_WIDTH - 1:0] adc_value,
    output reg value_change
);

    reg [11:0] adc_reg;

    //ADC Control State Machine
    
    `define ADC_IDLE    0
    `define ADC_START   1
    `define ADC_CONVERT 2
    `define ADC_FINISH  4
    reg [4:0] adc_ctrl_state;
    reg [4:0] adc_bit;

    //Delay between ADC reads
    reg [6:0] adc_delay;
    

    //ADC Clock Generation
    
    reg [4:0] adc_clk_div;

    initial begin
        value_change <= 0;
        adc_clk      <= 0;
        adc_clk_div  <= 0;
        adc_cs       <= 1;
    end

    always @(posedge clk) begin
        if(adc_clk_div == `ADC_CLK_DIV) begin
            adc_clk_div <= 0;
            adc_clk     <= ~adc_clk;
        end else begin
            adc_clk_div <= adc_clk_div + 1;
        end
    end


    initial begin
        adc_ctrl_state <= `ADC_IDLE;
    end

    always @(posedge adc_clk) begin
        case(adc_ctrl_state) 
            `ADC_IDLE: begin
                adc_bit <= 15;
                adc_cs  <= 1;
                if(adc_delay == 0) begin
                    adc_ctrl_state <= `ADC_START;
                end else begin
                    adc_delay <= adc_delay - 1;
                end

            end

            `ADC_START: begin
                adc_cs  <= 0;
                adc_bit <= 14;
                adc_ctrl_state <= `ADC_CONVERT;
            end

            `ADC_CONVERT: begin
                if(adc_bit != 0) begin
                    adc_bit <= adc_bit - 1;

                    //ADC is strobing real data now
                    if(adc_bit < 12)
                        adc_reg[adc_bit] <= adc_data;

                end else begin
                    adc_ctrl_state <= `ADC_FINISH;
                end
            end

            `ADC_FINISH: begin
                adc_value      <= adc_reg;
                value_change   <= ~value_change;

                adc_delay <= 16;
                adc_ctrl_state <= `ADC_IDLE;
            end
        endcase
    end

endmodule
