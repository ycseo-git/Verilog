module DES(i_Clk, i_Rst, i_fStart, i_fDec, i_Key, i_Text, o_fDone, o_Text);

input					i_Clk, i_Rst, i_fStart, i_fDec;
input			[63:0]	i_Key, i_Text;
output	wire			o_fDone;
output	wire	[63:0]	o_Text;

/* registers */
reg		[3:0]	c_Rnd,	n_Rnd;		// Round : 0-15
reg		[1:0]	c_State,n_State;
reg		[31:0]	c_L,	n_L;		// Text - left  32 bits
reg 	[31:0]	c_R,	n_R;		// Text - right 32 bits
reg		[27:0]	c_C,	n_C;		// Key  - left  28 bits
reg		[27:0]	c_D,	n_D;		// Key	- right 28 bits

/* Transformations */
wire	[63:0] IP_o;
wire	[47:0] E_o;
wire	[31:0] SBOX_o;
wire	[31:0] P_o;
wire	[63:0] InvIP_o;

/* C, D (i_Key) */
wire	[55:0] PC1_o;
wire	[47:0] PC2_o;
wire	[27:0] Rot_C, Rot_D;

parameter	IDLE	= 2'b00,
 			ENC		= 2'b01,
			DEC		= 2'b10,
			DONE	= 2'b11;

/* outputs */
assign	o_fDone = c_State == DONE;
assign	o_Text	= o_fDone ? InvIP_o : 0;

/* sub-modules and their connections for text */
IP		IP0		(i_Text,		IP_o	);
E_Table	E0		(c_R,			E_o		);
SBOX 	SBOX0	(E_o ^ PC2_o,	SBOX_o	);
P_Table	P0		(SBOX_o,		P_o		);
InvIP	INV_IP0	({c_R, c_L},	InvIP_o	);

/* sub-modules and their connections for key */
PC1		PC1_0	(i_Key,		PC1_o);	// PC1_o: {C_0, D_0}
PC2		PC2_0	({c_C, c_D},PC2_o);	// PC2_o: K_(c_Rnd + 1)
	
/* key scheduling */
assign	fRot1b	= c_Rnd == 0 || c_Rnd == 7 || c_Rnd == 14 || c_Rnd == 15;

ROL	ROL0(c_C, c_State[1], fRot1b, Rot_C);
ROL	ROL1(c_D, c_State[1], fRot1b, Rot_D);

/* registers */
always@(posedge i_Clk or negedge i_Rst)
	if(!i_Rst) begin
		c_State	= IDLE;
		c_Rnd	= 0;
		c_L		= 0;
		c_R		= 0;
		c_C		= 0;
		c_D		= 0;
	end else begin	
		c_State	= n_State;
		c_Rnd	= n_Rnd;
		c_L		 = n_L;
		c_R		 = n_R;
		c_C		 = n_C;
		c_D		 = n_D;
	end	

/* finite state machine */
always@*
begin
	n_Rnd	= 0;
	n_State = c_State;
	n_L		= 0;
	n_R		= 0;
	n_C		= 0;
	n_D		= 0;
	case(c_State)
		IDLE : 
			if(i_fStart)	begin
				n_L = IP_o[63:32];	// L_0
				n_R = IP_o[31: 0];	// R_0
				if(i_fDec) begin
					n_State = DEC;
					n_C = PC1_o[55:28];	// C_1
					n_D = PC1_o[27: 0];	// D_1
				end else begin
					n_State = ENC;
					n_C = {PC1_o[54:28], PC1_o[55]};	// C_1
					n_D = {PC1_o[26: 0], PC1_o[27]};	// D_1
				end
			end
		default : begin
			n_L = c_R;				// L_1 ~ L_16
			n_R = c_L ^ P_o;		// R_1 ~ R_16
			n_C = Rot_C;			// C_2 ~ C_16, C_0
			n_D = Rot_D;			// D_2 ~ D_16, D_0
			n_Rnd = c_Rnd + 1;
			if(c_Rnd == 15)	n_State = DONE;
		end
		DONE	: n_State = IDLE;
	endcase
end

endmodule
