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
module dphy_pcx_rx
#(        
          parameter IO_CONVERT_RATIO = 16,     
          parameter IO_CONVERT_RATIO_C2P = 16,                                       
          parameter NUM_LANES = 4,                                    
          parameter SKEW_CAL_EN = 1,                                  
          parameter ALT_CAL_EN = 1,                                   
          parameter PREAMBLE_EN = 1,                                  
          parameter CONTINUOUS_CLK = 0,                                  
          parameter RX_BIT_RATE_MBPS_SEL = 64, 
          parameter RX_FR_CLK_FREQ = 156000000,
          parameter TM_EN = 0,                                        
          parameter TM_LOOPBACK_MODE = 1
          )
   (
        input  wire             fr_clk,         
        input  wire             fr_clk_1024,    
        input  wire             arst_fr_n,      
        input  wire             srst_fr_n,      
        input sig_DPHY_CSR_Enable,
        input sig_CLK_CSR_CLK_LANE_EN,
        input [NUM_LANES-1:0] sig_DLANE_CSR_EN,             
        input [NUM_LANES-1:0] sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse,
        input [NUM_LANES-1:0] sig_DLANE_CSR_RX_MNL_DESKEW_EN,
        input [NUM_LANES*8-1:0] sig_PRBS_INIT,              
        input [NUM_LANES*7-1:0] sig_RX_DLANE_DESKEW_DELAY,
        output logic [NUM_LANES-1:0] set_RX_DLANE_ERR_SOT_ERR_pulse,      
        output logic [NUM_LANES-1:0] set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse, 
        output logic [NUM_LANES-1:0] set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse, 
        output logic [NUM_LANES-1:0] set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse,
        output logic [NUM_LANES-1:0] set_RX_DLANE_ERR_LPDT_ERR_pulse,     
        output logic [NUM_LANES-1:0] set_RX_DLANE_ERR_CTRL_ERR_pulse,     
        output logic [NUM_LANES-1:0] set_RX_DLANE_ERR_CAL_ERR_pulse,      
        input [7:0] sig_RX_CLK_LOSS_DETECT,
        input [7:0] sig_RX_CLK_SETTLE,
        input [7:0] sig_RX_HS_SETTLE,
        input [7:0] sig_RX_INIT,
        input [7:0] sig_RX_CLK_POST,
        input sig_RX_CAL_REG_CTRL_CAL_RESET_pulse,
        output logic [NUM_LANES*8-1:0] sig_RX_CAL_SKEW_W_START,
        output logic [NUM_LANES*8-1:0] sig_RX_CAL_SKEW_W_END,
        output logic [NUM_LANES*8-1:0] sig_RX_CAL_ALT_W_START,
        output logic [NUM_LANES*8-1:0] sig_RX_CAL_ALT_W_END,
        output logic [NUM_LANES*7-1:0] sig_RX_DESKEW_DELAY,
        output logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE,
        output logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE,
        output logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE,
        output logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE,
        output logic [NUM_LANES-1:0] sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE,
        output logic [NUM_LANES-1:0] sig_DLANE_STATUS_INIT_DONE,
        output logic  sig_CLK_STATUS_INIT_DONE,
        input sig_RX_TM_CONTROL_RX_TM_EN,
        input sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE,
        input sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse,
        input [7:0] sig_RX_PREP_TIME_TM,
        output logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B0,
        output logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B1,
        output logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B2,
        output logic [NUM_LANES*8-1:0] sig_RX_BER_CNT_B3,
        
        dphy_io_if              dphy_port,    
        dphy_dbg_dlane          dphy_dbg_dlane[7:0],
        dphy_dbg_clane          dphy_dbg_clane,

        ppi_if                  ppi_rx      
    );
    
    localparam RESET_PIPE_DEPTH = 2;
    localparam RX_PCS_DATA_HYPERPIPE_DEPTH = RX_PCS_DATA_HYPERPIPE_DEPTH_DEFAULT;
    localparam CAL_DELAY_CHANGE_PIPE = CAL_IP_DELAY_CHANGE_PIPE_DEFAULT;

    localparam [7:0] T_WAKE_ULPS = int'($floor(real'(RX_FR_CLK_FREQ/(1024*1000))));
        
    int i;
    genvar j;
    
    logic [1:0] rx_clk;
    logic [1:0] arst_rx_n;
    logic [1:0] srst_rx_0_n;
    logic [1:0] srst_rx_n;

    logic [NUM_LANES-1:0]   lane_in_cal;
    logic [NUM_LANES:0]     init_done;
    logic [NUM_LANES:0]     init_done_en;
    logic [NUM_LANES:0]     ppi_enable_fr;
    logic [NUM_LANES-1:0]   data_lane_en;
    logic [NUM_LANES-1:0]   link_dqs_del_up_req;
    logic [NUM_LANES-1:0]   link_dqs_del_up_ack;
    logic dqs_del_up_req_all;
    logic dqs_del_up_ack_all;
    logic cal_clk_en;
    logic [CAL_CLK_GATE_WIDTH-1:0] cal_clk_gate;
    logic [1:0] alt_skip_en;



    assign dqs_del_up_req_all = &(~lane_in_cal | link_dqs_del_up_req);
    assign link_dqs_del_up_ack = lane_in_cal & { NUM_LANES { dqs_del_up_ack_all } };
    assign cal_clk_en = ~|cal_clk_gate;
    assign dqs_del_up_ack_all = cal_clk_gate[0];
    assign sig_DLANE_STATUS_INIT_DONE = init_done[NUM_LANES-1:0];
    assign sig_CLK_STATUS_INIT_DONE = init_done[NUM_LANES];
    assign init_done_en = { init_done[NUM_LANES], init_done[NUM_LANES-1:0] | ~data_lane_en };
    
    always @(posedge fr_clk or negedge arst_fr_n)
        if(arst_fr_n == 1'h0 || |lane_in_cal == 1'b0 || &init_done_en == 1'b0)
            cal_clk_gate <= 1'b0;
        else
            cal_clk_gate <= { cal_clk_gate[CAL_CLK_GATE_WIDTH-2:0], cal_clk_en & dqs_del_up_req_all };

    if (NUM_LANES < 8) begin : byte1_stub
       assign arst_rx_n[1] = 1'b1;
       assign srst_rx_n[1] = 1'b1;
    end 
   
    genvar byte_n;
    for(byte_n = 0; byte_n < (NUM_LANES > 4 ? 2 :1); byte_n++)
    begin : rst_sync
        altera_std_synchronizer_nocut # ( .depth(3) ) cdc_async_rst_rx (
            .clk(rx_clk[byte_n]), .reset_n(arst_fr_n), .din(1'b1), .dout(arst_rx_n[byte_n]) );           
        altera_std_synchronizer_nocut # ( .depth(3) ) cdc_sync_rst_rx (
            .clk(rx_clk[byte_n]), .reset_n(1'b1), .din(arst_rx_n[byte_n]), .dout(srst_rx_0_n[byte_n]) );
        hyperpipe # ( .WIDTH(1), .CYCLES(RESET_PIPE_DEPTH) ) sync_rst_rx_pipe (
            .clk(rx_clk[byte_n]), .din( srst_rx_0_n[byte_n] ), .dout( srst_rx_n[byte_n] ) );
        assign rx_clk[byte_n] = dphy_port.rx_clk[byte_n];
    end
    
    
    altera_std_synchronizer_nocut # ( .depth(3) ) cdc_DPHY_CSR_Enable (
        .clk(fr_clk), .reset_n(arst_fr_n), .din(sig_DPHY_CSR_Enable), .dout(sig_DPHY_CSR_Enable_fr) );               
    
    genvar nlane;
    for(nlane = 0; nlane < NUM_LANES+1; nlane++)
    begin : ppi_enable_sync
        altera_std_synchronizer_nocut # ( .depth(3) ) cdc_PPI_Enable (
            .clk(fr_clk), .reset_n(arst_fr_n), .din(ppi_rx.Enable[nlane]), .dout(ppi_enable_fr[nlane]) );               
    end
    
    assign data_lane_en = ppi_enable_fr[NUM_LANES-1:0] & sig_DLANE_CSR_EN;
    
    for(j=0; j<NUM_LANES; j++)
    begin : dphy_pcs_dlanes
    
        dphy_pcx_data_rx #(
                .IO_CONVERT_RATIO(IO_CONVERT_RATIO),     
                .IO_CONVERT_RATIO_C2P(IO_CONVERT_RATIO_C2P), 
                .SKEW_CAL_EN(SKEW_CAL_EN),               
                .ALT_CAL_EN(ALT_CAL_EN),                 
                .PREAMBLE_EN(PREAMBLE_EN),               
                .TM_EN(TM_EN),                           
                .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE),     
                .LANE_ID(j),
                .NUM_LANES(NUM_LANES),
                .RX_PCS_DATA_HYPERPIPE_DEPTH(RX_PCS_DATA_HYPERPIPE_DEPTH),
                .RX_FR_CLK_FREQ(RX_FR_CLK_FREQ)
            ) pcs_data_rx
        (
                .fr_clk(fr_clk),    
                .fr_clk_1024(fr_clk_1024),                
                .arst_rx_n(j < 4 ? arst_rx_n[0] : arst_rx_n[1]),
                .arst_fr_n(arst_fr_n),
                .srst_fr_n(srst_fr_n),
                .srst_rx_n(j < 4 ? srst_rx_n[0] : srst_rx_n[1]),    
                .enable(sig_DPHY_CSR_Enable_fr & data_lane_en[j]),   
                .t_init(sig_RX_INIT),
                .t_hs_settle(sig_RX_HS_SETTLE), 
                .t_hs_skip(8'h00),                     
                .t_wake_ulps(T_WAKE_ULPS),
                .recal_p(sig_RX_CAL_REG_CTRL_CAL_RESET_pulse),
                .cal_prbs_init(sig_PRBS_INIT[j*8+:8]),
                .delay_val_update_p(sig_DLANE_CSR_RX_DESKEW_UPDATE_pulse[j]),
                .manual_skew_en(sig_DLANE_CSR_RX_MNL_DESKEW_EN[j]),
                .manual_skew_val(sig_RX_DLANE_DESKEW_DELAY[j*7+:7]),
                .tm_en(sig_RX_TM_CONTROL_RX_TM_EN),
                .tm_loopback(sig_RX_TM_CONTROL_RX_TM_LOOPBACK_MODE),
                .tm_cnt_rst_p(sig_RX_TM_CONTROL_RX_TST_CNT_RST_pulse),
                .tm_prep_time(sig_RX_PREP_TIME_TM),
                .sot_err_p(set_RX_DLANE_ERR_SOT_ERR_pulse[j]),     
                .sot_sync_err_p(set_RX_DLANE_ERR_SOT_SYNC_ERR_pulse[j]), 
                .eot_err_p(set_RX_DLANE_ERR_EOT_SYNC_ERR_pulse[j]), 
                .esc_entry_err_p(set_RX_DLANE_ERR_ESC_ENTRY_ERR_pulse[j]),
                .lpdt_err_p(set_RX_DLANE_ERR_LPDT_ERR_pulse[j]),     
                .ctrl_err_p(set_RX_DLANE_ERR_CTRL_ERR_pulse[j]),     
                .cal_err_p(set_RX_DLANE_ERR_CAL_ERR_pulse[j]),   
                .cal_w_start(sig_RX_CAL_SKEW_W_START[j*8+:8]),
                .cal_w_end(sig_RX_CAL_SKEW_W_END[j*8+:8]),
                .cal_w_start_alt(sig_RX_CAL_ALT_W_START[j*8+:8]),
                .cal_w_end_alt(sig_RX_CAL_ALT_W_END[j*8+:8]),
                .cal_delay_val(sig_RX_DESKEW_DELAY[j*7+:7]),
                .alt_skip_en(j < 4 ? alt_skip_en[0] : alt_skip_en[1]),
                .ber_cnt({sig_RX_BER_CNT_B3[j*8+:8], sig_RX_BER_CNT_B2[j*8+:8], sig_RX_BER_CNT_B1[j*8+:8], sig_RX_BER_CNT_B0[j*8+:8]}),
                .in_cal(lane_in_cal[j]),
                .dqs_del_up_req(link_dqs_del_up_req[j]),
                .dqs_del_up_ack(link_dqs_del_up_ack[j]),
                .init_done(init_done[j]),
                .cal_done_skew(sig_RX_CAL_STATUS_LANE_SKEW_CAL_DONE_LANE[j]), 
                .cal_done_alt(sig_RX_CAL_STATUS_LANE_ALT_CAL_DONE_LANE[j]),
                .cal_err_skew(sig_RX_CAL_STATUS_LANE_INIT_SKEW_CAL_ERR_LANE[j]),
                .cal_err_skew_per(sig_RX_CAL_STATUS_LANE_PER_SKEW_CAL_ERR_LANE[j]),
                .cal_err_alt(sig_RX_CAL_STATUS_LANE_ALT_CAL_ERR_LANE[j]),

                .dphy_port(dphy_port),
                .dphy_dbg_dlane(dphy_dbg_dlane[j]),
                
               .ppi_rx(ppi_rx)  
            );    

    end    

    assign clk_lane_enable = sig_CLK_CSR_CLK_LANE_EN & sig_DPHY_CSR_Enable_fr & ppi_enable_fr[NUM_LANES];

    dphy_pcx_clk_rx  # (
            .NUM_LANES(NUM_LANES),
            .CONTINUOUS_CLK(CONTINUOUS_CLK),
            .RX_FR_CLK_FREQ(RX_FR_CLK_FREQ)
        ) pcs_clk_rx (
            .fr_clk(fr_clk),                        
            .fr_clk_1024(fr_clk_1024),              
            .arst_fr_n(arst_fr_n),                  
            .srst_fr_n(srst_fr_n),                  
            .arst_rx_n(arst_rx_n),                  
            .srst_rx_n(srst_rx_n),                  
            .enable(clk_lane_enable),               
            .init_done(init_done[NUM_LANES]),
            .cal_clk_en(cal_clk_en),                
            .in_cal(|lane_in_cal),                  
            .alt_skip_en(alt_skip_en),              
            .t_clk_settle(sig_RX_CLK_SETTLE),       
            .t_clk_miss(sig_RX_CLK_LOSS_DETECT),    
            .t_init(sig_RX_INIT),                   
            .t_clk_post(sig_RX_CLK_POST),           
            .t_wake_ulps(T_WAKE_ULPS),              
            .dphy_port(dphy_port),            
            .dphy_dbg_clane(dphy_dbg_clane),
            .ppi_rx(ppi_rx)  
        );    
 

