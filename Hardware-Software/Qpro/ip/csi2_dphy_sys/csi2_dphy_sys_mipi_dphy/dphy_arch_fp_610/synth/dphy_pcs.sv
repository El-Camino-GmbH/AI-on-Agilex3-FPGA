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


module dphy_pcs #(

    parameter NUM_LANES = 4,                                    
    parameter PPI_WIDTH = 16,                                   
    parameter PPI_WIDTH_C2P = 16,                                   
    parameter TIME_UNIT = "ps",                                 
    parameter BIT_RATE = 36'd2000000000,                        
    parameter VCO_FREQ_MULT = BIT_RATE <300000000 ? 8 : BIT_RATE < 600000000 ? 4 : BIT_RATE < 1200000000 ? 2 : 1,
    parameter RX_BIT_RATE_MBPS_SEL = 64, 
    parameter unsigned RX_FR_CLK_FREQ = BIT_RATE / PPI_WIDTH_C2P,
    parameter SKEW_CAL_EN = 1,                                  
    parameter SKEW_CAL_LEN = 32768,                                  
    parameter PER_SKEW_CAL_EN = 1,                                  
    parameter ALT_CAL_EN = 1,                                   
    parameter ALT_CAL_LEN = 32768,                                   
    parameter PREAMBLE_EN = 1,                                  
    parameter TM_EN = 0,                                        
    parameter TM_LOOPBACK_MODE = 1,                             
    parameter DPHY_RX_EN = 0,                                   
    parameter DPHY_TX_EN = 0,                                   
    parameter CONTINUOUS_CLK = 0,                                   
    parameter PRBS_INIT     = 64'hffffffffffffffff,                       
    parameter REG_RW_ENABLE = 0,                                          
    parameter RX_DLANE_DESKEW_DELAY     = 64'h00,                         
    parameter RX_CLK_LOSS_DETECT   =  0,                                  
    parameter REG_USE_AUTO = 0,                                           
    parameter RX_CAP_EQ_MODE   = 0,                                       
    parameter RX_CLK_SETTLE   =  0,                                       
    parameter RX_HS_SETTLE   =  0,                                        
    parameter RX_INIT   =  0,                                             
    parameter RX_CLK_POST  = 0,                                           
    parameter RX_TM_CONTROL_RX_TM_EN   = 1'b0,                            
    parameter RX_TM_CONTROL_RX_TM_LOOPBACK_MODE   = 1'b0,                 
    parameter RX_PREP_TIME_TM   = 128,                                    
    parameter TX_CAP_EQ_MODE   = 0,                                       
    parameter TX_PREAMBLE_LEN_PREAMLBE_LEN   = 4'h0,                      
    parameter TX_CLK_LANE_PS   = 32,                                      
    parameter TX_LPX   =  0,                                              
    parameter TX_HS_EXIT   =  0,                                          
    parameter TX_LP_EXIT   =  0,                                          
    parameter TX_CLK_PREPARE   =  0,                                      
    parameter TX_CLK_TRAIL   =  0,                                        
    parameter TX_CLK_ZERO   =  0,                                         
    parameter TX_CLK_POST   =  0,                                         
    parameter TX_CLK_PRE   =  0,                                          
    parameter TX_HS_PREPARE   =  0,                                       
    parameter TX_HS_ZERO   =  0,                                          
    parameter TX_HS_TRAIL   =  0,                                         
    parameter TX_INIT   =  0,                                             
    parameter TX_WAKE   =  0,                                             
    parameter TX_TM_CONTROL_TX_TM_EN   = 1'b0,                            
    parameter TX_TM_CONTROL_TX_TM_LOOPBACK_MODE   = 1'b0,                 
    parameter TX_HS_TM_DESKEW_P   = 128                                   
    ) (      
        input  wire             core_clk,       
        input  wire             core_clk_1024,  
        input  wire             arst_n,         
        input  wire             srst_n,         
        input  wire             pll_lock,       
        dphy_io_if              dphy_port,            
        dphy_reg_if             reg_bus,
        input [PPI_WIDTH-1:0]           tm_loopback_in,
        input                           tm_hs_in,
        output [PPI_WIDTH-1:0]          tm_loopback_out,
        output                          tm_hs_out,
        dphy_dbg_dlane                  dphy_dbg_dlane[7:0],
        dphy_dbg_clane                  dphy_dbg_clane,
        
        ppi_if                  ppi_bus
    );
    
    /*****************************************
    *****************************************/
    logic sig_DPHY_CSR_Enable;
    logic sig_CLK_CSR_CLK_LANE_EN;
    logic [NUM_LANES-1:0] sig_DLANE_CSR_EN;                       
    logic [NUM_LANES-1:0] sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse;   
    logic [NUM_LANES-1:0] sig_DLANE_CSR_RX_MNL_DESKEW_EN;         
    logic [63:0] sig_PRBS_INIT;
    logic [8*7-1:0] sig_RX_DLANE_DESKEW_DELAY;
    logic [7:0] sig_RX_CLK_LOSS_DETECT;
    logic [7:0] sig_RX_CLK_SETTLE;
    logic [7:0] sig_RX_HS_SETTLE;
    logic [7:0] sig_RX_INIT;
    logic [7:0] sig_RX_CLK_POST;
    logic [2:0] sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL;
    logic sig_RX_CAL_REG_CTRL_CAL_RESET_pulse;
    logic sig_RX_TM_CONTROL_RX_TM_EN;
    logic sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE;
    logic sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse;
    logic [7:0] sig_RX_PREP_TIME_TM;
    logic sig_TX_PREAMBLE_LEN_PREAMBLE_EN;
    logic [3:0] sig_TX_PREAMBLE_LEN_PREAMLBE_LEN;
    logic [5:0] sig_TX_CLK_LANE_PS;
    logic [6:0] sig_TX_LPX;
    logic [7:0] sig_TX_HS_EXIT;
    logic [7:0] sig_TX_LP_EXIT;
    logic [5:0] sig_TX_CLK_PREPARE;
    logic [6:0] sig_TX_CLK_TRAIL;
    logic [6:0] sig_TX_CLK_ZERO;
    logic [7:0] sig_TX_CLK_POST;
    logic [3:0] sig_TX_CLK_PRE;
    logic [5:0] sig_TX_HS_PREPARE;
    logic [7:0] sig_TX_HS_ZERO;
    logic [7:0] sig_TX_HS_TRAIL;
    logic [7:0] sig_TX_INIT;
    logic [7:0] sig_TX_WAKE;
    logic sig_TX_TM_CONTROL_TX_TM_EN;
    logic sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE;
    logic sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse;
    logic [7:0] sig_TX_HS_TM_DESKEW_P;
    logic [1:0] rx_clk;

    /*****************************************
    *****************************************/
    logic [NUM_LANES-1:0] set_RX_DLANE_ERR_SOT_ERR_pulse;                
    logic [NUM_LANES-1:0] set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse;           
    logic [NUM_LANES-1:0] set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse;           
    logic [NUM_LANES-1:0] set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse;          
    logic [NUM_LANES-1:0] set_RX_DLANE_ERR_LPDT_ERR_pulse;               
    logic [NUM_LANES-1:0] set_RX_DLANE_ERR_CTRL_ERR_pulse;               
    logic [NUM_LANES-1:0] set_RX_DLANE_ERR_CAL_ERR_pulse;                
    logic [NUM_LANES*8-1:0] sig_RX_CAL_SKEW_W_START;
    logic [NUM_LANES*8-1:0] sig_RX_CAL_SKEW_W_END;
    logic [NUM_LANES*8-1:0] sig_RX_CAL_ALT_W_START;
    logic [NUM_LANES*8-1:0] sig_RX_CAL_ALT_W_END;
    logic [NUM_LANES*7-1:0] sig_RX_DESKEW_DELAY;
    logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE;
    logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE;
    logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE;
    logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE;
    logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE;
    logic [NUM_LANES-1:0] sig_DLANE_STATUS_INIT_DONE;
    logic sig_CLK_STATUS_INIT_DONE;

    logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B0;
    logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B1;
    logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B2;
    logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B3;
    logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B0;
    logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B1;
    logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B2;
    logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B3;


    logic sig_TX_MNL_IO_0_CTRL_EN;
    logic sig_TX_MNL_IO_0_CLK_LP_EN;
    logic [1:0] sig_TX_MNL_IO_0_LP_DAT;
    logic [1:0] sig_TX_MNL_IO_0_HS_DAT_D;
    logic [1:0] sig_TX_MNL_IO_0_HS_DAT_CK;
    logic [7:0] sig_TX_MNL_D_LP_EN;


   assign tm_hs_out = 1'b0;
   assign tm_loopback_out = {PPI_WIDTH{1'b0}};
   
    assign fr_clk = core_clk;
    assign fr_clk_1024 = core_clk_1024;
    assign arst_fr_n = arst_n;
    assign srst_fr_n = srst_n;
    assign arst_core_n = arst_n;
    assign srst_core_n = srst_n;

    
   if(DPHY_RX_EN == 1)
   begin : dphy_rx

        assign rx_clk = NUM_LANES > 4 ? dphy_port.rx_clk : { 1'b0, dphy_port.rx_clk[0] };

        dphy_pcx_rx #(
        .IO_CONVERT_RATIO(PPI_WIDTH),                   
        .IO_CONVERT_RATIO_C2P(PPI_WIDTH_C2P),           
        .NUM_LANES(NUM_LANES),                          
        .SKEW_CAL_EN(SKEW_CAL_EN),                      
        .ALT_CAL_EN(ALT_CAL_EN),                        
        .PREAMBLE_EN(PREAMBLE_EN),                      
        .CONTINUOUS_CLK(CONTINUOUS_CLK),                
        .RX_BIT_RATE_MBPS_SEL(RX_BIT_RATE_MBPS_SEL),    
        .RX_FR_CLK_FREQ(RX_FR_CLK_FREQ),                
        .TM_EN(TM_EN),                                  
        .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE)             
        ) dphy_pcs_rx
       (
            .fr_clk(fr_clk),
            .fr_clk_1024(fr_clk_1024),
            .arst_fr_n(arst_fr_n),                    
            .srst_fr_n(srst_fr_n),                    
            .sig_DPHY_CSR_Enable(sig_DPHY_CSR_Enable),
            .sig_CLK_CSR_CLK_LANE_EN(sig_CLK_CSR_CLK_LANE_EN & sig_DPHY_CSR_Enable),
            .sig_CLK_STATUS_INIT_DONE(sig_CLK_STATUS_INIT_DONE),
            .sig_DLANE_CSR_EN(sig_DLANE_CSR_EN),
            .sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse(sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse),
            .sig_DLANE_CSR_RX_MNL_DESKEW_EN(sig_DLANE_CSR_RX_MNL_DESKEW_EN),
            .sig_DLANE_STATUS_INIT_DONE(sig_DLANE_STATUS_INIT_DONE),
            .sig_PRBS_INIT(sig_PRBS_INIT[NUM_LANES*8-1:0]),
            .set_RX_DLANE_ERR_SOT_ERR_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse),
            .set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse),
            .set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse),
            .set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse),
            .set_RX_DLANE_ERR_LPDT_ERR_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse),
            .set_RX_DLANE_ERR_CTRL_ERR_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse),
            .set_RX_DLANE_ERR_CAL_ERR_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse),
            .sig_RX_DLANE_DESKEW_DELAY(sig_RX_DLANE_DESKEW_DELAY[NUM_LANES*7-1:0]),
            .sig_RX_CLK_LOSS_DETECT(sig_RX_CLK_LOSS_DETECT),
            .sig_RX_CLK_SETTLE(sig_RX_CLK_SETTLE),
            .sig_RX_HS_SETTLE(sig_RX_HS_SETTLE),
            .sig_RX_INIT(sig_RX_INIT),
            .sig_RX_CLK_POST(sig_RX_CLK_POST),
            .sig_RX_CAL_REG_CTRL_CAL_RESET_pulse(sig_RX_CAL_REG_CTRL_CAL_RESET_pulse),
            .sig_RX_CAL_SKEW_W_START(sig_RX_CAL_SKEW_W_START),
            .sig_RX_CAL_SKEW_W_END(sig_RX_CAL_SKEW_W_END),
            .sig_RX_CAL_ALT_W_START(sig_RX_CAL_ALT_W_START),
            .sig_RX_CAL_ALT_W_END(sig_RX_CAL_ALT_W_END),
            .sig_RX_DESKEW_DELAY(sig_RX_DESKEW_DELAY),
            .sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE(sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE),
            .sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE(sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE),
            .sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE),
            .sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE),
            .sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE),
            .sig_RX_TM_CONTROL_RX_TM_EN(sig_RX_TM_CONTROL_RX_TM_EN | tm_hs_in),
            .sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE(sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE),
            .sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse(sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse),
            .sig_RX_PREP_TIME_TM(sig_RX_PREP_TIME_TM),
            .sig_RX_BER_CNT_B0(sig_RX_BER_CNT_B0),
            .sig_RX_BER_CNT_B1(sig_RX_BER_CNT_B1),
            .sig_RX_BER_CNT_B2(sig_RX_BER_CNT_B2),
            .sig_RX_BER_CNT_B3(sig_RX_BER_CNT_B3),
            .dphy_port(dphy_port),
            .dphy_dbg_dlane(dphy_dbg_dlane),
            .dphy_dbg_clane(dphy_dbg_clane),


            .ppi_rx(ppi_bus)
        );

        assign dphy_port.mnl_tx_en = 1'b0;
        assign dphy_port.mnl_tx_clk_lp_hs_b = 1'b0;
        assign dphy_port.mnl_tx_data_lp_hs_b = 'h0;
        assign dphy_port.mnl_tx_data_lp_p = 1'b0;
        assign dphy_port.mnl_tx_data_lp_n = 1'b0;
        assign dphy_port.mnl_tx_data_hs = 2'b00;
        assign dphy_port.mnl_tx_clk_hs = 2'b00;

        assign dphy_port.core_clk = core_clk;
        assign dphy_port.srst_n = srst_n;

        assign sig_TX_WORD_COUNT_B0 = 'h0;
        assign sig_TX_WORD_COUNT_B1 = 'h0;    
        assign sig_TX_WORD_COUNT_B2 = 'h0;
        assign sig_TX_WORD_COUNT_B3 = 'h0;    
        
        
    end
    else if(DPHY_TX_EN == 1)
    begin : dphy_tx
    
        dphy_pcx_tx #(        
            .IO_CONVERT_RATIO(PPI_WIDTH),     
            .VCO_FREQ_MULT(VCO_FREQ_MULT),      	
            .NUM_LANES(NUM_LANES),                                    
            .SKEW_CAL_EN(SKEW_CAL_EN),                                  
            .ALT_CAL_EN(ALT_CAL_EN),                                   
            .SKEW_CAL_LEN(SKEW_CAL_LEN),                                  
            .ALT_CAL_LEN(ALT_CAL_LEN),                                   
            .PREAMBLE_EN(PREAMBLE_EN),                                  
            .CONTINUOUS_CLK(CONTINUOUS_CLK),         
            .TM_EN(TM_EN),                                        
            .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE)
        )   dphy_pcs_tx (
        .fr_clk(fr_clk),         
        .fr_clk_1024(fr_clk_1024),    
        .core_clk(core_clk),       
        .arst_fr_n(arst_fr_n),      
        .srst_fr_n(srst_fr_n),      
        .arst_core_n(arst_core_n),    
        .srst_core_n(srst_core_n),    
        .sig_DPHY_CSR_Enable(sig_DPHY_CSR_Enable),
        .sig_CLK_CSR_CLK_LANE_EN(sig_CLK_CSR_CLK_LANE_EN & sig_DPHY_CSR_Enable),
        .sig_CLK_STATUS_INIT_DONE(sig_CLK_STATUS_INIT_DONE),
        .sig_DLANE_CSR_EN(sig_DLANE_CSR_EN),             
        .sig_DLANE_STATUS_INIT_DONE(sig_DLANE_STATUS_INIT_DONE),
        .sig_PRBS_INIT(sig_PRBS_INIT[NUM_LANES*8-1:0]),              
        .sig_TX_PREAMBLE_LEN_PREAMBLE_EN(sig_TX_PREAMBLE_LEN_PREAMBLE_EN),
        .sig_TX_PREAMBLE_LEN_PREAMLBE_LEN(sig_TX_PREAMBLE_LEN_PREAMLBE_LEN),
        .sig_TX_LPX(sig_TX_LPX),
        .sig_TX_HS_EXIT(sig_TX_HS_EXIT),
        .sig_TX_LP_EXIT(sig_TX_LP_EXIT),
        .sig_TX_CLK_PREPARE(sig_TX_CLK_PREPARE),
        .sig_TX_CLK_TRAIL(sig_TX_CLK_TRAIL),
        .sig_TX_CLK_ZERO(sig_TX_CLK_ZERO),
        .sig_TX_CLK_POST(sig_TX_CLK_POST),
        .sig_TX_CLK_PRE(sig_TX_CLK_PRE),
        .sig_TX_HS_PREPARE(sig_TX_HS_PREPARE),
        .sig_TX_HS_ZERO(sig_TX_HS_ZERO),
        .sig_TX_HS_TRAIL(sig_TX_HS_TRAIL),
        .sig_TX_INIT(sig_TX_INIT),
        .sig_TX_WAKE(sig_TX_WAKE),
        .sig_TX_TM_CONTROL_TX_TM_EN(sig_TX_TM_CONTROL_TX_TM_EN | tm_hs_in),
        .sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE(sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE),
        .sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse(sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse),
        .tm_loopback_in(tm_loopback_in),
        .sig_TX_HS_TM_DESKEW_P(sig_TX_HS_TM_DESKEW_P),
        .sig_TX_WORD_COUNT_B0(sig_TX_WORD_COUNT_B0),
        .sig_TX_WORD_COUNT_B1(sig_TX_WORD_COUNT_B1),
        .sig_TX_WORD_COUNT_B2(sig_TX_WORD_COUNT_B2),
        .sig_TX_WORD_COUNT_B3(sig_TX_WORD_COUNT_B3),
        
        .dphy_port(dphy_port),    
        .dphy_dbg_dlane(dphy_dbg_dlane),
        .dphy_dbg_clane(dphy_dbg_clane),
        .ppi_tx(ppi_bus)      
    );
    
        assign dphy_port.mnl_tx_en = sig_TX_MNL_IO_0_CTRL_EN & arst_fr_n;
        assign dphy_port.mnl_tx_clk_lp_hs_b = sig_TX_MNL_IO_0_CLK_LP_EN;
        assign dphy_port.mnl_tx_data_lp_hs_b = sig_TX_MNL_D_LP_EN[NUM_LANES-1:0];
        assign dphy_port.mnl_tx_data_lp_p = sig_TX_MNL_IO_0_LP_DAT[1];
        assign dphy_port.mnl_tx_data_lp_n = sig_TX_MNL_IO_0_LP_DAT[0];
        assign dphy_port.mnl_tx_data_hs = sig_TX_MNL_IO_0_HS_DAT_D;
        assign dphy_port.mnl_tx_clk_hs = sig_TX_MNL_IO_0_HS_DAT_CK;
            
        assign set_RX_DLANE_ERR_SOT_ERR_pulse = 'h0;                
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse = 'h0;           
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse = 'h0;           
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse = 'h0;          
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse = 'h0;               
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse = 'h0;               
        assign set_RX_DLANE_ERR_CAL_ERR_pulse = 'h0;                
        assign sig_RX_CAL_SKEW_W_START = 'h0;
        assign sig_RX_CAL_SKEW_W_END = 'h0;
        assign sig_RX_CAL_ALT_W_START = 'h0;
        assign sig_RX_CAL_ALT_W_END = 'h0;
        assign sig_RX_DESKEW_DELAY = 'h0;
        assign sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE = 'h0;
        assign sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE = 'h0;
        assign sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE = 'h0;
        assign sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE = 'h0;
        assign sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE = 'h0;
        assign sig_RX_BER_CNT_B0 = 'h0;
        assign sig_RX_BER_CNT_B1 = 'h0;
        assign sig_RX_BER_CNT_B2 = 'h0;
        assign sig_RX_BER_CNT_B3 = 'h0;
        assign rx_clk = 1'b0;
    
    end


    dphy_regfile_top #(
        .NUM_LANES(NUM_LANES),                   
        .PPI_WIDTH(PPI_WIDTH),                   
        .TIME_UNIT(TIME_UNIT),                   
        .BIT_RATE(BIT_RATE),                     
        .TX_VCO_FREQ_MULT(VCO_FREQ_MULT),           
        .RX_FR_CLK_FREQ(RX_FR_CLK_FREQ),         
        .SKEW_CAL_EN(SKEW_CAL_EN),               
        .PER_SKEW_CAL_EN(PER_SKEW_CAL_EN),       
        .ALT_CAL_EN(ALT_CAL_EN),                 
        .PREAMBLE_EN(PREAMBLE_EN),               
        .TM_EN(TM_EN),                           
        .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE),     
        .DPHY_RX_EN(DPHY_RX_EN),                 
        .DPHY_TX_EN(DPHY_TX_EN),                 
        .REG_RW_ENABLE(REG_RW_ENABLE),
        .PRBS_INIT_0(PRBS_INIT[0*8 +: 8]),       
        .PRBS_INIT_1(PRBS_INIT[1*8 +: 8]),       
        .PRBS_INIT_2(PRBS_INIT[2*8 +: 8]),       
        .PRBS_INIT_3(PRBS_INIT[3*8 +: 8]),       
        .PRBS_INIT_4(PRBS_INIT[4*8 +: 8]),       
        .PRBS_INIT_5(PRBS_INIT[5*8 +: 8]),       
        .PRBS_INIT_6(PRBS_INIT[6*8 +: 8]),       
        .PRBS_INIT_7(PRBS_INIT[7*8 +: 8]),       
        .RX_DLANE_DESKEW_DELAY_0(RX_DLANE_DESKEW_DELAY[0*8 +: 7]), 
        .RX_DLANE_DESKEW_DELAY_1(RX_DLANE_DESKEW_DELAY[1*8 +: 7]), 
        .RX_DLANE_DESKEW_DELAY_2(RX_DLANE_DESKEW_DELAY[2*8 +: 7]), 
        .RX_DLANE_DESKEW_DELAY_3(RX_DLANE_DESKEW_DELAY[3*8 +: 7]), 
        .RX_DLANE_DESKEW_DELAY_4(RX_DLANE_DESKEW_DELAY[4*8 +: 7]), 
        .RX_DLANE_DESKEW_DELAY_5(RX_DLANE_DESKEW_DELAY[5*8 +: 7]), 
        .RX_DLANE_DESKEW_DELAY_6(RX_DLANE_DESKEW_DELAY[6*8 +: 7]), 
        .RX_DLANE_DESKEW_DELAY_7(RX_DLANE_DESKEW_DELAY[7*8 +: 7]), 
        .RX_CLK_LOSS_DETECT(RX_CLK_LOSS_DETECT), 
        .REG_USE_AUTO(REG_USE_AUTO),             
        .RX_CAP_EQ_MODE(RX_CAP_EQ_MODE),         
        .RX_CLK_SETTLE(RX_CLK_SETTLE),           
        .RX_HS_SETTLE(RX_HS_SETTLE),             
        .RX_INIT(RX_INIT),                       
        .RX_CLK_POST(RX_CLK_POST),               
        .RX_TM_CONTROL_RX_TM_EN(RX_TM_CONTROL_RX_TM_EN), 
        .RX_TM_CONTROL_RX_TM_LOOPBACK_MODE(RX_TM_CONTROL_RX_TM_LOOPBACK_MODE), 
        .RX_PREP_TIME_TM(RX_PREP_TIME_TM),       
        .TX_CAP_EQ_MODE(TX_CAP_EQ_MODE),         
        .TX_PREAMBLE_LEN_PREAMLBE_LEN(TX_PREAMBLE_LEN_PREAMLBE_LEN), 
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
        .TX_TM_CONTROL_TX_TM_EN(TX_TM_CONTROL_TX_TM_EN), 
        .TX_TM_CONTROL_TX_TM_LOOPBACK_MODE(TX_TM_CONTROL_TX_TM_LOOPBACK_MODE), 
        .TX_HS_TM_DESKEW_P(TX_HS_TM_DESKEW_P)    
    ) dphy_regfile_ins (
        .sig_IP_ID(IP_ID),
        .sig_DPHY_CSR_Enable(sig_DPHY_CSR_Enable),
        .sig_DPHY_CSR_PLL_LOCK(pll_lock),
        .sig_CLK_CSR_CLK_LANE_EN(sig_CLK_CSR_CLK_LANE_EN),
        .sig_CLK_STATUS_INIT_DONE(sig_CLK_STATUS_INIT_DONE),
        .sig_DLANE_CSR_EN(sig_DLANE_CSR_EN),
        .sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse(sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse),
        .sig_DLANE_CSR_RX_MNL_DESKEW_EN(sig_DLANE_CSR_RX_MNL_DESKEW_EN),
        .sig_DLANE_STATUS_INIT_DONE(sig_DLANE_STATUS_INIT_DONE),
        .sig_PRBS_INIT_0(sig_PRBS_INIT[0*8 +: 8]),
        .sig_PRBS_INIT_1(sig_PRBS_INIT[1*8 +: 8]),
        .sig_PRBS_INIT_2(sig_PRBS_INIT[2*8 +: 8]),
        .sig_PRBS_INIT_3(sig_PRBS_INIT[3*8 +: 8]),
        .sig_PRBS_INIT_4(sig_PRBS_INIT[4*8 +: 8]),
        .sig_PRBS_INIT_5(sig_PRBS_INIT[5*8 +: 8]),
        .sig_PRBS_INIT_6(sig_PRBS_INIT[6*8 +: 8]),
        .sig_PRBS_INIT_7(sig_PRBS_INIT[7*8 +: 8]),
        .set_RX_DLANE_ERR_SOT_ERR_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse),
        .set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse),
        .set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse),
        .set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse),
        .set_RX_DLANE_ERR_LPDT_ERR_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse),
        .set_RX_DLANE_ERR_CTRL_ERR_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse),
        .set_RX_DLANE_ERR_CAL_ERR_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse),
        .sig_RX_DLANE_DESKEW_DELAY_0(sig_RX_DLANE_DESKEW_DELAY[0*7 +: 7]),
        .sig_RX_DLANE_DESKEW_DELAY_1(sig_RX_DLANE_DESKEW_DELAY[1*7 +: 7]),
        .sig_RX_DLANE_DESKEW_DELAY_2(sig_RX_DLANE_DESKEW_DELAY[2*7 +: 7]),
        .sig_RX_DLANE_DESKEW_DELAY_3(sig_RX_DLANE_DESKEW_DELAY[3*7 +: 7]),
        .sig_RX_DLANE_DESKEW_DELAY_4(sig_RX_DLANE_DESKEW_DELAY[4*7 +: 7]),
        .sig_RX_DLANE_DESKEW_DELAY_5(sig_RX_DLANE_DESKEW_DELAY[5*7 +: 7]),
        .sig_RX_DLANE_DESKEW_DELAY_6(sig_RX_DLANE_DESKEW_DELAY[6*7 +: 7]),
        .sig_RX_DLANE_DESKEW_DELAY_7(sig_RX_DLANE_DESKEW_DELAY[7*7 +: 7]),
        .sig_RX_CLK_LOSS_DETECT(sig_RX_CLK_LOSS_DETECT),
        .sig_RX_CLK_SETTLE(sig_RX_CLK_SETTLE),
        .sig_RX_HS_SETTLE(sig_RX_HS_SETTLE),
        .sig_RX_INIT(sig_RX_INIT),
        .sig_RX_CLK_POST(sig_RX_CLK_POST),
        .sig_RX_CAL_REG_CTRL_CAL_RESET_pulse(sig_RX_CAL_REG_CTRL_CAL_RESET_pulse),
        .sig_RX_CAL_SKEW_W_START(sig_RX_CAL_SKEW_W_START),
        .sig_RX_CAL_SKEW_W_END(sig_RX_CAL_SKEW_W_END),
        .sig_RX_CAL_ALT_W_START(sig_RX_CAL_ALT_W_START),
        .sig_RX_CAL_ALT_W_END(sig_RX_CAL_ALT_W_END),
        .sig_RX_DESKEW_DELAY(sig_RX_DESKEW_DELAY),
        .sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE(sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE),
        .sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE(sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE),
        .sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE),
        .sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE),
        .sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE),
        .sig_RX_TM_CONTROL_RX_TM_EN(sig_RX_TM_CONTROL_RX_TM_EN),
        .sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE(sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE),
        .sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse(sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse),
        .sig_RX_PREP_TIME_TM(sig_RX_PREP_TIME_TM),
        .sig_RX_BER_CNT_B0(sig_RX_BER_CNT_B0),
        .sig_RX_BER_CNT_B1(sig_RX_BER_CNT_B1),
        .sig_RX_BER_CNT_B2(sig_RX_BER_CNT_B2),
        .sig_RX_BER_CNT_B3(sig_RX_BER_CNT_B3),
        .sig_TX_PREAMBLE_LEN_PREAMBLE_EN(sig_TX_PREAMBLE_LEN_PREAMBLE_EN),
        .sig_TX_PREAMBLE_LEN_PREAMLBE_LEN(sig_TX_PREAMBLE_LEN_PREAMLBE_LEN),
        .sig_TX_CLK_LANE_PS(sig_TX_CLK_LANE_PS),
        .sig_TX_LPX(sig_TX_LPX),
        .sig_TX_HS_EXIT(sig_TX_HS_EXIT),
        .sig_TX_LP_EXIT(sig_TX_LP_EXIT),
        .sig_TX_CLK_PREPARE(sig_TX_CLK_PREPARE),
        .sig_TX_CLK_TRAIL(sig_TX_CLK_TRAIL),
        .sig_TX_CLK_ZERO(sig_TX_CLK_ZERO),
        .sig_TX_CLK_POST(sig_TX_CLK_POST),
        .sig_TX_CLK_PRE(sig_TX_CLK_PRE),
        .sig_TX_HS_PREPARE(sig_TX_HS_PREPARE),
        .sig_TX_HS_ZERO(sig_TX_HS_ZERO),
        .sig_TX_HS_TRAIL(sig_TX_HS_TRAIL),
        .sig_TX_INIT(sig_TX_INIT),
        .sig_TX_WAKE(sig_TX_WAKE),
        .sig_TX_TM_CONTROL_TX_TM_EN(sig_TX_TM_CONTROL_TX_TM_EN),
        .sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE(sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE),
        .sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse(sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse),
        .sig_TX_HS_TM_DESKEW_P(sig_TX_HS_TM_DESKEW_P),
        .sig_TX_MNL_IO_0_CTRL_EN(sig_TX_MNL_IO_0_CTRL_EN),
        .sig_TX_MNL_IO_0_CLK_LP_EN(sig_TX_MNL_IO_0_CLK_LP_EN),
        .sig_TX_MNL_IO_0_LP_DAT(sig_TX_MNL_IO_0_LP_DAT),
        .sig_TX_MNL_IO_0_HS_DAT_D(sig_TX_MNL_IO_0_HS_DAT_D),
        .sig_TX_MNL_IO_0_HS_DAT_CK(sig_TX_MNL_IO_0_HS_DAT_CK),
        .sig_TX_MNL_D_LP_EN(sig_TX_MNL_D_LP_EN),
        .sig_TX_WORD_COUNT_B0(sig_TX_WORD_COUNT_B0),
        .sig_TX_WORD_COUNT_B1(sig_TX_WORD_COUNT_B1),
        .sig_TX_WORD_COUNT_B2(sig_TX_WORD_COUNT_B2),
        .sig_TX_WORD_COUNT_B3(sig_TX_WORD_COUNT_B3),
        .reg_clk(reg_bus.reg_clk),
        .reg_srst_n(reg_bus.reg_srst_n),
        .reg_wr_en(reg_bus.reg_wr_en),
        .reg_be(reg_bus.reg_be),
        .reg_rd_en(reg_bus.reg_rd_en),
        .reg_waddr(reg_bus.reg_waddr),
        .reg_raddr(reg_bus.reg_raddr),
        .reg_din(reg_bus.reg_din),
        .reg_dout(reg_bus.reg_dout),
        .tx_clk(core_clk),
        .rx_clk(rx_clk),
        .fr_clk(core_clk)
    );

