module SHA_256_Top (
    input             i_Clk,
    input             i_Rst,
    input             i_RX,
    output wire       o_TX,
    output wire [6:0] o_LED /* LED for debugging */
);  /* No padding */
    
    /* Parameters */
    parameter IDLE    = 2'h0;
    parameter SHA     = 2'h1;
    parameter TX_TEXT = 2'h2;

    /* Registers */
    reg         c_Init,         n_Init;
    reg [1:0]   c_State,        n_State;
    reg [4:0]   c_ByteCnt_Out,  n_ByteCnt_Out;
    reg [5:0]   c_ByteCnt,      n_ByteCnt;
    reg [511:0] c_Text,         n_Text;

    /* Wires */
    wire         fLstByte;

    wire         RX_o_fDone;
    wire [7:0]   RX_o_Data;

    wire         TX_i_fTX, TX_o_fDone, TX_o_fReady;
    wire [7:0]   TX_i_Data;

    wire         SHA_i_fStart, SHA_i_fInit, SHA_o_fDone;
    wire [255:0] SHA_o_Text;
    wire [511:0] SHA_i_Text;

    /* Assignment */
    assign o_LED        = {c_Init, c_ByteCnt}; /* 7-bit LED for debugging */

    assign fLstByte     = &c_ByteCnt;
    
    assign TX_i_fTX     = TX_o_fReady && c_State[1];
    assign TX_i_Data    = c_State == TX_TEXT ? c_Text[511:504] : TX_i_Data; // Out

    assign SHA_i_fStart = c_State == SHA;
    assign SHA_i_fInit  = c_Init;
    assign SHA_i_Text   = c_State == SHA ? c_Text : SHA_i_Text;

    /* Submodules */
    SHA_256 S0( i_Clk, i_Rst, SHA_i_fStart, SHA_i_fInit, SHA_i_Text, SHA_o_fDone, SHA_o_Text );
    UART_RX R0( i_Clk, i_Rst, i_RX, RX_o_fDone, RX_o_Data );
    UART_TX T0( i_Clk, i_Rst, TX_i_fTX, TX_i_Data, TX_o_fDone, TX_o_fReady, o_TX );

    /* FF */
    always@(posedge i_Clk, negedge i_Rst) begin
        if(!i_Rst) begin
            c_Init          = 1'b1;
            c_State         = IDLE;
            c_ByteCnt_Out   = 0;
            c_ByteCnt       = 0;
            c_Text          = 0;
        end else begin
            c_Init          = n_Init;
            c_State         = n_State;
            c_ByteCnt_Out   = n_ByteCnt_Out;
            c_ByteCnt       = n_ByteCnt;
            c_Text          = n_Text;
        end
    end

    /* FSM */
    always@* begin
        n_Init          = c_Init;
        n_State         = c_State;
        n_ByteCnt_Out   = c_ByteCnt_Out;
        n_ByteCnt       = c_ByteCnt;
        n_Text          = c_Text;
        case(c_State)
            IDLE : begin
                n_ByteCnt_Out = 0;
                if(RX_o_fDone) begin
                    n_Text    = {c_Text[503:0], RX_o_Data};
                    n_ByteCnt = c_ByteCnt + 1;
                    n_State   = fLstByte ? SHA : c_State;
                end
			end
            SHA : begin
                if(SHA_o_fDone) begin
                    n_Text      = {SHA_o_Text, 256'h0};
                    n_State     = TX_TEXT;
                end
            end
            TX_TEXT : begin
                if(TX_o_fDone) begin
                    n_Init          = 1'b0;
                    n_ByteCnt_Out   = c_ByteCnt_Out + 1;
                    n_Text          = {c_Text[503:0], 8'h0};
                    n_State         = &c_ByteCnt_Out ? IDLE : c_State;
                end
            end
        endcase
    end

endmodule