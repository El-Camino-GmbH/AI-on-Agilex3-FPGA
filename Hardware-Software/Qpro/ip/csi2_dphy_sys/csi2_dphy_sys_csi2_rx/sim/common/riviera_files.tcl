
namespace eval csi2_dphy_sys_csi2_rx {
  proc get_design_libraries {} {
    set libraries [dict create]
    dict set libraries altera_common_sv_packages              1
    dict set libraries intel_cv2axi_core_2140                 1
    dict set libraries altera_reset_controller_1924           1
    dict set libraries intel_vvp_ro_reg_servicer_2450         1
    dict set libraries intel_vvp_output_interface_bridge_2440 1
    dict set libraries altera_merlin_master_translator_193    1
    dict set libraries altera_merlin_slave_translator_191     1
    dict set libraries altera_mm_interconnect_1920            1
    dict set libraries intel_cv2axi_2140                      1
    dict set libraries intel_mipi_csi2_300                    1
    dict set libraries csi2_dphy_sys_csi2_rx                  1
    return $libraries
  }
  
  proc get_memory_files {QSYS_SIMDIR QUARTUS_INSTALL_DIR} {
    set memory_files [list]
    return $memory_files
  }
  
  proc get_common_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR} {
    set design_files [dict create]
    dict set design_files "altera_common_sv_packages::aldec_intel_vab_common_pkg"         "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_common_pkg.sv"]\"  -work altera_common_sv_packages"        
    dict set design_files "altera_common_sv_packages::aldec_intel_vab_axi_master"         "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_axi_master.sv"]\"  -work altera_common_sv_packages"        
    dict set design_files "altera_common_sv_packages::aldec_intel_vab_axi_pipeline_stage" "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_axi_pipeline_stage.sv"]\"  -work altera_common_sv_packages"
    dict set design_files "altera_common_sv_packages::aldec_intel_vvp_common_pkg"         "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_ro_reg_servicer_2450/sim/aldec/intel_vvp_common_pkg.sv"]\"  -work altera_common_sv_packages"
    return $design_files
  }
  
  proc get_design_files {USER_DEFINED_COMPILE_OPTIONS USER_DEFINED_VERILOG_COMPILE_OPTIONS USER_DEFINED_VHDL_COMPILE_OPTIONS QSYS_SIMDIR QUARTUS_INSTALL_DIR} {
    set design_files [list]
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_ext_interlace_toggle.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                       
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_pipelined_mux.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_common_slave_interface.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                     
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_flop_primitive.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                             
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_synchronizer_flop.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                          
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_clock_crosser.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/intel_vab_csr_interrupt.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_register_addresses.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_control.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                         
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_core.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_csr.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                             
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_axi_st_output.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_embedded_sync_extractor.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                         
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_fifo.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_format_detection.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_pixel_deprication.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_resolution_detection.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_sample_counter.v"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_sdi_resampler.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_sync_align.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                      
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_sync_conditioner.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_sync_polarity_convertor.v"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                          
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_vc_splitter.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                     
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_write_buffer_fifo.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/aldec/src_hdl/intel_cv2axi_aux_out.sv"]\" -l altera_common_sv_packages -work intel_cv2axi_core_2140"                                                         
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1924/sim/altera_reset_controller.v"]\"  -work altera_reset_controller_1924"                                                                                
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1924/sim/altera_reset_synchronizer.v"]\"  -work altera_reset_controller_1924"                                                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_ro_reg_servicer_2450/sim/aldec/src_hdl/intel_vvp_ro_reg_servicer.sv"]\" -l altera_common_sv_packages -work intel_vvp_ro_reg_servicer_2450"                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_ro_reg_servicer_2450/sim/csi2_dphy_sys_csi2_rx_intel_vvp_ro_reg_servicer_2450_jflcrey.sv"]\" -l altera_common_sv_packages -work intel_vvp_ro_reg_servicer_2450"               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_output_interface_bridge_2440/sim/aldec/intel_vvp_axi_pipeline_stage.sv"]\" -l altera_common_sv_packages -work intel_vvp_output_interface_bridge_2440"                         
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_output_interface_bridge_2440/sim/aldec/intel_vvp_axi_master.sv"]\" -l altera_common_sv_packages -work intel_vvp_output_interface_bridge_2440"                                 
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_output_interface_bridge_2440/sim/aldec/src_hdl/intel_vvp_output_interface_bridge.sv"]\" -l altera_common_sv_packages -work intel_vvp_output_interface_bridge_2440"            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_master_translator_193/sim/csi2_dphy_sys_csi2_rx_altera_merlin_master_translator_193_lgcew2q.sv"]\" -l altera_common_sv_packages -work altera_merlin_master_translator_193"
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_slave_translator_191/sim/csi2_dphy_sys_csi2_rx_altera_merlin_slave_translator_191_xg7rzxi.sv"]\" -l altera_common_sv_packages -work altera_merlin_slave_translator_191"   
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../altera_mm_interconnect_1920/sim/csi2_dphy_sys_csi2_rx_altera_mm_interconnect_1920_xqcry6i.v"]\"  -work altera_mm_interconnect_1920"                                                
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_2140/sim/csi2_dphy_sys_csi2_rx_intel_cv2axi_2140_4mpbb4i.v"]\"  -work intel_cv2axi_2140"                                                                              
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/csi2_dphy_sys_csi2_rx_intel_mipi_csi2_intel_cv2axi_300_5fgsb2i.v"]\"  -work intel_mipi_csi2_300"                                                           
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_pkg.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/vvp_pkg.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/axis_if.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/avalon_mm_if.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                           
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/vid_if.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                                 
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csi2_rx_csr.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                       
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csi2_rx_err_detect.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_axis_fifo.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                         
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_cdc.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_common_slave_interface.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_crc.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                               
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csr_ctrl_mux.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                      
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csr_interrupt.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                     
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_dphy_ppi_if.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                       
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_ecc_parity_gen.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_ecc_syndrome_decoder.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_fifo.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_packet_arbiter.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_pipelined_mux.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                     
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_pixel_barrel_shifter.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                              
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_prbs_gen_lane.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                     
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_reset_sync.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                        
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_ro_reg_servicer.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_skid_buffer.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                       
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_vab_axi_master.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_vab_axi_pipeline_stage.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_cv2axi_aux_out.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_byte_to_pixel_converter.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                        
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_depacketizer.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                   
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_descrambler.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                    
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_ecc.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_lane_management.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_ppi.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                            
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_protocol.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                                       
    lappend design_files "vlog  $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/csi2_dphy_sys_csi2_rx_intel_mipi_csi2_300_75ibfmy.sv"]\" -l altera_common_sv_packages -work intel_mipi_csi2_300"                                                
    lappend design_files "vlog -v2k5 $USER_DEFINED_VERILOG_COMPILE_OPTIONS $USER_DEFINED_COMPILE_OPTIONS  \"[normalize_path "$QSYS_SIMDIR/csi2_dphy_sys_csi2_rx.v"]\"  -work csi2_dphy_sys_csi2_rx"                                                                                                                             
    return $design_files
  }
  
  proc get_non_duplicate_elab_option {ELAB_OPTIONS NEW_ELAB_OPTION} {
    set IS_DUPLICATE [string first $NEW_ELAB_OPTION $ELAB_OPTIONS]
    if {$IS_DUPLICATE == -1} {
      return $NEW_ELAB_OPTION
    } else {
      return ""
    }
  }
  
  
  proc get_elab_options {SIMULATOR_TOOL_BITNESS} {
    set ELAB_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ELAB_OPTIONS
  }
  
  
  proc get_sim_options {SIMULATOR_TOOL_BITNESS} {
    set SIM_OPTIONS ""
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $SIM_OPTIONS
  }
  
  
  proc get_env_variables {SIMULATOR_TOOL_BITNESS} {
    set ENV_VARIABLES [dict create]
    set LD_LIBRARY_PATH [dict create]
    dict set ENV_VARIABLES "LD_LIBRARY_PATH" $LD_LIBRARY_PATH
    if ![ string match "bit_64" $SIMULATOR_TOOL_BITNESS ] {
    } else {
    }
    return $ENV_VARIABLES
  }
  
  
  proc normalize_path {FILEPATH} {
      if {[catch { package require fileutil } err]} { 
          return $FILEPATH 
      } 
      set path [fileutil::lexnormalize [file join [pwd] $FILEPATH]]  
      if {[file pathtype $FILEPATH] eq "relative"} { 
          set path [fileutil::relative [pwd] $path] 
      } 
      return $path 
  } 
  proc get_dpi_libraries {QSYS_SIMDIR} {
    set libraries [dict create]
    
    return $libraries
  }
  
}
