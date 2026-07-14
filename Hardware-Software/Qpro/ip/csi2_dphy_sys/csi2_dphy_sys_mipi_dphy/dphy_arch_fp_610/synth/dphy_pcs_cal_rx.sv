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


module dphy_pcs_cal_rx #(
        WIDTH = 8, 
        WIDTH_C2P = 8, 
        LOOKAHEAD = 1,                        
        LANE_ID = 0,
        RX_PCS_DATA_HYPERPIPE_DEPTH = 0,
        ALT_CAL_EN = 0                        
        )
(
    input                       rx_clk,
    input                       arst_rx_n,
    input                       srst_rx_n,
    input                       fr_clk,
    input                       arst_fr_n,
    input                       srst_fr_n,
    input                       recalibrate,            
    input                       is_skew_cal,
    input                       is_alt_cal,
    input  [8:0]                prbs_init_val,
    input [WIDTH-1:0]           data,
    input                       data_valid,
    output logic [15:0]         data_deskew_cntrl,
    output                      alt_cal_valid,
    output logic                cal_done,
    output logic                cal_err,
    output logic                cal_done_skew, 
    output logic                cal_done_alt,
    output logic                cal_err_skew,
    output logic                cal_err_skew_per,
    output logic                cal_err_alt,

    output                      in_cal,
    output                      dqs_del_up_req,
    input                       dqs_del_up_ack,
    input                       alt_skip_en,

    input                       delay_val_update_p,
    input                       manual_skew_en,
    input                       [6:0] manual_skew_val,
    output logic [7:0]          cal_w_start,
    output logic [7:0]          cal_w_end,
    output logic [7:0]          cal_w_start_alt,
    output logic [7:0]          cal_w_end_alt,
    output logic [6:0]          cal_delay_val


);
    localparam ALL_5 = (WIDTH== 8) ? 'h55 : 'h5555;
    localparam ALL_A = (WIDTH== 8) ? 'haa : 'haaaa;
    localparam CAL_DELAY_CHANGE_PIPE = 1;
    localparam DELAY_CHANGE_PIPE = CAL_DELAY_CHANGE_PIPE;
    localparam CAL_IP_RX_PIPE_DEPTH = RX_PCS_DATA_HYPERPIPE_DEPTH + (WIDTH == 16 ? CAL_IP_RX_PIPE_DEPTH_16 : CAL_IP_RX_PIPE_DEPTH_8);
    localparam CAL_IP_RX_CYCLE_DURATION = WIDTH == 16 ? CAL_IP_RX_CYCLE_DURATION_16 : CAL_IP_RX_CYCLE_DURATION_8;
    localparam CAL_IP_RX_CYCLE_DURATION_ALT = WIDTH == 16 ? CAL_IP_RX_CYCLE_DURATION_ALT_16 : CAL_IP_RX_CYCLE_DURATION_ALT_8;
    localparam CAL_IP_FA_PIPE_DEPTH = WIDTH_C2P == 16 ? CAL_IP_FA_PIPE_DEPTH_16 : CAL_IP_FA_PIPE_DEPTH_8;
    
    logic del_up, del_dn;
    logic [4:0] del_off;
    logic del_ch, del_ch_q, del_up_q;
    logic [WIDTH-1:0] data_q;
    genvar j;


    logic [7:0] shadow_delay_reg;       
    logic [7:0] window_start;           
    logic [7:0] window_end;             ;             
    logic [7:0] skew_del_val[DELAY_CHANGE_PIPE-1:0];
    logic [7:0] skew_del_val_cmp;
    logic [7:0] e_skew_del_val_cmp;

    logic [7:0] window_start_delta_alt;           
    logic [7:0] window_end_delta_alt;             ;             

    
    logic [DELAY_CHANGE_PIPE-1:0] skew_del_send;
    logic [DELAY_CHANGE_PIPE-1:0] data_cmp_done;
    logic [DELAY_CHANGE_PIPE-1:0] skew_del_send_ptr;
    logic [DELAY_CHANGE_PIPE-1:0] skew_del_send_ptr_q;
    logic [DELAY_CHANGE_PIPE-1:0] data_cmp_done_ptr;
    logic [DELAY_CHANGE_PIPE-1:0] window_side;  
    logic [DELAY_CHANGE_PIPE-1:0] is_inc;       
    logic data_pipe_empty;
    logic data_pipe_full;
    logic is_window_start_cmp;
    logic is_inc_cmp;
    logic [CAL_IO_DESKEW_CTRL_REG_BITS-1:0] skew_ctrl;  
    int i;
    genvar m;
    
    logic skew_del_ch_req;
    logic skew_del_ch_req_fr;
    logic [CAL_IP_FA_PIPE_DEPTH-1:0] skew_del_ch_req_fr_pipe;
    logic skew_del_ch_ack_fr;
    logic skew_del_ch_ack;
    logic skew_del_ch_ack_fast;
    logic skew_del_ch_ack_fast_fr;
    logic [CAL_IP_RX_PIPE_DEPTH-1:0] skew_del_ch_ack_pipe;
    logic del_up_fr;
    logic [CAL_IO_DESKEW_CTRL_REG_BITS-1:0] del_reg_fr;
    logic is_cal;
    
    
    logic [7:0] rx_cntr;
    logic [7:0] rx_cntr_load_val;
    logic rx_cntr_load_en, rx_cntr_dec_en;
    logic skew_find_win_start_coarse, skew_find_win_start_fine;
    logic skew_del_ch_ack_pulse;
    logic is_window_start;

    logic                shadow_reset;
    logic                shadow_load_final_en;
    logic                shadow_load_from_start_en;
    logic                shadow_load_from_end_en;
    logic                window_start_load_en;
    logic                window_end_load_en;
    logic                window_start_inc_4;
    logic                window_end_dec_4;
    logic                window_end_inc_64;
    logic                window_end_splus_64;
    logic                window_end_sminus_1;
    logic                window_reset;
    
    logic                shadow_load_final_en_skew;
    logic                shadow_load_from_start_en_skew;
    logic                shadow_load_from_end_en_skew;
    logic                window_start_load_en_skew;
    logic                window_end_load_en_skew;
    logic                window_end_inc_64_skew;
    logic                window_end_splus_64_skew;
    logic                window_end_sminus_1_skew;
    
    logic                shadow_load_final_en_alt;
    logic                shadow_load_from_start_en_alt;
    logic                shadow_load_from_end_en_alt;
    logic                window_start_load_en_alt;
    logic                window_end_load_en_alt;
    logic                window_end_inc_64_alt;
    logic                window_end_splus_64_alt;
    logic                window_end_sminus_1_alt;

    logic               window_update_delta_en_sat;
    logic               window_update_delta_capped_en;
    logic               window_update_delta_en;
    logic               window_start_delta_inc4;
    logic               window_end_delta_dec4;
    logic               window_start_delta_use_inc4;
    logic               window_end_delta_use_dec4;

    logic del_ch_sent;
    logic cal_err_skew_set, cal_err_alt_set;
    logic cal_err_state;
    logic window_reset_alt;
    logic window_reset_skew;
    logic window_delta_valid;

    
    assign cal_w_start = window_start;
    assign cal_w_end = window_end;
    assign cal_w_start_alt = window_start_delta_alt;
    assign cal_w_end_alt = window_end_delta_alt;

   logic  dqs_del_up_req_rxclk;

   assign dqs_del_up_req_rxclk = skew_del_ch_req ^ skew_del_ch_ack_fast;

    dphy_pcs_cal_skew_rx #(
            .WIDTH (WIDTH), 
            .LANE_ID(LANE_ID),
            .ALT_CAL_EN(ALT_CAL_EN)
            ) skew_cal
    (
        .rx_clk(rx_clk),
        .arst_rx_n(arst_rx_n),
        .srst_rx_n(srst_rx_n),
        .fr_clk(fr_clk),
        .srst_fr_n(srst_fr_n),
        .is_skew_cal(is_skew_cal),
        .is_alt_cal(is_alt_cal),
        .data(data),
        .data_valid(data_valid),
        .prbs_init_val(prbs_init_val),
        .cal_done_skew(cal_done_skew), 
        .cal_done_alt(cal_done_alt),        
        .skew_del_ch_ack_pulse(skew_del_ch_ack_pulse),
        .is_window_start_cmp(is_window_start_cmp),
        .del_ch_sent(del_ch_sent),
        .data_pipe_full(data_pipe_full),
        .data_pipe_empty(data_pipe_empty),
        .del_up(del_up),
        .del_dn(del_dn),
        .del_off(del_off),
        .is_window_start(is_window_start),
        .shadow_reset(shadow_reset),
        .shadow_load_final_en(shadow_load_final_en),
        .shadow_load_from_start_en(shadow_load_from_start_en),
        .shadow_load_from_end_en(shadow_load_from_end_en),
        .window_start_load_en(window_start_load_en),
        .window_end_load_en(window_end_load_en),
        .window_start_inc_4(window_start_inc_4),
        .window_end_dec_4(window_end_dec_4),
        .window_end_inc_64(window_end_inc_64),
        .window_end_sminus_1(window_end_sminus_1),
        .window_end_splus_64(window_end_splus_64),
        .window_update_delta_en(window_update_delta_en_sat),
        .window_reset(window_reset),
        .alt_skip_en(alt_skip_en),
        .cal_done(cal_done),
        .cal_err_state(cal_err_state),
        .cal_err_skew(cal_err_skew_set),
        .cal_err_alt(cal_err_alt_set),
	.dqs_del_up_req(dqs_del_up_req_rxclk)

    );

    always @(posedge rx_clk)
    begin
        if(srst_rx_n == 'b0)
	  begin
             window_update_delta_en <= 1'b0;
	     window_update_delta_capped_en <= 1'b0;
	  end
        else
	  begin
             window_update_delta_en <= window_update_delta_en_sat;
	     window_update_delta_capped_en <= window_update_delta_en;	     
	  end
    end   
   
    assign del_ch_sent = ~|rx_cntr &&  ~(skew_del_ch_req^skew_del_ch_ack_fast);
    assign is_cal = is_skew_cal | is_alt_cal;
    assign shadow_load_final_en_skew = is_skew_cal & shadow_load_final_en;
    assign shadow_load_final_en_alt = is_alt_cal & shadow_load_final_en;
    assign window_reset_skew =  is_skew_cal & window_reset;
    assign window_reset_alt = is_alt_cal & window_reset;
    assign shadow_load_from_start_en_skew = is_skew_cal & shadow_load_from_start_en;
    assign shadow_load_from_start_en_alt = is_alt_cal & shadow_load_from_start_en;
    assign shadow_load_from_end_en_skew = is_skew_cal & shadow_load_from_end_en;
    assign shadow_load_from_end_en_alt = is_alt_cal & shadow_load_from_end_en;
    assign window_start_load_en_skew = is_skew_cal & window_start_load_en;
    assign window_start_load_en_alt = is_alt_cal & window_start_load_en;
    assign window_end_load_en_skew = is_skew_cal & window_end_load_en;
    assign window_end_load_en_alt = is_alt_cal & window_end_load_en;
    assign window_end_inc_64_skew = is_skew_cal & window_end_inc_64;
    assign window_end_inc_64_alt = is_alt_cal & window_end_inc_64;
    assign window_end_splus_64_skew = is_skew_cal & window_end_splus_64;
    assign window_end_splus_64_alt = is_alt_cal & window_end_splus_64;
    assign window_end_sminus_1_skew = is_skew_cal & window_end_sminus_1;
    assign window_end_sminus_1_alt = is_alt_cal & window_end_sminus_1;

    assign window_start_load_en_delta = window_start_load_en & cal_done_alt;
    assign window_end_load_en_delta = window_end_load_en & cal_done_alt;
    assign window_start_delta_inc_4 = window_start_inc_4 & cal_done_alt;
    assign window_end_delta_dec_4 = window_end_dec_4 & cal_done_alt;

    assign del_ch = del_up | del_dn;
    
    logic cal_err_skew_clr;
    logic cal_err_skew_per_clr;
    logic cal_err_alt_clr;
    logic recal_rx;
    
   logic  recalibrate_rst;
   
    altera_std_synchronizer_nocut#(.depth(3), .rst_value(1)) clr_rx_cal_reg_ctrl_cal_reset_cdc (.clk(rx_clk), .reset_n(~recalibrate), .din(1'b0), .dout(recalibrate_rst));
   
    always @(posedge rx_clk or posedge recalibrate_rst)
        if(recalibrate_rst == 1'b1)
            recal_rx <= 1'b1;
        else
            recal_rx <= 1'b0;
 
    
    assign cal_err_skew_clr = recal_rx;
    assign cal_err_skew_per_clr = recal_rx;
    assign cal_err_alt_clr = recal_rx;
    
    always @(posedge rx_clk or negedge arst_rx_n)
    begin
        if(arst_rx_n == 'b0)
        begin
            cal_done_skew <= 'b0;
            cal_done_alt <= 'b0;
            cal_err_skew <= 1'b0;
            cal_err_skew_per <= 1'b0;
            cal_err_alt <= 1'b0;
        end
        else    
        begin
            cal_done_skew <= (is_skew_cal & cal_done) | (cal_done_skew & ~recal_rx);
            cal_done_alt <= (is_alt_cal & cal_done) | (cal_done_alt & ~recal_rx);
            cal_err_skew <= (~cal_done_skew & cal_err_skew_set) | (cal_err_skew & ~cal_err_skew_clr);
            cal_err_skew_per <= (cal_done_skew & cal_err_skew_set) | (cal_err_skew_per & ~cal_err_skew_per_clr);
            cal_err_alt <= (cal_err_alt_set) | (cal_err_alt & ~cal_err_alt_clr);
        end
    end

    always @(posedge rx_clk)
    begin
        if(srst_rx_n == 'b0)
            window_delta_valid <= 'b0;
        else    
            window_delta_valid <= (is_alt_cal & window_update_delta_en) | (window_delta_valid & ~recal_rx);
    end

    
    assign cal_err = cal_err_skew | cal_err_skew_per | cal_err_alt;
    
    assign alt_cal_valid = cal_done_skew & ~cal_done_alt;
    
    always @(posedge rx_clk)
    begin
        if(srst_rx_n == 1'b0 || window_reset_skew == 'b1)
            window_start <= 'h0;
        else
            window_start <= window_start_load_en_skew == 'b1 ? skew_del_val_cmp :
                            window_start_inc_4 == 'b1 ? window_start + 4'h4 : window_start;
    end

    always @(posedge rx_clk)
    begin
        if(srst_rx_n == 1'b0 ||  window_reset_alt == 'b1)
            window_start_delta_alt <= 'h0;
        else
            window_start_delta_alt <= window_start_load_en_alt == 'b1 ? skew_del_val_cmp :
				window_update_delta_en_sat == 1'b1 ? ( window_start_delta_alt - window_start ) :
                                window_update_delta_en == 1'b1 ? (window_start_delta_alt[7] ? 8'd0 : window_start_delta_alt) :
                                window_start_delta_alt;
    end


    always @(posedge rx_clk)
    begin
        if(srst_rx_n == 1'b0)
            window_end <= 'h0;
       else
            case( {window_reset_skew, window_end_load_en_skew, window_end_dec_4, window_end_inc_64_skew, window_end_splus_64_skew, window_end_sminus_1_skew } )
            6'b100000: window_end <='d63;
            6'b010000: window_end <= skew_del_val_cmp;
            6'b001000: window_end <= window_end - 4'h4;
            6'b000100: window_end <= window_end + 8'd64;
            6'b000010: window_end <= skew_del_val_cmp + 8'd64;
            6'b000001: window_end <= skew_del_val_cmp - 8'b1;
            default:
                window_end <= window_end;
            endcase
    end

    always @(posedge rx_clk)
    begin
        if(srst_rx_n == 1'b0)
            window_end_delta_alt <= 8'h0;
       else
            case( {window_reset_alt, window_end_load_en_alt, window_end_inc_64_alt, window_end_splus_64_alt, window_end_sminus_1_alt, window_update_delta_en_sat, window_update_delta_en } )
            7'b1000000: window_end_delta_alt <= 8'h0;
            7'b0100000: window_end_delta_alt <= skew_del_val_cmp;
            7'b0010000: window_end_delta_alt <= window_end_delta_alt + 8'd64;
            7'b0001000: window_end_delta_alt <= skew_del_val_cmp + 8'd64;
            7'b0000100: window_end_delta_alt <= skew_del_val_cmp - 8'b1;          
            7'b0000010: window_end_delta_alt <= window_end_delta_alt - window_end ;
	    7'b0000001: window_end_delta_alt <= ~window_end_delta_alt[7]  ? 8'd0 :  window_end_delta_alt;	      
            default:
                window_end_delta_alt <= window_end_delta_alt;
            endcase
    end


    always @(posedge rx_clk)
    begin
        if(srst_rx_n == 1'b0 || shadow_reset ==1'b1)
            shadow_delay_reg <= 8'h0;
        else if( ( del_up ^ del_dn) == 'b1)
            shadow_delay_reg <= del_up ? ( shadow_delay_reg + {1'b0, del_off} ) :
                                ( shadow_delay_reg - {1'b0, del_off} );
        else
            case( {shadow_load_from_start_en, shadow_load_from_end_en, (shadow_load_final_en || window_update_delta_capped_en)} )
            3'b100: shadow_delay_reg <=  window_start;
            3'b010: shadow_delay_reg <=  window_end;
            3'b001: begin
                    if(window_delta_valid == 'b1)
                        shadow_delay_reg <=( ( {1'b0, window_start} + {window_start_delta_alt[CAL_IO_DESKEW_CTRL_REG_BITS-2], window_start_delta_alt } ) +
                                            ( {1'b0, window_end} + {window_end_delta_alt[CAL_IO_DESKEW_CTRL_REG_BITS-2], window_end_delta_alt } ) ) >> 1;
                    else
                        shadow_delay_reg <=( {1'b0, window_start} + {1'b0, window_end}  ) >> 1;                        
                    end
            default:
                shadow_delay_reg <= shadow_delay_reg;
            endcase
    end
    

    always @(posedge rx_clk)
    begin
        if(is_cal == 1'b0)
        begin
            skew_del_send <= {DELAY_CHANGE_PIPE{1'b0}};
            skew_del_ch_ack_pipe <= {CAL_IP_RX_PIPE_DEPTH{1'b0}};
            data_cmp_done <= {DELAY_CHANGE_PIPE{1'b0}};
            skew_del_send_ptr <= { { ( DELAY_CHANGE_PIPE - 1) {1'b0} } , 1'b1};
            data_cmp_done_ptr <= { { ( DELAY_CHANGE_PIPE - 1) {1'b0} } , 1'b1};
        end
        else
        begin
            skew_del_send <= skew_del_send ^ ( {DELAY_CHANGE_PIPE{del_ch}} & skew_del_send_ptr);
            skew_del_ch_ack_pipe <= {skew_del_ch_ack_pipe[CAL_IP_RX_PIPE_DEPTH-2:0], skew_del_ch_ack};
            data_cmp_done <= data_cmp_done ^ ( {DELAY_CHANGE_PIPE{skew_del_ch_ack_pulse}} & data_cmp_done_ptr);
            if(DELAY_CHANGE_PIPE>1)
            begin
                skew_del_send_ptr <= del_ch == 1'b1 ? { skew_del_send_ptr[DELAY_CHANGE_PIPE-2:0], skew_del_send_ptr[DELAY_CHANGE_PIPE-1]} : skew_del_send_ptr;
                data_cmp_done_ptr <= (skew_del_ch_ack_pulse) == 1'b1 ? { data_cmp_done_ptr[DELAY_CHANGE_PIPE-2:0], data_cmp_done_ptr[DELAY_CHANGE_PIPE-1]} : data_cmp_done_ptr;
            end
            else
            begin
                skew_del_send_ptr <= del_ch == 1'b1 ? {skew_del_send_ptr[DELAY_CHANGE_PIPE-1]} : skew_del_send_ptr;
                data_cmp_done_ptr <= (skew_del_ch_ack_pulse) == 1'b1 ? {data_cmp_done_ptr[DELAY_CHANGE_PIPE-1]} : data_cmp_done_ptr;
            end
        end
    end
    
    assign data_pipe_full  =  &(skew_del_send ^ data_cmp_done);
    assign data_pipe_empty = ~|(skew_del_send ^ data_cmp_done);
    assign skew_del_ch_ack_pulse = (skew_del_ch_ack_pipe[CAL_IP_RX_PIPE_DEPTH-1] ^ skew_del_ch_ack_pipe[CAL_IP_RX_PIPE_DEPTH-2]);

    always @(posedge rx_clk)
    begin
        if(is_cal == 1'b0)
        begin
            skew_del_ch_req <= 1'b0;
        end
        else
        begin
            skew_del_ch_req <= del_ch ^ skew_del_ch_req;
        end
    end
    
    always @(posedge rx_clk)
    begin
        if(is_cal== 1'b0)
        begin
            skew_del_val_cmp <= 8'h0;
        end
        else
        begin
            if ( skew_del_ch_ack_pulse == 'b1 )
            begin
                for(i=0; i< DELAY_CHANGE_PIPE; i++)
                    if(data_cmp_done_ptr[i] == 'b1)
                    begin
                        skew_del_val_cmp <= skew_del_val[i];
                        is_window_start_cmp <= window_side[i];
                        is_inc_cmp <= is_inc[i];
                    end
            end
            else
            begin
                skew_del_val_cmp <= skew_del_val_cmp;
                is_window_start_cmp <= is_window_start_cmp;
                is_inc_cmp <= is_inc_cmp;
            end
        end
    end
    

    always @(posedge rx_clk)
    begin
        del_ch_q <= del_ch;
        skew_del_send_ptr_q <= skew_del_send_ptr;
        del_up_q <= del_up;
    end
    
    assign skew_ctrl = { 1'b0, shadow_delay_reg};

    always @(posedge rx_clk)
    begin
        for(i=0; i< DELAY_CHANGE_PIPE; i++)
        begin
                skew_del_val[i] <= (skew_del_send_ptr_q[i] & del_ch_q) == 'b1 ? shadow_delay_reg : skew_del_val[i];      
                window_side[i] <= (skew_del_send_ptr_q[i] & del_ch_q) == 'b1 ? is_window_start : window_side[i];
                is_inc[i] <= (skew_del_send_ptr_q[i] & del_ch_q) == 'b1 ? del_up_q : is_inc[i];
        end
    end
    
    assign rx_cntr_load_en = is_cal ? del_ch : 1'b0;
    assign rx_cntr_dec_en = is_cal ? 1'b1 : 1'b0;
    assign rx_cntr_load_val = is_alt_cal ? CAL_IP_RX_CYCLE_DURATION_ALT : CAL_IP_RX_CYCLE_DURATION;
    
    always @(posedge rx_clk)
    begin
        if(is_cal == 1'b0)
            rx_cntr <= 8'h0;
        else
            if(rx_cntr_load_en)
                rx_cntr <= rx_cntr_load_val;
            else
                rx_cntr <= |rx_cntr ? rx_cntr - rx_cntr_dec_en : rx_cntr;
    end

    logic in_cal_masked;
    always @(posedge rx_clk or negedge arst_rx_n)
        if(arst_rx_n == 1'b0)
            in_cal_masked <= 1'b0;
        else
            in_cal_masked <= is_cal & ~cal_done & ~cal_err_state;   


    altera_std_synchronizer_nocut #(.depth(3)) skew_del_send_sync (fr_clk, in_cal, skew_del_ch_req, skew_del_ch_req_fr);
    altera_std_synchronizer_nocut #(.depth(3)) skew_del_ack_sync (rx_clk, arst_rx_n, skew_del_ch_ack_fr, skew_del_ch_ack);
    altera_std_synchronizer_nocut #(.depth(3)) skew_del_ack_fast_sync (rx_clk, arst_rx_n, skew_del_ch_ack_fast_fr, skew_del_ch_ack_fast);
    altera_std_synchronizer_nocut #(.depth(3)) in_cal_sync (fr_clk, srst_fr_n, in_cal_masked, in_cal);


    always @(posedge fr_clk)
    begin
        if(srst_fr_n & in_cal == 1'b0)
        begin
            skew_del_ch_req_fr_pipe <= {CAL_IP_FA_PIPE_DEPTH{1'b0}};
            skew_del_ch_ack_fr <= {CAL_IP_FA_PIPE_DEPTH{1'b0}};
            skew_del_ch_ack_fast_fr <= 1'b0;
        end
        else
        begin
            skew_del_ch_req_fr_pipe <= {skew_del_ch_req_fr_pipe[CAL_IP_FA_PIPE_DEPTH-2:0], skew_del_ch_ack_fast_fr};
            skew_del_ch_ack_fr <= (skew_del_ch_req_fr_pipe[CAL_IP_FA_PIPE_DEPTH-1] ^ skew_del_ch_req_fr_pipe[CAL_IP_FA_PIPE_DEPTH-2]) === 'b1 ? ~skew_del_ch_ack_fr : skew_del_ch_ack_fr ;
            skew_del_ch_ack_fast_fr <= (dqs_del_up_req & dqs_del_up_ack) ^ skew_del_ch_ack_fast_fr;
        end  
    end

    assign dqs_del_up_req = skew_del_ch_req_fr ^ skew_del_ch_ack_fast_fr;
    
    
    logic del_up_fr_q;
    logic [15:0] data_deskew_cntrl_int;
    always @(posedge fr_clk or negedge arst_fr_n)
    begin
        if(arst_fr_n == 1'b0)
            del_reg_fr <= {CAL_IO_DESKEW_CTRL_REG_BITS{1'b0}};
        else if(delay_val_update_p | (dqs_del_up_req & dqs_del_up_ack) )
            del_reg_fr <=  (manual_skew_en == 1'b1 ? manual_skew_val : skew_ctrl[CAL_IO_DESKEW_CTRL_REG_BITS-1:0]);
    end

    assign cal_delay_val = del_reg_fr[6:0];

    always @(posedge fr_clk)
    begin
        if(srst_fr_n == 1'b0)
        begin
            del_up_fr <= 1'b0;
            del_up_fr_q <= 1'b0;
        end
        else
        begin
            del_up_fr <= (in_cal & dqs_del_up_req & dqs_del_up_ack) | delay_val_update_p ;
            del_up_fr_q <= WIDTH_C2P == 8 ? del_up_fr : 1'b0;
        end
    end

    assign data_deskew_cntrl_int = { 1'b1 , 6'h0, del_reg_fr[6], 1'b0, del_reg_fr[5:3], 1'b0, del_reg_fr[2:0] };
    
    if(WIDTH_C2P==16)
        assign data_deskew_cntrl = del_up_fr == 1'b1 ? data_deskew_cntrl_int : 16'h0;
    else
    begin
        assign data_deskew_cntrl[15:12] = 4'h0;
        assign data_deskew_cntrl[11:8] = 4'h0;
        assign data_deskew_cntrl[7:4] = del_up_fr == 1'b1 ? data_deskew_cntrl_int[7:4] : del_up_fr_q == 1'b1 ? data_deskew_cntrl_int[15:12] : 4'h0;
        assign data_deskew_cntrl[3:0] = del_up_fr == 1'b1 ? data_deskew_cntrl_int[3:0] : del_up_fr_q == 1'b1 ? data_deskew_cntrl_int[11:8] : 4'h0;
    end
   


// synthesis translate_off
    logic cal_err_mon;
    logic cal_done_q;
    int sk_cal_int;
    assign cal_err_mon = cal_err_skew | cal_err_skew_per | cal_err_alt;
    
    always @(posedge rx_clk)
    begin
        cal_done_q <= cal_done;
        if( is_skew_cal & cal_done & ~cal_done_q)
            sk_cal_int <= shadow_delay_reg;
        if (is_alt_cal & cal_done & ~cal_done_q)
        begin
            if(( shadow_delay_reg < sk_cal_int -2 || shadow_delay_reg > sk_cal_int +2) && (srst_rx_n === 1'b1))
                $display("Altcal ERROR: [lane %1d] : skew cal val = %3d, alt cal val = %3d @ %t", LANE_ID, sk_cal_int, shadow_delay_reg, $realtime);
        end
    end



// synthesis translate_on

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJl9KwJA+rMVmzMN1rDVVnbBX8GuZlvKJCCtH1rYwQfDB//sdoToo/3g45PcMARHuFdCCikXk5Cejqa2FvP26RIST9LyzGtAqT1fckRQkQ3d+T+qCNNXSGNJ+ZsfBq48ARwWWSzBW8H4IO3bwtXJHPNLjEnNbOL5rGQ0fKnyksBg8UYo25ymGqZq/nTgK/mpvcIZEakHe4qPP3wrSfh4OF6GlRs3L3BDzw4nyHE349G0FNNRQ7gWEHrGzFmRAw3kN/EZ9JnAldbYVQpO8dWXzEuP4YdUEj+TFSjayslSt0iNqnEp4ZavWR9/bVzQ5toeyW5Rgq9RgttDpWxXpiUHVDeXjsaOw2W9ZR6PBMjSRRU4ZgpmaR37OhdxogceFHvl69zB4NMjJhO7moNRdj6WmuL+LN9Ce1Oi7Xv7+/+W7tQKx9MqYsG9VW7Us7UvrUrVxec87d6dE3BZ25MnKVOppG89zak66orX92Qq2h1Wdgi3sMkf7QqJxh3ojdRBZnBgVu9nIoyUZX9AhFX2k3p/g/Seamdtqt8+mZQvqQTDvTeK1DgL52VulrkJyhYagHAxQR8Gcmv8Z8kC9WFv85AIgEnzamd0ecg3G8vZ5LvBY2ofXY9wO29iCyb+zg6kIbXkdZvt0GTLiwUaojaAQZyAXV0Uilv+1yXhNmtPFSFUUEN1LvsdR5lCFAlQiHPf3UoFB8c6Y5Vt2GaWuFVnV3GQVYEEqc5WHAHSyszLMz9A3nRvmklwFA+EphR5+mqnGVZa5WOGy6QTwCrThRcdgVLjAfO"
`endif