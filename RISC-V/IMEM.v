module IMEM ( 
	input				i_Clk,
	input 				i_Rst,
	input  wire [29:0] 	i_Addr,						
	output reg 	[31:0] 	o_Inst
	);

parameter MEM_MAX_LOG = 2**7-1;

/* Registers */
reg [31:0] r_Inst[0:MEM_MAX_LOG];

/* Assignment */
// assign o_Inst = Inst[i_Addr];

always@(posedge i_Clk, negedge i_Rst) begin
	r_Inst[0] 	<= 32'h_00000000;
	r_Inst[1] 	<= 32'h_00500513;		// 	addi a0, zero, 0x005 	
	r_Inst[2] 	<= 32'h_00a58633;		// 	add a2, a1, a0 			
	r_Inst[3] 	<= 32'h_00c576b3;		// 	and a3, a0, a2 			
	r_Inst[4] 	<= 32'h_0046f713;		// 	andi a4, a3, 0x004 		
	r_Inst[5] 	<= 32'h_00e567b3;		// 	or a5, a0, a4 			
	r_Inst[6] 	<= 32'h_0057e813;		// 	ori a6, a5, 0x005 		
	r_Inst[7] 	<= 32'h_00f748b3;		//  xor a7, a4, a5 			
	r_Inst[8] 	<= 32'h_0058c913;		// 	xori s2, a7, 0x005 		
	r_Inst[9] 	<= 32'h_0128a2b3;		//  slt t0, a7, s2	 		
	r_Inst[10] 	<= 32'h_00652313;		//  slti t1, a0, 0x006
	r_Inst[11] 	<= 32'h_00e919b3;		// 	sll s3, s2, a4
	r_Inst[12] 	<= 32'h_00391a13;		// 	slli s4, s2, 3
	r_Inst[13] 	<= 32'h_01195ab3;		//	srl s5, s2, a7 
	r_Inst[14] 	<= 32'h_00295b13;		//	srli s6, s2, 2 
	r_Inst[15] 	<= 32'h_00001bb7;		//	lui s7, 1
	r_Inst[16] 	<= 32'h_00001c17;		//	auipc s8, 1
	r_Inst[17] 	<= 32'h_0020016f;		//	jal sp, 1                 	
	r_Inst[18] 	<= 32'h_013981e7;		//	jalr gp, s3, 19				
	r_Inst[19]	<= 32'h_00c68263;		//	beq a2, a3, 2  								    
	r_Inst[20] 	<= 32'h_00130313;		//	addi t1, t1, 1			
	r_Inst[21] 	<= 32'h_00c69263;		//  bne a2, a3, 2	
	r_Inst[22] 	<= 32'h_00230313;		//	addi t1, t1, 2
	r_Inst[23] 	<= 32'h_00c6c263;		//	blt a2, a3, 2
	r_Inst[24] 	<= 32'h_00330313;		//	addi t1, t1, 3
	r_Inst[25] 	<= 32'h_00c6d263;		//	bge a2, a3, 2
	r_Inst[26] 	<= 32'h_00430313;		//	addi t1, t1, 4	
	r_Inst[27] 	<= 32'h_00500413;		//	addi s0, zero, 0x005						
	r_Inst[28] 	<= 32'h_00802223;		//	sw s0, 0x004(zero)
	r_Inst[29] 	<= 32'h_00402383;		//	lw t2, 0x004(zero)
	r_Inst[30] 	<= 32'h_00200e13;		//	addi t3, zero, 0x002
	r_Inst[31]	<= 32'h_01c01123;		//	sh t3, 0x002(zero)
	r_Inst[32]	<= 32'h_00201e83;		//	lh t4, 0x002(zero)
	r_Inst[33] 	<= 32'h_00400f13;		//	addi t5, zero, 0x004
	r_Inst[34]	<= 32'h_01e000a3;		//	sb t5, 0x001(zero)
	r_Inst[35]	<= 32'h_00100f83;		//	lb t6, 0x001(zero)
end

always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		o_Inst <= 0;
	end else begin
		o_Inst <= r_Inst[i_Addr];
	end
endmodule

// int square(int num) {
//     return num + num;
// }
// branch는 사이트에서 4배수로밖에 지원하지 않기 때문에 2를 8로



// 0000 0000 1011 0101 0(000) 0010 0110 0011
// 0 0 d 6 _ 2 6 3

// jal sp, 2 >> 32'h_0040016f
// jal sp, 1 >> 32'h_0020016f


// sb t0, 0x001(zero)
// 0000 0000 0101 0000 0010 0010 0010 0011
// 0 0 5 0 0 0 a 3

// bge a2, a3, 2
// 0000 0000 1100 0110 1101 0010 0110 0011
// 0 0 c 6 d 2 6 3
// Inst[25] 	<= 32'h_00d65263;		//	bge a2, a3, 2

// beq a2, a3, 2
// 0000 0000 1100 0110 1000 0010 0110 0011
// 0 0 c 6 8 2 6 3
// Inst[19]	<= 32'h_00d60263;		//	beq a2, a3, 2

// blt a2, a3, 2
// 0000 0000 1100 0110 1100 0010 0110 0011
// 0 0 c 6 c 2 6 3

// bne a2, a3, 2
// 0000 0000 1100 0110 1001 0010 0110 0011
// 0 0 c 6 9 2 6 3

// sub s1, a3, a4
// 0100 0000 1110 0110 1000 0100 1011 0011
// 4 0 e 6 8 4 b 3