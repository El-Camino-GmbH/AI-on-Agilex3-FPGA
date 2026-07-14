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



import dphy_pkg::*;

`undef RZQ_SHARING

module dphy_core #(
    parameter DEV_FAMILY                                         = "FAMILY_AGILEX5",     
    parameter SPEED_GRADE                                        = 2,                    
    parameter NUM_PLL                                            = 1,                    
    parameter RZQ_ID                                             = 0,                    
    parameter REF_CLK_FREQ_0                                     = 32'd30000000,         
    parameter VCO_FREQ_0                                         = 36'd1600000000,       
    parameter CORE_CLK_FREQ_0                                    = 36'd400000000,        
    parameter REF_CLK_IO_0                                       = 0,                    
    parameter REF_CLK_IO_SHARE                                   = 1,                    
    parameter REF_CLK_FREQ_1                                     = 32'd30000000,         
    parameter VCO_FREQ_1                                         = 36'd1600000000,       
    parameter CORE_CLK_FREQ_1                                    = 36'd400000000,        
    parameter REF_CLK_IO_1                                       = 0,                    
    parameter VCCN_VOLTAGE                                       = "VCCN_VOLTAGE_1P2V",
    parameter LINK_USED                                          = 8'b00000000,          
    parameter BIT_RATE_0                                         = 36'd3200000000,       
    parameter BIT_RATE_1                                         = 36'd3200000000,       
    parameter BIT_RATE_2                                         = 36'd3200000000,       
    parameter BIT_RATE_3                                         = 36'd3200000000,       
    parameter BIT_RATE_4                                         = 36'd3200000000,       
    parameter BIT_RATE_5                                         = 36'd3200000000,       
    parameter BIT_RATE_6                                         = 36'd3200000000,       
    parameter BIT_RATE_7                                         = 36'd3200000000,       
    parameter PPI_WIDTH_16                                       = 8'b00000000,          
    parameter NUM_LANES                                          = 64'h0101010101010101, 
    parameter BYTE_LOC                                           = 64'h0706050403020100, 
    parameter SKEW_CAL_EN                                        = 8'b00000000,          
    parameter SKEW_CAL_LEN                                       = 32'd32768,            
    parameter PER_SKEW_CAL_EN                                    = 8'b00000000,          
    parameter ALT_CAL_EN                                         = 8'b00000000,          
    parameter ALT_CAL_LEN                                        = 32'd32768,            
    parameter PREAMBLE_EN                                        = 8'b00000000,          
    parameter TM_EN                                              = 8'b00000000,          
    parameter TM_LOOPBACK_MODE                                   = 8'b00000000,          
    parameter VCO_FREQ_MULT                                      = 64'h0101010101010101, 
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
    parameter RX_BIT_RATE_MBPS_SEL                               = 64'h0000000000000000, 
	parameter RX_PPI_WIDTH_16_C2P                                = 8'b00000000,          
    parameter RX_TIMING_REG_RW                                   = 8'b00000000,          
    parameter CONTINUOUS_CLK                                     = 8'b00000000,          
    parameter RX_AUTO_TYPE                                       = 64'h0000000000000000, 
    parameter RX_CAP_EQ_MODE                                     = 64'h0000000000000000, 
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
    parameter DPHY_TX_EN                                         = 8'b00000000,          
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
        input wire                      rzq,
`endif
        input wire                      ref_clk_0_p,
        input wire                      ref_clk_0_n,
        input wire                      ref_clk_1_p,
        input wire                      ref_clk_1_n,
        input wire                      arst_n,           
   
        dphy_reg_if                     reg_bus,
   
        inout  [7:0] [7:0]              dphy_link_dp,           
        inout  [7:0] [7:0]              dphy_link_dn,           
        inout  [7:0]                    dphy_link_cp,           
        inout  [7:0]                    dphy_link_cn,           

        output [7:0]                    link_core_clk,          
        output [7:0]                    link_arst_n,            
        output [7:0]                    link_srst_n,            


        input [7:0][15:0]               tm_loopback_in,
        input [7:0]                     tm_hs_in,
        output [7:0][15:0]              tm_loopback_out,
        output [7:0]                    tm_hs_out,
        dphy_dbg_dlane                  dphy_dbg_dlane[63:0],
        dphy_dbg_clane                  dphy_dbg_clane[7:0],
        dphy_dbg_common                 dphy_dbg_common,

        ppi_if                          ppi[7:0]

    );
    localparam TIME_UNIT = "ps";
    localparam RZQ_ID_STR = RZQ_ID == 0 ? "RZQ0" : "RZQ1";

    logic [31:0] reg_dout[0:7];
    
    logic [7:0]      link_vco_clk;
    logic [7:0]      link_phy_clk;
    logic [7:0]      link_phy_clk_sync;
    logic [7:0]      link_core_clk_1024;
    logic [7:0]      link_pll_lock;
    logic [7:0]      link_enable;
     
    dphy_clk_rst_blk #(
        .SPEED_GRADE(SPEED_GRADE),                  
        .NUM_PLL(NUM_PLL),                          
        .RZQ_ID(RZQ_ID_STR),                        
        .REF_CLK_FREQ_0(REF_CLK_FREQ_0),            
        .VCO_FREQ_0(VCO_FREQ_0),                    
        .CORE_CLK_FREQ_0(CORE_CLK_FREQ_0),          
        .REF_CLK_IO_0(REF_CLK_IO_0),                
        .REF_CLK_IO_SHARE(REF_CLK_IO_SHARE),        
        .REF_CLK_FREQ_1(REF_CLK_FREQ_1),            
        .VCO_FREQ_1(VCO_FREQ_1),                    
        .CORE_CLK_FREQ_1(CORE_CLK_FREQ_1),          
        .REF_CLK_IO_1(REF_CLK_IO_1),                
        .LINK_USED(LINK_USED),                      
        .VCO_FREQ_MULT(VCO_FREQ_MULT),              
        .LINK_PLL_SRC(LINK_PLL_SRC)                 
    ) clk_rst (
`ifndef RZQ_SHARING
        .rzq(rzq),
`endif
        .ref_clk_0_p(ref_clk_0_p),
        .ref_clk_0_n(ref_clk_0_n),
        .ref_clk_1_p(ref_clk_1_p),
        .ref_clk_1_n(ref_clk_1_n),
        .arst_n(arst_n),       
        .dphy_dbg_common(dphy_dbg_common),
        .link_enable(link_enable),
        .link_vco_clk(link_vco_clk),
        .link_phy_clk(link_phy_clk),
        .link_phy_clk_sync(link_phy_clk_sync),
        .link_core_clk(link_core_clk),
        .link_core_clk_1024(link_core_clk_1024),
        .link_pll_lock(link_pll_lock),
        .link_srst_n(link_srst_n),
        .link_arst_n(link_arst_n)
    );
 
    
    genvar lvar;
    genvar lane_var;
   
    for (lvar = 0; lvar <8; lvar = lvar +1)
    begin : dphy_link
    
        localparam N_LANES = NUM_LANES[lvar*8 +: 4 ];
        
        if(LINK_USED[lvar] == 1)
        begin: dphy_link_used
    
            localparam REG_RW_ENABLE = ( DPHY_RX_EN[lvar] == 1'b1 ? RX_TIMING_REG_RW[lvar] :  ( DPHY_TX_EN[lvar] == 1'b1 ? TX_TIMING_REG_RW[lvar] : 0 ) );
            localparam REG_USE_AUTO = ( DPHY_RX_EN[lvar] == 1'b1 ? RX_AUTO_TYPE[lvar*8 +: 8] :  ( DPHY_TX_EN[lvar] == 1'b1 ? TX_AUTO_TYPE[lvar*8 +: 8] : 0 ) );
            localparam PPI_WIDTH = PPI_WIDTH_16[lvar] == 1'b1 ? 16 : 8;
            localparam PPI_WIDTH_C2P = RX_PPI_WIDTH_16_C2P[lvar] == 1'b1 ? 16 : 8;
            localparam PRBS_INIT = { PRBS_INIT_7[lvar*8 +: 8],
                                     PRBS_INIT_6[lvar*8 +: 8],
                                     PRBS_INIT_5[lvar*8 +: 8],
                                     PRBS_INIT_4[lvar*8 +: 8],
                                     PRBS_INIT_3[lvar*8 +: 8],
                                     PRBS_INIT_2[lvar*8 +: 8],
                                     PRBS_INIT_1[lvar*8 +: 8],
                                     PRBS_INIT_0[lvar*8 +: 8] };

            localparam BIT_RATE =  (lvar == 7 ) ? BIT_RATE_7 :
                                   (lvar == 6 ) ? BIT_RATE_6 :
                                   (lvar == 5 ) ? BIT_RATE_5 :
                                   (lvar == 4 ) ? BIT_RATE_4 :
                                   (lvar == 3 ) ? BIT_RATE_3 :
                                   (lvar == 2 ) ? BIT_RATE_2 :
                                   (lvar == 1 ) ? BIT_RATE_1 :
                                   BIT_RATE_0;
                                   
            localparam RX_DLANE_DESKEW_DELAY = { RX_DLANE_DESKEW_DELAY_7[lvar*8 +: 8],
                                                 RX_DLANE_DESKEW_DELAY_6[lvar*8 +: 8],
                                                 RX_DLANE_DESKEW_DELAY_5[lvar*8 +: 8],
                                                 RX_DLANE_DESKEW_DELAY_4[lvar*8 +: 8],
                                                 RX_DLANE_DESKEW_DELAY_3[lvar*8 +: 8],
                                                 RX_DLANE_DESKEW_DELAY_2[lvar*8 +: 8],
                                                 RX_DLANE_DESKEW_DELAY_1[lvar*8 +: 8],
                                                 RX_DLANE_DESKEW_DELAY_0[lvar*8 +: 8] };
            
            localparam RX_FR_CLK_FREQ = LINK_PLL_SRC[lvar] == 1'b0 ? CORE_CLK_FREQ_0 : CORE_CLK_FREQ_1;  
            localparam VCO_FREQ = LINK_PLL_SRC[lvar] == 1'b0 ? VCO_FREQ_0 : VCO_FREQ_1;  
            localparam BYTE_CNT = N_LANES > 4 ?2 : 1;
                                               
            
            logic  [BYTE_CNT-1:0]      rx_fwd_clk;          
            logic  [BYTE_CNT*96-1:0]   p2c;                 
            logic  [BYTE_CNT*4-1:0]    p2c_ctrl;            
            logic  [BYTE_CNT*12-1:0]   phy_gpio_din;        
    
            logic  [BYTE_CNT*96-1:0]   c2p;                 
            logic  [BYTE_CNT*20-1:0]   c2p_ctrl;            

	   logic [BYTE_CNT-1:0]        core_clk;                  
	   logic [BYTE_CNT-1:0]        srst_n;       
	   logic [BYTE_CNT*96-1:0]   c2p_hipi;          
	   logic [BYTE_CNT*96-1:0]   p2c_hipi;          
	   logic [BYTE_CNT*20-1:0]   c2p_ctrl_hipi;     
	   logic [BYTE_CNT*4-1:0]    p2c_ctrl_hipi;     
	   logic [BYTE_CNT*12-1:0]   phy_gpio_din_hipi; 
	   
            dphy_io_if #(
                .NUM_LANES(N_LANES),
                .IO_CONVERT_RATIO(PPI_WIDTH)
                 ) dphy_io_connect ();


            dphy_full_byte_wrap #(
                .DEV_FAMILY(DEV_FAMILY),                                            
                .NUM_LANES(N_LANES),                                                
                .IO_CONVERT_RATIO(PPI_WIDTH),                                       
                .IO_CONVERT_RATIO_C2P(PPI_WIDTH_C2P),                               
                .DPHY_RX_EN(DPHY_RX_EN[lvar]),                                      
                .DPHY_TX_EN(DPHY_TX_EN[lvar]),                                      
                .RX_DLANE_DESKEW_DELAY(RX_DLANE_DESKEW_DELAY),                      
                .TX_CLK_LANE_PS(TX_CLK_LANE_PS[lvar*8 +: 6]),                       
		        .VCO_FREQ_MULT(VCO_FREQ_MULT[lvar*8 +: 4 ]),                        
                .CONTINUOUS_CLK(CONTINUOUS_CLK[lvar]),                              
                .BYTE_CNT(BYTE_CNT),                                                
                .BYTE_LOC(BYTE_LOC[lvar*8 +:8]),                                    
                .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE[lvar*8 +: 6]),                       
                .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE[lvar*8 +: 2]),                       
                .BIT_RATE(BIT_RATE),                                                
                .VCO_FREQ(VCO_FREQ),                                                
                .RZQ_ID(RZQ_ID_STR),                                                
                .VCCN_VOLTAGE(VCCN_VOLTAGE)
                ) io_blk_inst (        
                .d_p(dphy_link_dp[lvar][N_LANES-1:0]),          
                .d_n(dphy_link_dn[lvar][N_LANES-1:0]),          
                .ck_p(dphy_link_cp[lvar]),                      
                .ck_n(dphy_link_cn[lvar]),                      
                .link_pll_lock(link_pll_lock[lvar]),            
                .link_vco_clk(link_vco_clk[lvar]),              
                .link_phy_clk(link_phy_clk[lvar]),              
                .link_phy_clk_sync(link_phy_clk_sync[lvar]),    
                .link_core_clk(link_core_clk[lvar]),            
                .rx_fwd_clk(rx_fwd_clk),                        
                .c2p(c2p_hipi),                                 
                .c2p_ctrl(c2p_ctrl_hipi),                       
                .p2c(p2c),                                      
                .p2c_ctrl(p2c_ctrl),                            
                .phy_gpio_din(phy_gpio_din),                    
                .dphy_io(dphy_io_connect)
                
            );

	   
	   dphy_full_byte_hipi_intf #(
		.DPHY_RX_EN(DPHY_RX_EN[lvar]),
		.DPHY_TX_EN(DPHY_TX_EN[lvar]),
		.NUM_LANES(N_LANES),
		.BYTE_CNT(BYTE_CNT)
		) io_hipi_intf_inst (
		.link_core_clk(link_core_clk[lvar]),
		.rx_fwd_clk(rx_fwd_clk),
		.p2c(p2c),
		.p2c_ctrl(p2c_ctrl),
		.phy_gpio_din(phy_gpio_din),
		.c2p(c2p),
		.c2p_ctrl(c2p_ctrl),
		.c2p_hipi(c2p_hipi),
                .p2c_hipi(p2c_hipi),
		.c2p_ctrl_hipi(c2p_ctrl_hipi),
		.p2c_ctrl_hipi(p2c_ctrl_hipi),
		.phy_gpio_din_hipi(phy_gpio_din_hipi)
		);
	   
    
            dphy_cp_map #(
                .DPHY_RX_EN(DPHY_RX_EN[lvar]),                 
                .DPHY_TX_EN(DPHY_TX_EN[lvar]),                 
                .NUM_LANES(N_LANES),
                .IO_CONVERT_RATIO(PPI_WIDTH),
                .BYTE_CNT(BYTE_CNT)
                ) dphy_io_map (
                .rx_fwd_clk(rx_fwd_clk),                        
                .p2c(p2c_hipi),                                   
                .p2c_ctrl(p2c_ctrl_hipi),                         
                .phy_gpio_din(phy_gpio_din_hipi),                 
                
                .c2p(c2p),                                      
                .c2p_ctrl(c2p_ctrl),                            
                
                .dphy_io(dphy_io_connect)
                );

            dphy_reg_if #(
                .DWIDTH(32),                
                .AWIDTH(8)                 
                ) reg_bus_link ();
           
            dphy_pcs #(
                .NUM_LANES(N_LANES),                     
                .PPI_WIDTH(PPI_WIDTH),                   
                .PPI_WIDTH_C2P(PPI_WIDTH_C2P),           
                .TIME_UNIT(TIME_UNIT),                   
                .BIT_RATE(BIT_RATE),                     
                .VCO_FREQ_MULT(VCO_FREQ_MULT[lvar*8 +: 4 ]), 
                .RX_FR_CLK_FREQ(RX_FR_CLK_FREQ),         
                .SKEW_CAL_EN(SKEW_CAL_EN[lvar]),         
                .SKEW_CAL_LEN(SKEW_CAL_LEN),             
                .PER_SKEW_CAL_EN(PER_SKEW_CAL_EN[lvar]), 
                .ALT_CAL_EN(ALT_CAL_EN[lvar]),           
                .ALT_CAL_LEN(ALT_CAL_LEN),               
                .PREAMBLE_EN(PREAMBLE_EN[lvar]),         
                .TM_EN(TM_EN[lvar]),                     
                .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE[lvar]), 
                .DPHY_RX_EN(DPHY_RX_EN[lvar]),           
                .DPHY_TX_EN(DPHY_TX_EN[lvar]),           
                .PRBS_INIT(PRBS_INIT),                   
                .REG_RW_ENABLE(REG_RW_ENABLE),           
                .CONTINUOUS_CLK(CONTINUOUS_CLK[lvar]),       
                .RX_BIT_RATE_MBPS_SEL(RX_BIT_RATE_MBPS_SEL[lvar*8 +: 8]),     
                .RX_DLANE_DESKEW_DELAY(RX_DLANE_DESKEW_DELAY), 
                .RX_CLK_LOSS_DETECT(RX_CLK_LOSS_DETECT[lvar*8 +: 8]), 
                .REG_USE_AUTO(REG_USE_AUTO),             
                .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE[lvar*8 +: 2]), 
                .RX_CLK_SETTLE(RX_CLK_SETTLE[lvar*8 +: 8]), 
                .RX_HS_SETTLE(RX_HS_SETTLE[lvar*8 +: 8]), 
                .RX_INIT(RX_INIT[lvar*8 +: 8]),          
                .RX_CLK_POST(RX_CLK_POST[lvar*8 +: 8]),          
                .RX_TM_CONTROL_RX_TM_EN(RX_TM_CONTROL_RX_TM_EN[lvar]), 
                .RX_TM_CONTROL_RX_TM_LOOPBACK_MODE(RX_TM_CONTROL_RX_TM_LOOPBACK_MODE[lvar]), 
                .RX_PREP_TIME_TM(RX_PREP_TIME_TM[lvar*8 +: 8]), 
                .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE[lvar*8 +: 2]), 
                .TX_PREAMBLE_LEN_PREAMLBE_LEN(TX_PREAMBLE_LEN_PREAMLBE_LEN[lvar*8 +: 4]), 
                .TX_CLK_LANE_PS(TX_CLK_LANE_PS[lvar*8 +: 6]), 
                .TX_LPX(TX_LPX[lvar*8 +: 7]),            
                .TX_HS_EXIT(TX_HS_EXIT[lvar*8 +: 8]),    
                .TX_LP_EXIT(TX_LP_EXIT[lvar*8 +: 8]),    
                .TX_CLK_PREPARE(TX_CLK_PREPARE[lvar*8 +: 6]), 
                .TX_CLK_TRAIL(TX_CLK_TRAIL[lvar*8 +: 7]), 
                .TX_CLK_ZERO(TX_CLK_ZERO[lvar*8 +: 7]),  
                .TX_CLK_POST(TX_CLK_POST[lvar*8 +: 8]),  
                .TX_CLK_PRE(TX_CLK_PRE[lvar*8 +: 4]),    
                .TX_HS_PREPARE(TX_HS_PREPARE[lvar*8 +: 6]), 
                .TX_HS_ZERO(TX_HS_ZERO[lvar*8 +: 8]),    
                .TX_HS_TRAIL(TX_HS_TRAIL[lvar*8 +: 8]),  
                .TX_INIT(TX_INIT[lvar*8 +: 8]),          
                .TX_WAKE(TX_WAKE[lvar*8 +: 8]),          
                .TX_TM_CONTROL_TX_TM_EN(TX_TM_CONTROL_TX_TM_EN[lvar]), 
                .TX_TM_CONTROL_TX_TM_LOOPBACK_MODE(TX_TM_CONTROL_TX_TM_LOOPBACK_MODE[lvar]), 
                .TX_HS_TM_DESKEW_P(TX_HS_TM_DESKEW_P[lvar*8 +: 8]) 
            ) dphy_pcs
           (
                .core_clk(link_core_clk[lvar]),                            
                .core_clk_1024(link_core_clk_1024[lvar]),
                .arst_n(link_arst_n[lvar]),                        
                .srst_n(link_srst_n[lvar]),                        
                .pll_lock(link_pll_lock[lvar]),
                .reg_bus(reg_bus_link),
                .dphy_port(dphy_io_connect),
                .tm_loopback_in(tm_loopback_in[lvar]),
                .tm_hs_in(tm_hs_in[lvar]),
                .tm_loopback_out(tm_loopback_out[lvar]),
                .tm_hs_out(tm_hs_out[lvar]),
                .dphy_dbg_dlane(dphy_dbg_dlane[lvar*8+7 : lvar*8]),
                .dphy_dbg_clane(dphy_dbg_clane[lvar]),
                .ppi_bus( ppi[lvar] )
            );

            // synthesis translate_off
            //if( DPHY_RX_EN[lvar] == 1 && SKEW_CAL_EN[lvar] == 1)
            // synthesis translate_on

            assign link_enable[lvar] = ppi[lvar].Enable[0];
            
            assign reg_bus_link.reg_clk = reg_bus.reg_clk;
            assign reg_bus_link.reg_srst_n = reg_bus.reg_srst_n;
            assign reg_bus_link.reg_wr_en = ~reg_bus.reg_waddr[8] & ( reg_bus.reg_waddr[11:9] == lvar[2:0] ? reg_bus.reg_wr_en : 1'b0);
            assign reg_bus_link.reg_rd_en = ~reg_bus.reg_raddr[8] & ( reg_bus.reg_raddr[11:9] == lvar[2:0] ? reg_bus.reg_rd_en : 1'b0);
            assign reg_bus_link.reg_be = reg_bus.reg_be;
            assign reg_bus_link.reg_din = reg_bus.reg_din;
            assign reg_bus_link.reg_raddr = reg_bus.reg_raddr[7:0];
            assign reg_bus_link.reg_waddr = reg_bus.reg_waddr[7:0];
            assign reg_dout[lvar] = reg_bus_link.reg_dout;
           
        end 
        else
        begin : dphy_link_unused
            assign reg_dout[lvar] = 32'h0;
            assign link_enable[lvar] = 1'b0;
        end 
        
    end 

    assign reg_bus.reg_dout = reg_dout[7] | reg_dout[6] | reg_dout[5] | reg_dout[4] |
                              reg_dout[3] | reg_dout[2] | reg_dout[1] | reg_dout[0] ;


endmodule 

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oK8X51I61z+yBf3yZVu3ivxsaaOeHqsBL0ycniHyaKpRSOR4jxWMK8vHQxsTye3WaZRiBE97Xb4NIWxwlq7fyMsb8BAGTfNJiVW4zRsTPr/SuNDaDk5w3u7gg28Oz5aW9QkQvHTpWexU81FJHOII1QmTxGcscy5/pIqat0cG9BZfJZGrcLfUENl5dd3+59nu28qcNcOhP70Gr4biM75DH1QuigMrHu/f35sNDy4BEkIRoUFNhkOu0HjsMipggLnqQxCYSyqP8axWPW/gcvhwZf3mF3ULy4nrnmfEe98oucjkeqsRAeffEH5wyZ7nUtTUdSTFhlM3U59y1yUtVtIq6cuJ+UCL/0YJmqPNp3Oa7H4w8mPKCtlI4BfU0fatJPugshTQY7oycYtnNYl9QZP9FtEmWfY3nePYL1BkuAMKpOenW53v16ovtLQ3AVfq5mHvloaND/MB5b0daKGFVrB0rflsXr5zC+bD7t0A3nf0o5eBZ8cqNSRa8eJqz/GTssayJbUowSkG/hmYGaSAEQHc/Q6fiZL1afQzb2OK6DtS3Sku60WcOdv3psphvz9CRQJLWMAMIKRx1xTtQZi986OmfJEfzRN+Kd7ptJm8Ld5V6IlZqcSp21RdHW3GYO44DAJ+xN5CrWNRafZZuKLiZRl0eCleKuNvVyEFfGDEAzmz5fvTQtWc42d26+3yaRFkwYHXhSiAGrMsS/KLcPiAtyWLsafu081Xr32bq6TaMl68e3g2HdIAXk9qXXAII0A+eFyMs+WQVSz7al/3s6YE1wtj+rG"
`endif
