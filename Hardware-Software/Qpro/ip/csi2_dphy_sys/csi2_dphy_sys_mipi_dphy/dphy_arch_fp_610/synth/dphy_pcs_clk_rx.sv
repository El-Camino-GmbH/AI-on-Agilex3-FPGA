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



module dphy_pcx_clk_rx # (
    parameter NUM_LANES = 4,
    parameter CONTINUOUS_CLK = 0,
    parameter RX_FR_CLK_FREQ = 93750000
   ) (
        input  wire             fr_clk,          
        input  wire             fr_clk_1024,
        input  wire             arst_fr_n,
        input  wire             srst_fr_n,
        input  wire [1:0]       arst_rx_n,
        input  wire [1:0]       srst_rx_n,
        input  wire             enable,
        output logic            init_done,
        output logic [1:0]      alt_skip_en,
        input  wire             cal_clk_en,
        input  wire             in_cal,
        input wire [7:0]        t_clk_settle,
        input wire [7:0]        t_clk_miss,   
        input wire [7:0]        t_init,   
        input wire [7:0]        t_clk_post, 
        input wire [7:0]        t_wake_ulps,
        dphy_io_if              dphy_port,    
        dphy_dbg_clane          dphy_dbg_clane, 
        ppi_if                  ppi_rx
    );

   
   
    typedef enum {
                ESC_IDLE,
                HS_REQ,
                HS_ACTIVE,
                ULPS_REQ,
                ULPS,
                ULPS_ABORT,
                ULPS_EXIT,
                ULPS_WAKE
             } rx_clk_sm_t;
             
    rx_clk_sm_t esc_c_st;

    logic [1:0]                     rx_clk;  
    logic                           rx_clk_lp_p;
    logic                           rx_clk_lp_n;
    logic                           rx_clk_lp_hs_b;
    logic [3:0]                     rx_data_read_en;
    
    logic rx_clk_lp_p_q, rx_clk_lp_p_deglitch;
    logic rx_clk_lp_n_q, rx_clk_lp_n_deglitch;
    logic c_lp_p_s_fr, c_lp_n_s_fr;
    logic val_c_lp_p_s_fr, val_c_lp_n_s_fr;
    
    logic lpctrl_hs_req_fr; 
    logic lpctrl_hs_stop_fr;
    logic lpctrl_hs_diff_fr;
    logic lpctrl_ulps_active_fr;
    logic lpctrl_ulps_req_fr;
    logic lpctrl_ulps_fr;

    logic clk_valid;
    logic clk_active;
    
    logic [1:0] lp_pn;
    logic lp_xor;

    logic pcomp_en;
    logic pcomp_pulse;
    logic all_data_stop;
    logic all_data_stop_q;
    logic all_data_stop_pedge;
    logic post_req_fr;
    logic post_req_rx;
    logic post_req_rx_q;
    logic post_ack_fr;
    logic post_ack_fr_q;
    logic post_ack_rx;
    logic post_ack_ignore;
    logic post_pending;
    logic [7:0] clk_post_cnt;
    logic post_cnt_load;
    logic post_tout;

    logic twake_cnt, twake_done;
    
    altera_std_synchronizer_nocut  # ( .depth(2), .rst_value(0) ) cdc_sync_lp_p_fr (
        .clk(fr_clk), .reset_n(srst_fr_n), .din(rx_clk_lp_p), .dout(rx_clk_lp_p_deglitch) );
    altera_std_synchronizer_nocut  # ( .depth(2), .rst_value(0) ) cdc_sync_lp_n_fr (
        .clk(fr_clk), .reset_n(srst_fr_n), .din(rx_clk_lp_n), .dout(rx_clk_lp_n_deglitch) );    

    always @(posedge fr_clk)
    begin
        rx_clk_lp_p_q <= rx_clk_lp_p_deglitch;
        rx_clk_lp_n_q <= rx_clk_lp_n_deglitch;
        c_lp_p_s_fr <= (rx_clk_lp_p_q == rx_clk_lp_p_deglitch) ? rx_clk_lp_p_q : c_lp_p_s_fr;
        c_lp_n_s_fr <= (rx_clk_lp_n_q == rx_clk_lp_n_deglitch) ? rx_clk_lp_n_q : c_lp_n_s_fr;
    end
    
    


    assign lp_pn = {c_lp_p_s_fr, c_lp_n_s_fr};
    assign lp_xor = c_lp_p_s_fr ^ c_lp_n_s_fr;
   always @(posedge fr_clk)
     if (srst_fr_n == 1'b0 || init_done == 1'b0)
       begin
          esc_c_st <= ESC_IDLE;
          twake_cnt <= 1'b0;
       end
     else
       begin
          if (lp_pn == LPCTRL_STOP)
            begin
               twake_cnt <= 1'b0;
               if ((esc_c_st == ULPS_EXIT) && (~twake_done))
                 esc_c_st <= ULPS_EXIT;
               else
                 esc_c_st <= ESC_IDLE;
            end
          else
            begin
               case(esc_c_st)
                 ESC_IDLE   :
                   begin
                      if(lp_pn == LPCTRL_LP_RQST) esc_c_st <= ULPS_REQ;
                      if(lp_pn == LPCTRL_HS_RQST) esc_c_st <= HS_REQ;
                   end
                 HS_REQ     :  if(lp_pn == LPCTRL_BRIDGE) esc_c_st <= HS_ACTIVE;
                 ULPS_REQ   :
                   if (lp_pn == ESC_SPACE)
                     esc_c_st <= ULPS;
                   else if (lp_pn == ESC_MARK_0)
                     esc_c_st <= ULPS_ABORT;
                 ULPS       : 
                   if(lp_pn == ESC_MARK_1)
                     begin
                        esc_c_st <= ULPS_EXIT;
                        twake_cnt <= 1'b1;                        
                     end
                 ULPS_EXIT  : 
                   if(twake_done)
                     begin
                        esc_c_st <= ULPS_WAKE;
                        twake_cnt <= 1'b0;
                     end
                   else
                     begin
                        esc_c_st <= ULPS_EXIT;
                        if (lp_pn == ESC_MARK_1)
                          twake_cnt <= 1'b1;
                        else
                          twake_cnt <= 1'b0;                        
                     end
                 ULPS_ABORT, ULPS_WAKE, HS_ACTIVE   : ;
                 default    : esc_c_st <= ESC_IDLE;
               endcase
            end 
       end
    
    assign lpctrl_hs_req_fr = esc_c_st == HS_REQ;
    assign lpctrl_hs_diff_fr = esc_c_st == HS_ACTIVE;
    assign lpctrl_ulps_fr = esc_c_st == ULPS || esc_c_st == ULPS_EXIT || esc_c_st == ULPS_WAKE || esc_c_st == ULPS_ABORT;
    assign lpctrl_ulps_req_fr = esc_c_st == ULPS_REQ;
    assign lpctrl_ulps_active_fr = esc_c_st == ULPS;
    assign lpctrl_hs_stop_fr = lp_pn == LPCTRL_STOP;


    assign rx_clk[0] =                          dphy_port.rx_clk[0];    
    assign rx_clk[1] =                          NUM_LANES > 4 ? dphy_port.rx_clk[1] : 1'b0;    
    assign rx_clk_lp_p =                        dphy_port.rx_clk_lp_p;
    assign rx_clk_lp_n =                        dphy_port.rx_clk_lp_n;
    assign dphy_port.rx_clk_lp_hs_b =           rx_clk_lp_hs_b;
    assign dphy_port.rx_data_read_en =          rx_data_read_en & { 4 {cal_clk_en } };

    assign ppi_rx.RxSRst_n[NUM_LANES] = srst_rx_n[0];
    assign ppi_rx.RxWordClkHS[NUM_LANES] = rx_clk[0];
    
    assign ppi_rx.RxClkActiveHS[NUM_LANES] = clk_active ;                           
    assign ppi_rx.RxActiveHS[NUM_LANES] =    lpctrl_hs_diff_fr;                     
    assign ppi_rx.RxDDRClkHS =               { (NUM_LANES+1) { 1'b0 } };            
    assign ppi_rx.RxUlpsClkNot[NUM_LANES] =  ~lpctrl_ulps_fr; 


    assign ppi_rx.RxClkEsc [NUM_LANES]        = lp_xor;
    assign ppi_rx.RxLpdtEsc [NUM_LANES]       = 1'b0;
    assign ppi_rx.RxUlpsEsc [NUM_LANES]       = lpctrl_ulps_fr;
    assign ppi_rx.RxTriggerEsc [NUM_LANES]    = 'h0;
    assign ppi_rx.RxWakeup [NUM_LANES]        = 1'b0;
    assign ppi_rx.RxDataEsc [NUM_LANES]       = 'h0 ;
    assign ppi_rx.RxValidEsc [NUM_LANES]      = 'h0;

    assign ppi_rx.RxSkewCalHS[NUM_LANES] = 1'b0;
    assign ppi_rx.RxAlternateCalHS[NUM_LANES] = 1'b0;
    assign ppi_rx.RxErrorCalHS[NUM_LANES] = 1'b0;
    assign ppi_rx.Direction[NUM_LANES] = 1'b1;
    assign ppi_rx.Stopstate[NUM_LANES] = init_done & lpctrl_hs_stop_fr;
    assign ppi_rx.UlpsActiveNot[NUM_LANES] = ~lpctrl_ulps_active_fr;
    assign ppi_rx.ErrSotHS[NUM_LANES] = 1'b0;
    assign ppi_rx.ErrSotSyncHS[NUM_LANES] = 1'b0;
    assign ppi_rx.ErrEsc[NUM_LANES] = 1'b0;
    assign ppi_rx.ErrSyncEsc[NUM_LANES] = 1'b0;
    assign ppi_rx.ErrControl[NUM_LANES] = 1'b0;
    assign ppi_rx.ErrContentionLP0[NUM_LANES] = 1'b0;
    assign ppi_rx.ErrContentionLP1[NUM_LANES] = 1'b0;   




   logic rx_clk_lp_n_q1;   
   logic rx_clk_lp_n_termen;

   if (RX_FR_CLK_FREQ >= 93750000)
     begin : termen_reg
        always @(posedge fr_clk or negedge arst_fr_n)
          if (arst_fr_n == 1'b0)
            rx_clk_lp_n_q1 <= 1'b1;
          else
            rx_clk_lp_n_q1 <= rx_clk_lp_n;
     end
   else
     begin : termen_stub
        assign rx_clk_lp_n_q1 = 1'b0;
     end   
   
   assign rx_clk_lp_n_termen = ~(rx_clk_lp_n_q1 | rx_clk_lp_n);
   
   always @(*)
        rx_clk_lp_hs_b <= ~(lpctrl_hs_diff_fr | (lpctrl_hs_req_fr & rx_clk_lp_n_termen));
        
    dphy_pcs_clk_timing_rx  # (
            .NUM_LANES(NUM_LANES),                   
            .CONTINUOUS_CLK(CONTINUOUS_CLK)
    ) timing_blk 
    (
       .arst_rx_n(arst_rx_n),
       .rx_clk(rx_clk),     
       .srst_rx_n(srst_rx_n),     
       .fr_clk(fr_clk),
       .fr_clk_1024(fr_clk_1024),  
       .srst_fr_n(srst_fr_n),
       .enable(enable),
       .in_cal(in_cal),
       .lpctrl_hs_req_fr (lpctrl_hs_req_fr ),
       .lpctrl_hs_stop_fr(lpctrl_hs_stop_fr),
       .lpctrl_hs_diff_fr(lpctrl_hs_diff_fr),
       .lpctrl_ulps_fr(lpctrl_ulps_fr),
       .twake_cnt(twake_cnt),
       .t_clk_settle(t_clk_settle), 
       .t_clk_miss(t_clk_miss),
       .t_init(t_init),
       .t_wake_ulps(t_wake_ulps),   
       .alt_skip_en(alt_skip_en),
       .init_done(init_done),
       .clk_active(clk_active),
       .clk_valid(clk_valid),                   
       .twake_done(twake_done)      
    );
    
    
    always @(posedge fr_clk or negedge arst_fr_n)
        if (arst_fr_n == 1'b0)
            rx_data_read_en <= 'h0;
        else
            rx_data_read_en <= {4{clk_valid & ~pcomp_en}};

    assign pcomp_en = CONTINUOUS_CLK == 0 ? 1'b0 : pcomp_pulse;

    if(CONTINUOUS_CLK == 1)
    begin: cont_clk_blk

        assign all_data_stop = &ppi_rx.Stopstate_fr[NUM_LANES-1:0];
        assign all_data_stop_pedge = ~all_data_stop_q & all_data_stop & init_done;
        assign post_pending = post_req_fr ^ post_ack_fr;
        assign pcomp_pulse = ~post_ack_ignore & ( post_ack_fr ^ post_ack_fr_q ) & all_data_stop;
        
        always @(posedge fr_clk)
            if (srst_fr_n == 1'b0)
            begin
                all_data_stop_q <= 1'b0;
                post_req_fr <= 1'b0;
                post_ack_fr_q <= 1'b0;
                post_ack_ignore <= 1'b0;
            end
            else
            begin
                all_data_stop_q <= all_data_stop;
                post_req_fr <= (~post_pending & all_data_stop_pedge) ^ post_req_fr;
                post_ack_fr_q <= post_ack_fr;
                post_ack_ignore <= all_data_stop_pedge ? post_pending : post_ack_ignore;
            end
        
        altera_std_synchronizer_nocut  # ( .depth(3), .rst_value(0) ) cdc_sync_postack_fr (
           .clk(fr_clk), .reset_n(srst_fr_n), .din(post_ack_rx), .dout(post_ack_fr) );

        altera_std_synchronizer_nocut  # ( .depth(3), .rst_value(0) ) cdc_sync_postreq_rx (
           .clk(rx_clk[0]), .reset_n(srst_rx_n[0]), .din(post_req_fr), .dout(post_req_rx) );


        always @(posedge rx_clk[0] or negedge arst_rx_n[0])
            if(arst_rx_n[0] == 1'b0)
            begin
                clk_post_cnt <= 8'h0;
                post_req_rx_q <= 1'b0;
                post_ack_rx <= 1'b0;
            end
            else
            begin
                clk_post_cnt <= post_cnt_load ? t_clk_post : clk_post_cnt - |clk_post_cnt;
                post_req_rx_q <= post_req_rx;
                post_ack_rx <= post_tout ^ post_ack_rx;
            end

        assign post_cnt_load = post_req_rx_q ^ post_req_rx;
        assign post_tout = ~|clk_post_cnt[7:1] & clk_post_cnt[0];
    end
    
endmodule 


`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJsFq/h6X6MJ3ZL79mLy4e6wxugJTTszJ8tk0bztz+o4QmD6Ikx729nuO7uvFdzSrWI82UO62DLnqPM93YNlZdt0jIZJ1kZWlo27INHGcKlD0eCYxw5RC+VvKUSguJn/aOoWAMBL9f+pgHErcmpCXmT5WlcDTzweHAsv3p7F+XVlfX4VSvBeZ6JNKiMjOX0iHgu/gD6ya2TIrOGbhPO3Tg/YsFt2hOmybjPCCfkFIDFhDUpQfyYlpujTnZpRU+uaQRDMNAKIIFevC28N2CmAJzZC0aB7ioDgidNcN/LUAoGltiXFuqL5qcWBVYjwKjPTL5rLFP+4XByC85IDpU+dsY4ucZwB/QEpgpQ44PYgrM40+F57UQ8TZ4cYZ2gCYXlHFj2C+er4N7Hl9X3MtqntOL65uZFgHSIy6uCeCRuLF+asyY8MHW36S3owqIb65TT5QeZG+P4KUVon2xL61Q3O2VJ13vs4MivpHurFup2ouC4vC+/K6KS8s52hRkg9CeYjY2fGPElK+3BuiQfBV2F4V30uJmO9ks5Daje7SoSVV2jd3BuKmqa1LtKfJWOAra6US3VKMUQnw+CLUFr9N8V3ysJ2/1v0sFAHhZBh3yN6u0JrwOIVGE+cs8/tnWbTI9otV2i24pH/8IByYUFZIsDyy4L7V666jAbcNug28SBexOA5oXFC+8sb5LRfkee1AJOsnViUfwCha1pgzIfFqW1gzJUZV/y9U+dtEGc7DmSIcRq8c7V8dTCS6Vz9T8d0YnSr/LaSCkHiBy/JAs9s80LM8wH"
`endif