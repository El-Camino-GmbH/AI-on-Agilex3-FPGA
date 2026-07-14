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

module dphy_pcs_timing_tx 
   (
        input  wire                     fr_clk,
        input  wire                     fr_clk_1024,
        input  wire                     srst_fr_n,     
        input  wire                     enable,
        
        input wire                      in_prepare,            
        input wire                      in_zero,  
        input wire                      in_pre,
        input wire                      in_trail,
        input wire                      in_post,
        input wire                      in_wake,
        input wire                      in_hs_exit,
        input wire                      in_lp_exit,
        input wire [7:0]                t_init,   
        input wire [7:0]                t_prepare,
        input wire [7:0]                t_zero,
        input wire [7:0]                t_pre,
        input wire [7:0]                t_trail,
        input wire [7:0]                t_post,
        input wire [7:0]                t_wake,
        input wire [7:0]                t_hs_exit,   
        input wire [7:0]                t_lp_exit,   
        output logic                    init_done,
        output logic                    timer_out

    );
    
    localparam FR_TIMER_WIDTH = 16;
    logic [6:0] in_trig;
    logic [6:0] in_trig_q;
    logic fr_ld_timer;
    logic fr_timer_en;
    logic [FR_TIMER_WIDTH-1:0] fr_ld_val;
    logic init_start;
    logic in_wake_q;
    logic fr_timer_out;

    assign in_trig = { in_prepare, in_zero, in_pre, in_trail, in_post, in_hs_exit, in_lp_exit };
    always @(posedge fr_clk)
    begin
        in_trig_q <= in_trig;
        in_wake_q <= in_wake;
    end
    
    
    assign fr_ld_timer = init_start | |(in_trig & ~in_trig_q) | (in_wake & ~in_wake_q);
    assign fr_timer_en = ( init_done & ~in_wake ) ? |in_trig : fr_clk_1024;
    assign fr_ld_val = { 8'h0,  ({ 8{init_start} } & t_init ) |
                                ({ 8{in_prepare} } & t_prepare ) |
                                ({ 8{in_zero} } & t_zero ) |
                                ({ 8{in_pre} } & t_pre ) |
                                ({ 8{in_trail} } & t_trail ) |
                                ({ 8{in_post} } & t_post ) |
                                ({ 8{in_wake} } & t_wake ) |
                                ({ 8{in_hs_exit} } & t_hs_exit ) |
                                ({ 8{in_lp_exit} } & t_lp_exit ) };
    
    always @(posedge fr_clk)
        if( (srst_fr_n & enable) == 1'b0)
        begin
            init_start <= 1;
            init_done <= 1'b0;
        end
        else
        begin
            init_start <= 1'b0;
            init_done <= init_done | fr_timer_out;
        end

    dphy_timer #(
        .WIDTH(FR_TIMER_WIDTH)
   ) tx_timer_fr
   (
        .clk(fr_clk),     
        .srst_n(srst_fr_n),     
        .timer_en(fr_timer_en), 
        .ld_timer(fr_ld_timer),   
        .ld_val(fr_ld_val), 
        .timer_out(fr_timer_out)   
    );
    
    assign timer_out = fr_timer_out;

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oICBJqObgMjn3pCZXWwikcayIem1weTORCLSw3uqsQWc5OtC3BIpkceWhJTzjhYw2pEcoo9amgDBqs49j/gplWvtNIztJd3QKOBUPNlzJEgtoq+Uv1SHu0MWjfgc1/odhhw8qCee2bBeTR+S8FMu/4VI4NAHZAR4kBB3sJBdDOy5vgcbVB6IwLkpDMwWjVO8GCM30t0AZdus4ieLyh33CY+q0sQh5UWhnzwqE34NKQNcQ0o3nzUkCe5uR6yD89o3XpFxfQd6AJx3Hd4d/OS3mLRPBMvPFCnGa8+LDXEqEoQ3PEF4ewhfj3q74oGkXwdIeRNCQ6HTbBeVadyvhmW/43/r37FrmyGgTwE2GdnqAVBrXiaxpf3rdiD2+dgHtW0+uN6FT6GjGFxRd84uCtYhrqtM+F59iuwDT8/WPxxV8zhWcASExBE7jEs4rOzxXfEHF+Y1kOFzH7cyqA87kY+JBItydn1Ztm5QPIgIU25A2o/AzMTyLrUdrw2K3f34nI0fwT63KyCkJquwbRz7vjVjVyBDR+i/IMdVWiuEuK2b53vuD/oakdR+ve1EZejTzfJ+fUWy3c6CdEAduDR7trbHb6yn+d5izPkZbAGzBP38mAFDGNgYwFDgyh0fDLaC/6H+Q1yBRpoQyLtBDdsmOvJe4NilgRPX1m8CQtU9loGpzyo6iQKv3f0MxLFxNhAQuS/JT2UR1QWpd96Zg51/fF3GqGsRrMpXRvDWDZgwmMOTVpqSJMY/KIl2Z3EeGHkaxEnqSNhbGfyd43kT71BoKnJlq8c"
`endif