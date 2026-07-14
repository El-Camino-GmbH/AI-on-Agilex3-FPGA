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





// synthesis translate_off        

`ifdef DPHY_BHV_SIM
`define BHV_IOPLL 1
`endif

`ifdef BHV_IOPLL
`define iopll_name dphy_iopll_bhv
`endif

`define SIM 1

// synthesis translate_on  


`ifndef iopll_name
`define iopll_name tennm_ph2_iopll
`endif

module dphy_iopll_wrap #(
    parameter PLL_ID = 0,
    parameter SPEED_GRADE = "SPEEDGRADE2",
    parameter REF_CLK_FREQ = 32'd0,
    parameter VCO_FREQ = 0
) ( 
    output logic           lock,                           
    input  wire            ref_clk0,                       
    input  wire            ref_clk1,                       
    input  wire            ref_clk_switch_n,               
    output logic [1:0]     ref_clk_bad,                    
    output logic           ref_clk_active,                 
    input  wire            fb_clk_in,                      
    input  wire            fb_clk_in_lvds,                 
    output logic [6:0]     out_clk,                        
    output logic           out_clk_external0,              
    output logic           out_clk_external1,              
    output logic           out_clk_periph0,                
    output logic           out_clk_periph1,                
    output logic           out_clk_cascade,                
    output logic           fb_clk_out,                     
    output logic [7:0]     vco_clk,                        
    output logic           vco_clk_periph                  
);
    localparam M_DIV_1 = int'(VCO_FREQ / REF_CLK_FREQ);
    localparam M_DIV_8 = int'(8 * VCO_FREQ / REF_CLK_FREQ);	
    localparam M_DIV = ((VCO_FREQ - M_DIV_1 * REF_CLK_FREQ) <= (VCO_FREQ - M_DIV_8 * REF_CLK_FREQ / 8)) ? M_DIV_1 : M_DIV_8;
    localparam N_DIV = ((VCO_FREQ - M_DIV_1 * REF_CLK_FREQ) <= (VCO_FREQ - M_DIV_8 * REF_CLK_FREQ / 8)) ? 1 : 8;
    localparam PFD_CLK = REF_CLK_FREQ / N_DIV;
    localparam SYNC_DIV = 16;

    
    `iopll_name #(
        .bandwidth_mode( "BANDWIDTH_MODE_AUTO" ),
        .base_address( (16'h3<<8) | (16'h3<<3) | PLL_ID ),
        .cascade_mode( "CASCADE_MODE_STANDALONE" ),
        .clk_switch_auto_en( "FALSE" ),
        .clk_switch_manual_en( "FALSE" ),
        .compensation_clk_source( "COMPENSATION_CLK_SOURCE_UNUSED" ),
        .compensation_mode( "COMPENSATION_MODE_DIRECT" ),
        .fb_clk_delay( 0 ),
        .fb_clk_fractional_div_den( 1 ),
        .fb_clk_fractional_div_num( 1 ),
        .fb_clk_fractional_div_value( 0 ),
        .fb_clk_m_div( M_DIV ),
        .out_clk_0_c_div( 2 ),
        .out_clk_0_core_en( "TRUE" ),
        .out_clk_0_delay( 0 ),
        .out_clk_0_dutycycle_den( 4 ),
        .out_clk_0_dutycycle_num( 2 ),
        .out_clk_0_dutycycle_percent( 50 ),
        .out_clk_0_freq( VCO_FREQ/2 ),
        .out_clk_0_phase_ps( 0 ),
        .out_clk_0_phase_shifts( 0 ),
        .out_clk_1_c_div( SYNC_DIV ),
        .out_clk_1_core_en( "TRUE" ),
        .out_clk_1_delay( 0 ),
        .out_clk_1_dutycycle_den( SYNC_DIV*2 ),
        .out_clk_1_dutycycle_num( SYNC_DIV ),
        .out_clk_1_dutycycle_percent( 50 ),
        .out_clk_1_freq( VCO_FREQ/SYNC_DIV ),
        .out_clk_1_phase_ps( 0 ),
        .out_clk_1_phase_shifts( 0 ),
        .out_clk_2_c_div( 1 ),
        .out_clk_2_core_en( "FALSE" ),
        .out_clk_2_delay( 0 ),
        .out_clk_2_dutycycle_den( 4 ),
        .out_clk_2_dutycycle_num( 2 ),
        .out_clk_2_dutycycle_percent( 0 ),
        .out_clk_2_freq( 0 ),
        .out_clk_2_phase_ps( 0 ),
        .out_clk_2_phase_shifts( 0 ),
        .out_clk_3_c_div( 1 ),
        .out_clk_3_core_en( "FALSE" ),
        .out_clk_3_delay( 0 ),
        .out_clk_3_dutycycle_den( 4 ),
        .out_clk_3_dutycycle_num( 2 ),
        .out_clk_3_dutycycle_percent( 0 ),
        .out_clk_3_freq( 0 ),
        .out_clk_3_phase_ps( 0 ),
        .out_clk_3_phase_shifts( 0 ),
        .out_clk_4_c_div( 1 ),
        .out_clk_4_core_en( "FALSE" ),
        .out_clk_4_delay( 0 ),
        .out_clk_4_dutycycle_den( 4 ),
        .out_clk_4_dutycycle_num( 2 ),
        .out_clk_4_dutycycle_percent( 0 ),
        .out_clk_4_freq( 0 ),
        .out_clk_4_phase_ps( 0 ),
        .out_clk_4_phase_shifts( 0 ),
        .out_clk_5_c_div( 1 ),
        .out_clk_5_core_en( "FALSE" ),
        .out_clk_5_delay( 0 ),
        .out_clk_5_dutycycle_den( 4 ),
        .out_clk_5_dutycycle_num( 2 ),
        .out_clk_5_dutycycle_percent( 0 ),
        .out_clk_5_freq( 0 ),
        .out_clk_5_phase_ps( 0 ),
        .out_clk_5_phase_shifts( 0 ),
        .out_clk_6_c_div( 1 ),
        .out_clk_6_core_en( "FALSE" ),
        .out_clk_6_delay( 0 ),
        .out_clk_6_dutycycle_den( 4 ),
        .out_clk_6_dutycycle_num( 2 ),
        .out_clk_6_dutycycle_percent( 0 ),
        .out_clk_6_freq( 0 ),
        .out_clk_6_phase_ps( 0 ),
        .out_clk_6_phase_shifts( 0 ),
        .out_clk_cascading_source( "OUT_CLK_CASCADING_SOURCE_UNUSED" ),
        .out_clk_external_0_source( "OUT_CLK_EXTERNAL_0_SOURCE_UNUSED" ),
        .out_clk_external_1_source( "OUT_CLK_EXTERNAL_1_SOURCE_UNUSED" ),
        .out_clk_periph_0_delay( 0 ),
        .out_clk_periph_0_en( "TRUE" ),
        .out_clk_periph_1_delay( 0 ),
        .out_clk_periph_1_en( "TRUE" ),
        .pfd_clk_freq( PFD_CLK ),
        .protocol_mode( "PROTOCOL_MODE_EMIF_MODE" ),
        .ref_clk_0_freq( REF_CLK_FREQ ),
        .ref_clk_1_freq( 0 ),
        .ref_clk_delay( 0 ),
        .ref_clk_n_div( N_DIV ),
        .self_reset_en( "TRUE" ),
        .set_dutycycle( "SET_DUTYCYCLE_FRACTION" ),
        .set_fractional( "SET_FRACTIONAL_FRACTION" ),
        .set_freq( "SET_FREQ_DIVISION_VERIFY" ),
        .set_phase( "SET_PHASE_NUM_SHIFTS" ),
        .vco_clk_freq( VCO_FREQ )
    ) iopll_inst (
        .permit_cal( 1'h1 ),                                          
        .lock( lock ),                                                
        .ref_clk0( ref_clk0 ),                                        
        .ref_clk_switch_n( ref_clk_switch_n ),                        
        .ref_clk_bad( ref_clk_bad ),                                  
        .ref_clk_active( ref_clk_active ),                            
        .fb_clk_in( fb_clk_in),                                       
        .out_clk( out_clk ),                                          
        .out_clk_external0( out_clk_external0 ),                      
        .out_clk_external1( out_clk_external1 ),                      
        .out_clk_periph0( out_clk_periph0 ),                          
        .out_clk_periph1( out_clk_periph1 ),                          
        .out_clk_cascade( out_clk_cascade ),                          
        .fb_clk_out( fb_clk_out ),                                    
        .vco_clk( vco_clk ),                                          
        .vco_clk_periph( vco_clk_periph ),                            
        .fb_clk_in_lvds(),                                            
        .ref_clk1( ),                                                 
        .reset( 1'b0 ),                                               
        .core_avl_clk(),                                              
        .core_avl_write(),                                            
        .core_avl_read(),                                             
        .core_avl_address(),                                          
        .core_avl_writedata(),                                        
        .cal_bus_rst_n(),                                            
        .cal_bus_clk(),                                               
        .cal_bus_write(),                                             
        .cal_bus_read(),                                              
        .cal_bus_address(),                                           
        .cal_bus_writedata(),                                         
        .dps_num_phase_shifts(),                                      
        .dps_cnt_sel(),                                               
        .dps_phase_en(),                                              
        .dps_up_dn(),                                                 
        .core_avl_readdata(),                                         
        .cal_bus_readdata(),                                          
        .dps_phase_done()                                             
    );
    
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t+sWRnUJzKI5R/Hq/2qYZjRzqJ/P3nhjcHO4EiCbhhR9jy0CUGVFfvpJ7xqupUQ0uwEVKaKg8IfaEzcH0JnRUTpJtgHrF84FFgSwezX5ASbjlTzbp4jBVaSLcWqARE7+zBxj/REOhylGbSyBLSH3vPD93sH0wO7Bl4KcF7yzaL/BpbJBRqmFUK8GRQPhvBtx4cdlZIr1yKCnlI++Gs/SKEBhOjlKdmgPt13n+1tM2uQy/ry0td3twOoNOLos13vX/9FpeaMnuiZXTWV2VlJ9BCuoxx8kfalQln0cmqv2kKleA/5KoePHpRw7dtY8rBBSQNmcPtNxa9VNyOifbfasqAt3rneV8VNpnraEdNahhhor2Ii0ub6tjIRmUrxJT6W2t75oRFx7t2F5mne5m0PT0/rXldRAHWbkRDHWLRHKczODANYwfCkExtzGLvfMhyoTlMWoVgGerNv4OHAqCeTPDtiSAC4IIZSUoouuLjwZc2sGmu370DlLbY3sJo3GRTy3Sah3W5Ygjxmsy7O7+/oOr1mdv3fRVhreUeH040NMO6AaN/ZW+JcNlcuGNtascDR/Qd3QcNuSDfUp4bdvdQLE1OKLxScGP8GGZmiPNyoF6PqQRJzQ2H/Oif7BA8H0lg2ov5pjdJX6JQSWGe4dqrhIRnQjlxzcLrp7HM/qcIB5/NJY/2pORVNh1fO1cDsl/dN2hKkM7IJD8dc6qWTYzJn7Bxxe0Ty1ACMOnb/pDNlhbe0bBZbwLJFk7HjLggBrNW5CEZ+2EhnXWGU3fHJEtFiaaRP"
`endif