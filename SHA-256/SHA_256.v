   module SHA_256 (
    input               i_Clk,
    input               i_Rst,
    input               i_fStart,
    input               i_fInit,
    input       [511:0] i_Text,
    output wire         o_fDone,
    output wire [255:0] o_Text
  );

    /* Parameters */
    parameter IDLE    = 2'b00;
    parameter RND     = 2'b01;
    parameter LST_RND = 2'b10;
    parameter DONE    = 2'b11;

    /* Registers */
    reg [1:0]   c_State, n_State;
    reg [5:0]   c_Rnd,   n_Rnd;
    reg [31:0]  c_K,     n_K;
    reg [255:0] c_H,     n_H;
    reg [255:0] c_CV,    n_CV;
    reg [511:0] c_W,     n_W;

    /* Wires */  
    wire [31:0] W_1,  W_14;
    wire [31:0] LS_0, LS_1;

    wire [31:0] a, b, c, d, e, f, g, h;
    wire [31:0] T_0,   T_1;             /* CV means Chain Variable, LS means Lower Sigma, US means Upper Sigma, T means Temporary */
    wire [31:0] US_0,  US_1, Maj, Ch;
    wire [31:0] a_Out, e_Out;
    
    /* Assignment */
    assign o_fDone = c_State == DONE;
    assign o_Text  = o_fDone ? c_H : 0;
    
    /* Assignment - Define the 32-bit value W every round */
    assign W_1  = c_W[479:448];
    assign W_14 = c_W[63:32];

    assign LS_0 = { W_1[6:0],   W_1[31:7] }   ^ { W_1[17:0],  W_1[31:18] }  ^ { 3'h0,  W_1[31:3] };
    assign LS_1 = { W_14[16:0], W_14[31:17] } ^ { W_14[18:0], W_14[31:19] } ^ { 10'h0, W_14[31:10] };

    /* Assignment - Round Function */
    assign a = c_CV[255:224];
    assign b = c_CV[223:192];
    assign c = c_CV[191:160];
    assign d = c_CV[159:128];
    assign e = c_CV[127:96];
    assign f = c_CV[95:64];
    assign g = c_CV[63:32];
    assign h = c_CV[31:0];
    
    assign US_0  = { a[1:0], a[31:2] } ^ { a[12:0], a[31:13] } ^ { a[21:0], a[31:22] };
    assign US_1  = { e[5:0], e[31:6] } ^ { e[10:0], e[31:11] } ^ { e[24:0], e[31:25] };
    assign Maj   = ( a & b ) ^ ( a & c ) ^ ( b & c );
    assign Ch    = ( e & f ) ^ ( ~e & g );

    assign T_0   = US_0 + Maj;
    assign T_1   = h + US_1 + Ch + n_K + c_W[511:480];

    assign a_Out = T_0 + T_1;
    assign e_Out = T_1 + d;

    /* Flip-Flop */
    always@(posedge i_Clk, negedge i_Rst) begin
        if(!i_Rst) begin
            c_State = IDLE;
            c_Rnd   = 0;
            c_K     = 0;
            c_W     = 0;
            c_CV    = 0;
            c_H     = 0;
        end else begin
            c_State = n_State;
            c_Rnd   = n_Rnd;
            c_K     = n_K;
            c_W     = n_W;
            c_CV    = n_CV;
            c_H     = n_H;
        end
    end

    /* Finite State Machine */
    always@* begin
        n_State = c_State;
        n_Rnd   = c_Rnd;
        n_W     = c_W;
        n_CV    = c_CV;
        n_H     = c_H;
        case(c_State)
            IDLE    : begin
                n_Rnd = 6'h0;
                if(i_fStart) begin
                    n_W     = i_Text;
                    n_CV    = i_fInit ? { 32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a, 32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19 } : c_H;
                    n_H     = i_fInit ? { 32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a, 32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19 } : c_H;
                    n_State = RND;
                end
            end
            RND     : begin
                n_Rnd = c_Rnd + 1;
                n_CV  = { a_Out, a, b, c, e_Out, e, f, g };
                n_W   = { c_W[479:0], (c_W[511:480] + LS_0 + c_W[223:192] + LS_1) };
                if(c_Rnd == 63) n_State = LST_RND;
            end
            LST_RND : begin 
                n_H     = { c_H[255:224] + a, c_H[223:192] + b, c_H[191:160] + c, c_H[159:128] + d, 
                            c_H[127:96] + e, c_H[95:64] + f, c_H[63:32] + g, c_H[31:0] + h };  
                n_State = DONE;
            end
            DONE    : begin
                n_State = IDLE;
            end
        endcase
    end

    /* Define the 32-bit value K every round */
    always@* begin
        n_K = c_K;
        case(c_Rnd)
            6'h0  : n_K = 32'h428a2f98; 6'h1  : n_K = 32'h71374491; 6'h2  : n_K = 32'hb5c0fbcf; 6'h3    : n_K = 32'he9b5dba5;
            6'h4  : n_K = 32'h3956c25b; 6'h5  : n_K = 32'h59f111f1; 6'h6  : n_K = 32'h923f82a4; 6'h7    : n_K = 32'hab1c5ed5;
            6'h8  : n_K = 32'hd807aa98; 6'h9  : n_K = 32'h12835b01; 6'hA  : n_K = 32'h243185be; 6'hB    : n_K = 32'h550c7dc3;
            6'hC  : n_K = 32'h72be5d74; 6'hD  : n_K = 32'h80deb1fe; 6'hE  : n_K = 32'h9bdc06a7; 6'hF    : n_K = 32'hc19bf174;
            6'h10 : n_K = 32'he49b69c1; 6'h11 : n_K = 32'hefbe4786; 6'h12 : n_K = 32'h0fc19dc6; 6'h13   : n_K = 32'h240ca1cc;
            6'h14 : n_K = 32'h2de92c6f; 6'h15 : n_K = 32'h4a7484aa; 6'h16 : n_K = 32'h5cb0a9dc; 6'h17   : n_K = 32'h76f988da;
            6'h18 : n_K = 32'h983e5152; 6'h19 : n_K = 32'ha831c66d; 6'h1A : n_K = 32'hb00327c8; 6'h1B   : n_K = 32'hbf597fc7;
            6'h1C : n_K = 32'hc6e00bf3; 6'h1D : n_K = 32'hd5a79147; 6'h1E : n_K = 32'h06ca6351; 6'h1F   : n_K = 32'h14292967;
            6'h20 : n_K = 32'h27b70a85; 6'h21 : n_K = 32'h2e1b2138; 6'h22 : n_K = 32'h4d2c6dfc; 6'h23   : n_K = 32'h53380d13;
            6'h24 : n_K = 32'h650a7354; 6'h25 : n_K = 32'h766a0abb; 6'h26 : n_K = 32'h81c2c92e; 6'h27   : n_K = 32'h92722c85;
            6'h28 : n_K = 32'ha2bfe8a1; 6'h29 : n_K = 32'ha81a664b; 6'h2A : n_K = 32'hc24b8b70; 6'h2B   : n_K = 32'hc76c51a3;
            6'h2C : n_K = 32'hd192e819; 6'h2D : n_K = 32'hd6990624; 6'h2E : n_K = 32'hf40e3585; 6'h2F   : n_K = 32'h106aa070;
            6'h30 : n_K = 32'h19a4c116; 6'h31 : n_K = 32'h1e376c08; 6'h32 : n_K = 32'h2748774c; 6'h33   : n_K = 32'h34b0bcb5;
            6'h34 : n_K = 32'h391c0cb3; 6'h35 : n_K = 32'h4ed8aa4a; 6'h36 : n_K = 32'h5b9cca4f; 6'h37   : n_K = 32'h682e6ff3;
            6'h38 : n_K = 32'h748f82ee; 6'h39 : n_K = 32'h78a5636f; 6'h3A : n_K = 32'h84c87814; 6'h3B   : n_K = 32'h8cc70208;
            6'h3C : n_K = 32'h90befffa; 6'h3D : n_K = 32'ha4506ceb; 6'h3E : n_K = 32'hbef9a3f7; default : n_K = 32'hc67178f2;
        endcase
    end

endmodule

    