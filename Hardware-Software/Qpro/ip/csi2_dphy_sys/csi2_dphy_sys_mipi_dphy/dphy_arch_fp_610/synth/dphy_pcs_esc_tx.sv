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


module dphy_pcx_esc_tx # (
        parameter LANE_ID = 0
    )
   (
        input  wire             fr_clk,          
        input  wire             srst_fr_n,    
        input  wire             esc_pulse,
        input  wire             srst_esc_n,
        input  wire             wake_done,
        output logic            in_wake,
        input  wire             esc_enter,
        output logic            esc_done,
        output logic            lp_p,
        output logic            lp_n,
        ppi_if                  ppi_tx
    );

    localparam USE_SPACE_ON_TRIG_EXT = 0;  
   
    typedef enum {
                    ESC_IDLE,
                    ESC_REQ,
                    ESC_REQ0,
                    ESC_REQ1,
                    ESC_CMD,
		    ESC_TRIG_EXT,
                    ESC_DATA,
                    ULPS,
                    ULPS_EXIT,
                    ESC_PAUSE,
                    ESC_EXIT
                 } tx_esc_sm_t;
                 
    tx_esc_sm_t cstate;
    tx_esc_sm_t nstate;

    logic e_is_ulps;
    logic [3:0] e_is_trigger;
    logic e_is_lpdt;
    logic e_d_valid;
    logic [7:0] e_esc_data;
    
    logic is_ulps;
    logic [3:0] is_trigger;
    logic is_lpdt;
    logic [7:0] esc_cmd_byte;
    logic esc_req_q;
    logic esc_req_capture;
    logic esc_req_pending;
    logic [3:0] bit_cnt;
    logic bit_cnt_inc;
    logic esc_data;
    logic is_even;
    logic d_valid;
    logic esc_ready;
    logic ulps_exit;
    logic exit_byte;
    logic esc_clk;
    logic e_esc_active;
    logic esc_active;
    logic [7:0] lp_srout;
    logic [7:0] e_lp_srout;
    logic ld_srout;
    logic esc_done_ext;
    
    logic esc_enter_sync;
    logic esc_enter_sync_valid;
    logic esc_done_esc;
    logic wake_done_sync;
    logic in_wake_esc;

           
    assign esc_clk = ppi_tx.TxClkEsc[LANE_ID];  
    assign esc_req_ppi = ppi_tx.TxRequestEsc[LANE_ID];
    
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) esc_enter_cdc (
                            .clk(esc_clk), .reset_n(srst_esc_n), .din(esc_enter), .dout(esc_enter_sync) );
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) esc_done_cdc (
                            .clk(fr_clk), .reset_n(srst_fr_n), .din(esc_done_esc), .dout(esc_done) );
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) wake_done_cdc (
                            .clk(esc_clk), .reset_n(srst_esc_n), .din(wake_done), .dout(wake_done_sync) );
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) in_wake_cdc (
                            .clk(fr_clk), .reset_n(srst_fr_n), .din(in_wake_esc), .dout(in_wake) );

    assign esc_enter_sync_valid = esc_enter_sync & (esc_req_pending | esc_req_ppi);
    
    
    always @(*)
    begin
        e_esc_active <= esc_enter_sync_valid;
        e_is_ulps <= ppi_tx.TxUlpsEsc[LANE_ID] | (ppi_tx.TxRequestTypeEsc[LANE_ID] == 4'h1);
        e_is_trigger <= ppi_tx.TxTriggerEsc[LANE_ID] | 
                        { ppi_tx.TxRequestTypeEsc[LANE_ID] == 4'h7, 
                          ppi_tx.TxRequestTypeEsc[LANE_ID] == 4'h6, 
                          ppi_tx.TxRequestTypeEsc[LANE_ID] == 4'h5, 
                          ppi_tx.TxRequestTypeEsc[LANE_ID] == 4'h4 } ;
        e_is_lpdt <= ppi_tx.TxLpdtEsc[LANE_ID]; 
    end

    always @(posedge esc_clk)
        if (srst_esc_n == 1'b0)
            cstate <= ESC_IDLE;
        else
            cstate <= nstate;

    always @(posedge esc_clk)
        if (srst_esc_n == 1'b0)
        begin
            esc_req_q <=  1'b0;
            esc_req_pending <= 1'b0;
        end
        else
        begin
            esc_req_q <=  esc_req_ppi;
            esc_req_pending <= esc_req_capture | (esc_req_pending & ~ld_srout);
        end

    assign esc_req_capture = esc_req_ppi & ~esc_req_q;
    
    always @(posedge esc_clk)
    begin
        if(esc_req_capture)
        begin
            is_ulps    <= e_is_ulps;
            is_trigger <= LANE_ID == 0 ? e_is_trigger : 'h0;
            is_lpdt    <= LANE_ID == 0 ? e_is_lpdt : 1'b0;
        end
    end
    
    assign d_valid = ppi_tx.TxValidEsc[LANE_ID] & esc_ready;
    assign ppi_tx.TxReadyEsc[LANE_ID] = esc_ready;
    
    assign esc_cmd_byte =   ( { 8 { is_ulps } } & ESC_ULPS_CMD ) | 
                            ( { 8 { is_trigger[0] } } & ESC_RESET_CMD ) |
                            ( { 8 { is_trigger[1] } } & ESC_HS_TST_CMD ) |
                            ( { 8 { is_trigger[2] } } & ESC_UNKNOW4_CMD ) |
                            ( { 8 { is_trigger[3] } } & ESC_UNKNOW5_CMD ) |
                            ( { 8 { is_lpdt } } & ESC_LPDT_CMD ) ;

    always @(posedge esc_clk)
        if (cstate == ESC_CMD || cstate == ESC_DATA || nstate == ESC_TRIG_EXT)
            bit_cnt    <= bit_cnt + bit_cnt_inc;
        else
            bit_cnt <= 'h0;
    
   assign bit_cnt_inc = 1'b1;

    assign exit_byte = &bit_cnt;
    always @(posedge esc_clk)
        esc_done_esc <= cstate == ESC_EXIT;
    

    always @(*)
        case(cstate)
            ESC_IDLE:   
                begin
                    lp_p <= 1'b1;
                    lp_n <= 1'b1;
                end
            ESC_REQ, ULPS_EXIT, ESC_EXIT: 
                begin
                    lp_p <= 1'b1;
                    lp_n <= 1'b0;
                end
            ESC_REQ0, ESC_PAUSE, ULPS: 
                begin
                    lp_p <= 1'b0;
                    lp_n <= 1'b0;
                end
            ESC_REQ1: 
                begin
                    lp_p <= 1'b0;
                    lp_n <= 1'b1;
                end
            ESC_CMD, ESC_DATA: 
                begin
                    lp_p <= bit_cnt[0] & lp_srout[0];
                    lp_n <= bit_cnt[0] & ~lp_srout[0]; 
                end
	    ESC_TRIG_EXT:
	         begin
                    lp_p <= bit_cnt[0] & (USE_SPACE_ON_TRIG_EXT ? 1'b0 : 1'b1);
		    lp_n <= 1'b0;		    
		 end
        endcase

    always @(*)
        case(cstate)
            ESC_IDLE    : nstate <= esc_enter_sync_valid ? ESC_REQ : cstate;
            ESC_REQ     : nstate <= ESC_REQ0;
            ESC_REQ0    : nstate <= ESC_REQ1;
            ESC_REQ1    : nstate <= ESC_CMD;
            ESC_CMD     : nstate <= (exit_byte & is_ulps)  ? ULPS : 
                                     exit_byte ? ESC_PAUSE : cstate;
            ESC_DATA    : nstate <=  exit_byte ? ESC_PAUSE : cstate;
            ULPS        : nstate <= ppi_tx.TxUlpsExit[LANE_ID] ? ULPS_EXIT : cstate;
            ULPS_EXIT   : nstate <= (~esc_req_ppi & wake_done_sync) ? ESC_EXIT : cstate;
            ESC_PAUSE   : nstate <=    d_valid ? ESC_DATA : 
                                    ~esc_req_ppi ? ESC_EXIT :
				    (|is_trigger)? ESC_TRIG_EXT : cstate;
            ESC_TRIG_EXT: nstate <= exit_byte ? ESC_PAUSE : cstate;	  
            ESC_EXIT    : nstate <= ESC_IDLE;
            default     : nstate <= ESC_EXIT;
        endcase

    assign in_wake_esc = (cstate == ULPS_EXIT);
    assign ld_srout = ( cstate == ESC_REQ1 ) | d_valid;
    assign e_esc_data = ( nstate == ESC_CMD ) ? esc_cmd_byte : ppi_tx.TxDataEsc[LANE_ID];
    assign e_lp_srout = ( (cstate == ESC_DATA || cstate == ESC_CMD ) && bit_cnt[0] == 1'b1) ? {1'b0, lp_srout[7:1]} : lp_srout;
    assign esc_ready = (cstate == ESC_PAUSE) & is_lpdt & ~|bit_cnt;
    assign ppi_tx.UlpsActiveNot[LANE_ID] = cstate == ULPS ? 1'b0 : 1'b1;

    always @(posedge esc_clk)
    begin
        lp_srout <= ld_srout ? e_esc_data : e_lp_srout;
    end


endmodule 


`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJIquzz423kjzzvb4/8uQsCqJXA4fr4PXJKppeP8lVH3kksVQhoX6UUyLM+Zxw3UQ9k/tW4pEQJDnblFht03wgGmudAFcuannj28qLaoSSz3Tna6L5+4Nping/GhkdR3ATpocvf63/g6rr8JxW++/PUVxt1/N3jGsW/lRdlPbuXlRICso4hqlaMStJm8NKM3NTvkxCvreGyu6T1eQnjx0TXf6jb8IRf7D3KMRuvfrqkBBDRvE3XLRqv2EHQOon5pbVxbvdK9Lh+QtjNoqCWPuKRc4FNwwWTO7d0R8pTn8zg6t3f9MudGUH09g//dL5HRGIbov9e4S2L15wlqTsZfdhA9l8q6rH5lnPn2MHx13rpEvcvvhygAYulEqkWuCE5ajsyZ6iPPFSWXtg6SJVJmpKSEQGkWMKvBFWViy9vUhfpzkH4mKYP99hoMwa0hLgxpG5ceFgVwZcSF2QABiK5uWpJ83hsD5+4q88yXtDVqpM0aJA76gODubZpnnNIW5wfRyUpUPhOZx3o0tc5LYcjzE3fGeWzKEqW/RtI1xqJYS6zu+oohcXNbPI+MP6iIv2EU7T5KIkWb5dACZmObfW7Qt9Gq5G4XWLka484Ea4+YbeP1mBZk9wEFxD5ApvRO9q3pP4BKw0R/sUsoCRCST81xMM7kje0iBlsUEQQgBHdDUI+hmgkg7uqB8KX5Dk2/e/f8q+wSoQDieAAvrLCDVNdwY+cN60VWAqS6YeU2qAc9L9g7/+GBr2/NFlZHhEJrIa6wU59kKlZP2FiFdJjxFqjFfgm"
`endif