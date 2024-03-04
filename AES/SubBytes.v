module SubBytes (
    input [7:0] i_Text,
    input i_fDec,
    output reg [7:0] o_Text
);

always@* begin
    if(i_fDec) begin
    case(i_Text[3:0]) /* Inverse S-Box */
		4'h0 : case(i_Text[7:4])
                4'h0 : 	o_Text <= 8'h52;
                4'h1 : 	o_Text <= 8'h7c;
                4'h2 : 	o_Text <= 8'h54;
                4'h3 : 	o_Text <= 8'h8;
                4'h4 : 	o_Text <= 8'h72;
                4'h5 : 	o_Text <= 8'h6c;
                4'h6 : 	o_Text <= 8'h90;
                4'h7 : 	o_Text <= 8'hd0;
                4'h8 : 	o_Text <= 8'h3a;
                4'h9 : 	o_Text <= 8'h96;
                4'hA : 	o_Text <= 8'h47;
                4'hB : 	o_Text <= 8'hfc;
                4'hC : 	o_Text <= 8'h1f;
                4'hD : 	o_Text <= 8'h60;
                4'hE : 	o_Text <= 8'ha0;
                4'hF : 	o_Text <= 8'h17;
        endcase
		4'h1 : case(i_Text[7:4])
        		4'h0 : 	o_Text <= 8'h9;
				4'h1 : 	o_Text <= 8'he3;
				4'h2 : 	o_Text <= 8'h7b;
				4'h3 : 	o_Text <= 8'h2e;
				4'h4 : 	o_Text <= 8'hf8;
				4'h5 : 	o_Text <= 8'h70;
				4'h6 : 	o_Text <= 8'hd8;
				4'h7 : 	o_Text <= 8'h2c;
				4'h8 : 	o_Text <= 8'h91;
				4'h9 : 	o_Text <= 8'hac;
				4'hA : 	o_Text <= 8'hf1;
				4'hB : 	o_Text <= 8'h56;
				4'hC : 	o_Text <= 8'hdd;
				4'hD : 	o_Text <= 8'h51;
				4'hE : 	o_Text <= 8'he0;
				4'hF : 	o_Text <= 8'h2b;
        endcase
		4'h2 : case(i_Text[7:4])
        		4'h0 : 	o_Text <= 8'h6a;
				4'h1 : 	o_Text <= 8'h39;
				4'h2 : 	o_Text <= 8'h94;
				4'h3 : 	o_Text <= 8'ha1;
				4'h4 : 	o_Text <= 8'hf6;
				4'h5 : 	o_Text <= 8'h48;
				4'h6 : 	o_Text <= 8'hab;
				4'h7 : 	o_Text <= 8'h1e;
				4'h8 : 	o_Text <= 8'h11;
				4'h9 : 	o_Text <= 8'h74;
				4'hA : 	o_Text <= 8'h1a;
				4'hB : 	o_Text <= 8'h3e;
				4'hC : 	o_Text <= 8'ha8;
				4'hD : 	o_Text <= 8'h7f;
				4'hE : 	o_Text <= 8'h3b;
				4'hF : 	o_Text <= 8'h4;
        endcase
		4'h3 : case(i_Text[7:4])
        		4'h0 : 	o_Text <= 8'hd5;
				4'h1 : 	o_Text <= 8'h82;
				4'h2 : 	o_Text <= 8'h32;
				4'h3 : 	o_Text <= 8'h66;
				4'h4 : 	o_Text <= 8'h64;
				4'h5 : 	o_Text <= 8'h50;
				4'h6 : 	o_Text <= 8'h0;
				4'h7 : 	o_Text <= 8'h8f;
				4'h8 : 	o_Text <= 8'h41;
				4'h9 : 	o_Text <= 8'h22;
				4'hA : 	o_Text <= 8'h71;
				4'hB : 	o_Text <= 8'h4b;
				4'hC : 	o_Text <= 8'h33;
				4'hD : 	o_Text <= 8'ha9;
				4'hE : 	o_Text <= 8'h4d;
				4'hF : 	o_Text <= 8'h7e;
		endcase
        4'h4 : case(i_Text[7:4])
        		4'h0 : 	o_Text <= 8'h30;
				4'h1 : 	o_Text <= 8'h9b;
				4'h2 : 	o_Text <= 8'ha6;
				4'h3 : 	o_Text <= 8'h28;
				4'h4 : 	o_Text <= 8'h86;
				4'h5 : 	o_Text <= 8'hfd;
				4'h6 : 	o_Text <= 8'h8c;
				4'h7 : 	o_Text <= 8'hca;
				4'h8 : 	o_Text <= 8'h4f;
				4'h9 : 	o_Text <= 8'he7;
				4'hA : 	o_Text <= 8'h1d;
				4'hB : 	o_Text <= 8'hc6;
				4'hC : 	o_Text <= 8'h88;
				4'hD : 	o_Text <= 8'h19;
				4'hE : 	o_Text <= 8'hae;
				4'hF : 	o_Text <= 8'hba;
		endcase
        4'h5 : case(i_Text[7:4])
        		4'h0 : 	o_Text <= 8'h36;
				4'h1 : 	o_Text <= 8'h2f;
				4'h2 : 	o_Text <= 8'hc2;
				4'h3 : 	o_Text <= 8'hd9;
				4'h4 : 	o_Text <= 8'h68;
				4'h5 : 	o_Text <= 8'hed;
				4'h6 : 	o_Text <= 8'hbc;
				4'h7 : 	o_Text <= 8'h3f;
				4'h8 : 	o_Text <= 8'h67;
				4'h9 : 	o_Text <= 8'had;
				4'hA : 	o_Text <= 8'h29;
				4'hB : 	o_Text <= 8'hd2;
				4'hC : 	o_Text <= 8'h7;
				4'hD : 	o_Text <= 8'hb5;
				4'hE : 	o_Text <= 8'h2a;
				4'hF : 	o_Text <= 8'h77;
		endcase
        4'h6 : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'ha5;
				4'h1 : 	o_Text <= 8'hff;
				4'h2 : 	o_Text <= 8'h23;
				4'h3 : 	o_Text <= 8'h24;
				4'h4 : 	o_Text <= 8'h98;
				4'h5 : 	o_Text <= 8'hb9;
				4'h6 : 	o_Text <= 8'hd3;
				4'h7 : 	o_Text <= 8'h0f;
				4'h8 : 	o_Text <= 8'hdc;
				4'h9 : 	o_Text <= 8'h35;
				4'hA : 	o_Text <= 8'hc5;
				4'hB : 	o_Text <= 8'h79;
				4'hC : 	o_Text <= 8'hc7;
				4'hD : 	o_Text <= 8'h4a;
				4'hE : 	o_Text <= 8'hf5;
				4'hF : 	o_Text <= 8'hd6;
		endcase
        4'h7 : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'h38;
				4'h1 : 	o_Text <= 8'h87;
				4'h2 : 	o_Text <= 8'h3d;
				4'h3 : 	o_Text <= 8'hb2;
				4'h4 : 	o_Text <= 8'h16;
				4'h5 : 	o_Text <= 8'hda;
				4'h6 : 	o_Text <= 8'h0a;
				4'h7 : 	o_Text <= 8'h2;
				4'h8 : 	o_Text <= 8'hea;
				4'h9 : 	o_Text <= 8'h85;
				4'hA : 	o_Text <= 8'h89;
				4'hB : 	o_Text <= 8'h20;
				4'hC : 	o_Text <= 8'h31;
				4'hD : 	o_Text <= 8'h0d;
				4'hE : 	o_Text <= 8'hb0;
				4'hF : 	o_Text <= 8'h26;
		endcase
        4'h8 : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'hbf;
				4'h1 : 	o_Text <= 8'h34;
				4'h2 : 	o_Text <= 8'hee;
				4'h3 : 	o_Text <= 8'h76;
				4'h4 : 	o_Text <= 8'hd4;
				4'h5 : 	o_Text <= 8'h5e;
				4'h6 : 	o_Text <= 8'hf7;
				4'h7 : 	o_Text <= 8'hc1;
				4'h8 : 	o_Text <= 8'h97;
				4'h9 : 	o_Text <= 8'he2;
				4'hA : 	o_Text <= 8'h6f;
				4'hB : 	o_Text <= 8'h9a;
				4'hC : 	o_Text <= 8'hb1;
				4'hD : 	o_Text <= 8'h2d;
				4'hE : 	o_Text <= 8'hc8;
				4'hF : 	o_Text <= 8'he1;
		endcase
        4'h9 : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'h40;
				4'h1 : 	o_Text <= 8'h8e;
				4'h2 : 	o_Text <= 8'h4c;
				4'h3 : 	o_Text <= 8'h5b;
				4'h4 : 	o_Text <= 8'ha4;
				4'h5 : 	o_Text <= 8'h15;
				4'h6 : 	o_Text <= 8'he4;
				4'h7 : 	o_Text <= 8'haf;
				4'h8 : 	o_Text <= 8'hf2;
				4'h9 : 	o_Text <= 8'hf9;
				4'hA : 	o_Text <= 8'hb7;
				4'hB : 	o_Text <= 8'hdb;
				4'hC : 	o_Text <= 8'h12;
				4'hD : 	o_Text <= 8'he5;
				4'hE : 	o_Text <= 8'heb;
				4'hF : 	o_Text <= 8'h69;
		endcase
        4'hA : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'ha3;
				4'h1 : 	o_Text <= 8'h43;
				4'h2 : 	o_Text <= 8'h95;
				4'h3 : 	o_Text <= 8'ha2;
				4'h4 : 	o_Text <= 8'h5c;
				4'h5 : 	o_Text <= 8'h46;
				4'h6 : 	o_Text <= 8'h58;
				4'h7 : 	o_Text <= 8'hbd;
				4'h8 : 	o_Text <= 8'hcf;
				4'h9 : 	o_Text <= 8'h37;
				4'hA : 	o_Text <= 8'h62;
				4'hB : 	o_Text <= 8'hc0;
				4'hC : 	o_Text <= 8'h10;
				4'hD : 	o_Text <= 8'h7a;
				4'hE : 	o_Text <= 8'hbb;
				4'hF : 	o_Text <= 8'h14;
		endcase
        4'hB : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'h9e;
				4'h1 : 	o_Text <= 8'h44;
				4'h2 : 	o_Text <= 8'h0b;
				4'h3 : 	o_Text <= 8'h49;
				4'h4 : 	o_Text <= 8'hcc;
				4'h5 : 	o_Text <= 8'h57;
				4'h6 : 	o_Text <= 8'h5;
				4'h7 : 	o_Text <= 8'h3;
				4'h8 : 	o_Text <= 8'hce;
				4'h9 : 	o_Text <= 8'he8;
				4'hA : 	o_Text <= 8'h0e;
				4'hB : 	o_Text <= 8'hfe;
				4'hC : 	o_Text <= 8'h59;
				4'hD : 	o_Text <= 8'h9f;
				4'hE : 	o_Text <= 8'h3c;
				4'hF : 	o_Text <= 8'h63;
		endcase
        4'hC : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'h81;
				4'h1 : 	o_Text <= 8'hc4;
				4'h2 : 	o_Text <= 8'h42;
				4'h3 : 	o_Text <= 8'h6d;
				4'h4 : 	o_Text <= 8'h5d;
				4'h5 : 	o_Text <= 8'ha7;
				4'h6 : 	o_Text <= 8'hb8;
				4'h7 : 	o_Text <= 8'h1;
				4'h8 : 	o_Text <= 8'hf0;
				4'h9 : 	o_Text <= 8'h1c;
				4'hA : 	o_Text <= 8'haa;
				4'hB : 	o_Text <= 8'h78;
				4'hC : 	o_Text <= 8'h27;
				4'hD : 	o_Text <= 8'h93;
				4'hE : 	o_Text <= 8'h83;
				4'hF : 	o_Text <= 8'h55;
		endcase
        4'hD : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'hf3;
				4'h1 : 	o_Text <= 8'hde;
				4'h2 : 	o_Text <= 8'hfa;
				4'h3 : 	o_Text <= 8'h8b;
				4'h4 : 	o_Text <= 8'h65;
				4'h5 : 	o_Text <= 8'h8d;
				4'h6 : 	o_Text <= 8'hb3;
				4'h7 : 	o_Text <= 8'h13;
				4'h8 : 	o_Text <= 8'hb4;
				4'h9 : 	o_Text <= 8'h75;
				4'hA : 	o_Text <= 8'h18;
				4'hB : 	o_Text <= 8'hcd;
				4'hC : 	o_Text <= 8'h80;
				4'hD : 	o_Text <= 8'hc9;
				4'hE : 	o_Text <= 8'h53;
				4'hF : 	o_Text <= 8'h21;
		endcase
        4'hE : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'hd7;
				4'h1 : 	o_Text <= 8'he9;
				4'h2 : 	o_Text <= 8'hc3;
				4'h3 : 	o_Text <= 8'hd1;
				4'h4 : 	o_Text <= 8'hb6;
				4'h5 : 	o_Text <= 8'h9d;
				4'h6 : 	o_Text <= 8'h45;
				4'h7 : 	o_Text <= 8'h8a;
				4'h8 : 	o_Text <= 8'he6;
				4'h9 : 	o_Text <= 8'hdf;
				4'hA : 	o_Text <= 8'hbe;
				4'hB : 	o_Text <= 8'h5a;
				4'hC : 	o_Text <= 8'hec;
				4'hD : 	o_Text <= 8'h9c;
				4'hE : 	o_Text <= 8'h99;
				4'hF : 	o_Text <= 8'h0c;
		endcase
        4'hF : case(i_Text[7:4])
				4'h0 : 	o_Text <= 8'hfb;
				4'h1 : 	o_Text <= 8'hcb;
				4'h2 : 	o_Text <= 8'h4e;
				4'h3 : 	o_Text <= 8'h25;
				4'h4 : 	o_Text <= 8'h92;
				4'h5 : 	o_Text <= 8'h84;
				4'h6 : 	o_Text <= 8'h6;
				4'h7 : 	o_Text <= 8'h6b;
				4'h8 : 	o_Text <= 8'h73;
				4'h9 : 	o_Text <= 8'h6e;
				4'hA : 	o_Text <= 8'h1b;
				4'hB : 	o_Text <= 8'hf4;
				4'hC : 	o_Text <= 8'h5f;
				4'hD : 	o_Text <= 8'hef;
				4'hE : 	o_Text <= 8'h61;
				4'hF : 	o_Text <= 8'h7d;
        endcase
    endcase
    end else begin
        case(i_Text[3:0]) /* Forward S-Box */
        4'h0 : case(i_Text[7:4])
                4'h0 : 	o_Text <= 8'h63;
                4'h1 : 	o_Text <= 8'hca;
                4'h2 : 	o_Text <= 8'hb7;
                4'h3 : 	o_Text <= 8'h4;
                4'h4 : 	o_Text <= 8'h9;
                4'h5 : 	o_Text <= 8'h53;
                4'h6 : 	o_Text <= 8'hd0;
                4'h7 : 	o_Text <= 8'h51;
                4'h8 : 	o_Text <= 8'hcd;
                4'h9 : 	o_Text <= 8'h60;
                4'hA : 	o_Text <= 8'he0;
                4'hB : 	o_Text <= 8'he7;
                4'hC : 	o_Text <= 8'hba;
                4'hD : 	o_Text <= 8'h70;
                4'hE : 	o_Text <= 8'he1;
                4'hF : 	o_Text <= 8'h8c;
    	endcase
    	4'h1 : case(i_Text[7:4])
                4'h0 : 	o_Text <= 8'h7c;
                4'h1 : 	o_Text <= 8'h82;
                4'h2 : 	o_Text <= 8'hfd;
                4'h3 : 	o_Text <= 8'hc7;
                4'h4 : 	o_Text <= 8'h83;
                4'h5 : 	o_Text <= 8'hd1;
                4'h6 : 	o_Text <= 8'hef;
                4'h7 : 	o_Text <= 8'ha3;
                4'h8 : 	o_Text <= 8'h0c;
                4'h9 : 	o_Text <= 8'h81;
                4'hA : 	o_Text <= 8'h32;
                4'hB : 	o_Text <= 8'hc8;
                4'hC : 	o_Text <= 8'h78;
                4'hD : 	o_Text <= 8'h3e;
                4'hE : 	o_Text <= 8'hf8;
                4'hF : 	o_Text <= 8'ha1;
    	endcase
    	4'h2 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h77;
			    4'h1 : 	o_Text <= 8'hc9;
			    4'h2 : 	o_Text <= 8'h93;
			    4'h3 : 	o_Text <= 8'h23;
			    4'h4 : 	o_Text <= 8'h2c;
			    4'h5 : 	o_Text <= 8'h0;
			    4'h6 : 	o_Text <= 8'haa;
			    4'h7 : 	o_Text <= 8'h40;
			    4'h8 : 	o_Text <= 8'h13;
			    4'h9 : 	o_Text <= 8'h4f;
			    4'hA : 	o_Text <= 8'h3a;
			    4'hB : 	o_Text <= 8'h37;
			    4'hC : 	o_Text <= 8'h25;
			    4'hD : 	o_Text <= 8'hb5;
			    4'hE : 	o_Text <= 8'h98;
			    4'hF : 	o_Text <= 8'h89;
    	endcase
    	4'h3 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h7b;
				4'h1 : 	o_Text <= 8'h7d;
				4'h2 : 	o_Text <= 8'h26;
				4'h3 : 	o_Text <= 8'hc3;
				4'h4 : 	o_Text <= 8'h1a;
				4'h5 : 	o_Text <= 8'hed;
				4'h6 : 	o_Text <= 8'hfb;
				4'h7 : 	o_Text <= 8'h8f;
				4'h8 : 	o_Text <= 8'hec;
				4'h9 : 	o_Text <= 8'hdc;
				4'hA : 	o_Text <= 8'h0a;
				4'hB : 	o_Text <= 8'h6d;
				4'hC : 	o_Text <= 8'h2e;
				4'hD : 	o_Text <= 8'h66;
				4'hE : 	o_Text <= 8'h11;
				4'hF : 	o_Text <= 8'h0d;
    	endcase
    	4'h4 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'hf2;
				4'h1 : 	o_Text <= 8'hfa;
				4'h2 : 	o_Text <= 8'h36;
				4'h3 : 	o_Text <= 8'h18;
				4'h4 : 	o_Text <= 8'h1b;
				4'h5 : 	o_Text <= 8'h20;
				4'h6 : 	o_Text <= 8'h43;
				4'h7 : 	o_Text <= 8'h92;
				4'h8 : 	o_Text <= 8'h5f;
				4'h9 : 	o_Text <= 8'h22;
				4'hA : 	o_Text <= 8'h49;
				4'hB : 	o_Text <= 8'h8d;
				4'hC : 	o_Text <= 8'h1c;
				4'hD : 	o_Text <= 8'h48;
				4'hE : 	o_Text <= 8'h69;
				4'hF : 	o_Text <= 8'hbf;
    	endcase
    	4'h5 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h6b;
				4'h1 : 	o_Text <= 8'h59;
				4'h2 : 	o_Text <= 8'h3f;
				4'h3 : 	o_Text <= 8'h96;
				4'h4 : 	o_Text <= 8'h6e;
				4'h5 : 	o_Text <= 8'hfc;
				4'h6 : 	o_Text <= 8'h4d;
				4'h7 : 	o_Text <= 8'h9d;
				4'h8 : 	o_Text <= 8'h97;
				4'h9 : 	o_Text <= 8'h2a;
				4'hA : 	o_Text <= 8'h6;
				4'hB : 	o_Text <= 8'hd5;
				4'hC : 	o_Text <= 8'ha6;
				4'hD : 	o_Text <= 8'h3;
				4'hE : 	o_Text <= 8'hd9;
				4'hF : 	o_Text <= 8'he6;
    	endcase
    	4'h6 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h6f;
				4'h1 : 	o_Text <= 8'h47;
				4'h2 : 	o_Text <= 8'hf7;
				4'h3 : 	o_Text <= 8'h5;
				4'h4 : 	o_Text <= 8'h5a;
				4'h5 : 	o_Text <= 8'hb1;
				4'h6 : 	o_Text <= 8'h33;
				4'h7 : 	o_Text <= 8'h38;
				4'h8 : 	o_Text <= 8'h44;
				4'h9 : 	o_Text <= 8'h90;
				4'hA : 	o_Text <= 8'h24;
				4'hB : 	o_Text <= 8'h4e;
				4'hC : 	o_Text <= 8'hb4;
				4'hD : 	o_Text <= 8'hf6;
				4'hE : 	o_Text <= 8'h8e;
				4'hF : 	o_Text <= 8'h42;

    	endcase
    	4'h7 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'hc5;
				4'h1 : 	o_Text <= 8'hf0;
				4'h2 : 	o_Text <= 8'hcc;
				4'h3 : 	o_Text <= 8'h9a;
				4'h4 : 	o_Text <= 8'ha0;
				4'h5 : 	o_Text <= 8'h5b;
				4'h6 : 	o_Text <= 8'h85;
				4'h7 : 	o_Text <= 8'hf5;
				4'h8 : 	o_Text <= 8'h17;
				4'h9 : 	o_Text <= 8'h88;
				4'hA : 	o_Text <= 8'h5c;
				4'hB : 	o_Text <= 8'ha9;
				4'hC : 	o_Text <= 8'hc6;
				4'hD : 	o_Text <= 8'h0e;
				4'hE : 	o_Text <= 8'h94;
				4'hF : 	o_Text <= 8'h68;
    	endcase
    	4'h8 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h30;
				4'h1 : 	o_Text <= 8'had;
				4'h2 : 	o_Text <= 8'h34;
				4'h3 : 	o_Text <= 8'h7;
				4'h4 : 	o_Text <= 8'h52;
				4'h5 : 	o_Text <= 8'h6a;
				4'h6 : 	o_Text <= 8'h45;
				4'h7 : 	o_Text <= 8'hbc;
				4'h8 : 	o_Text <= 8'hc4;
				4'h9 : 	o_Text <= 8'h46;
				4'hA : 	o_Text <= 8'hc2;
				4'hB : 	o_Text <= 8'h6c;
				4'hC : 	o_Text <= 8'he8;
				4'hD : 	o_Text <= 8'h61;
				4'hE : 	o_Text <= 8'h9b;
				4'hF : 	o_Text <= 8'h41;
    	endcase
    	4'h9 : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h1;
				4'h1 : 	o_Text <= 8'hd4;
				4'h2 : 	o_Text <= 8'ha5;
				4'h3 : 	o_Text <= 8'h12;
				4'h4 : 	o_Text <= 8'h3b;
				4'h5 : 	o_Text <= 8'hcb;
				4'h6 : 	o_Text <= 8'hf9;
				4'h7 : 	o_Text <= 8'hb6;
				4'h8 : 	o_Text <= 8'ha7;
				4'h9 : 	o_Text <= 8'hee;
				4'hA : 	o_Text <= 8'hd3;
				4'hB : 	o_Text <= 8'h56;
				4'hC : 	o_Text <= 8'hdd;
				4'hD : 	o_Text <= 8'h35;
				4'hE : 	o_Text <= 8'h1e;
				4'hF : 	o_Text <= 8'h99;
    	endcase
    	4'hA : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h67;
				4'h1 : 	o_Text <= 8'ha2;
				4'h2 : 	o_Text <= 8'he5;
				4'h3 : 	o_Text <= 8'h80;
				4'h4 : 	o_Text <= 8'hd6;
				4'h5 : 	o_Text <= 8'hbe;
				4'h6 : 	o_Text <= 8'h2;
				4'h7 : 	o_Text <= 8'hda;
				4'h8 : 	o_Text <= 8'h7e;
				4'h9 : 	o_Text <= 8'hb8;
				4'hA : 	o_Text <= 8'hac;
				4'hB : 	o_Text <= 8'hf4;
				4'hC : 	o_Text <= 8'h74;
				4'hD : 	o_Text <= 8'h57;
				4'hE : 	o_Text <= 8'h87;
				4'hF : 	o_Text <= 8'h2d;
    	endcase
    	4'hB : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h2b;
				4'h1 : 	o_Text <= 8'haf;
				4'h2 : 	o_Text <= 8'hf1;
				4'h3 : 	o_Text <= 8'he2;
				4'h4 : 	o_Text <= 8'hb3;
				4'h5 : 	o_Text <= 8'h39;
				4'h6 : 	o_Text <= 8'h7f;
				4'h7 : 	o_Text <= 8'h21;
				4'h8 : 	o_Text <= 8'h3d;
				4'h9 : 	o_Text <= 8'h14;
				4'hA : 	o_Text <= 8'h62;
				4'hB : 	o_Text <= 8'hea;
				4'hC : 	o_Text <= 8'h1f;
				4'hD : 	o_Text <= 8'hb9;
				4'hE : 	o_Text <= 8'he9;
				4'hF : 	o_Text <= 8'h0f;
    	endcase
    	4'hC : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'hfe;
				4'h1 : 	o_Text <= 8'h9c;
				4'h2 : 	o_Text <= 8'h71;
				4'h3 : 	o_Text <= 8'heb;
				4'h4 : 	o_Text <= 8'h29;
				4'h5 : 	o_Text <= 8'h4a;
				4'h6 : 	o_Text <= 8'h50;
				4'h7 : 	o_Text <= 8'h10;
				4'h8 : 	o_Text <= 8'h64;
				4'h9 : 	o_Text <= 8'hde;
				4'hA : 	o_Text <= 8'h91;
				4'hB : 	o_Text <= 8'h65;
				4'hC : 	o_Text <= 8'h4b;
				4'hD : 	o_Text <= 8'h86;
				4'hE : 	o_Text <= 8'hce;
				4'hF : 	o_Text <= 8'hb0;
    	endcase
    	4'hD : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'hd7;
				4'h1 : 	o_Text <= 8'ha4;
				4'h2 : 	o_Text <= 8'hd8;
				4'h3 : 	o_Text <= 8'h27;
				4'h4 : 	o_Text <= 8'he3;
				4'h5 : 	o_Text <= 8'h4c;
				4'h6 : 	o_Text <= 8'h3c;
				4'h7 : 	o_Text <= 8'hff;
				4'h8 : 	o_Text <= 8'h5d;
				4'h9 : 	o_Text <= 8'h5e;
				4'hA : 	o_Text <= 8'h95;
				4'hB : 	o_Text <= 8'h7a;
				4'hC : 	o_Text <= 8'hbd;
				4'hD : 	o_Text <= 8'hc1;
				4'hE : 	o_Text <= 8'h55;
				4'hF : 	o_Text <= 8'h54;
    	endcase
    	4'hE : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'hab;
				4'h1 : 	o_Text <= 8'h72;
				4'h2 : 	o_Text <= 8'h31;
				4'h3 : 	o_Text <= 8'hb2;
				4'h4 : 	o_Text <= 8'h2f;
				4'h5 : 	o_Text <= 8'h58;
				4'h6 : 	o_Text <= 8'h9f;
				4'h7 : 	o_Text <= 8'hf3;
				4'h8 : 	o_Text <= 8'h19;
				4'h9 : 	o_Text <= 8'h0b;
				4'hA : 	o_Text <= 8'he4;
				4'hB : 	o_Text <= 8'hae;
				4'hC : 	o_Text <= 8'h8b;
				4'hD : 	o_Text <= 8'h1d;
				4'hE : 	o_Text <= 8'h28;
				4'hF : 	o_Text <= 8'hbb;
    	endcase
    	4'hF : case(i_Text[7:4])
    			4'h0 : 	o_Text <= 8'h76;
				4'h1 : 	o_Text <= 8'hc0;
				4'h2 : 	o_Text <= 8'h15;
				4'h3 : 	o_Text <= 8'h75;
				4'h4 : 	o_Text <= 8'h84;
				4'h5 : 	o_Text <= 8'hcf;
				4'h6 : 	o_Text <= 8'ha8;
				4'h7 : 	o_Text <= 8'hd2;
				4'h8 : 	o_Text <= 8'h73;
				4'h9 : 	o_Text <= 8'hdb;
				4'hA : 	o_Text <= 8'h79;
				4'hB : 	o_Text <= 8'h8;
				4'hC : 	o_Text <= 8'h8a;
				4'hD : 	o_Text <= 8'h9e;
				4'hE : 	o_Text <= 8'hdf;
				4'hF : 	o_Text <= 8'h16;
    	endcase
    endcase
    end
end

endmodule