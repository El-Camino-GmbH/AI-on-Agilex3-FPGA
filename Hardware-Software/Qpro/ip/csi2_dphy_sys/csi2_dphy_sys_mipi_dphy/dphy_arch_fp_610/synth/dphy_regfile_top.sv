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



import dphy_reg_pkg::*;
import dphy_pkg::*;
module dphy_regfile_top #(

    parameter NUM_LANES = 4,                                    
    parameter PPI_WIDTH = 16,                                   
    parameter TIME_UNIT = "ps",                                 
    parameter BIT_RATE = 36'd2000000000,                        
    parameter TX_VCO_FREQ_MULT = BIT_RATE <300000000 ? 8 : BIT_RATE < 600000000 ? 4 : BIT_RATE < 1200000000 ? 2 : 1,
    parameter unsigned RX_FR_CLK_FREQ = BIT_RATE  / PPI_WIDTH,  
    parameter SKEW_CAL_EN = 1,                                  
    parameter PER_SKEW_CAL_EN = 1,                              
    parameter ALT_CAL_EN = 1,                                   
    parameter PREAMBLE_EN = 1,                                  
    parameter TM_EN = 0,                                        
    parameter TM_LOOPBACK_MODE = 1,                             
    parameter DPHY_RX_EN = 0,                                   
    parameter DPHY_TX_EN = 0,                                   
    parameter SKEW_CAL_LEN = 32768,                             
    parameter ALT_CAL_LEN = 65536,                              
    parameter PRBS_INIT_0   = 8'hFF,                                      
    parameter REG_RW_ENABLE = 0,                                          
    parameter PRBS_INIT_1   = 8'hFF,                                      
    parameter PRBS_INIT_2   = 8'hFF,                                      
    parameter PRBS_INIT_3   = 8'hFF,                                      
    parameter PRBS_INIT_4   = 8'hFF,                                      
    parameter PRBS_INIT_5   = 8'hFF,                                      
    parameter PRBS_INIT_6   = 8'hFF,                                      
    parameter PRBS_INIT_7   = 8'hFF,                                      
    parameter RX_DLANE_DESKEW_DELAY_0   = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_1   = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_2   = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_3   = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_4   = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_5   = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_6   = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_7   = 7'h0,                           
    parameter RX_CLK_LOSS_DETECT   =  0,                                  
    parameter REG_USE_AUTO = 0,                                           
    parameter RX_CAP_EQ_MODE   = 0,                                       
    parameter RX_CLK_SETTLE   =  0,                                       
    parameter RX_HS_SETTLE   =  0,                                        
    parameter RX_INIT   =  0,                                             
    parameter RX_CLK_POST   =  0,                                         
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
    input [7:0] sig_IP_ID,
    output logic sig_DPHY_CSR_Enable,
    input sig_DPHY_CSR_PLL_LOCK,
    output logic sig_CLK_CSR_CLK_LANE_EN,
    input sig_CLK_STATUS_INIT_DONE,
    output logic [NUM_LANES-1:0] sig_DLANE_CSR_EN,          
    output logic [NUM_LANES-1:0] sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse,
    output logic [NUM_LANES-1:0] sig_DLANE_CSR_RX_MNL_DESKEW_EN,
    input [NUM_LANES-1:0] sig_DLANE_STATUS_INIT_DONE,       
    output logic [7:0] sig_PRBS_INIT_0,
    output logic [7:0] sig_PRBS_INIT_1,
    output logic [7:0] sig_PRBS_INIT_2,
    output logic [7:0] sig_PRBS_INIT_3,
    output logic [7:0] sig_PRBS_INIT_4,
    output logic [7:0] sig_PRBS_INIT_5,
    output logic [7:0] sig_PRBS_INIT_6,
    output logic [7:0] sig_PRBS_INIT_7,
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_0,
    input [NUM_LANES-1:0] set_RX_DLANE_ERR_SOT_ERR_pulse,   
    input [NUM_LANES-1:0] set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse,
    input [NUM_LANES-1:0] set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse,
    input [NUM_LANES-1:0] set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse,
    input [NUM_LANES-1:0] set_RX_DLANE_ERR_LPDT_ERR_pulse,  
    input [NUM_LANES-1:0] set_RX_DLANE_ERR_CTRL_ERR_pulse,  
    input [NUM_LANES-1:0] set_RX_DLANE_ERR_CAL_ERR_pulse,   
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_1,
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_2,
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_3,
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_4,
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_5,
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_6,
    output logic [6:0] sig_RX_DLANE_DESKEW_DELAY_7,
    output logic [7:0] sig_RX_CLK_LOSS_DETECT,
    output logic [7:0] sig_RX_CLK_SETTLE,
    output logic [7:0] sig_RX_HS_SETTLE,
    output logic [7:0] sig_RX_INIT,
    output logic [7:0] sig_RX_CLK_POST,
    output logic sig_RX_CAL_REG_CTRL_CAL_RESET_pulse,
    input [NUM_LANES*8-1:0] sig_RX_CAL_SKEW_W_START,

    input [NUM_LANES*8-1:0] sig_RX_CAL_SKEW_W_END,

    input [NUM_LANES*8-1:0] sig_RX_CAL_ALT_W_START,

    input [NUM_LANES*8-1:0] sig_RX_CAL_ALT_W_END,

    input [NUM_LANES*7-1:0] sig_RX_DESKEW_DELAY,

    input [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE,

    input [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE,

    input [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE,

    input [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE,

    input [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE,

    output logic sig_RX_TM_CONTROL_RX_TM_EN,
    output logic sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE,
    output logic sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse,
    output logic [7:0] sig_RX_PREP_TIME_TM,
    input [NUM_LANES*8-1:0] sig_RX_BER_CNT_B0,

    input [NUM_LANES*8-1:0] sig_RX_BER_CNT_B1,

    input [NUM_LANES*8-1:0] sig_RX_BER_CNT_B2,

    input [NUM_LANES*8-1:0] sig_RX_BER_CNT_B3,

    output logic sig_TX_PREAMBLE_LEN_PREAMBLE_EN,
    output logic [3:0] sig_TX_PREAMBLE_LEN_PREAMLBE_LEN,
    output logic [5:0] sig_TX_CLK_LANE_PS,
    output logic [6:0] sig_TX_LPX,
    output logic [7:0] sig_TX_HS_EXIT,
    output logic [7:0] sig_TX_LP_EXIT,
    output logic [5:0] sig_TX_CLK_PREPARE,
    output logic [6:0] sig_TX_CLK_TRAIL,
    output logic [6:0] sig_TX_CLK_ZERO,
    output logic [7:0] sig_TX_CLK_POST,
    output logic [3:0] sig_TX_CLK_PRE,
    output logic [5:0] sig_TX_HS_PREPARE,
    output logic [7:0] sig_TX_HS_ZERO,
    output logic [7:0] sig_TX_HS_TRAIL,
    output logic [7:0] sig_TX_INIT,
    output logic [7:0] sig_TX_WAKE,
    output logic sig_TX_TM_CONTROL_TX_TM_EN,
    output logic sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE,
    output logic sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse,
    output logic [7:0] sig_TX_HS_TM_DESKEW_P,
    output logic sig_TX_MNL_IO_0_CTRL_EN,
    output logic sig_TX_MNL_IO_0_CLK_LP_EN,
    output logic [1:0] sig_TX_MNL_IO_0_LP_DAT,
    output logic [1:0] sig_TX_MNL_IO_0_HS_DAT_D,
    output logic [1:0] sig_TX_MNL_IO_0_HS_DAT_CK,
    output logic [7:0] sig_TX_MNL_D_LP_EN,
    input [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B0,

    input [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B1,

    input [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B2,

    input [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B3,
    input reg_clk,
    input reg_srst_n,
    input reg_wr_en,
    input [3:0] reg_be,
    input reg_rd_en,
    input [7:0] reg_waddr,
    input [7:0] reg_raddr,
    input [31:0] reg_din,
    output logic [31:0] reg_dout,
    input tx_clk,
    input [1:0] rx_clk,
    input fr_clk
    );

    logic [6:0] sig_RX_DESKEW_DELAY_MUX;;
    logic [7:0] sig_RX_BER_CNT_B0_MUX;;
    logic [7:0] sig_RX_BER_CNT_B1_MUX;;
    logic [7:0] sig_RX_BER_CNT_B2_MUX;;
    logic [7:0] sig_RX_BER_CNT_B3_MUX;;
    logic [7:0] sig_RX_CAL_ALT_W_END_MUX;;
    logic [7:0] sig_RX_CAL_ALT_W_START_MUX;;
    logic [7:0] sig_RX_CAL_SKEW_W_END_MUX;;
    logic [7:0] sig_RX_CAL_SKEW_W_START_MUX;;
    logic [7:0] sig_TX_WORD_COUNT_B0_MUX;;
    logic [7:0] sig_TX_WORD_COUNT_B1_MUX;;
    logic [7:0] sig_TX_WORD_COUNT_B2_MUX;;
    logic [7:0] sig_TX_WORD_COUNT_B3_MUX;;
    logic sig_RX_CAL_STATUS_DPHY_ALT_CAL_DONE;;
    logic sig_RX_CAL_STATUS_DPHY_ALT_CAL_ERR;;
    logic sig_RX_CAL_STATUS_DPHY_INIT_SKEW_CAL_ERR;;
    logic sig_RX_CAL_STATUS_DPHY_PER_SKEW_CAL_ERR;;
    logic sig_RX_CAL_STATUS_DPHY_SKEW_CAL_DONE;;
    logic [2:0] sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL;;
    logic clr_RX_CAL_REG_CTRL_CAL_RESET_tog;;
    logic clr_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc;;
    logic clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog;;
    logic clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc;;
    logic clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog;;
    logic clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc;;
    logic sig_RX_CAL_REG_CTRL_CAL_RESET_tog;;
    logic sig_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc;;
    logic sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog;;
    logic sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc;;
    logic sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog;;
    logic sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc;;
    logic [7:0] clr_DLANE_CSR_RX_DESKEW_UPDATE_tog;
    logic [7:0] clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc;
    logic [7:0] set_RX_DLANE_ERR_CAL_ERR_pulse_int;
    logic [7:0] set_RX_DLANE_ERR_CAL_ERR_pulse_int_cdc;
    logic [7:0] set_RX_DLANE_ERR_CTRL_ERR_pulse_int;
    logic [7:0] set_RX_DLANE_ERR_CTRL_ERR_pulse_int_cdc;
    logic [7:0] set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int;
    logic [7:0] set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int_cdc;
    logic [7:0] set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int;
    logic [7:0] set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int_cdc;
    logic [7:0] set_RX_DLANE_ERR_LPDT_ERR_pulse_int;
    logic [7:0] set_RX_DLANE_ERR_LPDT_ERR_pulse_int_cdc;
    logic [7:0] set_RX_DLANE_ERR_SOT_ERR_pulse_int;
    logic [7:0] set_RX_DLANE_ERR_SOT_ERR_pulse_int_cdc;
    logic [7:0] set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int;
    logic [7:0] set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int_cdc;
    logic [7:0] sig_DLANE_CSR_RX_DESKEW_UPDATE_tog;
    logic [7:0] sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc;

   logic 	arst_regsrst_rxclk0;
   logic 	arst_regsrst_rxclk1;
   logic 	arst_regsrst_frclk;  
   logic 	arst_regsrst_txclk;
   
    dphy_regfile #(
        .NUM_LANES(NUM_LANES),                   
        .PPI_WIDTH(PPI_WIDTH),                   
        .TIME_UNIT(TIME_UNIT),                   
        .BIT_RATE(BIT_RATE),                     
        .TX_VCO_FREQ_MULT(TX_VCO_FREQ_MULT),     
        .RX_FR_CLK_FREQ(RX_FR_CLK_FREQ),         
        .SKEW_CAL_EN(SKEW_CAL_EN),               
        .PER_SKEW_CAL_EN(PER_SKEW_CAL_EN),       
        .ALT_CAL_EN(ALT_CAL_EN),                 
        .PREAMBLE_EN(PREAMBLE_EN),               
        .TM_EN(TM_EN),                           
        .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE),     
        .DPHY_RX_EN(DPHY_RX_EN),                 
        .DPHY_TX_EN(DPHY_TX_EN),                 
        .SKEW_CAL_LEN(SKEW_CAL_LEN),             
        .ALT_CAL_LEN(ALT_CAL_LEN),               
        .PRBS_INIT_0_D(PRBS_INIT_0),             
        .PRBS_INIT_0_RW(REG_RW_ENABLE),          
        .PRBS_INIT_1_D(PRBS_INIT_1),             
        .PRBS_INIT_1_RW(REG_RW_ENABLE),          
        .PRBS_INIT_2_D(PRBS_INIT_2),             
        .PRBS_INIT_2_RW(REG_RW_ENABLE),          
        .PRBS_INIT_3_D(PRBS_INIT_3),             
        .PRBS_INIT_3_RW(REG_RW_ENABLE),          
        .PRBS_INIT_4_D(PRBS_INIT_4),             
        .PRBS_INIT_4_RW(REG_RW_ENABLE),          
        .PRBS_INIT_5_D(PRBS_INIT_5),             
        .PRBS_INIT_5_RW(REG_RW_ENABLE),          
        .PRBS_INIT_6_D(PRBS_INIT_6),             
        .PRBS_INIT_6_RW(REG_RW_ENABLE),          
        .PRBS_INIT_7_D(PRBS_INIT_7),             
        .PRBS_INIT_7_RW(REG_RW_ENABLE),          
        .RX_DLANE_DESKEW_DELAY_0_D(RX_DLANE_DESKEW_DELAY_0), 
        .RX_DLANE_DESKEW_DELAY_0_RW(REG_RW_ENABLE), 
        .RX_DLANE_DESKEW_DELAY_1_D(RX_DLANE_DESKEW_DELAY_1), 
        .RX_DLANE_DESKEW_DELAY_1_RW(REG_RW_ENABLE), 
        .RX_DLANE_DESKEW_DELAY_2_D(RX_DLANE_DESKEW_DELAY_2), 
        .RX_DLANE_DESKEW_DELAY_2_RW(REG_RW_ENABLE), 
        .RX_DLANE_DESKEW_DELAY_3_D(RX_DLANE_DESKEW_DELAY_3), 
        .RX_DLANE_DESKEW_DELAY_3_RW(REG_RW_ENABLE), 
        .RX_DLANE_DESKEW_DELAY_4_D(RX_DLANE_DESKEW_DELAY_4), 
        .RX_DLANE_DESKEW_DELAY_4_RW(REG_RW_ENABLE), 
        .RX_DLANE_DESKEW_DELAY_5_D(RX_DLANE_DESKEW_DELAY_5), 
        .RX_DLANE_DESKEW_DELAY_5_RW(REG_RW_ENABLE), 
        .RX_DLANE_DESKEW_DELAY_6_D(RX_DLANE_DESKEW_DELAY_6), 
        .RX_DLANE_DESKEW_DELAY_6_RW(REG_RW_ENABLE), 
        .RX_DLANE_DESKEW_DELAY_7_D(RX_DLANE_DESKEW_DELAY_7), 
        .RX_DLANE_DESKEW_DELAY_7_RW(REG_RW_ENABLE), 
        .RX_CLK_LOSS_DETECT_D(RX_CLK_LOSS_DETECT), 
        .RX_CLK_LOSS_DETECT_USE_AUTO(REG_USE_AUTO), 
        .RX_CLK_LOSS_DETECT_RW(REG_RW_ENABLE),   
        .RX_CAP_EQ_MODE_D(RX_CAP_EQ_MODE),       
        .RX_CLK_SETTLE_D(RX_CLK_SETTLE),         
        .RX_CLK_SETTLE_USE_AUTO(REG_USE_AUTO),   
        .RX_CLK_SETTLE_RW(REG_RW_ENABLE),        
        .RX_HS_SETTLE_D(RX_HS_SETTLE),           
        .RX_HS_SETTLE_USE_AUTO(REG_USE_AUTO),    
        .RX_HS_SETTLE_RW(REG_RW_ENABLE),         
        .RX_INIT_D(RX_INIT),                     
        .RX_INIT_USE_AUTO(REG_USE_AUTO),         
        .RX_INIT_RW(REG_RW_ENABLE),              
        .RX_CLK_POST_D(RX_CLK_POST),             
        .RX_CLK_POST_USE_AUTO(REG_USE_AUTO),     
        .RX_CLK_POST_RW(REG_RW_ENABLE),          
        .RX_TM_CONTROL_RX_TM_EN_D(RX_TM_CONTROL_RX_TM_EN), 
        .RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_D(RX_TM_CONTROL_RX_TM_LOOPBACK_MODE), 
        .RX_PREP_TIME_TM_D(RX_PREP_TIME_TM),     
        .RX_PREP_TIME_TM_RW(REG_RW_ENABLE),      
        .TX_CAP_EQ_MODE_D(TX_CAP_EQ_MODE),       
        .TX_PREAMBLE_LEN_PREAMLBE_LEN_D(TX_PREAMBLE_LEN_PREAMLBE_LEN), 
        .TX_CLK_LANE_PS_D(TX_CLK_LANE_PS),       
        .TX_LPX_D(TX_LPX),                       
        .TX_LPX_USE_AUTO(REG_USE_AUTO),          
        .TX_LPX_RW(REG_RW_ENABLE),               
        .TX_HS_EXIT_D(TX_HS_EXIT),               
        .TX_HS_EXIT_USE_AUTO(REG_USE_AUTO),      
        .TX_HS_EXIT_RW(REG_RW_ENABLE),           
        .TX_LP_EXIT_D(TX_LP_EXIT),               
        .TX_LP_EXIT_USE_AUTO(REG_USE_AUTO),      
        .TX_LP_EXIT_RW(REG_RW_ENABLE),           
        .TX_CLK_PREPARE_D(TX_CLK_PREPARE),       
        .TX_CLK_PREPARE_USE_AUTO(REG_USE_AUTO),  
        .TX_CLK_PREPARE_RW(REG_RW_ENABLE),       
        .TX_CLK_TRAIL_D(TX_CLK_TRAIL),           
        .TX_CLK_TRAIL_USE_AUTO(REG_USE_AUTO),    
        .TX_CLK_TRAIL_RW(REG_RW_ENABLE),         
        .TX_CLK_ZERO_D(TX_CLK_ZERO),             
        .TX_CLK_ZERO_USE_AUTO(REG_USE_AUTO),     
        .TX_CLK_ZERO_RW(REG_RW_ENABLE),          
        .TX_CLK_POST_D(TX_CLK_POST),             
        .TX_CLK_POST_USE_AUTO(REG_USE_AUTO),     
        .TX_CLK_POST_RW(REG_RW_ENABLE),          
        .TX_CLK_PRE_D(TX_CLK_PRE),               
        .TX_CLK_PRE_USE_AUTO(REG_USE_AUTO),      
        .TX_CLK_PRE_RW(REG_RW_ENABLE),           
        .TX_HS_PREPARE_D(TX_HS_PREPARE),         
        .TX_HS_PREPARE_USE_AUTO(REG_USE_AUTO),   
        .TX_HS_PREPARE_RW(REG_RW_ENABLE),        
        .TX_HS_ZERO_D(TX_HS_ZERO),               
        .TX_HS_ZERO_USE_AUTO(REG_USE_AUTO),      
        .TX_HS_ZERO_RW(REG_RW_ENABLE),           
        .TX_HS_TRAIL_D(TX_HS_TRAIL),             
        .TX_HS_TRAIL_USE_AUTO(REG_USE_AUTO),     
        .TX_HS_TRAIL_RW(REG_RW_ENABLE),          
        .TX_INIT_D(TX_INIT),                     
        .TX_INIT_USE_AUTO(REG_USE_AUTO),         
        .TX_INIT_RW(REG_RW_ENABLE),              
        .TX_WAKE_D(TX_WAKE),                     
        .TX_WAKE_USE_AUTO(REG_USE_AUTO),         
        .TX_WAKE_RW(REG_RW_ENABLE),              
        .TX_TM_CONTROL_TX_TM_EN_D(TX_TM_CONTROL_TX_TM_EN), 
        .TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_D(TX_TM_CONTROL_TX_TM_LOOPBACK_MODE), 
        .TX_HS_TM_DESKEW_P_D(TX_HS_TM_DESKEW_P), 
        .TX_HS_TM_DESKEW_P_RW(REG_RW_ENABLE)     
    ) dphy_regfile_ins (
        .sig_IP_ID(sig_IP_ID),
        .sig_DPHY_CSR_Enable(sig_DPHY_CSR_Enable),
        .sig_DPHY_CSR_PLL_LOCK(sig_DPHY_CSR_PLL_LOCK),
        .sig_CLK_CSR_CLK_LANE_EN(sig_CLK_CSR_CLK_LANE_EN),
        .sig_CLK_STATUS_INIT_DONE(sig_CLK_STATUS_INIT_DONE),
        .sig_DLANE_CSR_EN(sig_DLANE_CSR_EN),
        .clr_DLANE_CSR_RX_DESKEW_UPDATE_tog(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog),
        .sig_DLANE_CSR_RX_DESKEW_UPDATE_tog(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog),
        .sig_DLANE_CSR_RX_MNL_DESKEW_EN(sig_DLANE_CSR_RX_MNL_DESKEW_EN),
        .sig_DLANE_STATUS_INIT_DONE(sig_DLANE_STATUS_INIT_DONE),
        .sig_PRBS_INIT_0(sig_PRBS_INIT_0),
        .sig_PRBS_INIT_1(sig_PRBS_INIT_1),
        .sig_PRBS_INIT_2(sig_PRBS_INIT_2),
        .sig_PRBS_INIT_3(sig_PRBS_INIT_3),
        .sig_PRBS_INIT_4(sig_PRBS_INIT_4),
        .sig_PRBS_INIT_5(sig_PRBS_INIT_5),
        .sig_PRBS_INIT_6(sig_PRBS_INIT_6),
        .sig_PRBS_INIT_7(sig_PRBS_INIT_7),
        .sig_RX_DLANE_DESKEW_DELAY_0(sig_RX_DLANE_DESKEW_DELAY_0),
        .set_RX_DLANE_ERR_SOT_ERR_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int),
        .set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int),
        .set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int),
        .set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int),
        .set_RX_DLANE_ERR_LPDT_ERR_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int),
        .set_RX_DLANE_ERR_CTRL_ERR_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int),
        .set_RX_DLANE_ERR_CAL_ERR_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int),
        .sig_RX_DLANE_DESKEW_DELAY_1(sig_RX_DLANE_DESKEW_DELAY_1),
        .sig_RX_DLANE_DESKEW_DELAY_2(sig_RX_DLANE_DESKEW_DELAY_2),
        .sig_RX_DLANE_DESKEW_DELAY_3(sig_RX_DLANE_DESKEW_DELAY_3),
        .sig_RX_DLANE_DESKEW_DELAY_4(sig_RX_DLANE_DESKEW_DELAY_4),
        .sig_RX_DLANE_DESKEW_DELAY_5(sig_RX_DLANE_DESKEW_DELAY_5),
        .sig_RX_DLANE_DESKEW_DELAY_6(sig_RX_DLANE_DESKEW_DELAY_6),
        .sig_RX_DLANE_DESKEW_DELAY_7(sig_RX_DLANE_DESKEW_DELAY_7),
        .sig_RX_CLK_LOSS_DETECT(sig_RX_CLK_LOSS_DETECT),
        .sig_RX_CLK_SETTLE(sig_RX_CLK_SETTLE),
        .sig_RX_HS_SETTLE(sig_RX_HS_SETTLE),
        .sig_RX_INIT(sig_RX_INIT),
        .sig_RX_CLK_POST(sig_RX_CLK_POST),
        .sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL(sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL),
        .clr_RX_CAL_REG_CTRL_CAL_RESET_tog(clr_RX_CAL_REG_CTRL_CAL_RESET_tog),
        .sig_RX_CAL_REG_CTRL_CAL_RESET_tog(sig_RX_CAL_REG_CTRL_CAL_RESET_tog),
        .sig_RX_CAL_STATUS_DPHY_SKEW_CAL_DONE(sig_RX_CAL_STATUS_DPHY_SKEW_CAL_DONE),
        .sig_RX_CAL_STATUS_DPHY_ALT_CAL_DONE(sig_RX_CAL_STATUS_DPHY_ALT_CAL_DONE),
        .sig_RX_CAL_STATUS_DPHY_INIT_SKEW_CAL_ERR(sig_RX_CAL_STATUS_DPHY_INIT_SKEW_CAL_ERR),
        .sig_RX_CAL_STATUS_DPHY_PER_SKEW_CAL_ERR(sig_RX_CAL_STATUS_DPHY_PER_SKEW_CAL_ERR),
        .sig_RX_CAL_STATUS_DPHY_ALT_CAL_ERR(sig_RX_CAL_STATUS_DPHY_ALT_CAL_ERR),
        .sig_RX_CAL_SKEW_W_START_MUX(sig_RX_CAL_SKEW_W_START_MUX),
        .sig_RX_CAL_SKEW_W_END_MUX(sig_RX_CAL_SKEW_W_END_MUX),
        .sig_RX_CAL_ALT_W_START_MUX(sig_RX_CAL_ALT_W_START_MUX),
        .sig_RX_CAL_ALT_W_END_MUX(sig_RX_CAL_ALT_W_END_MUX),
        .sig_RX_DESKEW_DELAY_MUX(sig_RX_DESKEW_DELAY_MUX),
        .sig_RX_CAL_STATUS_LANE_MUX_SKEW_CAL_DONE_LANE(sig_RX_CAL_STATUS_LANE_MUX_SKEW_CAL_DONE_LANE),
        .sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_DONE_LANE(sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_DONE_LANE),
        .sig_RX_CAL_STATUS_LANE_MUX_INIT_SKEW_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_MUX_INIT_SKEW_CAL_ERR_LANE),
        .sig_RX_CAL_STATUS_LANE_MUX_PER_SKEW_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_MUX_PER_SKEW_CAL_ERR_LANE),
        .sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_ERR_LANE(sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_ERR_LANE),
        .sig_RX_TM_CONTROL_RX_TM_EN(sig_RX_TM_CONTROL_RX_TM_EN),
        .sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE(sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE),
        .clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog(clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog),
        .sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog(sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog),
        .sig_RX_PREP_TIME_TM(sig_RX_PREP_TIME_TM),
        .sig_RX_BER_CNT_B0_MUX(sig_RX_BER_CNT_B0_MUX),
        .sig_RX_BER_CNT_B1_MUX(sig_RX_BER_CNT_B1_MUX),
        .sig_RX_BER_CNT_B2_MUX(sig_RX_BER_CNT_B2_MUX),
        .sig_RX_BER_CNT_B3_MUX(sig_RX_BER_CNT_B3_MUX),
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
        .clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog(clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog),
        .sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog(sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog),
        .sig_TX_HS_TM_DESKEW_P(sig_TX_HS_TM_DESKEW_P),
        .sig_TX_MNL_IO_0_CTRL_EN(sig_TX_MNL_IO_0_CTRL_EN),
        .sig_TX_MNL_IO_0_CLK_LP_EN(sig_TX_MNL_IO_0_CLK_LP_EN),
        .sig_TX_MNL_IO_0_LP_DAT(sig_TX_MNL_IO_0_LP_DAT),
        .sig_TX_MNL_IO_0_HS_DAT_D(sig_TX_MNL_IO_0_HS_DAT_D),
        .sig_TX_MNL_IO_0_HS_DAT_CK(sig_TX_MNL_IO_0_HS_DAT_CK),
        .sig_TX_MNL_D_LP_EN(sig_TX_MNL_D_LP_EN),
        .sig_TX_WORD_COUNT_B0_MUX(sig_TX_WORD_COUNT_B0_MUX),
        .sig_TX_WORD_COUNT_B1_MUX(sig_TX_WORD_COUNT_B1_MUX),
        .sig_TX_WORD_COUNT_B2_MUX(sig_TX_WORD_COUNT_B2_MUX),
        .sig_TX_WORD_COUNT_B3_MUX(sig_TX_WORD_COUNT_B3_MUX),
        .clk(reg_clk),
        .srst_n(reg_srst_n),
        .wr_en(reg_wr_en),
        .be(reg_be),
        .rd_en(reg_rd_en),
        .waddr(reg_waddr),
        .raddr(reg_raddr),
        .din(reg_din),
        .dout(reg_dout)    
    );
    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_skew_w_start_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_SKEW_W_START[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_SKEW_W_START_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_cal_skew_w_start_8_stub
        assign sig_RX_CAL_SKEW_W_START_MUX = 8'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_skew_w_end_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_SKEW_W_END[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_SKEW_W_END_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_cal_skew_w_end_8_stub
        assign sig_RX_CAL_SKEW_W_END_MUX = 8'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_alt_w_start_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_ALT_W_START[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_ALT_W_START_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_cal_alt_w_start_8_stub
        assign sig_RX_CAL_ALT_W_START_MUX = 8'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_alt_w_end_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_ALT_W_END[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_ALT_W_END_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_cal_alt_w_end_8_stub
        assign sig_RX_CAL_ALT_W_END_MUX = 8'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_deskew_delay_7_mux
        logic [7:0] [6:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_DESKEW_DELAY[mux_sel * 7 +:7] : 7'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_DESKEW_DELAY_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_deskew_delay_7_stub
        assign sig_RX_DESKEW_DELAY_MUX = 7'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_status_lane_skew_cal_done_lane_1_mux
        assign sig_RX_CAL_STATUS_DPHY_SKEW_CAL_DONE = | sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE;
        logic [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE[mux_sel] : 1'b0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_STATUS_LANE_MUX_SKEW_CAL_DONE_LANE = |mux_out;
    end
    else
    begin : sig_rx_cal_status_lane_skew_cal_done_lane_1_stub
        assign sig_RX_CAL_STATUS_DPHY_SKEW_CAL_DONE = 1'h0;
        assign sig_RX_CAL_STATUS_LANE_MUX_SKEW_CAL_DONE_LANE = 1'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_status_lane_alt_cal_done_lane_1_mux
        assign sig_RX_CAL_STATUS_DPHY_ALT_CAL_DONE = | sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE;
        logic [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE[mux_sel] : 1'b0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_DONE_LANE = |mux_out;
    end
    else
    begin : sig_rx_cal_status_lane_alt_cal_done_lane_1_stub
        assign sig_RX_CAL_STATUS_DPHY_ALT_CAL_DONE = 1'h0;
        assign sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_DONE_LANE = 1'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_status_lane_init_skew_cal_err_lane_1_mux
        assign sig_RX_CAL_STATUS_DPHY_INIT_SKEW_CAL_ERR = | sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE;
        logic [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE[mux_sel] : 1'b0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_STATUS_LANE_MUX_INIT_SKEW_CAL_ERR_LANE = |mux_out;
    end
    else
    begin : sig_rx_cal_status_lane_init_skew_cal_err_lane_1_stub
        assign sig_RX_CAL_STATUS_DPHY_INIT_SKEW_CAL_ERR = 1'h0;
        assign sig_RX_CAL_STATUS_LANE_MUX_INIT_SKEW_CAL_ERR_LANE = 1'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_status_lane_per_skew_cal_err_lane_1_mux
        assign sig_RX_CAL_STATUS_DPHY_PER_SKEW_CAL_ERR = | sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE;
        logic [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE[mux_sel] : 1'b0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_STATUS_LANE_MUX_PER_SKEW_CAL_ERR_LANE = |mux_out;
    end
    else
    begin : sig_rx_cal_status_lane_per_skew_cal_err_lane_1_stub
        assign sig_RX_CAL_STATUS_DPHY_PER_SKEW_CAL_ERR = 1'h0;
        assign sig_RX_CAL_STATUS_LANE_MUX_PER_SKEW_CAL_ERR_LANE = 1'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_cal_status_lane_alt_cal_err_lane_1_mux
        assign sig_RX_CAL_STATUS_DPHY_ALT_CAL_ERR = | sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE;
        logic [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE[mux_sel] : 1'b0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_ERR_LANE = |mux_out;
    end
    else
    begin : sig_rx_cal_status_lane_alt_cal_err_lane_1_stub
        assign sig_RX_CAL_STATUS_DPHY_ALT_CAL_ERR = 1'h0;
        assign sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_ERR_LANE = 1'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_ber_cnt_b0_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_BER_CNT_B0[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_BER_CNT_B0_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_ber_cnt_b0_8_stub
        assign sig_RX_BER_CNT_B0_MUX = 8'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_ber_cnt_b1_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_BER_CNT_B1[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_BER_CNT_B1_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_ber_cnt_b1_8_stub
        assign sig_RX_BER_CNT_B1_MUX = 8'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_ber_cnt_b2_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_BER_CNT_B2[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_BER_CNT_B2_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_ber_cnt_b2_8_stub
        assign sig_RX_BER_CNT_B2_MUX = 8'h0;
    end

    if(DPHY_RX_EN == 1)
    begin : sig_rx_ber_cnt_b3_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_RX_BER_CNT_B3[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_RX_BER_CNT_B3_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_rx_ber_cnt_b3_8_stub
        assign sig_RX_BER_CNT_B3_MUX = 8'h0;
    end

    if(DPHY_TX_EN == 1)
    begin : sig_tx_word_count_b0_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_TX_WORD_COUNT_B0[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_TX_WORD_COUNT_B0_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_tx_word_count_b0_8_stub
        assign sig_TX_WORD_COUNT_B0_MUX = 8'h0;
    end

    if(DPHY_TX_EN == 1)
    begin : sig_tx_word_count_b1_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_TX_WORD_COUNT_B1[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_TX_WORD_COUNT_B1_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_tx_word_count_b1_8_stub
        assign sig_TX_WORD_COUNT_B1_MUX = 8'h0;
    end

    if(DPHY_TX_EN == 1)
    begin : sig_tx_word_count_b2_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_TX_WORD_COUNT_B2[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_TX_WORD_COUNT_B2_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_tx_word_count_b2_8_stub
        assign sig_TX_WORD_COUNT_B2_MUX = 8'h0;
    end

    if(DPHY_TX_EN == 1)
    begin : sig_tx_word_count_b3_8_mux
        logic [7:0] [7:0] mux_out ;
        genvar mux_sel ;
        for (mux_sel = 0; mux_sel < NUM_LANES; mux_sel++)
        begin : mux_out_drv
            assign mux_out[mux_sel] = ((sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL == mux_sel) ? sig_TX_WORD_COUNT_B3[mux_sel * 8 +:8] : 8'h0);
        end
        for (mux_sel = NUM_LANES; mux_sel < 8; mux_sel++)
        begin : mux_out_stub
            assign mux_out[mux_sel] = 'h0;
        end
        assign sig_TX_WORD_COUNT_B3_MUX = mux_out[0] | mux_out[1] | mux_out[2] | mux_out[3] | mux_out[4] | mux_out[5] | mux_out[6] | mux_out[7];
    end
    else
    begin : sig_tx_word_count_b3_8_stub
        assign sig_TX_WORD_COUNT_B3_MUX = 8'h0;
    end

    if(DPHY_TX_EN == 1)
      begin : dphy_reg_rst_sync_a0
         altera_std_synchronizer_nocut # ( .depth(3) ) cdc_async_regrst_txclk (
            .clk(tx_clk), .reset_n(reg_srst_n), .din(1'b1), .dout(arst_regsrst_txclk) );
      end
   
    if(DPHY_RX_EN == 1)
      begin : dphy_reg_rst_sync_b0
	     altera_std_synchronizer_nocut # ( .depth(3) ) cdc_async_regrst_rxclk_0 (
            .clk(rx_clk[0]), .reset_n(reg_srst_n), .din(1'b1), .dout(arst_regsrst_rxclk0) );
         altera_std_synchronizer_nocut # ( .depth(3) ) cdc_async_regrst_frclk (
            .clk(fr_clk), .reset_n(reg_srst_n), .din(1'b1), .dout(arst_regsrst_frclk) );
      end
    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
      begin : dphy_reg_rst_sync_b1
 	     altera_std_synchronizer_nocut # ( .depth(3) ) cdc_async_regrst_rxclk_1 (
            .clk(rx_clk[1]), .reset_n(reg_srst_n), .din(1'b1), .dout(arst_regsrst_rxclk1) ); 
      end
   
   
    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : dlane_csr_0_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_0_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[0]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[0]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_0_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[0]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[0]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[0] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[0];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[0] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[0] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[0];
    end
    else
    begin : dlane_csr_0_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : dlane_csr_1_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_1_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[1]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[1]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_1_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[1]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[1]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[1] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[1];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[1] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[1] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[1];
    end
    else
    begin : dlane_csr_1_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : dlane_csr_2_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_2_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[2]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[2]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_2_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[2]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[2]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[2] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[2];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[2] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[2] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[2];
    end
    else
    begin : dlane_csr_2_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : dlane_csr_3_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_3_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[3]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[3]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_3_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[3]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[3]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[3] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[3];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[3] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[3] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[3];
    end
    else
    begin : dlane_csr_3_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : dlane_csr_4_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_4_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[4]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[4]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_4_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[4]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[4]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[4] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[4];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[4] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[4] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[4];
    end
    else
    begin : dlane_csr_4_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : dlane_csr_5_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_5_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[5]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[5]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_5_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[5]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[5]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[5] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[5];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[5] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[5] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[5];
    end
    else
    begin : dlane_csr_5_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : dlane_csr_6_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_6_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[6]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[6]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_6_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[6]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[6]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[6] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[6];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[6] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[6] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[6];
    end
    else
    begin : dlane_csr_6_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : dlane_csr_7_rx_deskew_update_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_dlane_csr_7_rx_deskew_update_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[7]), .dout(clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[7]));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_dlane_csr_7_rx_deskew_update_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog[7]), .dout(sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[7]));
        always @(posedge fr_clk) clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[7] <= sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[7];
        assign sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[7] = clr_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[7] ^ sig_DLANE_CSR_RX_DESKEW_UPDATE_tog_cdc[7];
    end
    else
    begin : dlane_csr_7_rx_deskew_update_stub
        assign clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : set_rx_dlane_err_0_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_0_sot_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[0]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[0]));
    end
    else
    begin : set_rx_dlane_err_0_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : set_rx_dlane_err_0_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_0_sot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[0]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[0]));
    end
    else
    begin : set_rx_dlane_err_0_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : set_rx_dlane_err_0_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_0_eot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[0]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[0]));
    end
    else
    begin : set_rx_dlane_err_0_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : set_rx_dlane_err_0_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_0_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[0]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[0]));
    end
    else
    begin : set_rx_dlane_err_0_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : set_rx_dlane_err_0_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_0_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[0]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[0]));
    end
    else
    begin : set_rx_dlane_err_0_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : set_rx_dlane_err_0_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_0_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[0]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[0]));
    end
    else
    begin : set_rx_dlane_err_0_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 0)
    begin : set_rx_dlane_err_0_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_0_cal_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[0]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[0]));
    end
    else
    begin : set_rx_dlane_err_0_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[0] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : set_rx_dlane_err_1_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_1_sot_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[1]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[1]));
    end
    else
    begin : set_rx_dlane_err_1_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : set_rx_dlane_err_1_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_1_sot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[1]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[1]));
    end
    else
    begin : set_rx_dlane_err_1_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : set_rx_dlane_err_1_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_1_eot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[1]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[1]));
    end
    else
    begin : set_rx_dlane_err_1_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : set_rx_dlane_err_1_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_1_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[1]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[1]));
    end
    else
    begin : set_rx_dlane_err_1_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : set_rx_dlane_err_1_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_1_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[1]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[1]));
    end
    else
    begin : set_rx_dlane_err_1_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : set_rx_dlane_err_1_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_1_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[1]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[1]));
    end
    else
    begin : set_rx_dlane_err_1_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 1)
    begin : set_rx_dlane_err_1_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_1_cal_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[1]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[1]));
    end
    else
    begin : set_rx_dlane_err_1_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[1] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : set_rx_dlane_err_2_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_2_sot_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[2]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[2]));
    end
    else
    begin : set_rx_dlane_err_2_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : set_rx_dlane_err_2_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_2_sot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[2]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[2]));
    end
    else
    begin : set_rx_dlane_err_2_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : set_rx_dlane_err_2_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_2_eot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[2]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[2]));
    end
    else
    begin : set_rx_dlane_err_2_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : set_rx_dlane_err_2_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_2_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[2]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[2]));
    end
    else
    begin : set_rx_dlane_err_2_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : set_rx_dlane_err_2_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_2_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[2]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[2]));
    end
    else
    begin : set_rx_dlane_err_2_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : set_rx_dlane_err_2_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_2_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[2]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[2]));
    end
    else
    begin : set_rx_dlane_err_2_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 2)
    begin : set_rx_dlane_err_2_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_2_cal_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[2]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[2]));
    end
    else
    begin : set_rx_dlane_err_2_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[2] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : set_rx_dlane_err_3_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_3_sot_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[3]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[3]));
    end
    else
    begin : set_rx_dlane_err_3_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : set_rx_dlane_err_3_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_3_sot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[3]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[3]));
    end
    else
    begin : set_rx_dlane_err_3_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : set_rx_dlane_err_3_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_3_eot_sync_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[3]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[3]));
    end
    else
    begin : set_rx_dlane_err_3_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : set_rx_dlane_err_3_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_3_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[3]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[3]));
    end
    else
    begin : set_rx_dlane_err_3_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : set_rx_dlane_err_3_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_3_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[3]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[3]));
    end
    else
    begin : set_rx_dlane_err_3_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : set_rx_dlane_err_3_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_3_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[3]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[3]));
    end
    else
    begin : set_rx_dlane_err_3_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 3)
    begin : set_rx_dlane_err_3_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_3_cal_err_cdc (.clk_src(rx_clk[0]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk0), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[3]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[3]));
    end
    else
    begin : set_rx_dlane_err_3_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[3] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : set_rx_dlane_err_4_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_4_sot_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[4]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[4]));
    end
    else
    begin : set_rx_dlane_err_4_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : set_rx_dlane_err_4_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_4_sot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[4]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[4]));
    end
    else
    begin : set_rx_dlane_err_4_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : set_rx_dlane_err_4_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_4_eot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[4]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[4]));
    end
    else
    begin : set_rx_dlane_err_4_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : set_rx_dlane_err_4_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_4_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[4]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[4]));
    end
    else
    begin : set_rx_dlane_err_4_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : set_rx_dlane_err_4_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_4_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[4]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[4]));
    end
    else
    begin : set_rx_dlane_err_4_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : set_rx_dlane_err_4_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_4_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[4]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[4]));
    end
    else
    begin : set_rx_dlane_err_4_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 4)
    begin : set_rx_dlane_err_4_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_4_cal_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[4]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[4]));
    end
    else
    begin : set_rx_dlane_err_4_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[4] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : set_rx_dlane_err_5_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_5_sot_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[5]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[5]));
    end
    else
    begin : set_rx_dlane_err_5_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : set_rx_dlane_err_5_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_5_sot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[5]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[5]));
    end
    else
    begin : set_rx_dlane_err_5_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : set_rx_dlane_err_5_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_5_eot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[5]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[5]));
    end
    else
    begin : set_rx_dlane_err_5_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : set_rx_dlane_err_5_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_5_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[5]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[5]));
    end
    else
    begin : set_rx_dlane_err_5_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : set_rx_dlane_err_5_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_5_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[5]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[5]));
    end
    else
    begin : set_rx_dlane_err_5_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : set_rx_dlane_err_5_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_5_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[5]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[5]));
    end
    else
    begin : set_rx_dlane_err_5_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 5)
    begin : set_rx_dlane_err_5_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_5_cal_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[5]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[5]));
    end
    else
    begin : set_rx_dlane_err_5_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[5] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : set_rx_dlane_err_6_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_6_sot_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[6]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[6]));
    end
    else
    begin : set_rx_dlane_err_6_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : set_rx_dlane_err_6_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_6_sot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[6]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[6]));
    end
    else
    begin : set_rx_dlane_err_6_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : set_rx_dlane_err_6_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_6_eot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[6]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[6]));
    end
    else
    begin : set_rx_dlane_err_6_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : set_rx_dlane_err_6_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_6_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[6]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[6]));
    end
    else
    begin : set_rx_dlane_err_6_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : set_rx_dlane_err_6_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_6_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[6]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[6]));
    end
    else
    begin : set_rx_dlane_err_6_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : set_rx_dlane_err_6_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_6_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[6]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[6]));
    end
    else
    begin : set_rx_dlane_err_6_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 6)
    begin : set_rx_dlane_err_6_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_6_cal_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[6]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[6]));
    end
    else
    begin : set_rx_dlane_err_6_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[6] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : set_rx_dlane_err_7_sot_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_7_sot_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse[7]), .out_pulse(set_RX_DLANE_ERR_SOT_ERR_pulse_int[7]));
    end
    else
    begin : set_rx_dlane_err_7_sot_err_stub
        assign set_RX_DLANE_ERR_SOT_ERR_pulse_int[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : set_rx_dlane_err_7_sot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_7_sot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[7]), .out_pulse(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[7]));
    end
    else
    begin : set_rx_dlane_err_7_sot_sync_err_stub
        assign set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse_int[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : set_rx_dlane_err_7_eot_sync_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_7_eot_sync_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[7]), .out_pulse(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[7]));
    end
    else
    begin : set_rx_dlane_err_7_eot_sync_err_stub
        assign set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse_int[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : set_rx_dlane_err_7_esc_entry_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_7_esc_entry_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[7]), .out_pulse(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[7]));
    end
    else
    begin : set_rx_dlane_err_7_esc_entry_err_stub
        assign set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse_int[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : set_rx_dlane_err_7_lpdt_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_7_lpdt_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse[7]), .out_pulse(set_RX_DLANE_ERR_LPDT_ERR_pulse_int[7]));
    end
    else
    begin : set_rx_dlane_err_7_lpdt_err_stub
        assign set_RX_DLANE_ERR_LPDT_ERR_pulse_int[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : set_rx_dlane_err_7_ctrl_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_7_ctrl_err_cdc (.clk_src(fr_clk), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_frclk), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse[7]), .out_pulse(set_RX_DLANE_ERR_CTRL_ERR_pulse_int[7]));
    end
    else
    begin : set_rx_dlane_err_7_ctrl_err_stub
        assign set_RX_DLANE_ERR_CTRL_ERR_pulse_int[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1 && NUM_LANES > 7)
    begin : set_rx_dlane_err_7_cal_err_tsync
        toggle_synchronizer_2 #(.depth(3), .rst_value(0)) set_rx_dlane_err_7_cal_err_cdc (.clk_src(rx_clk[1]), .clk_dst(reg_clk), .reset_n_src(arst_regsrst_rxclk1), .reset_n_dst(reg_srst_n), .in_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse[7]), .out_pulse(set_RX_DLANE_ERR_CAL_ERR_pulse_int[7]));
    end
    else
    begin : set_rx_dlane_err_7_cal_err_stub
        assign set_RX_DLANE_ERR_CAL_ERR_pulse_int[7] = 1'b0;
    end

    if(DPHY_RX_EN == 1)
    begin : rx_cal_reg_ctrl_cal_reset_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_rx_cal_reg_ctrl_cal_reset_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc), .dout(clr_RX_CAL_REG_CTRL_CAL_RESET_tog));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_rx_cal_reg_ctrl_cal_reset_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_RX_CAL_REG_CTRL_CAL_RESET_tog), .dout(sig_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc));
        always @(posedge fr_clk) clr_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc <= sig_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc;
        assign sig_RX_CAL_REG_CTRL_CAL_RESET_pulse = clr_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc ^ sig_RX_CAL_REG_CTRL_CAL_RESET_tog_cdc;
    end
    else
    begin : rx_cal_reg_ctrl_cal_reset_stub
        assign clr_RX_CAL_REG_CTRL_CAL_RESET_tog = 1'b0;
        assign sig_RX_CAL_REG_CTRL_CAL_RESET_pulse = 1'b0;
    end

    if(DPHY_RX_EN == 1)
    begin : rx_tm_control_rx_tst_cnt_rst_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_rx_tm_control_rx_tst_cnt_rst_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc), .dout(clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_rx_tm_control_rx_tst_cnt_rst_cdc (.clk(fr_clk), .reset_n(arst_regsrst_frclk), .din(sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog), .dout(sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc));
        always @(posedge fr_clk) clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc <= sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc;
        assign sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse = clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc ^ sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog_cdc;
    end
    else
    begin : rx_tm_control_rx_tst_cnt_rst_stub
        assign clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog = 1'b0;
        assign sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse = 1'b0;
    end

    if(DPHY_TX_EN == 1)
    begin : tx_tm_control_tx_tst_cnt_rst_sync
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) clr_tx_tm_control_tx_tst_cnt_rst_cdc (.clk(reg_clk), .reset_n(reg_srst_n), .din(clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc), .dout(clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog));
        altera_std_synchronizer_nocut#(.depth(3), .rst_value(0)) sig_tx_tm_control_tx_tst_cnt_rst_cdc (.clk(tx_clk), .reset_n(arst_regsrst_txclk), .din(sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog), .dout(sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc));
        always @(posedge tx_clk) clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc <= sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc;
        assign sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse = clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc ^ sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog_cdc;
    end
    else
    begin : tx_tm_control_tx_tst_cnt_rst_stub
        assign clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog = 1'b0;
        assign sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse = 1'b0;
    end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oIp6onc3+93BqZDq9AGfB5QW4DvQJaMH9CMqE9mYY2c4qgp8/RmKEN5niZ/cp6JJJSZX6DKSVMHLnAEx+jAat9cmqHMaB2gxlGCQmhGhEHCUGYOwpxew7DUyViT9DaqOvmPXr1xzai4dYMTsREbWRl7MJkOH8tbuppZVj9PbFNewwkm6OhRdNwuA9gzIf7Xy/sQlPl0RQFzOjWNKk41n6ZBJRRvden0b9ze29ZqClaMyAUArnG4ncXIVL6LTmLN/9onNFq1d3QgL5vRdfw/KE/DsYWev/wQZawImmiokAMxMUkkjKbNHynP77GFhraRfdHA3wik8joRJ6DppvoxFVpYr1+BVujVV19G9Fa0/UcChEMemDGYHvVV9vkml6w6WqBaUBbRxsLgpT5qMdcqaoVruBgUIAjabc5M+ZxgqutG5rIFHqIn0MmQd2pJ9vG2tSZkO3Zg/7BmDvHEOaOl5//UKnz9DMAPnrecoZERRg+Qzp2EqN9g6ifmqxEfEIHCkTUJtEa2i+qnyzNE8oQU2bY/aoup13kNObFoONKVHdmX075M7pay2WN89gt3iNGKShZ+6J8hYr7+MkRg41osA4r3D4Xk+ki1Jhgw4k749ZXvMXhcp3iRtUsVKvXO6Zz65DYoigLfGHWKqxvojmLJgJJ1848gFCZ8LkmYPS0xKMlnYLjn58ExTtFJVw10Xg5HyPwHRMAcE2CjRQy3ncEkVWQjsRS/96+UeyBxswnNqErIRw71j4OK5sd22vrgS3QjJISJ7dx08aluoLWOAOqKKml9"
`endif