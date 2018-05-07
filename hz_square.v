`define CLK_RATE 32'd50000000

module hz_square(
    input clk,

    input count_stop,
    output reg pulse,
    output reg [12 - 1:0] pulse_real,
    output reg pulse_real_change
);

    reg [18:0] count;

    reg hz_clk;
    reg [8:0] hz_clk_div;


    initial begin
        count <= 0;

        pulse <= 0;
        pulse_real <= 0;
        pulse_real_change <= 0;

        hz_clk     <= 0;
        hz_clk_div <= 0;
    end


    always @(posedge clk) begin
        if(hz_clk_div == 13 * 2) begin
           hz_clk_div <= 0;

            if(count == 50000000/(13 * 2)) begin
                count <= 0;

                pulse = ~pulse;
                pulse_real_change <= ~pulse_real_change;

                if(pulse_real == 0) begin
                    pulse_real <= 4095;
                end else begin
                    pulse_real <= 0;
                end

            end else begin
                count <= count + 1;
            end
        end else begin
            if(~count_stop)
                hz_clk_div <= hz_clk_div + 1;
        end
    end


endmodule
