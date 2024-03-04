module MixColumns(i_D, i_fDec, o_D);

input			[31:0]	i_D;
input					i_fDec;
output	wire	[31:0]	o_D;

// for common part of MC and invMC
wire	[7:0] B0,  B1,  B2,  B3;
wire	[7:0] B0x2,B1x2,B2x2,B3x2;
wire	[7:0] B;

assign {B0, B1, B2, B3} = i_D;
assign	B0x2 = {B0[6:0], 1'b0} ^ {{2{B0[7]}}, 1'b0, {2{B0[7]}}};
assign	B1x2 = {B1[6:0], 1'b0} ^ {{2{B1[7]}}, 1'b0, {2{B1[7]}}};
assign	B2x2 = {B2[6:0], 1'b0} ^ {{2{B2[7]}}, 1'b0, {2{B2[7]}}};
assign	B3x2 = {B3[6:0], 1'b0} ^ {{2{B3[7]}}, 1'b0, {2{B3[7]}}};
assign	B	= B0 ^ B1 ^ B2 ^ B3;

// for only part of invMC
wire	[31:0]InvMC_i;
wire	[7:0] B02, B13, B_;
wire	[7:0] Bx9, B02x4_Bx9, B13x4_Bx9;

assign	InvMC_i		= i_fDec ? i_D : 0;
assign	B_			= i_fDec ? B   : 0;
assign {B02, B13}	= InvMC_i[31:16] ^ InvMC_i[15: 0];
assign	Bx9  		= {B_ [4:0], 3'b0} ^ {2{      B_ [7:5]}} ^ {{2{B_[7:5]}},1'b0}  ^ B;
assign	B02x4_Bx9	= {B02[5:0], 2'b0} ^ {2{1'b0, B02[7:6]}} ^  {2{B02[7:6], 1'b0}} ^ Bx9;
assign	B13x4_Bx9	= {B13[5:0], 2'b0} ^ {2{1'b0, B13[7:6]}} ^  {2{B13[7:6], 1'b0}} ^ Bx9;

assign	o_D	= i_D ^
			{2{B02x4_Bx9, B13x4_Bx9}}	^
			{B0x2, B1x2, B2x2, B3x2}	^
			{B1x2, B2x2, B3x2, B0x2};

endmodule 
