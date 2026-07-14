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
`define BHV_FA_P2C 1
`endif

`ifdef BHV_FA_P2C
`define fa_p2c_lane_name dphy_fa_p2c_lane_bhv
`endif

`define SIM 1

// synthesis translate_on  

`ifndef fa_p2c_lane_name
`define fa_p2c_lane_name tennm_lane_p2c_fabric_adaptor
`endif

module dphy_fa_p2c_lane_wrap #(
    parameter BYTE_LOC = 0,
    parameter FA_CORE_PERIPH_CLK_SEL_DATA_MODE = "FA_CORE_PERIPH_CLK_SEL_DATA_MODE_UNUSED",
    parameter FWD_CLOCK_DIVIDE_DATA_MODE = "FWD_CLOCK_DIVIDE_DATA_MODE_UNUSED",
    parameter IO12LANE_P2C_DATA_MODE = "IO12LANE_P2C_DATA_MODE_REG"
) ( 
    input  wire  [95:0]    i_hmc,                          
    input  wire  [95:0]    i_phy,                          
    output logic [95:0]    o_p2c,                          
    input  wire  [3:0]     i_p2c_phylite_ctrl,             
    input  wire  [3:0]     i_p2c_hmc_ctrl,                 
    output logic [3:0]     o_p2c_ctrl,                     
    input  wire            i_phy_clk_fr,                   
    input  wire            i_phy_clk_sync,                 
    input  wire            i_core_clk,                     
    input  wire            i_mipi_fwd_clk,                 
    output logic           o_mipi_fwd_clk                  
);

    `fa_p2c_lane_name #(
        .fa_core_periph_clk_sel_data_mode( FA_CORE_PERIPH_CLK_SEL_DATA_MODE ),
        .fwd_clock_divide_data_mode( FWD_CLOCK_DIVIDE_DATA_MODE ),
        .io12lane_p2c_data_mode( IO12LANE_P2C_DATA_MODE )
    ) fa_p2c_lane_inst (
        .i_hmc(  ),                                                   
        .i_phy( i_phy ),                                              
        .o_p2c( o_p2c ),                                              
        .i_p2c_phylite_ctrl( i_p2c_phylite_ctrl ),                    
        .i_p2c_hmc_ctrl(  ),                                          
        .o_p2c_ctrl( o_p2c_ctrl ),                                    
        .i_phy_clk_fr( i_phy_clk_fr ),                                
        .i_phy_clk_sync( i_phy_clk_sync ),                            
        .i_core_clk( i_core_clk ),                                    
        .o_mipi_fwd_clk( o_mipi_fwd_clk ),                            
        .i_mipi_fwd_clk( i_mipi_fwd_clk )                             
    );
    
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJdwVzKrGkhjPe4w/tsOebDN/lLvyr8KuOTCDNkzfiXuGdVP9yLhxbnzoM5PbWc2sGGXAE+fMb/xOKO00vvp/mP3JBbL79mwg9LFXiWQTD12izNgaUM1rC8l0PFrPX5P/vdffRuBsxHdwLeJ9pV9dMIVv1BPBWFXdutmcoV3GoI213+vfkccMnuzpgKF4VOz65KMFURrqjF5Hl6/zx1ttg3FHHGYTxBDmGKBk72KAHu38UtYcWkaQjukp6XCZgjDhZclL2RPX3CE+sqM77qpnZ4Ie+hzXcgL9Ooyh8aqDMDs83GGsqu6Tltq6YojbAY+A1Cgatpy32ixDcUqY/MFUli+4eheZeO7zp3GwHk+eoVCCsBdlrv/epklj5SdgxZXZQjsw2j+7kzwxJvRYfoi7B5UnJTNL/NMeUSp/eTfAgGlySOmdq0Xjd43WWpBiF0AW5SaYvTUfnh97oq8a/18f79jsW23i/524fiWzqixF2mxV/liUQ+5I4UGxjgkkwmPuN/a/vwa02/u154cZ0Ddx6Sjoi6ffFX11iahMiVceORHUF265p3L1YlJRQYhKix7UUoGpxUh2UVe17pVFUWfwzgiwYyN6F1/Oi68jkxntBGgUlAFdkEIVWIviQ04XOmjw+TnOfBKJkZ7kQNKvRWJlNcV+ry0RA4Gi+p9V4awE1P+42fOB2A9gyMUkOCQ/BSwtyTdpEkFbYVspbrkoEl8DeDDX7gMyA9ye9xuM0ZwhDUBkP4KgvBZf7VQebDd2WjitEMd6Xq6d0xf2eNEKKEnKFY"
`endif