endmodule 

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oLLhVYbcsj6FcsfZ901ERXL+M1B/w3MMix2i1boQ78J6PMpd/NDlovpyoXBylmx0YNLAT+YkmcMuxRbvTGDqCdUfohxU2MPqdZshdDcsMTEYpG8EcLAeqSbYe3I3mi86SKOQPDJ3vaKxr+cC1bK+ry2tcmD+5djGhbvDE3Rqd4hMScv+MQbEtnU2hY0yM2byM1RDy9WSEkBNpVEYuUJYe3WOvIfVzIl9EEOyd5gJC7mkiDEte8FPICpfn4xHKlg0zM2vFToT0iwqCnX0LWrZR9k77T5yYdexocPatadvG9I/levQFSN60Ao/7RiGslD+SN62csJl6JJKorINzDys1KNbey3OEJOlWBLkoBQiGTM7jyydKlv3uvjw1JhLn8C/JYra7r0b/d+G4w5POyOI527KNhS/3kBkz3pwWu2/uZY2PPUG0EryYz2nDonRXSnrIkiNl6qwBCjOGxG5b+DWsXF2d5CeHqi9NPqvdpOnhvnniqS79uLM3zt8lRCPVpHk/AEInXmnsC1bWY0ytvMHj0Mvgb1MgzuRrkQB2JaMMo0rXjNfDuOAgkhtGs6IhJlD4hlh4R1N42gnMdxQdQdtYrlTMtEEgQwjIfvc2lO4h9tPU8RG6i4trFQ1vhkTDoRMqnt0e9IiivTeg5NFMGRtXG/n4u5awE7kfP+TcrDonM1C0HRx+dIgyZcbr/XZaGwTxkzmJhPTrF8PjeWk/Vcvb+G8YQ6sIMkvWaXndSMHfhag67p3NfDZna8XlmAwlKLNY4bbnZHO6acNxa/M8fe7UrY"
`endif