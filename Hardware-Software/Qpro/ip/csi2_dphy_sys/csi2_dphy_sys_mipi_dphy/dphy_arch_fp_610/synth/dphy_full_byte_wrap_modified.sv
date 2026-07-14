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



`undef REVA

import dphy_pkg::*;
module dphy_full_byte_wrap #(
    parameter DEV_FAMILY = "FAMILY_AGILEX5",            
    parameter NUM_LANES = 4,                            
    parameter IO_CONVERT_RATIO = 16,                    
    parameter IO_CONVERT_RATIO_P2C = 16,                
    parameter IO_CONVERT_RATIO_C2P = 16,                
    parameter DPHY_RX_EN = 0,                           
    parameter DPHY_TX_EN = 0,                           
    parameter RX_DLANE_DESKEW_DELAY = 64'h0,            
    parameter TX_CLK_LANE_PS = 32,                      
    parameter VCO_FREQ_MULT = 4'b0001,                  
    parameter RX_CAP_EQ_MODE = 0,                       
    parameter TX_CAP_EQ_MODE = 0,                       
    parameter BYTE_LOC = 0,                             
    parameter CONTINUOUS_CLK = 0,                       
    parameter BYTE_CNT = NUM_LANES > 4 ? 2 : 1,         
    parameter BIT_RATE = 36'd3200000000,                
    parameter VCO_FREQ = 1600000000,                    
    parameter RZQ_ID = "RZQ0",                          
    parameter VCCN_VOLTAGE = "VCCN_VOLTAGE_1P2V"
    )
   (
        inout  [NUM_LANES-1:0] d_p,                     
        inout  [NUM_LANES-1:0] d_n,                     
        inout  ck_p,                                    
        inout  ck_n,                                    
        input  link_pll_lock,                           
        input  link_vco_clk,                            
        input  link_phy_clk,                            
        input  link_phy_clk_sync,                       
        input  link_core_clk,                           
        output logic [BYTE_CNT-1:0] rx_fwd_clk,         

        input  [BYTE_CNT*96-1:0]   c2p,                 
        input  [BYTE_CNT*20-1:0]   c2p_ctrl,            
        output logic [BYTE_CNT*96-1:0]   p2c,                 
        output logic [BYTE_CNT*4-1:0]    p2c_ctrl,            
        output logic [BYTE_CNT*12-1:0]   phy_gpio_din,         

        dphy_io_if                      dphy_io             
        
    );
    
    `ifdef DPHY_RTL_MODEL
    timeunit 1ns;
    timeprecision 1ps;
    `endif
    
    localparam DLANE_RX = DPHY_RX_EN == 1 ? NUM_LANES : 0;
    localparam DLANE_TX = DPHY_TX_EN == 1 ? NUM_LANES : 0;

    localparam int   PHY_PARKCLK_WIDTH         = 3;
 
    genvar BYTE_N;
    genvar LANE_N;
    genvar PAIR_N;
    

    wire [BYTE_CNT-1:0]      phy_clk_fr;                     
    wire [BYTE_CNT-1:0]      phy_clk_sync;                   
    wire [BYTE_CNT-1:0]      core_clk;                       

    wire [BYTE_CNT*96-1:0]   phy;                            
    wire [BYTE_CNT*96-1:0]   o_p2c;                            
    wire [BYTE_CNT*4-1:0]    p2c_phylite_ctrl;               
    wire [BYTE_CNT-1:0]      mipi_fwd_clk;                   
    wire [BYTE_CNT-1:0]      mipi_fwd_clk_o;                 
    wire [BYTE_CNT*96-1:0]   i_c2p;                          
    wire [BYTE_CNT*96-1:0]   c2p_phylite;                    
    wire [BYTE_CNT*20-1:0]   c2p_phylite_ctrl;               
    wire [BYTE_CNT*5-1:0]    fa2pa_gpio_dout_sel;            
    wire [BYTE_CNT*4-1:0]    fa2pa_rddata_en;                
    wire [BYTE_CNT*4-1:0]    fa2pa_wr_dqs_en;                
    wire [BYTE_CNT*96-1:0]   fa2pa_wrdata;                   
    wire [BYTE_CNT*4-1:0]    fa2pa_wrdata_en;                
    wire [BYTE_CNT*4-1:0]    fa2pa_rd_rank;                  
    wire [BYTE_CNT*4-1:0]    fa2pa_wr_rank;                  
    wire [BYTE_CNT-1:0]      phy_clk_hr;                     
    wire [BYTE_CNT*48-1:0]   phy2pa_rddata;                  
    wire [BYTE_CNT*2-1:0]    phy2pa_rddata_valid;            
    wire [BYTE_CNT-1:0]      phyclk_sync;                    
    wire [BYTE_CNT-1:0]      rxfwd_clk;                      
    wire [BYTE_CNT*96-1:0]   pa2fa_rddata;                   
    wire [BYTE_CNT*4-1:0]    pa2fa_rddata_valid;             
    wire [BYTE_CNT*12-1:0]   pa2phy_gpio_dout_sel;           
    wire [BYTE_CNT*2-1:0]    pa2phy_rddata_en;               
    wire [BYTE_CNT*2-1:0]    pa2phy_wr_dqs0_en;              
    wire [BYTE_CNT*2-1:0]    pa2phy_wr_dqs1_en;              
    wire [BYTE_CNT*4-1:0]    pa2phy_wr_rank;                 
    wire [BYTE_CNT*4-1:0]    pa2phy_rd_rank;                 
    wire [BYTE_CNT*48-1:0]   pa2phy_wrdata;                  
    wire [BYTE_CNT*2-1:0]    pa2phy_wrdata_en;               
    wire [BYTE_CNT-1:0]      rxfwd_clk_o;                    
    wire [BYTE_CNT*10-1:0]   fa2pa_mipi_lp_dout;             
    wire [BYTE_CNT*10-1:0]   mipi_lp_dout;                   
    wire [BYTE_CNT*12-1:0]   phy_pad_sig_i;                   
    wire [BYTE_CNT*12-1:0]   phy_pad_sig_o;                   
    wire [BYTE_CNT*12-1:0]   phy_pad_doe;                    
    wire [BYTE_CNT*48-1:0]   phy_tx_wr_data;                 
    wire [BYTE_CNT*48-1:0]   phy_core_data;                  
    wire [BYTE_CNT*12-1:0]   phy_gpio_dout;                  
    wire [BYTE_CNT*12-1:0]   phy_gpio_oe;                    
    wire [BYTE_CNT*12-1:0]   o_phy_gpio_din;                   
    wire [BYTE_CNT*12-1:0]   phy_gpio_dout_sel;              
    wire [BYTE_CNT*2-1:0]    phy_tx_wr_dqs_en4_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wr_dqs_en5_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wr_dqs_en6_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wr_dqs_en7_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en0_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en1_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en2_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en3_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en8_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en9_del;          
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en10_del;         
    wire [BYTE_CNT*2-1:0]    phy_tx_wrdata_en11_del;         
    wire [BYTE_CNT*4-1:0]    phy_tx_picode0;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode1;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode2;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode3;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode4;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode5;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode6;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode7;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode8;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode9;                 
    wire [BYTE_CNT*4-1:0]    phy_tx_picode10;                
    wire [BYTE_CNT*4-1:0]    phy_tx_picode11;                
    wire [BYTE_CNT*32-1:0]   phy_byte_tx_ctrl;               
    wire [BYTE_CNT-1:0]      phy_fifo_pack_select;           
    wire [BYTE_CNT*2-1:0]    phy_fifo_read_enable_upper;           
    wire [BYTE_CNT*2-1:0]    phy_fifo_read_enable_lower;           
    wire [BYTE_CNT-1:0]      phy_trainreset;                 
    wire [BYTE_CNT*32-1:0]   phy_byte_rx_ctrl;               
    wire [BYTE_CNT-1:0]      phy_txclk_gated;                
    wire [BYTE_CNT-1:0]      phy_rxclk_gated;                
    wire [BYTE_CNT-1:0]      phy_tx_clkrefdivby2;            
    wire [BYTE_CNT*12-1:0]   phy_tx_clkpi;                   
    wire [BYTE_CNT*6-1:0]    phy_sdll0_dqsp;                 
    wire [BYTE_CNT*6-1:0]    phy_sdll0_dqsn;                 
    wire [BYTE_CNT*6-1:0]    phy_sdll1_dqsp;                 
    wire [BYTE_CNT*6-1:0]    phy_sdll1_dqsn;                 
    wire [BYTE_CNT-1:0]      phy_rx_dqs_p4;                  
    wire [BYTE_CNT-1:0]      phy_rx_dqs_n4;                  
    wire [BYTE_CNT-1:0]      phy_rx_dqs_amp_p5;              
    wire [BYTE_CNT-1:0]      phy_rx_dqs_p6;                  
    wire [BYTE_CNT-1:0]      phy_rx_dqs_n6;                  
    wire [BYTE_CNT-1:0]      phy_rx_dqs_amp_p7;              
    wire [BYTE_CNT-1:0]      phy_rx_fwdclk;                  
    wire [BYTE_CNT*12-1:0]   phy_rx_senseampen;              
    wire [BYTE_CNT*6-1:0]    phy_sdll0_rx_d0pienable;        
    wire [BYTE_CNT-1:0]      phy_sdll0_rx_d0rcvenpre;        
    wire [BYTE_CNT-1:0]      phy_sdll0_rx_d0reset;           
    wire [BYTE_CNT*6-1:0]    phy_sdll1_rx_d0pienable;        
    wire [BYTE_CNT-1:0]      phy_sdll1_rx_d0rcvenpre;        
    wire [BYTE_CNT-1:0]      phy_sdll1_rx_d0reset;           
`ifdef REVA
    wire [BYTE_CNT-1:0]      phy_sdll1_rx_d0sdlparkvalue;    
    wire [BYTE_CNT-1:0]      phy_sdll0_rx_d0sdlparkvalue;    
