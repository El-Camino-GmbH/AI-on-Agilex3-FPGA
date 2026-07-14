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
module dphy_pcx_tx #(        
	parameter IO_CONVERT_RATIO = 16,     
	parameter VCO_FREQ_MULT = 1,     
	parameter NUM_LANES = 4,                                    
    parameter SKEW_CAL_EN = 1,                                  
    parameter SKEW_CAL_LEN = 32768,
    parameter ALT_CAL_EN = 1,                                   
    parameter ALT_CAL_LEN = 32768,                                   
	parameter PREAMBLE_EN = 1,                                  
	parameter CONTINUOUS_CLK = 0,                                  
	parameter TM_EN = 0,                                        
	parameter TM_LOOPBACK_MODE = 0
    )
   (
        input  wire             fr_clk,         
        input  wire             fr_clk_1024,    
        input  wire             core_clk,       
        input  wire             arst_fr_n,      
        input  wire             srst_fr_n,      
        input  wire             arst_core_n,    
        input  wire             srst_core_n,    
        input sig_DPHY_CSR_Enable,
        input sig_CLK_CSR_CLK_LANE_EN,
        output logic [NUM_LANES-1:0] sig_DLANE_STATUS_INIT_DONE,
        output logic  sig_CLK_STATUS_INIT_DONE,
        input [NUM_LANES-1:0] sig_DLANE_CSR_EN,             
        input [NUM_LANES*8-1:0] sig_PRBS_INIT,              
        input sig_TX_PREAMBLE_LEN_PREAMBLE_EN,
        input [3:0] sig_TX_PREAMBLE_LEN_PREAMLBE_LEN,
        input [6:0] sig_TX_LPX,
        input [7:0] sig_TX_HS_EXIT,
        input [7:0] sig_TX_LP_EXIT,
        input [5:0] sig_TX_CLK_PREPARE,
        input [6:0] sig_TX_CLK_TRAIL,
        input [6:0] sig_TX_CLK_ZERO,
        input [7:0] sig_TX_CLK_POST,
        input [3:0] sig_TX_CLK_PRE,
        input [5:0] sig_TX_HS_PREPARE,
        input [7:0] sig_TX_HS_ZERO,
        input [7:0] sig_TX_HS_TRAIL,
        input [7:0] sig_TX_INIT,
        input [7:0] sig_TX_WAKE,
        input sig_TX_TM_CONTROL_TX_TM_EN,
        input sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE,
        input sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse,
        input [IO_CONVERT_RATIO-1:0] tm_loopback_in,
        input [7:0] sig_TX_HS_TM_DESKEW_P,
        output logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B0,
    
        output logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B1,
    
        output logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B2,
    
        output logic [NUM_LANES*8-1:0] sig_TX_WORD_COUNT_B3,
        
        dphy_io_if              dphy_port,    
        dphy_dbg_dlane          dphy_dbg_dlane[7:0],
        dphy_dbg_clane          dphy_dbg_clane,
        ppi_if                  ppi_tx      
    );
    
        
    int i;
    genvar j;
    
    logic sig_DPHY_CSR_Enable_fr;
    logic sig_DPHY_CSR_Enable_core;
    logic [NUM_LANES-1:0] hs_done;
    logic [NUM_LANES-1:0] in_cal;
    logic [NUM_LANES-1:0] data_lane_en;
    logic [NUM_LANES:0] ppi_enable_fr;
    logic esc_pulse;
    logic srst_esc_n;
    logic clk_pre_done;


    logic [NUM_LANES-1:0] sig_DLANE_STATUS_INIT_DONE_int;
    logic sig_CLK_STATUS_INIT_DONE_int;
    logic auto_cal_done;
    logic auto_skew_cal;
    logic auto_alt_cal;
    logic clk_in_stop;


    altera_std_synchronizer_nocut # ( .depth(3) ) cdc_DPHY_CSR_Enable_fr (
        .clk(fr_clk), .reset_n(arst_fr_n), .din(sig_DPHY_CSR_Enable), .dout(sig_DPHY_CSR_Enable_fr) );               
    
    
    genvar nlane;
    for(nlane = 0; nlane < NUM_LANES+1; nlane++)
    begin : ppi_enable_sync
        altera_std_synchronizer_nocut # ( .depth(3) ) cdc_PPI_Enable (
            .clk(fr_clk), .reset_n(arst_fr_n), .din(ppi_tx.Enable[nlane]), .dout(ppi_enable_fr[nlane]) );               
    end

    assign data_lane_en = ppi_enable_fr[NUM_LANES-1:0] & sig_DLANE_CSR_EN;
    
    

    for(j=0; j<NUM_LANES; j++)
    begin : dphy_pcs_dlanes
    
        dphy_pcx_data_tx #(
                .IO_CONVERT_RATIO(IO_CONVERT_RATIO),     
                .SKEW_CAL_EN(SKEW_CAL_EN),               
                .ALT_CAL_EN(ALT_CAL_EN),                 
                .PREAMBLE_EN(PREAMBLE_EN),               
                .TM_EN(TM_EN),                           
                .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE),     
                .LANE_ID(j),
                .VCO_FREQ_MULT(VCO_FREQ_MULT)
            ) pcs_data_tx
        (
                .fr_clk(fr_clk),    
                .fr_clk_1024(fr_clk_1024),    
                .core_clk(core_clk),
                .srst_fr_n(srst_fr_n),
                .srst_core_n(srst_core_n),    
                .srst_esc_n(srst_esc_n),
                .enable(sig_DPHY_CSR_Enable_fr & data_lane_en[j]),  
                .t_init(sig_TX_INIT),   
                .t_hs_prepare({2'h0, sig_TX_HS_PREPARE}),
                .t_hs_zero(sig_TX_HS_ZERO),
                .t_hs_trail(sig_TX_HS_TRAIL),
                .t_wake(sig_TX_WAKE),
                .t_hs_exit(sig_TX_HS_EXIT),   
                .t_lp_exit(sig_TX_LP_EXIT),   
                .reg_preamble_en(sig_TX_PREAMBLE_LEN_PREAMBLE_EN),
                .reg_preamble_len({4'h0, sig_TX_PREAMBLE_LEN_PREAMLBE_LEN}),
                .cal_prbs_init(sig_PRBS_INIT[j*8+:8]),
                .hs_done(hs_done[j]),
                .init_done(sig_DLANE_STATUS_INIT_DONE_int[j]),
                .clk_pre_done(clk_pre_done),
                .esc_pulse(esc_pulse),
                .auto_skew_cal(auto_skew_cal),
                .auto_alt_cal(auto_alt_cal),
                .auto_cal_done(auto_cal_done),
                .in_cal(in_cal[j]),
                .in_tm(sig_TX_TM_CONTROL_TX_TM_EN),
                .tm_loopback(sig_TX_TM_CONTROL_TX_TM_LOOPBACK_MODE),
                .tm_cnt_rst_p(sig_TX_TM_CONTROL_TX_TST_CNT_RST_pulse),
                .tm_loopback_in(tm_loopback_in),
                .tm_hs_deskew(sig_TX_HS_TM_DESKEW_P),
                
                .word_cnt({sig_TX_WORD_COUNT_B3[j*8+:8], sig_TX_WORD_COUNT_B2[j*8+:8], sig_TX_WORD_COUNT_B1[j*8+:8], sig_TX_WORD_COUNT_B0[j*8+:8]}),
                .dphy_port(dphy_port),         
                .dphy_dbg_dlane(dphy_dbg_dlane[j]),
               .ppi_tx(ppi_tx)  
            );    


    end    
    assign clk_lane_enable = sig_CLK_CSR_CLK_LANE_EN & sig_DPHY_CSR_Enable_fr & ppi_enable_fr[NUM_LANES];
    assign dlanes_hs_done = &hs_done;

    dphy_pcx_clk_tx  # (
            .NUM_LANES(NUM_LANES),
            .IO_CONVERT_RATIO(IO_CONVERT_RATIO),
            .CONTINUOUS_CLK(CONTINUOUS_CLK),
            .VCO_FREQ_MULT(VCO_FREQ_MULT)
        ) pcs_clk_tx (
            .arst_fr_n(arst_fr_n),                  
            .fr_clk(fr_clk),                        
            .fr_clk_1024(fr_clk_1024),              
            .core_clk(core_clk),                    
            .srst_fr_n(srst_fr_n),                  
            .enable(clk_lane_enable),               
            .srst_esc_n(srst_esc_n),
            .t_init(sig_TX_INIT),                           
            .t_lpx({1'b0, sig_TX_LPX}),                     
            .t_clk_prepare({2'h0, sig_TX_CLK_PREPARE}),   
            .t_clk_zero({1'b0, sig_TX_CLK_ZERO}),           
            .t_clk_pre({4'h0, sig_TX_CLK_PRE}),                     
            .t_clk_trail({1'b0, sig_TX_CLK_TRAIL}),         
            .t_clk_post(sig_TX_CLK_POST),                   
            .t_wake(sig_TX_WAKE),                           
            .t_hs_exit(sig_TX_HS_EXIT),                     
            .t_lp_exit(sig_TX_LP_EXIT),                     
            .dlanes_hs_done(dlanes_hs_done),        
            .clk_pre_done(clk_pre_done),            
            .esc_pulse(esc_pulse),
            .init_done(sig_CLK_STATUS_INIT_DONE_int),
            .auto_cal(auto_alt_cal | auto_skew_cal),
            .auto_cal_done(auto_cal_done),
            .clk_in_stop(clk_in_stop),
            .dphy_port(dphy_port),   
            .dphy_dbg_clane(dphy_dbg_clane),
            .ppi_tx(ppi_tx)  
        );    


    assign sig_DLANE_STATUS_INIT_DONE = sig_DLANE_STATUS_INIT_DONE_int & {NUM_LANES{auto_cal_done}};
    assign sig_CLK_STATUS_INIT_DONE = sig_CLK_STATUS_INIT_DONE_int & auto_cal_done;
 
    if(SKEW_CAL_EN == 1)
    begin: auto_cal_tx_on
            localparam SKEW_CAL_CNT = SKEW_CAL_LEN >> (IO_CONVERT_RATIO == 16 ? 4 : 3);
            localparam ALT_CAL_CNT = ALT_CAL_LEN >> (IO_CONVERT_RATIO == 16 ? 4 : 3);
            localparam SKEW_CAL_CNT_W = $clog2(SKEW_CAL_CNT + 1);
            localparam ALT_CAL_CNT_W = $clog2(ALT_CAL_CNT + 1);
            logic init_all_done, init_all_done_sync;
            logic [SKEW_CAL_CNT_W-1:0] skew_cntr;
            logic [ALT_CAL_CNT_W-1:0] alt_cntr;
            logic incr_skew_cnt;
            logic incr_alt_cnt;
            logic [NUM_LANES-1:0] data_lane_init_done;
            typedef enum  {     
                        IDLE,
                        SKEW,
                        PAUSE,
                        ALT,
                        DONE
                   } auto_sm_t;
            auto_sm_t cs, ns;
        
        assign data_lane_init_done = sig_DLANE_STATUS_INIT_DONE_int | ~data_lane_en;
        assign init_all_done = &data_lane_init_done & sig_CLK_STATUS_INIT_DONE_int;
        assign incr_skew_cnt = auto_skew_cal & &in_cal;
        assign incr_alt_cnt = auto_alt_cal & &in_cal;

        altera_std_synchronizer_nocut # ( .depth(3) ) init_done_sync_inst (
            .clk(core_clk), .reset_n(1'b1), .din(init_all_done), .dout(init_all_done_sync) ); 
        
        always @(posedge core_clk)
        begin
            if(srst_core_n & init_all_done_sync == 1'b0)
            begin
                cs <= IDLE;
                skew_cntr <= 0;
                alt_cntr <= 0;
            end
            else
            begin
                cs <= ns;
                skew_cntr <= (skew_cntr == SKEW_CAL_CNT) ? skew_cntr : skew_cntr + incr_skew_cnt;
                alt_cntr <= (alt_cntr == ALT_CAL_CNT) ? alt_cntr : alt_cntr + incr_alt_cnt;
            end
        end

        always @(*)
            case(cs)
                IDLE:       ns <= init_all_done_sync ? SKEW : cs;    
                SKEW:       ns <= (skew_cntr == SKEW_CAL_CNT) ? (ALT_CAL_EN ? PAUSE : DONE) : cs;   
                PAUSE:      ns <=  (CONTINUOUS_CLK == 0 ? clk_in_stop : dlanes_hs_done) ? ALT : cs;   
                ALT:        ns <= (alt_cntr == ALT_CAL_CNT) ? DONE : cs;
                default:    ns <= cs;                           
            endcase
            
        assign auto_cal_done = cs == DONE;
        assign auto_skew_cal = cs == SKEW;
        assign auto_alt_cal = cs == ALT;
        
    end
    else
    begin: auto_cal_tx_off
        assign auto_cal_done = 1'b1;
        assign auto_skew_cal = 1'b0;
        assign auto_alt_cal = 1'b0;
    end

 
    
 

endmodule 

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oI313tc2tj3UsFdGUNBqDliwuST7f0gw8G3oTmG4Xx2ZmoKtcleT7hHkSeZ/At5H0V80ErJgxqbqGVhhHcEAMF8fwOMyfPwf1hMI4HSx4iQgGpZfhmwrKmdkviLvvxDotW+SZW9/tOTRrNFitTP2DPHxs51WHJVWdRq23MzVa2auYRvOsD91kx+iOT2Z5rlUQVRWTABRe2WQ8azOIPBU5RrRwMDlpsOBnOB8hFHw8SpqXQnsvCbJ9E8MRjGKyxP0kKbooXU4ZsLnebSN4SRo3to6WLEZ1Tb4u/SL36fax6EPeSBRIdT6ox7kvYKFe046oV7KJEwJcX2IDmPzk9UxZJBNF/UmSpMOoWvYOejRHYqF8bZy9SRu0I1xlTDGNZGOz69dUGhfOuDcrtAtBaZDkYWXVnRAT1Fq3gZJuaDIE0X5U+ZvvbpisOF6Wt/M2O/Rgh4MsiwDwfpwfuUWNa5NzVRi8IZHfgrCnNF/qCb3WLENW1lgknigMF7fOkimYClwEFiTtU2/XK+d4ISE0BO25xAvIpDTjzIRv/C4IDyMBbglKVC8Tn9F+OT566b49uX6uIq5m/NO8LjDE0+EWDreQETaTIpb96HakYRe8Pc6p1+3u9mKOqplt1acc2Myx60wt60P9SQIjU3ya6c0tm17tEVX5QQT/uLXK114j3YOrrTeTic42Ix78iAQrytZCwMmbqgl29U5XlcbdwVnGbBQI9nvC2WqGHJSp/aQqKmc6fJCGP2LPzu1LELp3Rq7jcCcMNW2VajT3BoEl8aSCPkEWRl"
`endif