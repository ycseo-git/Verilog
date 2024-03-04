module ALU (
	input					i_Clk,
	input 					i_Rst,
	input			[2:0]	i_Op, // The opcode should be considered externally.
	input					i_fSub,
	input 					i_fSign, // SUB, SRA, SLT, SLTU, SLTI, SLTIU
	input			[31:0]	i_Data0, i_Data1,
	output	reg		[31:0]	o_Data,
	output	reg				o_fBranch,
	output	reg				o_fNeg
);
	
/* Wires */
wire [32:0] Sum_i_0;
wire [32:0] Sum_i_1;
wire [32:0] Sum_o;
wire [62:0]	SLL_i,	SRL_i;
wire [4:0]	Shamt;
wire		fZero;
wire		fUnsign;

/* Registers */
reg	[31:0]	r_Data;
reg			r_fBranch;
reg			r_fNeg;

/* Parameters */
parameter LB 	 = 5'd0,  ADDI   = 5'd4,  AUIPC  = 5'd5,
		  S_TYPE = 5'd8,  R_TYPE = 5'd12, LUI 	 = 5'd13,
		  B_TYPE = 5'd24, JALR   = 5'd25, J_TYPE = 5'd27;

parameter	ADD  = 3'd0, SLL  = 3'd1, SLT  = 3'd2, SLTU = 3'd3,
			XOR  = 3'd4, SRL  = 3'd5, OR   = 3'd6, AND  = 3'd7;
parameter	BEQ  = 3'd0, BNE  = 3'd1, 
			BLT  = 3'd4, BGE  = 3'd5, BLTU = 3'd6, BGEU = 3'd7;
/* Assignment */
always@* begin
	r_fNeg = Sum_o[32];
	case(i_Op)
		ADD		: r_Data = Sum_o;
		SLL		: r_Data = SLL_i[~Shamt+:32];
		SLT		: r_Data = o_fNeg;
		SLTU	: r_Data = o_fNeg;
		XOR		: r_Data = i_Data0 ^ i_Data1;
		SRL		: r_Data = SRL_i[Shamt+:32];
		OR		: r_Data = i_Data0 | i_Data1;
		AND		: r_Data = i_Data0 & i_Data1;
		default : r_Data = 0;
	endcase
end

always@*
	case(i_Op)
		BEQ  	: r_fBranch =  fZero;
		BNE  	: r_fBranch = !fZero;
		BLT  	: r_fBranch =  Sum_o[32];
		BGE  	: r_fBranch = !Sum_o[32];
		BLTU 	: r_fBranch =  Sum_o[32];
		BGEU 	: r_fBranch = !Sum_o[32];
		default	: r_fBranch = 0;
	endcase

// Signed   : ADD, SLT, BLT, BGE
// Unsigned : SLTU, BLTU, BGEU
assign	fUnsign	= i_Op == SLTU || i_Op == BLTU || i_Op == BGEU; 
assign	Sum_i_0	= {i_Data0[31] & !fUnsign, i_Data0},
		Sum_i_1	= {i_Data1[31] & !fUnsign, i_Data1};
assign	Sum_o	= i_fSub ? Sum_i_0 - Sum_i_1 : Sum_i_0 + Sum_i_1;    // SUB or ADD
assign	fZero	= Sum_o[31:0] == 0;
// assign	o_fNeg	= Sum_o[32];

assign	SLL_i	= {i_Data0, 31'b0}; 
assign	SRL_i	= {{31{i_fSign & i_Data0[31]}}, i_Data0};
assign	Shamt	= i_Data1[4:0];

/* pipeline */
always@(posedge i_Clk, negedge i_Rst) 
		if(!i_Rst) begin
			o_Data 		<= 0;
			o_fBranch 	<= 0;
			o_fNeg		<= 0;
		end else begin
			o_Data 		<= r_Data;
			o_fBranch 	<= r_fBranch;
			o_fNeg		<= r_fNeg;
		end
endmodule
