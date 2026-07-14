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
module dphy_regfile #(

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
    parameter PRBS_INIT_0_D = 8'hFF,                                      
    parameter PRBS_INIT_0_RW = 0,                                         
    parameter PRBS_INIT_1_D = 8'hFF,                                      
    parameter PRBS_INIT_1_RW = 0,                                         
    parameter PRBS_INIT_2_D = 8'hFF,                                      
    parameter PRBS_INIT_2_RW = 0,                                         
    parameter PRBS_INIT_3_D = 8'hFF,                                      
    parameter PRBS_INIT_3_RW = 0,                                         
    parameter PRBS_INIT_4_D = 8'hFF,                                      
    parameter PRBS_INIT_4_RW = 0,                                         
    parameter PRBS_INIT_5_D = 8'hFF,                                      
    parameter PRBS_INIT_5_RW = 0,                                         
    parameter PRBS_INIT_6_D = 8'hFF,                                      
    parameter PRBS_INIT_6_RW = 0,                                         
    parameter PRBS_INIT_7_D = 8'hFF,                                      
    parameter PRBS_INIT_7_RW = 0,                                         
    parameter RX_DLANE_DESKEW_DELAY_0_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_0_RW = 0,                             
    parameter RX_DLANE_DESKEW_DELAY_1_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_1_RW = 0,                             
    parameter RX_DLANE_DESKEW_DELAY_2_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_2_RW = 0,                             
    parameter RX_DLANE_DESKEW_DELAY_3_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_3_RW = 0,                             
    parameter RX_DLANE_DESKEW_DELAY_4_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_4_RW = 0,                             
    parameter RX_DLANE_DESKEW_DELAY_5_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_5_RW = 0,                             
    parameter RX_DLANE_DESKEW_DELAY_6_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_6_RW = 0,                             
    parameter RX_DLANE_DESKEW_DELAY_7_D = 7'h0,                           
    parameter RX_DLANE_DESKEW_DELAY_7_RW = 0,                             
    parameter RX_CLK_LOSS_DETECT_D =  0,                                  
    parameter RX_CLK_LOSS_DETECT_USE_AUTO =  0,                           
    parameter RX_CLK_LOSS_DETECT_RW = 0,                                  
    parameter RX_CAP_EQ_MODE_D = 0,                                       
    parameter RX_CLK_SETTLE_D =  0,                                       
    parameter RX_CLK_SETTLE_USE_AUTO =  0,                                
    parameter RX_CLK_SETTLE_RW = 0,                                       
    parameter RX_HS_SETTLE_D =  0,                                        
    parameter RX_HS_SETTLE_USE_AUTO =  0,                                 
    parameter RX_HS_SETTLE_RW = 0,                                        
    parameter RX_INIT_D =  0,                                             
    parameter RX_INIT_USE_AUTO =  0,                                      
    parameter RX_INIT_RW = 0,                                             
    parameter RX_CLK_POST_D =  0,                                         
    parameter RX_CLK_POST_USE_AUTO =  0,                                  
    parameter RX_CLK_POST_RW = 0,                                         
    parameter RX_TM_CONTROL_RX_TM_EN_D = 1'b0,                            
    parameter RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_D = 1'b0,                 
    parameter RX_PREP_TIME_TM_D = 128,                                    
    parameter RX_PREP_TIME_TM_RW = 0,                                     
    parameter TX_CAP_EQ_MODE_D = 0,                                       
    parameter TX_PREAMBLE_LEN_PREAMLBE_LEN_D = 4'h0,                      
    parameter TX_CLK_LANE_PS_D = 32,                                      
    parameter TX_LPX_D =  0,                                              
    parameter TX_LPX_USE_AUTO =  0,                                       
    parameter TX_LPX_RW = 0,                                              
    parameter TX_HS_EXIT_D =  0,                                          
    parameter TX_HS_EXIT_USE_AUTO =  0,                                   
    parameter TX_HS_EXIT_RW = 0,                                          
    parameter TX_LP_EXIT_D =  0,                                          
    parameter TX_LP_EXIT_USE_AUTO =  0,                                   
    parameter TX_LP_EXIT_RW = 0,                                          
    parameter TX_CLK_PREPARE_D =  0,                                      
    parameter TX_CLK_PREPARE_USE_AUTO =  0,                               
    parameter TX_CLK_PREPARE_RW = 0,                                      
    parameter TX_CLK_TRAIL_D =  0,                                        
    parameter TX_CLK_TRAIL_USE_AUTO =  0,                                 
    parameter TX_CLK_TRAIL_RW = 0,                                        
    parameter TX_CLK_ZERO_D =  0,                                         
    parameter TX_CLK_ZERO_USE_AUTO =  0,                                  
    parameter TX_CLK_ZERO_RW = 0,                                         
    parameter TX_CLK_POST_D =  0,                                         
    parameter TX_CLK_POST_USE_AUTO =  0,                                  
    parameter TX_CLK_POST_RW = 0,                                         
    parameter TX_CLK_PRE_D =  0,                                          
    parameter TX_CLK_PRE_USE_AUTO =  0,                                   
    parameter TX_CLK_PRE_RW = 0,                                          
    parameter TX_HS_PREPARE_D =  0,                                       
    parameter TX_HS_PREPARE_USE_AUTO =  0,                                
    parameter TX_HS_PREPARE_RW = 0,                                       
    parameter TX_HS_ZERO_D =  0,                                          
    parameter TX_HS_ZERO_USE_AUTO =  0,                                   
    parameter TX_HS_ZERO_RW = 0,                                          
    parameter TX_HS_TRAIL_D =  0,                                         
    parameter TX_HS_TRAIL_USE_AUTO =  0,                                  
    parameter TX_HS_TRAIL_RW = 0,                                         
    parameter TX_INIT_D =  0,                                             
    parameter TX_INIT_USE_AUTO =  0,                                      
    parameter TX_INIT_RW = 0,                                             
    parameter TX_WAKE_D =  0,                                             
    parameter TX_WAKE_USE_AUTO =  0,                                      
    parameter TX_WAKE_RW = 0,                                             
    parameter TX_TM_CONTROL_TX_TM_EN_D = 1'b0,                            
    parameter TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_D = 1'b0,                 
    parameter TX_HS_TM_DESKEW_P_D = 128,                                  
    parameter TX_HS_TM_DESKEW_P_RW = 0                                    

    ) (
    input [IP_ID_W-1:0] sig_IP_ID,
    output logic sig_DPHY_CSR_Enable,
    input sig_DPHY_CSR_PLL_LOCK,
    output logic sig_CLK_CSR_CLK_LANE_EN,
    input sig_CLK_STATUS_INIT_DONE,
    output logic [NUM_LANES-1:0] sig_DLANE_CSR_EN,          
    input [7:0] clr_DLANE_CSR_RX_DESKEW_UPDATE_tog,         
    output logic [7:0] sig_DLANE_CSR_RX_DESKEW_UPDATE_tog,  
    output logic [NUM_LANES-1:0] sig_DLANE_CSR_RX_MNL_DESKEW_EN,
    input [NUM_LANES-1:0] sig_DLANE_STATUS_INIT_DONE,       
    output logic [PRBS_INIT_0_W-1:0] sig_PRBS_INIT_0,
    output logic [PRBS_INIT_1_W-1:0] sig_PRBS_INIT_1,
    output logic [PRBS_INIT_2_W-1:0] sig_PRBS_INIT_2,
    output logic [PRBS_INIT_3_W-1:0] sig_PRBS_INIT_3,
    output logic [PRBS_INIT_4_W-1:0] sig_PRBS_INIT_4,
    output logic [PRBS_INIT_5_W-1:0] sig_PRBS_INIT_5,
    output logic [PRBS_INIT_6_W-1:0] sig_PRBS_INIT_6,
    output logic [PRBS_INIT_7_W-1:0] sig_PRBS_INIT_7,
    output logic [RX_DLANE_DESKEW_DELAY_0_W-1:0] sig_RX_DLANE_DESKEW_DELAY_0,
    input [7:0] set_RX_DLANE_ERR_SOT_ERR_pulse,             
    input [7:0] set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse,        
    input [7:0] set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse,        
    input [7:0] set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse,       
    input [7:0] set_RX_DLANE_ERR_LPDT_ERR_pulse,            
    input [7:0] set_RX_DLANE_ERR_CTRL_ERR_pulse,            
    input [7:0] set_RX_DLANE_ERR_CAL_ERR_pulse,             
    output logic [RX_DLANE_DESKEW_DELAY_1_W-1:0] sig_RX_DLANE_DESKEW_DELAY_1,
    output logic [RX_DLANE_DESKEW_DELAY_2_W-1:0] sig_RX_DLANE_DESKEW_DELAY_2,
    output logic [RX_DLANE_DESKEW_DELAY_3_W-1:0] sig_RX_DLANE_DESKEW_DELAY_3,
    output logic [RX_DLANE_DESKEW_DELAY_4_W-1:0] sig_RX_DLANE_DESKEW_DELAY_4,
    output logic [RX_DLANE_DESKEW_DELAY_5_W-1:0] sig_RX_DLANE_DESKEW_DELAY_5,
    output logic [RX_DLANE_DESKEW_DELAY_6_W-1:0] sig_RX_DLANE_DESKEW_DELAY_6,
    output logic [RX_DLANE_DESKEW_DELAY_7_W-1:0] sig_RX_DLANE_DESKEW_DELAY_7,
    output logic [RX_CLK_LOSS_DETECT_W-1:0] sig_RX_CLK_LOSS_DETECT,
    output logic [RX_CLK_SETTLE_W-1:0] sig_RX_CLK_SETTLE,
    output logic [RX_HS_SETTLE_W-1:0] sig_RX_HS_SETTLE,
    output logic [RX_INIT_W-1:0] sig_RX_INIT,
    output logic [RX_CLK_POST_W-1:0] sig_RX_CLK_POST,
    output logic [RX_CAL_REG_CTRL_CAL_REG_MUXSEL_W-1:0] sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL,
    input clr_RX_CAL_REG_CTRL_CAL_RESET_tog,
    output logic sig_RX_CAL_REG_CTRL_CAL_RESET_tog,
    input sig_RX_CAL_STATUS_DPHY_SKEW_CAL_DONE,
    input sig_RX_CAL_STATUS_DPHY_ALT_CAL_DONE,
    input sig_RX_CAL_STATUS_DPHY_INIT_SKEW_CAL_ERR,
    input sig_RX_CAL_STATUS_DPHY_PER_SKEW_CAL_ERR,
    input sig_RX_CAL_STATUS_DPHY_ALT_CAL_ERR,
    input [RX_CAL_SKEW_W_START_MUX_W-1:0] sig_RX_CAL_SKEW_W_START_MUX,
    input [RX_CAL_SKEW_W_END_MUX_W-1:0] sig_RX_CAL_SKEW_W_END_MUX,
    input [RX_CAL_ALT_W_START_MUX_W-1:0] sig_RX_CAL_ALT_W_START_MUX,
    input [RX_CAL_ALT_W_END_MUX_W-1:0] sig_RX_CAL_ALT_W_END_MUX,
    input [RX_DESKEW_DELAY_MUX_W-1:0] sig_RX_DESKEW_DELAY_MUX,
    input sig_RX_CAL_STATUS_LANE_MUX_SKEW_CAL_DONE_LANE,
    input sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_DONE_LANE,
    input sig_RX_CAL_STATUS_LANE_MUX_INIT_SKEW_CAL_ERR_LANE,
    input sig_RX_CAL_STATUS_LANE_MUX_PER_SKEW_CAL_ERR_LANE,
    input sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_ERR_LANE,
    output logic sig_RX_TM_CONTROL_RX_TM_EN,
    output logic sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE,
    input clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog,
    output logic sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog,
    output logic [RX_PREP_TIME_TM_W-1:0] sig_RX_PREP_TIME_TM,
    input [RX_BER_CNT_B0_MUX_W-1:0] sig_RX_BER_CNT_B0_MUX,
    input [RX_BER_CNT_B1_MUX_W-1:0] sig_RX_BER_CNT_B1_MUX,
    input [RX_BER_CNT_B2_MUX_W-1:0] sig_RX_BER_CNT_B2_MUX,
    input [RX_BER_CNT_B3_MUX_W-1:0] sig_RX_BER_CNT_B3_MUX,
    output logic sig_TX_PREAMBLE_LEN_PREAMBLE_EN,
    output logic [TX_PREAMBLE_LEN_PREAMLBE_LEN_W-1:0] sig_TX_PREAMBLE_LEN_PREAMLBE_LEN,
    output logic [TX_CLK_LANE_PS_W-1:0] sig_TX_CLK_LANE_PS,
    output logic [TX_LPX_W-1:0] sig_TX_LPX,
    output logic [TX_HS_EXIT_W-1:0] sig_TX_HS_EXIT,
    output logic [TX_LP_EXIT_W-1:0] sig_TX_LP_EXIT,
    output logic [TX_CLK_PREPARE_W-1:0] sig_TX_CLK_PREPARE,
    output logic [TX_CLK_TRAIL_W-1:0] sig_TX_CLK_TRAIL,
    output logic [TX_CLK_ZERO_W-1:0] sig_TX_CLK_ZERO,
    output logic [TX_CLK_POST_W-1:0] sig_TX_CLK_POST,
    output logic [TX_CLK_PRE_W-1:0] sig_TX_CLK_PRE,
    output logic [TX_HS_PREPARE_W-1:0] sig_TX_HS_PREPARE,
    output logic [TX_HS_ZERO_W-1:0] sig_TX_HS_ZERO,
    output logic [TX_HS_TRAIL_W-1:0] sig_TX_HS_TRAIL,
    output logic [TX_INIT_W-1:0] sig_TX_INIT,
    output logic [TX_WAKE_W-1:0] sig_TX_WAKE,
    output logic sig_TX_TM_CONTROL_TX_TM_EN,
    output logic sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE,
    input clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog,
    output logic sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog,
    output logic [TX_HS_TM_DESKEW_P_W-1:0] sig_TX_HS_TM_DESKEW_P,
    output logic sig_TX_MNL_IO_0_CTRL_EN,
    output logic sig_TX_MNL_IO_0_CLK_LP_EN,
    output logic [TX_MNL_IO_0_LP_DAT_W-1:0] sig_TX_MNL_IO_0_LP_DAT,
    output logic [TX_MNL_IO_0_HS_DAT_D_W-1:0] sig_TX_MNL_IO_0_HS_DAT_D,
    output logic [TX_MNL_IO_0_HS_DAT_CK_W-1:0] sig_TX_MNL_IO_0_HS_DAT_CK,
    output logic [TX_MNL_D_LP_EN_W-1:0] sig_TX_MNL_D_LP_EN,
    input [TX_WORD_COUNT_B0_MUX_W-1:0] sig_TX_WORD_COUNT_B0_MUX,
    input [TX_WORD_COUNT_B1_MUX_W-1:0] sig_TX_WORD_COUNT_B1_MUX,
    input [TX_WORD_COUNT_B2_MUX_W-1:0] sig_TX_WORD_COUNT_B2_MUX,
    input [TX_WORD_COUNT_B3_MUX_W-1:0] sig_TX_WORD_COUNT_B3_MUX,
    input clk,
    input srst_n,
    input wr_en,
    input [3:0] be,
    input rd_en,
    input [7:0] waddr,
    input [7:0] raddr,
    input [31:0] din,
    output logic [31:0] dout
    );
    localparam TIME_DIV = TIME_UNIT == "ns" ? 1 : TIME_UNIT == "ps" ? 1000 : 1000000;
    localparam unsigned RX_CORE_FREQ = BIT_RATE / PPI_WIDTH      ;
    localparam unsigned TX_CORE_FREQ = (BIT_RATE * TX_VCO_FREQ_MULT )/ PPI_WIDTH;
    localparam unsigned RX_FR_CLK_PER = 1000000000 * TIME_DIV/RX_FR_CLK_FREQ;
    localparam unsigned TX_CORE_PER = 1000000000* TIME_DIV/TX_CORE_FREQ;
    localparam unsigned RX_CORE_PER = 1000000000* TIME_DIV/RX_CORE_FREQ;
    localparam unsigned UI = 1000000000* TIME_DIV/BIT_RATE       ;
    localparam unsigned RX_FR_CLK_PER_1K = RX_FR_CLK_PER * 1024  ;
    localparam unsigned TX_CORE_PER_1K = TX_CORE_PER * 1024      ;
    localparam unsigned RX_CORE_PER_1K = RX_CORE_PER  * 1024     ;
    localparam RXFIFO_LAT = PPI_WIDTH == 16 ? IO_RX_PIPE_DEPTH_16 : IO_RX_PIPE_DEPTH_8;
    localparam TXFIFO_LAT = PPI_WIDTH == 16 ? IO_TX_PIPE_DEPTH_16 : IO_TX_PIPE_DEPTH_8;
    localparam IP_CAP_ROLE_D = DPHY_TX_EN;
    localparam IP_CAP_PPI_WIDTH_D = PPI_WIDTH == 8 ? 2'b00 : 2'b01;
    localparam IP_CAP_NLANES_D = $clog2(NUM_LANES);
    localparam SKEW_CAL_LEN_B0_D = SKEW_CAL_LEN[7:0];
    localparam SKEW_CAL_LEN_B1_D = SKEW_CAL_LEN[15:8];
    localparam SKEW_CAL_LEN_B2_D = SKEW_CAL_LEN[23:16];
    localparam SKEW_CAL_LEN_B3_D = SKEW_CAL_LEN[31:24];
    localparam ALT_CAL_LEN_B0_D = ALT_CAL_LEN[7:0];
    localparam ALT_CAL_LEN_B1_D = ALT_CAL_LEN[15:8];
    localparam ALT_CAL_LEN_B2_D = ALT_CAL_LEN[23:16];
    localparam ALT_CAL_LEN_B3_D = ALT_CAL_LEN[31:24];
    localparam DLANE_CSR_0_EN_D = NUM_LANES > 0 ? 1'b1 : 1'b0;
    localparam DLANE_CSR_1_EN_D = NUM_LANES > 1 ? 1'b1 : 1'b0;
    localparam DLANE_CSR_2_EN_D = NUM_LANES > 2 ? 1'b1 : 1'b0;
    localparam DLANE_CSR_3_EN_D = NUM_LANES > 3 ? 1'b1 : 1'b0;
    localparam DLANE_CSR_4_EN_D = NUM_LANES > 4 ? 1'b1 : 1'b0;
    localparam DLANE_CSR_5_EN_D = NUM_LANES > 5 ? 1'b1 : 1'b0;
    localparam DLANE_CSR_6_EN_D = NUM_LANES > 6 ? 1'b1 : 1'b0;
    localparam DLANE_CSR_7_EN_D = NUM_LANES > 7 ? 1'b1 : 1'b0;
    localparam RX_CAP_SKEW_CAL_D = 
            DPHY_RX_EN == 1 ? SKEW_CAL_EN : 1'b0;
    localparam RX_CAP_ALT_CAL_D = 
            DPHY_RX_EN == 1 ? ALT_CAL_EN : 1'b0;
    localparam RX_CAP_PREAMBLE_D = 
            DPHY_RX_EN == 1 ? PREAMBLE_EN : 1'b0;
    localparam RX_CAP_PERIODIC_SKEW_CAL_D = 
            DPHY_RX_EN == 1 ? PER_SKEW_CAL_EN : 1'b0;
    localparam TX_CAP_SKEW_CAL_D = 
            DPHY_RX_EN == 1 ? 1'b0 : SKEW_CAL_EN;
    localparam TX_CAP_ALT_CAL_D = 
            DPHY_RX_EN == 1 ? 1'b0 : ALT_CAL_EN;
    localparam TX_CAP_PREAMBLE_D = 
            DPHY_RX_EN == 1 ? 1'b0 : PREAMBLE_EN;
    localparam TX_PREAMBLE_LEN_PREAMBLE_EN_D = 
            DPHY_RX_EN == 1 ? 1'b0 : PREAMBLE_EN;
    localparam [RX_CLK_LOSS_DETECT_W-1:0] RX_CLK_LOSS_DETECT_MIN = ($ceil((2.0*RX_CORE_PER)/RX_FR_CLK_PER) < 0) ? 0 : ($ceil((2.0*RX_CORE_PER)/RX_FR_CLK_PER) > 255) ? 255 : $ceil((2.0*RX_CORE_PER)/RX_FR_CLK_PER);
    localparam [RX_CLK_LOSS_DETECT_W-1:0] RX_CLK_LOSS_DETECT_MAX = ($floor((4.0*RX_CORE_PER)/RX_FR_CLK_PER) < 0) ? 0 : ($floor((4.0*RX_CORE_PER)/RX_FR_CLK_PER) > 255) ? 255 : $floor((4.0*RX_CORE_PER)/RX_FR_CLK_PER);
    localparam [RX_CLK_LOSS_DETECT_W-1:0] RX_CLK_LOSS_DETECT_MID = RX_CLK_LOSS_DETECT_MAX / 2 + RX_CLK_LOSS_DETECT_MIN / 2;
    localparam [RX_CLK_LOSS_DETECT_W-1:0] RX_CLK_LOSS_DETECT_AUTO = RX_CLK_LOSS_DETECT_USE_AUTO == 1 ? ( RX_CLK_LOSS_DETECT_MIN ) :
            RX_CLK_LOSS_DETECT_USE_AUTO == 3 ? ( RX_CLK_LOSS_DETECT_MAX ) : RX_CLK_LOSS_DETECT_MID;
    localparam [RX_CLK_SETTLE_W-1:0] RX_CLK_SETTLE_MIN = ($ceil((95.0*TIME_DIV - 2.0*RX_CORE_PER)/RX_FR_CLK_PER - 6.0) < 0) ? 0 : ($ceil((95.0*TIME_DIV - 2.0*RX_CORE_PER)/RX_FR_CLK_PER - 6.0) > 255) ? 255 : $ceil((95.0*TIME_DIV - 2.0*RX_CORE_PER)/RX_FR_CLK_PER - 6.0);
    localparam [RX_CLK_SETTLE_W-1:0] RX_CLK_SETTLE_MAX = ($floor((300.0*TIME_DIV- 2.0*RX_CORE_PER)/RX_FR_CLK_PER - 6.0) < 0) ? 0 : ($floor((300.0*TIME_DIV- 2.0*RX_CORE_PER)/RX_FR_CLK_PER - 6.0) > 255) ? 255 : $floor((300.0*TIME_DIV- 2.0*RX_CORE_PER)/RX_FR_CLK_PER - 6.0);
    localparam [RX_CLK_SETTLE_W-1:0] RX_CLK_SETTLE_MID = RX_CLK_SETTLE_MAX / 2 + RX_CLK_SETTLE_MIN / 2;
    localparam [RX_CLK_SETTLE_W-1:0] RX_CLK_SETTLE_AUTO = RX_CLK_SETTLE_USE_AUTO == 1 ? ( RX_CLK_SETTLE_MIN ) :
            RX_CLK_SETTLE_USE_AUTO == 3 ? ( RX_CLK_SETTLE_MAX ) : RX_CLK_SETTLE_MID;
    localparam [RX_HS_SETTLE_W-1:0] RX_HS_SETTLE_MIN = ($ceil((85.0 * TIME_DIV + 6.0 * UI -  RX_CORE_PER) / RX_FR_CLK_PER - 7.0) < 0) ? 0 : ($ceil((85.0 * TIME_DIV + 6.0 * UI -  RX_CORE_PER) / RX_FR_CLK_PER - 7.0) > 255) ? 255 : $ceil((85.0 * TIME_DIV + 6.0 * UI -  RX_CORE_PER) / RX_FR_CLK_PER - 7.0);
    localparam [RX_HS_SETTLE_W-1:0] RX_HS_SETTLE_MAX = ($floor((145.0 * TIME_DIV + 10.0 * UI - RX_CORE_PER) / RX_FR_CLK_PER - 7.0) < 0) ? 0 : ($floor((145.0 * TIME_DIV + 10.0 * UI - RX_CORE_PER) / RX_FR_CLK_PER - 7.0) > 255) ? 255 : $floor((145.0 * TIME_DIV + 10.0 * UI - RX_CORE_PER) / RX_FR_CLK_PER - 7.0);
    localparam [RX_HS_SETTLE_W-1:0] RX_HS_SETTLE_MID = RX_HS_SETTLE_MAX / 2 + RX_HS_SETTLE_MIN / 2;
    localparam [RX_HS_SETTLE_W-1:0] RX_HS_SETTLE_AUTO = RX_HS_SETTLE_USE_AUTO == 1 ? ( RX_HS_SETTLE_MIN ) :
            RX_HS_SETTLE_USE_AUTO == 3 ? ( RX_HS_SETTLE_MAX ) : RX_HS_SETTLE_MID;
    localparam [RX_INIT_W-1:0] RX_INIT_MIN = ($ceil(100000.0*TIME_DIV/RX_FR_CLK_PER_1K) < 0) ? 0 : ($ceil(100000.0*TIME_DIV/RX_FR_CLK_PER_1K) > 255) ? 255 : $ceil(100000.0*TIME_DIV/RX_FR_CLK_PER_1K);
    localparam [RX_INIT_W-1:0] RX_INIT_MAX = ((RX_INIT_MIN * 2.0) > 255) ? 255 : (RX_INIT_MIN * 2.0);
    localparam [RX_INIT_W-1:0] RX_INIT_MID = RX_INIT_MAX / 2 + RX_INIT_MIN / 2;
    localparam [RX_INIT_W-1:0] RX_INIT_AUTO = RX_INIT_USE_AUTO == 1 ? ( RX_INIT_MIN ) :
            RX_INIT_USE_AUTO == 3 ? ( RX_INIT_MAX ) : RX_INIT_MID;
    localparam [RX_CLK_POST_W-1:0] RX_CLK_POST_MIN = ($ceil(1.0) < 0) ? 0 : ($ceil(1.0) > 255) ? 255 : $ceil(1.0);
    localparam [RX_CLK_POST_W-1:0] RX_CLK_POST_MAX = ((RX_CLK_POST_MIN * 2.0) > 255) ? 255 : (RX_CLK_POST_MIN * 2.0);
    localparam [RX_CLK_POST_W-1:0] RX_CLK_POST_MID = RX_CLK_POST_MAX / 2 + RX_CLK_POST_MIN / 2;
    localparam [RX_CLK_POST_W-1:0] RX_CLK_POST_AUTO = RX_CLK_POST_USE_AUTO == 1 ? ( RX_CLK_POST_MIN ) :
            RX_CLK_POST_USE_AUTO == 3 ? ( RX_CLK_POST_MAX ) : RX_CLK_POST_MID;
    localparam [TX_LPX_W-1:0] TX_LPX_MIN = ($ceil(50.0*TIME_DIV/TX_CORE_PER) < 0) ? 0 : ($ceil(50.0*TIME_DIV/TX_CORE_PER) > 127) ? 127 : $ceil(50.0*TIME_DIV/TX_CORE_PER);
    localparam [TX_LPX_W-1:0] TX_LPX_MAX = ((TX_LPX_MIN * 2.0) > 127) ? 127 : (TX_LPX_MIN * 2.0);
    localparam [TX_LPX_W-1:0] TX_LPX_MID = TX_LPX_MAX / 2 + TX_LPX_MIN / 2;
    localparam [TX_LPX_W-1:0] TX_LPX_AUTO = TX_LPX_USE_AUTO == 1 ? ( TX_LPX_MIN ) :
            TX_LPX_USE_AUTO == 3 ? ( TX_LPX_MAX ) : TX_LPX_MID;
    localparam [TX_HS_EXIT_W-1:0] TX_HS_EXIT_MIN = ($ceil(100.0*TIME_DIV/TX_CORE_PER) < 0) ? 0 : ($ceil(100.0*TIME_DIV/TX_CORE_PER) > 255) ? 255 : $ceil(100.0*TIME_DIV/TX_CORE_PER);
    localparam [TX_HS_EXIT_W-1:0] TX_HS_EXIT_MAX = ((TX_HS_EXIT_MIN * 2.0) > 255) ? 255 : (TX_HS_EXIT_MIN * 2.0);
    localparam [TX_HS_EXIT_W-1:0] TX_HS_EXIT_MID = TX_HS_EXIT_MAX / 2 + TX_HS_EXIT_MIN / 2;
    localparam [TX_HS_EXIT_W-1:0] TX_HS_EXIT_AUTO = TX_HS_EXIT_USE_AUTO == 1 ? ( TX_HS_EXIT_MIN ) :
            TX_HS_EXIT_USE_AUTO == 3 ? ( TX_HS_EXIT_MAX ) : TX_HS_EXIT_MID;
    localparam [TX_LP_EXIT_W-1:0] TX_LP_EXIT_MIN = ($ceil(100.0*TIME_DIV/TX_CORE_PER) < 0) ? 0 : ($ceil(100.0*TIME_DIV/TX_CORE_PER) > 255) ? 255 : $ceil(100.0*TIME_DIV/TX_CORE_PER);
    localparam [TX_LP_EXIT_W-1:0] TX_LP_EXIT_MAX = ((TX_LP_EXIT_MIN * 2.0) > 255) ? 255 : (TX_LP_EXIT_MIN * 2.0);
    localparam [TX_LP_EXIT_W-1:0] TX_LP_EXIT_MID = TX_LP_EXIT_MAX / 2 + TX_LP_EXIT_MIN / 2;
    localparam [TX_LP_EXIT_W-1:0] TX_LP_EXIT_AUTO = TX_LP_EXIT_USE_AUTO == 1 ? ( TX_LP_EXIT_MIN ) :
            TX_LP_EXIT_USE_AUTO == 3 ? ( TX_LP_EXIT_MAX ) : TX_LP_EXIT_MID;
    localparam [TX_CLK_PREPARE_W-1:0] TX_CLK_PREPARE_MIN = ($ceil(38.0*TIME_DIV/TX_CORE_PER -2.0) < 0) ? 0 : ($ceil(38.0*TIME_DIV/TX_CORE_PER -2.0) > 63) ? 63 : $ceil(38.0*TIME_DIV/TX_CORE_PER -2.0);
    localparam [TX_CLK_PREPARE_W-1:0] TX_CLK_PREPARE_MAX = ($floor(95.0*TIME_DIV/TX_CORE_PER-2.0) < 0) ? 0 : ($floor(95.0*TIME_DIV/TX_CORE_PER-2.0) > 63) ? 63 : $floor(95.0*TIME_DIV/TX_CORE_PER-2.0);
    localparam [TX_CLK_PREPARE_W-1:0] TX_CLK_PREPARE_MID = TX_CLK_PREPARE_MAX / 2 + TX_CLK_PREPARE_MIN / 2;
    localparam [TX_CLK_PREPARE_W-1:0] TX_CLK_PREPARE_AUTO = TX_CLK_PREPARE_USE_AUTO == 1 ? ( TX_CLK_PREPARE_MIN ) :
            TX_CLK_PREPARE_USE_AUTO == 3 ? ( TX_CLK_PREPARE_MAX ) : TX_CLK_PREPARE_MID;
    localparam [TX_CLK_TRAIL_W-1:0] TX_CLK_TRAIL_MIN = ($ceil(60.0*TIME_DIV/TX_CORE_PER - 2.0 + TXFIFO_LAT) < 0) ? 0 : ($ceil(60.0*TIME_DIV/TX_CORE_PER - 2.0 + TXFIFO_LAT) > 127) ? 127 : $ceil(60.0*TIME_DIV/TX_CORE_PER - 2.0 + TXFIFO_LAT);
    localparam [TX_CLK_TRAIL_W-1:0] TX_CLK_TRAIL_MAX = ($floor((105.0*TIME_DIV+12.0*UI)/TX_CORE_PER - 2.0 + TXFIFO_LAT) < 0) ? 0 : ($floor((105.0*TIME_DIV+12.0*UI)/TX_CORE_PER - 2.0 + TXFIFO_LAT) > 127) ? 127 : $floor((105.0*TIME_DIV+12.0*UI)/TX_CORE_PER - 2.0 + TXFIFO_LAT);
    localparam [TX_CLK_TRAIL_W-1:0] TX_CLK_TRAIL_MID = TX_CLK_TRAIL_MAX / 2 + TX_CLK_TRAIL_MIN / 2;
    localparam [TX_CLK_TRAIL_W-1:0] TX_CLK_TRAIL_AUTO = TX_CLK_TRAIL_USE_AUTO == 1 ? ( TX_CLK_TRAIL_MIN ) :
            TX_CLK_TRAIL_USE_AUTO == 3 ? ( TX_CLK_TRAIL_MAX ) : TX_CLK_TRAIL_MID;
    localparam [TX_CLK_ZERO_W-1:0] TX_CLK_ZERO_MIN = ($ceil(262.0 *TIME_DIV/TX_CORE_PER -2.0 - TXFIFO_LAT) < 0) ? 0 : ($ceil(262.0 *TIME_DIV/TX_CORE_PER -2.0 - TXFIFO_LAT) > 127) ? 127 : $ceil(262.0 *TIME_DIV/TX_CORE_PER -2.0 - TXFIFO_LAT);
    localparam [TX_CLK_ZERO_W-1:0] TX_CLK_ZERO_MAX = ((TX_CLK_ZERO_MIN * 2.0) > 127) ? 127 : (TX_CLK_ZERO_MIN * 2.0);
    localparam [TX_CLK_ZERO_W-1:0] TX_CLK_ZERO_MID = TX_CLK_ZERO_MAX / 2 + TX_CLK_ZERO_MIN / 2;
    localparam [TX_CLK_ZERO_W-1:0] TX_CLK_ZERO_AUTO = TX_CLK_ZERO_USE_AUTO == 1 ? ( TX_CLK_ZERO_MIN ) :
            TX_CLK_ZERO_USE_AUTO == 3 ? ( TX_CLK_ZERO_MAX ) : TX_CLK_ZERO_MID;
    localparam [TX_CLK_POST_W-1:0] TX_CLK_POST_MIN = ($ceil((60.0*TIME_DIV+52.0*UI)/TX_CORE_PER - 3.0 - TXFIFO_LAT) < 0) ? 0 : ($ceil((60.0*TIME_DIV+52.0*UI)/TX_CORE_PER - 3.0 - TXFIFO_LAT) > 255) ? 255 : $ceil((60.0*TIME_DIV+52.0*UI)/TX_CORE_PER - 3.0 - TXFIFO_LAT);
    localparam [TX_CLK_POST_W-1:0] TX_CLK_POST_MAX = ((TX_CLK_POST_MIN * 2.0) > 255) ? 255 : (TX_CLK_POST_MIN * 2.0);
    localparam [TX_CLK_POST_W-1:0] TX_CLK_POST_MID = TX_CLK_POST_MAX / 2 + TX_CLK_POST_MIN / 2;
    localparam [TX_CLK_POST_W-1:0] TX_CLK_POST_AUTO = TX_CLK_POST_USE_AUTO == 1 ? ( TX_CLK_POST_MIN ) :
            TX_CLK_POST_USE_AUTO == 3 ? ( TX_CLK_POST_MAX ) : TX_CLK_POST_MID;
    localparam [TX_CLK_PRE_W-1:0] TX_CLK_PRE_MIN = ($ceil((8.0*UI)/TX_CORE_PER -2.0 + TXFIFO_LAT) < 0) ? 0 : ($ceil((8.0*UI)/TX_CORE_PER -2.0 + TXFIFO_LAT) > 15) ? 15 : $ceil((8.0*UI)/TX_CORE_PER -2.0 + TXFIFO_LAT);
    localparam [TX_CLK_PRE_W-1:0] TX_CLK_PRE_MAX = ((TX_CLK_PRE_MIN * 2.0) > 15) ? 15 : (TX_CLK_PRE_MIN * 2.0);
    localparam [TX_CLK_PRE_W-1:0] TX_CLK_PRE_MID = TX_CLK_PRE_MAX / 2 + TX_CLK_PRE_MIN / 2;
    localparam [TX_CLK_PRE_W-1:0] TX_CLK_PRE_AUTO = TX_CLK_PRE_USE_AUTO == 1 ? ( TX_CLK_PRE_MIN ) :
            TX_CLK_PRE_USE_AUTO == 3 ? ( TX_CLK_PRE_MAX ) : TX_CLK_PRE_MID;
    localparam [TX_HS_PREPARE_W-1:0] TX_HS_PREPARE_MIN = ($ceil((40.0*TIME_DIV+4.0*UI)/TX_CORE_PER -2.0) < 0) ? 0 : ($ceil((40.0*TIME_DIV+4.0*UI)/TX_CORE_PER -2.0) > 63) ? 63 : $ceil((40.0*TIME_DIV+4.0*UI)/TX_CORE_PER -2.0);
    localparam [TX_HS_PREPARE_W-1:0] TX_HS_PREPARE_MAX = ($floor((85.0*TIME_DIV +6.0*UI)/TX_CORE_PER-2.0) < 0) ? 0 : ($floor((85.0*TIME_DIV +6.0*UI)/TX_CORE_PER-2.0) > 63) ? 63 : $floor((85.0*TIME_DIV +6.0*UI)/TX_CORE_PER-2.0);
    localparam [TX_HS_PREPARE_W-1:0] TX_HS_PREPARE_MID = TX_HS_PREPARE_MAX / 2 + TX_HS_PREPARE_MIN / 2;
    localparam [TX_HS_PREPARE_W-1:0] TX_HS_PREPARE_AUTO = TX_HS_PREPARE_USE_AUTO == 1 ? ( TX_HS_PREPARE_MIN ) :
            TX_HS_PREPARE_USE_AUTO == 3 ? ( TX_HS_PREPARE_MAX ) : TX_HS_PREPARE_MID;
    localparam [TX_HS_ZERO_W-1:0] TX_HS_ZERO_MIN = ($ceil((105.0*TIME_DIV+6.0*UI)/TX_CORE_PER-3.0 - TXFIFO_LAT) < 0) ? 0 : ($ceil((105.0*TIME_DIV+6.0*UI)/TX_CORE_PER-3.0 - TXFIFO_LAT) > 255) ? 255 : $ceil((105.0*TIME_DIV+6.0*UI)/TX_CORE_PER-3.0 - TXFIFO_LAT);
    localparam [TX_HS_ZERO_W-1:0] TX_HS_ZERO_MAX = ((TX_HS_ZERO_MIN * 2.0) > 255) ? 255 : (TX_HS_ZERO_MIN * 2.0);
    localparam [TX_HS_ZERO_W-1:0] TX_HS_ZERO_MID = TX_HS_ZERO_MAX / 2 + TX_HS_ZERO_MIN / 2;
    localparam [TX_HS_ZERO_W-1:0] TX_HS_ZERO_AUTO = TX_HS_ZERO_USE_AUTO == 1 ? ( TX_HS_ZERO_MIN ) :
            TX_HS_ZERO_USE_AUTO == 3 ? ( TX_HS_ZERO_MAX ) : TX_HS_ZERO_MID;
    localparam [TX_HS_TRAIL_W-1:0] TX_HS_TRAIL_MIN = ($ceil((60.0*TIME_DIV+4.0*UI)/TX_CORE_PER-1.0 + TXFIFO_LAT) < 0) ? 0 : ($ceil((60.0*TIME_DIV+4.0*UI)/TX_CORE_PER-1.0 + TXFIFO_LAT) > 255) ? 255 : $ceil((60.0*TIME_DIV+4.0*UI)/TX_CORE_PER-1.0 + TXFIFO_LAT);
    localparam [TX_HS_TRAIL_W-1:0] TX_HS_TRAIL_MAX = ($floor((105.0*TIME_DIV+12.0*UI)/TX_CORE_PER-1.0 + TXFIFO_LAT) < 0) ? 0 : ($floor((105.0*TIME_DIV+12.0*UI)/TX_CORE_PER-1.0 + TXFIFO_LAT) > 255) ? 255 : $floor((105.0*TIME_DIV+12.0*UI)/TX_CORE_PER-1.0 + TXFIFO_LAT);
    localparam [TX_HS_TRAIL_W-1:0] TX_HS_TRAIL_MID = TX_HS_TRAIL_MAX / 2 + TX_HS_TRAIL_MIN / 2;
    localparam [TX_HS_TRAIL_W-1:0] TX_HS_TRAIL_AUTO = TX_HS_TRAIL_USE_AUTO == 1 ? ( TX_HS_TRAIL_MIN ) :
            TX_HS_TRAIL_USE_AUTO == 3 ? ( TX_HS_TRAIL_MAX ) : TX_HS_TRAIL_MID;
    localparam [TX_INIT_W-1:0] TX_INIT_MIN = ($ceil(100000.0*TIME_DIV/TX_CORE_PER_1K) < 0) ? 0 : ($ceil(100000.0*TIME_DIV/TX_CORE_PER_1K) > 255) ? 255 : $ceil(100000.0*TIME_DIV/TX_CORE_PER_1K);
    localparam [TX_INIT_W-1:0] TX_INIT_MAX = ((TX_INIT_MIN * 2.0) > 255) ? 255 : (TX_INIT_MIN * 2.0);
    localparam [TX_INIT_W-1:0] TX_INIT_MID = TX_INIT_MAX / 2 + TX_INIT_MIN / 2;
    localparam [TX_INIT_W-1:0] TX_INIT_AUTO = TX_INIT_USE_AUTO == 1 ? ( TX_INIT_MIN ) :
            TX_INIT_USE_AUTO == 3 ? ( TX_INIT_MAX ) : TX_INIT_MID;
    localparam [TX_WAKE_W-1:0] TX_WAKE_MIN = ($ceil(1000000.0*TIME_DIV/TX_CORE_PER_1K) < 0) ? 0 : ($ceil(1000000.0*TIME_DIV/TX_CORE_PER_1K) > 255) ? 255 : $ceil(1000000.0*TIME_DIV/TX_CORE_PER_1K);
    localparam [TX_WAKE_W-1:0] TX_WAKE_MAX = ((TX_WAKE_MIN * 2.0) > 255) ? 255 : (TX_WAKE_MIN * 2.0);
    localparam [TX_WAKE_W-1:0] TX_WAKE_MID = TX_WAKE_MAX / 2 + TX_WAKE_MIN / 2;
    localparam [TX_WAKE_W-1:0] TX_WAKE_AUTO = TX_WAKE_USE_AUTO == 1 ? ( TX_WAKE_MIN ) :
            TX_WAKE_USE_AUTO == 3 ? ( TX_WAKE_MAX ) : TX_WAKE_MID;

    logic reg_00_ren;
    logic [7:0] reg_00_00_rdata;
    logic [7:0] reg_00_01_rdata;
    logic [7:0] reg_00_11_rdata;
    logic reg_04_ren;
    logic [7:0] reg_04_00_rdata;
    logic reg_10_ren;
    logic reg_10_00_wen;
    logic [7:0] reg_10_00_rdata;
    logic reg_DPHY_CSR_Enable;
    logic reg_14_ren;
    logic [7:0] reg_14_00_rdata;
    logic [7:0] reg_14_01_rdata;
    logic [7:0] reg_14_10_rdata;
    logic [7:0] reg_14_11_rdata;
    logic reg_18_ren;
    logic [7:0] reg_18_00_rdata;
    logic [7:0] reg_18_01_rdata;
    logic [7:0] reg_18_10_rdata;
    logic [7:0] reg_18_11_rdata;
    logic reg_1C_ren;
    logic reg_1C_00_wen;
    logic [7:0] reg_1C_00_rdata;
    logic reg_CLK_CSR_CLK_LANE_EN;
    logic reg_1C_01_wen;
    logic [7:0] reg_1C_01_rdata;
    logic reg_20_ren;
    logic reg_20_00_wen;
    logic [7:0] reg_20_00_rdata;
    logic [7:0] reg_DLANE_CSR_EN;                           
    logic [7:0] reg_DLANE_CSR_RX_DESKEW_UPDATE;             
    logic [7:0] reg_DLANE_CSR_RX_MNL_DESKEW_EN;             
    logic [7:0] reg_20_01_rdata;
    logic reg_24_ren;
    logic reg_24_00_wen;
    logic [7:0] reg_24_00_rdata;
    logic [7:0] reg_24_01_rdata;
    logic reg_28_ren;
    logic reg_28_00_wen;
    logic [7:0] reg_28_00_rdata;
    logic [7:0] reg_28_01_rdata;
    logic reg_2C_ren;
    logic reg_2C_00_wen;
    logic [7:0] reg_2C_00_rdata;
    logic [7:0] reg_2C_01_rdata;
    logic reg_30_ren;
    logic reg_30_00_wen;
    logic [7:0] reg_30_00_rdata;
    logic [7:0] reg_30_01_rdata;
    logic reg_34_ren;
    logic reg_34_00_wen;
    logic [7:0] reg_34_00_rdata;
    logic [7:0] reg_34_01_rdata;
    logic reg_38_ren;
    logic reg_38_00_wen;
    logic [7:0] reg_38_00_rdata;
    logic [7:0] reg_38_01_rdata;
    logic reg_3C_ren;
    logic reg_3C_00_wen;
    logic [7:0] reg_3C_00_rdata;
    logic [7:0] reg_3C_01_rdata;
    logic reg_68_ren;
    logic reg_68_00_wen;
    logic [7:0] reg_68_00_rdata;
    logic [PRBS_INIT_0_W-1:0] reg_PRBS_INIT_0;
    logic reg_68_01_wen;
    logic [7:0] reg_68_01_rdata;
    logic [PRBS_INIT_1_W-1:0] reg_PRBS_INIT_1;
    logic reg_68_10_wen;
    logic [7:0] reg_68_10_rdata;
    logic [PRBS_INIT_2_W-1:0] reg_PRBS_INIT_2;
    logic reg_68_11_wen;
    logic [7:0] reg_68_11_rdata;
    logic [PRBS_INIT_3_W-1:0] reg_PRBS_INIT_3;
    logic reg_6C_ren;
    logic reg_6C_00_wen;
    logic [7:0] reg_6C_00_rdata;
    logic [PRBS_INIT_4_W-1:0] reg_PRBS_INIT_4;
    logic reg_6C_01_wen;
    logic [7:0] reg_6C_01_rdata;
    logic [PRBS_INIT_5_W-1:0] reg_PRBS_INIT_5;
    logic reg_6C_10_wen;
    logic [7:0] reg_6C_10_rdata;
    logic [PRBS_INIT_6_W-1:0] reg_PRBS_INIT_6;
    logic reg_6C_11_wen;
    logic [7:0] reg_6C_11_rdata;
    logic [PRBS_INIT_7_W-1:0] reg_PRBS_INIT_7;
    logic def_IP_CAP_ROLE;
    logic [IP_CAP_PPI_WIDTH_W-1:0] def_IP_CAP_PPI_WIDTH;
    logic [IP_CAP_NLANES_W-1:0] def_IP_CAP_NLANES;
    logic [SKEW_CAL_LEN_B0_W-1:0] def_SKEW_CAL_LEN_B0;
    logic [SKEW_CAL_LEN_B1_W-1:0] def_SKEW_CAL_LEN_B1;
    logic [SKEW_CAL_LEN_B2_W-1:0] def_SKEW_CAL_LEN_B2;
    logic [SKEW_CAL_LEN_B3_W-1:0] def_SKEW_CAL_LEN_B3;
    logic [ALT_CAL_LEN_B0_W-1:0] def_ALT_CAL_LEN_B0;
    logic [ALT_CAL_LEN_B1_W-1:0] def_ALT_CAL_LEN_B1;
    logic [ALT_CAL_LEN_B2_W-1:0] def_ALT_CAL_LEN_B2;
    logic [ALT_CAL_LEN_B3_W-1:0] def_ALT_CAL_LEN_B3;
    logic [PRBS_INIT_0_W-1:0] def_PRBS_INIT_0;
    logic [PRBS_INIT_1_W-1:0] def_PRBS_INIT_1;
    logic [PRBS_INIT_2_W-1:0] def_PRBS_INIT_2;
    logic [PRBS_INIT_3_W-1:0] def_PRBS_INIT_3;
    logic [PRBS_INIT_4_W-1:0] def_PRBS_INIT_4;
    logic [PRBS_INIT_5_W-1:0] def_PRBS_INIT_5;
    logic [PRBS_INIT_6_W-1:0] def_PRBS_INIT_6;
    logic [PRBS_INIT_7_W-1:0] def_PRBS_INIT_7;
    logic reg_08_ren;
    logic [7:0] reg_08_00_rdata;
    logic [7:0] reg_10_10_rdata;
    logic [RX_DLANE_ERR_W-1:0] reg_RX_DLANE_ERR;
    logic reg_20_10_wen;
    logic [7:0] reg_20_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_0_W-1:0] reg_RX_DLANE_DESKEW_DELAY_0;
    logic reg_20_11_wen;
    logic [7:0] reg_20_11_rdata;
    logic [7:0] reg_RX_DLANE_ERR_SOT_ERR;                   
    logic [7:0] reg_RX_DLANE_ERR_SOT_SYNC_ERR;              
    logic [7:0] reg_RX_DLANE_ERR_EOT_SYNC_ERR;              
    logic [7:0] reg_RX_DLANE_ERR_ESC_ENTRY_ERR;             
    logic [7:0] reg_RX_DLANE_ERR_LPDT_ERR;                  
    logic [7:0] reg_RX_DLANE_ERR_CTRL_ERR;                  
    logic [7:0] reg_RX_DLANE_ERR_CAL_ERR;                   
    logic reg_24_10_wen;
    logic [7:0] reg_24_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_1_W-1:0] reg_RX_DLANE_DESKEW_DELAY_1;
    logic reg_24_11_wen;
    logic [7:0] reg_24_11_rdata;
    logic reg_28_10_wen;
    logic [7:0] reg_28_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_2_W-1:0] reg_RX_DLANE_DESKEW_DELAY_2;
    logic reg_28_11_wen;
    logic [7:0] reg_28_11_rdata;
    logic reg_2C_10_wen;
    logic [7:0] reg_2C_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_3_W-1:0] reg_RX_DLANE_DESKEW_DELAY_3;
    logic reg_2C_11_wen;
    logic [7:0] reg_2C_11_rdata;
    logic reg_30_10_wen;
    logic [7:0] reg_30_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_4_W-1:0] reg_RX_DLANE_DESKEW_DELAY_4;
    logic reg_30_11_wen;
    logic [7:0] reg_30_11_rdata;
    logic reg_34_10_wen;
    logic [7:0] reg_34_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_5_W-1:0] reg_RX_DLANE_DESKEW_DELAY_5;
    logic reg_34_11_wen;
    logic [7:0] reg_34_11_rdata;
    logic reg_38_10_wen;
    logic [7:0] reg_38_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_6_W-1:0] reg_RX_DLANE_DESKEW_DELAY_6;
    logic reg_38_11_wen;
    logic [7:0] reg_38_11_rdata;
    logic reg_3C_10_wen;
    logic [7:0] reg_3C_10_rdata;
    logic [RX_DLANE_DESKEW_DELAY_7_W-1:0] reg_RX_DLANE_DESKEW_DELAY_7;
    logic reg_3C_11_wen;
    logic [7:0] reg_3C_11_rdata;
    logic reg_50_ren;
    logic reg_50_00_wen;
    logic [7:0] reg_50_00_rdata;
    logic [RX_CLK_LOSS_DETECT_W-1:0] reg_RX_CLK_LOSS_DETECT;
    logic reg_50_01_wen;
    logic [7:0] reg_50_01_rdata;
    logic [RX_CLK_SETTLE_W-1:0] reg_RX_CLK_SETTLE;
    logic reg_50_10_wen;
    logic [7:0] reg_50_10_rdata;
    logic [RX_HS_SETTLE_W-1:0] reg_RX_HS_SETTLE;
    logic reg_54_ren;
    logic reg_54_00_wen;
    logic [7:0] reg_54_00_rdata;
    logic [RX_INIT_W-1:0] reg_RX_INIT;
    logic reg_54_01_wen;
    logic [7:0] reg_54_01_rdata;
    logic [RX_CLK_POST_W-1:0] reg_RX_CLK_POST;
    logic reg_60_ren;
    logic reg_60_00_wen;
    logic [7:0] reg_60_00_rdata;
    logic [RX_CAL_REG_CTRL_CAL_REG_MUXSEL_W-1:0] reg_RX_CAL_REG_CTRL_CAL_REG_MUXSEL;
    logic reg_RX_CAL_REG_CTRL_CAL_RESET;
    logic [7:0] reg_60_01_rdata;
    logic [7:0] reg_60_10_rdata;
    logic [7:0] reg_60_11_rdata;
    logic reg_64_ren;
    logic [7:0] reg_64_00_rdata;
    logic [7:0] reg_64_01_rdata;
    logic [7:0] reg_64_10_rdata;
    logic [7:0] reg_64_11_rdata;
    logic reg_78_ren;
    logic reg_78_00_wen;
    logic [7:0] reg_78_00_rdata;
    logic reg_RX_TM_CONTROL_RX_TM_EN;
    logic reg_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE;
    logic reg_RX_TM_CONTROL_RX_TST_CNT_RST;
    logic reg_78_01_wen;
    logic [7:0] reg_78_01_rdata;
    logic [RX_PREP_TIME_TM_W-1:0] reg_RX_PREP_TIME_TM;
    logic reg_7C_ren;
    logic [7:0] reg_7C_00_rdata;
    logic [7:0] reg_7C_01_rdata;
    logic [7:0] reg_7C_10_rdata;
    logic [7:0] reg_7C_11_rdata;
    logic def_RX_CAP_SKEW_CAL;
    logic def_RX_CAP_ALT_CAL;
    logic def_RX_CAP_PREAMBLE;
    logic def_RX_CAP_PERIODIC_SKEW_CAL;
    logic [RX_CAP_EQ_MODE_W-1:0] def_RX_CAP_EQ_MODE;
    logic [RX_DLANE_DESKEW_DELAY_0_W-1:0] def_RX_DLANE_DESKEW_DELAY_0;
    logic [RX_DLANE_DESKEW_DELAY_1_W-1:0] def_RX_DLANE_DESKEW_DELAY_1;
    logic [RX_DLANE_DESKEW_DELAY_2_W-1:0] def_RX_DLANE_DESKEW_DELAY_2;
    logic [RX_DLANE_DESKEW_DELAY_3_W-1:0] def_RX_DLANE_DESKEW_DELAY_3;
    logic [RX_DLANE_DESKEW_DELAY_4_W-1:0] def_RX_DLANE_DESKEW_DELAY_4;
    logic [RX_DLANE_DESKEW_DELAY_5_W-1:0] def_RX_DLANE_DESKEW_DELAY_5;
    logic [RX_DLANE_DESKEW_DELAY_6_W-1:0] def_RX_DLANE_DESKEW_DELAY_6;
    logic [RX_DLANE_DESKEW_DELAY_7_W-1:0] def_RX_DLANE_DESKEW_DELAY_7;
    logic [RX_CLK_LOSS_DETECT_W-1:0] def_RX_CLK_LOSS_DETECT;
    logic [RX_CLK_SETTLE_W-1:0] def_RX_CLK_SETTLE;
    logic [RX_HS_SETTLE_W-1:0] def_RX_HS_SETTLE;
    logic [RX_INIT_W-1:0] def_RX_INIT;
    logic [RX_CLK_POST_W-1:0] def_RX_CLK_POST;
    logic [RX_PREP_TIME_TM_W-1:0] def_RX_PREP_TIME_TM;
    logic reg_0C_ren;
    logic [7:0] reg_0C_00_rdata;
    logic reg_0C_01_wen;
    logic [7:0] reg_0C_01_rdata;
    logic reg_TX_PREAMBLE_LEN_PREAMBLE_EN;
    logic [TX_PREAMBLE_LEN_PREAMLBE_LEN_W-1:0] reg_TX_PREAMBLE_LEN_PREAMLBE_LEN;
    logic [7:0] reg_10_01_rdata;
    logic reg_40_ren;
    logic reg_40_00_wen;
    logic [7:0] reg_40_00_rdata;
    logic [TX_LPX_W-1:0] reg_TX_LPX;
    logic reg_40_01_wen;
    logic [7:0] reg_40_01_rdata;
    logic [TX_HS_EXIT_W-1:0] reg_TX_HS_EXIT;
    logic reg_40_10_wen;
    logic [7:0] reg_40_10_rdata;
    logic [TX_LP_EXIT_W-1:0] reg_TX_LP_EXIT;
    logic reg_44_ren;
    logic reg_44_00_wen;
    logic [7:0] reg_44_00_rdata;
    logic [TX_CLK_PREPARE_W-1:0] reg_TX_CLK_PREPARE;
    logic reg_44_01_wen;
    logic [7:0] reg_44_01_rdata;
    logic [TX_CLK_TRAIL_W-1:0] reg_TX_CLK_TRAIL;
    logic reg_44_10_wen;
    logic [7:0] reg_44_10_rdata;
    logic [TX_CLK_ZERO_W-1:0] reg_TX_CLK_ZERO;
    logic reg_44_11_wen;
    logic [7:0] reg_44_11_rdata;
    logic [TX_CLK_POST_W-1:0] reg_TX_CLK_POST;
    logic reg_48_ren;
    logic reg_48_00_wen;
    logic [7:0] reg_48_00_rdata;
    logic [TX_CLK_PRE_W-1:0] reg_TX_CLK_PRE;
    logic reg_48_01_wen;
    logic [7:0] reg_48_01_rdata;
    logic [TX_HS_PREPARE_W-1:0] reg_TX_HS_PREPARE;
    logic reg_48_10_wen;
    logic [7:0] reg_48_10_rdata;
    logic [TX_HS_ZERO_W-1:0] reg_TX_HS_ZERO;
    logic reg_4C_ren;
    logic reg_4C_00_wen;
    logic [7:0] reg_4C_00_rdata;
    logic [TX_HS_TRAIL_W-1:0] reg_TX_HS_TRAIL;
    logic reg_4C_10_wen;
    logic [7:0] reg_4C_10_rdata;
    logic [TX_INIT_W-1:0] reg_TX_INIT;
    logic reg_4C_11_wen;
    logic [7:0] reg_4C_11_rdata;
    logic [TX_WAKE_W-1:0] reg_TX_WAKE;
    logic reg_70_ren;
    logic reg_70_00_wen;
    logic [7:0] reg_70_00_rdata;
    logic reg_TX_TM_CONTROL_TX_TM_EN;
    logic reg_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE;
    logic reg_TX_TM_CONTROL_TX_TST_CNT_RST;
    logic reg_70_01_wen;
    logic [7:0] reg_70_01_rdata;
    logic [TX_HS_TM_DESKEW_P_W-1:0] reg_TX_HS_TM_DESKEW_P;
    logic reg_70_10_wen;
    logic [7:0] reg_70_10_rdata;
    logic reg_TX_MNL_IO_0_CTRL_EN;
    logic reg_TX_MNL_IO_0_CLK_LP_EN;
    logic [TX_MNL_IO_0_LP_DAT_W-1:0] reg_TX_MNL_IO_0_LP_DAT;
    logic [TX_MNL_IO_0_HS_DAT_D_W-1:0] reg_TX_MNL_IO_0_HS_DAT_D;
    logic [TX_MNL_IO_0_HS_DAT_CK_W-1:0] reg_TX_MNL_IO_0_HS_DAT_CK;
    logic reg_70_11_wen;
    logic [7:0] reg_70_11_rdata;
    logic [TX_MNL_D_LP_EN_W-1:0] reg_TX_MNL_D_LP_EN;
    logic reg_74_ren;
    logic [7:0] reg_74_00_rdata;
    logic [7:0] reg_74_01_rdata;
    logic [7:0] reg_74_10_rdata;
    logic [7:0] reg_74_11_rdata;
    logic def_TX_CAP_SKEW_CAL;
    logic def_TX_CAP_ALT_CAL;
    logic def_TX_CAP_PREAMBLE;
    logic [TX_CAP_EQ_MODE_W-1:0] def_TX_CAP_EQ_MODE;
    logic [TX_CLK_LANE_PS_W-1:0] def_TX_CLK_LANE_PS;
    logic [TX_LPX_W-1:0] def_TX_LPX;
    logic [TX_HS_EXIT_W-1:0] def_TX_HS_EXIT;
    logic [TX_LP_EXIT_W-1:0] def_TX_LP_EXIT;
    logic [TX_CLK_PREPARE_W-1:0] def_TX_CLK_PREPARE;
    logic [TX_CLK_TRAIL_W-1:0] def_TX_CLK_TRAIL;
    logic [TX_CLK_ZERO_W-1:0] def_TX_CLK_ZERO;
    logic [TX_CLK_POST_W-1:0] def_TX_CLK_POST;
    logic [TX_CLK_PRE_W-1:0] def_TX_CLK_PRE;
    logic [TX_HS_PREPARE_W-1:0] def_TX_HS_PREPARE;
    logic [TX_HS_ZERO_W-1:0] def_TX_HS_ZERO;
    logic [TX_HS_TRAIL_W-1:0] def_TX_HS_TRAIL;
    logic [TX_INIT_W-1:0] def_TX_INIT;
    logic [TX_WAKE_W-1:0] def_TX_WAKE;
    logic [TX_HS_TM_DESKEW_P_W-1:0] def_TX_HS_TM_DESKEW_P;

    logic sig_D0_CAP_HS_CAP = 1'b0;
    logic [D0_CAP_FWD_ESC_CAP_W-1:0] sig_D0_CAP_FWD_ESC_CAP = 2'b11;
    logic [D0_CAP_REV_CAP_W-1:0] sig_D0_CAP_REV_CAP = 2'b00;
    logic sig_DN_CAP_HS_CAP = 1'b0;
    logic [DN_CAP_FWD_ESC_CAP_W-1:0] sig_DN_CAP_FWD_ESC_CAP = 2'b01;
    logic [DN_CAP_REV_CAP_W-1:0] sig_DN_CAP_REV_CAP = 2'b00;

    assign reg_00_ren = raddr[7:2] == 6'h00 ? rd_en : 1'b0;
    assign reg_00_00_rdata = reg_00_ren == 1'b0 ? 8'h00 : sig_IP_ID;
    assign def_IP_CAP_ROLE = IP_CAP_ROLE_D;
    assign def_IP_CAP_PPI_WIDTH = IP_CAP_PPI_WIDTH_D;
    assign def_IP_CAP_NLANES = IP_CAP_NLANES_D;
    assign reg_00_01_rdata = reg_00_ren == 1'b0 ? 8'h00 : 
            { {(7 - IP_CAP_NLANES_BI_H){1'b0} },
            def_IP_CAP_NLANES,
            def_IP_CAP_PPI_WIDTH,
            def_IP_CAP_ROLE};

    assign reg_00_11_rdata = reg_00_ren == 1'b0 ? 8'h00 : 
            { {(7 - D0_CAP_REV_CAP_BI_H){1'b0} },
            sig_D0_CAP_REV_CAP,
            sig_D0_CAP_FWD_ESC_CAP,
            sig_D0_CAP_HS_CAP};

    assign reg_04_ren = raddr[7:2] == 6'h01 ? rd_en : 1'b0;
    assign reg_04_00_rdata = reg_04_ren == 1'b0 ? 8'h00 : 
            { {(7 - DN_CAP_REV_CAP_BI_H){1'b0} },
            sig_DN_CAP_REV_CAP,
            sig_DN_CAP_FWD_ESC_CAP,
            sig_DN_CAP_HS_CAP};

    assign reg_10_ren = raddr[7:2] == 6'h04 ? rd_en : 1'b0;
    assign reg_10_00_wen = waddr[7:2] == 6'h04 ? be[0] & wr_en : 1'b0;
    assign reg_10_00_rdata = reg_10_ren == 1'b0 ? 8'h00 : 
            { {(7 - DPHY_CSR_PLL_LOCK_BI){1'b0} },
            sig_DPHY_CSR_PLL_LOCK,
            reg_DPHY_CSR_Enable};

    assign reg_14_ren = raddr[7:2] == 6'h05 ? rd_en : 1'b0;
    assign def_SKEW_CAL_LEN_B0 = SKEW_CAL_LEN_B0_D;
    assign reg_14_00_rdata = reg_14_ren == 1'b0 ? 8'h00 : def_SKEW_CAL_LEN_B0;
    assign def_SKEW_CAL_LEN_B1 = SKEW_CAL_LEN_B1_D;
    assign reg_14_01_rdata = reg_14_ren == 1'b0 ? 8'h00 : def_SKEW_CAL_LEN_B1;
    assign def_SKEW_CAL_LEN_B2 = SKEW_CAL_LEN_B2_D;
    assign reg_14_10_rdata = reg_14_ren == 1'b0 ? 8'h00 : def_SKEW_CAL_LEN_B2;
    assign def_SKEW_CAL_LEN_B3 = SKEW_CAL_LEN_B3_D;
    assign reg_14_11_rdata = reg_14_ren == 1'b0 ? 8'h00 : def_SKEW_CAL_LEN_B3;
    assign reg_18_ren = raddr[7:2] == 6'h06 ? rd_en : 1'b0;
    assign def_ALT_CAL_LEN_B0 = ALT_CAL_LEN_B0_D;
    assign reg_18_00_rdata = reg_18_ren == 1'b0 ? 8'h00 : def_ALT_CAL_LEN_B0;
    assign def_ALT_CAL_LEN_B1 = ALT_CAL_LEN_B1_D;
    assign reg_18_01_rdata = reg_18_ren == 1'b0 ? 8'h00 : def_ALT_CAL_LEN_B1;
    assign def_ALT_CAL_LEN_B2 = ALT_CAL_LEN_B2_D;
    assign reg_18_10_rdata = reg_18_ren == 1'b0 ? 8'h00 : def_ALT_CAL_LEN_B2;
    assign def_ALT_CAL_LEN_B3 = ALT_CAL_LEN_B3_D;
    assign reg_18_11_rdata = reg_18_ren == 1'b0 ? 8'h00 : def_ALT_CAL_LEN_B3;
    assign reg_1C_ren = raddr[7:2] == 6'h07 ? rd_en : 1'b0;
    assign reg_1C_00_wen = waddr[7:2] == 6'h07 ? be[0] & wr_en : 1'b0;
    assign reg_1C_00_rdata = reg_1C_ren == 1'b0 ? 8'h00 : 
            { {(7 - CLK_CSR_CLK_LANE_EN_BI){1'b0} },
            reg_CLK_CSR_CLK_LANE_EN};

    assign reg_1C_01_wen = waddr[7:2] == 6'h07 ? be[1] & wr_en : 1'b0;
    assign reg_1C_01_rdata = reg_1C_ren == 1'b0 ? 8'h00 : 
            { {(7 - CLK_STATUS_INIT_DONE_BI){1'b0} },
            sig_CLK_STATUS_INIT_DONE};

    assign reg_20_ren = raddr[7:2] == 6'h08 ? rd_en : 1'b0;
    assign reg_20_00_wen = waddr[7:2] == 6'h08 ? be[0] & wr_en : 1'b0;
    assign reg_20_00_rdata = reg_20_ren == 1'b0 ? 8'h00 : 
            { {(7 - DLANE_CSR_0_RX_MNL_DESKEW_EN_BI){1'b0} },
            reg_DLANE_CSR_RX_MNL_DESKEW_EN[0],
            reg_DLANE_CSR_RX_DESKEW_UPDATE[0] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[0],
            {(DLANE_CSR_0_RX_DESKEW_UPDATE_BI - DLANE_CSR_0_EN_BI - 1){1'b0} } ,
            reg_DLANE_CSR_EN[0]};

    assign reg_20_01_rdata = reg_20_ren == 1'b0 ? 8'h00 : 
            { {(7 - DLANE_STATUS_0_INIT_DONE_BI){1'b0} },
            sig_DLANE_STATUS_INIT_DONE[0]};

    if( NUM_LANES > 1)
    begin
        assign reg_24_ren = raddr[7:2] == 6'h09 ? rd_en : 1'b0;
        assign reg_24_00_wen = waddr[7:2] == 6'h09 ? be[0] & wr_en : 1'b0;
        assign reg_24_00_rdata = reg_24_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_CSR_1_RX_MNL_DESKEW_EN_BI){1'b0} },
                reg_DLANE_CSR_RX_MNL_DESKEW_EN[1],
                reg_DLANE_CSR_RX_DESKEW_UPDATE[1] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[1],
                {(DLANE_CSR_1_RX_DESKEW_UPDATE_BI - DLANE_CSR_1_EN_BI - 1){1'b0} } ,
                reg_DLANE_CSR_EN[1]};

    end
    else
    begin
        assign reg_24_ren = 1'b0;
        assign reg_24_00_wen = 1'b0;
        assign reg_24_00_rdata = 8'h0;
    end

    if( NUM_LANES > 1)
    begin
        assign reg_24_01_rdata = reg_24_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_STATUS_1_INIT_DONE_BI){1'b0} },
                sig_DLANE_STATUS_INIT_DONE[1]};

    end
    else
    begin
        assign reg_24_01_rdata = 8'h0;
    end

    if( NUM_LANES > 2)
    begin
        assign reg_28_ren = raddr[7:2] == 6'h0A ? rd_en : 1'b0;
        assign reg_28_00_wen = waddr[7:2] == 6'h0A ? be[0] & wr_en : 1'b0;
        assign reg_28_00_rdata = reg_28_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_CSR_2_RX_MNL_DESKEW_EN_BI){1'b0} },
                reg_DLANE_CSR_RX_MNL_DESKEW_EN[2],
                reg_DLANE_CSR_RX_DESKEW_UPDATE[2] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[2],
                {(DLANE_CSR_2_RX_DESKEW_UPDATE_BI - DLANE_CSR_2_EN_BI - 1){1'b0} } ,
                reg_DLANE_CSR_EN[2]};

    end
    else
    begin
        assign reg_28_ren = 1'b0;
        assign reg_28_00_wen = 1'b0;
        assign reg_28_00_rdata = 8'h0;
    end

    if( NUM_LANES > 2)
    begin
        assign reg_28_01_rdata = reg_28_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_STATUS_2_INIT_DONE_BI){1'b0} },
                sig_DLANE_STATUS_INIT_DONE[2]};

    end
    else
    begin
        assign reg_28_01_rdata = 8'h0;
    end

    if( NUM_LANES > 3)
    begin
        assign reg_2C_ren = raddr[7:2] == 6'h0B ? rd_en : 1'b0;
        assign reg_2C_00_wen = waddr[7:2] == 6'h0B ? be[0] & wr_en : 1'b0;
        assign reg_2C_00_rdata = reg_2C_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_CSR_3_RX_MNL_DESKEW_EN_BI){1'b0} },
                reg_DLANE_CSR_RX_MNL_DESKEW_EN[3],
                reg_DLANE_CSR_RX_DESKEW_UPDATE[3] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[3],
                {(DLANE_CSR_3_RX_DESKEW_UPDATE_BI - DLANE_CSR_3_EN_BI - 1){1'b0} } ,
                reg_DLANE_CSR_EN[3]};

    end
    else
    begin
        assign reg_2C_ren = 1'b0;
        assign reg_2C_00_wen = 1'b0;
        assign reg_2C_00_rdata = 8'h0;
    end

    if( NUM_LANES > 3)
    begin
        assign reg_2C_01_rdata = reg_2C_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_STATUS_3_INIT_DONE_BI){1'b0} },
                sig_DLANE_STATUS_INIT_DONE[3]};

    end
    else
    begin
        assign reg_2C_01_rdata = 8'h0;
    end

    if( NUM_LANES > 4)
    begin
        assign reg_30_ren = raddr[7:2] == 6'h0C ? rd_en : 1'b0;
        assign reg_30_00_wen = waddr[7:2] == 6'h0C ? be[0] & wr_en : 1'b0;
        assign reg_30_00_rdata = reg_30_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_CSR_4_RX_MNL_DESKEW_EN_BI){1'b0} },
                reg_DLANE_CSR_RX_MNL_DESKEW_EN[4],
                reg_DLANE_CSR_RX_DESKEW_UPDATE[4] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[4],
                {(DLANE_CSR_4_RX_DESKEW_UPDATE_BI - DLANE_CSR_4_EN_BI - 1){1'b0} } ,
                reg_DLANE_CSR_EN[4]};

    end
    else
    begin
        assign reg_30_ren = 1'b0;
        assign reg_30_00_wen = 1'b0;
        assign reg_30_00_rdata = 8'h0;
    end

    if( NUM_LANES > 4)
    begin
        assign reg_30_01_rdata = reg_30_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_STATUS_4_INIT_DONE_BI){1'b0} },
                sig_DLANE_STATUS_INIT_DONE[4]};

    end
    else
    begin
        assign reg_30_01_rdata = 8'h0;
    end

    if( NUM_LANES > 5)
    begin
        assign reg_34_ren = raddr[7:2] == 6'h0D ? rd_en : 1'b0;
        assign reg_34_00_wen = waddr[7:2] == 6'h0D ? be[0] & wr_en : 1'b0;
        assign reg_34_00_rdata = reg_34_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_CSR_5_RX_MNL_DESKEW_EN_BI){1'b0} },
                reg_DLANE_CSR_RX_MNL_DESKEW_EN[5],
                reg_DLANE_CSR_RX_DESKEW_UPDATE[5] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[5],
                {(DLANE_CSR_5_RX_DESKEW_UPDATE_BI - DLANE_CSR_5_EN_BI - 1){1'b0} } ,
                reg_DLANE_CSR_EN[5]};

    end
    else
    begin
        assign reg_34_ren = 1'b0;
        assign reg_34_00_wen = 1'b0;
        assign reg_34_00_rdata = 8'h0;
    end

    if( NUM_LANES > 5)
    begin
        assign reg_34_01_rdata = reg_34_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_STATUS_5_INIT_DONE_BI){1'b0} },
                sig_DLANE_STATUS_INIT_DONE[5]};

    end
    else
    begin
        assign reg_34_01_rdata = 8'h0;
    end

    if( NUM_LANES > 6)
    begin
        assign reg_38_ren = raddr[7:2] == 6'h0E ? rd_en : 1'b0;
        assign reg_38_00_wen = waddr[7:2] == 6'h0E ? be[0] & wr_en : 1'b0;
        assign reg_38_00_rdata = reg_38_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_CSR_6_RX_MNL_DESKEW_EN_BI){1'b0} },
                reg_DLANE_CSR_RX_MNL_DESKEW_EN[6],
                reg_DLANE_CSR_RX_DESKEW_UPDATE[6] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[6],
                {(DLANE_CSR_6_RX_DESKEW_UPDATE_BI - DLANE_CSR_6_EN_BI - 1){1'b0} } ,
                reg_DLANE_CSR_EN[6]};

    end
    else
    begin
        assign reg_38_ren = 1'b0;
        assign reg_38_00_wen = 1'b0;
        assign reg_38_00_rdata = 8'h0;
    end

    if( NUM_LANES > 6)
    begin
        assign reg_38_01_rdata = reg_38_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_STATUS_6_INIT_DONE_BI){1'b0} },
                sig_DLANE_STATUS_INIT_DONE[6]};

    end
    else
    begin
        assign reg_38_01_rdata = 8'h0;
    end

    if( NUM_LANES > 7)
    begin
        assign reg_3C_ren = raddr[7:2] == 6'h0F ? rd_en : 1'b0;
        assign reg_3C_00_wen = waddr[7:2] == 6'h0F ? be[0] & wr_en : 1'b0;
        assign reg_3C_00_rdata = reg_3C_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_CSR_7_RX_MNL_DESKEW_EN_BI){1'b0} },
                reg_DLANE_CSR_RX_MNL_DESKEW_EN[7],
                reg_DLANE_CSR_RX_DESKEW_UPDATE[7] ^ clr_DLANE_CSR_RX_DESKEW_UPDATE_tog[7],
                {(DLANE_CSR_7_RX_DESKEW_UPDATE_BI - DLANE_CSR_7_EN_BI - 1){1'b0} } ,
                reg_DLANE_CSR_EN[7]};

    end
    else
    begin
        assign reg_3C_ren = 1'b0;
        assign reg_3C_00_wen = 1'b0;
        assign reg_3C_00_rdata = 8'h0;
    end

    if( NUM_LANES > 7)
    begin
        assign reg_3C_01_rdata = reg_3C_ren == 1'b0 ? 8'h00 : 
                { {(7 - DLANE_STATUS_7_INIT_DONE_BI){1'b0} },
                sig_DLANE_STATUS_INIT_DONE[7]};

    end
    else
    begin
        assign reg_3C_01_rdata = 8'h0;
    end

    assign reg_68_ren = raddr[7:2] == 6'h1A ? rd_en : 1'b0;
    assign reg_68_00_wen = PRBS_INIT_0_RW == 1 && waddr[7:2] == 6'h1A ? be[0] & wr_en : 1'b0;
    assign def_PRBS_INIT_0 = PRBS_INIT_0_D;
    assign reg_68_00_rdata = reg_68_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_0_RW == 0 ? def_PRBS_INIT_0 : reg_PRBS_INIT_0 );
    if( NUM_LANES > 1)
    begin
        assign reg_68_01_wen = PRBS_INIT_1_RW == 1 && waddr[7:2] == 6'h1A ? be[1] & wr_en : 1'b0;
        assign def_PRBS_INIT_1 = PRBS_INIT_1_D;
        assign reg_68_01_rdata = reg_68_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_1_RW == 0 ? def_PRBS_INIT_1 : reg_PRBS_INIT_1 );
    end
    else
    begin
        assign reg_68_01_wen = 1'b0;
        assign def_PRBS_INIT_1 = 'h0;       
        assign reg_68_01_rdata = 8'h0;        
    end

    if( NUM_LANES > 2)
    begin
        assign reg_68_10_wen = PRBS_INIT_2_RW == 1 && waddr[7:2] == 6'h1A ? be[2] & wr_en : 1'b0;
        assign def_PRBS_INIT_2 = PRBS_INIT_2_D;
        assign reg_68_10_rdata = reg_68_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_2_RW == 0 ? def_PRBS_INIT_2 : reg_PRBS_INIT_2 );
    end
    else
    begin
        assign reg_68_10_wen = 1'b0;
        assign def_PRBS_INIT_2 = 'h0;
        assign reg_68_10_rdata = 8'h0;
    end

    if( NUM_LANES > 3)
    begin
        assign reg_68_11_wen = PRBS_INIT_3_RW == 1 && waddr[7:2] == 6'h1A ? be[3] & wr_en : 1'b0;
        assign def_PRBS_INIT_3 = PRBS_INIT_3_D;
        assign reg_68_11_rdata = reg_68_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_3_RW == 0 ? def_PRBS_INIT_3 : reg_PRBS_INIT_3 );
    end
    else
    begin
        assign reg_68_11_wen = 1'b0;
        assign def_PRBS_INIT_3 = 'h0;
        assign reg_68_11_rdata = 8'h0;
    end

    if( NUM_LANES > 4)
    begin
        assign reg_6C_ren = raddr[7:2] == 6'h1B ? rd_en : 1'b0;
        assign reg_6C_00_wen = PRBS_INIT_4_RW == 1 && waddr[7:2] == 6'h1B ? be[0] & wr_en : 1'b0;
        assign def_PRBS_INIT_4 = PRBS_INIT_4_D;
        assign reg_6C_00_rdata = reg_6C_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_4_RW == 0 ? def_PRBS_INIT_4 : reg_PRBS_INIT_4 );
    end
    else
    begin
        assign reg_6C_ren = 1'b0;
        assign reg_6C_00_wen = 1'b0;
        assign def_PRBS_INIT_4 = 'h0;
        assign reg_6C_00_rdata = 8'h0;
    end

    if( NUM_LANES > 5)
    begin
        assign reg_6C_01_wen = PRBS_INIT_5_RW == 1 && waddr[7:2] == 6'h1B ? be[1] & wr_en : 1'b0;
        assign def_PRBS_INIT_5 = PRBS_INIT_5_D;
        assign reg_6C_01_rdata = reg_6C_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_5_RW == 0 ? def_PRBS_INIT_5 : reg_PRBS_INIT_5 );
    end
    else
    begin
        assign reg_6C_01_wen = 1'b0;
        assign def_PRBS_INIT_5 = 'h0;
        assign reg_6C_01_rdata = 8'h0;
    end

    if( NUM_LANES > 6)
    begin
        assign reg_6C_10_wen = PRBS_INIT_6_RW == 1 && waddr[7:2] == 6'h1B ? be[2] & wr_en : 1'b0;
        assign def_PRBS_INIT_6 = PRBS_INIT_6_D;
        assign reg_6C_10_rdata = reg_6C_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_6_RW == 0 ? def_PRBS_INIT_6 : reg_PRBS_INIT_6 );
    end
    else
    begin
        assign reg_6C_10_wen = 1'b0;
        assign def_PRBS_INIT_6 = 'h0;
        assign reg_6C_10_rdata = 8'h0;
    end

    if( NUM_LANES > 7)
    begin
        assign reg_6C_11_wen = PRBS_INIT_7_RW == 1 && waddr[7:2] == 6'h1B ? be[3] & wr_en : 1'b0;
        assign def_PRBS_INIT_7 = PRBS_INIT_7_D;
        assign reg_6C_11_rdata = reg_6C_ren == 1'b0 ? 8'h00 : ( PRBS_INIT_7_RW == 0 ? def_PRBS_INIT_7 : reg_PRBS_INIT_7 );
    end
    else
    begin
        assign reg_6C_11_wen = 1'b0;
        assign def_PRBS_INIT_7 = 'h0;
        assign reg_6C_11_rdata = 8'h0;
    end

    assign reg_08_ren = DPHY_RX_EN == 1 && raddr[7:2] == 6'h02 ? rd_en : 1'b0;
    assign def_RX_CAP_SKEW_CAL = RX_CAP_SKEW_CAL_D;
    assign def_RX_CAP_ALT_CAL = RX_CAP_ALT_CAL_D;
    assign def_RX_CAP_PREAMBLE = RX_CAP_PREAMBLE_D;
    assign def_RX_CAP_PERIODIC_SKEW_CAL = RX_CAP_PERIODIC_SKEW_CAL_D;
    assign def_RX_CAP_EQ_MODE = RX_CAP_EQ_MODE_D;
    assign reg_08_00_rdata = reg_08_ren == 1'b0 ? 8'h00 : 
            { {(7 - RX_CAP_EQ_MODE_BI_H){1'b0} },
            def_RX_CAP_EQ_MODE,
            def_RX_CAP_PERIODIC_SKEW_CAL,
            def_RX_CAP_PREAMBLE,
            def_RX_CAP_ALT_CAL,
            def_RX_CAP_SKEW_CAL};

    assign reg_10_10_rdata = reg_10_ren == 1'b0 ? 8'h00 : reg_RX_DLANE_ERR;
    if( NUM_LANES > 0)
        assign reg_RX_DLANE_ERR[0] =  reg_RX_DLANE_ERR_CAL_ERR[0] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[0] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[0] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[0] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[0] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[0] |
                                       reg_RX_DLANE_ERR_SOT_ERR[0];
    else
        assign reg_RX_DLANE_ERR[0] = 1'b0;

    if( NUM_LANES > 1)
        assign reg_RX_DLANE_ERR[1] =  reg_RX_DLANE_ERR_CAL_ERR[1] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[1] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[1] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[1] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[1] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[1] |
                                       reg_RX_DLANE_ERR_SOT_ERR[1];
    else
        assign reg_RX_DLANE_ERR[1] = 1'b0;

    if( NUM_LANES > 2)
        assign reg_RX_DLANE_ERR[2] =  reg_RX_DLANE_ERR_CAL_ERR[2] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[2] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[2] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[2] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[2] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[2] |
                                       reg_RX_DLANE_ERR_SOT_ERR[2];
    else
        assign reg_RX_DLANE_ERR[2] = 1'b0;

    if( NUM_LANES > 3)
        assign reg_RX_DLANE_ERR[3] =  reg_RX_DLANE_ERR_CAL_ERR[3] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[3] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[3] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[3] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[3] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[3] |
                                       reg_RX_DLANE_ERR_SOT_ERR[3];
    else
        assign reg_RX_DLANE_ERR[3] = 1'b0;

    if( NUM_LANES > 4)
        assign reg_RX_DLANE_ERR[4] =  reg_RX_DLANE_ERR_CAL_ERR[4] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[4] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[4] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[4] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[4] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[4] |
                                       reg_RX_DLANE_ERR_SOT_ERR[4];
    else
        assign reg_RX_DLANE_ERR[4] = 1'b0;

    if( NUM_LANES > 5)
        assign reg_RX_DLANE_ERR[5] =  reg_RX_DLANE_ERR_CAL_ERR[5] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[5] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[5] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[5] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[5] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[5] |
                                       reg_RX_DLANE_ERR_SOT_ERR[5];
    else
        assign reg_RX_DLANE_ERR[5] = 1'b0;

    if( NUM_LANES > 6)
        assign reg_RX_DLANE_ERR[6] =  reg_RX_DLANE_ERR_CAL_ERR[6] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[6] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[6] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[6] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[6] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[6] |
                                       reg_RX_DLANE_ERR_SOT_ERR[6];
    else
        assign reg_RX_DLANE_ERR[6] = 1'b0;

    if( NUM_LANES > 7)
        assign reg_RX_DLANE_ERR[7] =  reg_RX_DLANE_ERR_CAL_ERR[7] |
                                       reg_RX_DLANE_ERR_CTRL_ERR[7] |
                                       reg_RX_DLANE_ERR_LPDT_ERR[7] |
                                       reg_RX_DLANE_ERR_ESC_ENTRY_ERR[7] |
                                       reg_RX_DLANE_ERR_EOT_SYNC_ERR[7] |
                                       reg_RX_DLANE_ERR_SOT_SYNC_ERR[7] |
                                       reg_RX_DLANE_ERR_SOT_ERR[7];
    else
        assign reg_RX_DLANE_ERR[7] = 1'b0;

    assign reg_20_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_0_RW == 1 && waddr[7:2] == 6'h08 ? be[2] & wr_en : 1'b0;
    assign def_RX_DLANE_DESKEW_DELAY_0 = RX_DLANE_DESKEW_DELAY_0_D;
    assign reg_20_10_rdata = reg_20_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_0_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_0_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_0  } : { {(8 - RX_DLANE_DESKEW_DELAY_0_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_0  } );
    assign reg_20_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h08 ? be[3] & wr_en : 1'b0;
    assign reg_20_11_rdata = reg_20_ren == 1'b0 ? 8'h00 : 
            { {(7 - RX_DLANE_ERR_0_CAL_ERR_BI){1'b0} },
            reg_RX_DLANE_ERR_CAL_ERR[0],
            reg_RX_DLANE_ERR_CTRL_ERR[0],
            reg_RX_DLANE_ERR_LPDT_ERR[0],
            reg_RX_DLANE_ERR_ESC_ENTRY_ERR[0],
            reg_RX_DLANE_ERR_EOT_SYNC_ERR[0],
            reg_RX_DLANE_ERR_SOT_SYNC_ERR[0],
            reg_RX_DLANE_ERR_SOT_ERR[0]};

    if( NUM_LANES > 1)
    begin
        assign reg_24_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_1_RW == 1 && waddr[7:2] == 6'h09 ? be[2] & wr_en : 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_1 = RX_DLANE_DESKEW_DELAY_1_D;
        assign reg_24_10_rdata = reg_24_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_1_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_1_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_1  } : { {(8 - RX_DLANE_DESKEW_DELAY_1_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_1  } );
    end
    else
    begin
        assign reg_24_10_wen = 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_1 = 'h0;       
        assign reg_24_10_rdata = 8'h0;
    end

    if( NUM_LANES > 1)
    begin
        assign reg_24_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h09 ? be[3] & wr_en : 1'b0;
        assign reg_24_11_rdata = reg_24_ren == 1'b0 ? 8'h00 : 
                { {(7 - RX_DLANE_ERR_1_CAL_ERR_BI){1'b0} },
                reg_RX_DLANE_ERR_CAL_ERR[1],
                reg_RX_DLANE_ERR_CTRL_ERR[1],
                reg_RX_DLANE_ERR_LPDT_ERR[1],
                reg_RX_DLANE_ERR_ESC_ENTRY_ERR[1],
                reg_RX_DLANE_ERR_EOT_SYNC_ERR[1],
                reg_RX_DLANE_ERR_SOT_SYNC_ERR[1],
                reg_RX_DLANE_ERR_SOT_ERR[1]};

    end
    else
    begin
        assign reg_24_11_wen = 1'b0;
        assign reg_24_11_rdata = 8'h0;
    end

    if( NUM_LANES > 2)
    begin
        assign reg_28_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_2_RW == 1 && waddr[7:2] == 6'h0A ? be[2] & wr_en : 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_2 = RX_DLANE_DESKEW_DELAY_2_D;
        assign reg_28_10_rdata = reg_28_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_2_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_2_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_2  } : { {(8 - RX_DLANE_DESKEW_DELAY_2_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_2  } );
    end
    else
    begin
        assign reg_28_10_wen = 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_2 = 'h0;
        assign reg_28_10_rdata = 8'h0;
    end

    if( NUM_LANES > 2)
    begin
        assign reg_28_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h0A ? be[3] & wr_en : 1'b0;
        assign reg_28_11_rdata = reg_28_ren == 1'b0 ? 8'h00 : 
                { {(7 - RX_DLANE_ERR_2_CAL_ERR_BI){1'b0} },
                reg_RX_DLANE_ERR_CAL_ERR[2],
                reg_RX_DLANE_ERR_CTRL_ERR[2],
                reg_RX_DLANE_ERR_LPDT_ERR[2],
                reg_RX_DLANE_ERR_ESC_ENTRY_ERR[2],
                reg_RX_DLANE_ERR_EOT_SYNC_ERR[2],
                reg_RX_DLANE_ERR_SOT_SYNC_ERR[2],
                reg_RX_DLANE_ERR_SOT_ERR[2]};

    end
    else
    begin
        assign reg_28_11_wen = 1'b0;
        assign reg_28_11_rdata = 8'h0;
    end

    if( NUM_LANES > 3)
    begin
        assign reg_2C_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_3_RW == 1 && waddr[7:2] == 6'h0B ? be[2] & wr_en : 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_3 = RX_DLANE_DESKEW_DELAY_3_D;
        assign reg_2C_10_rdata = reg_2C_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_3_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_3_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_3  } : { {(8 - RX_DLANE_DESKEW_DELAY_3_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_3  } );
    end
    else
    begin
        assign reg_2C_10_wen = 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_3 = 'h0;
        assign reg_2C_10_rdata = 8'h0;
    end

    if( NUM_LANES > 3)
    begin
        assign reg_2C_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h0B ? be[3] & wr_en : 1'b0;
        assign reg_2C_11_rdata = reg_2C_ren == 1'b0 ? 8'h00 : 
                { {(7 - RX_DLANE_ERR_3_CAL_ERR_BI){1'b0} },
                reg_RX_DLANE_ERR_CAL_ERR[3],
                reg_RX_DLANE_ERR_CTRL_ERR[3],
                reg_RX_DLANE_ERR_LPDT_ERR[3],
                reg_RX_DLANE_ERR_ESC_ENTRY_ERR[3],
                reg_RX_DLANE_ERR_EOT_SYNC_ERR[3],
                reg_RX_DLANE_ERR_SOT_SYNC_ERR[3],
                reg_RX_DLANE_ERR_SOT_ERR[3]};

    end
    else
    begin
        assign reg_2C_11_wen = 1'b0;
        assign reg_2C_11_rdata = 8'h0;
    end

    if( NUM_LANES > 4)
    begin
        assign reg_30_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_4_RW == 1 && waddr[7:2] == 6'h0C ? be[2] & wr_en : 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_4 = RX_DLANE_DESKEW_DELAY_4_D;
        assign reg_30_10_rdata = reg_30_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_4_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_4_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_4  } : { {(8 - RX_DLANE_DESKEW_DELAY_4_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_4  } );
    end
    else
    begin
        assign reg_30_10_wen = 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_4 = 'h0;
        assign reg_30_10_rdata = 8'h0;
    end

    if( NUM_LANES > 4)
    begin
        assign reg_30_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h0C ? be[3] & wr_en : 1'b0;
        assign reg_30_11_rdata = reg_30_ren == 1'b0 ? 8'h00 : 
                { {(7 - RX_DLANE_ERR_4_CAL_ERR_BI){1'b0} },
                reg_RX_DLANE_ERR_CAL_ERR[4],
                reg_RX_DLANE_ERR_CTRL_ERR[4],
                reg_RX_DLANE_ERR_LPDT_ERR[4],
                reg_RX_DLANE_ERR_ESC_ENTRY_ERR[4],
                reg_RX_DLANE_ERR_EOT_SYNC_ERR[4],
                reg_RX_DLANE_ERR_SOT_SYNC_ERR[4],
                reg_RX_DLANE_ERR_SOT_ERR[4]};

    end
    else
    begin
        assign reg_30_11_wen = 1'b0;
        assign reg_30_11_rdata = 8'h0;
    end

    if( NUM_LANES > 5)
    begin
        assign reg_34_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_5_RW == 1 && waddr[7:2] == 6'h0D ? be[2] & wr_en : 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_5 = RX_DLANE_DESKEW_DELAY_5_D;
        assign reg_34_10_rdata = reg_34_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_5_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_5_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_5  } : { {(8 - RX_DLANE_DESKEW_DELAY_5_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_5  } );
    end
    else
    begin
        assign reg_34_10_wen = 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_5 = 'h0;
        assign reg_34_10_rdata = 8'h0;
    end

    if( NUM_LANES > 5)
    begin
        assign reg_34_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h0D ? be[3] & wr_en : 1'b0;
        assign reg_34_11_rdata = reg_34_ren == 1'b0 ? 8'h00 : 
                { {(7 - RX_DLANE_ERR_5_CAL_ERR_BI){1'b0} },
                reg_RX_DLANE_ERR_CAL_ERR[5],
                reg_RX_DLANE_ERR_CTRL_ERR[5],
                reg_RX_DLANE_ERR_LPDT_ERR[5],
                reg_RX_DLANE_ERR_ESC_ENTRY_ERR[5],
                reg_RX_DLANE_ERR_EOT_SYNC_ERR[5],
                reg_RX_DLANE_ERR_SOT_SYNC_ERR[5],
                reg_RX_DLANE_ERR_SOT_ERR[5]};

    end
    else
    begin
        assign reg_34_11_wen = 1'b0;
        assign reg_34_11_rdata = 8'h0;
    end

    if( NUM_LANES > 6)
    begin
        assign reg_38_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_6_RW == 1 && waddr[7:2] == 6'h0E ? be[2] & wr_en : 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_6 = RX_DLANE_DESKEW_DELAY_6_D;
        assign reg_38_10_rdata = reg_38_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_6_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_6_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_6  } : { {(8 - RX_DLANE_DESKEW_DELAY_6_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_6  } );
    end
    else
    begin
        assign reg_38_10_wen = 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_6 = 'h0;
        assign reg_38_10_rdata = 8'h0;
    end

    if( NUM_LANES > 6)
    begin
        assign reg_38_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h0E ? be[3] & wr_en : 1'b0;
        assign reg_38_11_rdata = reg_38_ren == 1'b0 ? 8'h00 : 
                { {(7 - RX_DLANE_ERR_6_CAL_ERR_BI){1'b0} },
                reg_RX_DLANE_ERR_CAL_ERR[6],
                reg_RX_DLANE_ERR_CTRL_ERR[6],
                reg_RX_DLANE_ERR_LPDT_ERR[6],
                reg_RX_DLANE_ERR_ESC_ENTRY_ERR[6],
                reg_RX_DLANE_ERR_EOT_SYNC_ERR[6],
                reg_RX_DLANE_ERR_SOT_SYNC_ERR[6],
                reg_RX_DLANE_ERR_SOT_ERR[6]};

    end
    else
    begin
        assign reg_38_11_wen = 1'b0;
        assign reg_38_11_rdata = 8'h0;
    end

    if( NUM_LANES > 7)
    begin
        assign reg_3C_10_wen = DPHY_RX_EN == 1 && RX_DLANE_DESKEW_DELAY_7_RW == 1 && waddr[7:2] == 6'h0F ? be[2] & wr_en : 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_7 = RX_DLANE_DESKEW_DELAY_7_D;
        assign reg_3C_10_rdata = reg_3C_ren == 1'b0 ? 8'h00 : ( RX_DLANE_DESKEW_DELAY_7_RW == 0 ? { {(8 - RX_DLANE_DESKEW_DELAY_7_W){ 1'b0 } }, def_RX_DLANE_DESKEW_DELAY_7  } : { {(8 - RX_DLANE_DESKEW_DELAY_7_W){ 1'b0 } }, reg_RX_DLANE_DESKEW_DELAY_7  } );
    end
    else
    begin
        assign reg_3C_10_wen = 1'b0;
        assign def_RX_DLANE_DESKEW_DELAY_7 = 'h0;
        assign reg_3C_10_rdata = 8'h0;
    end

    if( NUM_LANES > 7)
    begin
        assign reg_3C_11_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h0F ? be[3] & wr_en : 1'b0;
        assign reg_3C_11_rdata = reg_3C_ren == 1'b0 ? 8'h00 : 
                { {(7 - RX_DLANE_ERR_7_CAL_ERR_BI){1'b0} },
                reg_RX_DLANE_ERR_CAL_ERR[7],
                reg_RX_DLANE_ERR_CTRL_ERR[7],
                reg_RX_DLANE_ERR_LPDT_ERR[7],
                reg_RX_DLANE_ERR_ESC_ENTRY_ERR[7],
                reg_RX_DLANE_ERR_EOT_SYNC_ERR[7],
                reg_RX_DLANE_ERR_SOT_SYNC_ERR[7],
                reg_RX_DLANE_ERR_SOT_ERR[7]};

    end
    else
    begin
        assign reg_3C_11_wen = 1'b0;
        assign reg_3C_11_rdata = 8'h0;
    end

    assign reg_50_ren = DPHY_RX_EN == 1 && raddr[7:2] == 6'h14 ? rd_en : 1'b0;
    assign reg_50_00_wen = DPHY_RX_EN == 1 && RX_CLK_LOSS_DETECT_RW == 1 && waddr[7:2] == 6'h14 ? be[0] & wr_en : 1'b0;
    assign def_RX_CLK_LOSS_DETECT = RX_CLK_LOSS_DETECT_USE_AUTO == 0 ? RX_CLK_LOSS_DETECT_D : RX_CLK_LOSS_DETECT_AUTO;
    assign reg_50_00_rdata = reg_50_ren == 1'b0 ? 8'h00 : ( RX_CLK_LOSS_DETECT_RW == 0 ? def_RX_CLK_LOSS_DETECT : reg_RX_CLK_LOSS_DETECT );
    assign reg_50_01_wen = DPHY_RX_EN == 1 && RX_CLK_SETTLE_RW == 1 && waddr[7:2] == 6'h14 ? be[1] & wr_en : 1'b0;
    assign def_RX_CLK_SETTLE = RX_CLK_SETTLE_USE_AUTO == 0 ? RX_CLK_SETTLE_D : RX_CLK_SETTLE_AUTO;
    assign reg_50_01_rdata = reg_50_ren == 1'b0 ? 8'h00 : ( RX_CLK_SETTLE_RW == 0 ? def_RX_CLK_SETTLE : reg_RX_CLK_SETTLE );
    assign reg_50_10_wen = DPHY_RX_EN == 1 && RX_HS_SETTLE_RW == 1 && waddr[7:2] == 6'h14 ? be[2] & wr_en : 1'b0;
    assign def_RX_HS_SETTLE = RX_HS_SETTLE_USE_AUTO == 0 ? RX_HS_SETTLE_D : RX_HS_SETTLE_AUTO;
    assign reg_50_10_rdata = reg_50_ren == 1'b0 ? 8'h00 : ( RX_HS_SETTLE_RW == 0 ? def_RX_HS_SETTLE : reg_RX_HS_SETTLE );
    assign reg_54_ren = DPHY_RX_EN == 1 && raddr[7:2] == 6'h15 ? rd_en : 1'b0;
    assign reg_54_00_wen = DPHY_RX_EN == 1 && RX_INIT_RW == 1 && waddr[7:2] == 6'h15 ? be[0] & wr_en : 1'b0;
    assign def_RX_INIT = RX_INIT_USE_AUTO == 0 ? RX_INIT_D : RX_INIT_AUTO;
    assign reg_54_00_rdata = reg_54_ren == 1'b0 ? 8'h00 : ( RX_INIT_RW == 0 ? def_RX_INIT : reg_RX_INIT );
    assign reg_54_01_wen = DPHY_RX_EN == 1 && RX_CLK_POST_RW == 1 && waddr[7:2] == 6'h15 ? be[1] & wr_en : 1'b0;
    assign def_RX_CLK_POST = RX_CLK_POST_USE_AUTO == 0 ? RX_CLK_POST_D : RX_CLK_POST_AUTO;
    assign reg_54_01_rdata = reg_54_ren == 1'b0 ? 8'h00 : ( RX_CLK_POST_RW == 0 ? def_RX_CLK_POST : reg_RX_CLK_POST );
    assign reg_60_ren = DPHY_RX_EN == 1 && raddr[7:2] == 6'h18 ? rd_en : 1'b0;
    assign reg_60_00_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h18 ? be[0] & wr_en : 1'b0;
    assign reg_60_00_rdata = reg_60_ren == 1'b0 ? 8'h00 : 
            { {(7 - RX_CAL_REG_CTRL_CAL_RESET_BI){1'b0} },
            reg_RX_CAL_REG_CTRL_CAL_RESET ^ clr_RX_CAL_REG_CTRL_CAL_RESET_tog,
            reg_RX_CAL_REG_CTRL_CAL_REG_MUXSEL};

    assign reg_60_01_rdata = reg_60_ren == 1'b0 ? 8'h00 : 
            { {(7 - RX_CAL_STATUS_DPHY_ALT_CAL_ERR_BI){1'b0} },
            sig_RX_CAL_STATUS_DPHY_ALT_CAL_ERR,
            sig_RX_CAL_STATUS_DPHY_PER_SKEW_CAL_ERR,
            sig_RX_CAL_STATUS_DPHY_INIT_SKEW_CAL_ERR,
            sig_RX_CAL_STATUS_DPHY_ALT_CAL_DONE,
            sig_RX_CAL_STATUS_DPHY_SKEW_CAL_DONE};

    assign reg_60_10_rdata = reg_60_ren == 1'b0 ? 8'h00 : sig_RX_CAL_SKEW_W_START_MUX;
    assign reg_60_11_rdata = reg_60_ren == 1'b0 ? 8'h00 : sig_RX_CAL_SKEW_W_END_MUX;
    assign reg_64_ren = DPHY_RX_EN == 1 && raddr[7:2] == 6'h19 ? rd_en : 1'b0;
    assign reg_64_00_rdata = reg_64_ren == 1'b0 ? 8'h00 : sig_RX_CAL_ALT_W_START_MUX;
    assign reg_64_01_rdata = reg_64_ren == 1'b0 ? 8'h00 : sig_RX_CAL_ALT_W_END_MUX;
    assign reg_64_10_rdata = reg_64_ren == 1'b0 ? 8'h00 : { {(8 - RX_DESKEW_DELAY_MUX_W){ 1'b0 } }, sig_RX_DESKEW_DELAY_MUX  };
    assign reg_64_11_rdata = reg_64_ren == 1'b0 ? 8'h00 : 
            { {(7 - RX_CAL_STATUS_LANE_MUX_ALT_CAL_ERR_LANE_BI){1'b0} },
            sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_ERR_LANE,
            sig_RX_CAL_STATUS_LANE_MUX_PER_SKEW_CAL_ERR_LANE,
            sig_RX_CAL_STATUS_LANE_MUX_INIT_SKEW_CAL_ERR_LANE,
            sig_RX_CAL_STATUS_LANE_MUX_ALT_CAL_DONE_LANE,
            sig_RX_CAL_STATUS_LANE_MUX_SKEW_CAL_DONE_LANE};

    assign reg_78_ren = DPHY_RX_EN == 1 && raddr[7:2] == 6'h1E ? rd_en : 1'b0;
    assign reg_78_00_wen = DPHY_RX_EN == 1 && waddr[7:2] == 6'h1E ? be[0] & wr_en : 1'b0;
    assign reg_78_00_rdata = reg_78_ren == 1'b0 ? 8'h00 : 
            { {(7 - RX_TM_CONTROL_RX_TST_CNT_RST_BI){1'b0} },
            reg_RX_TM_CONTROL_RX_TST_CNT_RST ^ clr_RX_TM_CONTROL_RX_TST_CNT_RST_tog,
            reg_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE,
            reg_RX_TM_CONTROL_RX_TM_EN};

    assign reg_78_01_wen = DPHY_RX_EN == 1 && RX_PREP_TIME_TM_RW == 1 && waddr[7:2] == 6'h1E ? be[1] & wr_en : 1'b0;
    assign def_RX_PREP_TIME_TM = RX_PREP_TIME_TM_D;
    assign reg_78_01_rdata = reg_78_ren == 1'b0 ? 8'h00 : ( RX_PREP_TIME_TM_RW == 0 ? def_RX_PREP_TIME_TM : reg_RX_PREP_TIME_TM );
    assign reg_7C_ren = DPHY_RX_EN == 1 && raddr[7:2] == 6'h1F ? rd_en : 1'b0;
    assign reg_7C_00_rdata = reg_7C_ren == 1'b0 ? 8'h00 : sig_RX_BER_CNT_B0_MUX;
    assign reg_7C_01_rdata = reg_7C_ren == 1'b0 ? 8'h00 : sig_RX_BER_CNT_B1_MUX;
    assign reg_7C_10_rdata = reg_7C_ren == 1'b0 ? 8'h00 : sig_RX_BER_CNT_B2_MUX;
    assign reg_7C_11_rdata = reg_7C_ren == 1'b0 ? 8'h00 : sig_RX_BER_CNT_B3_MUX;
    assign reg_0C_ren = DPHY_TX_EN == 1 && raddr[7:2] == 6'h03 ? rd_en : 1'b0;
    assign def_TX_CAP_SKEW_CAL = TX_CAP_SKEW_CAL_D;
    assign def_TX_CAP_ALT_CAL = TX_CAP_ALT_CAL_D;
    assign def_TX_CAP_PREAMBLE = TX_CAP_PREAMBLE_D;
    assign def_TX_CAP_EQ_MODE = TX_CAP_EQ_MODE_D;
    assign reg_0C_00_rdata = reg_0C_ren == 1'b0 ? 8'h00 : 
            { {(7 - TX_CAP_EQ_MODE_BI_H){1'b0} },
            def_TX_CAP_EQ_MODE,
            def_TX_CAP_PREAMBLE,
            def_TX_CAP_ALT_CAL,
            def_TX_CAP_SKEW_CAL};

    assign reg_0C_01_wen = DPHY_TX_EN == 1 && waddr[7:2] == 6'h03 ? be[1] & wr_en : 1'b0;
    assign reg_0C_01_rdata = reg_0C_ren == 1'b0 ? 8'h00 : 
            { {(7 - TX_PREAMBLE_LEN_PREAMLBE_LEN_BI_H){1'b0} },
            reg_TX_PREAMBLE_LEN_PREAMLBE_LEN,
            reg_TX_PREAMBLE_LEN_PREAMBLE_EN};

    assign def_TX_CLK_LANE_PS = TX_CLK_LANE_PS_D;
    assign reg_10_01_rdata = reg_10_ren == 1'b0 ? 8'h00 : { {(8 - TX_CLK_LANE_PS_W){ 1'b0 } }, def_TX_CLK_LANE_PS  };
    assign reg_40_ren = DPHY_TX_EN == 1 && raddr[7:2] == 6'h10 ? rd_en : 1'b0;
    assign reg_40_00_wen = DPHY_TX_EN == 1 && TX_LPX_RW == 1 && waddr[7:2] == 6'h10 ? be[0] & wr_en : 1'b0;
    assign def_TX_LPX = TX_LPX_USE_AUTO == 0 ? TX_LPX_D : TX_LPX_AUTO;
    assign reg_40_00_rdata = reg_40_ren == 1'b0 ? 8'h00 : ( TX_LPX_RW == 0 ? { {(8 - TX_LPX_W){ 1'b0 } }, def_TX_LPX  } : { {(8 - TX_LPX_W){ 1'b0 } }, reg_TX_LPX  } );
    assign reg_40_01_wen = DPHY_TX_EN == 1 && TX_HS_EXIT_RW == 1 && waddr[7:2] == 6'h10 ? be[1] & wr_en : 1'b0;
    assign def_TX_HS_EXIT = TX_HS_EXIT_USE_AUTO == 0 ? TX_HS_EXIT_D : TX_HS_EXIT_AUTO;
    assign reg_40_01_rdata = reg_40_ren == 1'b0 ? 8'h00 : ( TX_HS_EXIT_RW == 0 ? def_TX_HS_EXIT : reg_TX_HS_EXIT );
    assign reg_40_10_wen = DPHY_TX_EN == 1 && TX_LP_EXIT_RW == 1 && waddr[7:2] == 6'h10 ? be[2] & wr_en : 1'b0;
    assign def_TX_LP_EXIT = TX_LP_EXIT_USE_AUTO == 0 ? TX_LP_EXIT_D : TX_LP_EXIT_AUTO;
    assign reg_40_10_rdata = reg_40_ren == 1'b0 ? 8'h00 : ( TX_LP_EXIT_RW == 0 ? def_TX_LP_EXIT : reg_TX_LP_EXIT );
    assign reg_44_ren = DPHY_TX_EN == 1 && raddr[7:2] == 6'h11 ? rd_en : 1'b0;
    assign reg_44_00_wen = DPHY_TX_EN == 1 && TX_CLK_PREPARE_RW == 1 && waddr[7:2] == 6'h11 ? be[0] & wr_en : 1'b0;
    assign def_TX_CLK_PREPARE = TX_CLK_PREPARE_USE_AUTO == 0 ? TX_CLK_PREPARE_D : TX_CLK_PREPARE_AUTO;
    assign reg_44_00_rdata = reg_44_ren == 1'b0 ? 8'h00 : ( TX_CLK_PREPARE_RW == 0 ? { {(8 - TX_CLK_PREPARE_W){ 1'b0 } }, def_TX_CLK_PREPARE  } : { {(8 - TX_CLK_PREPARE_W){ 1'b0 } }, reg_TX_CLK_PREPARE  } );
    assign reg_44_01_wen = DPHY_TX_EN == 1 && TX_CLK_TRAIL_RW == 1 && waddr[7:2] == 6'h11 ? be[1] & wr_en : 1'b0;
    assign def_TX_CLK_TRAIL = TX_CLK_TRAIL_USE_AUTO == 0 ? TX_CLK_TRAIL_D : TX_CLK_TRAIL_AUTO;
    assign reg_44_01_rdata = reg_44_ren == 1'b0 ? 8'h00 : ( TX_CLK_TRAIL_RW == 0 ? { {(8 - TX_CLK_TRAIL_W){ 1'b0 } }, def_TX_CLK_TRAIL  } : { {(8 - TX_CLK_TRAIL_W){ 1'b0 } }, reg_TX_CLK_TRAIL  } );
    assign reg_44_10_wen = DPHY_TX_EN == 1 && TX_CLK_ZERO_RW == 1 && waddr[7:2] == 6'h11 ? be[2] & wr_en : 1'b0;
    assign def_TX_CLK_ZERO = TX_CLK_ZERO_USE_AUTO == 0 ? TX_CLK_ZERO_D : TX_CLK_ZERO_AUTO;
    assign reg_44_10_rdata = reg_44_ren == 1'b0 ? 8'h00 : ( TX_CLK_ZERO_RW == 0 ? { {(8 - TX_CLK_ZERO_W){ 1'b0 } }, def_TX_CLK_ZERO  } : { {(8 - TX_CLK_ZERO_W){ 1'b0 } }, reg_TX_CLK_ZERO  } );
    assign reg_44_11_wen = DPHY_TX_EN == 1 && TX_CLK_POST_RW == 1 && waddr[7:2] == 6'h11 ? be[3] & wr_en : 1'b0;
    assign def_TX_CLK_POST = TX_CLK_POST_USE_AUTO == 0 ? TX_CLK_POST_D : TX_CLK_POST_AUTO;
    assign reg_44_11_rdata = reg_44_ren == 1'b0 ? 8'h00 : ( TX_CLK_POST_RW == 0 ? def_TX_CLK_POST : reg_TX_CLK_POST );
    assign reg_48_ren = DPHY_TX_EN == 1 && raddr[7:2] == 6'h12 ? rd_en : 1'b0;
    assign reg_48_00_wen = DPHY_TX_EN == 1 && TX_CLK_PRE_RW == 1 && waddr[7:2] == 6'h12 ? be[0] & wr_en : 1'b0;
    assign def_TX_CLK_PRE = TX_CLK_PRE_USE_AUTO == 0 ? TX_CLK_PRE_D : TX_CLK_PRE_AUTO;
    assign reg_48_00_rdata = reg_48_ren == 1'b0 ? 8'h00 : ( TX_CLK_PRE_RW == 0 ? { {(8 - TX_CLK_PRE_W){ 1'b0 } }, def_TX_CLK_PRE  } : { {(8 - TX_CLK_PRE_W){ 1'b0 } }, reg_TX_CLK_PRE  } );
    assign reg_48_01_wen = DPHY_TX_EN == 1 && TX_HS_PREPARE_RW == 1 && waddr[7:2] == 6'h12 ? be[1] & wr_en : 1'b0;
    assign def_TX_HS_PREPARE = TX_HS_PREPARE_USE_AUTO == 0 ? TX_HS_PREPARE_D : TX_HS_PREPARE_AUTO;
    assign reg_48_01_rdata = reg_48_ren == 1'b0 ? 8'h00 : ( TX_HS_PREPARE_RW == 0 ? { {(8 - TX_HS_PREPARE_W){ 1'b0 } }, def_TX_HS_PREPARE  } : { {(8 - TX_HS_PREPARE_W){ 1'b0 } }, reg_TX_HS_PREPARE  } );
    assign reg_48_10_wen = DPHY_TX_EN == 1 && TX_HS_ZERO_RW == 1 && waddr[7:2] == 6'h12 ? be[2] & wr_en : 1'b0;
    assign def_TX_HS_ZERO = TX_HS_ZERO_USE_AUTO == 0 ? TX_HS_ZERO_D : TX_HS_ZERO_AUTO;
    assign reg_48_10_rdata = reg_48_ren == 1'b0 ? 8'h00 : ( TX_HS_ZERO_RW == 0 ? def_TX_HS_ZERO : reg_TX_HS_ZERO );
    assign reg_4C_ren = DPHY_TX_EN == 1 && raddr[7:2] == 6'h13 ? rd_en : 1'b0;
    assign reg_4C_00_wen = DPHY_TX_EN == 1 && TX_HS_TRAIL_RW == 1 && waddr[7:2] == 6'h13 ? be[0] & wr_en : 1'b0;
    assign def_TX_HS_TRAIL = TX_HS_TRAIL_USE_AUTO == 0 ? TX_HS_TRAIL_D : TX_HS_TRAIL_AUTO;
    assign reg_4C_00_rdata = reg_4C_ren == 1'b0 ? 8'h00 : ( TX_HS_TRAIL_RW == 0 ? def_TX_HS_TRAIL : reg_TX_HS_TRAIL );
    assign reg_4C_10_wen = DPHY_TX_EN == 1 && TX_INIT_RW == 1 && waddr[7:2] == 6'h13 ? be[2] & wr_en : 1'b0;
    assign def_TX_INIT = TX_INIT_USE_AUTO == 0 ? TX_INIT_D : TX_INIT_AUTO;
    assign reg_4C_10_rdata = reg_4C_ren == 1'b0 ? 8'h00 : ( TX_INIT_RW == 0 ? def_TX_INIT : reg_TX_INIT );
    assign reg_4C_11_wen = DPHY_TX_EN == 1 && TX_WAKE_RW == 1 && waddr[7:2] == 6'h13 ? be[3] & wr_en : 1'b0;
    assign def_TX_WAKE = TX_WAKE_USE_AUTO == 0 ? TX_WAKE_D : TX_WAKE_AUTO;
    assign reg_4C_11_rdata = reg_4C_ren == 1'b0 ? 8'h00 : ( TX_WAKE_RW == 0 ? def_TX_WAKE : reg_TX_WAKE );
    assign reg_70_ren = DPHY_TX_EN == 1 && raddr[7:2] == 6'h1C ? rd_en : 1'b0;
    assign reg_70_00_wen = DPHY_TX_EN == 1 && waddr[7:2] == 6'h1C ? be[0] & wr_en : 1'b0;
    assign reg_70_00_rdata = reg_70_ren == 1'b0 ? 8'h00 : 
            { {(7 - TX_TM_CONTROL_TX_TST_CNT_RST_BI){1'b0} },
            reg_TX_TM_CONTROL_TX_TST_CNT_RST ^ clr_TX_TM_CONTROL_TX_TST_CNT_RST_tog,
            reg_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE,
            reg_TX_TM_CONTROL_TX_TM_EN};

    assign reg_70_01_wen = DPHY_TX_EN == 1 && TX_HS_TM_DESKEW_P_RW == 1 && waddr[7:2] == 6'h1C ? be[1] & wr_en : 1'b0;
    assign def_TX_HS_TM_DESKEW_P = TX_HS_TM_DESKEW_P_D;
    assign reg_70_01_rdata = reg_70_ren == 1'b0 ? 8'h00 : ( TX_HS_TM_DESKEW_P_RW == 0 ? def_TX_HS_TM_DESKEW_P : reg_TX_HS_TM_DESKEW_P );
    assign reg_70_10_wen = DPHY_TX_EN == 1 && waddr[7:2] == 6'h1C ? be[2] & wr_en : 1'b0;
    assign reg_70_10_rdata = reg_70_ren == 1'b0 ? 8'h00 : 
            { reg_TX_MNL_IO_0_HS_DAT_CK,
            reg_TX_MNL_IO_0_HS_DAT_D,
            reg_TX_MNL_IO_0_LP_DAT,
            reg_TX_MNL_IO_0_CLK_LP_EN,
            reg_TX_MNL_IO_0_CTRL_EN};

    assign reg_70_11_wen = DPHY_TX_EN == 1 && waddr[7:2] == 6'h1C ? be[3] & wr_en : 1'b0;
    assign reg_70_11_rdata = reg_70_ren == 1'b0 ? 8'h00 : reg_TX_MNL_D_LP_EN;
    assign reg_74_ren = DPHY_TX_EN == 1 && raddr[7:2] == 6'h1D ? rd_en : 1'b0;
    assign reg_74_00_rdata = reg_74_ren == 1'b0 ? 8'h00 : sig_TX_WORD_COUNT_B0_MUX;
    assign reg_74_01_rdata = reg_74_ren == 1'b0 ? 8'h00 : sig_TX_WORD_COUNT_B1_MUX;
    assign reg_74_10_rdata = reg_74_ren == 1'b0 ? 8'h00 : sig_TX_WORD_COUNT_B2_MUX;
    assign reg_74_11_rdata = reg_74_ren == 1'b0 ? 8'h00 : sig_TX_WORD_COUNT_B3_MUX;

        always @(posedge clk)
        begin
            if(srst_n == 1'b0)
                begin
                    reg_DPHY_CSR_Enable <= 1'h1;
                    reg_CLK_CSR_CLK_LANE_EN <= 1'h1;
                    reg_DLANE_CSR_EN[0] <= DLANE_CSR_0_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[0] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[0] <= 1'h0;
                    reg_DLANE_CSR_EN[1] <= DLANE_CSR_1_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[1] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[1] <= 1'h0;
                    reg_DLANE_CSR_EN[2] <= DLANE_CSR_2_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[2] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[2] <= 1'h0;
                    reg_DLANE_CSR_EN[3] <= DLANE_CSR_3_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[3] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[3] <= 1'h0;
                    reg_DLANE_CSR_EN[4] <= DLANE_CSR_4_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[4] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[4] <= 1'h0;
                    reg_DLANE_CSR_EN[5] <= DLANE_CSR_5_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[5] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[5] <= 1'h0;
                    reg_DLANE_CSR_EN[6] <= DLANE_CSR_6_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[6] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[6] <= 1'h0;
                    reg_DLANE_CSR_EN[7] <= DLANE_CSR_7_EN_D;
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[7] <= 1'h0;
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[7] <= 1'h0;
                    reg_PRBS_INIT_0 <= def_PRBS_INIT_0;
                    reg_PRBS_INIT_1 <= def_PRBS_INIT_1;
                    reg_PRBS_INIT_2 <= def_PRBS_INIT_2;
                    reg_PRBS_INIT_3 <= def_PRBS_INIT_3;
                    reg_PRBS_INIT_4 <= def_PRBS_INIT_4;
                    reg_PRBS_INIT_5 <= def_PRBS_INIT_5;
                    reg_PRBS_INIT_6 <= def_PRBS_INIT_6;
                    reg_PRBS_INIT_7 <= def_PRBS_INIT_7;
                end
                else
                begin
                    reg_DPHY_CSR_Enable <= reg_10_00_wen == 1'b1 ? din[0 + DPHY_CSR_Enable_BI] : reg_DPHY_CSR_Enable;
                    reg_CLK_CSR_CLK_LANE_EN <= reg_1C_00_wen == 1'b1 ? din[0 + CLK_CSR_CLK_LANE_EN_BI] : reg_CLK_CSR_CLK_LANE_EN;
                    reg_DLANE_CSR_EN[0] <= reg_20_00_wen == 1'b1 ? din[0 + DLANE_CSR_0_EN_BI] : reg_DLANE_CSR_EN[0];
                    reg_DLANE_CSR_RX_DESKEW_UPDATE[0] <= ( reg_20_00_wen & din[0 + DLANE_CSR_0_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[0] : reg_DLANE_CSR_RX_DESKEW_UPDATE[0];
                    reg_DLANE_CSR_RX_MNL_DESKEW_EN[0] <= reg_20_00_wen == 1'b1 ? din[0 + DLANE_CSR_0_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[0];
                    if( NUM_LANES > 1)
                    begin
                        reg_DLANE_CSR_EN[1] <= reg_24_00_wen == 1'b1 ? din[0 + DLANE_CSR_1_EN_BI] : reg_DLANE_CSR_EN[1];
                        reg_DLANE_CSR_RX_DESKEW_UPDATE[1] <= ( reg_24_00_wen & din[0 + DLANE_CSR_1_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[1] : reg_DLANE_CSR_RX_DESKEW_UPDATE[1];
                        reg_DLANE_CSR_RX_MNL_DESKEW_EN[1] <= reg_24_00_wen == 1'b1 ? din[0 + DLANE_CSR_1_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[1];
                    end
                    if( NUM_LANES > 2)
                    begin
                        reg_DLANE_CSR_EN[2] <= reg_28_00_wen == 1'b1 ? din[0 + DLANE_CSR_2_EN_BI] : reg_DLANE_CSR_EN[2];
                        reg_DLANE_CSR_RX_DESKEW_UPDATE[2] <= ( reg_28_00_wen & din[0 + DLANE_CSR_2_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[2] : reg_DLANE_CSR_RX_DESKEW_UPDATE[2];
                        reg_DLANE_CSR_RX_MNL_DESKEW_EN[2] <= reg_28_00_wen == 1'b1 ? din[0 + DLANE_CSR_2_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[2];
                    end
                    if( NUM_LANES > 3)
                    begin
                        reg_DLANE_CSR_EN[3] <= reg_2C_00_wen == 1'b1 ? din[0 + DLANE_CSR_3_EN_BI] : reg_DLANE_CSR_EN[3];
                        reg_DLANE_CSR_RX_DESKEW_UPDATE[3] <= ( reg_2C_00_wen & din[0 + DLANE_CSR_3_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[3] : reg_DLANE_CSR_RX_DESKEW_UPDATE[3];
                        reg_DLANE_CSR_RX_MNL_DESKEW_EN[3] <= reg_2C_00_wen == 1'b1 ? din[0 + DLANE_CSR_3_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[3];
                    end
                    if( NUM_LANES > 4)
                    begin
                        reg_DLANE_CSR_EN[4] <= reg_30_00_wen == 1'b1 ? din[0 + DLANE_CSR_4_EN_BI] : reg_DLANE_CSR_EN[4];
                        reg_DLANE_CSR_RX_DESKEW_UPDATE[4] <= ( reg_30_00_wen & din[0 + DLANE_CSR_4_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[4] : reg_DLANE_CSR_RX_DESKEW_UPDATE[4];
                        reg_DLANE_CSR_RX_MNL_DESKEW_EN[4] <= reg_30_00_wen == 1'b1 ? din[0 + DLANE_CSR_4_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[4];
                    end
                    if( NUM_LANES > 5)
                    begin
                        reg_DLANE_CSR_EN[5] <= reg_34_00_wen == 1'b1 ? din[0 + DLANE_CSR_5_EN_BI] : reg_DLANE_CSR_EN[5];
                        reg_DLANE_CSR_RX_DESKEW_UPDATE[5] <= ( reg_34_00_wen & din[0 + DLANE_CSR_5_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[5] : reg_DLANE_CSR_RX_DESKEW_UPDATE[5];
                        reg_DLANE_CSR_RX_MNL_DESKEW_EN[5] <= reg_34_00_wen == 1'b1 ? din[0 + DLANE_CSR_5_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[5];
                    end
                    if( NUM_LANES > 6)
                    begin
                        reg_DLANE_CSR_EN[6] <= reg_38_00_wen == 1'b1 ? din[0 + DLANE_CSR_6_EN_BI] : reg_DLANE_CSR_EN[6];
                        reg_DLANE_CSR_RX_DESKEW_UPDATE[6] <= ( reg_38_00_wen & din[0 + DLANE_CSR_6_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[6] : reg_DLANE_CSR_RX_DESKEW_UPDATE[6];
                        reg_DLANE_CSR_RX_MNL_DESKEW_EN[6] <= reg_38_00_wen == 1'b1 ? din[0 + DLANE_CSR_6_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[6];
                    end
                    if( NUM_LANES > 7)
                    begin
                        reg_DLANE_CSR_EN[7] <= reg_3C_00_wen == 1'b1 ? din[0 + DLANE_CSR_7_EN_BI] : reg_DLANE_CSR_EN[7];
                        reg_DLANE_CSR_RX_DESKEW_UPDATE[7] <= ( reg_3C_00_wen & din[0 + DLANE_CSR_7_RX_DESKEW_UPDATE_BI] ) ? ~reg_DLANE_CSR_RX_DESKEW_UPDATE[7] : reg_DLANE_CSR_RX_DESKEW_UPDATE[7];
                        reg_DLANE_CSR_RX_MNL_DESKEW_EN[7] <= reg_3C_00_wen == 1'b1 ? din[0 + DLANE_CSR_7_RX_MNL_DESKEW_EN_BI] : reg_DLANE_CSR_RX_MNL_DESKEW_EN[7];
                    end
                    reg_PRBS_INIT_0 <= reg_68_00_wen == 1'b1 ? din[0 +: PRBS_INIT_0_W] : reg_PRBS_INIT_0;
                    if( NUM_LANES > 1)
                    begin
                        reg_PRBS_INIT_1 <= reg_68_01_wen == 1'b1 ? din[8 +: PRBS_INIT_1_W] : reg_PRBS_INIT_1;
                    end
                    if( NUM_LANES > 2)
                    begin
                        reg_PRBS_INIT_2 <= reg_68_10_wen == 1'b1 ? din[16 +: PRBS_INIT_2_W] : reg_PRBS_INIT_2;
                    end
                    if( NUM_LANES > 3)
                    begin
                        reg_PRBS_INIT_3 <= reg_68_11_wen == 1'b1 ? din[24 +: PRBS_INIT_3_W] : reg_PRBS_INIT_3;
                    end
                    if( NUM_LANES > 4)
                    begin
                        reg_PRBS_INIT_4 <= reg_6C_00_wen == 1'b1 ? din[0 +: PRBS_INIT_4_W] : reg_PRBS_INIT_4;
                    end
                    if( NUM_LANES > 5)
                    begin
                        reg_PRBS_INIT_5 <= reg_6C_01_wen == 1'b1 ? din[8 +: PRBS_INIT_5_W] : reg_PRBS_INIT_5;
                    end
                    if( NUM_LANES > 6)
                    begin
                        reg_PRBS_INIT_6 <= reg_6C_10_wen == 1'b1 ? din[16 +: PRBS_INIT_6_W] : reg_PRBS_INIT_6;
                    end
                    if( NUM_LANES > 7)
                    begin
                        reg_PRBS_INIT_7 <= reg_6C_11_wen == 1'b1 ? din[24 +: PRBS_INIT_7_W] : reg_PRBS_INIT_7;
                    end
                end
            end
    if(DPHY_RX_EN == 1)
    begin : DPHY_RX_reg_blk
        always @(posedge clk)
        begin
            if(srst_n == 1'b0)
                begin
                    reg_RX_DLANE_DESKEW_DELAY_0 <= def_RX_DLANE_DESKEW_DELAY_0;
                    reg_RX_DLANE_ERR_SOT_ERR[0] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[0] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[0] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[0] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[0] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[0] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[0] <= 1'h0;
                    reg_RX_DLANE_DESKEW_DELAY_1 <= def_RX_DLANE_DESKEW_DELAY_1;
                    reg_RX_DLANE_ERR_SOT_ERR[1] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[1] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[1] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[1] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[1] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[1] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[1] <= 1'h0;
                    reg_RX_DLANE_DESKEW_DELAY_2 <= def_RX_DLANE_DESKEW_DELAY_2;
                    reg_RX_DLANE_ERR_SOT_ERR[2] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[2] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[2] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[2] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[2] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[2] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[2] <= 1'h0;
                    reg_RX_DLANE_DESKEW_DELAY_3 <= def_RX_DLANE_DESKEW_DELAY_3;
                    reg_RX_DLANE_ERR_SOT_ERR[3] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[3] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[3] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[3] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[3] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[3] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[3] <= 1'h0;
                    reg_RX_DLANE_DESKEW_DELAY_4 <= def_RX_DLANE_DESKEW_DELAY_4;
                    reg_RX_DLANE_ERR_SOT_ERR[4] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[4] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[4] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[4] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[4] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[4] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[4] <= 1'h0;
                    reg_RX_DLANE_DESKEW_DELAY_5 <= def_RX_DLANE_DESKEW_DELAY_5;
                    reg_RX_DLANE_ERR_SOT_ERR[5] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[5] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[5] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[5] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[5] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[5] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[5] <= 1'h0;
                    reg_RX_DLANE_DESKEW_DELAY_6 <= def_RX_DLANE_DESKEW_DELAY_6;
                    reg_RX_DLANE_ERR_SOT_ERR[6] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[6] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[6] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[6] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[6] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[6] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[6] <= 1'h0;
                    reg_RX_DLANE_DESKEW_DELAY_7 <= def_RX_DLANE_DESKEW_DELAY_7;
                    reg_RX_DLANE_ERR_SOT_ERR[7] <= 1'h0;
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[7] <= 1'h0;
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[7] <= 1'h0;
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[7] <= 1'h0;
                    reg_RX_DLANE_ERR_LPDT_ERR[7] <= 1'h0;
                    reg_RX_DLANE_ERR_CTRL_ERR[7] <= 1'h0;
                    reg_RX_DLANE_ERR_CAL_ERR[7] <= 1'h0;
                    reg_RX_CLK_LOSS_DETECT <= def_RX_CLK_LOSS_DETECT;
                    reg_RX_CLK_SETTLE <= def_RX_CLK_SETTLE;
                    reg_RX_HS_SETTLE <= def_RX_HS_SETTLE;
                    reg_RX_INIT <= def_RX_INIT;
                    reg_RX_CLK_POST <= def_RX_CLK_POST;
                    reg_RX_CAL_REG_CTRL_CAL_REG_MUXSEL <= 3'h0;
                    reg_RX_CAL_REG_CTRL_CAL_RESET <= 1'h0;
                    reg_RX_TM_CONTROL_RX_TM_EN <= RX_TM_CONTROL_RX_TM_EN_D;
                    reg_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE <= RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_D;
                    reg_RX_TM_CONTROL_RX_TST_CNT_RST <= 1'h0;
                    reg_RX_PREP_TIME_TM <= def_RX_PREP_TIME_TM;
                end
                else
                begin
                    reg_RX_DLANE_DESKEW_DELAY_0 <= reg_20_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_0_W] : reg_RX_DLANE_DESKEW_DELAY_0;
                    reg_RX_DLANE_ERR_SOT_ERR[0] <= set_RX_DLANE_ERR_SOT_ERR_pulse[0] | ( ~( reg_20_11_wen & din[24 + RX_DLANE_ERR_0_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[0]);
                    reg_RX_DLANE_ERR_SOT_SYNC_ERR[0] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[0] | ( ~( reg_20_11_wen & din[24 + RX_DLANE_ERR_0_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[0]);
                    reg_RX_DLANE_ERR_EOT_SYNC_ERR[0] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[0] | ( ~( reg_20_11_wen & din[24 + RX_DLANE_ERR_0_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[0]);
                    reg_RX_DLANE_ERR_ESC_ENTRY_ERR[0] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[0] | ( ~( reg_20_11_wen & din[24 + RX_DLANE_ERR_0_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[0]);
                    reg_RX_DLANE_ERR_LPDT_ERR[0] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[0] | ( ~( reg_20_11_wen & din[24 + RX_DLANE_ERR_0_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[0]);
                    reg_RX_DLANE_ERR_CTRL_ERR[0] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[0] | ( ~( reg_20_11_wen & din[24 + RX_DLANE_ERR_0_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[0]);
                    reg_RX_DLANE_ERR_CAL_ERR[0] <= set_RX_DLANE_ERR_CAL_ERR_pulse[0] | ( ~( reg_20_11_wen & din[24 + RX_DLANE_ERR_0_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[0]);
                    if( NUM_LANES > 1)
                    begin
                        reg_RX_DLANE_DESKEW_DELAY_1 <= reg_24_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_1_W] : reg_RX_DLANE_DESKEW_DELAY_1;
                    end
                    if( NUM_LANES > 1)
                    begin
                        reg_RX_DLANE_ERR_SOT_ERR[1] <= set_RX_DLANE_ERR_SOT_ERR_pulse[1] | ( ~( reg_24_11_wen & din[24 + RX_DLANE_ERR_1_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[1]);
                        reg_RX_DLANE_ERR_SOT_SYNC_ERR[1] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[1] | ( ~( reg_24_11_wen & din[24 + RX_DLANE_ERR_1_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[1]);
                        reg_RX_DLANE_ERR_EOT_SYNC_ERR[1] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[1] | ( ~( reg_24_11_wen & din[24 + RX_DLANE_ERR_1_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[1]);
                        reg_RX_DLANE_ERR_ESC_ENTRY_ERR[1] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[1] | ( ~( reg_24_11_wen & din[24 + RX_DLANE_ERR_1_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[1]);
                        reg_RX_DLANE_ERR_LPDT_ERR[1] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[1] | ( ~( reg_24_11_wen & din[24 + RX_DLANE_ERR_1_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[1]);
                        reg_RX_DLANE_ERR_CTRL_ERR[1] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[1] | ( ~( reg_24_11_wen & din[24 + RX_DLANE_ERR_1_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[1]);
                        reg_RX_DLANE_ERR_CAL_ERR[1] <= set_RX_DLANE_ERR_CAL_ERR_pulse[1] | ( ~( reg_24_11_wen & din[24 + RX_DLANE_ERR_1_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[1]);
                    end
                    if( NUM_LANES > 2)
                    begin
                        reg_RX_DLANE_DESKEW_DELAY_2 <= reg_28_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_2_W] : reg_RX_DLANE_DESKEW_DELAY_2;
                    end
                    if( NUM_LANES > 2)
                    begin
                        reg_RX_DLANE_ERR_SOT_ERR[2] <= set_RX_DLANE_ERR_SOT_ERR_pulse[2] | ( ~( reg_28_11_wen & din[24 + RX_DLANE_ERR_2_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[2]);
                        reg_RX_DLANE_ERR_SOT_SYNC_ERR[2] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[2] | ( ~( reg_28_11_wen & din[24 + RX_DLANE_ERR_2_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[2]);
                        reg_RX_DLANE_ERR_EOT_SYNC_ERR[2] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[2] | ( ~( reg_28_11_wen & din[24 + RX_DLANE_ERR_2_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[2]);
                        reg_RX_DLANE_ERR_ESC_ENTRY_ERR[2] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[2] | ( ~( reg_28_11_wen & din[24 + RX_DLANE_ERR_2_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[2]);
                        reg_RX_DLANE_ERR_LPDT_ERR[2] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[2] | ( ~( reg_28_11_wen & din[24 + RX_DLANE_ERR_2_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[2]);
                        reg_RX_DLANE_ERR_CTRL_ERR[2] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[2] | ( ~( reg_28_11_wen & din[24 + RX_DLANE_ERR_2_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[2]);
                        reg_RX_DLANE_ERR_CAL_ERR[2] <= set_RX_DLANE_ERR_CAL_ERR_pulse[2] | ( ~( reg_28_11_wen & din[24 + RX_DLANE_ERR_2_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[2]);
                    end
                    if( NUM_LANES > 3)
                    begin
                        reg_RX_DLANE_DESKEW_DELAY_3 <= reg_2C_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_3_W] : reg_RX_DLANE_DESKEW_DELAY_3;
                    end
                    if( NUM_LANES > 3)
                    begin
                        reg_RX_DLANE_ERR_SOT_ERR[3] <= set_RX_DLANE_ERR_SOT_ERR_pulse[3] | ( ~( reg_2C_11_wen & din[24 + RX_DLANE_ERR_3_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[3]);
                        reg_RX_DLANE_ERR_SOT_SYNC_ERR[3] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[3] | ( ~( reg_2C_11_wen & din[24 + RX_DLANE_ERR_3_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[3]);
                        reg_RX_DLANE_ERR_EOT_SYNC_ERR[3] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[3] | ( ~( reg_2C_11_wen & din[24 + RX_DLANE_ERR_3_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[3]);
                        reg_RX_DLANE_ERR_ESC_ENTRY_ERR[3] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[3] | ( ~( reg_2C_11_wen & din[24 + RX_DLANE_ERR_3_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[3]);
                        reg_RX_DLANE_ERR_LPDT_ERR[3] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[3] | ( ~( reg_2C_11_wen & din[24 + RX_DLANE_ERR_3_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[3]);
                        reg_RX_DLANE_ERR_CTRL_ERR[3] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[3] | ( ~( reg_2C_11_wen & din[24 + RX_DLANE_ERR_3_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[3]);
                        reg_RX_DLANE_ERR_CAL_ERR[3] <= set_RX_DLANE_ERR_CAL_ERR_pulse[3] | ( ~( reg_2C_11_wen & din[24 + RX_DLANE_ERR_3_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[3]);
                    end
                    if( NUM_LANES > 4)
                    begin
                        reg_RX_DLANE_DESKEW_DELAY_4 <= reg_30_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_4_W] : reg_RX_DLANE_DESKEW_DELAY_4;
                    end
                    if( NUM_LANES > 4)
                    begin
                        reg_RX_DLANE_ERR_SOT_ERR[4] <= set_RX_DLANE_ERR_SOT_ERR_pulse[4] | ( ~( reg_30_11_wen & din[24 + RX_DLANE_ERR_4_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[4]);
                        reg_RX_DLANE_ERR_SOT_SYNC_ERR[4] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[4] | ( ~( reg_30_11_wen & din[24 + RX_DLANE_ERR_4_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[4]);
                        reg_RX_DLANE_ERR_EOT_SYNC_ERR[4] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[4] | ( ~( reg_30_11_wen & din[24 + RX_DLANE_ERR_4_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[4]);
                        reg_RX_DLANE_ERR_ESC_ENTRY_ERR[4] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[4] | ( ~( reg_30_11_wen & din[24 + RX_DLANE_ERR_4_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[4]);
                        reg_RX_DLANE_ERR_LPDT_ERR[4] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[4] | ( ~( reg_30_11_wen & din[24 + RX_DLANE_ERR_4_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[4]);
                        reg_RX_DLANE_ERR_CTRL_ERR[4] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[4] | ( ~( reg_30_11_wen & din[24 + RX_DLANE_ERR_4_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[4]);
                        reg_RX_DLANE_ERR_CAL_ERR[4] <= set_RX_DLANE_ERR_CAL_ERR_pulse[4] | ( ~( reg_30_11_wen & din[24 + RX_DLANE_ERR_4_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[4]);
                    end
                    if( NUM_LANES > 5)
                    begin
                        reg_RX_DLANE_DESKEW_DELAY_5 <= reg_34_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_5_W] : reg_RX_DLANE_DESKEW_DELAY_5;
                    end
                    if( NUM_LANES > 5)
                    begin
                        reg_RX_DLANE_ERR_SOT_ERR[5] <= set_RX_DLANE_ERR_SOT_ERR_pulse[5] | ( ~( reg_34_11_wen & din[24 + RX_DLANE_ERR_5_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[5]);
                        reg_RX_DLANE_ERR_SOT_SYNC_ERR[5] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[5] | ( ~( reg_34_11_wen & din[24 + RX_DLANE_ERR_5_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[5]);
                        reg_RX_DLANE_ERR_EOT_SYNC_ERR[5] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[5] | ( ~( reg_34_11_wen & din[24 + RX_DLANE_ERR_5_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[5]);
                        reg_RX_DLANE_ERR_ESC_ENTRY_ERR[5] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[5] | ( ~( reg_34_11_wen & din[24 + RX_DLANE_ERR_5_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[5]);
                        reg_RX_DLANE_ERR_LPDT_ERR[5] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[5] | ( ~( reg_34_11_wen & din[24 + RX_DLANE_ERR_5_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[5]);
                        reg_RX_DLANE_ERR_CTRL_ERR[5] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[5] | ( ~( reg_34_11_wen & din[24 + RX_DLANE_ERR_5_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[5]);
                        reg_RX_DLANE_ERR_CAL_ERR[5] <= set_RX_DLANE_ERR_CAL_ERR_pulse[5] | ( ~( reg_34_11_wen & din[24 + RX_DLANE_ERR_5_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[5]);
                    end
                    if( NUM_LANES > 6)
                    begin
                        reg_RX_DLANE_DESKEW_DELAY_6 <= reg_38_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_6_W] : reg_RX_DLANE_DESKEW_DELAY_6;
                    end
                    if( NUM_LANES > 6)
                    begin
                        reg_RX_DLANE_ERR_SOT_ERR[6] <= set_RX_DLANE_ERR_SOT_ERR_pulse[6] | ( ~( reg_38_11_wen & din[24 + RX_DLANE_ERR_6_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[6]);
                        reg_RX_DLANE_ERR_SOT_SYNC_ERR[6] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[6] | ( ~( reg_38_11_wen & din[24 + RX_DLANE_ERR_6_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[6]);
                        reg_RX_DLANE_ERR_EOT_SYNC_ERR[6] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[6] | ( ~( reg_38_11_wen & din[24 + RX_DLANE_ERR_6_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[6]);
                        reg_RX_DLANE_ERR_ESC_ENTRY_ERR[6] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[6] | ( ~( reg_38_11_wen & din[24 + RX_DLANE_ERR_6_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[6]);
                        reg_RX_DLANE_ERR_LPDT_ERR[6] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[6] | ( ~( reg_38_11_wen & din[24 + RX_DLANE_ERR_6_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[6]);
                        reg_RX_DLANE_ERR_CTRL_ERR[6] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[6] | ( ~( reg_38_11_wen & din[24 + RX_DLANE_ERR_6_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[6]);
                        reg_RX_DLANE_ERR_CAL_ERR[6] <= set_RX_DLANE_ERR_CAL_ERR_pulse[6] | ( ~( reg_38_11_wen & din[24 + RX_DLANE_ERR_6_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[6]);
                    end
                    if( NUM_LANES > 7)
                    begin
                        reg_RX_DLANE_DESKEW_DELAY_7 <= reg_3C_10_wen == 1'b1 ? din[16 +: RX_DLANE_DESKEW_DELAY_7_W] : reg_RX_DLANE_DESKEW_DELAY_7;
                    end
                    if( NUM_LANES > 7)
                    begin
                        reg_RX_DLANE_ERR_SOT_ERR[7] <= set_RX_DLANE_ERR_SOT_ERR_pulse[7] | ( ~( reg_3C_11_wen & din[24 + RX_DLANE_ERR_7_SOT_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_ERR[7]);
                        reg_RX_DLANE_ERR_SOT_SYNC_ERR[7] <= set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[7] | ( ~( reg_3C_11_wen & din[24 + RX_DLANE_ERR_7_SOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_SOT_SYNC_ERR[7]);
                        reg_RX_DLANE_ERR_EOT_SYNC_ERR[7] <= set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[7] | ( ~( reg_3C_11_wen & din[24 + RX_DLANE_ERR_7_EOT_SYNC_ERR_BI] ) & reg_RX_DLANE_ERR_EOT_SYNC_ERR[7]);
                        reg_RX_DLANE_ERR_ESC_ENTRY_ERR[7] <= set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[7] | ( ~( reg_3C_11_wen & din[24 + RX_DLANE_ERR_7_ESC_ENTRY_ERR_BI] ) & reg_RX_DLANE_ERR_ESC_ENTRY_ERR[7]);
                        reg_RX_DLANE_ERR_LPDT_ERR[7] <= set_RX_DLANE_ERR_LPDT_ERR_pulse[7] | ( ~( reg_3C_11_wen & din[24 + RX_DLANE_ERR_7_LPDT_ERR_BI] ) & reg_RX_DLANE_ERR_LPDT_ERR[7]);
                        reg_RX_DLANE_ERR_CTRL_ERR[7] <= set_RX_DLANE_ERR_CTRL_ERR_pulse[7] | ( ~( reg_3C_11_wen & din[24 + RX_DLANE_ERR_7_CTRL_ERR_BI] ) & reg_RX_DLANE_ERR_CTRL_ERR[7]);
                        reg_RX_DLANE_ERR_CAL_ERR[7] <= set_RX_DLANE_ERR_CAL_ERR_pulse[7] | ( ~( reg_3C_11_wen & din[24 + RX_DLANE_ERR_7_CAL_ERR_BI] ) & reg_RX_DLANE_ERR_CAL_ERR[7]);
                    end
                    reg_RX_CLK_LOSS_DETECT <= reg_50_00_wen == 1'b1 ? din[0 +: RX_CLK_LOSS_DETECT_W] : reg_RX_CLK_LOSS_DETECT;
                    reg_RX_CLK_SETTLE <= reg_50_01_wen == 1'b1 ? din[8 +: RX_CLK_SETTLE_W] : reg_RX_CLK_SETTLE;
                    reg_RX_HS_SETTLE <= reg_50_10_wen == 1'b1 ? din[16 +: RX_HS_SETTLE_W] : reg_RX_HS_SETTLE;
                    reg_RX_INIT <= reg_54_00_wen == 1'b1 ? din[0 +: RX_INIT_W] : reg_RX_INIT;
                    reg_RX_CLK_POST <= reg_54_01_wen == 1'b1 ? din[8 +: RX_CLK_POST_W] : reg_RX_CLK_POST;
                    reg_RX_CAL_REG_CTRL_CAL_REG_MUXSEL <= reg_60_00_wen == 1'b1 ? din[0 + RX_CAL_REG_CTRL_CAL_REG_MUXSEL_BI_H:0 + RX_CAL_REG_CTRL_CAL_REG_MUXSEL_BI] : reg_RX_CAL_REG_CTRL_CAL_REG_MUXSEL;
                    reg_RX_CAL_REG_CTRL_CAL_RESET <= ( reg_60_00_wen & din[0 + RX_CAL_REG_CTRL_CAL_RESET_BI] ) ? ~reg_RX_CAL_REG_CTRL_CAL_RESET : reg_RX_CAL_REG_CTRL_CAL_RESET;
                    reg_RX_TM_CONTROL_RX_TM_EN <= reg_78_00_wen == 1'b1 ? din[0 + RX_TM_CONTROL_RX_TM_EN_BI] : reg_RX_TM_CONTROL_RX_TM_EN;
                    reg_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE <= reg_78_00_wen == 1'b1 ? din[0 + RX_TM_CONTROL_RX_TM_LOOPBACK_MODE_BI] : reg_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE;
                    reg_RX_TM_CONTROL_RX_TST_CNT_RST <= ( reg_78_00_wen & din[0 + RX_TM_CONTROL_RX_TST_CNT_RST_BI] ) ? ~reg_RX_TM_CONTROL_RX_TST_CNT_RST : reg_RX_TM_CONTROL_RX_TST_CNT_RST;
                    reg_RX_PREP_TIME_TM <= reg_78_01_wen == 1'b1 ? din[8 +: RX_PREP_TIME_TM_W] : reg_RX_PREP_TIME_TM;
                end
            end
    end
    else
    begin : DPHY_RX_reg_blk_stub
        assign reg_RX_DLANE_DESKEW_DELAY_0 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[0] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[0] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[0] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[0] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[0] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[0] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[0] = 1'h0;
        assign reg_RX_DLANE_DESKEW_DELAY_1 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[1] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[1] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[1] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[1] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[1] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[1] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[1] = 1'h0;
        assign reg_RX_DLANE_DESKEW_DELAY_2 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[2] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[2] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[2] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[2] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[2] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[2] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[2] = 1'h0;
        assign reg_RX_DLANE_DESKEW_DELAY_3 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[3] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[3] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[3] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[3] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[3] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[3] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[3] = 1'h0;
        assign reg_RX_DLANE_DESKEW_DELAY_4 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[4] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[4] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[4] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[4] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[4] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[4] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[4] = 1'h0;
        assign reg_RX_DLANE_DESKEW_DELAY_5 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[5] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[5] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[5] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[5] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[5] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[5] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[5] = 1'h0;
        assign reg_RX_DLANE_DESKEW_DELAY_6 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[6] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[6] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[6] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[6] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[6] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[6] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[6] = 1'h0;
        assign reg_RX_DLANE_DESKEW_DELAY_7 = 7'h0;
        assign reg_RX_DLANE_ERR_SOT_ERR[7] = 1'h0;
        assign reg_RX_DLANE_ERR_SOT_SYNC_ERR[7] = 1'h0;
        assign reg_RX_DLANE_ERR_EOT_SYNC_ERR[7] = 1'h0;
        assign reg_RX_DLANE_ERR_ESC_ENTRY_ERR[7] = 1'h0;
        assign reg_RX_DLANE_ERR_LPDT_ERR[7] = 1'h0;
        assign reg_RX_DLANE_ERR_CTRL_ERR[7] = 1'h0;
        assign reg_RX_DLANE_ERR_CAL_ERR[7] = 1'h0;
        assign reg_RX_CLK_LOSS_DETECT = 8'h0;
        assign reg_RX_CLK_SETTLE = 8'h0;
        assign reg_RX_HS_SETTLE = 8'h0;
        assign reg_RX_INIT = 8'h0;
        assign reg_RX_CLK_POST = 8'h0;
        assign reg_RX_CAL_REG_CTRL_CAL_REG_MUXSEL = 3'h0;
        assign reg_RX_CAL_REG_CTRL_CAL_RESET = 1'h0;
        assign reg_RX_TM_CONTROL_RX_TM_EN = 1'h0;
        assign reg_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE = 1'h0;
        assign reg_RX_TM_CONTROL_RX_TST_CNT_RST = 1'h0;
        assign reg_RX_PREP_TIME_TM = 8'h0;
    end
    if(DPHY_TX_EN == 1)
    begin : DPHY_TX_reg_blk
        always @(posedge clk)
        begin
            if(srst_n == 1'b0)
                begin
                    reg_TX_PREAMBLE_LEN_PREAMBLE_EN <= TX_PREAMBLE_LEN_PREAMBLE_EN_D;
                    reg_TX_PREAMBLE_LEN_PREAMLBE_LEN <= TX_PREAMBLE_LEN_PREAMLBE_LEN_D;
                    reg_TX_LPX <= def_TX_LPX;
                    reg_TX_HS_EXIT <= def_TX_HS_EXIT;
                    reg_TX_LP_EXIT <= def_TX_LP_EXIT;
                    reg_TX_CLK_PREPARE <= def_TX_CLK_PREPARE;
                    reg_TX_CLK_TRAIL <= def_TX_CLK_TRAIL;
                    reg_TX_CLK_ZERO <= def_TX_CLK_ZERO;
                    reg_TX_CLK_POST <= def_TX_CLK_POST;
                    reg_TX_CLK_PRE <= def_TX_CLK_PRE;
                    reg_TX_HS_PREPARE <= def_TX_HS_PREPARE;
                    reg_TX_HS_ZERO <= def_TX_HS_ZERO;
                    reg_TX_HS_TRAIL <= def_TX_HS_TRAIL;
                    reg_TX_INIT <= def_TX_INIT;
                    reg_TX_WAKE <= def_TX_WAKE;
                    reg_TX_TM_CONTROL_TX_TM_EN <= TX_TM_CONTROL_TX_TM_EN_D;
                    reg_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE <= TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_D;
                    reg_TX_TM_CONTROL_TX_TST_CNT_RST <= 1'h0;
                    reg_TX_HS_TM_DESKEW_P <= def_TX_HS_TM_DESKEW_P;
                    reg_TX_MNL_IO_0_CTRL_EN <= 1'h0;
                    reg_TX_MNL_IO_0_CLK_LP_EN <= 1'h0;
                    reg_TX_MNL_IO_0_LP_DAT <= 2'h0;
                    reg_TX_MNL_IO_0_HS_DAT_D <= 2'h0;
                    reg_TX_MNL_IO_0_HS_DAT_CK <= 2'h0;
                    reg_TX_MNL_D_LP_EN <= 'h0;
                end
                else
                begin
                    reg_TX_PREAMBLE_LEN_PREAMBLE_EN <= reg_0C_01_wen == 1'b1 ? din[8 + TX_PREAMBLE_LEN_PREAMBLE_EN_BI] : reg_TX_PREAMBLE_LEN_PREAMBLE_EN;
                    reg_TX_PREAMBLE_LEN_PREAMLBE_LEN <= reg_0C_01_wen == 1'b1 ? din[8 + TX_PREAMBLE_LEN_PREAMLBE_LEN_BI_H:8 + TX_PREAMBLE_LEN_PREAMLBE_LEN_BI] : reg_TX_PREAMBLE_LEN_PREAMLBE_LEN;
                    reg_TX_LPX <= reg_40_00_wen == 1'b1 ? din[0 +: TX_LPX_W] : reg_TX_LPX;
                    reg_TX_HS_EXIT <= reg_40_01_wen == 1'b1 ? din[8 +: TX_HS_EXIT_W] : reg_TX_HS_EXIT;
                    reg_TX_LP_EXIT <= reg_40_10_wen == 1'b1 ? din[16 +: TX_LP_EXIT_W] : reg_TX_LP_EXIT;
                    reg_TX_CLK_PREPARE <= reg_44_00_wen == 1'b1 ? din[0 +: TX_CLK_PREPARE_W] : reg_TX_CLK_PREPARE;
                    reg_TX_CLK_TRAIL <= reg_44_01_wen == 1'b1 ? din[8 +: TX_CLK_TRAIL_W] : reg_TX_CLK_TRAIL;
                    reg_TX_CLK_ZERO <= reg_44_10_wen == 1'b1 ? din[16 +: TX_CLK_ZERO_W] : reg_TX_CLK_ZERO;
                    reg_TX_CLK_POST <= reg_44_11_wen == 1'b1 ? din[24 +: TX_CLK_POST_W] : reg_TX_CLK_POST;
                    reg_TX_CLK_PRE <= reg_48_00_wen == 1'b1 ? din[0 +: TX_CLK_PRE_W] : reg_TX_CLK_PRE;
                    reg_TX_HS_PREPARE <= reg_48_01_wen == 1'b1 ? din[8 +: TX_HS_PREPARE_W] : reg_TX_HS_PREPARE;
                    reg_TX_HS_ZERO <= reg_48_10_wen == 1'b1 ? din[16 +: TX_HS_ZERO_W] : reg_TX_HS_ZERO;
                    reg_TX_HS_TRAIL <= reg_4C_00_wen == 1'b1 ? din[0 +: TX_HS_TRAIL_W] : reg_TX_HS_TRAIL;
                    reg_TX_INIT <= reg_4C_10_wen == 1'b1 ? din[16 +: TX_INIT_W] : reg_TX_INIT;
                    reg_TX_WAKE <= reg_4C_11_wen == 1'b1 ? din[24 +: TX_WAKE_W] : reg_TX_WAKE;
                    reg_TX_TM_CONTROL_TX_TM_EN <= reg_70_00_wen == 1'b1 ? din[0 + TX_TM_CONTROL_TX_TM_EN_BI] : reg_TX_TM_CONTROL_TX_TM_EN;
                    reg_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE <= reg_70_00_wen == 1'b1 ? din[0 + TX_TM_CONTROL_TX_TM_LOOPBACK_MODE_BI] : reg_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE;
                    reg_TX_TM_CONTROL_TX_TST_CNT_RST <= ( reg_70_00_wen & din[0 + TX_TM_CONTROL_TX_TST_CNT_RST_BI] ) ? ~reg_TX_TM_CONTROL_TX_TST_CNT_RST : reg_TX_TM_CONTROL_TX_TST_CNT_RST;
                    reg_TX_HS_TM_DESKEW_P <= reg_70_01_wen == 1'b1 ? din[8 +: TX_HS_TM_DESKEW_P_W] : reg_TX_HS_TM_DESKEW_P;
                    reg_TX_MNL_IO_0_CTRL_EN <= reg_70_10_wen == 1'b1 ? din[16 + TX_MNL_IO_0_CTRL_EN_BI] : reg_TX_MNL_IO_0_CTRL_EN;
                    reg_TX_MNL_IO_0_CLK_LP_EN <= reg_70_10_wen == 1'b1 ? din[16 + TX_MNL_IO_0_CLK_LP_EN_BI] : reg_TX_MNL_IO_0_CLK_LP_EN;
                    reg_TX_MNL_IO_0_LP_DAT <= reg_70_10_wen == 1'b1 ? din[16 + TX_MNL_IO_0_LP_DAT_BI_H:16 + TX_MNL_IO_0_LP_DAT_BI] : reg_TX_MNL_IO_0_LP_DAT;
                    reg_TX_MNL_IO_0_HS_DAT_D <= reg_70_10_wen == 1'b1 ? din[16 + TX_MNL_IO_0_HS_DAT_D_BI_H:16 + TX_MNL_IO_0_HS_DAT_D_BI] : reg_TX_MNL_IO_0_HS_DAT_D;
                    reg_TX_MNL_IO_0_HS_DAT_CK <= reg_70_10_wen == 1'b1 ? din[16 + TX_MNL_IO_0_HS_DAT_CK_BI_H:16 + TX_MNL_IO_0_HS_DAT_CK_BI] : reg_TX_MNL_IO_0_HS_DAT_CK;
                    reg_TX_MNL_D_LP_EN <= reg_70_11_wen == 1'b1 ? din[24 +: TX_MNL_D_LP_EN_W] : reg_TX_MNL_D_LP_EN;
                end
            end
    end
    else
    begin : DPHY_TX_reg_blk_stub
        assign reg_TX_PREAMBLE_LEN_PREAMBLE_EN = 1'h0;
        assign reg_TX_PREAMBLE_LEN_PREAMLBE_LEN = 4'h0;
        assign reg_TX_LPX = 7'h0;
        assign reg_TX_HS_EXIT = 8'h0;
        assign reg_TX_LP_EXIT = 8'h0;
        assign reg_TX_CLK_PREPARE = 6'h0;
        assign reg_TX_CLK_TRAIL = 7'h0;
        assign reg_TX_CLK_ZERO = 7'h0;
        assign reg_TX_CLK_POST = 8'h0;
        assign reg_TX_CLK_PRE = 4'h0;
        assign reg_TX_HS_PREPARE = 6'h0;
        assign reg_TX_HS_ZERO = 8'h0;
        assign reg_TX_HS_TRAIL = 8'h0;
        assign reg_TX_INIT = 8'h0;
        assign reg_TX_WAKE = 8'h0;
        assign reg_TX_TM_CONTROL_TX_TM_EN = 1'h0;
        assign reg_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE = 1'h0;
        assign reg_TX_TM_CONTROL_TX_TST_CNT_RST = 1'h0;
        assign reg_TX_HS_TM_DESKEW_P = 8'h0;
        assign reg_TX_MNL_IO_0_CTRL_EN = 1'h0;
        assign reg_TX_MNL_IO_0_CLK_LP_EN = 1'h0;
        assign reg_TX_MNL_IO_0_LP_DAT = 2'h0;
        assign reg_TX_MNL_IO_0_HS_DAT_D = 2'h0;
        assign reg_TX_MNL_IO_0_HS_DAT_CK = 2'h0;
        assign reg_TX_MNL_D_LP_EN = 8'h0;
    end

    assign sig_DPHY_CSR_Enable = reg_DPHY_CSR_Enable;
    assign sig_CLK_CSR_CLK_LANE_EN = reg_CLK_CSR_CLK_LANE_EN;
    assign sig_DLANE_CSR_EN = reg_DLANE_CSR_EN[NUM_LANES-1:0];             
    assign sig_DLANE_CSR_RX_DESKEW_UPDATE_tog = reg_DLANE_CSR_RX_DESKEW_UPDATE;
    assign sig_DLANE_CSR_RX_MNL_DESKEW_EN = reg_DLANE_CSR_RX_MNL_DESKEW_EN[NUM_LANES-1:0];
    assign sig_PRBS_INIT_0 = PRBS_INIT_0_RW == 0 ? def_PRBS_INIT_0 : reg_PRBS_INIT_0;
    assign sig_PRBS_INIT_1 = PRBS_INIT_1_RW == 0 ? def_PRBS_INIT_1 : reg_PRBS_INIT_1;
    assign sig_PRBS_INIT_2 = PRBS_INIT_2_RW == 0 ? def_PRBS_INIT_2 : reg_PRBS_INIT_2;
    assign sig_PRBS_INIT_3 = PRBS_INIT_3_RW == 0 ? def_PRBS_INIT_3 : reg_PRBS_INIT_3;
    assign sig_PRBS_INIT_4 = PRBS_INIT_4_RW == 0 ? def_PRBS_INIT_4 : reg_PRBS_INIT_4;
    assign sig_PRBS_INIT_5 = PRBS_INIT_5_RW == 0 ? def_PRBS_INIT_5 : reg_PRBS_INIT_5;
    assign sig_PRBS_INIT_6 = PRBS_INIT_6_RW == 0 ? def_PRBS_INIT_6 : reg_PRBS_INIT_6;
    assign sig_PRBS_INIT_7 = PRBS_INIT_7_RW == 0 ? def_PRBS_INIT_7 : reg_PRBS_INIT_7;
    assign sig_RX_DLANE_DESKEW_DELAY_0 = RX_DLANE_DESKEW_DELAY_0_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_0 : reg_RX_DLANE_DESKEW_DELAY_0;
    assign sig_RX_DLANE_DESKEW_DELAY_1 = RX_DLANE_DESKEW_DELAY_1_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_1 : reg_RX_DLANE_DESKEW_DELAY_1;
    assign sig_RX_DLANE_DESKEW_DELAY_2 = RX_DLANE_DESKEW_DELAY_2_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_2 : reg_RX_DLANE_DESKEW_DELAY_2;
    assign sig_RX_DLANE_DESKEW_DELAY_3 = RX_DLANE_DESKEW_DELAY_3_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_3 : reg_RX_DLANE_DESKEW_DELAY_3;
    assign sig_RX_DLANE_DESKEW_DELAY_4 = RX_DLANE_DESKEW_DELAY_4_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_4 : reg_RX_DLANE_DESKEW_DELAY_4;
    assign sig_RX_DLANE_DESKEW_DELAY_5 = RX_DLANE_DESKEW_DELAY_5_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_5 : reg_RX_DLANE_DESKEW_DELAY_5;
    assign sig_RX_DLANE_DESKEW_DELAY_6 = RX_DLANE_DESKEW_DELAY_6_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_6 : reg_RX_DLANE_DESKEW_DELAY_6;
    assign sig_RX_DLANE_DESKEW_DELAY_7 = RX_DLANE_DESKEW_DELAY_7_RW == 0 ? def_RX_DLANE_DESKEW_DELAY_7 : reg_RX_DLANE_DESKEW_DELAY_7;
    assign sig_RX_CLK_LOSS_DETECT = RX_CLK_LOSS_DETECT_RW == 0 ? def_RX_CLK_LOSS_DETECT : reg_RX_CLK_LOSS_DETECT;
    assign sig_RX_CLK_SETTLE = RX_CLK_SETTLE_RW == 0 ? def_RX_CLK_SETTLE : reg_RX_CLK_SETTLE;
    assign sig_RX_HS_SETTLE = RX_HS_SETTLE_RW == 0 ? def_RX_HS_SETTLE : reg_RX_HS_SETTLE;
    assign sig_RX_INIT = RX_INIT_RW == 0 ? def_RX_INIT : reg_RX_INIT;
    assign sig_RX_CLK_POST = RX_CLK_POST_RW == 0 ? def_RX_CLK_POST : reg_RX_CLK_POST;
    assign sig_RX_CAL_REG_CTRL_CAL_REG_MUXSEL = reg_RX_CAL_REG_CTRL_CAL_REG_MUXSEL;
    assign sig_RX_CAL_REG_CTRL_CAL_RESET_tog = reg_RX_CAL_REG_CTRL_CAL_RESET;
    assign sig_RX_TM_CONTROL_RX_TM_EN = reg_RX_TM_CONTROL_RX_TM_EN;
    assign sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE = reg_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE;
    assign sig_RX_TM_CONTROL_RX_TST_CNT_RST_tog = reg_RX_TM_CONTROL_RX_TST_CNT_RST;
    assign sig_RX_PREP_TIME_TM = RX_PREP_TIME_TM_RW == 0 ? def_RX_PREP_TIME_TM : reg_RX_PREP_TIME_TM;
    assign sig_TX_PREAMBLE_LEN_PREAMBLE_EN = reg_TX_PREAMBLE_LEN_PREAMBLE_EN;
    assign sig_TX_PREAMBLE_LEN_PREAMLBE_LEN = reg_TX_PREAMBLE_LEN_PREAMLBE_LEN;
    assign sig_TX_CLK_LANE_PS = def_TX_CLK_LANE_PS;
    assign sig_TX_LPX = TX_LPX_RW == 0 ? def_TX_LPX : reg_TX_LPX;
    assign sig_TX_HS_EXIT = TX_HS_EXIT_RW == 0 ? def_TX_HS_EXIT : reg_TX_HS_EXIT;
    assign sig_TX_LP_EXIT = TX_LP_EXIT_RW == 0 ? def_TX_LP_EXIT : reg_TX_LP_EXIT;
    assign sig_TX_CLK_PREPARE = TX_CLK_PREPARE_RW == 0 ? def_TX_CLK_PREPARE : reg_TX_CLK_PREPARE;
    assign sig_TX_CLK_TRAIL = TX_CLK_TRAIL_RW == 0 ? def_TX_CLK_TRAIL : reg_TX_CLK_TRAIL;
    assign sig_TX_CLK_ZERO = TX_CLK_ZERO_RW == 0 ? def_TX_CLK_ZERO : reg_TX_CLK_ZERO;
    assign sig_TX_CLK_POST = TX_CLK_POST_RW == 0 ? def_TX_CLK_POST : reg_TX_CLK_POST;
    assign sig_TX_CLK_PRE = TX_CLK_PRE_RW == 0 ? def_TX_CLK_PRE : reg_TX_CLK_PRE;
    assign sig_TX_HS_PREPARE = TX_HS_PREPARE_RW == 0 ? def_TX_HS_PREPARE : reg_TX_HS_PREPARE;
    assign sig_TX_HS_ZERO = TX_HS_ZERO_RW == 0 ? def_TX_HS_ZERO : reg_TX_HS_ZERO;
    assign sig_TX_HS_TRAIL = TX_HS_TRAIL_RW == 0 ? def_TX_HS_TRAIL : reg_TX_HS_TRAIL;
    assign sig_TX_INIT = TX_INIT_RW == 0 ? def_TX_INIT : reg_TX_INIT;
    assign sig_TX_WAKE = TX_WAKE_RW == 0 ? def_TX_WAKE : reg_TX_WAKE;
    assign sig_TX_TM_CONTROL_TX_TM_EN = reg_TX_TM_CONTROL_TX_TM_EN;
    assign sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE = reg_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE;
    assign sig_TX_TM_CONTROL_TX_TST_CNT_RST_tog = reg_TX_TM_CONTROL_TX_TST_CNT_RST;
    assign sig_TX_HS_TM_DESKEW_P = TX_HS_TM_DESKEW_P_RW == 0 ? def_TX_HS_TM_DESKEW_P : reg_TX_HS_TM_DESKEW_P;
    assign sig_TX_MNL_IO_0_CTRL_EN = reg_TX_MNL_IO_0_CTRL_EN;
    assign sig_TX_MNL_IO_0_CLK_LP_EN = reg_TX_MNL_IO_0_CLK_LP_EN;
    assign sig_TX_MNL_IO_0_LP_DAT = reg_TX_MNL_IO_0_LP_DAT;
    assign sig_TX_MNL_IO_0_HS_DAT_D = reg_TX_MNL_IO_0_HS_DAT_D;
    assign sig_TX_MNL_IO_0_HS_DAT_CK = reg_TX_MNL_IO_0_HS_DAT_CK;
    assign sig_TX_MNL_D_LP_EN = reg_TX_MNL_D_LP_EN;

    always @(posedge clk)
    begin
        dout[31:24] <= reg_00_11_rdata |
                reg_14_11_rdata |
                reg_18_11_rdata |
                reg_68_11_rdata |
                reg_6C_11_rdata |
                reg_20_11_rdata |
                reg_24_11_rdata |
                reg_28_11_rdata |
                reg_2C_11_rdata |
                reg_30_11_rdata |
                reg_34_11_rdata |
                reg_38_11_rdata |
                reg_3C_11_rdata |
                reg_60_11_rdata |
                reg_64_11_rdata |
                reg_7C_11_rdata |
                reg_44_11_rdata |
                reg_4C_11_rdata |
                reg_70_11_rdata |
                reg_74_11_rdata;
        dout[23:16] <= reg_14_10_rdata |
                reg_18_10_rdata |
                reg_68_10_rdata |
                reg_6C_10_rdata |
                reg_10_10_rdata |
                reg_20_10_rdata |
                reg_24_10_rdata |
                reg_28_10_rdata |
                reg_2C_10_rdata |
                reg_30_10_rdata |
                reg_34_10_rdata |
                reg_38_10_rdata |
                reg_3C_10_rdata |
                reg_50_10_rdata |
                reg_60_10_rdata |
                reg_64_10_rdata |
                reg_7C_10_rdata |
                reg_40_10_rdata |
                reg_44_10_rdata |
                reg_48_10_rdata |
                reg_4C_10_rdata |
                reg_70_10_rdata |
                reg_74_10_rdata;
        dout[15:8] <= reg_00_01_rdata |
                reg_14_01_rdata |
                reg_18_01_rdata |
                reg_1C_01_rdata |
                reg_20_01_rdata |
                reg_24_01_rdata |
                reg_28_01_rdata |
                reg_2C_01_rdata |
                reg_30_01_rdata |
                reg_34_01_rdata |
                reg_38_01_rdata |
                reg_3C_01_rdata |
                reg_68_01_rdata |
                reg_6C_01_rdata |
                reg_50_01_rdata |
                reg_54_01_rdata |
                reg_60_01_rdata |
                reg_64_01_rdata |
                reg_78_01_rdata |
                reg_7C_01_rdata |
                reg_0C_01_rdata |
                reg_10_01_rdata |
                reg_40_01_rdata |
                reg_44_01_rdata |
                reg_48_01_rdata |
                reg_70_01_rdata |
                reg_74_01_rdata;
        dout[7:0] <= reg_00_00_rdata |
                reg_04_00_rdata |
                reg_10_00_rdata |
                reg_14_00_rdata |
                reg_18_00_rdata |
                reg_1C_00_rdata |
                reg_20_00_rdata |
                reg_24_00_rdata |
                reg_28_00_rdata |
                reg_2C_00_rdata |
                reg_30_00_rdata |
                reg_34_00_rdata |
                reg_38_00_rdata |
                reg_3C_00_rdata |
                reg_68_00_rdata |
                reg_6C_00_rdata |
                reg_08_00_rdata |
                reg_50_00_rdata |
                reg_54_00_rdata |
                reg_60_00_rdata |
                reg_64_00_rdata |
                reg_78_00_rdata |
                reg_7C_00_rdata |
                reg_0C_00_rdata |
                reg_40_00_rdata |
                reg_44_00_rdata |
                reg_48_00_rdata |
                reg_4C_00_rdata |
                reg_70_00_rdata |
                reg_74_00_rdata;
    end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oIJzq7qejf/PKaqSbL75Qb8n1OZ4g2EVL6VddNpUeO0A6ZL0oB52laowgUlNDuf1XjJ1DwaGKCp2M+P/zRBzG9CL8GMNXun2ZiSjdAK92mE3r9LzYWpALNk2ywGi9wX2+0wDSIq3KSuBkejgY23uvKWRV9aSLFbolVI1Gf5FO/p2OhzAbYpLhe2R4joYFuZx0zcf6bwNO2fxyS3dWllAqb1IUdX5WplbpBvH9GZ+YsnTFKFqGzNQap5Udx6mNdiiUFTd40bspFJqDpEMqVzxawNfNXgh4UwdvQZjqX0KHa7Vr0HIDert2E+EkQKyYufUGO2KCRNXtl5KJp+dBzhJl+fm15zWfWJnVEGSDoBfbUIeRoHx1JYcg0e2McKMTaqia4OCx9eEpohZCZE+Rn6a24iAlH8n/zzHXAxcLSC61fCtZ+SUYao2umQLyez2E8J5YuePfnNHMLLbBzFaSq1g3VwhwskCAZ1iOl1XOLoJbdTLvyRfFZRH68oxPeIl2eZEywUuREzmh4XXl6vxlTEGnpLo0tkTv0ebN5b+oubVok6D0ix7rp0b+7WAUsZ8YqeFBg4f9j8hZGvh2pN7DSlWmpxVGdoTPr2SU74jB5e1/QhTDrisAk3+1a0tO7gAuqxrC9Oth8KINu5c5Tbbh0FmtwAymY/67HUQbanPs/+rfR4h9VwAKfO1y6GS7RussrHaqkmqgL9CcFVcAtHobiowNvJoYPBqo7ebaqgCkAt71Nw9dEDlkjXxZlaC7zvymjEns5xEdFNWrX69maT8HxfFmMt"
`endif