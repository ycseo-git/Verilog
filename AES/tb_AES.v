module tb_AES ();

reg i_Clk, i_Rst, i_fStart, i_fDec;
reg [127:0] i_Key, i_Text;

wire o_fDone;
wire [127:0] o_Text;

AES A0( i_Clk, i_Rst, i_fStart, i_fDec, i_Key, i_Text, o_fDone, o_Text );

always
#10 i_Clk = ~i_Clk;

initial 
begin
    i_Clk = 0;
    i_Rst = 0;
    @(negedge i_Clk) i_Rst = 1;
    
    i_fStart = 1; i_fDec = 1;
    i_Key = 128'h70337336763979244226452948404D63; // i_Text = 128'h566B59703273357638792F423F452848;
    i_Text = 128'h71a4d5f1009b926a22428735dd77a40c;
end

endmodule