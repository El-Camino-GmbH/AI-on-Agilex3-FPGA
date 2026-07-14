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


module dphy_pcs_data_timing_rx # (
        parameter DIN_PIPE_DEPTH = 2
   ) (
        input wire   rx_clk, 
        input wire   srst_rx_n,
        input wire   arst_rx_n, 
        input wire   fr_clk,
        input wire   srst_fr_n, 
        input wire   fr_clk_1024,
        input wire   enable,
        input wire   is_ulps,
        input wire   ulps_wake_cnt, 
        
        input wire   lpctrl_hs_req_fr,
        input wire   lpctrl_hs_stop_fr,
        input wire   lpctrl_hs_diff_fr,
        input wire   lpctrl_lp_req_fr,
        input wire   fast_stop,

        input [7:0]  t_hs_settle, 
        input [7:0]  t_hs_skip, 
        input [7:0]  t_init,
        input [7:0]  t_wake_ulps,

        output logic ulps_wake_done,
        output logic init_done,
        output logic din_valid           

    );
    
    localparam FR_TIMER_WIDTH = 16;
    localparam DIN_VALID_PIPE_LEN = DIN_PIPE_DEPTH > 2 ? DIN_PIPE_DEPTH - 2 : 0;
    
   logic             fr_ld_timer;   
   logic [FR_TIMER_WIDTH-1:0] fr_ld_val; 
   logic                      fr_timer_out;
   
   logic                      din_valid_fr;
   logic                      din_valid_rx;
   logic                      din_valid_int;
   logic                      fast_stop_rx;
   logic                      enable_q;


   
   
   assign ulps_wake_done = is_ulps & fr_timer_out;
    
    always @(posedge fr_clk)
    begin
        if(srst_fr_n == 1'b0)
        begin
                din_valid_fr <= 1'b0;
                init_done <= 1'b0;
                enable_q <= 1'b0;
        end
        else 
        begin
            din_valid_fr <= (init_done & fr_timer_out) | (din_valid_fr & lpctrl_hs_diff_fr);
            init_done <= ( init_done & ( enable === 1'b1) )  | (fr_timer_out === 1'b1);
            enable_q <= enable;
        end
    end

    assign fr_timer_en = (init_done == 1'b0) || (ulps_wake_cnt == 1'b1) ? fr_clk_1024 : lpctrl_hs_diff_fr;
    assign fr_ld_timer = init_done == 1'b1 ? ( is_ulps == 1'b1 ? ~ulps_wake_cnt : lpctrl_hs_req_fr ) : lpctrl_hs_stop_fr === 1'b1 && enable_q === 1'b1 ? 1'b0 : 1'b1;
    assign fr_ld_val = init_done == 1'b1 ? (is_ulps == 1'b1 ? { 8'h0, t_wake_ulps } : { 8'h0, t_hs_settle }) : { 8'h0, t_init }  ;

    dphy_timer #(
        .WIDTH(FR_TIMER_WIDTH)
   ) rx_timer_fr
   (
        .clk(fr_clk),     
        .srst_n(srst_fr_n),     
        .timer_en(fr_timer_en), 
        .ld_timer(fr_ld_timer),   
        .ld_val(fr_ld_val), 
        .timer_out(fr_timer_out)   
    );

    altera_std_synchronizer_nocut # (
        .depth(3)
    ) cdc_sync_din_valid (
        .clk(rx_clk),
        .reset_n(arst_rx_n),
        .din(din_valid_fr),
        .dout(din_valid_rx)
    );

    altera_std_synchronizer_nocut # (
        .depth(3)
    ) cdc_sync_fast_stop (
        .clk(rx_clk),
        .reset_n(arst_rx_n),
        .din(fast_stop),
        .dout(fast_stop_rx)
    );

    assign din_valid_int = din_valid_rx & ~fast_stop_rx;
    hyperpipe # (.WIDTH(1), .CYCLES(DIN_VALID_PIPE_LEN)) din_valid_pipe (.clk(rx_clk), .din(din_valid_int), .dout(din_valid) );

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oLyxeZ9BB8DGas2DWNO2pWjkszyEeoMxfugBR7SakpXVoOQFwU7/+Ig/MksnLttDl79HGMqBqxJUrIs+4+JxtuZNxrXNucAMkwR58Pn5WoYI+Md79mFTBqPtXzvJic4IKyZiJqqij/L0AL/vA9GVSEGuFcfIXtnZ7k6DcgYwvYbbA8uKzXVo3qyF1zTeUvrCTogZdmq+9Jr19s9pm6Bhu5YIVkmr7g1+2gYfrZFXY0+y/ZO18OYF5So8fsmDBJGxMh8ZQDeoQxDmJPJcPyrKP1v35WoV36Dow3/X8htbXQPF876xsQ/BR3VqVMRjk+KvFjXRhWglVamnRlnsq4W1ojp68zLZY2yIyBMgxxMHr7ZZxRDTYvR0GDQ3DsEzyN1AFSc3XeKHmVbuHAg7mJX4DLizLIbRuLsd0Dn1WzogdWp1QXAuFSA1iv3lgZKqITOqu9+GE0JEcY2qLk6HGi0v7MmCGRSX4s74AMv97Z/Dfe29qhyxlin7GGj1c4oy2m1qXrgKt2auNa9r1UVhBZD3e8GSWj4Xnx35Ao88fITiPz1RHUPMENjSY/3pZATnzp5eU/DRaKwceNnwLxrDicbBL0gOKOc+1NXu744vHBqlmfQKmQ7r2KNAsNw/bouPN55gHoHX3WYkKL2R/od1Gpd+MrFNtLPjtUWeLRrpSPL3lE6uVk4Ox88Zuyt+FPkmFCqUbGpHMYA1PyYFBU/o5ywy8LPDG7QMQ2R6+HDVhKNwJuy8LS6MSmn+okXeYm57hOlFkxq8k9rZOHrdASfYKNZIpTe"
`endif