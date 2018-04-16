`include "adc_config.v"

module adc(
    input clk,

    output reg adc_clk,
    output reg adc_cs,
    input      adc_data,

    input      d_ready,
    output reg d_valid,

	output reg [`ADC_WIDTH - 1:0] adc_value
);

    reg [11:0] adc_reg;

    //ADC Control State Machine
    
    `define ADC_IDLE    0
    `define ADC_START   1
    `define ADC_CONVERT 2
    `define ADC_FINISH  4
    reg [4:0] adc_ctrl_state;
    reg [4:0] adc_bit;


    //ADC Clock Generation
    
    reg [4:0] adc_clk_div;

    initial begin
        adc_clk     <= 0;
        adc_clk_div <= 0;
        d_valid     <= 0;
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
        adc_ctrl_state <= ADC_IDLE;
    end

    always @(posedge adc_clk) begin
        case(adc_ctrl_state) 
            `ADC_IDLE: begin
                adc_bit <= 15;
                adc_cs  <= 1;
                adc_ctrl_state <= `ADC_START;
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
                d_valid        <= 1;

                if(d_valid & d_ready) begin
                    d_valid        <= 0;
                    adc_ctrl_state <= `ADC_IDLE;
                end
            end
        endcase
    end

endmodule