`endif
    wire [BYTE_CNT*2-1:0]    phyctrl_rddata_valid_upper;           
    wire [BYTE_CNT*2-1:0]    phyctrl_rddata_valid_lower;           
    wire [BYTE_CNT*2-1:0]    phyctrl_dqs_en4_del;         
    wire [BYTE_CNT*2-1:0]    phyctrl_dqs_en5_del;         
    wire [BYTE_CNT*2-1:0]    phyctrl_dqs_en6_del;         
    wire [BYTE_CNT*2-1:0]    phyctrl_dqs_en7_del;         
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en0_del;            
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en1_del;            
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en2_del;            
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en3_del;            
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en8_del;            
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en9_del;            
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en10_del;           
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en11_del;           
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode0;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode1;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode2;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode3;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode4;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode5;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode6;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode7;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode8;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode9;             
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode10;            
    wire [BYTE_CNT*4-1:0]    phyctrl_tx_picode11;            
    wire [BYTE_CNT*32-1:0]   phyctrl_byte_tx_ctrl;           
    wire [BYTE_CNT-1:0]      phyctrl_fifo_pack_select;       
    wire [BYTE_CNT*2-1:0]    phyctrl_fifo_read_enable_upper;       
    wire [BYTE_CNT*2-1:0]    phyctrl_fifo_read_enable_lower;       
    wire [BYTE_CNT-1:0]      phyctrl_trainreset;             
    wire [BYTE_CNT*32-1:0]   phyctrl_byte_rx_ctrl;           
    wire [BYTE_CNT-1:0]      phyctrl_pll_lock;               
    wire [BYTE_CNT*2-1:0]    phyctrl_rddata_en;              
    wire [BYTE_CNT*2-1:0]    phyctrl_wr_dqs0_en;              
    wire [BYTE_CNT*2-1:0]    phyctrl_wr_dqs1_en;              
    wire [BYTE_CNT*2-1:0]    phyctrl_wrdata_en;              
    wire [BYTE_CNT-1:0]      phyctrl_pllvcoclk;              
    wire [BYTE_CNT-1:0]      phyctrl_phyclk_sync;            
    wire [BYTE_CNT-1:0]      phyctrl_phy_clk;                
    wire [BYTE_CNT-1:0]      phyctrl_gated_tx_phy_clk;       
    wire [BYTE_CNT-1:0]      phyctrl_gated_rx_phy_clk;       
    wire [BYTE_CNT-1:0]      phyctrl_tx_clkrefdivby2;        
    wire [BYTE_CNT*12-1:0]   phyctrl_tx_clkpi;               
    wire [BYTE_CNT*6-1:0]    phyctrl_sdll0_dqsp;             
    wire [BYTE_CNT*6-1:0]    phyctrl_sdll0_dqsn;             
    wire [BYTE_CNT*6-1:0]    phyctrl_sdll1_dqsp;             
    wire [BYTE_CNT*6-1:0]    phyctrl_sdll1_dqsn;             
    wire [BYTE_CNT-1:0]      phyctrl_rx_dqs_p4;              
    wire [BYTE_CNT-1:0]      phyctrl_rx_dqs_n4;              
    wire [BYTE_CNT-1:0]      phyctrl_rx_dqs_amp_p5;          
    wire [BYTE_CNT-1:0]      phyctrl_rx_dqs_p6;              
    wire [BYTE_CNT-1:0]      phyctrl_rx_dqs_n6;              
    wire [BYTE_CNT-1:0]      phyctrl_rx_dqs_amp_p7;          
    wire [BYTE_CNT*12-1:0]   phyctrl_pa_sideband;            
    wire [BYTE_CNT*12-1:0]   phyctrl_rx_senseampen;          
`ifdef REVA
    wire [BYTE_CNT-1:0]      phyctrl_sdll0_rx_d0sdlparkvalue;
    wire [BYTE_CNT-1:0]      phyctrl_sdll1_rx_d0sdlparkvalue;
