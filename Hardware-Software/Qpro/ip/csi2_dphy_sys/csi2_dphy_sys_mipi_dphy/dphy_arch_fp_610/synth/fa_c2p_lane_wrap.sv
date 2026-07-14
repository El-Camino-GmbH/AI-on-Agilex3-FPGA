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
`define BHV_FA_C2P 1
`endif

`ifdef BHV_FA_C2P
`define fa_c2p_lane_name dphy_fa_c2p_lane_bhv
`endif

`define SIM 1

// synthesis translate_on  


`ifndef fa_c2p_lane_name
`define fa_c2p_lane_name tennm_lane_c2p_fabric_adaptor
`endif

module dphy_fa_c2p_lane_wrap #(
    parameter BYTE_LOC = 0,
    parameter FA_CORE_PERIPH_CLK_SEL_DATA_MODE = "FA_CORE_PERIPH_CLK_SEL_DATA_MODE_UNUSED",
    parameter IO12LANE_C2P_DATA_MODE = "IO12LANE_C2P_DATA_MODE_REG",
    parameter IO_CONVERT_RATIO_C2P = 16
) ( 
    output logic [95:0]    o_c2p_hmc,                      
    output logic [95:0]    o_c2p_phylite,                  
    input  wire  [95:0]    i_c2p,                          
    input  wire  [19:0]    i_c2p_ctrl,                     
    output logic [19:0]    o_c2p_phylite_ctrl,             
    output logic [19:0]    o_c2p_hmc_ctrl,                 
    input  wire            i_phy_clk_fr,                   
    input  wire            i_phy_clk_sync,                 
    input  wire            i_core_clk                      
);

    `fa_c2p_lane_name #(
`ifdef BHV_FA_C2P
        .IO_CONVERT_RATIO_C2P(IO_CONVERT_RATIO_C2P),
`endif
        .fa_core_periph_clk_sel_data_mode( FA_CORE_PERIPH_CLK_SEL_DATA_MODE ),
        .io12lane_c2p_data_mode( IO12LANE_C2P_DATA_MODE )
    ) fa_c2p_lane_inst (
        .o_c2p_hmc( o_c2p_hmc ),                                      
        .o_c2p_phylite( o_c2p_phylite ),                              
        .i_c2p( i_c2p ),                                              
        .i_c2p_ctrl( i_c2p_ctrl ),                                    
        .o_c2p_phylite_ctrl( o_c2p_phylite_ctrl ),                    
        .o_c2p_hmc_ctrl( o_c2p_hmc_ctrl ),                            
        .i_phy_clk_fr( i_phy_clk_fr ),                                
        .i_phy_clk_sync( i_phy_clk_sync ),                            
        .i_core_clk( i_core_clk )                                     
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oKtZpZ6JMnTWaZy/Sr6h5tvIEjZmCir/oWvipg9XO2IuFRpS8S0Vy7Fr5vckBOFwI8Q4gAtaeeP3ClkzBW/WlWfYKYmW+eRG1PpCxL1FrIfL077nu0Orkx1rHqlxvPtIuhgh/G9nT5yts18nqsPQZD0VZ6RD/yyjlYvoTUcpCT7YyuVIPK8ICRI9xnomKS9zYtUgSW9szBwI4EoaBC3uLEvvmShV5ZMxLpOFfp0TRgLONZPSjfTy8G8FUGUa2F2BcAeyfLoq4LzO8ojzm8M8aj0GnilTmyzeR2ufPWU5dzpZ7LsERpPbjTDZgAcga6twwcwrVFx3lUkG5HGVGW5muyeJsd2pO62YGqNYhuSDfRlmzST36NKo7ParQibRaMCgvjdM7QeqvtxN3qMXmCXWwgKfoBV3sylOHIt5x/KrrG8Dm7MFY+htPELmcfTkiPMeQLoG3NaZBPPxczhCcXbPiy/C3SteY2MaG1RTdfHT6uBU81ELTQ5qP9G5/Agh8hs53PQ7NUp/8MJcP09+q6g32R7RvKL9J8LPV3TLcUvuNJjMt94XEZflPWYYrWlGPmqxXN1dj8LUBJb5Ac9uUZAxcs6N5EV9BihsthlZHCbBQEPVmt3lvUCJkKdyyt+A+yupSgCV5cqpSqqcX5vfRyDffmYudszzSBzScy5RDZUVwv393du6tJ0PveoG4yzwSc2QpRgLh11br3Ui+wtXqPz4/ni2wSr++CoFyEOjrU9LS7LKxcpP+Z0FmBqXAWmn3G9HMuXgvsmDGTknBLenSSbJn4s"
`endif