module DMEM(
	input				i_Clk, i_Rst,
	input				i_fWE,
	input				i_fRE,
	input		[1:0]	i_Size,
	input				i_fSignEx,
	input		[31:0]	i_Addr, i_Data,				
	output	reg	[31:0]	o_Data
);

parameter 	BYTE 		= 2'b00, 
			HALF_WORD 	= 2'b01, 
			WORD 		= 2'b10;

/* Registers */
reg 	[7:0]	r_Data [0:(2**12)-1]; 	// size? total 2^18
reg		[3:0]	fWE;
wire	[31:0]	RdData;
wire	[31:0]	WrData;
assign	RdData = {
	r_Data[{i_Addr[31:2], 2'h3}], 
	r_Data[{i_Addr[31:2], 2'h2}], 
	r_Data[{i_Addr[31:2], 2'h1}], 
	r_Data[{i_Addr[31:2], 2'h0}]};
assign	WrData = i_Size[1] ? i_Data : i_Size[0] ? {2{i_Data[15:0]}} : {4{i_Data[7:0]}};

always@*
begin
	fWE	= 4'b0;
	if(i_fWE)	
		case({i_Size, i_Addr[1:0]})
			// Byte writes are valid to any address
			4'b00_00 : fWE = 4'b0001;
			4'b00_01 : fWE = 4'b0010;
			4'b00_10 : fWE = 4'b0100;
			4'b00_11 : fWE = 4'b1000;
	    
			// Halfword writes are only valid to even addresses
			4'b01_00 : fWE = 4'b0011;
			4'b01_10 : fWE = 4'b1100;
			
			// Word writes are only valid to word aligned addresses
			4'b10_00 : fWE = 4'b1111;
			default  : fWE = 4'b0000;
		endcase

	o_Data	= 0;
	if(i_fRE)	
		case({i_Size, i_Addr[1:0]})
			// Byte writes are valid to any address
			4'b00_00 : o_Data = {{24{i_fSignEx & RdData[ 7]}}, RdData[ 0+:8]};
			4'b00_01 : o_Data = {{24{i_fSignEx & RdData[15]}}, RdData[ 8+:8]};
			4'b00_10 : o_Data = {{24{i_fSignEx & RdData[23]}}, RdData[16+:8]};
			4'b00_11 : o_Data = {{24{i_fSignEx & RdData[31]}}, RdData[24+:8]};
	
			// Halfword writes are only valid to even addresses
			4'b01_00 : o_Data = {{16{i_fSignEx & RdData[15]}}, RdData[ 0+:16]};
			4'b01_10 : o_Data = {{16{i_fSignEx & RdData[31]}}, RdData[16+:16]};
			
			// Word writes are only valid to word aligned addresses
			4'b10_00 : o_Data = RdData;
			default  : o_Data = 0;
		endcase
end

always@(posedge i_Clk) 
	 if (i_fWE) begin
	 	if(fWE[3])	r_Data[{i_Addr[31:2], 2'h3}] <= WrData[8*3+:8];
	 	if(fWE[2])	r_Data[{i_Addr[31:2], 2'h2}] <= WrData[8*2+:8];
	 	if(fWE[1])	r_Data[{i_Addr[31:2], 2'h1}] <= WrData[8*1+:8];
	 	if(fWE[0])	r_Data[{i_Addr[31:2], 2'h0}] <= WrData[8*0+:8];
	 end

endmodule
