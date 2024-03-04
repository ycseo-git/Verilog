module AES_Top ( /* 2nd */
    input       		 i_Clk,
    input       		 i_Rst,
    input       		 i_RX,
    output wire 		 o_TX,
    output wire [3:0]    o_LED
);

    /* Parameters */
    parameter IDLE    = 3'h0;
    parameter RX_KEY  = 3'h1;
    parameter RX_TEXT = 3'h2;
    parameter AES     = 3'h3;
    parameter TX_RES  = 3'h4;
    parameter TX_TEXT = 3'h5;

    /* Registers */
    reg [1:0]   c_Cmd,      n_Cmd;
    reg [2:0]   c_State,    n_State;
    reg [3:0]   c_ByteCnt,  n_ByteCnt;
    reg [127:0] c_Key, 	    n_Key;
    reg [127:0] c_Text,		n_Text;

    /* Wires */
    wire         fLstByte;

    wire         AES_i_fStart, AES_i_fDec, AES_o_fDone;
    wire [127:0] AES_i_Key, AES_i_Text, AES_o_Text;

    wire         RX_o_fDone;
    wire [7:0]   RX_o_Data;

    wire         TX_i_fTX,  TX_o_fDone;
    wire [7:0]   TX_i_Data, TX_o_fReady;

    /* Assignment */
	assign o_LED		= c_ByteCnt;
	 
    assign fLstByte     = &c_ByteCnt; /* c_ByteCnt == 3'h7 */

    assign AES_i_fStart = c_State == AES;
    assign AES_i_fDec   = c_Cmd[0];
    assign AES_i_Key    = (c_State == RX_KEY)  && RX_o_fDone && fLstByte ? c_Key  : AES_i_Key;
    assign AES_i_Text   = (c_State == RX_TEXT) && RX_o_fDone && fLstByte ? c_Text : AES_i_Text;

    assign TX_i_fTX     = TX_o_fReady && (c_State == TX_RES || c_State == TX_TEXT);
    assign TX_i_Data    = c_State == TX_RES ? c_Cmd : c_Text[127:120]; /* FIFO */

    /* Submodules */
    AES     A0( i_Clk, i_Rst, AES_i_fStart, AES_i_fDec, AES_i_Key, AES_i_Text, AES_o_fDone, AES_o_Text );
    UART_RX R0( i_Clk, i_Rst, i_RX, RX_o_fDone, RX_o_Data );
    UART_TX T0( i_Clk, i_Rst, TX_i_fTX, TX_i_Data, TX_o_fDone, TX_o_fReady, o_TX );

    /* Flip Flop */
    always@(posedge i_Clk, negedge i_Rst) begin
        if(!i_Rst) begin
            c_Cmd     = 0;
            c_ByteCnt = 0;
            c_Key     = 0;
            c_Text    = 0;
            c_State   = IDLE;
        end else begin
            c_Cmd     = n_Cmd;
            c_ByteCnt = n_ByteCnt;
            c_Key     = n_Key;
            c_Text    = n_Text;
            c_State   = n_State;
        end
    end

    /* Finite State Machine */
    always@* begin
        n_Cmd     = c_Cmd;
        n_ByteCnt = c_ByteCnt;
        n_Key     = c_Key;
        n_Text    = c_Text;
        n_State   = c_State;
        case(c_State)
            IDLE : begin
                if(RX_o_fDone) begin
                    n_Cmd   = RX_o_Data;
                    n_State = RX_o_Data[1] ? RX_TEXT : RX_KEY;
                end
            end
            RX_KEY : begin
                if(RX_o_fDone) begin
                    n_ByteCnt = n_ByteCnt + 1;
                    n_Key     = {c_Key[119:0], RX_o_Data};
                    n_State   = fLstByte ? TX_RES : c_State;
                end
            end
            RX_TEXT : begin
                if(RX_o_fDone) begin
                    n_ByteCnt = n_ByteCnt + 1;
                    n_Text    = {c_Text[119:0], RX_o_Data};
                    n_State   = fLstByte ? AES : c_State;
                end
            end
            AES : begin
                if(AES_o_fDone) begin
                    n_Text  = AES_o_Text;
                    n_State = TX_RES;
                end
            end
            TX_RES : begin
                if(TX_o_fDone) n_State = c_Cmd[1] ? TX_TEXT : IDLE;
            end
            TX_TEXT : begin
                if(TX_o_fDone) begin
                    n_Text    = {c_Text[119:0], 8'h0};
                    n_ByteCnt = c_ByteCnt + 1;
                    n_State   = fLstByte ? IDLE : c_State;
                end
            end
            endcase
    end
    
endmodule