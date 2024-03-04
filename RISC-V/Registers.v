module Registers (
	input 				i_Clk, i_Rst, i_fWE,
	input  		[4:0]	i_Rs1, i_Rs2, i_Rd,
	input  		[31:0]	i_Data,
	output reg	[31:0]	o_Data0, o_Data1
);

	/* Registers */
	reg [31:0] r_Reg [0:31];

	integer i;

	always@(posedge i_Clk, negedge i_Rst) 
		if(!i_Rst) 
			for (i=0; i<32; i=i+1) r_Reg[i] <= 32'b0;
		else if(i_fWE) 
			for (i=1; i<32; i=i+1) 
				if(i == i_Rd) r_Reg[i] <= i_Data;
	
	
	always@(posedge i_Clk, negedge i_Rst) 
		if(!i_Rst) begin
			o_Data0 <= 0;
			o_Data1 <= 0;
		end else begin
			o_Data0 <= r_Reg[i_Rs1];
			o_Data1 <= r_Reg[i_Rs2];
		end
endmodule
