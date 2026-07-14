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


module dphy_syncpat #(
        parameter DWIDTH = 16,
        parameter PIPELINE_OUT_DEPTH = 3,        
        parameter SKEW_CAL_EN = 0,
        parameter ALT_CAL_EN = 0
    )
   (
        input  wire                     clk,       
        input  wire                     srst_n,     
        input  wire                     arst_n,     
        
        input                           sync_search_req,   
        input                           alt_cal_valid,
        output logic                    sync_search_found, 
        output logic                    sot_err,
        input [DWIDTH-1:0]              din, 
        input                           din_valid,
        output logic                    is_skew_cal,
        output logic                    is_alt_cal,
        output logic                    is_preamble,
        output logic                    is_alp_ctrl,       
        output logic                    is_hs_data,
        output logic                    sot_err_p,
        output logic                    sot_sync_err_p,
        output logic                    eot_err_p,
        output logic                    active_hs,
        output logic                    sync_hs,
        output logic                    data_valid_hs,
        output logic                    skew_cal_hs,       
        output logic                    alt_cal_hs,         
        output logic [DWIDTH-1:0]       dout,
        output logic                    dout_valid
    );
    
    localparam BUFFER_DEPTH = 3;
    localparam WINDOW_SHIFT_LEN = DWIDTH;
    localparam MUX_SELECT_WIDTH = DWIDTH == 16 ? 4 : 3;
    localparam WINDOW_SHIFT_START_8 = DWIDTH == 16 ? 16 : 0;
    localparam WINDOW_SHIFT_END_8 = WINDOW_SHIFT_START_8 + DWIDTH;
    localparam WINDOW_DATA_OFFSET_8 = DWIDTH == 16 ? 8 : 0;
    localparam WINDOW_SHIFT_START_16 = 0;
    localparam WINDOW_DATA_OFFSET_16 = DWIDTH == 16 ? 0 : 8;
    localparam WINDOW_SHIFT_END_16 = WINDOW_SHIFT_START_16 + DWIDTH;



    logic [DWIDTH-1:0] ored_sel_lines;
    logic [DWIDTH-1:0] ored_sel_lines_swap;
    logic [DWIDTH-1:0] ored_sel_lines_noswap;
    logic [DWIDTH-1:0] active_sel_lines;
    logic is_sync_16;
    logic sync_search_found_int;
    logic sync_search_found_int_q;
    logic [DWIDTH-1:0] alt_cal_sel_lines;
    logic [DWIDTH-1:0] hs_data_sel_lines;
    logic [DWIDTH-1:0] alt_cal_sel_lines_swap;
    logic [DWIDTH-1:0] hs_data_sel_lines_swap;
    logic [DWIDTH-1:0] alt_cal_sel_lines_noswap;
    logic [DWIDTH-1:0] hs_data_sel_lines_noswap;
    logic [DWIDTH-1:0] skew_cal_sel_lines;
    logic [DWIDTH-1:0] hs_data_pre_sel_lines;
    logic [DWIDTH-1:0] preamble_sel_lines;
    logic [DWIDTH-1:0] skew_cal_sel_lines_swap;
    logic [DWIDTH-1:0] hs_data_pre_sel_lines_swap;
    logic [DWIDTH-1:0] preamble_sel_lines_swap;
    logic [DWIDTH-1:0] skew_cal_sel_lines_noswap;
    logic [DWIDTH-1:0] hs_data_pre_sel_lines_noswap;
    logic [DWIDTH-1:0] preamble_sel_lines_noswap;
    logic [7:0]  data_window_8 [0:DWIDTH-1];
    logic [15:0] data_window_16 [0:DWIDTH-1];
    logic [7:0]  data_window_8_swap [0:DWIDTH-1];
    logic [15:0] data_window_16_swap [0:DWIDTH-1];
    logic [DWIDTH-1:0] data_window_off8 [0:DWIDTH-1];
    logic [DWIDTH-1:0] data_window_off0 [0:DWIDTH-1];
    logic [DWIDTH-1:0] data_window_off8_swap [0:DWIDTH-1];
    logic [DWIDTH-1:0] data_window_off0_swap [0:DWIDTH-1];

    logic datarst_n [BUFFER_DEPTH-1:0]; /* synthesis preserve_syn_only */
    logic [DWIDTH-1:0] local_data_pipe [BUFFER_DEPTH-1:0];
    logic [BUFFER_DEPTH-1:0] din_valid_q;
    logic [BUFFER_DEPTH*DWIDTH-1:0] local_data_pipe_flat;
    logic [BUFFER_DEPTH*DWIDTH-1:0] local_data_pipe_flat_swap;
    logic [DWIDTH-1:0] data_window_valid ;
    logic e_sync_search_found;
    logic skew_cal_prio;
    localparam LEADER_SEQ_LIMIT = 4;
    logic [2:0] lead_seq_limit;
    localparam LEADER_SEQ_LIMIT_8 = LEADER_SEQ_LIMIT - 1;
    logic lead_seq_limit_ovf; 
   
    
    logic [MUX_SELECT_WIDTH-1:0] data_sel;
    logic [MUX_SELECT_WIDTH-1:0] data_sel_noswap;
    logic [MUX_SELECT_WIDTH-1:0] data_sel_q;
    logic swap_select_q;
    logic [DWIDTH-1:0]       dout_int;
    logic                    dout_valid_int;
    logic                    data_valid_hs_int;
    logic                    is_skew_cal_int;
    logic                    is_alt_cal_int;
    logic                    is_preamble_int;
    logic                    is_alp_ctrl_int;       
    logic                    is_hs_data_int;
    logic                    active_hs_int;
    logic                    sync_hs_int;
    logic                    skew_cal_hs_int;       
    logic                    alt_cal_hs_int;         

    logic                    ext_hs_search;
    typedef enum { IDLE, SEARCH_LEAD, PREAMBLE, PREAMBLE_EXIT, SKEW_CAL, ALT_CAL, HS_DATA, SOT_ERR} spat_states_t;
    spat_states_t c_spat_sm;
    spat_states_t n_spat_sm;

    
    int i;
    int j;
    genvar k;
    logic alt_cal_en_q;
    logic alt_cal_en_qual;
    
    for(k=0; k<BUFFER_DEPTH; k++)
    begin : local_data_pipes
	always @(posedge clk)
	  begin
	     datarst_n[k] <= srst_n;	     
	  end
        always @(posedge clk)
        begin
            if(datarst_n[k] == 1'b0)
                local_data_pipe[k] <= 'h0;
            else
                local_data_pipe[k] <= ( ( k == BUFFER_DEPTH -1 ) ? ((c_spat_sm == IDLE) ? 'h0 : din) : local_data_pipe[k+1] );
        end
        assign local_data_pipe_flat[k*DWIDTH+:DWIDTH] = local_data_pipe[k];        
    end

    always @(*)
    begin : odd_even_bit_swap
        int j;
        for(j=0; j<BUFFER_DEPTH*DWIDTH-1; j= j+2)
        begin
            local_data_pipe_flat_swap[j]    <= local_data_pipe_flat[j+1];
            local_data_pipe_flat_swap[j+1]  <= local_data_pipe_flat[j];
        end
    end
    
    always @(posedge clk)
    begin
        if(srst_n == 1'b0)
            din_valid_q <= 'h0;
        else
        begin
            din_valid_q[BUFFER_DEPTH-1:1] <= din_valid_q[BUFFER_DEPTH-2:0];
            din_valid_q[0] <= din_valid;
        end
    end

    always @(*)
    begin : data_window_noswap
        int j;
        for(j=0; j<DWIDTH; j++) 
        begin
            data_window_8[j]    <= local_data_pipe_flat[WINDOW_SHIFT_START_8+j+:8];
            data_window_16[j]   <= local_data_pipe_flat[WINDOW_SHIFT_START_16+j+:16];
            data_window_off8[j] <= local_data_pipe_flat[8+j+:DWIDTH];
            data_window_off0[j] <= local_data_pipe_flat[j+:DWIDTH];
        end
    end
    
    always @(*)
    begin : dsel_noswap
        int j;
        for(j=0; j<DWIDTH; j++) 
        begin
            alt_cal_sel_lines_noswap[j] <= ((data_window_8[j] == SYNC_ALT_CAL) && (ALT_CAL_EN == 1)) ? alt_cal_en_qual : 'h0;
            hs_data_sel_lines_noswap[j] <= (data_window_8[j] == SYNC_HS_DATA) ? 'h1 : 'h0;
            preamble_sel_lines_noswap[j] <= (data_window_16[j] == SYNC_PREAMBLE) ? 'h1 : 'h0;
            skew_cal_sel_lines_noswap[j]  <= (((data_window_16[j] & SYNC_SKEW_CAL_RX) == SYNC_SKEW_CAL_RX) && (SKEW_CAL_EN == 1)) ? 'h1 : 'h0;
            hs_data_pre_sel_lines_noswap[j] <= (data_window_16[j] == SYNC_HS_DATA_PRE) ? 'h1 : 'h0;
        end 
    end        
    
    always @(*)
    begin : data_window_swap
        int j;
        for(j=0; j<DWIDTH; j++) 
        begin
            data_window_8_swap[j]       <= local_data_pipe_flat_swap[WINDOW_SHIFT_START_8+j+:8];
            data_window_16_swap[j]      <= local_data_pipe_flat_swap[WINDOW_SHIFT_START_16+j+:16];
            data_window_off8_swap[j]    <= local_data_pipe_flat_swap[8+j+:DWIDTH];
            data_window_off0_swap[j]    <= local_data_pipe_flat_swap[j+:DWIDTH];
        end
    end


   
if(SYNC_SWAP_EN==1)
begin : swap_match
    always @(*)
    begin : dsel_swap
        int j;
        for(j=0; j<DWIDTH; j++) 
        begin
            alt_cal_sel_lines_swap[j]   <= ((data_window_8_swap[j] == SYNC_ALT_CAL) && (ALT_CAL_EN == 1)) ? alt_cal_en_qual : 'h0;
            hs_data_sel_lines_swap[j]   <= (data_window_8_swap[j] == SYNC_HS_DATA) ? 'h1 : 'h0;
            preamble_sel_lines_swap[j]  <= 'h0;
            skew_cal_sel_lines_swap[j]      <= (((data_window_16_swap[j] & SYNC_SKEW_CAL_RX) == SYNC_SKEW_CAL_RX) && (SKEW_CAL_EN == 1)) ? 'h1 : 'h0;
            hs_data_pre_sel_lines_swap[j]   <= (data_window_16_swap[j] == SYNC_HS_DATA_PRE) ? 'h1 : 'h0;
        end
    end
end
else
begin : no_swap_match
    always @(*)
    begin : data_sel_swap
        int j;
        for(j=0; j<DWIDTH; j++) 
        begin
            alt_cal_sel_lines_swap[j]   <= 'h0;
            hs_data_sel_lines_swap[j]   <= 'h0;
            preamble_sel_lines_swap[j]  <= 'h0;
            skew_cal_sel_lines_swap[j]      <= (data_window_16_swap[j] == SYNC_SKEW_CAL_RX) ? 'h1 : 'h0;
            hs_data_pre_sel_lines_swap[j]   <= 'h0;
        end
    end
end
    assign alt_cal_sel_lines = alt_cal_sel_lines_noswap | alt_cal_sel_lines_swap;
    assign hs_data_sel_lines = hs_data_sel_lines_noswap | hs_data_sel_lines_swap;
    assign preamble_sel_lines = preamble_sel_lines_noswap | preamble_sel_lines_swap;
    assign skew_cal_sel_lines = skew_cal_sel_lines_noswap | skew_cal_sel_lines_swap;
    assign hs_data_pre_sel_lines = hs_data_pre_sel_lines_noswap | hs_data_pre_sel_lines_swap;
    
    assign ored_sel_lines_swap = ext_hs_search == 1'b1 ? (hs_data_pre_sel_lines_swap) : (alt_cal_sel_lines_swap | hs_data_sel_lines_swap | preamble_sel_lines_swap);
    assign ored_sel_lines_noswap = ext_hs_search == 1'b1 ? (hs_data_pre_sel_lines_noswap) : (alt_cal_sel_lines_noswap | hs_data_sel_lines_noswap | preamble_sel_lines_noswap);
    assign skew_cal_prio = |skew_cal_sel_lines;
    assign ored_sel_lines = ((skew_cal_prio == 'b1) && (ext_hs_search == 1'b0)) ? skew_cal_sel_lines : (ored_sel_lines_noswap | ored_sel_lines_swap);



    always @(*)
    begin : data_sel_prio_encoder
        casez(ored_sel_lines)
            16'b????_????_????_???1 : data_sel <= 4'h0;
            16'b????_????_????_??10 : data_sel <= 4'h1;
            16'b????_????_????_?100 : data_sel <= 4'h2;
            16'b????_????_????_1000 : data_sel <= 4'h3;
            16'b????_????_???1_0000 : data_sel <= 4'h4;
            16'b????_????_??10_0000 : data_sel <= 4'h5;
            16'b????_????_?100_0000 : data_sel <= 4'h6;
            16'b????_????_1000_0000 : data_sel <= 4'h7;
            16'b????_???1_0000_0000 : data_sel <= 4'h8;
            16'b????_??10_0000_0000 : data_sel <= 4'h9;
            16'b????_?100_0000_0000 : data_sel <= 4'ha;
            16'b????_1000_0000_0000 : data_sel <= 4'hb;
            16'b???1_0000_0000_0000 : data_sel <= 4'hc;
            16'b??10_0000_0000_0000 : data_sel <= 4'hd;
            16'b?100_0000_0000_0000 : data_sel <= 4'he;
            16'b1000_0000_0000_0000 : data_sel <= 4'hf;
            default                 : data_sel <= 4'h0;
        endcase
    end

    always @(*)
    begin : data_sel_prio_encoder_active
        casez(ored_sel_lines)
            16'b????_????_????_???1 : active_sel_lines <= 16'h0001;
            16'b????_????_????_??10 : active_sel_lines <= 16'h0002;
            16'b????_????_????_?100 : active_sel_lines <= 16'h0004;
            16'b????_????_????_1000 : active_sel_lines <= 16'h0008;
            16'b????_????_???1_0000 : active_sel_lines <= 16'h0010;
            16'b????_????_??10_0000 : active_sel_lines <= 16'h0020;
            16'b????_????_?100_0000 : active_sel_lines <= 16'h0040;
            16'b????_????_1000_0000 : active_sel_lines <= 16'h0080;
            16'b????_???1_0000_0000 : active_sel_lines <= 16'h0100;
            16'b????_??10_0000_0000 : active_sel_lines <= 16'h0200;
            16'b????_?100_0000_0000 : active_sel_lines <= 16'h0400;
            16'b????_1000_0000_0000 : active_sel_lines <= 16'h0800;
            16'b???1_0000_0000_0000 : active_sel_lines <= 16'h1000;
            16'b??10_0000_0000_0000 : active_sel_lines <= 16'h2000;
            16'b?100_0000_0000_0000 : active_sel_lines <= 16'h4000;
            16'b1000_0000_0000_0000 : active_sel_lines <= 16'h8000;
            default                 : active_sel_lines <= 16'h0000;
        endcase
    end



    always @(*)
    begin : data_sel_prio_encoder_noswap
        casez(ored_sel_lines_noswap)
            16'b????_????_????_???1 : data_sel_noswap <= 4'h0;
            16'b????_????_????_??10 : data_sel_noswap <= 4'h1;
            16'b????_????_????_?100 : data_sel_noswap <= 4'h2;
            16'b????_????_????_1000 : data_sel_noswap <= 4'h3;
            16'b????_????_???1_0000 : data_sel_noswap <= 4'h4;
            16'b????_????_??10_0000 : data_sel_noswap <= 4'h5;
            16'b????_????_?100_0000 : data_sel_noswap <= 4'h6;
            16'b????_????_1000_0000 : data_sel_noswap <= 4'h7;
            16'b????_???1_0000_0000 : data_sel_noswap <= 4'h8;
            16'b????_??10_0000_0000 : data_sel_noswap <= 4'h9;
            16'b????_?100_0000_0000 : data_sel_noswap <= 4'ha;
            16'b????_1000_0000_0000 : data_sel_noswap <= 4'hb;
            16'b???1_0000_0000_0000 : data_sel_noswap <= 4'hc;
            16'b??10_0000_0000_0000 : data_sel_noswap <= 4'hd;
            16'b?100_0000_0000_0000 : data_sel_noswap <= 4'he;
            16'b1000_0000_0000_0000 : data_sel_noswap <= 4'hf;
            default                 : data_sel_noswap <= 4'h0;
        endcase
    end
    
   always @(posedge clk)
    begin    
        if((srst_n == 'b0) || (c_spat_sm == IDLE))
            {lead_seq_limit_ovf,lead_seq_limit[2:0]} <= 4'h0;
        else if( lead_seq_limit != 'h0 || (din_valid == 1'b1 && (|din != 1'b0) ) )
            {lead_seq_limit_ovf,lead_seq_limit[2:0]} <=  ( (is_preamble_int | ~sync_search_req) == 1'b1 ? 'h0 : (lead_seq_limit + sync_search_req) );
    end
          
    always @(posedge clk)
    begin
        alt_cal_en_qual <= (~alt_cal_en_q | (alt_cal_en_qual & ~e_sync_search_found) ) & alt_cal_valid;
        alt_cal_en_q <= alt_cal_valid;
    end

        
    always @(posedge clk)
    if(srst_n == 1'b0)
    begin
        is_alt_cal_int <=  'b0;
        is_hs_data_int <=  'b0;
        is_skew_cal_int <= 'b0;
        is_preamble_int <= 'b0;
        ext_hs_search <= 'b0;
    end
    else
     begin
        is_alt_cal_int <= ( n_spat_sm == ALT_CAL ? 1'b1 : 1'b0 );
        is_hs_data_int <= ( n_spat_sm == HS_DATA ? 1'b1 : 1'b0 );
        is_skew_cal_int <= ( n_spat_sm == SKEW_CAL ? 1'b1 : 1'b0 );
        is_preamble_int <= ( n_spat_sm == PREAMBLE ? 1'b1 : 1'b0 );
        ext_hs_search <= ( n_spat_sm == PREAMBLE || n_spat_sm == PREAMBLE_EXIT ? 1'b1 : 1'b0 );
    end

    always @(posedge clk or negedge arst_n)
    begin
        if(arst_n == 1'b0)
        begin
            skew_cal_hs_int <= 1'b0;
            alt_cal_hs_int <= 1'b0;
            data_valid_hs_int <= 1'b0;
            active_hs_int <= 'b0;
            sync_hs_int <= 'b0;
        end
        else    
        begin
            skew_cal_hs_int <= srst_n & ~e_sync_search_found & (c_spat_sm == SKEW_CAL ? |din_valid_q :  1'b0);
            alt_cal_hs_int <= srst_n &  ~e_sync_search_found &  (c_spat_sm == ALT_CAL ? |din_valid_q :  1'b0);
            data_valid_hs_int <= srst_n &  ~e_sync_search_found & (c_spat_sm == HS_DATA  ? |din_valid_q : 1'b0);              
            active_hs_int <= srst_n &  ( n_spat_sm == IDLE || n_spat_sm == SEARCH_LEAD || n_spat_sm == PREAMBLE || n_spat_sm == PREAMBLE_EXIT ? 1'b0 :  |din_valid_q  );
            sync_hs_int <= srst_n &  c_spat_sm != HS_DATA && n_spat_sm == HS_DATA ? 'b1 : 'b0;
        end
    end


    always @(posedge clk)
    begin
        if(srst_n == 1'b0)
        begin
            dout_valid_int <= 1'b0;
        end
        else    
        begin
            dout_valid_int <=  ~e_sync_search_found & 
                              ( c_spat_sm == PREAMBLE ? preamble_sel_lines[data_sel_q] : 1'b1) & 
                              ( c_spat_sm == IDLE || c_spat_sm == SEARCH_LEAD || c_spat_sm == SOT_ERR || c_spat_sm == PREAMBLE_EXIT  ? 1'b0 : |din_valid_q );
        end
    end
       
    always @(posedge clk)
    begin    
        dout_int <=     swap_select_q == 'b0 ? ( ( is_sync_16 ?  WINDOW_DATA_OFFSET_16 : WINDOW_DATA_OFFSET_8 ) == 0 ? data_window_off0[data_sel_q] : data_window_off8[data_sel_q] ) 
                                             : ( ( is_sync_16 ?  WINDOW_DATA_OFFSET_16 : WINDOW_DATA_OFFSET_8 ) == 0 ? data_window_off0_swap[data_sel_q] : data_window_off8_swap[data_sel_q] );
    end    

    always @(posedge clk)
    if(e_sync_search_found)
    begin
        data_sel_q <= data_sel;
        swap_select_q <= data_sel == data_sel_noswap ? 1'b0 : |(ored_sel_lines & ored_sel_lines_swap);
        is_sync_16 <= preamble_sel_lines[data_sel] |skew_cal_sel_lines[data_sel] |  hs_data_pre_sel_lines[data_sel];
    end
    
    always @(posedge clk)
    begin    
        if(srst_n == 'b0)
        begin
            sync_search_found_int   <= 'b0;
        end
        else
        begin
            sync_search_found_int   <= e_sync_search_found & (n_spat_sm != PREAMBLE ? 1'b1 : 1'b0);
        end
    end

    always @(posedge clk or negedge arst_n)
    begin    
        if(arst_n == 'b0)
            sot_err <= 'b0;
        else
            sot_err <= (c_spat_sm == SOT_ERR ? 1'b1 : 1'b0) & sync_search_req;
    end
    assign sot_err_p = 1'b0;
    assign sot_sync_err_p = sot_err;
    assign eot_err_p = 1'b0;

    
    always @(*)
    begin
        if(|din_valid_q == 1'b0)
        begin
            n_spat_sm <= IDLE;
            e_sync_search_found <= 1'b0;
        end
        else
        begin
            case(c_spat_sm)
            IDLE:
                begin
                    e_sync_search_found <= 1'b0;
                    if(sync_search_req == 1'b1)
                        n_spat_sm <= SEARCH_LEAD;
                    else
                        n_spat_sm <= c_spat_sm;
                end
            SEARCH_LEAD:
                begin
                    if(skew_cal_prio | |preamble_sel_lines) 
                    begin
                        n_spat_sm <= |(active_sel_lines & preamble_sel_lines) ? PREAMBLE : SKEW_CAL;
                        e_sync_search_found <= |din_valid_q;
                    end
                    else if(lead_seq_limit == LEADER_SEQ_LIMIT) 
                    begin
                        n_spat_sm <= SOT_ERR;
                        e_sync_search_found <= 1'b0;
                    end
                    else if(|alt_cal_sel_lines | |hs_data_sel_lines) 
                    begin
                        n_spat_sm <= |(active_sel_lines & alt_cal_sel_lines) ? ALT_CAL : HS_DATA;
                        e_sync_search_found <= |din_valid_q;
                    end
                    else
                    begin
                        n_spat_sm <= c_spat_sm;
                        e_sync_search_found <= 1'b0;
                    end
                                    
                end
            PREAMBLE:
                begin
                    if(|hs_data_pre_sel_lines)
                    begin
                        n_spat_sm <= HS_DATA;
                        e_sync_search_found <= |din_valid_q;
                    end
                    else 
                    begin
                        if( preamble_sel_lines[data_sel_q] == 1'b0)
                            n_spat_sm <= PREAMBLE_EXIT;
                        else
                            n_spat_sm <= c_spat_sm;
                        e_sync_search_found <= 1'b0;
                    end
                end
            PREAMBLE_EXIT:
                begin
                    if(|hs_data_pre_sel_lines)
                    begin
                        n_spat_sm <= HS_DATA;
                        e_sync_search_found <= |din_valid_q;
                    end
                    else
                    begin
                        if (lead_seq_limit == LEADER_SEQ_LIMIT)
                            n_spat_sm <= SOT_ERR;
                        else
                            n_spat_sm <= c_spat_sm;
                        e_sync_search_found <= 1'b0;
                    end
                end
            default:
                begin
                    e_sync_search_found <= 1'b0;
                    n_spat_sm <= c_spat_sm;
                end
            endcase
        end
    end
    
    
    always @(posedge clk or negedge arst_n)
    begin
        if(arst_n == 1'b0)
        begin
            c_spat_sm <= IDLE;
        end
        else
        begin
            c_spat_sm <= srst_n == 1'b0 ? IDLE : n_spat_sm;
        end
    end

   
    hyperpipe # ( 
        .WIDTH(DWIDTH+4),
        .CYCLES(PIPELINE_OUT_DEPTH)
    ) syncpat_pipe (
        .clk(clk),
        .din( { sync_search_found_int, is_hs_data_int, is_preamble_int,  dout_valid_int, dout_int} ),
        .dout( { sync_search_found, is_hs_data, is_preamble, dout_valid, dout} )
    );

   if(SKEW_CAL_EN == 1)
     begin: skew_pipe
        hyperpipe
          # ( 
              .WIDTH(1),
              .CYCLES(PIPELINE_OUT_DEPTH)
              ) syncpat_skewcal_en
            (
             .clk(clk),
             .din( { is_skew_cal_int } ),
             .dout( { is_skew_cal } )
             );
     end
   else
     begin: no_skew_pipe         
        assign is_skew_cal = 1'b0;        
     end

   if(ALT_CAL_EN == 1)
     begin: alt_pipe
        hyperpipe
          # ( 
              .WIDTH(1),
              .CYCLES(PIPELINE_OUT_DEPTH)
              ) syncpat_altcal_en
            (
             .clk(clk),
             .din( { is_alt_cal_int } ),
             .dout( { is_alt_cal } )
             );
     end 
   else
     begin: no_alt_pipe
        assign is_alt_cal = 1'b0; 
     end
   
    if(PIPELINE_OUT_DEPTH > 0)
    begin: ppi_ctrl_pipeline
        logic [4:0] ppi_ctrl_pipe [PIPELINE_OUT_DEPTH-1:0];
        int stage;
        
        always @(posedge clk or negedge arst_n)
            if(arst_n == 1'b0)
                for(stage=0;stage<PIPELINE_OUT_DEPTH;stage=stage+1) ppi_ctrl_pipe[stage] <= 5'h0;
            else
            begin
                if( srst_n == 1'b0)
                    for(stage=0;stage<PIPELINE_OUT_DEPTH;stage=stage+1) ppi_ctrl_pipe[stage] <= 5'h0;
                else
                begin
                    ppi_ctrl_pipe[0] <= { active_hs_int, sync_hs_int, skew_cal_hs_int, alt_cal_hs_int, data_valid_hs_int };
                    for(stage=1;stage<PIPELINE_OUT_DEPTH;stage=stage+1) ppi_ctrl_pipe[stage] <= ppi_ctrl_pipe[stage-1];
                end
            end
        
        assign active_hs = ppi_ctrl_pipe[5*PIPELINE_OUT_DEPTH-1];
        assign sync_hs = ppi_ctrl_pipe[5*PIPELINE_OUT_DEPTH-2];
        assign skew_cal_hs = ppi_ctrl_pipe[5*PIPELINE_OUT_DEPTH-3];
        assign alt_cal_hs = ppi_ctrl_pipe[5*PIPELINE_OUT_DEPTH-4];
        assign data_valid_hs = ppi_ctrl_pipe[5*PIPELINE_OUT_DEPTH-5];
    end
    else
    begin: ppi_ctrl_no_pipeline
        assign active_hs = active_hs_int;
        assign sync_hs = sync_hs_int;
        assign skew_cal_hs = skew_cal_hs_int;
        assign alt_cal_hs = alt_cal_hs_int;
        assign data_valid_hs = data_valid_hs_int;
    end
    
endmodule    
    
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oIoHEGW9fR6uw35JhOq2VTm9BGqUouVT/luynT3RFpXaH9qDkZiE9zt9SpBE6gMaNws4+0yscOjEiIkAHR21oNJtTDNyPwXblJXNfT7WX2NPTS1w/7vGfm3JgUFzsNqfqXxLVrklgWffn2gO/qW5SlK8AAcn31jcfYK4J9CL9/dtQAlEcaXLNy7FmMwtTwyr12HpjZ6Mhbmif+VX/Mx7phopjI5yrkgxsUOC5qKEhMNYZdTEfCdGUNFoPAs+YDGA9K2H1swno9SSuvaDhEYOQ2pXu26kxSezdMR07cVMPtP4efCYAPwKVu+AKdcNB3TkTaCRDuU3VnKAkNuFqm/QEVgzITpQdCS5+u5NfVuADh2sl098knBWbN3Iq/W55o/eerdjP+xdkTf3qWgmzFrftU6imBIp1PzQv+fgXqSEJGXcD6iaA3b5K7koLJd+TUS2KeHRPHzJKou9Y3ZwdPXXZ8DkjVm7jwAYFQR40yc907pENZqZuq89HgZrqhRlrIqzJ2zBNYhld0OXUSIPI8wQROuWJ6RrTTubq0ZDZnvHftMoasr8js3VlQfi3JevVBwvtk9LVBoE7ncFve/kS/ftOrYrwL481VXur8C+O6VZRGykVYLMhrrWIC07q7MyBVlj9I+gsVaK96nQ5dEwbpoN5r8Ct+Ew5xyMvtW5VUxcClHjr7dvdGJiRP8KuJ/ycAUTa1x5rKfkRcpIEr7zu0jv8dyThIzKw8Z03ERqJRlgO4MMLW7Cd7dxCjof0Wbgu56sA8oJSdStrNrzP7/E6lzimyn"
`endif