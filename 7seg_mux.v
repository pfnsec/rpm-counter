
//50MHz/120Hz = 416667
//`define SEG_CLK_DIV 416
`define SEG_CLK_DIV 416667

module seg_mux(
    input  clk,
	input  [7:0] seg_a,
	input  [7:0] seg_b,
	input  [7:0] seg_c,
	input  [7:0] seg_d,

	output [7:0] seg,

    output reg [3:0] anode
);

    reg [19:0] clk_div;

    initial begin
        clk_div <= 0;
        anode   <= 0;
    end

    assign seg = anode[0] ? seg_a 
               : anode[1] ? seg_b
               : anode[2] ? seg_c
               : anode[3] ? seg_d
               : 8'b0;

    always @(posedge clk) begin
        if(clk_div == `SEG_CLK_DIV) begin
            clk_div <= 0;

            anode <= anode[0] ? 4'b0010 
                   : anode[1] ? 4'b0100
                   : anode[2] ? 4'b1000
                   : anode[3] ? 4'b0001
                   : 4'b0001;
        end else begin
            clk_div <= clk_div + 1;
        end
    end

endmodule
