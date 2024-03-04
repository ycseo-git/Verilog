module tb_RV32I();


reg Clk;
reg Rst;

RV32I RISC_CORE(Clk, Rst);


always
begin
	#10 Clk = ~Clk;
end

initial
begin
	Clk = 1;
	Rst = 0;
	#5 Rst = 1; 
end

endmodule