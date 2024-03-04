module tb_SHA_256 ();

reg         i_Clk, i_Rst;
reg         i_fStart;
reg         i_fInit;
reg [511:0] i_Text;


wire         o_fDone;
wire [255:0] o_Text;

SHA_256 S0( i_Clk, i_Rst, i_fStart, i_fInit, i_Text, o_fDone, o_Text );

always
#10 i_Clk = ~i_Clk;

initial 
begin
    i_Clk = 0;
    i_Rst = 0;
    @(negedge i_Clk) i_Rst = 1;
    
    #50 i_fStart = 1'b1;
        i_fInit  = 1'b1;
        i_Text   = 512'h30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030;
end

endmodule 