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

`timescale 1ns / 10 ps

module dphy_pcx_data_rx #(
        parameter IO_CONVERT_RATIO = 16,
        parameter IO_CONVERT_RATIO_C2P = 16,
        parameter SKEW_CAL_EN = 0,
        parameter ALT_CAL_EN = 0,
        parameter PREAMBLE_EN = 0,
        parameter TM_EN = 0,
        parameter TM_LOOPBACK_MODE = 0,
        parameter LANE_ID = 0,
        parameter NUM_LANES = 4,
        parameter RX_PCS_DATA_HYPERPIPE_DEPTH = RX_PCS_DATA_HYPERPIPE_DEPTH_DEFAULT,
        parameter CAL_DELAY_CHANGE_PIPE = CAL_IP_DELAY_CHANGE_PIPE_DEFAULT,
        parameter RX_FR_CLK_FREQ = 93750000

    )
   (
        input wire          fr_clk, 
        input wire          fr_clk_1024, 
        input wire          arst_fr_n, 
        input wire          srst_fr_n, 
        input wire          arst_rx_n,
        input wire          srst_rx_n, 
        input wire          enable,
        
        input wire [7:0]    t_init,
        input wire [7:0]    t_hs_settle, 
        input wire [7:0]    t_hs_skip, 
        input wire [7:0]    t_wake_ulps,
        input wire          recal_p,
        input wire [7:0]    cal_prbs_init,
        input wire          delay_val_update_p,
        input wire          manual_skew_en,
        input wire [6:0]    manual_skew_val,
        input wire          tm_en,
        input wire          tm_loopback,
        input wire          tm_cnt_rst_p,
        input wire [7:0]    tm_prep_time,
        output logic        sot_err_p, 
        output logic        sot_sync_err_p, 
        output logic        eot_err_p, 
        output logic        esc_entry_err_p,
        output logic        lpdt_err_p, 
        output logic        ctrl_err_p, 
        output logic        cal_err_p, 
        output logic [7:0]  cal_w_start,
        output logic [7:0]  cal_w_end,
        output logic [7:0]  cal_w_start_alt,
        output logic [7:0]  cal_w_end_alt,
        output logic [6:0]  cal_delay_val,
        output logic [31:0] ber_cnt,
        
        output              in_cal,
        output              dqs_del_up_req,
        input               dqs_del_up_ack,
        input               alt_skip_en,
        output              init_done,
        output              cal_done_skew, 
        output              cal_done_alt,
        output              cal_err_skew,
        output              cal_err_skew_per,
        output              cal_err_alt,
                            dphy_io_if dphy_port, 
                            dphy_dbg_dlane dphy_dbg_dlane,
                            ppi_if ppi_rx
    );
    
    localparam RESET_PIPE_DEPTH = RX_DATA_RESET_PIPE_DEPTH;
    
    logic                           rx_clk;         
    logic [IO_CONVERT_RATIO-1:0]    rx_rd_data; 
    logic [3:0]                     rx_rd_valid;   
    logic                           rx_data_lp_p;
    logic                           rx_data_lp_n;
    logic                           rx_data_lp_hs_b;
    logic [15:0]                    rx_data_deskew_cntrl;

    logic [IO_CONVERT_RATIO-1:0]    dout;
    logic din_valid, din_valid_q;                            
    logic dout_valid;

    logic sync_search_req;
    logic sync_search_found;
    logic sot_err;
    logic is_skew_cal;
    logic is_alt_cal;
    logic is_preamble;
    logic is_alp_ctrl;
    logic is_hs_data;
    logic active_hs;
    logic sync_hs;
    logic data_valid_hs;
    logic skew_cal_hs;       
    logic alt_cal_hs;         
    logic cal_done, cal_err;
    logic alt_cal_valid;
    
    
    
    logic rx_data_lp_p_fr_q, rx_data_lp_p_fr;
    logic rx_data_lp_n_fr_q, rx_data_lp_n_fr; 

    logic rx_data_lp_11, rx_data_lp_11_q, rx_data_lp_11_deglitch;

    logic d_lp_p_s_fr, d_lp_n_s_fr;
    
   logic  is_hs_req;
   logic  is_hs;
   logic  is_lp_req;
   logic  is_lp;
   logic  is_stop;
   logic  init_stop;
   logic  is_ulps;
   logic  ulps_wake_cnt;
   logic  ulps_wake_done;
   
    logic force_rx_mode;        


   assign ber_cnt = 32'd0;   
   
   logic  init_done_q, init_done_qq;   
   logic  init_done_pedge_pulse, init_done_pedge_pulse_q;
   
   always @(posedge fr_clk)
     if (srst_fr_n == 1'b0)
       begin
	init_done_q <= 1'b0;
	init_done_qq <= 1'b0;
	init_done_pedge_pulse_q <= 1'b0;
       end
     else
       begin
	  init_done_q <= init_done;
	  init_done_qq <= init_done_q;
	  init_done_pedge_pulse_q <= init_done_pedge_pulse;	  
       end

   assign init_done_pedge_pulse = ~init_done_qq && init_done_q;
   assign init_done_delay_upd_en = init_done_pedge_pulse || init_done_pedge_pulse_q;   
   

    altera_std_synchronizer_nocut  # ( .depth(2), .rst_value(1) ) cdc_sync_lp_p_fr (
        .clk(fr_clk), .reset_n(srst_fr_n), .din(rx_data_lp_p), .dout(rx_data_lp_p_fr) );
    altera_std_synchronizer_nocut  # ( .depth(2), .rst_value(1) ) cdc_sync_lp_n_fr (
        .clk(fr_clk), .reset_n(srst_fr_n), .din(rx_data_lp_n), .dout(rx_data_lp_n_fr) );


    always @(posedge fr_clk)
    begin
        rx_data_lp_p_fr_q <= rx_data_lp_p_fr;
        rx_data_lp_n_fr_q <= rx_data_lp_n_fr;
        d_lp_p_s_fr <= (rx_data_lp_p_fr_q === rx_data_lp_p_fr) ? rx_data_lp_p_fr_q : d_lp_p_s_fr;
        d_lp_n_s_fr <= (rx_data_lp_n_fr_q === rx_data_lp_n_fr) ? rx_data_lp_n_fr_q : d_lp_n_s_fr;
    end
    
    always @(posedge rx_clk or negedge arst_rx_n)
    begin
        if(arst_rx_n == 1'b0)
            init_stop <= 1'b1;
        else
            init_stop <= ~active_hs;
    end

    always @(posedge fr_clk)
    begin
        rx_data_lp_11 <= rx_data_lp_p & rx_data_lp_n;
        rx_data_lp_11_q <= rx_data_lp_11;
        rx_data_lp_11_deglitch <= (rx_data_lp_11 == rx_data_lp_11_q) ? rx_data_lp_11_q : rx_data_lp_11_deglitch;
    end



    
    assign rx_clk =                                             LANE_ID < 4 ? dphy_port.rx_clk[0] : dphy_port.rx_clk[1] ; 
    assign rx_rd_data =                                         dphy_port.rx_rd_data[LANE_ID*IO_CONVERT_RATIO +: IO_CONVERT_RATIO]; 
    assign rx_rd_valid =                                        dphy_port.rx_rd_valid;         
    assign rx_clk_lp_p =                                        dphy_port.rx_clk_lp_p;
    assign rx_clk_lp_n =                                        dphy_port.rx_clk_lp_n;
    assign rx_data_lp_p =                                       dphy_port.rx_data_lp_p[LANE_ID];
    assign rx_data_lp_n =                                       dphy_port.rx_data_lp_n[LANE_ID];
    assign dphy_port.rx_data_lp_hs_b[LANE_ID] =                 rx_data_lp_hs_b;
    assign dphy_port.rx_data_deskew_cntrl [LANE_ID*16 +: 16] =  rx_data_deskew_cntrl;



    logic initdone_stop_fr, initdone_stop_rx;
    assign initdone_stop_fr = is_stop & init_done;      
    altera_std_synchronizer_nocut  # ( .depth(2), .rst_value(0) ) cdc_sync_initstop_rx (
           .clk(rx_clk), .reset_n(srst_rx_n), .din(initdone_stop_fr), .dout(initdone_stop_rx) );

    logic  initstop_active_hs_n_rx, initstop_active_hs_n_fr;
    assign initstop_active_hs_n_rx = init_stop | ~active_hs;
    altera_std_synchronizer_nocut  # ( .depth(2), .rst_value(0) ) cdc_sync_initactive_fr (
           .clk(fr_clk), .reset_n(srst_fr_n), .din(initstop_active_hs_n_rx), .dout(initstop_active_hs_n_fr) );
           
    assign force_rx_mode = ppi_rx.ForceRxmode[LANE_ID];

    assign ppi_rx.RxSRst_n[LANE_ID] = srst_rx_n;
    assign ppi_rx.RxWordClkHS[LANE_ID] = rx_clk;
    assign ppi_rx.RxDataHS[LANE_ID] = IO_CONVERT_RATIO == 16 ? {16'h0 , dout} : {24'h0 , dout};
    assign ppi_rx.RxValidHS[LANE_ID] = IO_CONVERT_RATIO == 16 ? { 2'h0, { 2 { data_valid_hs } } } : { 3'h0, data_valid_hs } ;
    assign ppi_rx.RxActiveHS[LANE_ID] = active_hs;
    assign ppi_rx.RxSyncHS[LANE_ID] = sync_hs; 
    assign ppi_rx.RxClkActiveHS[LANE_ID] = ppi_rx.RxClkActiveHS[NUM_LANES] & enable;
    assign ppi_rx.RxUlpsClkNot[LANE_ID] = ppi_rx.RxUlpsClkNot[NUM_LANES] | ~enable;
    assign ppi_rx.RxSkewCalHS[LANE_ID] = skew_cal_hs;
    assign ppi_rx.RxAlternateCalHS[LANE_ID] = alt_cal_hs;
    assign ppi_rx.RxErrorCalHS[LANE_ID] = cal_err;
    assign ppi_rx.Direction[LANE_ID] = 1'b1;
    assign ppi_rx.Stopstate[LANE_ID] = is_stop & init_done & (init_stop | ~active_hs);
    assign ppi_rx.Stopstate_fr[LANE_ID] = is_stop & init_done & initstop_active_hs_n_fr;
    assign ppi_rx.ErrSotHS[LANE_ID] = sot_err_p;
    assign ppi_rx.ErrSotSyncHS[LANE_ID] = sot_sync_err_p;
    assign ppi_rx.ErrContentionLP0[LANE_ID] = 1'b0;
    assign ppi_rx.ErrContentionLP1[LANE_ID] = 1'b0;   

    assign cal_err_p = cal_err;     



    dphy_syncpat #(
        .DWIDTH(IO_CONVERT_RATIO),
        .PIPELINE_OUT_DEPTH(RX_PCS_DATA_HYPERPIPE_DEPTH),
        .SKEW_CAL_EN(SKEW_CAL_EN),
        .ALT_CAL_EN(ALT_CAL_EN)
    ) syncpat_data
   (
        .clk(rx_clk),       
        .srst_n(srst_rx_n),     
        .arst_n(arst_rx_n),     
        .sync_search_req(sync_search_req),  
        .alt_cal_valid(alt_cal_valid),
        .sync_search_found(sync_search_found), 
        .sot_err(sot_err),
        .din(rx_rd_data),   
        .din_valid(din_valid),
        .is_skew_cal(is_skew_cal),
        .is_alt_cal(is_alt_cal),
        .is_preamble(is_preamble),
        .is_alp_ctrl(is_alp_ctrl),       
        .is_hs_data(is_hs_data),
        .sot_err_p(sot_err_p),     
        .sot_sync_err_p(sot_sync_err_p), 
        .eot_err_p(eot_err_p), 
        .active_hs(active_hs),
        .sync_hs(sync_hs),
        .data_valid_hs(data_valid_hs),
        .skew_cal_hs(skew_cal_hs),       
        .alt_cal_hs(alt_cal_hs),         
        .dout(dout),
        .dout_valid(dout_valid)
    );

    if(SKEW_CAL_EN == 1)
    begin: cal_fsm

        dphy_pcs_cal_rx #(
            .WIDTH(IO_CONVERT_RATIO),
            .WIDTH_C2P(IO_CONVERT_RATIO_C2P),
            .LOOKAHEAD(1),
            .LANE_ID(LANE_ID),
            .RX_PCS_DATA_HYPERPIPE_DEPTH(RX_PCS_DATA_HYPERPIPE_DEPTH),
            .ALT_CAL_EN(ALT_CAL_EN)
            )
            pcs_cal_rx
        (
            .rx_clk(rx_clk),
            .arst_rx_n(arst_rx_n),
            .srst_rx_n(srst_rx_n),
            .fr_clk(fr_clk),
            .arst_fr_n(arst_fr_n),
            .srst_fr_n(srst_fr_n),
            .recalibrate(recal_p),
            .alt_cal_valid(alt_cal_valid),
            .is_skew_cal(is_skew_cal),
            .is_alt_cal(is_alt_cal),
            `ifdef VIP
            .prbs_init_val({8'h01, 1'b0}),   
            `else
            .prbs_init_val({cal_prbs_init, 1'b0}),   
            `endif        
            .data(dout),
            .data_valid(dout_valid),
            .data_deskew_cntrl(rx_data_deskew_cntrl),
            .cal_done(cal_done),
            .cal_err(cal_err),
            .cal_done_skew(cal_done_skew), 
            .cal_done_alt(cal_done_alt),
            .cal_err_skew(cal_err_skew),
            .cal_err_skew_per(cal_err_skew_per),
            .cal_err_alt(cal_err_alt),

            .in_cal(in_cal),
            .dqs_del_up_req(dqs_del_up_req),
            .dqs_del_up_ack(dqs_del_up_ack),
            .alt_skip_en(alt_skip_en),
            .delay_val_update_p((delay_val_update_p||init_done_pedge_pulse)),
            .manual_skew_en((manual_skew_en||init_done_delay_upd_en)),
            .manual_skew_val(manual_skew_val),
            .cal_w_start(cal_w_start),
            .cal_w_end(cal_w_end),
            .cal_w_start_alt(cal_w_start_alt),
            .cal_w_end_alt(cal_w_end_alt),
            .cal_delay_val(cal_delay_val)

        );
    end
    else
    begin: no_cal_fsm
        
   
        logic del_up_fr;
        logic del_up_fr_q;
        logic [15:0] data_deskew_cntrl_int;
        logic [CAL_IO_DESKEW_CTRL_REG_BITS-1:0] del_reg_fr;
        always @(posedge fr_clk or negedge arst_fr_n)
        begin
            if(arst_fr_n == 1'b0)
                del_reg_fr <= {CAL_IO_DESKEW_CTRL_REG_BITS{1'b0}};
            else if((delay_val_update_p||init_done_pedge_pulse) & (manual_skew_en||init_done_delay_upd_en))
                del_reg_fr <= manual_skew_val;
        end

        always @(posedge fr_clk)
        begin
            if(srst_fr_n == 1'b0)
            begin
                del_up_fr <= 1'b0;
                del_up_fr_q <= 1'b0;
            end
            else
            begin
                del_up_fr <= (manual_skew_en||init_done_delay_upd_en) & (delay_val_update_p||init_done_pedge_pulse) ;
                del_up_fr_q <= IO_CONVERT_RATIO_C2P == 8 ? del_up_fr : 1'b0;
            end
        end

        assign data_deskew_cntrl_int = { 1'b1 , 6'h0, del_reg_fr[6], 1'b0, del_reg_fr[5:3], 1'b0, del_reg_fr[2:0] };
    
        if(IO_CONVERT_RATIO_C2P==16)
            assign rx_data_deskew_cntrl = del_up_fr == 1'b1 ? data_deskew_cntrl_int : 16'h0;
        else
        begin
            assign rx_data_deskew_cntrl[15:12] = 4'h0;
            assign rx_data_deskew_cntrl[11:8] = 4'h0;
            assign rx_data_deskew_cntrl[7:4] = del_up_fr == 1'b1 ? data_deskew_cntrl_int[7:4] : del_up_fr_q == 1'b1 ? data_deskew_cntrl_int[15:12] : 4'h0;
            assign rx_data_deskew_cntrl[3:0] = del_up_fr == 1'b1 ? data_deskew_cntrl_int[3:0] : del_up_fr_q == 1'b1 ? data_deskew_cntrl_int[11:8] : 4'h0;
        end

        assign alt_cal_valid = 1'b0;
        assign cal_done = 1'b0;
        assign cal_err = 1'b0;
        assign in_cal = 1'b0;
        assign dqs_del_up_req = 1'b0;
        assign cal_w_start = 8'h0;
        assign cal_w_end = 8'h0;
        assign cal_w_start_alt = 8'h0;
        assign cal_w_end_alt = 8'h0;
        assign cal_delay_val  = 8'h0;
        assign cal_done_skew = 1'b0;
        assign cal_done_alt= 1'b0;
        assign cal_err_skew = 1'b0;
        assign cal_err_skew_per = 1'b0;
        assign cal_err_alt = 1'b0;
        
    end

   
   

   logic rx_data_lp_n_q1;   
   logic rx_data_lp_n_termen;

   if (RX_FR_CLK_FREQ >= 93750000)
     begin : termen_reg 
        always @(posedge fr_clk or negedge arst_fr_n)
          if (arst_fr_n == 1'b0)
            rx_data_lp_n_q1 <= 1'b1;
          else
            rx_data_lp_n_q1 <= rx_data_lp_n;
     end
   else
     begin : termen_stub
       assign rx_data_lp_n_q1 = 1'b0;        
     end   
   
   assign rx_data_lp_n_termen = ~(rx_data_lp_n_q1 | rx_data_lp_n);
   
    always @(*)
     begin
         rx_data_lp_hs_b <= ~( is_hs | (is_hs_req & rx_data_lp_n_termen));
     end
                
     dphy_pcs_data_timing_rx #( 
        .DIN_PIPE_DEPTH(IO_CONVERT_RATIO == 16 ? CAL_IO_RX_PIPE_DEPTH_16 : CAL_IO_RX_PIPE_DEPTH_8)
     ) timing_blk (
        .rx_clk(rx_clk),     
        .srst_rx_n(srst_rx_n),
        .arst_rx_n(arst_rx_n),   
        .fr_clk(fr_clk),
        .srst_fr_n(srst_fr_n),  
        .fr_clk_1024(fr_clk_1024),
        .enable(enable),
        .is_ulps(is_ulps),
        .ulps_wake_cnt(ulps_wake_cnt),
        .lpctrl_hs_req_fr (is_hs_req ),
        .lpctrl_hs_stop_fr(is_stop),
        .lpctrl_hs_diff_fr(is_hs),
        .lpctrl_lp_req_fr(is_lp_req),
        .fast_stop(rx_data_lp_11_deglitch),
        .t_hs_settle(t_hs_settle), 
        .t_hs_skip(t_hs_skip),                     
        .t_init(t_init),
        .t_wake_ulps(t_wake_ulps),
        .ulps_wake_done(ulps_wake_done),
        .init_done(init_done),
        .din_valid(din_valid)           
     );
    
     
     always @(posedge rx_clk)
     begin
         if (srst_rx_n == 1'b0)
         begin
             sync_search_req <= 1'b0;
             din_valid_q <= 1'b0;
         end
         else
         begin
             sync_search_req <= (din_valid & ~din_valid_q) | (sync_search_req & ~(sync_search_found & ~is_preamble) & ~sot_err);
             din_valid_q <= din_valid;
         end
     end


    dphy_pcs_esc_rx # (
        .LANE_ID(LANE_ID)
    ) esc_data_crtl
   (
        .fr_clk(fr_clk),     
        .srst_fr_n(srst_fr_n),    
        .init_done(init_done),
        .lp_p(d_lp_p_s_fr),
        .lp_n(d_lp_n_s_fr),
        .is_hs_req(is_hs_req),
        .is_hs(is_hs),
        .is_lp_req(is_lp_req),
        .is_lp(is_lp),
        .is_stop(is_stop),
        .is_ulps(is_ulps),
        .ulps_wake_cnt(ulps_wake_cnt),
        .ulps_wake_done(ulps_wake_done),
        .esc_entry_err_p(esc_entry_err_p),
        .lpdt_err_p(lpdt_err_p),
        .ctrl_err_p(ctrl_err_p),
        .ppi_rx(ppi_rx)
    );




// synthesis translate_off

// synthesis translate_on


endmodule 


`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oI8Bc7vsDyjjRVfd+vD+2UXZxpAcevgtyPUu/NrF/Vzk+GEPlBwwAnaEGJzigqOc919prLT81qR3FBMr2nhc3KNybOmynkAtzVe3sZrxLASBU2Mw2ZYOWu69aebNEMKY0JVslELCs2qoiCyZZibQP12H91J2Igi1hrCUo4yiMLLI4deg9jsYufop3PgcgwWjqITInbyhoPiA//IRms2H1GO1vPBj7Zwm/i+CJhEfPHlka0eI4h8WQWs5XCpOgnDRQfIOlkAp70Hyzyp72iZ9QiLLAChdO2l4OEz2JjM86KOfdICrjdAYGccivH6RdgsgJ6Pd6QtnFArqWdVVuLVAfs8ntFNeTZ1OQRJ3/78SN8/aOR8B5qxpqZ8ns3Wp6xBoV2XUardKaccy513iYTqQpyoqxveBFVI1Kru1RpDGljDPdxso9zuWVk8J7yauPLe00A+X5TRszHEMYmQyPM+0BvIT2LF5btDi9b480b+Sgltw6fa+g8ZzE56jLT7PgA6iaXwkZ8z3EjMZxpz18xt2A3Gk/kkk8IX1a+QfBvBxlWnVyFNWfbe3KLaArpYbWJrcgn8re2luChvMhDUz6WnSrKginmnHWiaoVKVXU5U2PwcGetCZMtr3mS7IWsmE0ycRQCTL2XZbBa389lWoaID8XeEnOUh+XXuK11hbNd7dQ99KwRmbQ5rNrQSiOaj7o4efpNUB1tnW0iuBDSwDJO/hc9NAIv7MXHbZEmboMhYxuPxtxL/zgomlwWGjSxC2v96Serv/npCFw9LfmmQOZIiyL2P"
`endif