endmodule 

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oID2mV3A1RLRC/DMN2naiUnj9QAeYGj2Nd1hq2/YXHf9wdWsk+0H1bwViVgmBpVCFWVbtrx3ucZMW/wh8KopxS1thjGEfY702l9/RMO3IgecK1g4YXa6GDXC/F1nmoqLqAMFv/E5cObryAzdUGkxtjE3Y2gqKn0r1CeXjkZ67Oc9tbldhDTx/TDQyDIngJkRxHWGCqgos+Hj3MHn8hPqqmBqA4Pl/CP817v06qWh0BF2q5hGn8vTjZtehjIM0zFcy1vu1UWk2vB5qyIgFRR3iGk7KsaGaDDJ3YqSnrfgpVEkXtABOTYrjr8o8U/v6326oYk1vymD2JcARG/ObayhETLrkHy+JUrPZo7AU8FOEEkYBvM+Vy5RaTsobmeYGAfyR+921lNWEHQrB+EYAQqOjnkGRqT5kCczV+l/hZQ65VN6kMBNYPe0y4ICICyBQR2cCj9vw89LQU8Vyv+NAzyKNxKbqu7B6U4J0ELS9avDa/53SU6vu5jXya2EWVUC4WkB+oea/gRP/2RbI/W/JO6VnYXglz6nCNDv5csCUz/3oqakczHUu8pgV8ECKQwuKFrzeTCtIUUctnBlG+zzdbmeVQUsC/kWNWs/TM/addlafU/5JL3Qc2BRQ8+IERxOB3KWb7wiDLtJOuoeez7u1cNKMgn40oKkLT7beO8mgHm5EGzwkkaCimqHbRpHERLNCRQ5LdInfVfDpLXRJ/G48oZHjksBuNqmGO5b+G42/PuCkITqWHwjZ0wNWWntgDrkX16vrI9eqKeEU7go0niYVqbH+5S"
`endif