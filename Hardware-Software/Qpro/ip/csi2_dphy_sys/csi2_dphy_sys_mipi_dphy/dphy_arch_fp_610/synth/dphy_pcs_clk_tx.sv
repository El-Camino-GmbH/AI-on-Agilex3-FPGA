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

module dphy_pcx_clk_tx # (
	parameter IO_CONVERT_RATIO = 16,     
	parameter CONTINUOUS_CLK = 0,                                  
    parameter NUM_LANES = 4,
	parameter VCO_FREQ_MULT = 1     
   ) (
        input  wire             arst_fr_n,
        input  wire             fr_clk,          
        input  wire             fr_clk_1024,
        input  wire             core_clk,
        input  wire             srst_fr_n,
        input  wire             enable,
        output logic            srst_esc_n,
        input wire [7:0]        t_init,   
        input wire [7:0]        t_lpx,   
        input wire [7:0]        t_clk_prepare,
        input wire [7:0]        t_clk_zero,
        input wire [7:0]        t_clk_pre,
        input wire [7:0]        t_clk_trail,
        input wire [7:0]        t_clk_post,
        input wire [7:0]        t_wake,     
        input wire [7:0]        t_hs_exit,   
        input wire [7:0]        t_lp_exit,   
        input wire              dlanes_hs_done,
        output logic            clk_pre_done,
        output logic            esc_pulse,
        output logic            init_done,
        input wire              auto_cal_done,
        input wire              auto_cal,
        output logic            clk_in_stop,
        dphy_io_if              dphy_port,        
        dphy_dbg_clane          dphy_dbg_clane, 
        ppi_if                  ppi_tx
    );
    
    logic                           tx_clk_lp_p;
    logic                           tx_clk_lp_n;
    logic                           tx_clk_lp_hs_b;
    logic [IO_CONVERT_RATIO-1:0]    tx_clk_data;
    logic                           force_stop;
    logic                           hs_enter;
    logic                           ulps_enter, ulps_enter_fr;
    logic                           ulps_exit, ulps_exit_fr;
    logic                           in_ulps;
    logic in_stop;
    logic in_prepare;
    logic in_zero;
    logic in_pre;
    logic in_active;
    logic in_trail;
    logic in_post;
    logic in_wake;
    logic in_hs_exit;
    logic in_lp_exit;
    logic prepare_done;
    logic zero_done;
    logic pre_done;
    logic trail_done;
    logic wake_done;
    logic hs_exit_done;
    logic lp_exit_done;
    logic post_done;
    logic e_post_done;
    logic dlanes_hs_done_q;
    logic dlanes_hs_start;
    logic dlanes_hs_stop;

    logic timer_out;
    logic timer_out_ext;
    

    logic [7:0] lpx_cnt;
    logic [7:0] lpx_cnt_p1;
    logic esc_clk_trans;
    logic esc_clk_pedge;
    logic esc_clk_nedge;
    logic esc_clk;
    logic esc_clk_tog;
    logic esc_clk_fr_q;
    logic tx_word_clk;
    assign tx_word_clk = core_clk;

    
    always @(posedge fr_clk)
        if ( ( srst_fr_n & enable ) == 1'b0)
        begin
            lpx_cnt <= 'h0;
            esc_clk <= 1'b0;
        end
        else
        begin
            lpx_cnt <= esc_clk_pedge == 1'b1 ? 'h0 : lpx_cnt_p1;
            esc_clk <= ( esc_clk_pedge | esc_clk ) & ~esc_clk_nedge;
        end

    logic lpx_cnt_ovf;
   
    assign {lpx_cnt_ovf, lpx_cnt_p1[7:0]} = lpx_cnt + 1;
    assign esc_clk_trans = esc_clk_pedge | esc_clk_nedge;
    
    assign esc_clk_pedge = lpx_cnt_p1 == t_lpx ? 1'b1 : 1'b0;
    assign esc_clk_nedge = lpx_cnt_p1[6:0] == t_lpx[7:1] ? 1'b1 : 1'b0;

    
    
    /*
    logic srst_tog_r;
    logic srst_tog_a;
    always @(posedge fr_clk or negedge arst_fr_n)
    begin
        if(arst_fr_n == 1'b0)
            srst_tog_r <= 1'b0;
        else
            srst_tog_r <= srst_tog_r ^ srst_tog_a ? srst_tog_r : (srst_fr_n & enable);
    end
    
    always @(posedge esc_clk or negedge arst_fr_n)
        if(arst_fr_n == 1'b0)
            srst_tog_a <= 1'b0;
        else
            srst_tog_a <= srst_tog_r;
    
    always @(posedge esc_clk)
        srst_esc_n <= srst_tog_a;
    
    always @(posedge esc_clk)
        if ( srst_esc_n == 1'b0)
            esc_clk_tog <= 1'b0;
        else
            esc_clk_tog <= ~esc_clk_tog;

    always @(posedge fr_clk)
    begin
        esc_clk_fr_q <= esc_clk_tog;
    end
    */
    assign esc_pulse = esc_clk_pedge;
    logic arst_esc_n;
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) esc_rst_sync (
                                .clk(esc_clk), .reset_n(arst_fr_n), .din(1'b1), .dout(arst_esc_n) );
    always @(posedge esc_clk)
        srst_esc_n <= arst_esc_n;

    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) ulps_exit_fr_sync (
                                .clk(fr_clk), .reset_n(srst_fr_n), .din(ulps_exit), .dout(ulps_exit_fr) );
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) ulps_enter_fr_sync (
                                .clk(fr_clk), .reset_n(srst_fr_n), .din(ulps_enter), .dout(ulps_enter_fr) );
    logic force_stop_fr;
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) force_stop_fr_sync (
                                .clk(fr_clk), .reset_n(srst_fr_n), .din(force_stop), .dout(force_stop_fr) );
   
    logic in_ulps_esc;
    altera_std_synchronizer_nocut #(.depth(3), .rst_value(0)) in_ulps_esc_sync (
                                .clk(esc_clk), .reset_n(srst_esc_n), .din(in_ulps), .dout(in_ulps_esc) );

    assign dphy_port.tx_clk_lp_hs_b =           tx_clk_lp_hs_b;
    assign dphy_port.tx_clk_lp_p =              tx_clk_lp_p;
    assign dphy_port.tx_clk_lp_n =              tx_clk_lp_n;
    assign dphy_port.tx_clk_data =              tx_clk_data;


    logic clock_post_pulse;
    assign dphy_port.rx_data_read_en = CONTINUOUS_CLK == 1'b0 ? 4'h0 : { 4 { ~clock_post_pulse } };

    assign ppi_tx.TxWordClkHS = { (NUM_LANES+1) { tx_word_clk } }; 
    assign ppi_tx.TxClkEsc = { (NUM_LANES+1) { esc_clk } };        
    assign ppi_tx.TxReadyEsc[NUM_LANES] = 1'b0;
    
    assign ppi_tx.TxReadyHS[NUM_LANES] = auto_cal_done & in_active;                
    assign ppi_tx.Stopstate[NUM_LANES] = in_stop;
    assign ppi_tx.Direction[NUM_LANES] = 1'b0;
    assign ppi_tx.TxHSIdleClkReadyHS[NUM_LANES] = 1'b0;
    assign force_stop = ppi_tx.ForceTxStopmode[NUM_LANES];
    assign ulps_enter = auto_cal_done & ppi_tx.TxUlpsClk[NUM_LANES];
    assign ulps_exit = ppi_tx.TxUlpsExit[NUM_LANES];
    assign ppi_tx.UlpsActiveNot[NUM_LANES] = ~in_ulps_esc;
    assign hs_enter = CONTINUOUS_CLK == 1'b0 ? (auto_cal_done ? ppi_tx.TxRequestHS[NUM_LANES] : auto_cal) : init_done;   

    typedef enum  {     INIT,
                        STOP,
                        HS_REQ,
                        BRIDGE,
                        ZERO,
                        ACTIVE,
                        TRAIL,
                        HS_EXIT,
                        ULPS_REQ,
                        ULPS,
                        ULPS_EXIT,
                        LP_EXIT   
                   } tx_clk_sm_t;
    tx_clk_sm_t cstate;
    tx_clk_sm_t nstate;

    always @(posedge fr_clk)
        if ( (srst_fr_n & enable & init_done) == 1'b0)
            cstate <= INIT;
        else if (force_stop_fr)
            cstate <= STOP;
        else
            cstate <= nstate;

    always @(*)
        case (cstate)
            INIT :      nstate <= init_done ? STOP : cstate;
            STOP :      nstate <= esc_pulse & ulps_enter_fr ? ULPS_REQ : 
                                  esc_pulse & hs_enter ? HS_REQ : cstate;
            HS_REQ :    nstate <= esc_pulse ? BRIDGE : cstate;
            BRIDGE :    nstate <= prepare_done ? ZERO : cstate;
            ZERO :      nstate <= zero_done ? ACTIVE : cstate;
            ACTIVE :    nstate <= ~hs_enter & e_post_done ? TRAIL : cstate;
            TRAIL :     nstate <= trail_done ? HS_EXIT : cstate;
            HS_EXIT :   nstate <= hs_exit_done ? STOP : cstate;
            ULPS_REQ :  nstate <= esc_pulse ? ULPS : cstate;
            ULPS :      nstate <= esc_pulse & ulps_exit_fr ? ULPS_EXIT : cstate;
            ULPS_EXIT : nstate <= esc_pulse & ~ulps_enter_fr & wake_done ? LP_EXIT : cstate;
            LP_EXIT :   nstate <= lp_exit_done ? STOP : cstate;
            default :   nstate <= STOP;
        endcase

    assign tx_clk_lp_hs_b = enable && (( cstate == ZERO        || 
                              cstate == ACTIVE      || 
                              cstate == TRAIL) ? 1'b0 : 1'b1 );
    assign tx_clk_lp_p =    enable && (( cstate == HS_REQ      || 
                              cstate == BRIDGE      || 
                              cstate == ULPS        || 
                              cstate == ZERO        || 
                              cstate == ACTIVE      || 
                              cstate == TRAIL) ? 1'b0 : 1'b1 );
    assign tx_clk_lp_n =    enable && (( cstate == ULPS_REQ    || 
                              cstate == ULPS_EXIT   || 
                              cstate == BRIDGE      || 
                              cstate == ULPS        || 
                              cstate == ZERO        || 
                              cstate == ACTIVE      || 
                              cstate == TRAIL) ? 1'b0 : 1'b1 );

    assign in_stop = cstate == STOP;
    assign clk_in_stop = in_stop;
    assign in_prepare = cstate == BRIDGE ? 1'b1 : 1'b0;
    assign in_zero = cstate == ZERO ? 1'b1 : 1'b0;
    assign in_active = cstate == ACTIVE ? 1'b1 : 1'b0;
    assign in_pre = in_active & ~clk_pre_done;
    assign in_trail = cstate == TRAIL ? 1'b1 : 1'b0;
    assign in_ulps = cstate == ULPS ? 1'b1 : 1'b0;
    assign in_wake = cstate == ULPS_EXIT ? 1'b1 : 1'b0;
    assign in_hs_exit = cstate == HS_EXIT ? 1'b1 : 1'b0;
    assign in_lp_exit = cstate == LP_EXIT ? 1'b1 : 1'b0;
    assign prepare_done = in_prepare & timer_out;
    assign zero_done = in_zero & timer_out;
    assign pre_done = in_pre & timer_out;
    assign trail_done = in_trail & timer_out;
    assign hs_exit_done = in_hs_exit & timer_out;
    assign lp_exit_done = in_lp_exit & timer_out;
    assign wake_done = in_wake & timer_out_ext;

    always @(posedge fr_clk)
        timer_out_ext <= timer_out | (~esc_pulse & timer_out_ext);
    
    always @(posedge fr_clk)
        dlanes_hs_done_q <= dlanes_hs_done;
    
    assign dlanes_hs_start = dlanes_hs_done_q & ~dlanes_hs_done;
    assign dlanes_hs_stop = ~dlanes_hs_done_q & dlanes_hs_done;
    
    
    
    always @(posedge fr_clk)
    begin
        if ( in_active == 1'b0 )
        begin
            in_post <= 1'b0;
            post_done <= 1'b1;
            clock_post_pulse <= 1'b0;
        end
        else
        begin
            in_post <= ( dlanes_hs_stop | in_post ) & ~timer_out; 
            post_done <= e_post_done;
            clock_post_pulse <= (in_post & timer_out) | ( dlanes_hs_done_q & ~in_post & fr_clk_1024 );
        end
    end

    assign e_post_done = (~dlanes_hs_start & post_done) | (in_post & timer_out);

    always @(posedge fr_clk)
    begin
        if ( in_stop == 1'b1 )
            clk_pre_done <= 1'b0;
        else 
            clk_pre_done <= (clk_pre_done | pre_done) & ~in_trail;
    end
    
    
     dphy_pcs_timing_tx timing_blk 
     (
        .fr_clk(fr_clk),
        .fr_clk_1024(fr_clk_1024),  
        .srst_fr_n(srst_fr_n),
        .enable(enable),
        .in_prepare(in_prepare),            
        .in_zero(in_zero),  
        .in_pre(in_pre),
        .in_trail(in_trail),
        .in_post(in_post),
        .in_wake(in_wake),
        .in_hs_exit(in_hs_exit),
        .in_lp_exit(in_lp_exit),
        .t_init(t_init),   
        .t_prepare(t_clk_prepare),
        .t_zero(t_clk_zero),
        .t_pre(t_clk_pre),
        .t_trail(t_clk_trail),
        .t_post(t_clk_post),
        .t_wake(t_wake),
        .t_hs_exit(t_hs_exit),   
        .t_lp_exit(t_lp_exit),   
        .init_done(init_done),
        .timer_out(timer_out)
     );
     
         
    if(IO_CONVERT_RATIO == 16)
    begin: tx_clk_pat
        localparam DATA_DIV8 = 16'h0ff0;
        localparam DATA_DIV4 = 16'h3c3c;
        localparam DATA_DIV2 = 16'h6666;
        localparam DATA_DIV1 = 16'h5555;
        localparam DATA_TRAIL8 = 16'h0000;
        localparam DATA_TRAIL4 = 16'h0000;
        localparam DATA_TRAIL2 = 16'h0000;
        localparam DATA_TRAIL1 = 16'h0000;
        logic [15:0]    tx_clk_data_hs;
        logic [15:0]    tx_clk_data_trail;

        assign tx_clk_data_hs =     VCO_FREQ_MULT == 2 ? DATA_DIV2 : 
                                    VCO_FREQ_MULT == 4 ? DATA_DIV4 :
                                    VCO_FREQ_MULT == 8 ? DATA_DIV8 : DATA_DIV1;
        assign tx_clk_data_trail =  VCO_FREQ_MULT == 2 ? DATA_TRAIL2 :
                                    VCO_FREQ_MULT == 4 ? DATA_TRAIL4 :
                                    VCO_FREQ_MULT == 8 ? DATA_TRAIL8 : DATA_TRAIL1;
        
        assign tx_clk_data =     { 16 {~in_zero}  } & 
                             ( ( { 16 {in_active} } & tx_clk_data_hs ) | ( { 16 {in_trail} } & tx_clk_data_trail ) );
                             
    end
    else
    begin: tx_clk_pat

        logic clk_word_odd;
        always @(posedge core_clk)
        begin
            if ( in_zero == 1'b1 )
                clk_word_odd <= 1'b0;
            else
                clk_word_odd <= in_active ^ clk_word_odd;
        end

        localparam DATA_DIV8_EVEN = 8'hf0;
        localparam DATA_DIV8_ODD = 8'h0f;
        localparam DATA_DIV4 = 8'h3c;
        localparam DATA_DIV2 = 8'h66;
        localparam DATA_DIV1 = 8'h55;
        localparam DATA_TRAIL8_EVEN = 8'h00;
        localparam DATA_TRAIL8_ODD = 8'hff;
        localparam DATA_TRAIL4 = 8'h00;
        localparam DATA_TRAIL2 = 8'h00;
        localparam DATA_TRAIL1 = 8'h00;
        logic [7:0]    tx_clk_data_hs;
        logic [7:0]    tx_clk_data_trail;

        assign tx_clk_data_hs =     VCO_FREQ_MULT == 2 ? DATA_DIV2 :
                                    VCO_FREQ_MULT == 4 ? DATA_DIV4 : 
                                    VCO_FREQ_MULT == 8 ? ( clk_word_odd ?  DATA_DIV8_ODD : DATA_DIV8_EVEN ) :
                                    DATA_DIV1;
        assign tx_clk_data_trail =  VCO_FREQ_MULT == 2 ? DATA_TRAIL2 :
                                    VCO_FREQ_MULT == 4 ? DATA_TRAIL4 :
                                    VCO_FREQ_MULT == 8 ? ( ~clk_word_odd ? DATA_TRAIL8_ODD : DATA_TRAIL8_EVEN ) :
                                    DATA_TRAIL1;
        
        assign tx_clk_data =     { 8 {~in_zero}  } & 
                             ( ( { 8 {in_active} } & tx_clk_data_hs ) | ( { 8 {in_trail} } & tx_clk_data_trail ) );


    end
         

endmodule 


`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oIV/1oH3/KFgjywg3CfruPHCoeL1+osHRAG8FM6BnAy6G/+9o3CiHAO5a2lxjibt4l4EwjRvKjIlARvmMLqk7tObmQus0H9eg6anJlDKJdWy917szH1dN2ug9EcUMKuKC5K5NoNboeg2GJhjm7yzX8L9W7aH4/lSUVk882Eskp8wm6hNRfsSLhnAuN4kCsrU6BPy0cGxZW/hUT+/tfSxNZcOIq0TDkvfXZexlwURCzAvTp/aYjpmSJfRFmHyflQMSwVrDq1Q41VBmgHFPSEMld+WAsYbuCGkKnPxcD0ZmKB5NiAuz2iBl1uxbDZlIoSkStfx+Allojqvh/OB9PCmz7c6VSSDNmrVr6IY9FVxbxVRk9PgslquE22B/+dTid84fP162P8kPD3ei3YgKjjRSon9bQv4JZ0V3VpS3ZghkF8kkLatr2VTowvvKkHYBHz9KbAYOphbapq9a8mEOnZz2WacgYYo089206P5lAzJsZx11DapwYgQaFHU0aHY43qnfXAMW+L+5+wdKqE4Z2EoDwW/xweli7OkPwWC3myabVm14c4pGyqKKaf4IEni0qBFg7HunUzvoQbRXllzCkg6AyeLbzJuwth7VO2Pzvxq4wmJKscJqePymaDcRfo/RoCUKXiae1HRFMyZS/DTpuGitMtRf4MTe+DeijGm6p9AT24STSaEdizCTkqGVk1LLWhMdiiWMPC+23W9UtBxCwWOwZpCQJYJcT+2Yz305lo9YnKTTyMwxsO/XyLU5Q+7cMAqGyDsWlgEgHZRWyq5xpQSp25"
`endif