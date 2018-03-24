
module decode_seg(
    input clk,
    input reset,
    input [3:0] dec,
	output reg [7:0] seg //Active-high output to the display. Segment a => seg[0], segment b => seg[1], etc.
);

    wire a, b, c, d;

    assign {a,b,c,d} = dec;

    always @(posedge clk) begin
        /*
	    seg[0] <=   a |  c | (b & d) | (~b & ~d);
	    seg[1] <=  ~b | (~c & ~d) | (c & d);
	    seg[2] <=   b | ~c  | d;
	    seg[3] <= (~b & ~d) | (c & ~d) | (b & ~c & d) | (~b & c) | a;
	    seg[4] <= (~b & ~d) | (c & ~d);
	    seg[5] <=   a | (~c & ~d) | (b & ~c) | (b & ~d);
	    seg[6] <=   a | (b & ~c) | (~b & c) | (c & ~d);
	    seg[7] <= {a,b,c,d} >= 10;
        */

        case(dec)
            0: seg = 7'b1111110;
            1: seg = 7'b0110000;
            2: seg = 7'b1101101;
            3: seg = 7'b1111001;
            4: seg = 7'b0110011;
            5: seg = 7'b1011011;
            6: seg = 7'b1011111;
            7: seg = 7'b1110000;
            8: seg = 7'b1111111;
            9: seg = 7'b1111011; 
           /*
        4'b0000 : seg = 7'h7E;
        4'b0001 : seg = 7'h30;
        4'b0010 : seg = 7'h6D;
        4'b0011 : seg = 7'h79;
        4'b0100 : seg = 7'h33;
        4'b0101 : seg = 7'h5B;
        4'b0110 : seg = 7'h5F;
        4'b0111 : seg = 7'h70;
        4'b1000 : seg = 7'h7F;
        4'b1001 : seg = 7'h7B; */
        default:                
               seg = 8'b00000000;
        endcase

        seg = seg << 1;

    end


/*
	Simulate an ASCII seven-segment display to verify the decoder.
	Example output:

	Input: 5   Input: 6   Input: 7    Input: 8
	 _          _          _           _ 
	|_         |_           |         |_|
	 _|        |_|          |         |_|

*/

//*
	always @(posedge clk) begin	

	//First line: segment a
		if(seg[0])
			$display(" _ ");
		else
			$display("   ");

	//Second line: segments f, g, b
		if(seg[5])
			$write("|");
		else
			$write(" ");

		if(seg[6])
			$write("_");
		else
			$write(" ");

		if(seg[1])
			$display("|");
		else
			$display(" ");

	//Third line: segments e, d, c
		if(seg[4])
			$write("|");
		else
			$write(" ");

		if(seg[3])
			$write("_");
		else
			$write(" ");

		if(seg[2])
			$display("|");
		else
			$display(" ");
	end
//*/

endmodule
