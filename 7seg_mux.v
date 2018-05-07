
//50MHz/120Hz = 416667
//`define SEG_CLK_DIV 416
`define SEG_CLK_DIV 116667
//`define SEG_CLK_DIV 416667
//`define SEG_CLK_DIV 32'd41666700

module seg_mux(
    input  clk,
	input  [7:0] seg_a,
	input  [7:0] seg_b,
	input  [7:0] seg_c,
	input  [7:0] seg_d,

    input  [3:0] dp_k,


    output [3:0] dp,
	output [7:0] seg,

    output [3:0] an
);

    reg [31:0] clk_div;
    reg [3:0] anode;
	reg [7:0] seg_a_r;
	reg [7:0] seg_b_r;
	reg [7:0] seg_c_r;
	reg [7:0] seg_d_r;

    initial begin
        clk_div <= 0;
        anode   <= 0;
    end

    assign an  = ~anode;

    assign dp  = anode[0] ? ~dp_k[0] 
               : anode[1] ? ~dp_k[1]
               : anode[2] ? ~dp_k[2]
               : anode[3] ? ~dp_k[3]
               : 8'b0;

    assign seg = anode[0] ? ~seg_a_r
               : anode[1] ? ~seg_b_r
               : anode[2] ? ~seg_c_r
               : anode[3] ? ~seg_d_r
               : 8'b0;

    always @(posedge clk) begin
        if(clk_div == `SEG_CLK_DIV) begin
            clk_div <= 0;

            seg_a_r <= seg_a;
            seg_b_r <= seg_b;
            seg_c_r <= seg_c;
            seg_d_r <= seg_d;

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
