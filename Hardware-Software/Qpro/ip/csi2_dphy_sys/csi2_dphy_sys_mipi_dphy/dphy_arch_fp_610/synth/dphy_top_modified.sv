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



(* altera_attribute = " \
   -name DESIGN_ASSISTANT_EXCLUDE \"RDC-50003\" -to \"dphy_core_inst\|*\" \
   " *)

`undef RZQ_SHARING

import dphy_pkg::*;
module dphy_top #(
    parameter DEV_FAMILY                                         = "FAMILY_AGILEX5",     
    parameter SPEED_GRADE                                        = 2,                    
    parameter NUM_PLL                                            = 1,                    
    parameter RZQ_ID                                             = 0,                    
    parameter REF_CLK_FREQ_0                                     = 32'd30000000,         
    parameter VCO_FREQ_0                                         = 40'd1600000000,       
    parameter CORE_CLK_FREQ_0                                    = 32'd400000000,        
    parameter REF_CLK_IO_0                                       = 0,                    
    parameter REF_CLK_IO_SHARE                                   = 1,                    
    parameter REF_CLK_FREQ_1                                     = 32'd30000000,         
    parameter VCO_FREQ_1                                         = 40'd1600000000,       
    parameter CORE_CLK_FREQ_1                                    = 32'd400000000,        
    parameter REF_CLK_IO_1                                       = 0,                    
    parameter LINK_USED                                          = 8'b00001111,          
    parameter BIT_RATE_0                                         = 36'd3200000000,       
    parameter BIT_RATE_1                                         = 36'd3200000000,       
    parameter BIT_RATE_2                                         = 36'd3200000000,       
    parameter BIT_RATE_3                                         = 36'd3200000000,       
    parameter BIT_RATE_4                                         = 36'd3200000000,       
    parameter BIT_RATE_5                                         = 36'd3200000000,       
    parameter BIT_RATE_6                                         = 36'd3200000000,       
    parameter BIT_RATE_7                                         = 36'd3200000000,       
    parameter PPI_WIDTH_16                                       = 8'b00000000,          
    parameter NUM_LANES                                          = 64'h0101010108080202, 
    parameter BYTE_LOC                                           = 64'h0706050403020100, 
    parameter SKEW_CAL_EN                                        = 8'b00000000,          
    `ifdef VIP 
    parameter SKEW_CAL_LEN                                       = 512,                  
    parameter ALT_CAL_LEN                                        = 512,                  
    `else
    parameter SKEW_CAL_LEN                                       = 32'd32768,            
    parameter ALT_CAL_LEN                                        = 32'd32768,             
    `endif
    parameter PER_SKEW_CAL_EN                                    = 8'b00000000,          
    parameter ALT_CAL_EN                                         = 8'b00000000,          
    parameter RX_BIT_RATE_MBPS_SEL                               = 64'h0000000000000000, 
    parameter PREAMBLE_EN                                        = 8'b00000000,          
    parameter TM_EN                                              = 8'b00000000,          
    parameter TM_LOOPBACK_MODE                                   = 8'b00000000,          
    parameter TM_LOOPBACK_PAIR                                   = 64'h0808080808080808, 
    parameter TX_VCO_FREQ_MULT                                   = 64'h0101010101010101, 
    parameter LINK_PLL_SRC                                       = 8'b00000000,          
    parameter PRBS_INIT_0                                        = 64'hffffffffffffffff, 
    parameter PRBS_INIT_1                                        = 64'hffffffffffffffff, 
    parameter PRBS_INIT_2                                        = 64'hffffffffffffffff, 
    parameter PRBS_INIT_3                                        = 64'hffffffffffffffff, 
    parameter PRBS_INIT_4                                        = 64'hffffffffffffffff, 
    parameter PRBS_INIT_5                                        = 64'hffffffffffffffff, 
    parameter PRBS_INIT_6                                        = 64'hffffffffffffffff, 
    parameter PRBS_INIT_7                                        = 64'hffffffffffffffff, 
    parameter DPHY_RX_EN                                         = 8'b00000000,          
	parameter RX_PPI_WIDTH_16_C2P                                = 8'b00000000,         
    parameter RX_TIMING_REG_RW                                   = 8'b00000000,          
    parameter CONTINUOUS_CLK                                     = 8'b00000000,          
    parameter RX_CAP_EQ_MODE                                     = 64'h0000000000000000, 
    parameter RX_AUTO_TYPE                                       = 64'h0000000000000000, 
    parameter RX_CLK_LOSS_DETECT                                 = 64'h0000000000000000, 
    parameter RX_CLK_SETTLE                                      = 64'h0000000000000000, 
    parameter RX_HS_SETTLE                                       = 64'h0000000000000000, 
    parameter RX_INIT                                            = 64'h0000000000000000, 
    parameter RX_CLK_POST                                        = 64'h0000000000000000, 
    parameter RX_PREP_TIME_TM                                    = 64'h0000000000000000, 
    parameter RX_TM_CONTROL_RX_TM_EN                             = 8'b00000000,          
    parameter RX_TM_CONTROL_RX_TM_LOOPBACK_MODE                  = 8'b00000000,          
    parameter RX_DLANE_DESKEW_DELAY_0                            = 64'h0000000000000000, 
    parameter RX_DLANE_DESKEW_DELAY_1                            = 64'h0000000000000000, 
    parameter RX_DLANE_DESKEW_DELAY_2                            = 64'h0000000000000000, 
    parameter RX_DLANE_DESKEW_DELAY_3                            = 64'h0000000000000000, 
    parameter RX_DLANE_DESKEW_DELAY_4                            = 64'h0000000000000000, 
    parameter RX_DLANE_DESKEW_DELAY_5                            = 64'h0000000000000000, 
    parameter RX_DLANE_DESKEW_DELAY_6                            = 64'h0000000000000000, 
    parameter RX_DLANE_DESKEW_DELAY_7                            = 64'h0000000000000000, 
    parameter DPHY_TX_EN                                         = 8'b00001010,          
    parameter TX_TIMING_REG_RW                                   = 8'b00000000,          
    parameter TX_AUTO_TYPE                                       = 64'h0000000000000000, 
    parameter TX_CAP_EQ_MODE                                     = 64'h0000000000000000, 
    parameter TX_CLK_LANE_PS                                     = 64'h0000000000000000, 
    parameter TX_LPX                                             = 64'h0000000000000000, 
    parameter TX_HS_EXIT                                         = 64'h0000000000000000, 
    parameter TX_LP_EXIT                                         = 64'h0000000000000000, 
    parameter TX_CLK_PREPARE                                     = 64'h0000000000000000, 
    parameter TX_CLK_TRAIL                                       = 64'h0000000000000000, 
    parameter TX_CLK_ZERO                                        = 64'h0000000000000000, 
    parameter TX_CLK_POST                                        = 64'h0000000000000000, 
    parameter TX_CLK_PRE                                         = 64'h0000000000000000, 
    parameter TX_HS_PREPARE                                      = 64'h0000000000000000, 
    parameter TX_HS_ZERO                                         = 64'h0000000000000000, 
    parameter TX_HS_TRAIL                                        = 64'h0000000000000000, 
    parameter TX_INIT                                            = 64'h0000000000000000, 
    parameter TX_WAKE                                            = 64'h0000000000000000, 
    parameter TX_HS_TM_DESKEW_P                                  = 64'h0000000000000000, 
    parameter TX_TM_CONTROL_TX_TM_EN                             = 8'b00000000,          
    parameter TX_TM_CONTROL_TX_TM_LOOPBACK_MODE                  = 8'b00000000,          
    parameter TX_PREAMBLE_LEN_PREAMLBE_LEN                       = 64'h0000000000000000  
    )
   (
`ifndef RZQ_SHARING
        input wire                                      rzq,     
`endif
        input wire                                      ref_clk_0_p,
        input wire                                      ref_clk_0_n,
        input wire                                      ref_clk_1_p,
        input wire                                      ref_clk_1_n,
        input wire                                      arst_n,           

        output [7:0]                                    link_core_clk,          
        output [7:0]                                    link_arst_n,            
        output [7:0]                                    link_srst_n,            

 		input                                           axil_clk, 
        input                                           srst_axil_n,
		input                                           awvalid,
		input   [11:0]                                  awaddr,        
		output logic                                    awready,
		input                                           wvalid,
		input   [3:0]                                   wstrb,
		input   [31:0]                                  wdata,
		output logic                                    wready,
		input                                           bready,
		output logic [1:0]                              bresp,
		output logic                                    bvalid,
		input   [11:0]                                  araddr,
		input                                           arvalid,
		output logic                                    arready,
		input                                           rready,
		output logic  [31:0]                            rdata,
		output logic  [1:0]                             rresp,
		output logic                                    rvalid,
        input  logic [2:0]                              arprot,
        input  logic [2:0]                              awprot,

        output logic                                    reg_wr_en_o,
        output logic                                    reg_rd_en_o,
        output logic [10:0]                             reg_raddr_o,
        output logic [10:0]                             reg_waddr_o,
        output logic [3:0]                              reg_be_o,
        output logic [31:0]                             reg_din_o,
        input  [31:0]                                   reg_dout_i,

        inout  [7:0] [7:0]                              dphy_link_dp,           
        inout  [7:0] [7:0]                              dphy_link_dn,           
        inout  [7:0]                                    dphy_link_cp,           
        inout  [7:0]                                    dphy_link_cn,           

        ppi_if                                          ppi[7:0]


    );
    
    genvar link_id;
    
    dphy_dbg_dlane dphy_dbg_dlane[63:0] ();
    dphy_dbg_clane dphy_dbg_clane[7:0] ();

    

    dphy_dbg_common dphy_dbg_common();

    
    wire [7:0][15:0]                tm_loopback_in;
    wire [7:0]                      tm_hs_in;
    wire [7:0][15:0]                tm_loopback_out;
    wire [7:0]                      tm_hs_out;
    
    assign tm_hs_in = 'h0;

    genvar 			    tm_ln;
   
    for(tm_ln=0; tm_ln<8; tm_ln++)
      begin : tm_lb
	 assign tm_loopback_in[tm_ln] = 'h0;	 
      end
    
    
    logic read_en_q;
    logic [31:0] reg_dout_ext;
    
    always @(posedge axil_clk)
        if(srst_axil_n == 1'b0)
            read_en_q <= 1'b0;
        else
            read_en_q <= reg_rd_en_o;
    
    assign reg_wr_en_o = reg_bus.reg_waddr[8] & reg_bus.reg_wr_en;
    assign reg_rd_en_o = reg_bus.reg_raddr[8] & reg_bus.reg_rd_en;
    assign reg_be_o = reg_bus.reg_be;
    assign reg_din_o = reg_bus.reg_din;
    assign reg_raddr_o = { reg_bus.reg_raddr[11:9] , reg_bus.reg_raddr[7:0] };
    assign reg_waddr_o = { reg_bus.reg_waddr[11:9] , reg_bus.reg_waddr[7:0] };
    assign reg_dout_ext = read_en_q == 1'b1 ? reg_dout_i : 32'h0;
           
    
    dphy_reg_if #(
            .DWIDTH(32),                
            .AWIDTH(12)                 
             ) reg_bus ();
    assign reg_bus.reg_clk = axil_clk;
    assign reg_bus.reg_srst_n = srst_axil_n;
    
    dphy_axil_target  # (
        .AWIDTH(12),
        .DWIDTH(32)
    ) axil_target_inst(
        .clk(axil_clk), 
        .srst_n(srst_axil_n),
        .awvalid(awvalid),
        .awaddr(awaddr),        
        .awready(awready),
        .wvalid(wvalid),
        .wstrb(wstrb),
        .wdata(wdata),
        .wready(wready),
        .bready(bready),
        .bresp(bresp),
        .bvalid(bvalid),
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),
        .rready(rready),
        .rdata(rdata),
        .rresp(rresp),
        .rvalid(rvalid),
        .reg_dout_ext(reg_dout_ext),
        .reg_if(reg_bus)
    );    

    dphy_core #(
        .DEV_FAMILY(DEV_FAMILY),                                                
        .SPEED_GRADE(SPEED_GRADE),                                              
        .NUM_PLL(NUM_PLL),                                                      
        .RZQ_ID(RZQ_ID),                                                        
        .REF_CLK_FREQ_0(REF_CLK_FREQ_0),                                        
        .VCO_FREQ_0(VCO_FREQ_0),                                                
        .CORE_CLK_FREQ_0(CORE_CLK_FREQ_0),                                      
        .REF_CLK_IO_0(REF_CLK_IO_0),                                            
        .REF_CLK_IO_SHARE(REF_CLK_IO_SHARE),                                    
        .REF_CLK_FREQ_1(REF_CLK_FREQ_1),                                        
        .VCO_FREQ_1(VCO_FREQ_1),                                                
        .CORE_CLK_FREQ_1(CORE_CLK_FREQ_1),                                      
        .REF_CLK_IO_1(REF_CLK_IO_1),                                            
        .VCCN_VOLTAGE((REF_CLK_IO_0 == 0 || REF_CLK_IO_0 == 1) ? "VCCN_VOLTAGE_1P2V" : (REF_CLK_IO_0 == 2 || REF_CLK_IO_0 == 3) ? "VCCN_VOLTAGE_1P1V" : "QPDS_UNSET"),
        .LINK_USED(LINK_USED),                                                  
        .BIT_RATE_0(BIT_RATE_0),                                                
        .BIT_RATE_1(BIT_RATE_1),                                                
        .BIT_RATE_2(BIT_RATE_2),                                                
        .BIT_RATE_3(BIT_RATE_3),                                                
        .BIT_RATE_4(BIT_RATE_4),                                                
        .BIT_RATE_5(BIT_RATE_5),                                                
        .BIT_RATE_6(BIT_RATE_6),                                                
        .BIT_RATE_7(BIT_RATE_7),                                                
        .PPI_WIDTH_16(PPI_WIDTH_16),                                            
        .NUM_LANES(NUM_LANES),                                                  
        .BYTE_LOC(BYTE_LOC),                                                    
        .SKEW_CAL_EN(SKEW_CAL_EN),                                              
        .SKEW_CAL_LEN(SKEW_CAL_LEN),                                            
        .PER_SKEW_CAL_EN(SKEW_CAL_EN),                                          
        .ALT_CAL_EN(ALT_CAL_EN),                                                
        .ALT_CAL_LEN(ALT_CAL_LEN),                                              
        .PREAMBLE_EN(PREAMBLE_EN),                                              
        .CONTINUOUS_CLK(CONTINUOUS_CLK),                                        
        .TM_EN(TM_EN),                                                          
        .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE),                                    
        .VCO_FREQ_MULT(TX_VCO_FREQ_MULT),                                       
        .LINK_PLL_SRC(LINK_PLL_SRC),                                            
        .PRBS_INIT_0(PRBS_INIT_0),                                              
        .PRBS_INIT_1(PRBS_INIT_1),                                              
        .PRBS_INIT_2(PRBS_INIT_2),                                              
        .PRBS_INIT_3(PRBS_INIT_3),                                              
        .PRBS_INIT_4(PRBS_INIT_4),                                              
        .PRBS_INIT_5(PRBS_INIT_5),                                              
        .PRBS_INIT_6(PRBS_INIT_6),                                              
        .PRBS_INIT_7(PRBS_INIT_7),                                              
        .DPHY_RX_EN(DPHY_RX_EN),                                                
        .RX_BIT_RATE_MBPS_SEL(RX_BIT_RATE_MBPS_SEL),                            
        .RX_PPI_WIDTH_16_C2P(RX_PPI_WIDTH_16_C2P),                              
        .RX_TIMING_REG_RW(RX_TIMING_REG_RW),                                    
        .RX_AUTO_TYPE(RX_AUTO_TYPE),                                            
        .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE),                                        
        .RX_CLK_LOSS_DETECT(RX_CLK_LOSS_DETECT),                                
        .RX_CLK_SETTLE(RX_CLK_SETTLE),                                          
        .RX_HS_SETTLE(RX_HS_SETTLE),                                            
        .RX_INIT(RX_INIT),                                                      
        .RX_CLK_POST(RX_CLK_POST),                                              
        .RX_PREP_TIME_TM(RX_PREP_TIME_TM),                                      
        .RX_TM_CONTROL_RX_TM_EN(RX_TM_CONTROL_RX_TM_EN),                        
        .RX_TM_CONTROL_RX_TM_LOOPBACK_MODE(RX_TM_CONTROL_RX_TM_LOOPBACK_MODE),  
        .RX_DLANE_DESKEW_DELAY_0(RX_DLANE_DESKEW_DELAY_0),                      
        .RX_DLANE_DESKEW_DELAY_1(RX_DLANE_DESKEW_DELAY_1),                      
        .RX_DLANE_DESKEW_DELAY_2(RX_DLANE_DESKEW_DELAY_2),                      
        .RX_DLANE_DESKEW_DELAY_3(RX_DLANE_DESKEW_DELAY_3),                      
        .RX_DLANE_DESKEW_DELAY_4(RX_DLANE_DESKEW_DELAY_4),                      
        .RX_DLANE_DESKEW_DELAY_5(RX_DLANE_DESKEW_DELAY_5),                      
        .RX_DLANE_DESKEW_DELAY_6(RX_DLANE_DESKEW_DELAY_6),                      
        .RX_DLANE_DESKEW_DELAY_7(RX_DLANE_DESKEW_DELAY_7),                      
        .DPHY_TX_EN(DPHY_TX_EN),                                                
        .TX_TIMING_REG_RW(TX_TIMING_REG_RW),                                    
        .TX_AUTO_TYPE(TX_AUTO_TYPE),                                            
        .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE),                                        
        .TX_CLK_LANE_PS(TX_CLK_LANE_PS),                                        
        .TX_LPX(TX_LPX),                                                        
        .TX_HS_EXIT(TX_HS_EXIT),                                                
        .TX_LP_EXIT(TX_LP_EXIT),                                                
        .TX_CLK_PREPARE(TX_CLK_PREPARE),                                        
        .TX_CLK_TRAIL(TX_CLK_TRAIL),                                            
        .TX_CLK_ZERO(TX_CLK_ZERO),                                              
        .TX_CLK_POST(TX_CLK_POST),                                              
        .TX_CLK_PRE(TX_CLK_PRE),                                                
        .TX_HS_PREPARE(TX_HS_PREPARE),                                          
        .TX_HS_ZERO(TX_HS_ZERO),                                                
        .TX_HS_TRAIL(TX_HS_TRAIL),                                              
        .TX_INIT(TX_INIT),                                                      
        .TX_WAKE(TX_WAKE),                                                      
        .TX_HS_TM_DESKEW_P(TX_HS_TM_DESKEW_P),                                  
        .TX_TM_CONTROL_TX_TM_EN(TX_TM_CONTROL_TX_TM_EN),                        
        .TX_TM_CONTROL_TX_TM_LOOPBACK_MODE(TX_TM_CONTROL_TX_TM_LOOPBACK_MODE),  
        .TX_PREAMBLE_LEN_PREAMLBE_LEN(TX_PREAMBLE_LEN_PREAMLBE_LEN)             
    ) dphy_core_inst
   (
`ifndef RZQ_SHARING
        .rzq(rzq),
`endif
        .ref_clk_0_p(ref_clk_0_p),                                          
        .ref_clk_0_n(ref_clk_0_n),
        .ref_clk_1_p(ref_clk_1_p),
        .ref_clk_1_n(ref_clk_1_n),
        .arst_n(arst_n),           

        .link_core_clk(link_core_clk),                                      
        .link_arst_n(link_arst_n),                                          
        .link_srst_n(link_srst_n),                                          
   
        .reg_bus(reg_bus),                                                  
   
        .dphy_link_dp(dphy_link_dp),                                        
        .dphy_link_dn(dphy_link_dn),                                        
        .dphy_link_cp(dphy_link_cp),                                        
        .dphy_link_cn(dphy_link_cn),                                        

        .tm_loopback_in(tm_loopback_in),
        .tm_hs_in(tm_hs_in),
        .tm_loopback_out(tm_loopback_out),
        .tm_hs_out(tm_hs_out),
        .dphy_dbg_dlane(dphy_dbg_dlane),
        .dphy_dbg_clane(dphy_dbg_clane),
        .dphy_dbg_common(dphy_dbg_common),

        .ppi(ppi)
    );





endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJ0PC/JYf9hSkBoWGAmJPJkrgGJmQFfAoEix66cElQQzr+FrQnXK2wLs2g3VHIH28kvkzpBB7UCeNNoWfIeyzhbPyfnVDHd/d842qtu6Kz5WUsmS7+b1cWb3ACTrQFAS6m8xBmrdyVJgvKmyjWyEs//lQeRHiz+iBXKOSoVn7ZsU+eAd8S1bAzqdWjng1+Qxf/rTYviB3trN7qowCVeNkkU0SxZrJJvjrwkdLewZsC1FFVXQXlqwcbkHwXQweEzSVHAUu/kNlqKiTtDpwH3IJxfOObF4h62zTYGR9Ci8ZKfceJHw4tH7HjkidWr2zKx71NqPT+pZqOLAWkoFZjN9ZWBGMEb3Kma2/siZpmhKFOPS3USJhnfnpBatNcUmp0A6sAUrj4g0f4jJOjYMg2Gj7QBENJGUSLXz26/sZuC+JujTIcR7hO52SPYJio+M3Rs4D0naJznrV/mfn1vZfA+z9ur+aWLVwAEnS6o2Xti+FDlTuH0m/gXNWU+FAHL7FiqRf70nmT6pIRPk30gMY24vl8H/udM6K59Q+R+9KArEM5BFzb7dEZG5iGLPcZbTuWVvBm8v/iw8OKP22qxNFjCEYgVPD8mQ3TuvmxTyjrd9tJL4n5TeLlwFuUpYCtGCbBRnZxl6+GIdMPvrN+u8dKRMgEL0qX6Y7dtN/GbqbJL1w0UUExN+GkFwTFQ9BhBH+WyeaDa8V9EGFFwhM6kOzKdR+FFkARP0B5Jumn1C57vyOCL1EcYD0+iylAu8dMorr1pwU27zfJHn/uqWnBjcpb2ySTV"
`endif
