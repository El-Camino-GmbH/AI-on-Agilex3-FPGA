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
`define BHV_PA 1
`endif

`ifdef BHV_PA
`define phy_adaptor_name dphy_phy_adaptor_bhv
`endif

`define SIM 1

// synthesis translate_on  


`ifndef phy_adaptor_name
`define phy_adaptor_name tennm_phy_adaptor
`endif

module dphy_phy_adaptor_wrap #(
    parameter BYTE_LOC = 0,
    parameter BYTE_N = 0,
    parameter NUM_LANES = 0
) ( 
    input  wire  [4:0]     i_fa2pa_gpio_dout_sel,          
    input  wire  [3:0]     i_fa2pa_rddata_en,              
    input  wire  [3:0]     i_fa2pa_wr_dqs_en,              
    input  wire  [95:0]    i_fa2pa_wrdata,                 
    input  wire  [3:0]     i_fa2pa_wrdata_en,              
    input  wire  [3:0]     i_fa2pa_wr_rank,
    input  wire  [3:0]     i_fa2pa_rd_rank,

    input  wire            i_phy_clk_hr,                   
    input  wire  [47:0]    i_phy2pa_rddata,                
    input  wire  [1:0]     i_phy2pa_rddata_valid,          
    input  wire            i_phyclk_sync,                  
    input  wire            i_rxfwd_clk,                    
    output logic [95:0]    o_pa2fa_rddata,                 
    output logic [3:0]     o_pa2fa_rddata_valid,           
    output logic [11:0]    o_pa2phy_gpio_dout_sel,         
    output logic [1:0]     o_pa2phy_rddata_en,             

    output logic [3:0]     o_pa2phy_rd_rank,
    output logic [3:0]     o_pa2phy_wr_rank,
    output logic           o_pa2phy_dram_clock_disable,
    input  logic           i_ctr2pa_dram_clock_disable,
    
    output logic [1:0]     o_pa2phy_wr_dqs0_en,            
    output logic [1:0]     o_pa2phy_wr_dqs1_en,            
    output logic [47:0]    o_pa2phy_wrdata,                
    output logic [1:0]     o_pa2phy_wrdata_en,             
    output logic           o_rxfwd_clk,                    
    input  wire  [9:0]     i_fa2pa_mipi_lp_dout,           
    output logic [9:0]     o_mipi_lp_dout,                 
    output logic           o_pa2phy_rxanalogen,
    output logic           o_pa2phy_txanalogen
);

    `phy_adaptor_name #(
        .base_address( (16'h3<<8) | (16'h2<<3) | BYTE_LOC ),
        .controller( "CONTROLLER_SOFT" ),
        .ddr_lane_mode( "DDR_LANE_MODE_DQ" ),
        .mipi_func( NUM_LANES == 1 ? "MIPI_FUNC_D1" : ( NUM_LANES == 2 ? "MIPI_FUNC_D2" : ( BYTE_N == 0 ? "MIPI_FUNC_D4CK" : "MIPI_FUNC_D4" ) ) ),
        .pin0_swizzle("PIN0_SWIZZLE_DQ0"),
        .pin1_swizzle("PIN1_SWIZZLE_DQ1"),
        .pin2_swizzle("PIN2_SWIZZLE_DQ2"),
        .pin3_swizzle("PIN3_SWIZZLE_DQ3"),
        .pin8_swizzle("PIN8_SWIZZLE_DQ4"),
        .pin9_swizzle("PIN9_SWIZZLE_DQ5"),
        .pin10_swizzle("PIN10_SWIZZLE_DQ6"),
        .pin11_swizzle("PIN11_SWIZZLE_DQ7"),
         /* patch 12
        .rate_conv(QR_HR_CONV_EN)
        */
	.rate_conv( "RATE_CONV_QR_HR_CONV_EN" )
    ) phy_adaptor_inst (
        .i_alert_gpio_din(),                                          
        .i_hmc2pa_rd_rank(),                                          
        .i_hmc2pa_rddata_en(),                                        
        .i_hmc2pa_wr_dqs0_en(),                                        
        .i_hmc2pa_wr_dqs1_en(),                                        
        .i_hmc2pa_wr_rank(),                                          
        .i_hmc2pa_wrdata(),                                           
        .i_hmc2pa_wrdata_en(),                                        
        .i_seq2pa_rd_rank(),                                          
        .i_seq2pa_rddata_en(),                                        
        .i_seq2pa_seq_en(),                                           
        .i_seq2pa_suppression(),                                      
        .i_seq2pa_wr_dqs_en(),                                        
        .i_seq2pa_wr_rank(),                                          
        .i_seq2pa_wrdata(),                                           
        .i_seq2pa_wrdata_en(),                                        
        .i_fa2pa_rd_rank(i_fa2pa_rd_rank),                            
        .i_fa2pa_wr_rank(i_fa2pa_wr_rank),                            
        .i_fa2pa_gpio_dout_sel( i_fa2pa_gpio_dout_sel ),              
        .i_fa2pa_rddata_en( i_fa2pa_rddata_en ),                      
        .i_fa2pa_wrdata( i_fa2pa_wrdata ),                            
        .i_fa2pa_wr_dqs_en( i_fa2pa_wr_dqs_en ),                      
        .i_fa2pa_wrdata_en( i_fa2pa_wrdata_en ),                      
        .i_phy_clk_hr( i_phy_clk_hr ),                                
        .i_phy2pa_rddata( i_phy2pa_rddata ),                          
        .i_phy2pa_rddata_valid( i_phy2pa_rddata_valid ),              
        .i_phyclk_sync( i_phyclk_sync ),                              
        .i_rxfwd_clk( i_rxfwd_clk ),                                  
        .o_pa2fa_rddata( o_pa2fa_rddata ),                            
        .o_pa2fa_rddata_valid( o_pa2fa_rddata_valid ),                
        .o_pa2hmc_rddata(  ),                                         
        .o_pa2hmc_rddata_valid(  ),                                   
        .o_pa2phy_gpio_dout_sel( o_pa2phy_gpio_dout_sel ),            
        .o_pa2phy_rd_rank( o_pa2phy_rd_rank ),                        
        .o_pa2phy_rddata_en( o_pa2phy_rddata_en ),                    
        .o_pa2phy_suppression(  ),                                    
        .o_pa2phy_wr_dqs0_en( o_pa2phy_wr_dqs0_en ),                  
        .o_pa2phy_wr_dqs1_en( o_pa2phy_wr_dqs1_en ),                  
        .o_pa2phy_dram_clock_disable(o_pa2phy_dram_clock_disable),
        .i_ctr2pa_dram_clock_disable(i_ctr2pa_dram_clock_disable),
        
        .o_pa2phy_wr_rank(o_pa2phy_wr_rank),                          
        .o_pa2phy_wrdata( o_pa2phy_wrdata ),                          
        .o_pa2phy_wrdata_en( o_pa2phy_wrdata_en ),                    
        .o_rxfwd_clk( o_rxfwd_clk ),                                  
        .o_rb_pa2seq_ddr_lane_mode(  ),                               
        .o_rb_pa2seq_if_sel(  ),                                      
        .o_rb_pa2seq_phy_clk_en(  ),                                  
        .o_rb_pa2seq_rate_conv_en(  ),                                
        .o_rb_pa2seq_seq_base_addr(  ),                               
        .i_fa2pa_mipi_lp_dout( i_fa2pa_mipi_lp_dout ),                
        .o_mipi_lp_dout( o_mipi_lp_dout ),                            
        .o_pa2phy_rxanalogen(o_pa2phy_rxanalogen),
        .o_pa2phy_txanalogen(o_pa2phy_txanalogen),
	.i_hmc2pa_rxanalogen(1'b1),
	.i_hmc2pa_txanalogen(1'b1)
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t/gY+/87dnT0l8WgzRQ3eBMlPCYcZRFI/p4xkEZbHQrgbChRF+BhM6Bco0SqOdzfyOOP+psblliZCYSFP1xtqVM++DEX2YU2sHRzPHvfPP6MFghMgk6P8ncN2341duINF/YF7f+W44TiE95mQgYp1TJl4rvG/qVTcydGgMnNDmzn/zg/ItAm3NYCi19W9VzBfDijbX2Fj9Scmpa+C2RtT4VOszB+9AHTI/DXmY9TBPfemVLI7PWImbsGfjasg3jVG7/u6GewfWvWOcZQyG9jsv8aGULZW5FLWPfUBb7MHwJBftAXNCAlgLP0HvvSRMIRwIRmeeYaK8z/VoocogFnDCRUZGHsrJux9tkxosmsCSmBBCeygQrE+myGPSwIBXlS95Ov6yCto0k9MO3TTNLL/U8/xNgzScRc6SjdpkBflVMoofaFD/ccH4jG67L/Q4h91r89kGdCTb74YJm0CVnqKrAeKGdaQ6C1a6hjdd8pJ9PxTFisfH1+Mav8JUvVfNxEdM+HLkwQz5GXz2qqHAbPFh/s/fxgbICiHYXI2gfHjmrpxD9llfepvTJXg3zj2lNatcDdnD3P27K6DbuT664KaVHmZZdnWv4CBbwHGe7Av1Th6Wpdj6UQK0ZwJBujayo71MwZtPSG9oByA5GSQutgoxbrqmKzgzCtCc6clJDLhXE3ykHsh09U3FPyAHnURrbxeNvHFXwZ3FicKYURCD4lmsdOHf8Iq+Q5wRDnN7SMTAINP8FZ/clIvZ+A5kd36kii4+uBWIN56UTQqrmYOT5eqlw"
`endif