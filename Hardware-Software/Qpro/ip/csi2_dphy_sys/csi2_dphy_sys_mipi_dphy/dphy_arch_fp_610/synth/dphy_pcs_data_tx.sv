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

module dphy_pcx_data_tx # (
        parameter IO_CONVERT_RATIO = 16,
        parameter NUM_LANES = 4,
        parameter SKEW_CAL_EN = 1,                                  
        parameter ALT_CAL_EN = 1,                                   
        parameter PREAMBLE_EN = 0,
        parameter TM_EN = 0,
        parameter TM_LOOPBACK_MODE = 0,
        parameter LANE_ID = 0,
        parameter VCO_FREQ_MULT = 1     
   ) (
        input  wire             fr_clk,          
        input  wire             fr_clk_1024,
        input  wire             core_clk,          
        input  wire             srst_fr_n,
        input  wire             srst_core_n,
        input  wire             srst_esc_n,
        input  wire             enable,
        input wire [7:0]        t_init,   
        input wire [7:0]        t_hs_prepare,
        input wire [7:0]        t_hs_zero,
        input wire [7:0]        t_hs_trail,
        input wire [7:0]        t_wake,
        input wire [7:0]        t_hs_exit,   
        input wire [7:0]        t_lp_exit,   
        input wire              reg_preamble_en,
        input wire [7:0]        reg_preamble_len,
        input wire [7:0]        cal_prbs_init,
        output logic            hs_done,
        output logic            init_done,
        input wire              clk_pre_done,
        input wire              esc_pulse,
        input wire              auto_skew_cal,
        input wire              auto_alt_cal,
        input wire              auto_cal_done,
        output logic            in_cal,
        input                   in_tm,
        input                   tm_loopback,
        input                   tm_cnt_rst_p,
        input [IO_CONVERT_RATIO-1:0] tm_loopback_in,
        input  [7:0]            tm_hs_deskew,
        output logic [31:0]     word_cnt,

        dphy_io_if              dphy_port,            
        dphy_dbg_dlane          dphy_dbg_dlane,
        ppi_if                  ppi_tx
    );
     
    logic tx_data_lp_p;
    logic tx_data_lp_n;
    logic tx_data_lp_hs_b;
    logic force_stop;
    logic hs_enter;
    logic in_stop;
    logic esc_enter;
    logic ulps_exit;
    logic is_ulps;
    logic in_skew_cal;    
    logic in_alt_cal;    
    logic in_sync;    
    logic in_sync2;    
    logic in_prepare;
    logic in_zero, in_zero_hs_data_gen;
    logic in_preamble, in_preamble_hs_data_gen;
    logic in_wake;
    logic in_active;
    logic in_trail, in_trail_hs_data_gen;
    logic in_hs_exit;
    logic in_lp_exit;
    logic prepare_done;
    logic zero_done;
    logic zero_done_q;
    logic preamble_done;
    logic trail_done;
    logic hs_exit_done;
    logic lp_exit_done;
    logic wake_done;
    logic esc_lp_p;
    logic esc_lp_n;
    logic hs_txfer_en;
    logic is_skew_cal;
    logic is_alt_cal;
    logic tx_word_clk;
    logic esc_clk;
    logic in_esc;
    logic esc_done;
    logic preamble_cnt_done;
    logic hs_ready;
    logic is_cal;
    logic [ (IO_CONVERT_RATIO == 16 ? 0 : 1 ) : 0] word_cntr;
    logic cnt_pulse;
    logic [7:0] preamble_len_cnt;
    logic preamble_exit;
    logic timer_out;
    logic data_next_en;


    typedef enum  {     INIT,
                        STOP,
                        HS_REQ,
                        BRIDGE,
                        ZERO,
                        PREAMBLE,
                        SYNC,
                        SYNC_2,
                        ALT_CAL,
                        SKEW_CAL,
                        ACTIVE,
                        TRAIL,
                        HS_EXIT,
                        ESC_ACTIVE,
                        LP_EXIT   
                   } tx_data_sm_t;
    tx_data_sm_t cstate, cstate_hs_data_gen; /* synthesis preserve_syn_only */
    tx_data_sm_t nstate;

    assign esc_clk = ppi_tx.TxClkEsc[LANE_ID];  

    assign dphy_port.tx_data_lp_hs_b[LANE_ID] = tx_data_lp_hs_b;
    assign dphy_port.tx_data_lp_p[LANE_ID] =    tx_data_lp_p;
    assign dphy_port.tx_data_lp_n[LANE_ID] =    tx_data_lp_n;

    assign tx_word_clk = ppi_tx.TxWordClkHS[LANE_ID];
    
    logic TxRequestEsc_sync;
    assign ppi_tx.Stopstate[LANE_ID] = in_stop;
    assign ppi_tx.Direction[LANE_ID] = 1'b0;
    assign ppi_tx.TxHSIdleClkReadyHS[LANE_ID] = 1'b0;
    assign force_stop = ppi_tx.ForceTxStopmode[LANE_ID];
    assign esc_enter = auto_cal_done & TxRequestEsc_sync & (cstate == STOP);
    assign hs_enter = clk_pre_done & ( (ppi_tx.TxRequestHS[LANE_ID] & auto_cal_done) | is_cal ); 
    assign hs_txfer_en = ppi_tx.TxDataTransferEnHS[LANE_ID];    
    assign is_skew_cal = auto_cal_done ? ppi_tx.TxSkewCalHS[LANE_ID] : auto_skew_cal;
    assign is_alt_cal = auto_cal_done ? ppi_tx.TxAlternateCalHS[LANE_ID] : auto_alt_cal;
    assign is_cal = is_skew_cal | is_alt_cal;

    assign hs_done = tx_data_lp_hs_b;
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) esc_req_sync (
                                .clk(fr_clk), .reset_n(srst_fr_n), .din(ppi_tx.TxRequestEsc[LANE_ID]), .dout(TxRequestEsc_sync) );
    

    always @(posedge fr_clk)
    begin
        if ( (srst_fr_n & enable & init_done) == 1'b0) begin	   
           cstate <= INIT;
	       cstate_hs_data_gen <= INIT;
           hs_ready <= 1'b0;           
	    end
        else if (force_stop) begin
           cstate <= STOP;
	       cstate_hs_data_gen <= STOP;
           hs_ready <= 1'b0;
	    end
        else begin
           cstate <= nstate;
	       cstate_hs_data_gen <= nstate;
           hs_ready <= (nstate == ACTIVE);           
	    end        
    end

    always @(*)
        case (cstate)
            INIT :          nstate = init_done ? STOP : cstate;
            STOP :          nstate = esc_pulse & esc_enter ? ESC_ACTIVE :
                                     esc_pulse & hs_enter  ? HS_REQ : cstate;
            HS_REQ :        nstate = esc_pulse ? BRIDGE : cstate;
            BRIDGE :        nstate = prepare_done ? ZERO : cstate;
            ZERO :          nstate = ( zero_done & reg_preamble_en & ~is_cal ) ? PREAMBLE :
                                     ( zero_done & ( hs_txfer_en | is_cal ) ) ? SYNC :
                                     ( zero_done & ~hs_enter ) ? HS_EXIT :
                                     cstate;
            PREAMBLE :      nstate = ( preamble_exit & hs_txfer_en ) ? SYNC : 
                                     ( preamble_exit & ~hs_enter ) ? HS_EXIT : cstate;
            SYNC :          nstate = data_next_en ? ( is_alt_cal ? ALT_CAL : IO_CONVERT_RATIO == 8 && ( reg_preamble_en | is_skew_cal ) 
                                     ? SYNC_2 : is_skew_cal ? SKEW_CAL : ACTIVE ) : cstate;
            SYNC_2 :        nstate = data_next_en ? ( is_skew_cal ? SKEW_CAL : ACTIVE ) : cstate;
            ALT_CAL :       nstate = ~is_alt_cal ? TRAIL : cstate;
            SKEW_CAL :      nstate = ~is_skew_cal ? TRAIL : cstate;
            ACTIVE :        nstate = ~hs_enter ? TRAIL : cstate;
            TRAIL :         nstate = trail_done ? HS_EXIT : cstate;
            HS_EXIT :       nstate = hs_exit_done ? STOP : cstate;
            ESC_ACTIVE :    nstate = esc_done ? LP_EXIT : cstate;
            LP_EXIT :       nstate = lp_exit_done ? STOP : cstate;
            default :       nstate = STOP;
        endcase

    assign tx_data_lp_hs_b = enable && (( cstate_hs_data_gen == ZERO       || 
                               cstate_hs_data_gen == ACTIVE     || 
                               cstate_hs_data_gen == TRAIL      || 
                               cstate_hs_data_gen == SYNC       || 
                               cstate_hs_data_gen == SYNC_2     || 
                               cstate_hs_data_gen == ALT_CAL    || 
                               cstate_hs_data_gen == SKEW_CAL   || 
                               cstate_hs_data_gen == PREAMBLE ) ? 1'b0 : 1'b1 );
    assign tx_data_lp_p =    enable && ( cstate == ESC_ACTIVE ? esc_lp_p :
                             ( cstate == HS_REQ     || 
                               cstate == BRIDGE     ||
                               cstate == ZERO       || 
                               cstate == ACTIVE     || 
                               cstate == TRAIL      || 
                               cstate == SYNC       || 
                               cstate == SYNC_2     || 
                               cstate == ALT_CAL    || 
                               cstate == SKEW_CAL   || 
                               cstate == PREAMBLE ) ? 1'b0 : 1'b1 );
    assign tx_data_lp_n =    enable && ( cstate == ESC_ACTIVE ? esc_lp_n :
                             ( cstate == BRIDGE     ||
                               cstate == ZERO       || 
                               cstate == ACTIVE     || 
                               cstate == TRAIL      || 
                               cstate == SYNC       || 
                               cstate == SYNC_2     || 
                               cstate == ALT_CAL    || 
                               cstate == SKEW_CAL   || 
                               cstate == PREAMBLE ) ? 1'b0 : 1'b1 );


    assign in_stop = cstate == STOP ? 1'b1 : 1'b0;
    assign in_sync = cstate_hs_data_gen == SYNC ? 1'b1 : 1'b0;
    assign in_sync2 = cstate_hs_data_gen == SYNC_2 ? 1'b1 : 1'b0;
    assign in_prepare = cstate == BRIDGE ? 1'b1 : 1'b0;
    assign in_zero = cstate == ZERO ? 1'b1 : 1'b0;
    assign in_zero_hs_data_gen = cstate_hs_data_gen == ZERO ? 1'b1 : 1'b0;
    assign in_active = cstate_hs_data_gen == ACTIVE ? 1'b1 : 1'b0;
    assign in_trail = cstate== TRAIL ? 1'b1 : 1'b0;
    assign in_trail_hs_data_gen = cstate_hs_data_gen == TRAIL ? 1'b1 : 1'b0;
    assign in_hs_exit = cstate == HS_EXIT ? 1'b1 : 1'b0;
    assign in_lp_exit = cstate == LP_EXIT ? 1'b1 : 1'b0;
    assign in_preamble = cstate == PREAMBLE ? 1'b1 : 1'b0;
    assign in_preamble_hs_data_gen = cstate_hs_data_gen == PREAMBLE ? 1'b1 : 1'b0;
    assign in_skew_cal = cstate_hs_data_gen == SKEW_CAL ? 1'b1 : 1'b0;
    assign in_alt_cal = cstate_hs_data_gen == ALT_CAL ? 1'b1 : 1'b0;
    assign in_esc = cstate == ESC_ACTIVE ? 1'b1 : 1'b0;
    assign in_cal = in_skew_cal | in_alt_cal;
    assign prepare_done = in_prepare & timer_out;
    assign trail_done = in_trail & timer_out;
    assign hs_exit_done = in_hs_exit & timer_out;
    assign lp_exit_done = in_lp_exit & timer_out;
    
    always @(posedge fr_clk)
        zero_done_q <= zero_done;
    assign zero_done = in_zero & ( timer_out | zero_done_q );

    always @(posedge core_clk)
    begin
        if(in_preamble)
            word_cntr <= word_cntr + data_next_en ;
        else
            word_cntr <= 'h0;
    end
    assign cnt_pulse = &word_cntr;

    always @(posedge core_clk)
        if(in_preamble)
            preamble_len_cnt <= preamble_len_cnt - (|preamble_len_cnt & cnt_pulse);
        else    
            preamble_len_cnt <= reg_preamble_len;
    assign preamble_cnt_done = ~|preamble_len_cnt & cnt_pulse ;

    always @(posedge core_clk)
        preamble_done <= in_preamble & ( preamble_cnt_done | preamble_done );
    
    assign preamble_exit = preamble_cnt_done;
    
    always @(posedge core_clk)
    begin
        wake_done <= in_wake & (timer_out | wake_done);
    end

    
    dphy_pcx_esc_tx # (
        .LANE_ID(LANE_ID)
    ) esc_lp_sm
   (
        .fr_clk(fr_clk), 
        .srst_fr_n(srst_fr_n),    
        .esc_pulse(esc_pulse),
        .srst_esc_n(srst_esc_n),
        .wake_done(wake_done),
        .in_wake(in_wake),
        .esc_enter(in_esc),
        .esc_done(esc_done),
        .lp_p(esc_lp_p),
        .lp_n(esc_lp_n),
        .ppi_tx(ppi_tx)
    );
    

     dphy_pcs_timing_tx timing_blk 
     (
        .fr_clk(fr_clk),
        .fr_clk_1024(fr_clk_1024),  
        .srst_fr_n(srst_fr_n),
        .enable(enable),
        .in_prepare(in_prepare),            
        .in_zero(in_zero),  
        .in_pre(1'b0),
        .in_trail(in_trail),
        .in_post(1'b0),
        .in_wake(in_wake),
        .in_hs_exit(in_hs_exit),
        .in_lp_exit(in_lp_exit),
        .t_init(t_init),   
        .t_prepare(t_hs_prepare),
        .t_pre(8'h0),
        .t_zero(t_hs_zero),
        .t_trail(t_hs_trail),
        .t_post(8'h0),
        .t_wake(t_wake),
        .t_hs_exit(t_hs_exit),   
        .t_lp_exit(t_lp_exit),   
        .init_done(init_done),
        .timer_out(timer_out)
     );
     


    dphy_pcx_data_mux_tx # (
        .IO_CONVERT_RATIO(IO_CONVERT_RATIO),     
        .SKEW_CAL_EN(SKEW_CAL_EN),               
        .ALT_CAL_EN(ALT_CAL_EN),                 
        .PREAMBLE_EN(PREAMBLE_EN),               
        .TM_EN(TM_EN),                           
        .TM_LOOPBACK_MODE(TM_LOOPBACK_MODE),     
        .LANE_ID(LANE_ID),
        .VCO_FREQ_MULT(VCO_FREQ_MULT)    
        ) hs_data_gen (

        .core_clk(core_clk),
        .srst_core_n(srst_core_n),
        .in_hs(~tx_data_lp_hs_b),
        .in_zero(in_zero_hs_data_gen),  
        .in_preamble(in_preamble_hs_data_gen),            
        .in_sync(in_sync),
        .in_sync2(in_sync2),
        .in_alt_cal(in_alt_cal),
        .in_skew_cal(in_skew_cal),
        .in_active(in_active),
        .in_trail(in_trail_hs_data_gen),
        .hs_ready(hs_ready),
        .in_tm(in_tm),
        .in_tm_loopback(tm_loopback),
        .cal_prbs_init(cal_prbs_init),
        .reg_preamble_en(reg_preamble_en),
        .loopback_in(tm_loopback_in),
        .word_cnt_rst(tm_cnt_rst_p),
        .word_cnt(word_cnt),
        .data_next_en(data_next_en),
        .auto_cal_done(auto_cal_done),
        .auto_skew_cal(auto_skew_cal),
        .auto_alt_cal(auto_alt_cal),
        .dphy_port(dphy_port),
        .ppi_tx(ppi_tx)
    );    
    

endmodule 

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oKpoPeiQ7xVXpAP7jEa5EuGWn2kh1OKMVFCDvJZsJgdcUwg41qUJeA2vULBOcpPQyymyRj9PzBRry0SaHyQOryBrBMalCKnGMjv8OCWVkmNMGicY6d9c0Wh9vqvuT1vmxO/8dQW1lM/L85UfijE5+qsMFb5bZGzSLMzSSf5CCL0h6MXAyrc119Ut4XWeiQzEpyITAeqU9uT0QlgW2v4gbeBLJw0Xp8DjEUo9+5gRWYjyVKuPwFXIuG2R810FWskHG7EswJVuo7wp1cJbwMZAOoQrSaqjP+l76AVeBFdj8d/5oy59joHnn67TbJHHuqkuq6olKosy6GdC3qMErKQwR6I600qk+zgUFJQbpkti9s6AY2T1hJrlw94BhfJkP/0m3OXigq3lsi4YJmX5q67FW7g0s8WnMIwzUQzecMpNnfEVnOfBFWDRsLC7L6xFPI7OeZnT44FMDwLOYESAGXjGkI7RLAAbyoJVtOW1KnachouDGrJTI0ZOHsXNMRRhJLAbTGbt6OkVja8xffbcoTs9zMuXLvvKFbOvyuxrbuM2iY0PCC3J4Ihu9YpG+GrmoA/mpupH1e69xIo3Kud+nwvKBJ1P6SRFJbzJ59O9muCSCSajPpwSpb69jjYbrOPJEaiyloiq45PnKoaTvEMwpn3/KF+MSZzKFkuDSQOPdAETJ4AUDJsOcrr6Fiqv8YsUjjmrgNpm+ups3YU3q36siFmi2menzaMzj2fpShji1DHbl44+GyxJl8zhVGp+3tY0JTqZDtE1l9YAsdAflEvz3PDkbny"
`endif