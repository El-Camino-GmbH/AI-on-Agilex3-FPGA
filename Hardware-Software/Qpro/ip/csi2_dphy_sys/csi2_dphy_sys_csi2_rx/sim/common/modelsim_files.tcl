
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
  
  proc get_common_design_files {QSYS_SIMDIR} {
    set design_files [dict create]
    dict set design_files "altera_common_sv_packages::mentor_intel_vab_common_pkg"         "-makelib altera_common_sv_packages \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_common_pkg.sv"]\"   -end"        
    dict set design_files "altera_common_sv_packages::mentor_intel_vab_axi_master"         "-makelib altera_common_sv_packages \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_axi_master.sv"]\"   -end"        
    dict set design_files "altera_common_sv_packages::mentor_intel_vab_axi_pipeline_stage" "-makelib altera_common_sv_packages \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_axi_pipeline_stage.sv"]\"   -end"
    dict set design_files "altera_common_sv_packages::mentor_intel_vvp_common_pkg"         "-makelib altera_common_sv_packages \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_ro_reg_servicer_2450/sim/mentor/intel_vvp_common_pkg.sv"]\"   -end"
    return $design_files
  }
  
  proc get_design_files {QSYS_SIMDIR QUARTUS_INSTALL_DIR} {
    set design_files [list]
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_ext_interlace_toggle.sv"]\"   -L altera_common_sv_packages -end"                                                      
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_pipelined_mux.sv"]\"   -L altera_common_sv_packages -end"                                                             
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_common_slave_interface.sv"]\"   -L altera_common_sv_packages -end"                                                    
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_flop_primitive.sv"]\"   -L altera_common_sv_packages -end"                                                            
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_synchronizer_flop.sv"]\"   -L altera_common_sv_packages -end"                                                         
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_clock_crosser.sv"]\"   -L altera_common_sv_packages -end"                                                             
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/intel_vab_csr_interrupt.sv"]\"   -L altera_common_sv_packages -end"                                                             
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_register_addresses.sv"]\"   -L altera_common_sv_packages -end"                                             
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_control.sv"]\"   -L altera_common_sv_packages -end"                                                        
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_core.sv"]\"   -L altera_common_sv_packages -end"                                                           
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_csr.sv"]\"   -L altera_common_sv_packages -end"                                                            
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_axi_st_output.sv"]\"   -L altera_common_sv_packages -end"                                                  
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_embedded_sync_extractor.sv"]\"   -L altera_common_sv_packages -end"                                        
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_fifo.sv"]\"   -L altera_common_sv_packages -end"                                                           
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_format_detection.sv"]\"   -L altera_common_sv_packages -end"                                               
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_pixel_deprication.sv"]\"   -L altera_common_sv_packages -end"                                              
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_resolution_detection.sv"]\"   -L altera_common_sv_packages -end"                                           
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_sample_counter.v"]\"   -L altera_common_sv_packages -end"                                                  
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_sdi_resampler.sv"]\"   -L altera_common_sv_packages -end"                                                  
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_sync_align.sv"]\"   -L altera_common_sv_packages -end"                                                     
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_sync_conditioner.sv"]\"   -L altera_common_sv_packages -end"                                               
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_sync_polarity_convertor.v"]\"   -L altera_common_sv_packages -end"                                         
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_vc_splitter.sv"]\"   -L altera_common_sv_packages -end"                                                    
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_write_buffer_fifo.sv"]\"   -L altera_common_sv_packages -end"                                              
    lappend design_files "-makelib intel_cv2axi_core_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_core_2140/sim/mentor/src_hdl/intel_cv2axi_aux_out.sv"]\"   -L altera_common_sv_packages -end"                                                        
    lappend design_files "-makelib altera_reset_controller_1924 \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1924/sim/altera_reset_controller.v"]\"   -end"                                                                                      
    lappend design_files "-makelib altera_reset_controller_1924 \"[normalize_path "$QSYS_SIMDIR/../altera_reset_controller_1924/sim/altera_reset_synchronizer.v"]\"   -end"                                                                                    
    lappend design_files "-makelib intel_vvp_ro_reg_servicer_2450 \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_ro_reg_servicer_2450/sim/mentor/src_hdl/intel_vvp_ro_reg_servicer.sv"]\"   -L altera_common_sv_packages -end"                                   
    lappend design_files "-makelib intel_vvp_ro_reg_servicer_2450 \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_ro_reg_servicer_2450/sim/csi2_dphy_sys_csi2_rx_intel_vvp_ro_reg_servicer_2450_jflcrey.sv"]\"   -L altera_common_sv_packages -end"               
    lappend design_files "-makelib intel_vvp_output_interface_bridge_2440 \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_output_interface_bridge_2440/sim/mentor/intel_vvp_axi_pipeline_stage.sv"]\"   -L altera_common_sv_packages -end"                        
    lappend design_files "-makelib intel_vvp_output_interface_bridge_2440 \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_output_interface_bridge_2440/sim/mentor/intel_vvp_axi_master.sv"]\"   -L altera_common_sv_packages -end"                                
    lappend design_files "-makelib intel_vvp_output_interface_bridge_2440 \"[normalize_path "$QSYS_SIMDIR/../intel_vvp_output_interface_bridge_2440/sim/mentor/src_hdl/intel_vvp_output_interface_bridge.sv"]\"   -L altera_common_sv_packages -end"           
    lappend design_files "-makelib altera_merlin_master_translator_193 \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_master_translator_193/sim/csi2_dphy_sys_csi2_rx_altera_merlin_master_translator_193_lgcew2q.sv"]\"   -L altera_common_sv_packages -end"
    lappend design_files "-makelib altera_merlin_slave_translator_191 \"[normalize_path "$QSYS_SIMDIR/../altera_merlin_slave_translator_191/sim/csi2_dphy_sys_csi2_rx_altera_merlin_slave_translator_191_xg7rzxi.sv"]\"   -L altera_common_sv_packages -end"   
    lappend design_files "-makelib altera_mm_interconnect_1920 \"[normalize_path "$QSYS_SIMDIR/../altera_mm_interconnect_1920/sim/csi2_dphy_sys_csi2_rx_altera_mm_interconnect_1920_xqcry6i.v"]\"   -end"                                                      
    lappend design_files "-makelib intel_cv2axi_2140 \"[normalize_path "$QSYS_SIMDIR/../intel_cv2axi_2140/sim/csi2_dphy_sys_csi2_rx_intel_cv2axi_2140_4mpbb4i.v"]\"   -end"                                                                                    
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/csi2_dphy_sys_csi2_rx_intel_mipi_csi2_intel_cv2axi_300_5fgsb2i.v"]\"   -end"                                                                 
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_pkg.sv"]\"   -L altera_common_sv_packages -end"                                                                               
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/vvp_pkg.sv"]\"   -L altera_common_sv_packages -end"                                                                                
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/axis_if.sv"]\"   -L altera_common_sv_packages -end"                                                                                
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/avalon_mm_if.sv"]\"   -L altera_common_sv_packages -end"                                                                           
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/vid_if.sv"]\"   -L altera_common_sv_packages -end"                                                                                 
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csi2_rx_csr.sv"]\"   -L altera_common_sv_packages -end"                                                                       
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csi2_rx_err_detect.sv"]\"   -L altera_common_sv_packages -end"                                                                
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_axis_fifo.sv"]\"   -L altera_common_sv_packages -end"                                                                         
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_cdc.sv"]\"   -L altera_common_sv_packages -end"                                                                               
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_common_slave_interface.sv"]\"   -L altera_common_sv_packages -end"                                                            
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_crc.sv"]\"   -L altera_common_sv_packages -end"                                                                               
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csr_ctrl_mux.sv"]\"   -L altera_common_sv_packages -end"                                                                      
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_csr_interrupt.sv"]\"   -L altera_common_sv_packages -end"                                                                     
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_dphy_ppi_if.sv"]\"   -L altera_common_sv_packages -end"                                                                       
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_ecc_parity_gen.sv"]\"   -L altera_common_sv_packages -end"                                                                    
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_ecc_syndrome_decoder.sv"]\"   -L altera_common_sv_packages -end"                                                              
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_fifo.sv"]\"   -L altera_common_sv_packages -end"                                                                              
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_packet_arbiter.sv"]\"   -L altera_common_sv_packages -end"                                                                    
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_pipelined_mux.sv"]\"   -L altera_common_sv_packages -end"                                                                     
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_pixel_barrel_shifter.sv"]\"   -L altera_common_sv_packages -end"                                                              
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_prbs_gen_lane.sv"]\"   -L altera_common_sv_packages -end"                                                                     
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_reset_sync.sv"]\"   -L altera_common_sv_packages -end"                                                                        
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_ro_reg_servicer.sv"]\"   -L altera_common_sv_packages -end"                                                                   
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_skid_buffer.sv"]\"   -L altera_common_sv_packages -end"                                                                       
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_vab_axi_master.sv"]\"   -L altera_common_sv_packages -end"                                                                    
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_vab_axi_pipeline_stage.sv"]\"   -L altera_common_sv_packages -end"                                                            
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_cv2axi_aux_out.sv"]\"   -L altera_common_sv_packages -end"                                                                    
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_byte_to_pixel_converter.sv"]\"   -L altera_common_sv_packages -end"                                                        
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_depacketizer.sv"]\"   -L altera_common_sv_packages -end"                                                                   
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_descrambler.sv"]\"   -L altera_common_sv_packages -end"                                                                    
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_ecc.sv"]\"   -L altera_common_sv_packages -end"                                                                            
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_lane_management.sv"]\"   -L altera_common_sv_packages -end"                                                                
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_ppi.sv"]\"   -L altera_common_sv_packages -end"                                                                            
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/intelfpga/mipi_rx_protocol.sv"]\"   -L altera_common_sv_packages -end"                                                                       
    lappend design_files "-makelib intel_mipi_csi2_300 \"[normalize_path "$QSYS_SIMDIR/../intel_mipi_csi2_300/sim/csi2_dphy_sys_csi2_rx_intel_mipi_csi2_300_75ibfmy.sv"]\"   -L altera_common_sv_packages -end"                                                
    lappend design_files "-makelib csi2_dphy_sys_csi2_rx \"[normalize_path "$QSYS_SIMDIR/csi2_dphy_sys_csi2_rx.v"]\"   -end"                                                                                                                                   
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
