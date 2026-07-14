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


module dphy_pcs_cal_skew_rx #(
        WIDTH = 8, 
        LANE_ID = 0,
        ALT_BIT_SHIFT = WIDTH/2,                  
        ALT_WORD_SHIFT = WIDTH == 16 ? 4  : 8,    
        ALT_CAL_EN = 0
        )
(
    input                       rx_clk,
    input                       arst_rx_n,
    input                       srst_rx_n,
    input                       fr_clk,
    input                       srst_fr_n,
    input                       is_skew_cal,
    input                       is_alt_cal,
    input [WIDTH-1:0]           data,
    input                       data_valid,
    input  [8:0]                prbs_init_val,
    input                       cal_done_skew,              
    input                       cal_done_alt,               
    input                       skew_del_ch_ack_pulse,
    input                       is_window_start_cmp,
    input                       del_ch_sent,               
    input                       data_pipe_full,
    input                       data_pipe_empty,
    input                       alt_skip_en,
    output logic                del_up,
    output logic                del_dn,
    output logic [4:0]          del_off,
    output logic                is_window_start,
    output logic                shadow_reset,
    output logic                shadow_load_final_en,
    output logic                shadow_load_from_start_en,
    output logic                shadow_load_from_end_en,
    output logic                window_start_load_en,
    output logic                window_start_inc_4,
    output logic                window_end_load_en,
    output logic                window_end_dec_4,
    output logic                window_end_inc_64,
    output logic                window_end_sminus_1,
    output logic                window_end_splus_64,
    output logic                window_update_delta_en,
    output logic                window_reset,
    output logic                cal_done,
    output logic                cal_err_state,
    output logic                cal_err_skew,
    output logic                cal_err_alt,
    input                       dqs_del_up_req

);

    localparam ALL_5 = (WIDTH== 8) ? 'h55 : 'h5555;
    localparam ALL_A = (WIDTH== 8) ? 'haa : 'haaaa;
    localparam CAL_IP_RX_EXTEND_CMP_ALT = (WIDTH== 8) ? CAL_IP_RX_EXTEND_CMP_ALT_8 : CAL_IP_RX_EXTEND_CMP_ALT_16;
    localparam CAL_IP_RX_EXTEND_CMP_SKEW = (WIDTH== 8) ? CAL_IP_RX_EXTEND_CMP_SKEW_8 : CAL_IP_RX_EXTEND_CMP_SKEW_16;
    localparam CAL_IP_RX_EXTEND_CMP = CAL_IP_RX_EXTEND_CMP_ALT > CAL_IP_RX_EXTEND_CMP_SKEW ? CAL_IP_RX_EXTEND_CMP_ALT : CAL_IP_RX_EXTEND_CMP_SKEW;
    localparam FULL_SWEEP = CAL_IP_FULL_SWEEP;
    localparam CAL_PRBS_SKIP_LEN  = WIDTH == 16 ? 1 : 2;   
    localparam CAL_PRBS_PAUSE_LEN = ALT_WORD_SHIFT - CAL_PRBS_SKIP_LEN - 1;       
    localparam CAL_CLK_GATE_WIDTH_ADD =  WIDTH == 16 ? 2 : 4;
    localparam ALT_COMP_GATE_DELAY_LEN = 5;

    
    logic [WIDTH-1:0] exp_data;    
    genvar i, j;
    int k;

    logic [7:0] skew_max_steps;
    logic [7:0] skew_max_steps_cntr;
    logic skew_max_steps_done;
    logic reload_cntr;
    logic load_pulse;
    logic first_tran_seen;
    logic [WIDTH-1:0] exp_val_skew;
    logic wait_empty_skew;
    logic del_ch;
    logic is_cal, cal_inc;
    logic is_skew_cal_q, is_alt_cal_q;
    logic is_all_5;
    logic [WIDTH-1:0] data_q;
    logic data_stable;
    logic [CAL_IP_RX_EXTEND_CMP-1:0] del_ch_ack_pulse_ext;
    logic [CAL_IP_RX_EXTEND_CMP_SKEW-1:0] skew_del_ch_ack_pulse_ext;
    logic data_pipe_empty_ext;
    logic alt_wait_resync;
    logic [1:0] alt_resync_cmp_q;
    logic alt_resync_cmp;
    logic cal_err_int;
    
    logic [WIDTH/2-1:0] exp_data_even;
    logic [WIDTH/2-1:0] exp_data_odd;
    logic [WIDTH/2-1:0] exp_data_even_q[ALT_WORD_SHIFT-1:0];
    logic [WIDTH/2-1:0] exp_data_odd_q[ALT_WORD_SHIFT-1:0];
    logic [WIDTH/2-1:0] data_even;
    logic [WIDTH/2-1:0] data_odd;
    logic [ALT_BIT_SHIFT+WIDTH/2-1:0] data_even_q;
    logic [ALT_BIT_SHIFT+WIDTH/2-1:0] data_odd_q;
    logic [WIDTH/2-1:0] data_shift_even[ALT_BIT_SHIFT-1:0];
    logic [WIDTH/2-1:0] data_shift_odd[ALT_BIT_SHIFT-1:0];
    logic [ALT_BIT_SHIFT-1:0] match_odd_sel [ALT_WORD_SHIFT-1:0];
    logic [ALT_BIT_SHIFT-1:0] match_even_sel [ALT_WORD_SHIFT-1:0];
    logic [ALT_WORD_SHIFT-1:0] match_odd;
    logic [ALT_WORD_SHIFT-1:0] match_even;
    logic [ALT_WORD_SHIFT-1:0] pass_sel_even;
    logic [ALT_WORD_SHIFT-1:0] pass_sel_odd;
    logic [ALT_WORD_SHIFT-1:0] pass_window_even;
    logic [ALT_WORD_SHIFT-1:0] pass_window_odd;
        
    logic [CAL_IP_RX_EXTEND_CMP_ALT-1:0] alt_del_ch_ack_pulse_ext;
    logic [CAL_PRBS_PAUSE_LEN-1:0] prbs_pause_sel;
    logic [CAL_PRBS_PAUSE_LEN-1:0] e_prbs_pause_sel;
    logic [CAL_PRBS_SKIP_LEN-1:0] prbs_skip_sel;
    logic [CAL_PRBS_SKIP_LEN-1:0] e_prbs_skip_sel;
        
    `ifdef SUPPORT_ALT_SWAP
    logic [ALT_BIT_SHIFT-1:0] match_odd_sel_swap [ALT_WORD_SHIFT-1:0];
    logic [ALT_BIT_SHIFT-1:0] match_even_sel_swap [ALT_WORD_SHIFT-1:0];
    logic [ALT_WORD_SHIFT-1:0] match_odd_swap;
    logic [ALT_WORD_SHIFT-1:0] match_even_swap;
    logic [ALT_WORD_SHIFT-1:0] pass_sel_even_swap;
    logic [ALT_WORD_SHIFT-1:0] pass_sel_odd_swap;
    logic [ALT_WORD_SHIFT-1:0] pass_window_even_swap;
    logic [ALT_WORD_SHIFT-1:0] pass_window_odd_swap;
    logic [CAL_PRBS_PAUSE_LEN-1:0] pass_window_pause_noswap;
    logic [CAL_PRBS_PAUSE_LEN-1:0] pass_window_pause_swap;
    logic [CAL_PRBS_SKIP_LEN-1:0] pass_window_skip_noswap;
    logic [CAL_PRBS_SKIP_LEN-1:0] pass_window_skip_swap;
    `endif
    logic [CAL_PRBS_SKIP_LEN-1:0] pass_window_skip;
    logic [CAL_PRBS_PAUSE_LEN-1:0] pass_window_pause;
    logic prbs_pause;
    logic prbs_pause_q;
    logic prbs_skip;
    logic pass;
    logic pass_qual;
    logic alt_is_swap;
    logic [CAL_CLK_GATE_WIDTH+CAL_CLK_GATE_WIDTH_ADD-1:0] alt_clk_gate_skip;
    logic [8:0] prbs_init_val_sync;
   
    
    // synthesis translate_off
    int link_id;
    // synthesis translate_on
    

    typedef enum { CMP_IDLE, CMP_GOOD, CMP_FLIP, CMP_BAD } skew_cmp_result_t;
    skew_cmp_result_t skew_cmp_result, skew_cmp_result_prev;
    typedef enum { ALT_PASS, ALT_FAIL, ALT_IDLE } alt_cmp_result_t;
    alt_cmp_result_t alt_cmp_result;

    typedef enum {  
            IDLE                                ,
            FULL_START                          ,
            READ_FIRST                          ,
            CAL_DONE                            ,
            PER_READ_FIRST,
            ALT_START,
            ALT_END,
            ALT_READ_CENTER,
            ALT_READ_CENTER_RESYNC,
            CAL_DELTA_UP,
            CAL_FINAL_WRITE,
            CAL_ERROR,
            PER_VAL_START                       ,
            PER_VAL_END                         ,
            PER_START_GOOD                      ,
            PER_START_BAD                       ,
            FULL_GOOD                           ,
            FULL_BAD                            ,
            PER_END_GOOD                        ,
            PER_END_BAD                          
            } skew_cal_sm_t;
    skew_cal_sm_t    cal_sm;    
    
    
    localparam RESYNC_LIMIT = 512;      
    logic [9:0] resync_limit_cnt;
    
    always @(posedge rx_clk)
    begin
        if(cal_sm == ALT_READ_CENTER_RESYNC)
            resync_limit_cnt <= resync_limit_cnt + 1'b1;
        else
            resync_limit_cnt <= 'h0;
    end
    
    assign shadow_reset =  load_pulse & is_skew_cal & ( (cal_sm == FULL_START) ? 'b1 : 0);
    assign shadow_load_from_start_en = (is_skew_cal == 1'b1 && cal_sm == PER_VAL_START || cal_sm == PER_READ_FIRST) ? load_pulse : 'b0;
    assign shadow_load_from_end_en = load_pulse & (cal_sm == PER_START_GOOD || cal_sm == PER_START_BAD || cal_sm == PER_VAL_END) ? 'b1 : 'b0;
    assign window_reset = load_pulse & (cal_sm == FULL_START ? 1'b1 : 1'b0);
    assign window_update_delta_en = ( cal_sm == CAL_DELTA_UP ) ? ~load_pulse : 1'b0;
    
    assign window_end_inc_64 = ( cal_sm == FULL_GOOD && skew_cmp_result == CMP_FLIP && first_tran_seen == 'b1 && wait_empty_skew == 1'b0) ? 'b1 : 'b0;
    assign window_end_splus_64 = ( cal_sm == FULL_GOOD && skew_cmp_result == CMP_FLIP && first_tran_seen == 'b0) ? 'b1 : 'b0;
    assign window_end_sminus_1 = ( cal_sm == FULL_GOOD && skew_cmp_result == CMP_BAD && first_tran_seen == 'b0) ? 'b1 : 'b0;
    assign window_start_inc_4 = ( cal_sm == PER_VAL_START && (skew_cmp_result == CMP_BAD || skew_cmp_result == CMP_FLIP)) ? 'b1 : 'b0;
    assign window_end_dec_4 = ( cal_sm == PER_VAL_END && (skew_cmp_result == CMP_BAD || skew_cmp_result == CMP_FLIP)) ? 'b1 : 'b0;


    always @(*)
    begin
        case(cal_sm)
        FULL_GOOD:
            begin
                window_start_load_en  <= (skew_cmp_result == CMP_FLIP &&  wait_empty_skew == 1'b0) ? 'b1 : 'b0;
                window_end_load_en  <= (alt_cmp_result == ALT_PASS) ? 1'b1 : 1'b0;  
                shadow_load_final_en <= load_pulse;
            end
        FULL_BAD:
            begin
                window_start_load_en  <= ( first_tran_seen == 1'b0 && (skew_cmp_result == CMP_FLIP || alt_cmp_result == ALT_PASS) ) ? 'b1 : 'b0;
                window_end_load_en  <=  (( first_tran_seen == 1'b0 && skew_cmp_result == CMP_FLIP) || skew_cmp_result == CMP_GOOD || alt_cmp_result == ALT_PASS)  ? 'b1 : 'b0;
                shadow_load_final_en <= load_pulse;
            end
        READ_FIRST:
            begin
                window_start_load_en  <= alt_cmp_result == ALT_PASS ? 'b1 : 'b0;
                window_end_load_en  <= alt_cmp_result == ALT_PASS ? 'b1 : 'b0;
                shadow_load_final_en <= 1'b0;
            end
        ALT_START:
            begin
                window_start_load_en  <= alt_cmp_result == ALT_PASS ? 'b1 : 'b0;
                window_end_load_en  <= 'b0;
                shadow_load_final_en <= load_pulse;
            end
        ALT_END:
            begin
                window_start_load_en  <= 'b0;
                window_end_load_en  <= alt_cmp_result == ALT_PASS ? 'b1 : 'b0;
                shadow_load_final_en <= 'b0;
            end
        PER_VAL_START:
            begin
                window_start_load_en  <= 'b0;
                window_end_load_en <= 'b0;
                shadow_load_final_en <= 1'b0;
            end        
        PER_VAL_END:
            begin
                window_start_load_en  <= 'b0;
                window_end_load_en <= 'b0;
                shadow_load_final_en <= 1'b0;
            end        
        PER_START_GOOD,PER_START_BAD: 
            begin
                window_start_load_en  <= (skew_cmp_result == CMP_GOOD ? 'b1 : 'b0) & is_window_start_cmp;
                window_end_load_en <= 'b0;
                shadow_load_final_en <= 1'b0;
            end
        PER_END_GOOD, PER_END_BAD: 
            begin
                window_start_load_en  <= 'b0;
                window_end_load_en <= (skew_cmp_result == CMP_GOOD ? 'b1 : 'b0) & ~is_window_start_cmp;
                shadow_load_final_en <= load_pulse;
            end
        CAL_DELTA_UP:
            begin
                window_start_load_en  <= 'b0;
                window_end_load_en <= 'b0;
                shadow_load_final_en <= load_pulse;
            end
        default: 
            begin
                window_start_load_en  <= 'b0;
                window_end_load_en <= 'b0;
                shadow_load_final_en <= 1'b0;
            end
        endcase
    end



    assign reload_cntr = (cal_sm == FULL_START || cal_sm == PER_VAL_START || cal_sm == PER_VAL_END || cal_sm == ALT_START) ? load_pulse : 1'b0;
    always @(posedge rx_clk)
    begin
        if(is_cal == 1'b0 || reload_cntr == 'b1)
            skew_max_steps_cntr <= 'h0;
        else
            skew_max_steps_cntr <=  skew_max_steps_done == 'b1 ? skew_max_steps_cntr : skew_max_steps_cntr + del_ch;
    end
    assign skew_max_steps_done = skew_max_steps == skew_max_steps_cntr;
    
    always @(posedge rx_clk)
    begin 
        case(cal_sm)
        IDLE, FULL_START, ALT_READ_CENTER : 
            begin
                first_tran_seen <= 'b0;
                exp_val_skew <= 'h0;
            end
        READ_FIRST, PER_READ_FIRST : 
            begin
                if(skew_cmp_result == CMP_FLIP) 
                    exp_val_skew <= is_all_5 == 1'b1 ? ALL_5 : ALL_A;
            end
        FULL_GOOD, ALT_START, ALT_END : 
            begin
                if(skew_cmp_result == CMP_BAD || alt_cmp_result == ALT_FAIL)
                    first_tran_seen <= 'b1;                          
            end
        FULL_BAD : 
            begin
                 if(skew_cmp_result == CMP_FLIP || alt_cmp_result == ALT_PASS)
                    first_tran_seen <= 'b1;
            
                if( first_tran_seen == 1'b0 && (skew_cmp_result == CMP_FLIP || alt_cmp_result == ALT_PASS) )
                    exp_val_skew <= is_all_5 == 1'b1 ? ALL_5 : ALL_A;
            end
        default : ; 
        endcase
    end

    always @(posedge rx_clk)
    begin 
        case(cal_sm)
        IDLE :
            load_pulse <= 'b0;
 
        FULL_START, CAL_DELTA_UP :                       
            load_pulse <= ~load_pulse;

        PER_READ_FIRST, PER_VAL_START, PER_VAL_END :     
            begin
                if(load_pulse == 'b1)
                    load_pulse <= 'b0;
                else
                    load_pulse <= wait_empty_skew & (skew_cmp_result != CMP_IDLE) ? 'b1 : 'b0;                    
            end
        FULL_GOOD, ALT_START, ALT_END, ALT_READ_CENTER: 
            begin
                if(load_pulse === 'b1)
                    load_pulse <= 'b0;
                else
                    load_pulse <= (skew_max_steps_done | wait_empty_skew) & data_pipe_empty_ext;                
            end
        FULL_BAD : 
            begin
                if(load_pulse === 'b1)
                    load_pulse <= 'b0;
                else if( ( (skew_max_steps_done | wait_empty_skew) & data_pipe_empty_ext ) == 'b1)
                    load_pulse <= first_tran_seen;
            end
        PER_START_GOOD, PER_START_BAD, PER_END_GOOD, PER_END_BAD :     
            begin
                if(load_pulse === 'b1)
                    load_pulse <= 'b0;
                else if( ( (skew_max_steps_done | wait_empty_skew) & data_pipe_empty_ext ) == 'b1)
                    load_pulse <= 'b1;

            end
        default: 
           ;
        endcase
    end
    
    always @(posedge rx_clk)
    begin 
        case(cal_sm)
        IDLE, FULL_START : 
                wait_empty_skew <= 'b0;
        READ_FIRST, PER_READ_FIRST : 
            begin
                if(wait_empty_skew == 'b1 && (skew_cmp_result != CMP_IDLE || alt_cmp_result != ALT_IDLE))
                    wait_empty_skew <= 'b0;
                else if(del_ch_sent == 'b0)
                    wait_empty_skew <= 'b1;                    
            end
        FULL_GOOD, ALT_START, ALT_END :         
            begin
                if(skew_cmp_result == CMP_FLIP || alt_cmp_result == ALT_FAIL)
                    wait_empty_skew <= 1'b1;
                else if(load_pulse === 'b1)
                     wait_empty_skew <= 'b0;           
            end
        FULL_BAD :          
            begin
                if( (skew_cmp_result == CMP_FLIP || alt_cmp_result == ALT_FAIL) && first_tran_seen == 1'b1)
                    wait_empty_skew <= 'b1;
                else if(load_pulse === 'b1)
                    wait_empty_skew <= 1'b0;
            end
        PER_VAL_START, PER_VAL_END, ALT_READ_CENTER, CAL_FINAL_WRITE :     
            begin
		if(wait_empty_skew == 'b1 && (skew_cmp_result != CMP_IDLE || ((alt_cmp_result != ALT_IDLE) && (~dqs_del_up_req)) ))
                    wait_empty_skew <= 'b0;
                else if(del_ch_sent == 'b0)
                    wait_empty_skew <= 'b1;               
            end
        default: 
           ;
        endcase
    end

    always @(posedge rx_clk)
    begin 
        if(is_cal == 1'b0)
            cal_sm <= IDLE;
        else 
        begin
            case(cal_sm)
            IDLE : 
                begin
                    if( (is_cal & data_valid) == 'b1)
                    begin
                        if(is_alt_cal == 'b1)
                            cal_sm <= READ_FIRST;
                        else
                            cal_sm <= ( ~cal_done_skew ) == 1'b1 ? FULL_START : PER_READ_FIRST;
                        // synthesis translate_off
                        if(LANE_ID == 0)
                        $display("Cal start (link %1d) @ %t", link_id, $realtime);
                        // synthesis translate_on
                    end
                end
            FULL_START : 
                begin
                    if(load_pulse == 'b1)
                        cal_sm <= READ_FIRST;
                end
            READ_FIRST : 
                begin
                    if(is_alt_cal == 'b1)
                    begin
                        if(alt_cmp_result == ALT_PASS)
                            cal_sm <= ALT_START;
                        else if(alt_cmp_result == ALT_FAIL) 
                            cal_sm <= CAL_ERROR;
                    end
                    else    
                    begin
                        if(skew_cmp_result == CMP_BAD)
                            cal_sm <= FULL_BAD;
                        else if(skew_cmp_result != CMP_IDLE)
                            cal_sm <= FULL_GOOD;
                    end
                end
            PER_READ_FIRST : 
                begin
                    if(skew_cmp_result == CMP_BAD)
                        cal_sm <= CAL_ERROR;
                    if(load_pulse == 'b1)
                        cal_sm <= PER_VAL_START;                    
                end
            ALT_START :
                begin
                    if(load_pulse === 'b1)
                    begin
                        cal_sm <= ALT_READ_CENTER;
                    end
                end
            ALT_READ_CENTER :
                begin
                    if(alt_cmp_result == ALT_PASS)
                        cal_sm <= ALT_END;  
                    else if (alt_cmp_result == ALT_FAIL)        
                        cal_sm <= ALT_READ_CENTER_RESYNC;
                end
            ALT_READ_CENTER_RESYNC:
                begin
                    if(alt_cmp_result == ALT_PASS)
                        cal_sm <= ALT_END;  
                    if(resync_limit_cnt == RESYNC_LIMIT)    
                        cal_sm <= CAL_ERROR;                
                end
            ALT_END :
                begin
                    if(load_pulse === 'b1)
                    begin
                        cal_sm <= CAL_DELTA_UP;
                    end
                end
            FULL_GOOD : 
                begin
                    if(load_pulse === 'b1)
                    begin
                        cal_sm <= (is_alt_cal == 1'b1) ? CAL_DELTA_UP : CAL_FINAL_WRITE;
                        // synthesis translate_off
                        `ifdef RTL_SIM_CAL_DEBUG
                            if(LANE_ID == 0)
                                $display("Cal full sweep done (link %1d) @ %t", link_id, $realtime);
                        `endif
                        // synthesis translate_on
                    end
                end
            FULL_BAD : 
                begin
                    if(load_pulse === 'b1)
                    begin
                        cal_sm <= (is_alt_cal == 1'b1) ? CAL_DELTA_UP : CAL_FINAL_WRITE;
                        // synthesis translate_off
                        `ifdef RTL_SIM_CAL_DEBUG
                            if(LANE_ID == 0)
                                $display("Cal full sweep done (link %1d) @ %t", link_id, $realtime);
                        `endif
                        // synthesis translate_on
                    end
                    else if( ( (skew_max_steps_done | wait_empty_skew) & data_pipe_empty_ext & ~first_tran_seen) == 'b1)
                        cal_sm <= CAL_ERROR;

                end
            PER_VAL_START : 
                begin
                    if(load_pulse == 'b1)
                    begin  
                        if(skew_cmp_result_prev == CMP_GOOD)
                            cal_sm <= PER_START_GOOD;
                        else
                            cal_sm <= PER_START_BAD;
                    end
                end
            PER_START_GOOD, PER_START_BAD :
                begin
                    if(load_pulse == 'b1)
                        cal_sm <= PER_VAL_END;
                end
            PER_VAL_END : 
                begin
                    if(load_pulse == 'b1)
                    begin
                        if(skew_cmp_result_prev == CMP_GOOD)
                             cal_sm <= PER_END_GOOD;
                        else
                            cal_sm <= PER_END_BAD;
                    end

                end
            PER_END_GOOD, PER_END_BAD :
                begin
                    if(load_pulse == 'b1)
                    begin
                        cal_sm <= CAL_FINAL_WRITE;
                        // synthesis translate_off
                        `ifdef RTL_SIM_CAL_DEBUG
                            if(LANE_ID == 0)
                                $display("Cal per done (link %1d) @ %t", link_id, $realtime);
                        `endif
                        // synthesis translate_on
                    end
                end
            CAL_DELTA_UP:
                begin
                    if(load_pulse == 'b1)
                        cal_sm <= CAL_FINAL_WRITE;                       
                end
            CAL_FINAL_WRITE:
                begin
 	        if(wait_empty_skew == 'b1 && (skew_cmp_result != CMP_IDLE || ((alt_cmp_result != ALT_IDLE) && (~dqs_del_up_req)) ))
                       cal_sm <= cal_err_int == 0 ? CAL_DONE : CAL_ERROR;      
                end
            CAL_ERROR:
                    cal_sm <= is_alt_cal == 'b0 ? FULL_START : (cal_err_int == 0 ? CAL_FINAL_WRITE : CAL_ERROR) ;   
            default: 
                begin
                    if(is_cal == 'b0)  cal_sm <= IDLE;
                end
            endcase
        end
    end
    

    
    always @(posedge rx_clk)
    begin
        if(is_cal == 1'b0)
        begin
            del_up <= 'b0;
            del_dn <= 'b0;
        end
        else 
        begin
            case(cal_sm)
            READ_FIRST, PER_READ_FIRST, PER_VAL_START, PER_VAL_END, CAL_FINAL_WRITE, ALT_READ_CENTER:
                begin
                    del_up <= del_ch_sent & ~data_pipe_full & ~wait_empty_skew & ~load_pulse & ~del_up;
                    del_dn <= del_ch_sent & ~data_pipe_full & ~wait_empty_skew & ~load_pulse & ~del_dn;
                end
            FULL_BAD, FULL_GOOD, PER_END_BAD, PER_END_GOOD:
                begin
                    del_up <= del_ch_sent & ~data_pipe_full & ~wait_empty_skew & ~load_pulse & ~del_up & ~skew_max_steps_done;
                    del_dn <= 'b0;
                end
            ALT_END:
                begin
                    del_up <= del_ch_sent & data_pipe_empty_ext & ~wait_empty_skew & ~load_pulse & ~del_up & ~skew_max_steps_done;
                    del_dn <= 'b0;
                end
            ALT_START:
                begin
                    del_up <= 'b0;
                    del_dn <= del_ch_sent & data_pipe_empty_ext & ~wait_empty_skew & ~load_pulse & ~del_dn & ~skew_max_steps_done;;
                end
            PER_START_BAD, PER_START_GOOD:
                begin
                    del_up <= 'b0;
                    del_dn <= del_ch_sent & ~data_pipe_full & ~wait_empty_skew & ~load_pulse & ~del_dn & ~skew_max_steps_done;;
                end
            default:    
                begin
                    del_up <= 'b0;
                    del_dn <= 'b0;
                end
            endcase
        end
    end

    always @(*)
        case(cal_sm)
            PER_START_BAD, PER_START_GOOD, ALT_START: is_window_start <= 'b1;
            default: is_window_start <= 'b0;
        endcase
    
    always @(*)
        case(cal_sm)
        FULL_START, READ_FIRST, FULL_GOOD, FULL_BAD :  skew_max_steps <=  ( cal_err_int == 'b1 && cal_done_skew == 1'b1 ) ? 'd8 : FULL_SWEEP;
        ALT_START, ALT_END :  skew_max_steps <=  FULL_SWEEP >> 1;
        default: skew_max_steps <= 'd3;
        endcase
            
    assign del_ch = del_up | del_dn;

    always @(*)
        case(cal_sm)
        FULL_START, READ_FIRST, FULL_GOOD, FULL_BAD :  del_off <=  ( cal_err_int == 'b1 && cal_done_skew == 1'b1 ) ? 'd8 : 'd1;
        default: del_off <= 'd1;
        endcase
    

    logic del_ch_ack_pulse;
    logic clk_gate_skip_en;
    logic [ALT_COMP_GATE_DELAY_LEN-1:0] clk_gate_skip_en_q;

    
    always @(posedge rx_clk)
    begin
        if(is_cal == 1'b0)
            del_ch_ack_pulse_ext <= 'h0;
        else
            del_ch_ack_pulse_ext <= {del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP-2:0] , del_ch_ack_pulse | alt_resync_cmp_q[1]};
    end    
    
    always @(posedge rx_clk)
        alt_resync_cmp_q <= { alt_resync_cmp_q[0], alt_resync_cmp };
    
    assign skew_del_ch_ack_pulse_ext = is_skew_cal == 1'b1 ? del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_SKEW-1:0] : 'h0;
    assign alt_del_ch_ack_pulse_ext = is_alt_cal == 1'b1 ? del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_ALT-1:0] : 'h0;
    assign data_pipe_empty_ext = data_pipe_empty & (is_skew_cal ? ~|skew_del_ch_ack_pulse_ext : ~|alt_del_ch_ack_pulse_ext & ~clk_gate_skip_en & ~|clk_gate_skip_en_q);
    assign alt_wait_resync = (alt_cmp_result == ALT_FAIL && ( cal_sm == ALT_READ_CENTER || cal_sm == ALT_READ_CENTER_RESYNC ) ) ? 'b1 : 'b0;
    assign alt_resync_cmp = (cal_sm == ALT_READ_CENTER_RESYNC  ? 'b1 : 'b0) & prbs_pause & ~|prbs_pause_sel & ~|del_ch_ack_pulse_ext;
    
    always @(posedge rx_clk)
    begin
        if(is_alt_cal == 1'b0)
        begin
            alt_clk_gate_skip <= 'h0;
            clk_gate_skip_en_q <= 'h0;
        end
        else
        begin
            alt_clk_gate_skip <= {alt_clk_gate_skip[CAL_CLK_GATE_WIDTH+CAL_CLK_GATE_WIDTH_ADD-2:0] , skew_del_ch_ack_pulse};
            clk_gate_skip_en_q <= { clk_gate_skip_en_q[ALT_COMP_GATE_DELAY_LEN-2:0],  clk_gate_skip_en };
        end
    end    
    
    assign del_ch_ack_pulse = is_alt_cal == 1'b1 ? clk_gate_skip_en_q[ALT_COMP_GATE_DELAY_LEN-1] &  ~clk_gate_skip_en_q[ALT_COMP_GATE_DELAY_LEN-2] : skew_del_ch_ack_pulse;
    assign clk_gate_skip_en = alt_skip_en;
    

    for(i=0; i<WIDTH; i+=2)
    begin : data_q_mux
        assign data_q [i] = data_even_q[ALT_BIT_SHIFT+i/2];
        assign data_q [i+1] = data_odd_q[ALT_BIT_SHIFT+i/2];        
    end
    
    always @(posedge rx_clk)
            data_stable <= (skew_del_ch_ack_pulse_ext[0] | data_stable ) & (data_q == data ? 1'b1 : 1'b0);

    always @(posedge rx_clk)
    begin
        if (skew_del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_SKEW-1] == 'b1 && is_skew_cal == 1'b1)
        begin
            if( (data == ALL_5 || data == ALL_A) && data_stable === 1'b1 ) 
            begin
                is_all_5 <= data == ALL_5 ? 1'b1 : 1'b0;
                if( ~|(data ^ exp_val_skew) )
                    skew_cmp_result <= CMP_GOOD;
                else 
                    skew_cmp_result <= CMP_FLIP;
            end
            else
                skew_cmp_result <= CMP_BAD;
        end
        else    skew_cmp_result <= CMP_IDLE;
    end

    always @(posedge rx_clk)
    begin
        if (skew_cmp_result != CMP_IDLE)
            skew_cmp_result_prev <= skew_cmp_result;
    end
    
    logic [WIDTH-1:0]           prbs_out_data;
    logic [15:0]                prbs_next_data;

    always @(posedge rx_clk)
        if(cal_sm == READ_FIRST && (is_alt_cal & del_ch) == 1'b1)
            alt_is_swap <= (data == exp_data) ? 1'b0 : 1'b1;        
    

    for(i=0; i<WIDTH; i+=2)
    begin : d_exp_d_map
        assign data_even[i/2] = data[i];
        assign data_odd[i/2] = data[i+1];
        assign exp_data_even[i/2] = exp_data[i];
        assign exp_data_odd[i/2] = exp_data[i+1];
    end

    for(i=0; i<ALT_BIT_SHIFT; i++)
    begin : alt_b_shift
        assign data_shift_even[i] = data_even_q[ALT_BIT_SHIFT-i+:WIDTH/2];
        assign data_shift_odd[i] = data_odd_q[ALT_BIT_SHIFT-i+:WIDTH/2];
        for(j=0; j<ALT_WORD_SHIFT; j++)
        begin : alt_b_w_shift
            `ifdef SUPPORT_ALT_SWAP
                assign match_even_sel[j][i] = data_shift_even[i] == exp_data_even_q[j] ? 'b1 : 'b0;
                assign match_odd_sel[j][i] = data_shift_odd[i] == exp_data_odd_q[j] ? 'b1 : 'b0;
                assign match_even_sel_swap[j][i] = data_shift_even[i] == exp_data_odd_q[j] ? 'b1 : 'b0;
                assign match_odd_sel_swap[j][i] = data_shift_odd[i] == exp_data_even_q[j] ? 'b1 : 'b0;
            `else
                assign match_even_sel[j][i] = data_shift_even[i] == ( alt_is_swap == 'b1 ? exp_data_odd_q[j] :  exp_data_even_q[j]) ? 'b1 : 'b0;
                assign match_odd_sel[j][i] = data_shift_odd[i] == ( alt_is_swap == 'b1 ? exp_data_even_q[j] :  exp_data_odd_q[j]) ? 'b1 : 'b0;
            `endif
        end
    end

    for(j=0; j<ALT_WORD_SHIFT; j++)
    begin : alt_w_shift
        assign match_even[j] = |match_even_sel[j];
        assign match_odd[j] =  |match_odd_sel[j];
       `ifdef SUPPORT_ALT_SWAP
            assign match_even_swap[j] = |match_even_sel_swap[j];
            assign match_odd_swap[j] =  |match_odd_sel_swap[j];
        `endif
    end
    
    always @(posedge rx_clk)
    begin
        if(is_alt_cal == 1'b0)
        begin
            for(k=0; k<ALT_WORD_SHIFT; k++)
            begin
                exp_data_even_q[k] <= 'h0;
                exp_data_odd_q[k] <= 'h0;
            end
        end
        else
        begin
            exp_data_even_q[0] <= prbs_pause_q ? exp_data_even_q[0] : exp_data_even;
            exp_data_odd_q[0] <= prbs_pause_q ? exp_data_odd_q[0] : exp_data_odd;
            for(k=1; k<ALT_WORD_SHIFT; k++)
            begin
                exp_data_even_q[k] <= prbs_pause_q ? exp_data_even_q[k] : exp_data_even_q[k-1];
                exp_data_odd_q[k] <= prbs_pause_q ? exp_data_odd_q[k] : exp_data_odd_q[k-1];
            end
        end
    end
        
    always @(posedge rx_clk)
    begin
        if(is_cal == 1'b0)   
        begin
            data_even_q <= 'h0;
            data_odd_q <= 'h0;
        end
        else
        begin
            data_even_q <= { data_even, data_even_q[ALT_BIT_SHIFT+WIDTH/2-1:WIDTH/2]};
            data_odd_q <= { data_odd, data_odd_q[ALT_BIT_SHIFT+WIDTH/2-1:WIDTH/2]};
        end
    end

    always @(posedge rx_clk)
    begin
        for(k=0; k<ALT_WORD_SHIFT; k++)
        begin
            pass_window_even[k] <= ~|alt_del_ch_ack_pulse_ext | (pass_window_even[k] & match_even[k]);
            pass_window_odd[k] <= ~|alt_del_ch_ack_pulse_ext | (pass_window_odd[k] & match_odd[k]);
            pass_sel_even[k] <= |alt_del_ch_ack_pulse_ext == 1'b1 ? pass_window_even[k] : pass_sel_even[k];
            pass_sel_odd[k] <= |alt_del_ch_ack_pulse_ext == 1'b1 ? pass_window_odd[k] : pass_sel_odd[k];
            `ifdef SUPPORT_ALT_SWAP
                pass_window_even_swap[k] <= ~|alt_del_ch_ack_pulse_ext | (pass_window_even_swap[k] & match_even_swap[k]);
                pass_window_odd_swap[k] <= ~|alt_del_ch_ack_pulse_ext | (pass_window_odd_swap[k] & match_odd_swap[k]);
                pass_sel_even_swap[k] <= |alt_del_ch_ack_pulse_ext == 1'b1 ? pass_window_even_swap[k] : pass_sel_even_swap[k];
                pass_sel_odd_swap[k] <= |alt_del_ch_ack_pulse_ext == 1'b1 ? pass_window_odd_swap[k] : pass_sel_odd_swap[k];
            `endif
        end
     end
    
    always @(posedge rx_clk)
    begin
        if(is_alt_cal == 1'b0)
        begin
            prbs_pause <= 1'b0;
            prbs_pause_q <= 1'b0;
            prbs_skip <= 1'b0;
        end
        else
        begin
            prbs_pause <= |prbs_pause_sel;
            prbs_pause_q <= prbs_pause;
            prbs_skip <= |prbs_skip_sel;
        end
    end

    if(CAL_PRBS_PAUSE_LEN > 1)
    begin :  pause_len_gt1
    always @(posedge rx_clk)
        if(is_alt_cal == 1'b0)
            prbs_pause_sel <= 'h0;
        else
            prbs_pause_sel <= alt_del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_ALT-1] == 1'b1 ? e_prbs_pause_sel : { 1'b0, prbs_pause_sel[CAL_PRBS_PAUSE_LEN-1 : 1] };
    end
    else
    begin :  pause_len_eq1
    always @(posedge rx_clk)
        if(is_alt_cal == 1'b0)
            prbs_pause_sel <= 'h0;
        else
            prbs_pause_sel <= alt_del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_ALT-1] == 1'b1 ? e_prbs_pause_sel : 1'b0;
    end
    

    if(CAL_PRBS_SKIP_LEN > 1)
    begin : skip_len_gt1
        always @(posedge rx_clk)
            if(is_alt_cal == 1'b0)
                prbs_skip_sel <= 'h0;
            else
                prbs_skip_sel <= alt_del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_ALT-1] == 1'b1 ? e_prbs_skip_sel : {prbs_skip_sel[CAL_PRBS_SKIP_LEN-2:0], 1'b0 };
    end
    else
    begin : skip_len_eq1
        always @(posedge rx_clk)
            if(is_alt_cal == 1'b0)
                prbs_skip_sel <= 'h0;
            else
                prbs_skip_sel <= alt_del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_ALT-1] == 1'b1 ? e_prbs_skip_sel : 1'b0;
    end
    
    
    `ifdef SUPPORT_ALT_SWAP
        assign pass_window_pause_noswap = pass_window_even[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN]  > pass_window_odd[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN]  ? 
                                        pass_window_odd[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN]  : pass_window_even[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN] ;
        assign pass_window_pause_swap = pass_window_even_swap[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN] > pass_window_odd_swap[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN] ? 
                                        pass_window_odd_swap[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN] : pass_window_even_swap[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN];
        assign pass_window_pause = |pass_window_pause_swap ? pass_window_pause_swap : pass_window_pause_noswap;
    
        assign pass_window_skip_noswap = pass_window_even[CAL_PRBS_SKIP_LEN-1:0]  > pass_window_odd[CAL_PRBS_SKIP_LEN-1:0]  ? 
                                        pass_window_odd[CAL_PRBS_SKIP_LEN-1:0]  : pass_window_even[CAL_PRBS_SKIP_LEN-1:0] ;
        assign pass_window_skip_swap = pass_window_even_swap[CAL_PRBS_SKIP_LEN-1:0] > pass_window_odd_swap[CAL_PRBS_SKIP_LEN-1:0] ? 
                                        pass_window_odd_swap[CAL_PRBS_SKIP_LEN-1:0] : pass_window_even_swap[CAL_PRBS_SKIP_LEN-1:0];
        assign pass_window_skip = |pass_window_skip_swap ? pass_window_skip_swap : pass_window_skip_noswap;

        assign pass = (|pass_sel_even & |pass_sel_odd) | (|pass_sel_even_swap & |pass_sel_odd_swap);
    `else
        assign pass_window_pause = pass_window_even[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN]  > pass_window_odd[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN]  ? 
                                   pass_window_odd[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN]  : pass_window_even[ALT_WORD_SHIFT-1-:CAL_PRBS_PAUSE_LEN] ;
        assign pass_window_skip = pass_window_even[CAL_PRBS_SKIP_LEN-1:0]  > pass_window_odd[CAL_PRBS_SKIP_LEN-1:0]  ? 
                                  pass_window_odd[CAL_PRBS_SKIP_LEN-1:0]  : pass_window_even[CAL_PRBS_SKIP_LEN-1:0] ;
        assign pass = (|pass_window_even & |pass_window_odd) ;
    `endif


    assign e_prbs_pause_sel = ( cal_sm == ALT_READ_CENTER || cal_sm == ALT_READ_CENTER_RESYNC ) &&  pass_qual !== 1'b1 ? ( { CAL_PRBS_PAUSE_LEN { alt_wait_resync } } ) 
                              : pass_window_pause;
    assign e_prbs_skip_sel =  pass_window_skip;

    assign pass_qual = pass;
    assign alt_cmp_result = alt_del_ch_ack_pulse_ext[CAL_IP_RX_EXTEND_CMP_ALT-1] == 1'b0 ? ALT_IDLE : (pass_qual === 1'b1 ? ALT_PASS : ALT_FAIL);
    
    `ifdef PRBS_USE_FUTURE 
            always @(posedge rx_clk)
            begin
                exp_data <= prbs_next_data[WIDTH-1:0];
            end
    `else
        `ifdef PRBS_USE_PREV    
            logic [WIDTH-1:0]           prbs_out_data_q;
            always @(posedge rx_clk)
            begin
                exp_data <= prbs_out_data_q;
                prbs_out_data_q <= prbs_out_data;
            end            
        `else 
            assign exp_data = prbs_out_data;
        `endif
    `endif


   for(i=0; i<9; i++)
     begin: prbs_init 
	    altera_std_synchronizer_nocut#(.depth(3)) inst_cdc (.clk(rx_clk), .reset_n(1'b1), .din(prbs_init_val[i]), .dout(prbs_init_val_sync[i]));
     end

   if(ALT_CAL_EN == 1)
     begin: alt_cal_prbs
        dphy_prbs9 
          #(
            .WIDTH(WIDTH),
    `ifdef PRBS_USE_FUTURE
            .LOOKAHEAD(1)
    `else
            .LOOKAHEAD(0)
    `endif
            )
        prbs9_gen
          (
           .clk(rx_clk),
           .srst_n(srst_rx_n),
           .enable(is_alt_cal),
           .init_val(prbs_init_val_sync),    
           .pause(prbs_pause),
           .skip(prbs_skip | clk_gate_skip_en | (del_up & del_dn) ),
           .out_valid(prbs_out_valid),
           .prbs_out(prbs_out_data),
           .prbs_next(prbs_next_data)
           );
     end   
   else
     begin: no_prbs
        assign prbs_out_valid = 1'b0;
        assign prbs_out_data = 'd0;
        assign prbs_next_data = 'd0;        
     end
    
    
    assign is_cal = is_skew_cal | is_alt_cal;
    always @(posedge rx_clk)
    begin
        is_skew_cal_q <= is_skew_cal;
        is_alt_cal_q <= is_alt_cal;
    end
    assign cal_err_skew = (is_skew_cal_q & ~is_skew_cal) & ((cal_sm != CAL_DONE) ? 'b1 : 'b0);
    assign cal_err_alt = (is_alt_cal_q & ~is_alt_cal) & ((cal_sm != CAL_DONE) ? 'b1 : 'b0);
    
    always @(posedge rx_clk)
    begin
        if (srst_rx_n == 'b0 || is_cal == 1'b0)
        begin
            cal_done <= 'b0;
            cal_err_int <= 'b0;
        end
        else
        begin
            cal_done <= cal_done | ( (cal_sm == CAL_DONE) ? 'b1 : 'b0 );
            cal_err_int <= ( cal_err_int & ~ cal_done ) | ( (cal_sm == CAL_ERROR) ? 'b1 : 'b0 );
        end
    end

    assign cal_err_state = cal_err_int;



// synthesis translate_off

    logic chk_swap_alt;
    logic alt_is_swap_back;
    logic alt_center_read_resync;
    `ifdef SUPPORT_ALT_SWAP
        assign chk_swap_alt = (alt_cmp_result == ALT_PASS ? 'b1 : 'b0) & ( alt_is_swap_back ^ (|pass_sel_even_swap & |pass_sel_odd_swap));
    `else
        assign chk_swap_alt = 'b0;
    `endif

    always @(posedge rx_clk)
        if(cal_sm == READ_FIRST && (is_alt_cal & del_ch) == 1'b1)
            alt_is_swap_back <= (data == exp_data) ? 1'b0 : 1'b1;  
        else if(chk_swap_alt == 'b1)
            alt_is_swap_back <= ~alt_is_swap_back;

    always @(posedge chk_swap_alt)
    begin
        $display("Check ALT_SWAP [%1d.%1d] : alt swap switch from %b to %b @ %t", link_id, LANE_ID, alt_is_swap_back, ~alt_is_swap_back, $realtime);
    end

    always @(posedge rx_clk)
      begin
	 if (srst_rx_n === 1'b1)
	   begin
              if(alt_center_read_resync=='b0 && cal_sm == ALT_READ_CENTER_RESYNC)
		$display("Check ALT_CENTER_RESYNC [%1d.%1d] : resync required @ %t", link_id, LANE_ID,  $realtime);
              else if (alt_center_read_resync=='b1 && cal_sm == ALT_END)
		$display("Check ALT_CENTER_RESYNC [%1d.%1d] : resync acquired @ %t", link_id, LANE_ID,  $realtime);
              else if (alt_center_read_resync=='b1 && cal_sm != ALT_READ_CENTER_RESYNC)
		$display("Check ALT_CENTER_RESYNC [%1d.%1d] : ERROR in resync @ %t", link_id, LANE_ID,  $realtime);
	   end
         alt_center_read_resync <= cal_sm == ALT_READ_CENTER_RESYNC ? 'b1 : 'b0;
      end



`ifdef RTL_SIM_CAL_DEBUG

    assign cal_err = cal_err_skew | cal_err_skew;

    always @(cal_err_int)
    begin
        if(cal_err_int == 'b1)
            $display("Cal info cal_err asserted on link.lane %1d.%1d @ %t", link_id, LANE_ID, $realtime);
        if(cal_err_int == 'b0)
            $display("Cal info cal_err cleared on link.lane %1d.%1d @ %t", link_id, LANE_ID, $realtime);
    end
    
    always @(posedge cal_err) 
        $display("Cal ERROR (cal did not complete) on link.lane %1d.%1d @ %t", link_id, LANE_ID, $realtime);
`endif
// synthesis translate_on


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oKM+mDL+jZuSLfWMKlGhmH5QR38d0BxKHbbIh6icxF64owqG4FCX7zVRM4M0X5fGW+B0QOQnZZ0M7SsIxNHBUCH4cGZt1cpWb8+jDf+RUWqHDVd47I3PjcC19F+zd30YfRj/nurDum+ocZtWpto9DlXyiXiDcykVDyC7zhF3LcRXPnu7K+nphAEiR40DODubGuAmv1wvxya+ss+pAXyH4YaDODA886WW658VYOY96yPv0/EGIBsbIFmkB8edbpH/5xBaDtussyH21RJdtAeLiEP1L5De+Vw0TeaW4DzUiHQugyYKyk+R9CrZKmqBAns4XXesllf+jhuIKRAZ2rrM0/o79QxhU5UeGvSGjkZrSoDbqzMzs0H7qjbxvmd7r267sFQFQTF4GI+0yIr4TeLnXBG6qTztID8SySdeJjwPXdxWSUyt7ziNdqmTawDsIOMiU1TKLnvSIoey6IUuoz0okk64p2iOGpf65UAjErTx6aYSQF3sR8NyGECGgwYg4R7z//EC8XgdtoaHNPwNr8j8pfxEzVm9rfrZV+mZo8CeKYEQ7R+hyqvB1+xWzYOgluIyrNm7XbqIIJjV8Spt60lnPRd+7JQsr7Ug1dDHbV8ev+qEJezPfRE1LVrSjLW2Fy+CY0/sBsHDJhAapswbtgznWs0geV+bCoEGMZtCoVJIZyEdjgyCbMgrnDhRKPo6fK9uHgBE7aHlnNnuCu1duL/61HG5cnv26g8Re+tYQzbqdOG14OUWI8agoq6ao1/vQ6dnS8thpMyzxfLnTRL+y0b4fJZ"
`endif