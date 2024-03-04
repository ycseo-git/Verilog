module DES_top(
    input i_Clk,
    input i_Rst,
    input i_Rx,
    output wire o_Tx
);

/* Parameters */
parameter IDLE = 3'h1;
parameter RX_KEY = 3'h2;
parameter RX_TEXT = 3'h3;
parameter START_DES = 3'h4;
parameter WAIT_DES = 3'h5;
parameter TX_RES = 3'h6;
parameter TX_TEXT = 3'h7;

/* Registers */
reg [1:0] n_Cmd, c_Cmd;
reg [63:0] n_Key, c_Key;
reg [63:0] n_Text, c_Text;
reg [2:0] n_State, c_State;
reg [2:0] n_ByteCnt, c_ByteCnt;

/* Wires */
wire DES_i_fStart, DES_i_fDec;
wire [63:0] DES_i_Key, DES_i_Text;
wire DES_o_fDone;
wire [63:0] DES_o_Text;

wire RX_o_fDone;
wire [7:0] Rx_o_Data;

wire TX_i_fTx;
wire [7:0] TX_i_Data;
wire Tx_o_fDone, TX_o_fReady;

wire fLstByte;

/* Submodules */
DES DES0(i_Clk, i_Rst, DES_i_fStart, DES_i_fDec, DES_i_Key, DES_i_Text, DES_o_fDone, DES_o_Text);
UART_RX RX0(i_Clk, i_Rst, i_Rx, RX_o_fDone, Rx_o_Data);
UART_TX TX0(i_Clk, i_Rst, TX_i_fTx, TX_i_Data, Tx_o_fDone, TX_o_fReady, o_Tx);

/* Assign */
assign Tx_i_fTx = TX_o_fReady && (c_State == TX_RES || c_State == TX_TEXT);
assign Tx_i_Data = c_State == TX_RES ? c_Cmd : c_Text[63:56];
assign DES_i_fStart = c_State == START_DES;

assign DES_i_fDec = c_Cmd[0];
assign DES_i_Key = c_State == RX_KEY ? RX_o_fDone && fLstByte ? c_Key : DES_i_Key : DES_i_Key;
assign DES_i_Text = c_State == RX_TEXT ? RX_o_fDone && fLstByte ? c_Text : DES_i_Text : DES_i_Text;
assign fLstByte = &c_ByteCnt;

/* FF */
always@(posedge i_Clk, negedge i_Rst)
if(!i_Rst) begin
    c_Cmd = 0;
    c_Text = 0;
    c_Key = 0;
    c_ByteCnt = 0;
    c_State = IDLE;
end else begin
    c_Cmd = n_Cmd;
    c_Text = n_Text;
    c_Key = n_Key;
    c_ByteCnt = n_ByteCnt;
    c_State = n_State;
end

always@*
begin
    n_Cmd = c_Cmd;
    n_Text = c_Text;
    n_Key = c_Key;
    n_ByteCnt = 0;
    n_State = c_State;
    case(c_State)
    IDLE : begin 
        if (RX_o_fDone) begin
        n_Cmd = Rx_o_Data;
        if (Rx_o_Data[1]) n_State = RX_TEXT;
        else n_State = RX_KEY;
    end
    end
    RX_KEY : begin
        if (RX_o_fDone) begin
            n_Key = {c_Key[55:0], Rx_o_Data};
            n_ByteCnt = c_ByteCnt+1;
            if (fLstByte) n_State = TX_RES;
       else n_State = RX_KEY;
       end
    end
    RX_TEXT : begin
        n_Text = RX_o_fDone ? {c_Text[55:0], Rx_o_Data} : c_Text;
        n_ByteCnt = RX_o_fDone ? c_ByteCnt + 1 : c_ByteCnt;
        if (RX_o_fDone && fLstByte) n_State = START_DES;
        else n_State = RX_TEXT;
    end
    START_DES : begin
        n_State = WAIT_DES;
    end
    WAIT_DES : begin
        n_Text = DES_o_fDone ? DES_o_Text : c_Text;
        if(DES_o_fDone) n_State = TX_RES;
        else n_State = WAIT_DES;
    end
    TX_RES : begin
        n_State = Tx_o_fDone ? c_Cmd[1] ? TX_TEXT : IDLE : TX_RES;
    end
    TX_TEXT : begin
        n_Text = Tx_o_fDone ? {c_Text[55:0], Rx_o_Data} : c_Text;
        n_ByteCnt = Tx_o_fDone ? c_ByteCnt + 1 : c_ByteCnt;
        if (Tx_o_fDone && fLstByte) n_State = IDLE;
        else n_State = TX_TEXT;
    end
    endcase
end
endmodule