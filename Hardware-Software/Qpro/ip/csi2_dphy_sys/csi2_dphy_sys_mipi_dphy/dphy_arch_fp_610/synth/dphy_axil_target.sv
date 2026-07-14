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



module dphy_axil_target  # (
    parameter AWIDTH = 12,
    parameter DWIDTH = 32
    ) (
		input                       clk, 
        input                       srst_n,
		input                       awvalid,
		input   [AWIDTH-1:0]        awaddr,        
		output logic                awready,
		input                       wvalid,
		input   [(DWIDTH/8)-1:0]    wstrb,
		input   [DWIDTH-1:0]        wdata,
		output logic                wready,
		input                       bready,
		output logic [1:0]          bresp,
		output logic                bvalid,
		input   [AWIDTH-1:0]        araddr,
		input                       arvalid,
		output logic                arready,
		input                       rready,
		output logic  [DWIDTH-1:0]  rdata,
		output logic  [1:0]         rresp,
		output logic                rvalid,
        input  [DWIDTH-1:0]         reg_dout_ext,
        dphy_reg_if                 reg_if
);



    typedef enum { s_idle, s_start, s_ready, s_done } sm_t;
    sm_t write_cs, write_ns;
    sm_t read_cs, read_ns;
    logic [AWIDTH-1:0] awaddr_q;
    logic [DWIDTH-1:0] wdata_q;
    logic [(DWIDTH/8)-1:0] wstrb_q;
    logic [AWIDTH-1:0] araddr_q;
    logic reg_rd_en_q;
    
    always @(posedge clk)
    begin
        if(srst_n == 1'b0)
        begin
            write_cs <= s_idle;
            read_cs <= s_idle;
        end
        else
        begin
            write_cs <= write_ns;
            read_cs <= read_ns;
        end
    end
    
	always @(*)
    begin
        case (write_cs)
            s_idle  :   if(awvalid == 1'b1)		
                            write_ns = s_start;
                        else                    
                            write_ns = write_cs;
            s_start :   if(wvalid == 1'b1)		
                            write_ns = s_ready;
                        else                    
                            write_ns = write_cs;
            s_ready :   if(bready == 1'b1)
                            write_ns = s_idle;
                        else
                            write_ns = write_cs;
            default  :  write_ns = s_idle;
        endcase
    end

    always @(posedge clk)
    begin
        awready <= (write_cs == s_idle && write_ns == s_start) ? 1'b1 : 1'b0;
        awaddr_q <= (awready & awvalid) == 1'b1 ? awaddr : awaddr_q;
        wready <= (write_cs == s_start && write_ns == s_ready) ? 1'b1 : 1'b0;
        wdata_q <= wready == 1'b1 ? wdata : wdata_q;
        wstrb_q <= wready == 1'b1 ? wstrb : wstrb_q;
        bvalid <= (write_cs == s_ready) ? 1'b1 : 1'b0;
        reg_if.reg_wr_en <= wready;
    end

    assign bresp = 2'b00;

    assign reg_if.reg_waddr = awaddr_q;
    assign reg_if.reg_din = wdata_q;
    assign reg_if.reg_be = wstrb_q;

	always @(*)
    begin
        case (read_cs)
            s_idle  :   if(arvalid == 1'b1)		
                            read_ns = s_start;
                        else                    
                            read_ns = read_cs;
            s_start :   read_ns = s_ready;
            s_ready :   if(rready == 1'b1 && rvalid == 1'b1)
                            read_ns = s_idle;
                        else
                            read_ns = read_cs;
            default  :  read_ns = s_idle;
        endcase
    end

    always @(posedge clk)
    begin
        araddr_q <= (read_cs == s_start) ? araddr : araddr_q;
        reg_rd_en_q <= reg_if.reg_rd_en & ~(rvalid & rready);
        rvalid <= reg_rd_en_q & ~(rvalid & rready);
        rdata <= (reg_rd_en_q == 1'b1) ? reg_if.reg_dout | reg_dout_ext : rdata;
    end

    assign arready = (read_cs == s_start) ? 1'b1 : 1'b0;

    assign rresp = 2'b00;

    assign reg_if.reg_raddr = araddr_q;
    assign reg_if.reg_rd_en = (read_cs == s_ready) ? 1'b1 : 1'b0;


endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oI3TaZmMXpS7ibwrE6o+xEd8NgOpXq++EquWJ6EP3gqwavWzTXnrU9WnOwBebYLO8WyXWzwoyiH1jyoo/Q6Wx/e2rHOnCk0aF1UH8we2UkM9c5joWi/Yr0b/BEShRsiultDLDNaYgRglTzBUhK6RcFa4P2eAC+t7FmMzI0BJqDKRpLiFZ2ILB4rDrEr1CoWJfIsHV9N4OsHxCMQaw4VgAZV1eQaB5X2vnPJkwgJe4GaSDOG9qkSLXJCLu4aAzBzXpCSsnqcbG+JvPyGjqalRYRNtOydoQOoVm2u3VgIePUEls7dYtJve0+QfI5ALz6ZWsRhk7dNZeYwch74Tkw5K0is6SE6N+Mf9IDCjX6BuGLje9eUdujR56FUei/VJ1UXLhLD3lzItFuWPtx/rDpFBHcCs1WKv45UKrTBFp4dk03OLDHRxB/u1MPAq2UN7+TTPw3Na3S/xpO3LFSqDxnl5pGw4PvkPUzWJcRex3HpCBrSuqGgfbMNNXR8eh+h7waVxrBmRaOtMKiLq4CfvTGRiEnJQbUYnAN9Xt29Dcj/AHMhGsMB0xlrWYnz5FbgA4q7eQotgt20xdjuR5intJF020O/QoFvguOIEFe3I4GSFGn2wqnEZLpJStxJheKl0nyRdQFB+huf9O8rtokGMhqNiGkRW54npfxqJvYudqd931wk1rWfsMCK+g1j1z6ktK9au0toHu7yzoiistunSqw47PcKyT3MjeqqhIFCFOlhFfMccAXiZfL0t+9Tf0IAZtkLMIdvgrTynSGRjgHRPnzqnBXk"
`endif