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
`define BHV_CPA 1
`endif

`ifdef BHV_CPA
`define cpa_name dphy_cpa_bhv
`endif

`define SIM 1

// synthesis translate_on

`ifndef cpa_name
`define cpa_name tennm_clkgen
`endif

module dphy_cpa_wrap #(
    parameter CPA_ID = 0,
    parameter PHY_CLK_DIV = 1,
    parameter VCO_CLK_DIV_EXPONENT = 2,
    parameter VCO_CLK_FREQ = 36'h00000000
) ( 
    input  wire            i_core_clk_in,                  
    input  wire            i_phyclk,                       
    input  wire            i_phyclk_sync,                  
    output logic           o_core_clk_out,                 
    input  wire  [7:0]     i_vco8ph,                       
    output logic           o_lock,                         
    input  wire            i_pll_lock                      
);

localparam PROTOCOL_MODE = 1'b0
// synthesis translate_off
                           | 1'b1
// synthesis translate_on
                           ? "PROTOCOL_MODE_NON_EMIF"
                           : "PROTOCOL_MODE_EMIF";

   
    `cpa_name #(
        .base_address( (16'h3<<8) | (16'h1a<<1) | CPA_ID ),
        .feedback_dly_sel( "FEEDBACK_DLY_SEL_DLY_PHY" ),
        .feedback_dly_steps( 7'h00 ),
        .phy_clk_div( PHY_CLK_DIV ),
        .protocol_mode( PROTOCOL_MODE ),
        .vco_clk_div_exponent( VCO_CLK_DIV_EXPONENT ),
        .vco_clk_div_mantissa( 5'h00 ),
        .vco_clk_freq( VCO_CLK_FREQ )
    ) cpa_inst (
        .i_core_clk_in( i_core_clk_in ),                              
        .i_phyclk( i_phyclk ),                                        
        .i_phyclk_sync( i_phyclk_sync ),                              
        .o_core_clk_out( o_core_clk_out ),                            
        .i_vco8ph( i_vco8ph ),                                        
        .o_lock( o_lock ),                                            
        .i_avl_clk(),                                                 
        .i_avl_rst_n(),                                               
        .i_avl_write(),                                               
        .i_avl_read(),                                                
        .i_avl_address(),                                             
        .i_avl_writedata(),                                           
        .o_avl_readdata(  ),                                          
        .i_pll_lock( i_pll_lock )                                     
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oKHhtVSPIeOEvQ5H2Odq7d3ugHyddX8RYJtU72kXEEdekDVwd1zFETiTI8D7bVCMfup0DlqfXkbmOrRidbygUWYsT5DZRmwVo3mernz/PxvtmOIl1dn3aNyTs9gzdA7FtfMGG0Mq9PiHvJlbSklpqn4I+oAWoLzOIg85eJFXGtPCiEOSdtGCb+NADzuGaMnZ9mkaOTQZD/YehMRACkdpWUv/OkEso5Qz9a5zNTQpe0YCylQMDk97OtkYM/p1NLSrsbAcHEU9GraLD6VUntXikp12CD+u8n6OgJ5xiwGW4XBV46gEfPZss1+ObraIXNZ3g4gT6lqr4gLYiAREUE6g0Z7I2ZjlAeB3EG6yx7krGuEbyCvyucjmCo4mICyJuwO5P3DfmfwVRJfDVJMw5Z3nBKo75HjQFik6KhQ75QqSpL7CaenNI0Mp8S1SqlkHxwE/fo3j1gtGnYobT8BMlHXU90F9H0XbKLgGpfSAh5r/MIToqkaHiaVzMCtHXa5o5LkfiotktvGwYE8MFovkjuqwZE6ToWPUP1sjxrh6Vp7ElVVEtABvjUGDgrkdfYS4yiwyYMSVPPd67vWtzPEv1hVGKf0T06UrKOjV9Sl82qymlc7bINvPvEUR9rkV2xtYohIi/dwI/VLAXv/RcQFgVHyodpnlIAL7/edAeaJpl9JpdcEd1djl6N9WUl5Ud3u+oVJqCR22u/yqOfMm5wwgCLYeSj53fsxr36ZdBm3m1eShGOXmZpDKOG6+u4QBvgGAVi5zH7rMTqZHx/JH1QWcFddL3VU"
`endif