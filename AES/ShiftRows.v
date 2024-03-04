module ShiftRows (
    input [127:0] i_Text,
    input i_fDec,
    output reg [127:0] o_Text
);

always@* begin
    if(i_fDec) begin
        o_Text = {
            i_Text[127:120], i_Text[23:16], i_Text[47:40], i_Text[71:64],
            i_Text[95:88], i_Text[119:112], i_Text[15:8], i_Text[39:32],
            i_Text[63:56], i_Text[87:80], i_Text[111:104], i_Text[7:0],
            i_Text[31:24], i_Text[55:48], i_Text[79:72], i_Text[103:96]
        };
    end else begin
        o_Text = {
            i_Text[127:120], i_Text[87:80], i_Text[47:40], i_Text[7:0],
            i_Text[95:88], i_Text[55:48], i_Text[15:8], i_Text[103:96],
            i_Text[63:56], i_Text[23:16], i_Text[111:104], i_Text[71:64],
            i_Text[31:24], i_Text[119:112], i_Text[79:72], i_Text[39:32]
        };
    end
end

endmodule