`else
    wire [PHY_PARKCLK_WIDTH-1 : 0] phyctrl_parkclk_to_rxtop_n0_pl1 [BYTE_CNT-1:0]; 
    wire [PHY_PARKCLK_WIDTH-1 : 0] phyctrl_parkclk_to_rxtop_n1_pl1 [BYTE_CNT-1:0]; 
`endif
    wire [BYTE_CNT*6-1:0]    phyctrl_sdll0_rx_d0pienable;    
    wire [BYTE_CNT-1:0]      phyctrl_sdll0_rx_d0rcvenpre;    
    wire [BYTE_CNT-1:0]      phyctrl_sdll0_rx_d0reset;       
    wire [BYTE_CNT*6-1:0]    phyctrl_sdll1_rx_d0pienable;    
    wire [BYTE_CNT-1:0]      phyctrl_sdll1_rx_d0rcvenpre;    
    wire [BYTE_CNT-1:0]      phyctrl_sdll1_rx_d0reset;       
    wire [BYTE_CNT-1:0]      phyctrl_sdll1_dqspin_x16_clk;
    wire [BYTE_CNT-1:0]      phyctrl_sdll1_dqsnin_x16_clk;
    wire [BYTE_CNT-1:0]      phyctrl_sdll0_dqspin_x16_clk;
    wire [BYTE_CNT-1:0]      phyctrl_sdll0_dqsnin_x16_clk;
    
    wire [BYTE_CNT-1:0]      phyctrl_ckx16dqsn_to_bottom;
    wire [BYTE_CNT-1:0]      phyctrl_ckx16dqsp_to_bottom;
    wire [BYTE_CNT-1:0]      phyctrl_ckx16dqsn_to_top;
    wire [BYTE_CNT-1:0]      phyctrl_ckx16dqsp_to_top;

    wire [BYTE_CNT-1:0]      phyctrl_phyclk_notgated;
    wire [BYTE_CNT-1:0]      pa2phy_dram_clock_disable;
   wire [4:0] 		     DCCXtalkControl_DCCSamples[BYTE_CNT-1:0];
   wire 		     DCCXtalkControl_RunDCC[BYTE_CNT-1:0];
   wire [1:0] 		     DCCXtalkControl_SelMeasPoint[BYTE_CNT-1:0];   
   wire [4:0] 		     DDRCrRxEQRank01_RxDFETap0Rank0[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank01_RxDFETap1Rank0[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank01_RxDFETap2Rank0[BYTE_CNT-1:0];
   wire [2:0] 		     DDRCrRxEQRank01_RxDFETap3Rank0[BYTE_CNT-1:0];
   wire [4:0] 		     DDRCrRxEQRank01_RxDFETap0Rank1[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank01_RxDFETap1Rank1[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank01_RxDFETap2Rank1[BYTE_CNT-1:0];
   wire [2:0] 		     DDRCrRxEQRank01_RxDFETap3Rank1[BYTE_CNT-1:0];
   wire [4:0] 		     DDRCrRxEQRank23_RxDFETap0Rank2[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank23_RxDFETap1Rank2[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank23_RxDFETap2Rank2[BYTE_CNT-1:0];
   wire [2:0] 		     DDRCrRxEQRank23_RxDFETap3Rank2[BYTE_CNT-1:0];
   wire [4:0] 		     DDRCrRxEQRank23_RxDFETap0Rank3[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank23_RxDFETap1Rank3[BYTE_CNT-1:0];
   wire [3:0] 		     DDRCrRxEQRank23_RxDFETap2Rank3[BYTE_CNT-1:0];
   wire [2:0] 		     DDRCrRxEQRank23_RxDFETap3Rank3[BYTE_CNT-1:0];
    wire [4:0]	mipi_rb_rxdly_direct_ctrl[BYTE_CNT-1:0];
    wire [4:0]	mipi_rx_diff_en[BYTE_CNT-1:0];
    wire [4:0]	mipi_rx_dphylprxen[BYTE_CNT-1:0];
    wire [47:0]         phy_tx_wr_data_pl[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0]	phy_rx_x16dqsn_p4;
    wire [BYTE_CNT-1:0]	phy_rx_x16dqsp_p4;
    wire [11:0]   	rx_rxdqsampresult[BYTE_CNT-1:0];   
    wire [11:0]         rxdphylprxen[BYTE_CNT-1:0];
    wire [11:0]         rxlvdien[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] rzq_en;
    wire [2:0]          tx_modectrl_4[BYTE_CNT-1:0];		
    wire [1:0]          dqsmode[BYTE_CNT-1:0];
    wire [1:0]          n0_odt_seg_rotate_en[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] dcd_ter_en;
    wire [BYTE_CNT-1:0] from_sdll0_o_dcdsawl_clk;
    wire [BYTE_CNT-1:0] from_sdll1_o_dcdsawl_clk;
    wire [1:0]          n1_odt_seg_rotate_en[BYTE_CNT-1:0];
    wire [11:0]         odt_en[BYTE_CNT-1:0];
    wire [11:0]         odt_parken[BYTE_CNT-1:0];
    wire [11:0]         odt_parken_dqsn[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] phyctrl_ddrcrdatacontrol0_enodtrotation;
    wire [BYTE_CNT-1:0] phyctrl_ddrcrdatacontrol4_unmatchedrx;
    wire [11:0]         phyctrl_dfemuxout_0[BYTE_CNT-1:0];
    wire [11:0]         phyctrl_dfemuxout_1[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] phyctrl_o_occ_phy_clk;
    wire [11:0]         phyctrl_rcvenmuxout_0[BYTE_CNT-1:0];
    wire [11:0]         phyctrl_rcvenmuxout_1[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_rddata_en_dly[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] phyctrl_rx_d0cben;   
    wire [BYTE_CNT-1:0] phyctrl_rx_d0drvsel;
    wire [BYTE_CNT-1:0] phyctrl_rxfifo_rb_avm_wr_pipestage;
    wire [BYTE_CNT-1:0] phyctrl_phy_clk_gated;
    wire [BYTE_CNT-1:0] phyctrl_phy_reset_n;   
    wire [1:0]          phyctrl_wrdata_en0[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wrdata_en1[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wrdata_en2[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wrdata_en3[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wr_dqs_en4[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wr_dqs_en5[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wr_dqs_en6[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wr_dqs_en7[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wrdata_en8[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wrdata_en9[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wrdata_en10[BYTE_CNT-1:0];
    wire [1:0]          phyctrl_wrdata_en11[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_00_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_01_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_02_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_03_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_04_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_05_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_06_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_07_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_08_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_09_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_10_dcccount[BYTE_CNT-1:0];
    wire [16:0]         phyctrl_x1counterdccpin_11_dcccount[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] 	rxfifo_skew;
    wire [13:0] 	rxfifo_spare[BYTE_CNT-1:0];
    wire [11:0]         rxnpathenable[BYTE_CNT-1:0];
    wire [11:0]         rxppathenable[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0]	pa2phy_rxanalogen;
    wire [BYTE_CNT-1:0] pa2phy_txanalogen;
    wire [3:0]          phy_datatrainfeedback_dqsnparklovohcode[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] phy_datatrainfeedback_dqsnparklowvoh;   
    wire [11:0]         phyctrl_ddrcrcmdbustrain_ddrdqovrddata[BYTE_CNT-1:0];  
    wire [11:0]         phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen[BYTE_CNT-1:0];
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_00;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_01;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_02;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_03;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_04;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_05;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_06;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_07;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_08;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_09;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_10;
    wire [BYTE_CNT-1:0] 	phyctrl_cr_iamca_11;
   
   wire [BYTE_CNT-1:0] 	        mipi_idle;
   wire [BYTE_CNT-1:0] 		txdigitop_0_o_tx_drven_ph0;
   wire [BYTE_CNT-1:0] 		txdigitop_0_o_tx_drven_ph1;
   wire [BYTE_CNT-1:0] 		txdigitop_4_o_tx_drven_ph0;
   wire [BYTE_CNT-1:0] 		txdigitop_4_o_tx_drven_ph1;
   wire [1:0] 			delayed_oe_p0[BYTE_CNT-1:0];
   wire [1:0] 			delayed_oe_p4[BYTE_CNT-1:0];
   wire [11:0]                  rb_txfifo_in_sel[BYTE_CNT-1:0];			
   wire [BYTE_CNT-1:0] 		occ_mux_auxclk;
   wire [BYTE_CNT-1:0] 		nbiasen, pbiasen;
   
   
   
    /*
    initial 
    begin
        #205us
        $dumpfile("io12.vcd");
        $dumpvars(0);
    end
    */

    assign p2c_phylite_ctrl =  pa2fa_rddata_valid;

    assign phyctrl_rddata_en = pa2phy_rddata_en;              
    assign phyctrl_wr_dqs0_en = pa2phy_wr_dqs0_en;              
    assign phyctrl_wr_dqs1_en = pa2phy_wr_dqs1_en;              
    assign phyctrl_wrdata_en = pa2phy_wrdata_en;              
    assign rxfwd_clk = phy_rx_fwdclk;
    assign phy2pa_rddata_valid = phyctrl_rddata_valid_lower;


    assign phy_tx_wr_dqs_en4_del = phyctrl_dqs_en4_del;          
    assign phy_tx_wr_dqs_en5_del = phyctrl_dqs_en5_del;          
    assign phy_tx_wr_dqs_en6_del = phyctrl_dqs_en6_del;          
    assign phy_tx_wr_dqs_en7_del = phyctrl_dqs_en7_del;          
    assign phy_tx_wrdata_en0_del = phyctrl_wrdata_en0_del;             
    assign phy_tx_wrdata_en1_del = phyctrl_wrdata_en1_del;             
    assign phy_tx_wrdata_en2_del = phyctrl_wrdata_en2_del;             
    assign phy_tx_wrdata_en3_del = phyctrl_wrdata_en3_del;             
    assign phy_tx_wrdata_en8_del = phyctrl_wrdata_en8_del;             
    assign phy_tx_wrdata_en9_del = phyctrl_wrdata_en9_del;             
    assign phy_tx_wrdata_en10_del = phyctrl_wrdata_en10_del;           
    assign phy_tx_wrdata_en11_del = phyctrl_wrdata_en11_del;           
    assign phy_tx_picode0 =  phyctrl_tx_picode0;                    
    assign phy_tx_picode1 =  phyctrl_tx_picode1;                    
    assign phy_tx_picode2 =  phyctrl_tx_picode2;                    
    assign phy_tx_picode3 =  phyctrl_tx_picode3;                    
    assign phy_tx_picode4 =  phyctrl_tx_picode4;                    
    assign phy_tx_picode5 =  phyctrl_tx_picode5;                    
    assign phy_tx_picode6 =  phyctrl_tx_picode6;                    
    assign phy_tx_picode7 =  phyctrl_tx_picode7;                    
    assign phy_tx_picode8 =  phyctrl_tx_picode8;                    
    assign phy_tx_picode9 =  phyctrl_tx_picode9;                    
    assign phy_tx_picode10 = phyctrl_tx_picode10;                   
    assign phy_tx_picode11 = phyctrl_tx_picode11;                   
    assign phy_byte_tx_ctrl = phyctrl_byte_tx_ctrl;               
    assign phy_fifo_pack_select = phyctrl_fifo_pack_select;           
    assign phy_fifo_read_enable_upper = phyctrl_fifo_read_enable_upper;           
    assign phy_fifo_read_enable_lower = phyctrl_fifo_read_enable_lower;           
    assign phy_trainreset = phyctrl_trainreset;                 
    assign phy_byte_rx_ctrl = phyctrl_byte_rx_ctrl;               
    assign phy_txclk_gated = phyctrl_gated_tx_phy_clk;                
    assign phy_rxclk_gated = phyctrl_gated_rx_phy_clk;                
    assign phy_tx_clkrefdivby2 = phyctrl_tx_clkrefdivby2;            
    assign phy_tx_clkpi = phyctrl_tx_clkpi;                   
    assign phy_sdll0_dqsp = phyctrl_sdll0_dqsp;                 
    assign phy_sdll0_dqsn = phyctrl_sdll0_dqsn;                 
    assign phy_sdll1_dqsp = phyctrl_sdll1_dqsp;                 
    assign phy_sdll1_dqsn = phyctrl_sdll1_dqsn;                 
    assign phyctrl_rx_dqs_p4 = phy_rx_dqs_p4;                  
    assign phyctrl_rx_dqs_n4 = phy_rx_dqs_n4;                  
    assign phyctrl_rx_dqs_amp_p5 = phy_rx_dqs_amp_p5;              
    assign phyctrl_rx_dqs_p6 = phy_rx_dqs_p6;                  
    assign phyctrl_rx_dqs_n6 = phy_rx_dqs_n6;                  
    assign phyctrl_rx_dqs_amp_p7 = phy_rx_dqs_amp_p7;              
    assign phy_rx_senseampen = phyctrl_rx_senseampen;              
    assign phy_sdll0_rx_d0pienable = phyctrl_sdll0_rx_d0pienable;        
    assign phy_sdll0_rx_d0rcvenpre = phyctrl_sdll0_rx_d0rcvenpre;        
    assign phy_sdll0_rx_d0reset = phyctrl_sdll0_rx_d0reset;           
`ifdef REVA
    assign phy_sdll0_rx_d0sdlparkvalue = phyctrl_sdll0_rx_d0sdlparkvalue;    
    assign phy_sdll1_rx_d0sdlparkvalue = phyctrl_sdll1_rx_d0sdlparkvalue;    
`endif
    assign phy_sdll1_rx_d0pienable = phyctrl_sdll1_rx_d0pienable;        
    assign phy_sdll1_rx_d0rcvenpre = phyctrl_sdll1_rx_d0rcvenpre;        
    assign phy_sdll1_rx_d0reset = phyctrl_sdll1_rx_d0reset;           
    
    if(BYTE_CNT > 1)
    begin : dqs_x16_byte
        assign phyctrl_sdll1_dqspin_x16_clk[0] = phyctrl_ckx16dqsp_to_top[0];
        assign phyctrl_sdll1_dqsnin_x16_clk[0] = phyctrl_ckx16dqsn_to_top[0];
        assign phyctrl_sdll0_dqspin_x16_clk[0] = phyctrl_ckx16dqsp_to_top[0];
        assign phyctrl_sdll0_dqsnin_x16_clk[0] = phyctrl_ckx16dqsn_to_top[0];
        assign phyctrl_sdll1_dqspin_x16_clk[1] = phyctrl_ckx16dqsp_to_bottom[0];
        assign phyctrl_sdll1_dqsnin_x16_clk[1] = phyctrl_ckx16dqsn_to_bottom[0];
        assign phyctrl_sdll0_dqspin_x16_clk[1] = phyctrl_ckx16dqsp_to_bottom[0];
        assign phyctrl_sdll0_dqsnin_x16_clk[1] = phyctrl_ckx16dqsn_to_bottom[0];
    end
    else begin : dqs_x8_byte
        if(BYTE_LOC&1 == 1)
        begin : dqs_x8_byte_odd
            assign phyctrl_sdll1_dqspin_x16_clk[0] = '0;
            assign phyctrl_sdll1_dqsnin_x16_clk[0] = '0;
            assign phyctrl_sdll0_dqspin_x16_clk[0] = '0;
            assign phyctrl_sdll0_dqsnin_x16_clk[0] = '0;
        end
        else 
        begin : dqs_x8_byte_even
            assign phyctrl_sdll1_dqspin_x16_clk[0] = phyctrl_ckx16dqsp_to_top[0];
            assign phyctrl_sdll1_dqsnin_x16_clk[0] = phyctrl_ckx16dqsn_to_top[0];
            assign phyctrl_sdll0_dqspin_x16_clk[0] = phyctrl_ckx16dqsp_to_top[0];
            assign phyctrl_sdll0_dqsnin_x16_clk[0] = phyctrl_ckx16dqsn_to_top[0];
        end
    end


    
    for(BYTE_N = 0; BYTE_N < BYTE_CNT; BYTE_N++)
    begin : byte_in_link
        localparam NUM_LANES_BYTE = ( BYTE_CNT == 2 && BYTE_N == 0 ) ? 4 : NUM_LANES - 4 * BYTE_N;
        localparam CONVERT_RATIO = DPHY_RX_EN == 1 ? IO_CONVERT_RATIO_C2P : IO_CONVERT_RATIO;
        localparam PAIR_USED = ( NUM_LANES_BYTE == 4 && BYTE_N == 0 ) ? 6'b011111 : 
                                 NUM_LANES_BYTE == 4 ? 6'b011011 : 
                                 NUM_LANES_BYTE == 2 ? 6'b000111 : 
                                 NUM_LANES_BYTE == 1 ? 6'b000101 : 
                                6'b000000;        

       assign phy_gpio_oe[BYTE_N*12 +: 12] = 12'd0;
       assign phyctrl_pa_sideband[BYTE_N*12 +: 12] = 12'd0;
       if (DPHY_TX_EN == 1)
	 begin:drv0_0
	    assign rx_fwd_clk[BYTE_N] = 1'b0;
	    assign mipi_fwd_clk[BYTE_N] = 1'b0;
	    assign phy_pad_sig_i[BYTE_N*12 +: 12] = 12'd0;
	 end
       
        for (PAIR_N = 0; PAIR_N < 6; PAIR_N++)
        begin : pair_muxes
            if(PAIR_USED[PAIR_N] == 1'b1)
            begin : pair_used
                assign p2c[BYTE_N*96 + PAIR_N * 16 +: 16] = o_p2c[BYTE_N*96 + PAIR_N * 16 +: 16] ;
                assign i_c2p[BYTE_N*96 + PAIR_N * 16 +: 16] = c2p[BYTE_N*96 + PAIR_N * 16 +: 16] ;
                
                assign phy_gpio_din[BYTE_N*12 + PAIR_N * 2 +: 2] = o_phy_gpio_din[BYTE_N*12 + PAIR_N * 2 +: 2];
                assign phy_gpio_dout_sel[BYTE_N*12 + PAIR_N * 2 +: 2] =  pa2phy_gpio_dout_sel[BYTE_N*12 + PAIR_N * 2 +: 2];
                assign phy_gpio_dout[BYTE_N*12 + PAIR_N * 2 +: 2] =  mipi_lp_dout[BYTE_N*10 + PAIR_N * 2 +: 2];
                assign fa2pa_mipi_lp_dout[BYTE_N*10 + PAIR_N * 2 +: 2] = PAIR_N == 4 ? c2p_ctrl[BYTE_N*20+16 +: 2] : 
                                                                                       c2p_ctrl[BYTE_N*20 + PAIR_N * 2 +: 2];
                assign fa2pa_gpio_dout_sel[BYTE_N*5 + PAIR_N] = PAIR_N > 1 ? c2p_ctrl[BYTE_N*20+10 + PAIR_N] :
                                                                             c2p_ctrl[BYTE_N*20+18 + PAIR_N];
                
                assign phy[BYTE_N*96 + PAIR_N * 16 +: 16] =  pa2fa_rddata[BYTE_N*96 + PAIR_N * 16 +: 16];
                assign fa2pa_wrdata[BYTE_N*96 + PAIR_N * 16 +: 16] = c2p_phylite[BYTE_N*96 + PAIR_N * 16 +: 16];
                assign phy_tx_wr_data[BYTE_N*48 + PAIR_N * 8 +: 8] = pa2phy_wrdata[BYTE_N*48 + PAIR_N * 8 +: 8];
                assign phy2pa_rddata[BYTE_N*48 + PAIR_N * 8 +: 8] = phy_core_data[BYTE_N*48 + PAIR_N * 8 +: 8];

            end
            else
            begin : pair_unused
	       assign p2c[BYTE_N*96 + PAIR_N * 16 +: 16] = {16{1'b0}};
	       assign i_c2p[BYTE_N*96 + PAIR_N * 16 +: 16] = {16{1'b0}};
	       assign phy_gpio_din[BYTE_N*12 + PAIR_N * 2 +: 2] = {2{1'b0}};
	       assign phy_gpio_dout_sel[BYTE_N*12 + PAIR_N * 2 +: 2] = {2{1'b0}};
	       assign phy_gpio_dout[BYTE_N*12 + PAIR_N * 2 +: 2] = {2{1'b0}};
	       assign phy_tx_wr_data[BYTE_N*48 + PAIR_N * 8 +: 8] = {8{1'b0}};
	       assign phy2pa_rddata[BYTE_N*48 + PAIR_N * 8 +: 8] = {8{1'b0}};
	       assign phy[BYTE_N*96 + PAIR_N * 16 +: 16] = {16{1'b0}};
	       assign fa2pa_wrdata[BYTE_N*96 + PAIR_N * 16 +: 16] = {16{1'b0}};
	       if (PAIR_N < 5)
		 begin : pair_unused_2
		    assign fa2pa_mipi_lp_dout[BYTE_N*10 + PAIR_N * 2 +: 2] = {2{1'b0}};
		    assign fa2pa_gpio_dout_sel[BYTE_N*5 + PAIR_N] = 1'b0;
		 end
	       if(DPHY_RX_EN == 1)
		 begin : rx_pair_unused
		    assign phy_pad_sig_i[BYTE_N*12 + PAIR_N * 2 +: 2] = {2{1'b0}};
		 end
            end
        end


        assign phy_clk_fr[BYTE_N] = link_phy_clk;
        assign phy_clk_sync[BYTE_N] = link_phy_clk_sync;
        assign core_clk[BYTE_N] = link_core_clk;
        if(DPHY_RX_EN == 1)
        begin : fwd_clk_mux
            assign mipi_fwd_clk[BYTE_N] = rxfwd_clk_o[BYTE_N];
            assign rx_fwd_clk[BYTE_N] = mipi_fwd_clk_o[BYTE_N];
        end
    
        dphy_fa_p2c_lane_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .FA_CORE_PERIPH_CLK_SEL_DATA_MODE( DPHY_RX_EN == 1 ? "FA_CORE_PERIPH_CLK_SEL_DATA_MODE_UNUSED" : "FA_CORE_PERIPH_CLK_SEL_DATA_MODE_PHYCLK_DIV2" ),
            .FWD_CLOCK_DIVIDE_DATA_MODE( DPHY_RX_EN == 1 ? (IO_CONVERT_RATIO == 8 ? "FWD_CLOCK_DIVIDE_DATA_MODE_BYPASS" : "FWD_CLOCK_DIVIDE_DATA_MODE_DIV2") : "FWD_CLOCK_DIVIDE_DATA_MODE_UNUSED" ),
            .IO12LANE_P2C_DATA_MODE( IO_CONVERT_RATIO ==  8 ? "IO12LANE_P2C_DATA_MODE_REG" : "IO12LANE_P2C_DATA_MODE_TDM" )
        ) fa_p2c_lane_wrap_inst (
            .i_hmc(),                                                     
            .i_phy( phy[BYTE_N*96 +: 96] ),                               
            .o_p2c( o_p2c[BYTE_N*96 +: 96] ),                             
            .i_p2c_phylite_ctrl( p2c_phylite_ctrl[BYTE_N*4 +: 4] ),       
            .i_p2c_hmc_ctrl(),                                            
            .o_p2c_ctrl( p2c_ctrl[BYTE_N*4 +: 4] ),                       
            .i_phy_clk_fr( phy_clk_fr[BYTE_N] ),                          
            .i_phy_clk_sync( phy_clk_sync[BYTE_N] ),                      
            .i_core_clk( 1'b0 ),                                          
            .i_mipi_fwd_clk( mipi_fwd_clk[BYTE_N] ),                      
            .o_mipi_fwd_clk( mipi_fwd_clk_o[BYTE_N] )                     
        );

        dphy_fa_c2p_lane_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .FA_CORE_PERIPH_CLK_SEL_DATA_MODE( "FA_CORE_PERIPH_CLK_SEL_DATA_MODE_PHYCLK_DIV2" ),
            .IO12LANE_C2P_DATA_MODE( CONVERT_RATIO == 8 ? "IO12LANE_C2P_DATA_MODE_REG_MIPI" : "IO12LANE_C2P_DATA_MODE_TDM_MIPI" ),
            .IO_CONVERT_RATIO_C2P(IO_CONVERT_RATIO_C2P)
        ) fa_c2p_lane_wrap_inst (
            .o_c2p_hmc(  ),                                               
            .o_c2p_phylite( c2p_phylite[BYTE_N*96 +: 96] ),               
            .i_c2p( i_c2p[BYTE_N*96 +: 96] ),                             
            .i_c2p_ctrl( c2p_ctrl[BYTE_N*20 +: 20] ),                     
            .o_c2p_phylite_ctrl( c2p_phylite_ctrl[BYTE_N*20 +: 20] ),     
            .o_c2p_hmc_ctrl(  ),                                          
            .i_phy_clk_fr( phy_clk_fr[BYTE_N] ),                          
            .i_phy_clk_sync( phy_clk_sync[BYTE_N] ),                      
            .i_core_clk( 1'b0 )                                           
        );

        
        assign phy_clk_hr[BYTE_N] = link_phy_clk;
        assign phyclk_sync[BYTE_N] = link_phy_clk_sync;
        
        
        assign fa2pa_rddata_en[BYTE_N*4 +: 4] = c2p_phylite_ctrl[BYTE_N*20+8 +: 4];                    
        assign fa2pa_wr_dqs_en[BYTE_N*4 +: 4] = c2p_phylite_ctrl[BYTE_N*20+12 +: 4];                    
        assign fa2pa_wrdata_en[BYTE_N*4 +: 4] = c2p_phylite_ctrl[BYTE_N*20+16 +: 4];                    
        assign fa2pa_rd_rank[BYTE_N*4 +: 4] = c2p_phylite_ctrl[BYTE_N*20+0 +: 4];                    
        assign fa2pa_wr_rank[BYTE_N*4 +: 4] = c2p_phylite_ctrl[BYTE_N*20+4 +: 4];                    

        dphy_phy_adaptor_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .BYTE_N(BYTE_N),
            .NUM_LANES(NUM_LANES)
        ) phy_adaptor_wrap_inst (
            .o_pa2phy_dram_clock_disable(pa2phy_dram_clock_disable[BYTE_N]),
            .o_pa2phy_wr_dqs0_en( pa2phy_wr_dqs0_en[BYTE_N*2 +: 2] ),     
            .o_pa2phy_wr_dqs1_en( pa2phy_wr_dqs1_en[BYTE_N*2 +: 2] ),     
            .i_ctr2pa_dram_clock_disable(),
            
            .i_fa2pa_gpio_dout_sel( fa2pa_gpio_dout_sel[BYTE_N*5 +: 5] ), 
            .i_fa2pa_rddata_en( fa2pa_rddata_en[BYTE_N*4 +: 4] ),         
            .i_fa2pa_rd_rank( fa2pa_rd_rank[BYTE_N*4 +: 4] ),             
            .i_fa2pa_wr_rank( fa2pa_wr_rank[BYTE_N*4 +: 4] ),             
            .i_fa2pa_wr_dqs_en( fa2pa_wr_dqs_en[BYTE_N*4 +: 4] ),         
            .i_fa2pa_wrdata( fa2pa_wrdata[BYTE_N*96 +: 96] ),             
            .i_fa2pa_wrdata_en( fa2pa_wrdata_en[BYTE_N*4 +: 4] ),         
            .i_phy_clk_hr( phy_clk_hr[BYTE_N] ),                          
            .i_phy2pa_rddata( phy2pa_rddata[BYTE_N*48 +: 48] ),           
            .i_phy2pa_rddata_valid( phy2pa_rddata_valid[BYTE_N*2 +: 2] ), 
            .i_phyclk_sync( phyclk_sync[BYTE_N] ),                        
            .i_rxfwd_clk( rxfwd_clk[BYTE_N] ),                            
            .o_pa2fa_rddata( pa2fa_rddata[BYTE_N*96 +: 96] ),             
            .o_pa2fa_rddata_valid( pa2fa_rddata_valid[BYTE_N*4 +: 4] ),   
            .o_pa2phy_gpio_dout_sel( pa2phy_gpio_dout_sel[BYTE_N*12 +: 12] ), 
            .o_pa2phy_rddata_en( pa2phy_rddata_en[BYTE_N*2 +: 2] ),       
            .o_pa2phy_wr_rank( pa2phy_wr_rank[BYTE_N*4 +: 4] ),             
            .o_pa2phy_rd_rank( pa2phy_rd_rank[BYTE_N*4 +: 4] ),             
            .o_pa2phy_wrdata( pa2phy_wrdata[BYTE_N*48 +: 48] ),           
            .o_pa2phy_wrdata_en( pa2phy_wrdata_en[BYTE_N*2 +: 2] ),       
            .o_rxfwd_clk( rxfwd_clk_o[BYTE_N] ),                          
            .i_fa2pa_mipi_lp_dout( fa2pa_mipi_lp_dout[BYTE_N*10 +: 10] ), 
            .o_mipi_lp_dout( mipi_lp_dout[BYTE_N*10 +: 10] ),             
            .o_pa2phy_rxanalogen(pa2phy_rxanalogen[BYTE_N]),
            .o_pa2phy_txanalogen(pa2phy_txanalogen[BYTE_N])
        );


`ifdef DPHY_RTL_MODEL


       


`endif


        dphy_byte_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .BYTE_N(BYTE_N),
            .DPHY_RX_EN(DPHY_RX_EN),
            .DPHY_TX_EN(DPHY_TX_EN),
            .NUM_LANES(NUM_LANES_BYTE),
	    .BIT_RATE(BIT_RATE),
            .CONTINUOUS_CLK(CONTINUOUS_CLK),
            .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE),
            .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE),
            .RZQ_ID(RZQ_ID),
	    .VCCN_VOLTAGE(VCCN_VOLTAGE)
        ) byte_wrap_inst (
            .io_phy_pad_sig_bidir_out( phy_pad_sig_o[BYTE_N*12 +: 12] ),  
            .io_phy_pad_sig_bidir_in( phy_pad_sig_i[BYTE_N*12 +: 12] ),   
            .o_phy_pad_doe( phy_pad_doe[BYTE_N*12 +: 12] ),               
            .i_phy_tx_wr_data( phy_tx_wr_data[BYTE_N*48 +: 48] ),         
            .o_phy_core_data( phy_core_data[BYTE_N*48 +: 48] ),           
            .i_phy_gpio_dout( phy_gpio_dout[BYTE_N*12 +: 12] ),           
            .i_phy_gpio_oe( phy_gpio_oe[BYTE_N*12 +: 12] ),               
            .o_phy_gpio_din( o_phy_gpio_din[BYTE_N*12 +: 12] ),             
            .i_phy_gpio_dout_sel( phy_gpio_dout_sel[BYTE_N*12 +: 12] ),   
            .i_phyclk_notgated(phyctrl_phyclk_notgated[BYTE_N]),
            .i_phy_dfi_dram_clock_disable(pa2phy_dram_clock_disable[BYTE_N]),
            
            .i_phy_tx_wr_dqs_en4_del( phy_tx_wr_dqs_en4_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wr_dqs_en5_del( phy_tx_wr_dqs_en5_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wr_dqs_en6_del( phy_tx_wr_dqs_en6_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wr_dqs_en7_del( phy_tx_wr_dqs_en7_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en0_del( phy_tx_wrdata_en0_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en1_del( phy_tx_wrdata_en1_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en2_del( phy_tx_wrdata_en2_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en3_del( phy_tx_wrdata_en3_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en8_del( phy_tx_wrdata_en8_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en9_del( phy_tx_wrdata_en9_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en10_del( phy_tx_wrdata_en10_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_wrdata_en11_del( phy_tx_wrdata_en11_del[BYTE_N*2 +: 2] ), 
            .i_phy_tx_picode0( phy_tx_picode0[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode1( phy_tx_picode1[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode2( phy_tx_picode2[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode3( phy_tx_picode3[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode4( phy_tx_picode4[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode5( phy_tx_picode5[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode6( phy_tx_picode6[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode7( phy_tx_picode7[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode8( phy_tx_picode8[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode9( phy_tx_picode9[BYTE_N*4 +: 4] ),           
            .i_phy_tx_picode10( phy_tx_picode10[BYTE_N*4 +: 4] ),         
            .i_phy_tx_picode11( phy_tx_picode11[BYTE_N*4 +: 4] ),         
            .i_phy_byte_tx_ctrl( phy_byte_tx_ctrl[BYTE_N*32 +: 32] ),     
            .i_phy_fifo_pack_select( phy_fifo_pack_select[BYTE_N] ),      
            .i_phy_fifo_read_enable_upper( phy_fifo_read_enable_upper[BYTE_N*2 +: 2] ), 
            .i_phy_fifo_read_enable_lower( phy_fifo_read_enable_lower[BYTE_N*2 +: 2] ), 
            .i_phy_trainreset( phy_trainreset[BYTE_N] ),                  
            .i_phy_byte_rx_ctrl( phy_byte_rx_ctrl[BYTE_N*32 +: 32] ),     
            .i_phy_txclk_gated( phy_txclk_gated[BYTE_N] ),                
            .i_phy_rxclk_gated( phy_rxclk_gated[BYTE_N] ),                
            .i_phy_tx_clkrefdivby2( phy_tx_clkrefdivby2[BYTE_N] ),        
            .i_phy_tx_clkpi( phy_tx_clkpi[BYTE_N*12 +: 12] ),             
            .i_phy_sdll0_dqsp( phy_sdll0_dqsp[BYTE_N*6 +: 6] ),           
            .i_phy_sdll0_dqsn( phy_sdll0_dqsn[BYTE_N*6 +: 6] ),           
            .i_phy_sdll1_dqsp( phy_sdll1_dqsp[BYTE_N*6 +: 6] ),           
            .i_phy_sdll1_dqsn( phy_sdll1_dqsn[BYTE_N*6 +: 6] ),           
            .o_phy_rx_dqs_p4( phy_rx_dqs_p4[BYTE_N] ),                    
            .o_phy_rx_dqs_n4( phy_rx_dqs_n4[BYTE_N] ),                    
            .o_phy_rx_dqs_amp_p5( phy_rx_dqs_amp_p5[BYTE_N] ),            
            .o_phy_rx_dqs_p6( phy_rx_dqs_p6[BYTE_N] ),                    
            .o_phy_rx_dqs_n6( phy_rx_dqs_n6[BYTE_N] ),                    
            .o_phy_rx_dqs_amp_p7( phy_rx_dqs_amp_p7[BYTE_N] ),            
            .o_phy_rx_fwdclk( phy_rx_fwdclk[BYTE_N] ),                    
            .i_phy_rx_senseampen( phy_rx_senseampen[BYTE_N*12 +: 12] ),   
            .i_phy_sdll0_rx_d0pienable( phy_sdll0_rx_d0pienable[BYTE_N*6 +: 6] ), 
            .i_phy_sdll0_rx_d0rcvenpre( phy_sdll0_rx_d0rcvenpre[BYTE_N] ), 
            .i_phy_sdll0_rx_d0reset( phy_sdll0_rx_d0reset[BYTE_N] ),      
`ifdef REVA
            .i_phy_sdll0_rx_d0sdlparkvalue( phy_sdll0_rx_d0sdlparkvalue[BYTE_N] ), 
            .i_phy_sdll1_rx_d0sdlparkvalue( phy_sdll1_rx_d0sdlparkvalue[BYTE_N] ),  
`else
            .i_phy_parkclk_to_rxtop_n0_pl1( phyctrl_parkclk_to_rxtop_n0_pl1[BYTE_N][PHY_PARKCLK_WIDTH-1:0]) ,
            .i_phy_parkclk_to_rxtop_n1_pl1( phyctrl_parkclk_to_rxtop_n1_pl1[BYTE_N][PHY_PARKCLK_WIDTH-1:0]) ,
`endif
            .i_phy_sdll1_rx_d0pienable( phy_sdll1_rx_d0pienable[BYTE_N*6 +: 6] ), 
            .i_phy_sdll1_rx_d0rcvenpre( phy_sdll1_rx_d0rcvenpre[BYTE_N] ), 
            .i_phy_sdll1_rx_d0reset( phy_sdll1_rx_d0reset[BYTE_N] ),      
	    .o_DCCXtalkControl_DCCSamples(DCCXtalkControl_DCCSamples[BYTE_N][4:0]),
	    .o_DCCXtalkControl_RunDCC(DCCXtalkControl_RunDCC[BYTE_N]),
 	    .o_DCCXtalkControl_SelMeasPoint(DCCXtalkControl_SelMeasPoint[BYTE_N][1:0]),
            .o_DDRCrRxEQRank01_RxDFETap0Rank0(DDRCrRxEQRank01_RxDFETap0Rank0[BYTE_N][4:0]),
            .o_DDRCrRxEQRank01_RxDFETap1Rank0(DDRCrRxEQRank01_RxDFETap1Rank0[BYTE_N][3:0]),
            .o_DDRCrRxEQRank01_RxDFETap2Rank0(DDRCrRxEQRank01_RxDFETap2Rank0[BYTE_N][3:0]),
            .o_DDRCrRxEQRank01_RxDFETap3Rank0(DDRCrRxEQRank01_RxDFETap3Rank0[BYTE_N][2:0]),
            .o_DDRCrRxEQRank01_RxDFETap0Rank1(DDRCrRxEQRank01_RxDFETap0Rank1[BYTE_N][4:0]),
            .o_DDRCrRxEQRank01_RxDFETap1Rank1(DDRCrRxEQRank01_RxDFETap1Rank1[BYTE_N][3:0]),
            .o_DDRCrRxEQRank01_RxDFETap2Rank1(DDRCrRxEQRank01_RxDFETap2Rank1[BYTE_N][3:0]),
            .o_DDRCrRxEQRank01_RxDFETap3Rank1(DDRCrRxEQRank01_RxDFETap3Rank1[BYTE_N][2:0]),
            .o_DDRCrRxEQRank23_RxDFETap0Rank2(DDRCrRxEQRank23_RxDFETap0Rank2[BYTE_N][4:0]),
            .o_DDRCrRxEQRank23_RxDFETap1Rank2(DDRCrRxEQRank23_RxDFETap1Rank2[BYTE_N][3:0]),
            .o_DDRCrRxEQRank23_RxDFETap2Rank2(DDRCrRxEQRank23_RxDFETap2Rank2[BYTE_N][3:0]),
            .o_DDRCrRxEQRank23_RxDFETap3Rank2(DDRCrRxEQRank23_RxDFETap3Rank2[BYTE_N][2:0]),
            .o_DDRCrRxEQRank23_RxDFETap0Rank3(DDRCrRxEQRank23_RxDFETap0Rank3[BYTE_N][4:0]),
            .o_DDRCrRxEQRank23_RxDFETap1Rank3(DDRCrRxEQRank23_RxDFETap1Rank3[BYTE_N][3:0]),
            .o_DDRCrRxEQRank23_RxDFETap2Rank3(DDRCrRxEQRank23_RxDFETap2Rank3[BYTE_N][3:0]),
            .o_DDRCrRxEQRank23_RxDFETap3Rank3(DDRCrRxEQRank23_RxDFETap3Rank3[BYTE_N][2:0]),
            .o_mipi_rb_rxdly_direct_ctrl(mipi_rb_rxdly_direct_ctrl[BYTE_N][4:0]),
            .o_mipi_rx_diff_en(mipi_rx_diff_en[BYTE_N][4:0]),
            .o_mipi_rx_dphylprxen(mipi_rx_dphylprxen[BYTE_N][4:0]),
	    .o_phy_tx_wr_data_pl(phy_tx_wr_data_pl[BYTE_N][47:0]),
	    .o_from_phy_rx_x16dqsn_p4(phy_rx_x16dqsn_p4[BYTE_N]),
	    .o_from_phy_rx_x16dqsp_p4(phy_rx_x16dqsp_p4[BYTE_N]),
	    .o_rx_rxdqsampresult(rx_rxdqsampresult[BYTE_N][11:0]),
	    .o_rxdphylprxen(rxdphylprxen[BYTE_N][11:0]),
	    .o_rxlvdien(rxlvdien[BYTE_N][11:0]),
	    .o_rzq_en(rzq_en[BYTE_N]),                                   
	    .o_tx_modectrl_4(tx_modectrl_4[BYTE_N][2:0]),
 	    .i_dcd_ter_en(dcd_ter_en[BYTE_N]),
 	    .i_from_sdll0_o_dcdsawl_clk(from_sdll0_o_dcdsawl_clk[BYTE_N]),
   	    .i_from_sdll1_o_dcdsawl_clk(from_sdll1_o_dcdsawl_clk[BYTE_N]),
	    .i_dqsmode(dqsmode[BYTE_N][1:0]),
	    .i_n0_odt_seg_rotate_en(n0_odt_seg_rotate_en[BYTE_N][1:0]),  
	    .i_n1_odt_seg_rotate_en(n1_odt_seg_rotate_en[BYTE_N][1:0]),  
	    .i_odt_en(odt_en[BYTE_N][11:0]),
	    .i_odt_parken(odt_parken[BYTE_N][11:0]),
	    .i_odt_parken_dqsn(odt_parken_dqsn[BYTE_N][11:0]),
	    .i_phy_ddrcrdatacontrol0_enodtrotation(phyctrl_ddrcrdatacontrol0_enodtrotation[BYTE_N]),
	    .i_phy_ddrcrdatacontrol4_unmatchedrx(phyctrl_ddrcrdatacontrol4_unmatchedrx[BYTE_N]),
	    .i_phy_rx_dfemuxout_0(phyctrl_dfemuxout_0[BYTE_N][11:0]),
	    .i_phy_rx_dfemuxout_1(phyctrl_dfemuxout_1[BYTE_N][11:0]),
	    .i_phy_occ_phy_clk(phyctrl_o_occ_phy_clk[BYTE_N]),
	    .i_phy_rx_rcvenmuxout_0(phyctrl_rcvenmuxout_0[BYTE_N][11:0]),
	    .i_phy_rx_rcvenmuxout_1(phyctrl_rcvenmuxout_1[BYTE_N][11:0]),
	    .i_phy_rddata_en_dly(phyctrl_rddata_en_dly[BYTE_N][1:0]),
	    .i_phy_rx_d0cben(phyctrl_rx_d0cben[BYTE_N]),
	    .i_phy_rx_d0drvsel(phyctrl_rx_d0drvsel[BYTE_N]),
	    .i_rxfifo_rb_avm_wr_pipestage(phyctrl_rxfifo_rb_avm_wr_pipestage[BYTE_N]),
	    .i_phy_phy_clk_gated(phyctrl_phy_clk_gated[BYTE_N]),
	    .i_phy_tx_wrdata_en0(phyctrl_wrdata_en0[BYTE_N][1:0]),
	    .i_phy_tx_wrdata_en1(phyctrl_wrdata_en1[BYTE_N][1:0]),
	    .i_phy_tx_wrdata_en2(phyctrl_wrdata_en2[BYTE_N][1:0]),
	    .i_phy_tx_wrdata_en3(phyctrl_wrdata_en3[BYTE_N][1:0]),
	    .i_phy_tx_wr_dqs_en4(phyctrl_wr_dqs_en4[BYTE_N][1:0]),
	    .i_phy_tx_wr_dqs_en5(phyctrl_wr_dqs_en5[BYTE_N][1:0]),
	    .i_phy_tx_wr_dqs_en6(phyctrl_wr_dqs_en6[BYTE_N][1:0]),
	    .i_phy_tx_wr_dqs_en7(phyctrl_wr_dqs_en7[BYTE_N][1:0]),
	    .i_phy_tx_wrdata_en8(phyctrl_wrdata_en8[BYTE_N][1:0]),
	    .i_phy_tx_wrdata_en9(phyctrl_wrdata_en9[BYTE_N][1:0]),
	    .i_phy_tx_wrdata_en10(phyctrl_wrdata_en10[BYTE_N][1:0]),
	    .i_phy_tx_wrdata_en11(phyctrl_wrdata_en11[BYTE_N][1:0]),
	    .i_X1CounterDCCPin_00_DCCCount(phyctrl_x1counterdccpin_00_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_01_DCCCount(phyctrl_x1counterdccpin_01_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_02_DCCCount(phyctrl_x1counterdccpin_02_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_03_DCCCount(phyctrl_x1counterdccpin_03_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_04_DCCCount(phyctrl_x1counterdccpin_04_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_05_DCCCount(phyctrl_x1counterdccpin_05_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_06_DCCCount(phyctrl_x1counterdccpin_06_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_07_DCCCount(phyctrl_x1counterdccpin_07_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_08_DCCCount(phyctrl_x1counterdccpin_08_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_09_DCCCount(phyctrl_x1counterdccpin_09_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_10_DCCCount(phyctrl_x1counterdccpin_10_dcccount[BYTE_N][16:0]),
	    .i_X1CounterDCCPin_11_DCCCount(phyctrl_x1counterdccpin_11_dcccount[BYTE_N][16:0]),
	    .i_rxfifo_skew(rxfifo_skew[BYTE_N]),
	    .i_rxfifo_spare(rxfifo_spare[BYTE_N][13:0]),
	    .rxnpathenable(rxnpathenable[BYTE_N][11:0]),
	    .rxppathenable(rxppathenable[BYTE_N][11:0]),
	    .i_phy_phy_reset_n(phyctrl_phy_reset_n[BYTE_N]),
	    .i_phy_datatrainfeedback_dqsnparklovohcode(phy_datatrainfeedback_dqsnparklovohcode[BYTE_N][3:0]),
	    .i_phy_datatrainfeedback_dqsnparklowvoh(phy_datatrainfeedback_dqsnparklowvoh[BYTE_N]),
	    .i_phy_ddrcrcmdbustrain_ddrdqovrddata(phyctrl_ddrcrcmdbustrain_ddrdqovrddata[BYTE_N]),
	    .i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen(phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen[BYTE_N]),
	    .o_phy_cr_iamca_00(phyctrl_cr_iamca_00[BYTE_N]),
	    .o_phy_cr_iamca_01(phyctrl_cr_iamca_01[BYTE_N]),
	    .o_phy_cr_iamca_02(phyctrl_cr_iamca_02[BYTE_N]),
	    .o_phy_cr_iamca_03(phyctrl_cr_iamca_03[BYTE_N]),
	    .o_phy_cr_iamca_04(phyctrl_cr_iamca_04[BYTE_N]),
	    .o_phy_cr_iamca_05(phyctrl_cr_iamca_05[BYTE_N]),
	    .o_phy_cr_iamca_06(phyctrl_cr_iamca_06[BYTE_N]),
	    .o_phy_cr_iamca_07(phyctrl_cr_iamca_07[BYTE_N]),
	    .o_phy_cr_iamca_08(phyctrl_cr_iamca_08[BYTE_N]),
	    .o_phy_cr_iamca_09(phyctrl_cr_iamca_09[BYTE_N]),
	    .o_phy_cr_iamca_10(phyctrl_cr_iamca_10[BYTE_N]),
	    .o_phy_cr_iamca_11(phyctrl_cr_iamca_11[BYTE_N]),
	    .o_phy_mipi_idle(mipi_idle[BYTE_N]),
	    .pllclk(),
	    .from_io12phy_txdigitop_0_o_tx_drven_ph0_toviewdigin(txdigitop_0_o_tx_drven_ph0[BYTE_N]),
	    .from_io12phy_txdigitop_0_o_tx_drven_ph1_toviewdigin(txdigitop_0_o_tx_drven_ph1[BYTE_N]),
	    .from_io12phy_txdigitop_4_o_tx_drven_ph0_toviewdigin(txdigitop_4_o_tx_drven_ph0[BYTE_N]),
	    .from_io12phy_txdigitop_4_o_tx_drven_ph1_toviewdigin(txdigitop_4_o_tx_drven_ph1[BYTE_N]),
	    .o_delayed_oe_p0_toviewdigin(delayed_oe_p0[BYTE_N][1:0]),
	    .o_delayed_oe_p4_toviewdigin(delayed_oe_p4[BYTE_N][1:0]),
	    .o_rb_txfifo_in_sel(rb_txfifo_in_sel[BYTE_N][11:0]),
	    .i_occ_mux_auxclk(occ_mux_auxclk[BYTE_N]),
	    .i_nbiasen(nbiasen[BYTE_N]),
	    .i_pbiasen(pbiasen[BYTE_N]),
            .dphy_io(dphy_io)
       );

        
        assign phyctrl_pll_lock[BYTE_N] = link_pll_lock;                 
        assign phyctrl_pllvcoclk[BYTE_N] = link_vco_clk;              
        assign phyctrl_phyclk_sync[BYTE_N] = link_phy_clk_sync;       
        assign phyctrl_phy_clk[BYTE_N] = link_phy_clk;                

        
        dphy_byte_control_wrap #(
            .DEV_FAMILY(DEV_FAMILY),        
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .DPHY_RX_EN(DPHY_RX_EN),
            .DPHY_TX_EN(DPHY_TX_EN),
            .BYTE_CNT(BYTE_CNT),
            .BYTE_N(BYTE_N),
            .NUM_LANES(NUM_LANES_BYTE),
            .RX_DLANE_DESKEW_DELAY(RX_DLANE_DESKEW_DELAY[BYTE_N*32 +: 32]),
            .TX_CLK_LANE_PS( (BYTE_N == 0 && VCO_FREQ_MULT == 4'b0001) ? TX_CLK_LANE_PS : 7'h0),
            .CONTINUOUS_CLK(CONTINUOUS_CLK),
            .BIT_RATE(BIT_RATE),
            .VCO_FREQ(VCO_FREQ),
	    .VCCN_VOLTAGE(VCCN_VOLTAGE)
        ) byte_control_wrap_inst (
            .o_phyctrl_rddata_valid_upper( phyctrl_rddata_valid_upper[BYTE_N*2 +: 2] ), 
            .o_phyctrl_rddata_valid_lower( phyctrl_rddata_valid_lower[BYTE_N*2 +: 2] ), 
            .o_phyctrl_dqs_en4_del( phyctrl_dqs_en4_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_dqs_en5_del( phyctrl_dqs_en5_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_dqs_en6_del( phyctrl_dqs_en6_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_dqs_en7_del( phyctrl_dqs_en7_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en0_del( phyctrl_wrdata_en0_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en1_del( phyctrl_wrdata_en1_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en2_del( phyctrl_wrdata_en2_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en3_del( phyctrl_wrdata_en3_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en8_del( phyctrl_wrdata_en8_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en9_del( phyctrl_wrdata_en9_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en10_del( phyctrl_wrdata_en10_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_wrdata_en11_del( phyctrl_wrdata_en11_del[BYTE_N*2 +: 2] ), 
            .o_phyctrl_tx_picode0( phyctrl_tx_picode0[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode1( phyctrl_tx_picode1[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode2( phyctrl_tx_picode2[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode3( phyctrl_tx_picode3[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode4( phyctrl_tx_picode4[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode5( phyctrl_tx_picode5[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode6( phyctrl_tx_picode6[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode7( phyctrl_tx_picode7[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode8( phyctrl_tx_picode8[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode9( phyctrl_tx_picode9[BYTE_N*4 +: 4] ),   
            .o_phyctrl_tx_picode10( phyctrl_tx_picode10[BYTE_N*4 +: 4] ), 
            .o_phyctrl_tx_picode11( phyctrl_tx_picode11[BYTE_N*4 +: 4] ), 
            .o_phyctrl_byte_tx_ctrl( phyctrl_byte_tx_ctrl[BYTE_N*32 +: 32] ), 
            .o_phyctrl_fifo_pack_select( phyctrl_fifo_pack_select[BYTE_N] ), 
            .o_phyctrl_fifo_read_enable_upper( phyctrl_fifo_read_enable_upper[BYTE_N*2 +: 2] ), 
            .o_phyctrl_fifo_read_enable_lower( phyctrl_fifo_read_enable_lower[BYTE_N*2 +: 2] ), 
            .o_phyctrl_trainreset( phyctrl_trainreset[BYTE_N] ),          
            .o_phyctrl_byte_rx_ctrl( phyctrl_byte_rx_ctrl[BYTE_N*32 +: 32] ), 
            .i_phyctrl_pll_lock( phyctrl_pll_lock[BYTE_N] ),              
            .i_phyctrl_rddata_en( phyctrl_rddata_en[BYTE_N*2 +: 2] ),     
            .i_phyctrl_wr_dqs0_en( phyctrl_wr_dqs0_en[BYTE_N*2 +: 2] ),     
            .i_phyctrl_wr_dqs1_en( phyctrl_wr_dqs1_en[BYTE_N*2 +: 2] ),     
            .i_phyctrl_wr_rank( pa2phy_wr_rank[BYTE_N*4 +: 4] ),            
            .i_phyctrl_rd_rank( pa2phy_rd_rank[BYTE_N*4 +: 4] ),            
            .i_phyctrl_wrdata_en( phyctrl_wrdata_en[BYTE_N*2 +: 2] ),     
            .i_phyctrl_pllvcoclk( phyctrl_pllvcoclk[BYTE_N] ),            
            .i_phyctrl_phyclk_sync( phyctrl_phyclk_sync[BYTE_N] ),        
            .i_phyctrl_phy_clk( phyctrl_phy_clk[BYTE_N] ),                
            .o_phyctrl_gated_tx_phy_clk( phyctrl_gated_tx_phy_clk[BYTE_N] ), 
            .o_phyctrl_gated_rx_phy_clk( phyctrl_gated_rx_phy_clk[BYTE_N] ), 
            .o_phyctrl_tx_clkrefdivby2( phyctrl_tx_clkrefdivby2[BYTE_N] ), 
            .o_phyctrl_tx_clkpi( phyctrl_tx_clkpi[BYTE_N*12 +: 12] ),     
            .o_phyctrl_sdll0_dqsp( phyctrl_sdll0_dqsp[BYTE_N*6 +: 6] ),   
            .o_phyctrl_sdll0_dqsn( phyctrl_sdll0_dqsn[BYTE_N*6 +: 6] ),   
            .o_phyctrl_sdll1_dqsp( phyctrl_sdll1_dqsp[BYTE_N*6 +: 6] ),   
            .o_phyctrl_sdll1_dqsn( phyctrl_sdll1_dqsn[BYTE_N*6 +: 6] ),   
            .i_phyctrl_rx_dqs_p4( phyctrl_rx_dqs_p4[BYTE_N] ),            
            .i_phyctrl_rx_dqs_n4( phyctrl_rx_dqs_n4[BYTE_N] ),            
            .i_phyctrl_rx_dqs_amp_p5( phyctrl_rx_dqs_amp_p5[BYTE_N] ),    
            .i_phyctrl_rx_dqs_p6( phyctrl_rx_dqs_p6[BYTE_N] ),            
            .i_phyctrl_rx_dqs_n6( phyctrl_rx_dqs_n6[BYTE_N] ),            
            .i_phyctrl_rx_dqs_amp_p7( phyctrl_rx_dqs_amp_p7[BYTE_N] ),    
            .i_phyctrl_pa_sideband( phyctrl_pa_sideband[BYTE_N*12 +: 12] ), 
            .o_phyctrl_rx_senseampen( phyctrl_rx_senseampen[BYTE_N*12 +: 12] ), 
            .i_phyctrl_sdll1_dqspin_x16_clk(phyctrl_sdll1_dqspin_x16_clk[BYTE_N]),
            .i_phyctrl_sdll1_dqsnin_x16_clk(phyctrl_sdll1_dqsnin_x16_clk[BYTE_N]),
            .i_phyctrl_sdll0_dqspin_x16_clk(phyctrl_sdll0_dqspin_x16_clk[BYTE_N]),
            .i_phyctrl_sdll0_dqsnin_x16_clk(phyctrl_sdll0_dqsnin_x16_clk[BYTE_N]),
            .o_phyctrl_ckx16dqsn_to_bottom(phyctrl_ckx16dqsn_to_bottom[BYTE_N]),
            .o_phyctrl_ckx16dqsp_to_bottom(phyctrl_ckx16dqsp_to_bottom[BYTE_N]),
            .o_phyctrl_ckx16dqsn_to_top(phyctrl_ckx16dqsn_to_top[BYTE_N]),
            .o_phyctrl_ckx16dqsp_to_top(phyctrl_ckx16dqsp_to_top[BYTE_N]),
            .o_phyctrl_phyclk_notgated(phyctrl_phyclk_notgated[BYTE_N]),
            .o_phyctrl_sdll0_rx_d0pienable( phyctrl_sdll0_rx_d0pienable[BYTE_N*6 +: 6] ), 
            .o_phyctrl_sdll0_rx_d0rcvenpre( phyctrl_sdll0_rx_d0rcvenpre[BYTE_N] ), 
            .o_phyctrl_sdll0_rx_d0reset( phyctrl_sdll0_rx_d0reset[BYTE_N] ), 
`ifdef REVA
            .o_phyctrl_sdll0_rx_d0sdlparkvalue( phyctrl_sdll0_rx_d0sdlparkvalue[BYTE_N] ), 
            .o_phyctrl_sdll1_rx_d0sdlparkvalue( phyctrl_sdll1_rx_d0sdlparkvalue[BYTE_N] ),  
`else
            .o_phyctrl_parkclk_to_rxtop_n0_pl1( phyctrl_parkclk_to_rxtop_n0_pl1[BYTE_N][PHY_PARKCLK_WIDTH-1:0]), 
            .o_phyctrl_parkclk_to_rxtop_n1_pl1( phyctrl_parkclk_to_rxtop_n1_pl1[BYTE_N][PHY_PARKCLK_WIDTH-1:0]), 
`endif
            .o_phyctrl_sdll1_rx_d0pienable( phyctrl_sdll1_rx_d0pienable[BYTE_N*6 +: 6] ), 
            .o_phyctrl_sdll1_rx_d0rcvenpre( phyctrl_sdll1_rx_d0rcvenpre[BYTE_N] ), 
            .o_phyctrl_sdll1_rx_d0reset( phyctrl_sdll1_rx_d0reset[BYTE_N] ), 
            .i_DCCXtalkControl_DCCSamples(DCCXtalkControl_DCCSamples[BYTE_N][4:0]),
            .i_DCCXtalkControl_RunDCC(DCCXtalkControl_RunDCC[BYTE_N]),
            .i_DCCXtalkControl_SelMeasPoint(DCCXtalkControl_SelMeasPoint[BYTE_N][1:0]),	    
            .i_DDRCrRxEQRank01_RxDFETap0Rank0(DDRCrRxEQRank01_RxDFETap0Rank0[BYTE_N][4:0]),
            .i_DDRCrRxEQRank01_RxDFETap1Rank0(DDRCrRxEQRank01_RxDFETap1Rank0[BYTE_N][3:0]),
            .i_DDRCrRxEQRank01_RxDFETap2Rank0(DDRCrRxEQRank01_RxDFETap2Rank0[BYTE_N][3:0]),
            .i_DDRCrRxEQRank01_RxDFETap3Rank0(DDRCrRxEQRank01_RxDFETap3Rank0[BYTE_N][2:0]),
            .i_DDRCrRxEQRank01_RxDFETap0Rank1(DDRCrRxEQRank01_RxDFETap0Rank1[BYTE_N][4:0]),
            .i_DDRCrRxEQRank01_RxDFETap1Rank1(DDRCrRxEQRank01_RxDFETap1Rank1[BYTE_N][3:0]),
            .i_DDRCrRxEQRank01_RxDFETap2Rank1(DDRCrRxEQRank01_RxDFETap2Rank1[BYTE_N][3:0]),
            .i_DDRCrRxEQRank01_RxDFETap3Rank1(DDRCrRxEQRank01_RxDFETap3Rank1[BYTE_N][2:0]),
            .i_DDRCrRxEQRank23_RxDFETap0Rank2(DDRCrRxEQRank23_RxDFETap0Rank2[BYTE_N][4:0]),
            .i_DDRCrRxEQRank23_RxDFETap1Rank2(DDRCrRxEQRank23_RxDFETap1Rank2[BYTE_N][3:0]),
            .i_DDRCrRxEQRank23_RxDFETap2Rank2(DDRCrRxEQRank23_RxDFETap2Rank2[BYTE_N][3:0]),
            .i_DDRCrRxEQRank23_RxDFETap3Rank2(DDRCrRxEQRank23_RxDFETap3Rank2[BYTE_N][2:0]),
            .i_DDRCrRxEQRank23_RxDFETap0Rank3(DDRCrRxEQRank23_RxDFETap0Rank3[BYTE_N][4:0]),
            .i_DDRCrRxEQRank23_RxDFETap1Rank3(DDRCrRxEQRank23_RxDFETap1Rank3[BYTE_N][3:0]),
            .i_DDRCrRxEQRank23_RxDFETap2Rank3(DDRCrRxEQRank23_RxDFETap2Rank3[BYTE_N][3:0]),
            .i_DDRCrRxEQRank23_RxDFETap3Rank3(DDRCrRxEQRank23_RxDFETap3Rank3[BYTE_N][2:0]),
            .i_mipi_rb_rxdly_direct_ctrl(mipi_rb_rxdly_direct_ctrl[BYTE_N][4:0]),
            .i_mipi_rx_diff_en(mipi_rx_diff_en[BYTE_N][4:0]),
            .i_mipi_rx_dphylprxen(mipi_rx_dphylprxen[BYTE_N][4:0]),
	    .i_phyctrl_io_pad_doe(phy_pad_doe[BYTE_N*12 +: 12]),
	    .i_phyctrl_tx_wr_data_pl(phy_tx_wr_data_pl[BYTE_N][47:0]),
	    .i_rx_rxdqsampresult(rx_rxdqsampresult[BYTE_N][11:0]),
	    .i_rx_x16dqsn_p4(phy_rx_x16dqsn_p4[BYTE_N]),
	    .i_rx_x16dqsp_p4(phy_rx_x16dqsp_p4[BYTE_N]),
	    .i_rxdphylprxen(rxdphylprxen[BYTE_N][11:0]),
	    .i_rxlvdien(rxlvdien[BYTE_N][11:0]),
	    .i_rzq_en(rzq_en[BYTE_N]),                                   
	    .i_tx_modectrl_4(tx_modectrl_4[BYTE_N][2:0]),
	    .o_dcd_ter_en(dcd_ter_en[BYTE_N]),
	    .o_from_sdll0_o_dcdsawl_clk(from_sdll0_o_dcdsawl_clk[BYTE_N]),
	    .o_from_sdll1_o_dcdsawl_clk(from_sdll1_o_dcdsawl_clk[BYTE_N]),
	    .o_io12phyctrl_dqsmode(dqsmode[BYTE_N][1:0]),
	    .o_n0_odt_seg_rotate_en(n0_odt_seg_rotate_en[BYTE_N][1:0]),  
	    .o_n1_odt_seg_rotate_en(n1_odt_seg_rotate_en[BYTE_N][1:0]),  
	    .o_odt_en(odt_en[BYTE_N][11:0]),
	    .o_odt_parken(odt_parken[BYTE_N][11:0]),
	    .o_odt_parken_dqsn(odt_parken_dqsn[BYTE_N][11:0]),
	    .o_phyctrl_ddrcrdatacontrol0_enodtrotation(phyctrl_ddrcrdatacontrol0_enodtrotation[BYTE_N]),
	    .o_phyctrl_ddrcrdatacontrol4_unmatchedrx(phyctrl_ddrcrdatacontrol4_unmatchedrx[BYTE_N]),
	    .o_phyctrl_dfemuxout_0(phyctrl_dfemuxout_0[BYTE_N][11:0]),
	    .o_phyctrl_dfemuxout_1(phyctrl_dfemuxout_1[BYTE_N][11:0]),
	    .o_phyctrl_o_occ_phy_clk(phyctrl_o_occ_phy_clk[BYTE_N]),
	    .o_phyctrl_rcvenmuxout_0(phyctrl_rcvenmuxout_0[BYTE_N][11:0]),
	    .o_phyctrl_rcvenmuxout_1(phyctrl_rcvenmuxout_1[BYTE_N][11:0]),
	    .o_phyctrl_rddata_en_dly(phyctrl_rddata_en_dly[BYTE_N][1:0]),
	    .o_phyctrl_rx_d0cben(phyctrl_rx_d0cben[BYTE_N]),
	    .o_phyctrl_rx_d0drvsel(phyctrl_rx_d0drvsel[BYTE_N]),
	    .o_phyctrl_rxfifo_rb_avm_wr_pipestage(phyctrl_rxfifo_rb_avm_wr_pipestage[BYTE_N]),
            .o_phyctrl_u_io12phyctrl_logic_o_phy_clk_gated(phyctrl_phy_clk_gated[BYTE_N]),
	    .o_phyctrl_u_io12phyctrl_logic_o_phy_reset_n(phyctrl_phy_reset_n[BYTE_N]),
            .o_phyctrl_wrdata_en0(phyctrl_wrdata_en0[BYTE_N][1:0]),
            .o_phyctrl_wrdata_en1(phyctrl_wrdata_en1[BYTE_N][1:0]),
            .o_phyctrl_wrdata_en2(phyctrl_wrdata_en2[BYTE_N][1:0]),
            .o_phyctrl_wrdata_en3(phyctrl_wrdata_en3[BYTE_N][1:0]),
            .o_phyctrl_wr_dqs_en4(phyctrl_wr_dqs_en4[BYTE_N][1:0]),
            .o_phyctrl_wr_dqs_en5(phyctrl_wr_dqs_en5[BYTE_N][1:0]),
            .o_phyctrl_wr_dqs_en6(phyctrl_wr_dqs_en6[BYTE_N][1:0]),
            .o_phyctrl_wr_dqs_en7(phyctrl_wr_dqs_en7[BYTE_N][1:0]),
            .o_phyctrl_wrdata_en8(phyctrl_wrdata_en8[BYTE_N][1:0]),
            .o_phyctrl_wrdata_en9(phyctrl_wrdata_en9[BYTE_N][1:0]),
            .o_phyctrl_wrdata_en10(phyctrl_wrdata_en10[BYTE_N][1:0]),
            .o_phyctrl_wrdata_en11(phyctrl_wrdata_en11[BYTE_N][1:0]),
            .o_phyctrl_X1CounterDCCPin_00_DCCCount(phyctrl_x1counterdccpin_00_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_01_DCCCount(phyctrl_x1counterdccpin_01_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_02_DCCCount(phyctrl_x1counterdccpin_02_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_03_DCCCount(phyctrl_x1counterdccpin_03_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_04_DCCCount(phyctrl_x1counterdccpin_04_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_05_DCCCount(phyctrl_x1counterdccpin_05_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_06_DCCCount(phyctrl_x1counterdccpin_06_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_07_DCCCount(phyctrl_x1counterdccpin_07_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_08_DCCCount(phyctrl_x1counterdccpin_08_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_09_DCCCount(phyctrl_x1counterdccpin_09_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_10_DCCCount(phyctrl_x1counterdccpin_10_dcccount[BYTE_N][16:0]),
            .o_phyctrl_X1CounterDCCPin_11_DCCCount(phyctrl_x1counterdccpin_11_dcccount[BYTE_N][16:0]),
	    .o_rxfifo_skew(rxfifo_skew[BYTE_N]),
	    .o_rxfifo_spare(rxfifo_spare[BYTE_N][13:0]),
	    .rxnpathenable(rxnpathenable[BYTE_N][11:0]),
	    .rxppathenable(rxppathenable[BYTE_N][11:0]),
	    .i_pa_2_phytop_rx_analog_en(pa2phy_rxanalogen[BYTE_N]),
	    .i_pa_2_phytop_tx_analog_en(pa2phy_txanalogen[BYTE_N]),
	    .o_phyctrl_datatrainfeedback_dqsnparklovohcode(phy_datatrainfeedback_dqsnparklovohcode[BYTE_N][3:0]),
	    .o_phyctrl_datatrainfeedback_dqsnparklowvoh(phy_datatrainfeedback_dqsnparklowvoh[BYTE_N]),
	    .o_phyctrl_ddrcrcmdbustrain_ddrdqovrddata(phyctrl_ddrcrcmdbustrain_ddrdqovrddata[BYTE_N]),
	    .o_phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen(phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen[BYTE_N]),
	    .i_phyctrl_cr_iamca_00(phyctrl_cr_iamca_00[BYTE_N]),
	    .i_phyctrl_cr_iamca_01(phyctrl_cr_iamca_01[BYTE_N]),
	    .i_phyctrl_cr_iamca_02(phyctrl_cr_iamca_02[BYTE_N]),
	    .i_phyctrl_cr_iamca_03(phyctrl_cr_iamca_03[BYTE_N]),
	    .i_phyctrl_cr_iamca_04(phyctrl_cr_iamca_04[BYTE_N]),
	    .i_phyctrl_cr_iamca_05(phyctrl_cr_iamca_05[BYTE_N]),
	    .i_phyctrl_cr_iamca_06(phyctrl_cr_iamca_06[BYTE_N]),
 	    .i_phyctrl_cr_iamca_07(phyctrl_cr_iamca_07[BYTE_N]),
	    .i_phyctrl_cr_iamca_08(phyctrl_cr_iamca_08[BYTE_N]),
	    .i_phyctrl_cr_iamca_09(phyctrl_cr_iamca_09[BYTE_N]),
	    .i_phyctrl_cr_iamca_10(phyctrl_cr_iamca_10[BYTE_N]),
	    .i_phyctrl_cr_iamca_11(phyctrl_cr_iamca_11[BYTE_N]),
	    .i_phyctrl_gpio_dout_sel(phy_gpio_dout_sel[BYTE_N*12 +: 12]),
	    .i_phyctrl_mipi_idle(mipi_idle[BYTE_N]),
	    .i_txdigitop_0_o_tx_drven_ph0(txdigitop_0_o_tx_drven_ph0[BYTE_N]),
	    .i_txdigitop_0_o_tx_drven_ph1(txdigitop_0_o_tx_drven_ph1[BYTE_N]),
	    .i_txdigitop_4_o_tx_drven_ph0(txdigitop_4_o_tx_drven_ph0[BYTE_N]),
	    .i_txdigitop_4_o_tx_drven_ph1(txdigitop_4_o_tx_drven_ph1[BYTE_N]),	    
	    .i_delayed_oe_p0_toviewdigin(delayed_oe_p0[BYTE_N][1:0]),
	    .i_delayed_oe_p4_toviewdigin(delayed_oe_p4[BYTE_N][1:0]),
	    .i_from_phytop_core_data(phy_core_data[BYTE_N*48 +: 48]),
	    .i_phyctrl_rb_txfifo_in_sel(rb_txfifo_in_sel[BYTE_N][11:0]),
	    .o_occ_mux_auxclk(occ_mux_auxclk[BYTE_N]),
	    .o_nbiasen(nbiasen[BYTE_N]),
	    .o_pbiasen(pbiasen[BYTE_N])
       );

        /***************************************
        * IO buffer instantiations
        ****************************************/
        genvar dlane;
        localparam DLANE_RX_BYTE = DLANE_RX == 0 ? 0 : NUM_LANES_BYTE;
        localparam DLANE_TX_BYTE = DLANE_TX == 0 ? 0 : NUM_LANES_BYTE;
        for(dlane =0; dlane < DLANE_RX_BYTE ; dlane++)        
        begin : rx_dlane_iobuf
            localparam sig_idx  = 2 * ( dlane < 2 ? dlane : dlane + 1 ) + ( BYTE_N == 1 ? 12 : 0);
            localparam lane_idx = dlane + ( BYTE_N == 1 ? 4 : 0);
    
            dphy_ibuf_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .PIN_ID(sig_idx),                
            .IO_STANDARD("IO_STANDARD_IOSTD_DPHY"),
            .RZQ_ID(RZQ_ID),
            .USAGE_MODE("USAGE_MODE_DPHY"),
            .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE),
            .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) ibuf_even_inst (
                .inp( d_p[lane_idx] ),                                  
                .outp( phy_pad_sig_i[sig_idx] )                           
            );
      
            dphy_ibuf_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .PIN_ID(sig_idx+1),                
            .IO_STANDARD("IO_STANDARD_IOSTD_DPHY"),
            .RZQ_ID(RZQ_ID),
            .USAGE_MODE("USAGE_MODE_DPHY"),
            .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE),
            .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) ibuf_odd_inst (
                .inp( d_n[lane_idx] ),                                  
                .outp( phy_pad_sig_i[sig_idx + 1] )                       
            );

            /*
            dphy_ibuf_diff_wrap #(
                .BYTE_LOC(BYTE_LOC + BYTE_N),
                .PIN_ID(sig_idx),                
                .IO_STANDARD("IO_STANDARD_IOSTD_DPHY"),
                .RZQ_ID(RZQ_ID),
                .TERMINATION("TERMINATION_RT_50_OHM_CAL"),
                .USAGE_MODE("USAGE_MODE_DPHY")
            ) ibuf_diff_wrap_inst (
                .inp( d_p[lane_idx] ),                                        
                .inpbar( d_n[lane_idx] ),                                     
                .outp( phy_pad_sig_i[sig_idx] ),                                
                .outbar( phy_pad_sig_i[sig_idx + 1] )                           
            );
            */
        end

		   
        for(dlane = 0; dlane < DLANE_TX_BYTE; dlane++)        
        begin: tx_dlane_iobuf
            localparam sig_idx  = 2 * ( dlane < 2 ? dlane : dlane + 1 ) + ( BYTE_N == 1 ? 12 : 0);
            localparam lane_idx = dlane + ( BYTE_N == 1 ? 4 : 0);

            dphy_obuf_wrap #(
                .BYTE_LOC(BYTE_LOC + BYTE_N),
                .PIN_ID(sig_idx),
                .RZQ_ID(RZQ_ID),
                .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE),
		.BIT_RATE(BIT_RATE),
                .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) obuf_even_inst (
                .inp( phy_pad_sig_o[sig_idx] ),                                   
                .oe( phy_pad_doe[sig_idx] ),                                    
                .outp( d_p[lane_idx] )                                          
            );

            dphy_obuf_wrap #(
                .BYTE_LOC(BYTE_LOC + BYTE_N),
                .PIN_ID(sig_idx+1),
                .RZQ_ID(RZQ_ID),
                .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE),
		.BIT_RATE(BIT_RATE),
                .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) obuf_odd_inst (
                .inp( phy_pad_sig_o[sig_idx+1] ),                                 
                .oe( phy_pad_doe[sig_idx+1] ),                                  
                .outp( d_n[lane_idx] )                                          
            );

        end
        

        
        if (DPHY_RX_EN == 1 && BYTE_N == 0) 
        begin: rx_clk_iobuf

            dphy_ibuf_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .PIN_ID(4),                
            .IO_STANDARD("IO_STANDARD_IOSTD_DPHY"),
            .RZQ_ID(RZQ_ID),
            .USAGE_MODE("USAGE_MODE_DPHY"),
            .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE),
            .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) ibuf_clk_p_inst (
                .inp( ck_p ),                                                
                .outp( phy_pad_sig_i[4] )                                     
            );
      
            dphy_ibuf_wrap #(
            .BYTE_LOC(BYTE_LOC + BYTE_N),
            .PIN_ID(5),                
            .IO_STANDARD("IO_STANDARD_IOSTD_DPHY"),
            .RZQ_ID(RZQ_ID),
            .USAGE_MODE("USAGE_MODE_DPHY"),
            .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE),
            .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) ibuf_clk_n_inst (
                .inp( ck_n ),                                               
                .outp( phy_pad_sig_i[5] )                                     
            );

/*
            dphy_ibuf_diff_wrap #(
                .IO_STANDARD("IO_STANDARD_IOSTD_DPHY"),
                .RZQ_ID(RZQ_ID),
                .TERMINATION("TERMINATION_RT_50_OHM_CAL"),
                .USAGE_MODE("USAGE_MODE_DPHY")
            ) ibuf_clk_diff_inst (
                .inp( ck_p ),                                               
                .inpbar( ck_n ),                                            
                .outp( phy_pad_sig_i[4] ),                                    
                .outbar( phy_pad_sig_i[5] )                                   
            );
*/
        end
        else if (DPHY_TX_EN == 1 && BYTE_N == 0) 
        begin: tx_clk_iobuf
            dphy_obuf_wrap #(
                .BYTE_LOC(BYTE_LOC + BYTE_N),
                .PIN_ID(4),                
                .RZQ_ID(RZQ_ID),
                .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE),
		.BIT_RATE(BIT_RATE),
                .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) obuf_even_inst (
                .inp(  phy_pad_sig_o[4] ),                                                
                .oe( phy_pad_doe[4] ),                                                  
                .outp( ck_p )                                                           
            );

            dphy_obuf_wrap #(
                .BYTE_LOC(BYTE_LOC + BYTE_N),
                .PIN_ID(5),                
                .RZQ_ID(RZQ_ID),
                .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE),
		.BIT_RATE(BIT_RATE),
                .TOGGLE_SPEED( BIT_RATE > 1200000000 ? "TOGGLE_SPEED_FAST" : "TOGGLE_SPEED_SLOW" )
            ) obuf_odd_inst (
                .inp( phy_pad_sig_o[5] ),                                     
                .oe( phy_pad_doe[5] ),                                      
                .outp( ck_n )                                               
            );
        
        end

    end 
    
    
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oLURemC8nGouMFIrahf3bzUu2nb91vbmXAtTmJOgKVl7hSbKjAhcFW0KRaSDbUllRTqQKtQwPsLKzKcOYvoXHQOxUhmb3L1+9D/qjQPXZA2uIvZotNX+8Z738B2ud9dliLJcygyzRa7f/ejoXaAMo9EdLczBFGoVZ7pQc2bfBManxxteNbs+MiLvnvg4qd3WNE/yMpQ61zDhyjOAO3UqW1cQQANX3vagRGr1HDQLRM0Dz2fyalr9Fn3Nnz15ZPmJ4AhFK9pe1kjk5iSgrNlQyczl9wG/7bvaNbl9ST1ApDY+pKu3CLqM6xD+BfvXZl6WlHQm02JaJf2Q/Y+L+CdroLSSZAHKKWP8v98dnXeyZQdH91G1+++2xepavvDctmju4PpP8GWJQdo91yO8g3dmiH4/3XiZcEAxs84BXfWyV67rzerHpR21E/asHLfuQrzNHyZtA7mwgNKkMMp15xb0ctBb04OHRDdt4ZmVNTYmDrVgqYwcfpTjEhFUifTdu+t6aVimj7V0MUkH9xl7VbTrblbKpGpOPphX0ygHUuyJSG3e7YJ5d5WQJMI5z1Y0ICmxikgUIfYsZxRTmcgeDeedXW+nnEqUp2Hx36LklnRiP6JClx9xmZQt/nlHHQK99FoVmolu+SoE4hwElpj81FZIP3WMFjS2WCByzKlXk/lBI2JEAvweDtIl3obfsmELepSzBQfrDXHXj1ZwdfLweyeKY8e+lvS4PKCvj/Nl+Sr+Ojeb8hl/dYpbaXdPvIGPp6/GJ6A5UyTGUKnEYvPzxshddlu"
`endif
