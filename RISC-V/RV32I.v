module RV32I (
	input i_Clk, i_Rst,
	output o_PC
);


/* Parameters (Opcode/Funct3) */
parameter 	LB 	 = 5'd0,  	ADDI   = 5'd4,  AUIPC  = 5'd5,
		  	S_TYPE = 5'd8,  R_TYPE = 5'd12, LUI 	 = 5'd13,
			B_TYPE = 5'd24, JALR   = 5'd25, J_TYPE = 5'd27;	  

parameter 	ADD = 3'd0, SLL = 3'd1, SLT = 3'd2, SLTU = 3'd3,
		  	XOR = 3'd4, SRL = 3'd5, OR  = 3'd6, AND  = 3'd7,
		  	LBU = 3'd4, LHU = 3'd5;


/* Registers */
reg  [29:0]	r_PC;
	

/* Wires */
wire [29:0]	PC_p4;

wire [31:0] IM_i, IM_o;
			
wire 		REG_i_fWE;
wire [ 4:0] REG_i_Rs1, REG_i_Rs2, REG_i_Rd;
wire [31:0] REG_i, REG_o_0, REG_o_1;

wire 		ALU_o_fNeg, ALU_o_fBranch;
wire  [2:0] ALU_i_Op;
wire [31:0] ALU_i_0, ALU_i_1, ALU_o;
wire 		ALU_i_fSign, ALU_i_fSub;

wire 		DM_i_fWE;
wire 		DM_i_fReadEA;
wire [31:0] DM_i_Addr, DM_i, DM_o;
wire  [1:0]	DM_i_Size;
wire 		DM_i_fSignEx;

wire 		fReadMem, fWriteMem, fPCSrc, fUnsigned;
wire 		Func7_5b;
wire [ 2:0] Funct3;
wire [ 4:0] Opcode;

wire [31:0] ImmS, ImmJ, ImmU, ImmB, ImmI;



/* Modules */
IMEM 	  IM0  (i_Clk, i_Rst, r_PC, IM_o);
Registers REG  (i_Clk, i_Rst, REG_i_fWE, REG_i_Rs1, REG_i_Rs2, REG_i_Rd, REG_i, REG_o_0, REG_o_1);
ALU 	  ALU0 (i_Clk, i_Rst, ALU_i_Op, ALU_i_fSub, ALU_i_fSign, ALU_i_0, ALU_i_1, ALU_o, ALU_o_fBranch, ALU_o_fNeg);
DMEM 	  DM0  (i_Clk, i_Rst, DM_i_fWE, DM_i_fReadEA, DM_i_Size, DM_i_fSignEx, DM_i_Addr, DM_i, DM_o);

/* ImmGen */
assign 	ImmS = {{20{IM_o[31]}}, IM_o[31:25], IM_o[11:7]};
assign 	ImmJ = {{12{IM_o[31]}}, IM_o[31], IM_o[19:12], IM_o[20], IM_o[30:21]};
assign 	ImmU = {IM_o[31:12], 12'b0};
assign 	ImmB = {{20{IM_o[31] && !fUnsigned}}, IM_o[31], IM_o[7], IM_o[30:25], IM_o[11:8]};
assign 	ImmI = fUnsigned ? {20'b0, IM_o[31:20]} : {{20{IM_o[31]}}, IM_o[31:20]};			// zero-ex, sign-ex


/* Assignment */
assign 	Funct3 			= IM_o[14:12];
assign 	Opcode 			= IM_o[ 6: 2];


/* [1] Control Signal */
assign 	fReadMem  		= Opcode == LB;
assign 	fWriteMem 		= Opcode == S_TYPE;
assign 	fPCSrc 			= &Opcode[4:3] && (Opcode[2:0] == 3'b001 || Opcode[2:0] == 3'b011 || (Opcode[2:0] == 3'b0 && ALU_o_fBranch));
assign	fUnsigned 		= Funct3 == SLTU || (Opcode == 5'b0 && Funct3 == LBU) || (Opcode == 5'b0 && Funct3 == LHU);		



/* [2] Datapath */
assign 	PC_p4 			= r_PC + 30'b1;

assign	REG_i_Rs1 	  	= IM_o[19:15],
		REG_i_Rs2 	  	= IM_o[24:20],
		REG_i_Rd 	  	= IM_o[11: 7];


/* [3] Excute */
assign 	Func7_5b		= IM_o[30] && (Opcode == R_TYPE),							
		ALU_i_fSub		= Func7_5b || (Opcode == B_TYPE) || ((Opcode == R_TYPE || Opcode == ADDI) && (Funct3 == SLT || Funct3 == SLTU)),
		ALU_i_fSign		= Func7_5b,
		ALU_i_Op 		= (Opcode[2:0] == 3'b100 || Opcode[4:0] == B_TYPE) ? Funct3 : ADD,		
		ALU_i_0			= Opcode == AUIPC ? {r_PC, 2'b0} : 
						  Opcode == LUI ? 0 : REG_o_0,
		ALU_i_1			= (Opcode == LB || Opcode == ADDI) ? ImmI :
						  (Opcode == AUIPC || Opcode == LUI) ? ImmU :
						  Opcode == S_TYPE ? ImmS : REG_o_1;

/* [4] Mem */
assign 	DM_i_fWE		= fWriteMem,
		DM_i_fReadEA	= fReadMem,
		DM_i_Addr	 	= ALU_o,
		DM_i 			= REG_o_1,
		DM_i_Size		= Funct3[1:0],		// byte = 2'b00, half word = 2'b01, word = 2'b10
		DM_i_fSignEx	= Funct3[2:1] == 0;

/* [5] WB */
assign 	REG_i_fWE		= Opcode != B_TYPE && Opcode != S_TYPE,
	 	REG_i 			= 	Opcode == LB ? DM_o : 
							(Opcode == J_TYPE || Opcode == JALR) ? {PC_p4, 2'b0} : ALU_o;							

	

/* PC module import */
always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) 					r_PC <= 0;
	else if(Opcode == JALR)		r_PC <= REG_o_0[31:2] + ImmI[29:0];				
	else if(fPCSrc)				r_PC <= r_PC + 
									(Opcode == B_TYPE ? ImmB[29:0] :
						  			 Opcode == J_TYPE ? ImmJ[29:0] : 29'b0);		// add offset
	else						r_PC <= PC_p4; 

assign o_PC = r_PC;

endmodule
