module KeyExpand ( /* 2nd */
    input      [127:0] i_Key,
    input      [3:0]   i_Rnd,
    input              i_fDec,
    output reg [127:0] o_Key
);

    /* Temporary Word Generation */
    reg [31:0] c_RCon, n_RCon;

    wire [31:0] LstWord, RotWord, SubWord, TempWord;
    
    assign LstWord  = i_fDec ? i_Key[63:32] ^ i_Key[31:0] : i_Key[31:0];
    assign RotWord  = { LstWord[23:16], LstWord[15:8], LstWord[7:0], LstWord[31:24] };
    assign TempWord = c_RCon ^ SubWord;

    SubBytes SB0( RotWord[  7:0], 1'b0, SubWord[  7:0] );
    SubBytes SB1( RotWord[ 15:8], 1'b0, SubWord[ 15:8] );
    SubBytes SB2( RotWord[23:16], 1'b0, SubWord[23:16] );
    SubBytes SB3( RotWord[31:24], 1'b0, SubWord[31:24] );

    always@* begin
        c_RCon = n_RCon;
    end
    
    always@* begin
        n_RCon = c_RCon;
        case(i_Rnd)
            4'h0 :    n_RCon = 32'h_01_00_00_00;
            4'h1 :    n_RCon = 32'h_02_00_00_00;
            4'h2 :    n_RCon = 32'h_04_00_00_00;
            4'h3 :    n_RCon = 32'h_08_00_00_00;
            4'h4 :    n_RCon = 32'h_10_00_00_00;
            4'h5 :    n_RCon = 32'h_20_00_00_00;
            4'h6 :    n_RCon = 32'h_40_00_00_00;
            4'h7 :    n_RCon = 32'h_80_00_00_00;
            4'h8 :    n_RCon = 32'h_1B_00_00_00;
            default : n_RCon = 32'h_36_00_00_00;
        endcase
    end

    /* Key Generation */
    always@* begin
        o_Key = i_fDec ?
                      {      TempWord ^ i_Key[127:96],
                        i_Key[127:96] ^ i_Key[ 95:64],
                        i_Key[ 95:64] ^ i_Key[ 63:32], 
                        i_Key[ 63:32] ^ i_Key[  31:0] }
                      :
                      { TempWord ^ i_Key[127:96],
                        TempWord ^ i_Key[127:96] ^ i_Key[95:64],
                        TempWord ^ i_Key[127:96] ^ i_Key[95:64] ^ i_Key[63:32],
                        TempWord ^ i_Key[127:96] ^ i_Key[95:64] ^ i_Key[63:32] ^ i_Key[31:0] };
    end

endmodule