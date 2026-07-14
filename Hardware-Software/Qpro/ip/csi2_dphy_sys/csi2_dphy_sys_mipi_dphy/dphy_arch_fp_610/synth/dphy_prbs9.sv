// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.





module dphy_prbs9 #(
        WIDTH = 8,                                  
        LOOKAHEAD = 0                               
        )
(
    input                       clk,
    input                       srst_n,
    input                       enable,
    input                       skip,
    input                       pause,
    input  [8:0]                init_val,
    output logic                out_valid,
    output logic [WIDTH-1:0]    prbs_out,
    output logic [15:0]         prbs_next
);

    logic [8:0] q_0;
    logic [8:0] q_1;
    logic [8:0] q_2;
    logic [8:0] q_3;

    logic [8:0] init_val_int;
    int i;
    logic [8:0] init_val_tmp;
    assign init_val_tmp = 9'h02;   
    
    `ifdef VIP
        always @(*)
        begin
            for (i = 1; i < 9; i++)
                init_val_int[9-i] <= init_val_tmp[i];
            init_val_int[0] <= init_val_tmp[0];
        end
    `else
        assign init_val_int = init_val; 
    `endif

`ifdef DEBUG_ALT_CAL

    logic [WIDTH-1:0] cnt;

    always @(posedge clk)
        begin
            if(enable == 1'b0)
                cnt <= 'hc3;
            else
                cnt <= cnt + 1'b1 + skip;
            prbs_out <= { ~cnt[7:0] , cnt[7:0] };
        end        



`else
    always @(posedge clk)
        out_valid <= enable;
    
    if(WIDTH == 16)
    begin
        
        always @(posedge clk)
        begin
            logic [8:0] q_tmp;
            if(enable == 1'b0)
            begin
                q_tmp = init_val_int;
                q_0 <= q_tmp;
                for(i=0; i<8; i++)
                    q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                q_1 <= q_tmp;
                if(LOOKAHEAD == 1)
                begin
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_2 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_3 <= q_tmp;
                end
            end                                                     
            else
            begin
                if(LOOKAHEAD == 1 && skip == 'b1 && pause == 'b0)
                begin
                    q_tmp = q_3;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_0 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_1 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_2 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_3 <= q_tmp;
                end            
                else if(LOOKAHEAD == 0 && skip == 'b1 && pause == 'b0)
                begin
                    q_tmp = q_1;
                    for(i=0; i<24; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_0 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_1 <= q_tmp;
                end
                else if(LOOKAHEAD == 1 & skip == pause)
                begin
                    q_0 <= q_2;
                    q_1 <= q_3;
                    q_tmp = q_3;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_2 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_3 <= q_tmp;
                    
                end
                else if(LOOKAHEAD == 0 && pause == skip)
                begin
                    q_tmp = q_1;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_0 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_1 <= q_tmp;
                end
		else
		begin
		    q_tmp <= q_tmp;
		    q_0 <= q_0;
		    q_1 <= q_1;
		end
            end
        end
        
        always @(posedge clk)
        begin
        `ifdef VIP
            for (i = 1; i < 9; i++)
            begin
                prbs_out[8-i]    <= q_0[i];
                prbs_out[16-i]   <= q_1[i];
                prbs_next[8-i]   <= (LOOKAHEAD == 1) ? q_2[i] : 'h0;
                prbs_next[16-i]  <= (LOOKAHEAD == 1) ? q_3[i] : 'h0;
            end
        `else
            prbs_out <= { q_1[8:1] , q_0[8:1] };
            prbs_next <= (LOOKAHEAD == 1) ? {  q_3[8:1] , q_2[8:1] } : 'h0;
        `endif
        end

    end
    else
    begin
        always @(posedge clk)
        begin
            logic [8:0] q_tmp;
            if(enable == 1'b0)
            begin
                q_tmp = init_val_int;
                q_0 <= q_tmp;
                if(LOOKAHEAD == 1)
                begin
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_1 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_2 <= q_tmp;
                end                
            end
            else
            begin
                if(LOOKAHEAD == 1 && skip == 'b1 && pause == 'b0)
                begin
                    q_tmp = q_2;
                    q_0 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_1 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_2 <= q_tmp;
                end
                if(LOOKAHEAD == 0 && skip == 'b1 && pause == 'b0)
                begin
                    q_tmp = q_0;
                    for(i=0; i<16; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_0 <= q_tmp;
                end
                else if(LOOKAHEAD == 1 && skip == pause)
                begin
                    q_0 <= q_1;
                    q_tmp = q_2;
                    q_1 <= q_tmp;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_2 <= q_tmp;
                end 
                else if(LOOKAHEAD == 0 && pause == skip)
                begin
                    q_tmp = q_0;
                    for(i=0; i<8; i++)
                        q_tmp = { q_tmp[4] ^ q_tmp[0], q_tmp[8:1] };
                    q_0 <= q_tmp;
                end
	       	else
		begin
		    q_tmp <= q_tmp;
		    q_0 <= q_0;
		    q_1 <= q_1;
		end
            end
        end

        always @(posedge clk)
        begin
        `ifdef VIP
            for (i = 1; i < 9; i++)
            begin
                prbs_out[8-i]    <= q_0[i];
                prbs_next[8-i]    <= (LOOKAHEAD == 1) ? q_1[i] : 'h0;
                prbs_next[16-i]   <= (LOOKAHEAD == 1) ? q_2[i] : 'h0;
            end
        `else
            prbs_out <= q_0[8:1];
            prbs_next <= LOOKAHEAD == 1 ? {q_2[8:1], q_1[8:1]} : 'h0;
        `endif
        end

    end

`endif    

 

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oLIP5PI2BY+9pRCx7UXSJPxkdWdaQ0gLbzo7I/tkx34zIJxhIP1OPbcKIbWt5f6AhfiSSna2rEzCjv7Md7RJ3odqFCRJXrjO1lmfuiyXFKjBm8mZlWz0axhndsAwSoJFLKtcQRk99cfpnJRNQm15ZtrXrf+YtqFGvHLS3DpgCldfAlBVZHsznZrk8yPLGrbyofMv+5GQLWmVlZN9yCZ2ayJBK9nIJiKoe4swFeumJYE8wwOeac0qCWr+A1sy9xndcGJ1269RMeiKgA/OpZOjJhZDG0LPadghA0tFCt/MxKZqPEa+6ZQ6I7E6G0MexlM/NZL2eZ+t2E60jf45g7CYr1BFXzD4650hurxLbEZq9Ljv/iZirsQ6RAtz93zX2bT6RDw5/S23wL+Fmymq03cHAcsrpPBVUshz2upE+ZTmHZhcfKvRnIo1XdJm25ZfvWrE0TKr6/gMp2M0bm6BzyyuUH7mxQOmu89zM6zfafokERmRgeCHNzrbAEmL6eqcvezqaDIXUNHiiozUx8pJi/uNw4jpmakx3NyqU2NyZhwzjbLCbzwAxSnjgaetx5Ipsmb08YzaZ1X0olsiSkVJ+kphlMbb4ifW/tm7iopCqY0crfhxdAwCs48daffGVzSC3G2MUMNFUcXYGTEnp8JFu9CRebqKJiYnaW3tg5tzUd4gTSXisggwMHJomaE2WbvYEoyqiA6jg6Opwq3CaXsBOWBl62uS9YbMQ7eoe6nxfRM7wjjsxwk/FbkSGqKLsR4hvi3hqQ9NMuVALkvqJTv7WaPfLaL"
`endif