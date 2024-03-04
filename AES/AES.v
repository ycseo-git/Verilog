module AES ( /* 2nd */
    input               i_Clk,
    input               i_Rst,
    input               i_fStart,
    input               i_fDec,
    input       [127:0] i_Key,
    input       [127:0] i_Text,
    output wire         o_fDone,
    output wire [127:0] o_Text
);

    /* Parameters */
    parameter IDLE    = 3'h0;
    parameter PRE_KEY = 3'h1;
    parameter RND     = 3'h2;
    parameter LST_RND = 3'h3;
    parameter DONE    = 3'h4;

    /* Registers */
    reg [2:0]   c_State, n_State;
    reg [3:0]   c_Rnd, n_Rnd;
    reg [127:0] c_Key, n_Key;
    reg [127:0] c_Text, n_Text;

    /* Wires */
    wire         KE_i_fDec;
    wire [127:0] KE_i_Key,  KE_o_Key;
    wire [127:0] SB_i_Text, SB_o_Text;
    wire [127:0] SR_i_Text, SR_o_Text;
    wire [127:0] MC_i_Text, MC_o_Text;

    /* Assignment */
    assign o_fDone   = c_State == DONE;
    assign o_Text    = o_fDone ? c_Text : 0;
    assign KE_i_fDec = i_fDec && (c_State == RND || c_State == LST_RND);
    assign KE_i_Key  = c_Key;
    assign SB_i_Text = i_fDec ? c_Text : KE_i_Key ^ c_Text;
    assign SR_i_Text = SB_o_Text;
    assign MC_i_Text = i_fDec ? SR_o_Text ^ KE_o_Key : SR_o_Text;

    /* Submodules */
    KeyExpand   KE0  ( KE_i_Key, c_Rnd, KE_i_fDec, KE_o_Key );

    SubBytes    SB0  ( SB_i_Text[127:120], i_fDec, SB_o_Text[127:120] );
    SubBytes    SB1  ( SB_i_Text[119:112], i_fDec, SB_o_Text[119:112] );
    SubBytes    SB2  ( SB_i_Text[111:104], i_fDec, SB_o_Text[111:104] );
    SubBytes    SB3  ( SB_i_Text[ 103:96], i_fDec, SB_o_Text[ 103:96] );
    SubBytes    SB4  ( SB_i_Text[  95:88], i_fDec, SB_o_Text[  95:88] );
    SubBytes    SB5  ( SB_i_Text[  87:80], i_fDec, SB_o_Text[  87:80] );

    SubBytes    SB6  ( SB_i_Text[  79:72], i_fDec, SB_o_Text[  79:72] );
    SubBytes    SB7  ( SB_i_Text[  71:64], i_fDec, SB_o_Text[  71:64] );
    SubBytes    SB8  ( SB_i_Text[  63:56], i_fDec, SB_o_Text[  63:56] );
    SubBytes    SB9  ( SB_i_Text[  55:48], i_fDec, SB_o_Text[  55:48] );
    SubBytes    SB10 ( SB_i_Text[  47:40], i_fDec, SB_o_Text[  47:40] );

    SubBytes    SB11 ( SB_i_Text[  39:32], i_fDec, SB_o_Text[  39:32] );
    SubBytes    SB12 ( SB_i_Text[  31:24], i_fDec, SB_o_Text[  31:24] );
    SubBytes    SB13 ( SB_i_Text[  23:16], i_fDec, SB_o_Text[  23:16] );
    SubBytes    SB14 ( SB_i_Text[   15:8], i_fDec, SB_o_Text[   15:8] );
    SubBytes    SB15 ( SB_i_Text[    7:0], i_fDec, SB_o_Text[    7:0] );

    ShiftRows   SR0  ( SR_i_Text, i_fDec, SR_o_Text );

    MixColumns  MC0  ( MC_i_Text[ 127:96], i_fDec, MC_o_Text[ 127:96] );
    MixColumns  MC1  ( MC_i_Text[  95:64], i_fDec, MC_o_Text[  95:64] );
    MixColumns  MC2  ( MC_i_Text[  63:32], i_fDec, MC_o_Text[  63:32] );
    MixColumns  MC3  ( MC_i_Text[   31:0], i_fDec, MC_o_Text[   31:0] );

    /* Flip Flop */
    always@(posedge i_Clk, negedge i_Rst) begin
        if(!i_Rst) begin
            c_State = IDLE;
            c_Rnd   = 0;
            c_Key   = 0;
            c_Text  = 0;
        end else begin
            c_State = n_State;
            c_Rnd   = n_Rnd;
            c_Key   = n_Key;
            c_Text  = n_Text;
        end
    end

    /* Finite State Machine */
    always@* begin
        n_State = c_State;
        n_Rnd   = c_Rnd;
        n_Key   = c_Key;
        n_Text  = c_Text;
        case(c_State)
            IDLE : begin
                n_Rnd   = 4'h0;
                if(i_fStart) begin
                    n_Key   = i_Key;
                    n_Text  = i_Text;  
                    n_State = i_fDec ? PRE_KEY : RND;
                end
            end
            PRE_KEY : begin
                n_Rnd = c_Rnd + 1;
                n_Key = KE_o_Key;
                if(c_Rnd == 9) begin
                    n_Rnd   = c_Rnd;
                    n_Text  = KE_o_Key ^ c_Text;
                    n_State = RND;
                end
            end
            RND : begin
                n_Key   = KE_o_Key;
                n_Text  = MC_o_Text;
                n_Rnd   = i_fDec ? c_Rnd - 1 : c_Rnd + 1;
                if(i_fDec) n_State = c_Rnd == 1 ? LST_RND : c_State;
                else       n_State = c_Rnd == 8 ? LST_RND : c_State;
            end
            LST_RND : begin
                n_Key   = KE_o_Key;
                n_Text  = SR_o_Text ^ KE_o_Key;
                n_State = DONE;
            end
            DONE : begin
                n_State = IDLE;
            end
        endcase
    end

endmodule