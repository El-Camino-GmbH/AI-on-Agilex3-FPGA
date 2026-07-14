# (C) 2001-2025 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


#####################################################################
#
# THIS IS AN AUTO-GENERATED FILE!
# -------------------------------
# If you modify this files, all your changes will be lost if you
# regenerate the core!
#
# FILE DESCRIPTION
# ----------------
# This file specifies the timing constraints of the memory device and
# of the memory interface

# NOTE!!!: Assumes if MIRRORED IP is used, used for RX IP

##########################################################################################

# Debug switch. Change to 1 to get more run-time debug information
set ::mipi_debug 0

# ------------------------------------------- #
# -                                         - #
# --- Some useful functions and variables --- #
# -                                         - #
# ------------------------------------------- #

 
set script_dir [file dirname [info script]]
source "$script_dir/csi2_dphy_sys_mipi_dphy_dphy_arch_fp_610_vgxsyya_timing_parameters.tcl"
source "$script_dir/csi2_dphy_sys_mipi_dphy_dphy_arch_fp_610_vgxsyya_timing_pins.tcl"

set module csi2_dphy_sys_mipi_dphy_dphy_arch_fp_610_vgxsyya

#--------------------------------------------#
# -                                        - #
# --- Determine when SDC is being loaded --- #
# -                                        - #
#--------------------------------------------#

set syn_flow 0
set sta_flow 0
set fit_flow 0
set pow_flow 0
if { $::TimeQuestInfo(nameofexecutable) == "quartus_map" || $::TimeQuestInfo(nameofexecutable) == "quartus_syn" } {
   set syn_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_sta" } {
   set sta_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_fit" } {
   set fit_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_pow" } {
   set pow_flow 1
}
set ::io_only_analysis 0
 
# ------------------------ #
# -                      - #
# --- GENERAL SETTINGS --- #
# -                      - #
# ------------------------ #
 
# This is a global setting and will apply to the whole design.
# This setting is required for the memory interface to be
# properly constrained.
derive_clock_uncertainty
 
# All timing requirements will be represented in nanoseconds with up to 3 decimal places of precision
set_time_format -unit ns -decimal_places 3

# -------------------------------------------------------------------- #
# -                                                                  - #
# --- This is the main call to the netlist traversal routines      --- #
# --- that will automatically find all pins and registers required --- #
# --- to apply timing constraints.                                 --- #
# --- During the fitter, the routines will be called only once     --- #
# --- and cached data will be used in all subsequent calls.        --- #
# -                                                                  - #
# -------------------------------------------------------------------- #
 
mipi_initialize_archinst_db mipi_archinst_db mipi_archinst_list $module

if { ! [array exists mipi_sdc]} {
   array set mipi_sdc {}
   set instcnt 0
   if { $::mipi_debug } { 
      set sdc_pass 0
   }
}

set not_uniq_SDC 0

set is_reva $mipi_param(IS_REVA)
# --- EXPECTING 1 instance only per l unique MIPI IP
# --- advised for USER to create 1 IP per instance
# --- USER may still possibly copy created IP, and use it on multiple instances
# --- NEED TO UPDATE if that's a possible case scenario

# --- START OF foreach instname $mipi_archinst_list

foreach instname $mipi_archinst_list {
	if { $not_uniq_SDC } {
	   post_message -type info  "MIPI SDC INFO: file re-applied to another instance."
	}
	if { ! [ info exists mipi_sdc($instname) ] } {
   	   post_message -type info "MIPI SDC INFO: Applying SDC module: $module on $::TimeQuestInfo(nameofexecutable) on instance: $instname"
   	   set mipi_sdc($instname) mipi_u${instcnt}
   	   incr instcnt
	   set not_uniq_SDC 1
	} else {
   	  post_message -type info "MIPI SDC INFO: Re-using SDC module: $module on $::TimeQuestInfo(nameofexecutable) on instance: $instname"
	}
	
# --- END OF foreach instname $mipi_archinst_list
# --- if single ip FOR MULTIPLE INSTS is not allowed
# --- REMOVE COMMENTED BRACKETS as they are still PAIRED!


set U_MIPI $mipi_sdc($instname)

set mipi_inst $instname

if {($mipi_param(EX_DESIGN_GEN_SYNTH) eq "true")} {
   regsub {\|dphy\|dphy} $mipi_inst "" dut_hier
   if {($mipi_param(EX_DESIGN_SYNTH_MIRROR) eq "true") && [regexp {\|dphy_m\|dphy_m} $mipi_inst]} {
      regsub {\|dphy_m\|dphy_m} $mipi_inst "" dut_hier   
   }
   if { $::mipi_debug } { post_message -type info "DEBUG MIPI SDC: DUT HIER: $dut_hier" }
}

if { $::mipi_debug } {
   incr sdc_pass
   post_message -type info "DEBUG MIPI SDC: SDC FILE READ : $sdc_pass"
   post_message -type info "DEBUG MIPI SDC: mipi_inst: $instname"
   post_message -type info "DEBUG MIPI SDC: U_MIPI prefix: $U_MIPI"
}


# ----------------------- #
# -                     - #
# --  False Path delay -- #
# -                     - #
# ----------------------- #
#use set_max_delay during syn/route on paths deemed false paths


proc apply_delay_on_fp {sta_on from_coll to_coll path_delay} {
     set min_path_delay [expr (-1*${path_delay})]
     if {[is_post_route]} {
     	set_false_path -from ${from_coll} -to ${to_coll}
     } else {
	set_max_delay ${path_delay} -from ${from_coll} -to ${to_coll}
     	set_min_delay ${min_path_delay} -from ${from_coll} -to ${to_coll}
     }
}
proc apply_delay_on_fp_2 {sta_on from_coll to_coll path_delay} {
     set min_path_delay [expr (-1*${path_delay})]
     if {[is_post_route]} {
     	set_false_path -from ${from_coll} -to ${to_coll}
     } else {
	set_max_delay ${path_delay} -from ${from_coll} -to ${to_coll}
     	set_min_delay ${min_path_delay} -from ${from_coll} -to ${to_coll}
     }
}
proc apply_delay_to_fp {sta_on to_coll path_delay} {
     set min_path_delay [expr (-1*${path_delay})]
     if {[is_post_route]} {
     	set_false_path -to ${to_coll}
     } else {
     	set_max_delay ${path_delay} -to ${to_coll}
     	set_min_delay ${min_path_delay} -to ${to_coll}
     }
}
proc apply_delay_from_pseudo_fp {sta_on from_coll path_delay} {
     set min_path_delay [expr (-1*${path_delay})]
     if {[is_post_route]} {
     	set_false_path -from ${from_coll} -no_synchronizer
     } else {
     	set_max_delay ${path_delay} -from ${from_coll}
     	set_min_delay ${min_path_delay} -from ${from_coll}
     }
}

proc apply_delay_on_pseudo_fp {from_coll to_coll path_delay} {
     set min_path_delay [expr (-1*${path_delay})]
     if {[is_post_route]} {
     	set_false_path -from ${from_coll} -to ${to_coll}
     } else {
	set_max_delay ${path_delay} -from ${from_coll} -to ${to_coll}
     	set_min_delay ${min_path_delay} -from ${from_coll} -to ${to_coll}
     }
}

proc apply_delay_from_fp {sta_on from_coll path_delay} {
     set min_path_delay [expr (-1*${path_delay})]
     if {[is_post_route]} {
     	set_false_path -from ${from_coll}
     } else {
     	set_max_delay ${path_delay} -from ${from_coll}
     	set_min_delay ${min_path_delay} -from ${from_coll}
     }
}
proc apply_delay_to_async_rst_synchro {sta_on to_coll path_delay} {
     if {[is_post_route]} {
     	set_false_path -to ${to_coll}
     } else {
     	set_max_delay ${path_delay} -to ${to_coll}
     }
}

proc apply_delay_on_synched_dbus {from_coll to_coll max_path_delay min_path_delay} {
    set_max_delay ${max_path_delay} -from ${from_coll} -to ${to_coll}
    set_min_delay ${min_path_delay} -from ${from_coll} -to ${to_coll}     
}

proc apply_maxmin_on_multi {from_coll to_coll max_path_delay min_path_delay} {
    set_max_delay ${max_path_delay} -from ${from_coll} -to ${to_coll}
    set_min_delay ${min_path_delay} -from ${from_coll} -to ${to_coll}     
}


proc find_driving_async_port {pin_id} {
     set mipi_async_port ""
     set mipi_port_id [mipi_get_input_port_id $pin_id asynch]
     if {$mipi_port_id == -1} {
     	post_message -type critical_warning "Failed to find MIPI driving async port input"
     } else {
	 set mipi_async_port [get_node_info -name $mipi_port_id]
     }
     return $mipi_async_port
}

# ----------------------- #
# -                     - #
# --- OverConstrain   --- #
# -  up to Fit Route    - #
# -                     - #
# ----------------------- #

if {[is_post_route]} {
set ovc_factor 1.000
} else {
set ovc_factor 0.900
}


# ----------------------- #
# -                     - #
# --- REFERENCE CLOCK --- #
# -                     - #
# ----------------------- #

# get IOPLL instance list using dphy_iopll_wrap

array set mipi_iopll_inst {}
array set mipi_iopll_inst [mipi_find_ioplls_from_wrap $mipi_inst dphy_iopll_wrap [array get mipi_param]]

set hier_used "arch"

for {set i 0} {$i < $mipi_param(GUI_NUM_PLL)} {incr i} {
   if { ($i == 0) || ($mipi_param(GUI_REF_CLK_IO_SHARE) ne "true") } {
      set ref_clk_period_ns($i) [mipi_hz_to_ns $mipi_param(DER_REF_CLK_FREQ_${i})]
      set ovc_ref_clk_period_ns [format {%0.3f} [expr { $ref_clk_period_ns($i) * $ovc_factor }]]
      set ref_clk_src($i) [get_ports [find_driving_async_port [get_pins $mipi_iopll_inst(${hier_used}_${i})|ref_clk0]]]
      create_clock -period $ovc_ref_clk_period_ns -name ${U_MIPI}_REF_CLK_${i} $ref_clk_src($i)
      if { $::mipi_debug } {
         post_message -type info "DEBUG MIPI SDC: NUM_PLL - $mipi_param(GUI_NUM_PLL)"
         post_message -type info "DEBUG MIPI SDC: mipi_param(DER_REF_CLK_FREQ_${i}) - $mipi_param(DER_REF_CLK_FREQ_${i})"
         post_message -type info "DEBUG MIPI SDC: period(ns) - $ref_clk_period_ns($i)"
	 post_message -type info "DEBUG MIPI SDC: target - $mipi_iopll_inst(${hier_used}_${i})|ref_clk0"
      }
   } else {
      set ref_clk_src(1) $ref_clk_src(0)
   }
}

# ----------------------- #
# -                     - #
# ---  IOPLL CLOCKs   --- #
# -                     - #
# ----------------------- #

# MIPI only use N (divider) = 1 or 8

for {set i 0} {$i < $mipi_param(GUI_NUM_PLL)} {incr i} {
   if { ($mipi_param(GUI_REF_CLK_IO_SHARE) ne "true") } {
      set ref_clk_mhz($i) $mipi_param(GUI_REF_CLK_FREQ_MHZ_${i})
   } else {
      set ref_clk_mhz($i) $mipi_param(GUI_REF_CLK_FREQ_MHZ_0)
   }
   set M1_real($i) [expr $mipi_param(GUI_VCO_FREQ_MHZ_${i}) / $ref_clk_mhz($i)]
   set M1_int($i)  [expr {int($mipi_param(GUI_VCO_FREQ_MHZ_${i}) / $ref_clk_mhz($i))}]

   set M8_real($i) [expr (8*$mipi_param(GUI_VCO_FREQ_MHZ_${i})) / $ref_clk_mhz($i)]
   set M8_int($i)  [expr {int((8*$mipi_param(GUI_VCO_FREQ_MHZ_${i})) / $ref_clk_mhz($i))}]

   if {($M1_real($i) != $M1_int($i)) && ($M8_real($i) != $M8_int($i))} {
      post_message -type error "MIPI SDC INFO: (PARAM_ERROR) REF_CLK_${i}- M and N for clock dividers should be both integers."
      post_message -type error "MIPI SDC INFO: (PARAM_ERROR) REF_CLK_${i}- M1_R: $M1_real($i) M1_I: $M1_int($i) M8_R: $M8_real($i)l M8_I: $M8_int($i)"
      post_message -type error "MIPI SDC INFO: (PARAM_ERROR) REF_CLK_${i}- VCO(MHz): $mipi_param(GUI_VCO_FREQ_MHZ_${i}) REF (MHz): ref_clk_mhz($i)"
   } else {
      if {$M1_real($i) == $M1_int($i)} {
         set PLL_M($i)  $M1_int($i)
         set PLL_N($i)  1
      } else {
         set PLL_M($i)  $M8_int($i)
         set PLL_N($i)  8
         set pll_ncntr_reg [get_keepers $mipi_iopll_inst(${hier_used}_${i})~ncntr_reg]
         create_generated_clock -source  $ref_clk_src($i) -name ${U_MIPI}_PLL_NCNTR_${i} $pll_ncntr_reg
         set ref_clk_src($i) $pll_ncntr_reg
      }
   }
}

# get IOPLL instance list using dphy_iopll_wrap




for {set i 0} {$i < $mipi_param(GUI_NUM_PLL)} {incr i} {
   create_generated_clock -multiply_by $PLL_M($i) -divide_by $PLL_N($i) -source  $ref_clk_src($i) -name ${U_MIPI}_PLL_VCO_CLK_${i} [get_pins $mipi_iopll_inst(${hier_used}_${i})|vco_clk_periph]
   create_generated_clock -multiply_by $PLL_M($i) -divide_by $PLL_N($i) -source  $ref_clk_src($i) -name ${U_MIPI}_PLL_VCO_CPA_CLK_${i} [get_pins $mipi_iopll_inst(${hier_used}_${i})|vco_clk[0]]
   create_generated_clock -multiply_by $PLL_M($i) -divide_by [expr $PLL_N($i)*2] -source $ref_clk_src($i) -name ${U_MIPI}_PHY_CLK_${i} [get_pins $mipi_iopll_inst(${hier_used}_${i})|out_clk_periph0]
   create_generated_clock -multiply_by $PLL_M($i) -divide_by [expr $PLL_N($i)*128] -source $ref_clk_src($i) -name ${U_MIPI}_PHY_CLK_SYNC_${i} [get_pins $mipi_iopll_inst(${hier_used}_${i})|out_clk_periph1]

   if { $::mipi_debug } {
      post_message -type info "DEBUG MIPI SDC: VCO_CLK pin - $mipi_iopll_inst(${hier_used}_${i})|vco_clk_periph"
      post_message -type info "DEBUG MIPI SDC: CPA_CLK pin - $mipi_iopll_inst(${hier_used}_${i})|vco_clk[0]"
   }
}

set max_links 8

# ----------------------- #
# -                     - #
# ---  CPA CLOCKs     --- #
# -                     - #
# ----------------------- #

array set mipi_cpa_inst {}
array set mipi_cpa_inst [mipi_find_cpas_from_wrap $mipi_inst dphy_cpa_wrap [array get mipi_param]]

for {set i 0} {$i < $mipi_param(GUI_NUM_PLL)} {incr i} {
   create_generated_clock -divide_by $mipi_param(GUI_CORE_CLK_DIV_${i}) -source [get_pins $mipi_iopll_inst(${hier_used}_${i})|vco_clk[0]] -name ${U_MIPI}_CORE_CLK_${i} [get_pins $mipi_cpa_inst(${hier_used}_${i})|o_core_clk_out]
}




# ------------------------------ #
# -                            - #
# ---  Other Periph CLKs     --- #
# -                            - #
# ------------------------------ #
# -                ARRAY PATERN               - #
# ---  IO_BLK_INST_ARR($LINK_$BYTE_in_LINK) --- #
# -                                           - #

array set mipi_fa_c2p_inst [mipi_find_insts_from_wrap $mipi_inst dphy_fa_c2p_lane_wrap fa_c2p_lane_inst [array get mipi_param]]
array set mipi_byte_inst [mipi_find_insts_from_wrap $mipi_inst dphy_byte_wrap byte_inst [array get mipi_param]]

array set mipi_fa_p2c_inst [mipi_find_insts_from_wrap $mipi_inst dphy_fa_p2c_lane_wrap fa_p2c_lane_inst [array get mipi_param]]
array set mipi_phy_adapt_inst [mipi_find_insts_from_wrap $mipi_inst dphy_phy_adaptor_wrap phy_adaptor_inst [array get mipi_param]]
array set mipi_byte_ctrl_inst [mipi_find_insts_from_wrap $mipi_inst dphy_byte_control_wrap byte_control_inst [array get mipi_param]]

for {set i 0} {$i < $max_links} {incr i} {
   if { ($mipi_param(DER_LINK_USED_${i}) eq "true") } {
      
      set src_pll $mipi_param(GUI_SOURCE_PLL_${i})
      if {$mipi_param(DER_RX_PPI_WIDTH_16_C2P_${i}) eq "true"} {
      	 set rx_dphy_io_cp_period_ns($i) [mipi_hz_to_ns [expr (8*$mipi_param(DER_RX_CORE_FREQ_${i}))]]
      } else {
         set rx_dphy_io_cp_period_ns($i) [mipi_hz_to_ns [expr (4*$mipi_param(DER_RX_CORE_FREQ_${i}))]]
      }
    
    if { ($is_reva eq "true") || ($mipi_sys_param(SYS_INFO_DEVICE_IOBANK_REVISION) eq "IO96B_REVB0") } {
        set FA_PHYCLK_DIV 2
    } else {
        set FA_PHYCLK_DIV 4
    }
    
      create_generated_clock -divide_by $FA_PHYCLK_DIV -name ${U_MIPI}_FA_CLK_${i}_BYTE_0 -source [get_pins $mipi_iopll_inst(${hier_used}_${src_pll})|out_clk_periph0] [get_keepers $mipi_fa_c2p_inst(${hier_used}_${i}_0)~div_reg]
      create_generated_clock -divide_by 2 -name ${U_MIPI}_PA_CLK_${i}_BYTE_0 -source [get_pins $mipi_iopll_inst(${hier_used}_${src_pll})|out_clk_periph0] $mipi_phy_adapt_inst(${hier_used}_${i}_0)|i_phy_clk_hr
      if {$mipi_param(GUI_NUM_LANES_${i})==8} {
        create_generated_clock -divide_by $FA_PHYCLK_DIV -name ${U_MIPI}_FA_CLK_${i}_BYTE_1 -source [get_pins $mipi_iopll_inst(${hier_used}_${src_pll})|out_clk_periph0] [get_keepers $mipi_fa_c2p_inst(${hier_used}_${i}_1)~div_reg]
	    create_generated_clock -divide_by 2 -name ${U_MIPI}_PA_CLK_${i}_BYTE_1 -source [get_pins $mipi_iopll_inst(${hier_used}_${src_pll})|out_clk_periph0] $mipi_phy_adapt_inst(${hier_used}_${i}_1)|i_phy_clk_hr
      }

      
      if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 1)} {
      	 set rx_byte_clk_period_ns($i) [expr ($rx_dphy_io_cp_period_ns($i)/2)]

      	 if {$is_reva == "true"} {
      	 }

      	 if {$mipi_param(GUI_NUM_LANES_${i})==8} {
         	 if {$is_reva == "true"} {
         	 }
      	 }

      }
   }
}


#
# UNIQUE instance
# This is a slow clock (core_clk/1024), just use reg[0] of clock divider
#

# only 1 instance of this per IP
set clk_rst_inst [lindex [get_entity_instances dphy_clk_rst_blk] 0]




# ------------        ----------- #
# -                             - #
# ---  TX ESC CLKs            --- #
# -                             - #
# ------------        ----------- #


for {set i 0} {$i < $max_links} {incr i} {
   if { ($mipi_param(DER_LINK_USED_${i}) eq "true") } {
      if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 1)} {
      	 set src_pll $mipi_param(GUI_SOURCE_PLL_${i})
      	 set esc_clk_reg($i) [get_registers ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[$i].dphy_link_used.dphy_pcs|dphy_tx.dphy_pcs_tx|pcs_clk_tx|esc_clk]
      	 create_generated_clock -divide_by $mipi_param(DER_TX_LPX_MIN_${i}) -source [get_pins $mipi_cpa_inst(${hier_used}_${src_pll})|o_core_clk_out] -name ${U_MIPI}_ESC_CLK_${i} $esc_clk_reg($i)
      }
   }
}

# ------------------------- #
# -                       - #
# ---  MIPI FWD/RX CLKs --- #
# -                       - #
# ------------------------- #
# -                ARRAY PATERN               - #
# ---  IO_BLK_INST_ARR($LINK_$BYTE_in_LINK) --- #
# -                                           - #


# - Target sample paths of wrappers
# - dut|dphy|dphy|arch|dphy_inst|dphy_core_inst|dphy_link[0].dphy_link_used.io_blk_inst|byte_in_link[0].fa_p2c_lane_wrap_inst
# - dut|dphy|dphy|arch|dphy_inst|dphy_core_inst|dphy_link[1].dphy_link_used.io_blk_inst|byte_in_link[0].fa_p2c_lane_wrap_inst

for {set i 0} {$i < $max_links} {incr i} {

   if {($mipi_param(DER_LINK_USED_${i}) eq "true") && ($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 0)} {

      if {$mipi_param(GUI_NUM_LANES_${i})==8} {
      	set rx_cp_port "${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.io_blk_inst|byte_in_link[0].byte_wrap_inst|byte_inst|o_from_phy_rx_x16dqsp_p4"
      } else {
      	set rx_cp_port "${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.io_blk_inst|byte_in_link[0].byte_wrap_inst|byte_inst|o_phy_rx_dqs_p4"
      }

      set dphyinst ${hier_used}



      if {$mipi_param(DER_RX_PPI_WIDTH_16_C2P_${i}) eq "true"} {
      	 set rx_dphy_io_cp_period_ns($i) [mipi_hz_to_ns [expr (8*$mipi_param(DER_RX_CORE_FREQ_${i}))]]
	 set fa_p2c_divider 2
	 set mipi_fwd_clk_src_byte_0($i) [get_keepers $mipi_fa_p2c_inst(${dphyinst}_${i}_0)~lane_mipi_div_reg]
	 if {$mipi_param(GUI_NUM_LANES_${i})==8} {
	    set mipi_fwd_clk_src_byte_1($i) [get_keepers $mipi_fa_p2c_inst(${dphyinst}_${i}_1)~lane_mipi_div_reg]
	 }
      } else {
         set rx_dphy_io_cp_period_ns($i) [mipi_hz_to_ns [expr (4*$mipi_param(DER_RX_CORE_FREQ_${i}))]]
	 set fa_p2c_divider 1
	 set mipi_fwd_clk_src_byte_0($i) [get_pins $mipi_fa_p2c_inst(${dphyinst}_${i}_0)|i_mipi_fwd_clk]
	 if {$mipi_param(GUI_NUM_LANES_${i})==8} {
	    set mipi_fwd_clk_src_byte_1($i) [get_pins $mipi_fa_p2c_inst(${dphyinst}_${i}_1)|i_mipi_fwd_clk]
	 }
      }

      set ovc_rx_dphy_io_cp_period_ns [format {%0.3f} [expr { $rx_dphy_io_cp_period_ns($i) * $ovc_factor }]]
      create_clock -name ${U_MIPI}_RX_DPHY_IP_CP_LINK_${i} -period $ovc_rx_dphy_io_cp_period_ns [get_pins $rx_cp_port]
      
      if {${sta_flow}} {
      }

      create_generated_clock -name ${U_MIPI}_RX_DQSN_${i}_BYTE_0 -divide_by 2 -source [get_pins $rx_cp_port] [get_keepers $mipi_byte_inst(${dphyinst}_${i}_0)~dqsn0_0_reg__nff]

      if {$is_reva == "true"} {
      	create_generated_clock -name ${U_MIPI}_RX_PA_CLK${i}_BYTE_0 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_0)~dqsn0_0_reg__nff] [get_keepers $mipi_phy_adapt_inst(${dphyinst}_${i}_0)~rxfwd_reg]
	    create_generated_clock -name ${U_MIPI}_RX_PA_FWDCLK${i}_BYTE_0 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_0)~dqsn0_0_reg__nff] [get_pins $mipi_phy_adapt_inst(${dphyinst}_${i}_0)|o_rxfwd_clk]
      } else {
      	create_generated_clock -name ${U_MIPI}_RX_PA_CLK${i}_BYTE_0 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_0)~dqsn0_0_reg__nff] [get_keepers $mipi_phy_adapt_inst(${dphyinst}_${i}_0)~rxfwd_reg]
	    create_generated_clock -name ${U_MIPI}_RX_PA_FWDCLK${i}_BYTE_0 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_0)~dqsn0_0_reg__nff] [get_pins $mipi_phy_adapt_inst(${dphyinst}_${i}_0)|o_rxfwd_clk]
      }

      
      create_generated_clock -name ${U_MIPI}_MIPI_FWD_CLK_${i}_BYTE_0 -divide_by $fa_p2c_divider -source [get_pins $mipi_phy_adapt_inst(${dphyinst}_${i}_0)|o_rxfwd_clk] $mipi_fwd_clk_src_byte_0($i)
	 
      if {$mipi_param(GUI_NUM_LANES_${i})==8} {
	 create_generated_clock -name ${U_MIPI}_RX_DQSN_${i}_BYTE_1 -divide_by 2 -source [get_pins $rx_cp_port] [get_keepers $mipi_byte_inst(${dphyinst}_${i}_1)~dqsn0_0_reg__nff]
	 
    	if {$is_reva == "true"} {
	 	create_generated_clock -name ${U_MIPI}_RX_PA_CLK${i}_BYTE_1 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_1)~dqsn0_0_reg__nff] [get_keepers $mipi_phy_adapt_inst(${dphyinst}_${i}_1)~rxfwd_reg]
		create_generated_clock -name ${U_MIPI}_RX_PA_FWDCLK${i}_BYTE_1 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_1)~dqsn0_0_reg__nff] [get_pins $mipi_phy_adapt_inst(${dphyinst}_${i}_1)|o_rxfwd_clk]
   	} else {
      		create_generated_clock -name ${U_MIPI}_RX_PA_CLK${i}_BYTE_1 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_1)~dqsn0_0_reg__nff] [get_keepers $mipi_phy_adapt_inst(${dphyinst}_${i}_1)~rxfwd_reg]
		create_generated_clock -name ${U_MIPI}_RX_PA_FWDCLK${i}_BYTE_1 -divide_by 2 -source [get_keepers $mipi_byte_inst(${dphyinst}_${i}_1)~dqsn0_0_reg__nff] [get_pins $mipi_phy_adapt_inst(${dphyinst}_${i}_1)|o_rxfwd_clk]
   	}

	 
	 create_generated_clock -name ${U_MIPI}_MIPI_FWD_CLK_${i}_BYTE_1 -divide_by $fa_p2c_divider -source  [get_pins $mipi_phy_adapt_inst(${dphyinst}_${i}_1)|o_rxfwd_clk] $mipi_fwd_clk_src_byte_1($i)

      }




   }
}


# --------------------------------------------------- #
# -                                                 - #
# ---  C2P_CTRLs (gpio_dout_sel) - select signals --- #
# -    modeled as CLOCKs on timing LIB              - #
# -    to check arrival against gpio_dout           - #
# -                                                 - #
# --------------------------------------------------- #
#  This is to ensure latencies within IO12 between gpio_dout and gpio_dout_sel somehow matches
#  NOTE: gpio_dout is stable for at least 60ns (Tclk-trail, longer for Ths-trail) before gpio_dout_sel switches HS-LP
#  NOTE: gpio_dout is stable for at least 38ns (Tclk-prepare, longer for Thx-prepare) before gpio_dout_sel switches LP-HS
#  should use multicycle 0 to check if  gpio_dout and gpio_dout_sel delays match (timing check gpio_dout_sel is faster by around 0.692ns) - timing check will fail
#  USE multicycle 1 to PASS on timing, gpio_dout is stable anyway (above info) before gpio_dout_sel switches. Adjust timing Ttrail and Tprepare to make sure it's within specs

set GPIO_SEL_PER [mipi_hz_to_ns 20000000]

set mipi_core_hipi_inst_list [get_entity_instances dphy_full_byte_hipi_intf]

for {set i 0} {$i < $max_links} {incr i} {

   if {($mipi_param(DER_LINK_USED_${i}) eq "true")} {
      set src_pll $mipi_param(GUI_SOURCE_PLL_${i})

      set hipi_intf_exist 0
      set hipi_inst_hier ""
      set match_inst "dphy_core_inst\\\|dphy_link\\\[$i\\\].dphy_link_used.io_hipi_intf_inst"

      regsub -all {\W} $mipi_inst {\\&} e_hier
      
      foreach link $mipi_core_hipi_inst_list {
	 if { [regexp "$e_hier" $link] } {
	    if [regexp $match_inst $link] {
	       set hipi_intf_exist 1
	       set hipi_inst_hier $link
	    }
	 }
      }

      if {$hipi_intf_exist == 0} {
	  puts $out_fh "${match_inst}_MISSING"
	  post_message -type error "MIPI SDC INFO: EXPECTED MIPI HIPI instance is missing: ${hipi_inst_hier}"
	  continue
      } else {
	  set numbytes [expr (($mipi_param(GUI_NUM_LANES_${i})/8) + 1)]
	  if {$mipi_param(GUI_NUM_LANES_${i}) == 8} {
	     set bytepairs [expr $mipi_param(GUI_NUM_LANES_${i})/2]
	  } else {
	     set bytepairs $mipi_param(GUI_NUM_LANES_${i})
	  }

	  set max_bytepairs 4

	  for {set bytenum 0} {$bytenum < $numbytes} {incr bytenum} {

	     if {$bytenum == 0} {
		create_generated_clock -divide_by 2 -source [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[12].c2p_ctrl_hipi_ff|clk] -name ${U_MIPI}_CLK_SEL_${i} [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[12].c2p_ctrl_hipi_ff|q]
		apply_maxmin_on_multi [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}] [get_clocks ${U_MIPI}_CLK_SEL_${i}] [expr 1*[get_clock_info -period [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]]] [expr -1*[get_clock_info -period [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]]]
	     }

	     set j [expr (12 + ($bytenum * 20)) ]

	     for {set pair 0} {$pair < $max_bytepairs} {incr pair} {
	     	 if {$pair < 2} {
		    set j [expr (($pair+18) + ($bytenum * 20)) ]
		    if {$pair < $bytepairs} {
		       create_generated_clock -divide_by 2  -source [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|clk] -name ${U_MIPI}_DATA_SEL_${i}_${bytenum}_${pair} [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|q]
		    }
                 }
		 if {$pair == 2} {
		    set j [expr (13 + ($bytenum * 20)) ]
		    if {$pair < $bytepairs} {
		       create_generated_clock -divide_by 2  -source [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|clk] -name ${U_MIPI}_DATA_SEL_${i}_${bytenum}_${pair} [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|q]
		    }
		 }
		 if {$pair == 3} {
		    set j [expr (14 + ($bytenum * 20)) ]
		    if {$pair < $bytepairs} {
		       create_generated_clock -divide_by 2 -source [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|clk] -name ${U_MIPI}_DATA_SEL_${i}_${bytenum}_${pair} [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|q]
		    }
		 }
		 if {$pair < $bytepairs} {
		    apply_maxmin_on_multi [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}] [get_clocks ${U_MIPI}_DATA_SEL_${i}_${bytenum}_${pair}] [expr 1*[get_clock_info -period [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]]] [expr -1*[get_clock_info -period [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]]]
		 }
      	     }

	     for {set c2p_ctrl_bit 0} {$c2p_ctrl_bit < 8} {incr c2p_ctrl_bit} {
	     	 set j [expr ($c2p_ctrl_bit + ($bytenum * 20)) ]
		 apply_delay_on_fp_2 $sta_flow [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|clk] [get_keepers $mipi_fa_c2p_inst(${hier_used}_${i}_${bytenum})~lane_periph_fa_reg] [expr 1*[get_clock_info -period [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]]]
		 if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 1) && (($c2p_ctrl_bit < 4)||($c2p_ctrl_bit > 5))} {
		    set_data_delay -from ${U_MIPI}_ESC_CLK_${i} -to [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|d] -get_value_from_clock_period dst_clock_period -value_multiplier 1
		    set_false_path -from ${U_MIPI}_ESC_CLK_${i} -to [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|d]
		 }
	     }
	     for {set c2p_ctrl_bit 15} {$c2p_ctrl_bit < 18} {incr c2p_ctrl_bit} {
	     	 set j [expr ($c2p_ctrl_bit + ($bytenum * 20)) ]
		 apply_delay_on_fp_2 $sta_flow [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|clk] [get_keepers $mipi_fa_c2p_inst(${hier_used}_${i}_${bytenum})~lane_periph_fa_reg] [expr 1*[get_clock_info -period [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]]]
		 if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 1) && ($c2p_ctrl_bit > 15)} {
		    set_data_delay -from ${U_MIPI}_ESC_CLK_${i} -to [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|d] -get_value_from_clock_period dst_clock_period -value_multiplier 1
		    set_false_path -from ${U_MIPI}_ESC_CLK_${i} -to [get_pins ${hipi_inst_hier}|byte_in_link[$bytenum].c2p_ctrl_hipi_inst[$j].c2p_ctrl_hipi_ff|d]
		 }
	     }

	     if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 1)} {
	     	for {set c2p_ctrl_bit 8} {$c2p_ctrl_bit < 12} {incr c2p_ctrl_bit} {
	     	    set j [expr ($c2p_ctrl_bit + ($bytenum * 20)) ]
	     	}
	     }
      	  }
      }
   }
}


    # ------------------------- #
    # -      additional       - #
    # --- CLOCK UNCERTAINTY --- #
    # -                       - #
    # ------------------------- #




    # ------------------------- #
    # -                       - #
    # ---    EXCEPTIONS     --- #
    # -                       - #
    # ------------------------- #


set false_path_delay [expr ([get_clock_info -period mipi_u0_CORE_CLK_0]) * 1]

for {set i 0} {$i < $mipi_param(GUI_NUM_PLL)} {incr i} {
    set pll_lock($i) [get_pins $mipi_iopll_inst(${hier_used}_${i})|lock]
    set_max_delay ${false_path_delay} -through $pll_lock($i)
    set_min_delay [expr (-1*${false_path_delay})] -through $pll_lock($i)
}

    # ------------------------- #
    # -                       - #
    # ---    EXCEPTIONS     --- #
    # -                       - #
    # ------------------------- #
    
for {set i 0} {$i < $max_links} {incr i} {
   if {($mipi_param(DER_LINK_USED_${i}) eq "true") && ($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 0)} {
   
    apply_maxmin_on_multi [get_keepers *.fa_p2c_lane_wrap_inst|fa_p2c_lane_inst~lane_mipi_reg] [get_keepers *.dphy_rx_hipi_intf.p2c_hipi_inst[*].p2c_hipi_ff] 0 [expr -1*[get_clock_info -period [get_clocks ${U_MIPI}_MIPI_FWD_CLK_${i}_BYTE_0]]]

   }
}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_tx.dphy_pcs_tx|dphy_pcs_dlanes[*].pcs_data_tx|hs_data_gen|*_cdc|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_tx.dphy_pcs_tx|dphy_pcs_dlanes[*].pcs_data_tx|esc_req_sync|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_tx.dphy_pcs_tx|pcs_clk_tx|*_fr_sync|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_tx.dphy_pcs_tx|pcs_clk_tx|*_esc_sync|din_s1] ${false_path_delay}
    
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*|cdc_sync|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*_cdc|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*_cdc|cdc_sync_ack|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*pcs_data_rx|cdc_sync_*|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*pcs_data_rx|timing_blk|cdc_sync_*|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*pcs_clk_rx|*cdc_sync_*|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*pcs_clk_rx|timing_blk|*cdc_*|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*|grey_cnt_sync[*].cdc_sync_clk_valid_fr|din_s1] ${false_path_delay}
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_regfile_ins|*_rx_cal_reg_ctrl_cal_reset_cdc|din_s1] ${false_path_delay}
    
    apply_delay_from_pseudo_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_regfile_ins|dphy_regfile_ins|reg_*] [expr (2*${false_path_delay})]
    apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_regfile_ins|dphy_regfile_ins|dout*] ${false_path_delay}
    
    
    apply_delay_to_async_rst_synchro $sta_flow [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|clk_rst|clk_rst_mux[*].cdc_async_rst|*|clrn] ${false_path_delay}
    apply_delay_to_async_rst_synchro $sta_flow [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|rst_sync[*].cdc_async_rst_rx|*|clrn] ${false_path_delay}
    apply_delay_to_async_rst_synchro $sta_flow [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|timing_blk|cdc_async_rst_rx_fr|*|clrn] ${false_path_delay}
    apply_delay_to_async_rst_synchro $sta_flow [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_regfile_ins|dphy_reg_rst_sync_*.cdc_async_regrst*|*|clrn] ${false_path_delay}
    apply_delay_to_async_rst_synchro $sta_flow [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_tx.dphy_pcs_tx|pcs_clk_tx|esc_rst_sync|*|clrn] ${false_path_delay}

    for {set i 0} {$i < $max_links} {incr i} {
        if {($mipi_param(DER_LINK_USED_${i}) eq "true")} {
    	    if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 0)} {
	            if {($mipi_param(GUI_SKEW_CAL_EN_${i}) eq "true")} {	      
		            apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*pcs_data_rx|cal_fsm.pcs_cal_rx|*_sync|din_s1] ${false_path_delay}
    		        apply_delay_to_async_rst_synchro $sta_flow [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[*].pcs_data_rx|cal_fsm.pcs_cal_rx|clr_rx_cal_reg_ctrl_cal_reset_cdc|*|clrn] ${false_path_delay}
                    if {($mipi_param(GUI_ALT_CAL_EN_${i}) eq "true")} {
                        apply_delay_to_fp $sta_flow [get_keepers *|arch|dphy_inst|dphy_core_inst|dphy_link[*].dphy_link_used.dphy_pcs|*pcs_data_rx|cal_fsm.pcs_cal_rx|skew_cal|*_cdc|din_s1] ${false_path_delay}
                    } 
   	            }    
    	    }
    	}
    }


    if {($mipi_param(EX_DESIGN_GEN_SYNTH) eq "true") && ($mipi_param(EX_DESIGN_USE_TG) eq "true")} {

        apply_delay_to_fp $sta_flow [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|*_cdc|din_s1] ${false_path_delay}
        apply_delay_from_pseudo_fp $sta_flow [get_keepers *tg.tg_inst|test_ctrl_reg[*]] ${false_path_delay}
        apply_delay_on_fp $sta_flow [get_clocks ${U_MIPI}_MIPI_FWD_CLK_*] [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|reg_dout_top_async*] ${false_path_delay}

        for {set i 0} {$i < $max_links} {incr i} {
            if {($mipi_param(DER_LINK_USED_${i}) eq "true")} {
	            if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 1)} {
	      	        set src_pll $mipi_param(GUI_SOURCE_PLL_${i})
	      	        set TX_CORE_CLK [get_clock_info -name [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]]

		            apply_delay_from_pseudo_fp $sta_flow [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|reg_file|reg_word[*].reg_data[*]] [expr (2*${false_path_delay})]

		            apply_delay_on_pseudo_fp [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_lane_num_sync[*]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|ulps_req_q[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)]
		            apply_delay_on_pseudo_fp [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_lane_num_sync_q[*]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|ulps_req_q[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)]
		            apply_delay_on_pseudo_fp [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_enable_sync[*]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|ulps_req_q[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)]
		            apply_delay_on_pseudo_fp [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_enable_sync_q[*]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|ulps_req_q[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)]
		            apply_delay_on_pseudo_fp [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|init_cdc|dreg[1]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|ulps_req_q[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)] 
		            apply_delay_on_pseudo_fp [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|init_done_cdc|dreg[1]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|ulps_req_q[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)] 

		            apply_delay_to_fp $sta_flow [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|*_cdc|din_s1] ${false_path_delay}


		            apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|arst_esc_cdc|*|clrn] ${false_path_delay}
		            apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|int_arst_synchro|*|clrn] ${false_path_delay}

		            apply_delay_on_synched_dbus [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_sm_q.*] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_sm_esc.*] [expr ([get_clock_info -period $TX_CORE_CLK]*3)] [expr (-3*[get_clock_info -period $TX_CORE_CLK])]
		            apply_delay_on_synched_dbus [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|Stopstate_q[*]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|Stopstate_esc[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)] [expr (-3*[get_clock_info -period $TX_CORE_CLK])]
		            apply_delay_on_synched_dbus [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_enable_sync[*]] [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_tg.ppi_gen|test_enable_esc[*]] [expr ([get_clock_info -period $TX_CORE_CLK]*3)] [expr (-3*[get_clock_info -period $TX_CORE_CLK])]

	            }
	            if {($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 0)} {

                    apply_delay_from_pseudo_fp $sta_flow [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|csr_data_ovrd_retime[*]] [expr (2*${false_path_delay})]
                    apply_delay_from_pseudo_fp $sta_flow [get_keepers ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|dlane[*].csr_hs_data_retime[*]] [expr (2*${false_path_delay})]
                    apply_delay_to_fp $sta_flow [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|*ppi_checker.ppi_chkr|te_cdc*_cdc*|din_s1] ${false_path_delay}
       	            apply_delay_to_fp $sta_flow [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|*ppi_checker.ppi_chkr|tln_cdc*_rx_cdc*|din_s1] ${false_path_delay}
                    apply_delay_to_fp $sta_flow [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|*ppi_checker.ppi_chkr|init_core_cdc*|din_s1] ${false_path_delay}
    
                    apply_delay_on_fp $sta_flow [get_keepers *.ppi_checker.ppi_chkr|reg_file|reg_word[*].reg_data*] [get_clocks ${U_MIPI}_*MIPI_FWD_CLK_*] ${false_path_delay}
       	            apply_delay_on_fp $sta_flow [get_clocks ${U_MIPI}_MIPI_FWD_CLK_*] [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[*].ppi_checker.ppi_chkr|reg_file|reg_dout_async*] ${false_path_delay}

                    if {$mipi_param(GUI_NUM_PLL) > 1} {
                        set clk_launch [get_clock_info -name [get_clocks -of_objects *|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|lp_trigger_tst_cnt[*]|clk]]
                        set clk_latch [get_clock_info -name [get_clocks -of_objects *|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|reg_file|reg_dout_async[*]|clk]]
                        set clk_latch_top [get_clock_info -name [get_clocks -of_objects *|dphy_ppi_tg_inst|tg.tg_inst|reg_dout_top_async[*]|clk]]

                        if {![string equal $clk_launch $clk_latch]} {
                            set_false_path -from [get_clocks $clk_launch] -to [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|reg_file|reg_dout_async*]
                        }

                        if {![string equal $clk_launch $clk_latch_top]} {
                            set_false_path -from [get_clocks $clk_launch] -to [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|reg_dout_top_async*]
                        }

                        set clk_launch2 [get_clock_info -name [get_clocks -of_objects *|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|reg_file|reg_word[*].reg_data[*]|clk]]
                        set clk_latch2 [get_clock_info -name [get_clocks -of_objects *|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|lpdt_err_sticky|clk]]

                        if {![string equal $clk_launch2 $clk_latch2]} {
                            set_false_path -from [get_keepers *|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|reg_file|reg_word[*].reg_data*] -to [get_clocks $clk_latch2]
                        }
                    }
    
                    apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|stop_cdc[*].stop_core_cdc|dreg[*]|clrn] ${false_path_delay}
       	            apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|init_rx_cdc_0|dreg[*]|clrn] ${false_path_delay}
       	            apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|init_rx_cdc_0|din_s1|clrn] ${false_path_delay}
                    apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|arst_rx_cdc_0|din_s1|clrn] ${false_path_delay}
       	            apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|arst_rx_cdc_0|dreg[*]|clrn] ${false_path_delay}
       	            if {$mipi_param(GUI_NUM_LANES_${i}) == 8} {
       	                apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|arst_rx_cdc_1|din_s1|clrn] ${false_path_delay}
       	                apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|arst_rx_cdc_1|dreg[*]|clrn] ${false_path_delay}
       	                apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|init_rx_cdc_1|dreg[*]|clrn] ${false_path_delay}
                        apply_delay_to_async_rst_synchro $sta_flow [get_pins ${dut_hier}|tg*|tg*|dphy_ppi_tg_inst|tg.tg_inst|PPI_RTL.ppi_agents[${i}].ppi_checker.ppi_chkr|init_rx_cdc_1|din_s1|clrn] ${false_path_delay}
       		        }    
	            }
	        }
	    }
    }   




    # ----------------------------------------------------------------------------------------------------------------------
    # -      More DBUS constraining
    # ----------------------------------------------------------------------------------------------------------------------



    # ---  Virtual RX ESC CLKs    --- #


    for {set i 0} {$i < $max_links} {incr i} {
	    if {($mipi_param(DER_LINK_USED_${i}) eq "true") && ($mipi_param(GUI_DPHY_IP_ROLE_${i}) == 0)} {
	        set src_pll $mipi_param(GUI_SOURCE_PLL_${i})
	
	        set RX_CORE_CLK [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]
	        set RX_FWD_CLK [get_clocks ${U_MIPI}_MIPI_FWD_CLK_${i}_BYTE_0]
	
            if {($mipi_param(GUI_SKEW_CAL_EN_${i}) eq "true")} {
   	            apply_delay_on_synched_dbus [get_keepers *dphy_link[${i}]*dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[*].pcs_data_rx|cal_fsm.pcs_cal_rx|shadow_delay_reg[*]] [get_keepers *dphy_link[${i}]*dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[*].pcs_data_rx|cal_fsm.pcs_cal_rx|del_reg_fr[*]] [expr ([get_clock_info -period $RX_CORE_CLK]*1.5)] [expr (-1*[get_clock_info -period $RX_CORE_CLK])]
            }

            if {($mipi_param(GUI_SKEW_CAL_EN_${i}) eq "true")} {
    	        apply_delay_on_synched_dbus [get_keepers *dphy_link[${i}]*dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|timing_blk|skip_cnt_fr[*]] [get_keepers *dphy_link[${i}]*dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|timing_blk|skip_cnt_rx[*]] [get_clock_info -period $RX_FWD_CLK] [expr (-1*[get_clock_info -period $RX_FWD_CLK])]
            }



            create_clock -add -name V_${U_MIPI}_ESC_CLK_${i} -period 50
            if {[is_post_route]} {
                set_false_path -from [get_clocks V_${U_MIPI}_ESC_CLK_${i}] -to [get_clocks ${U_MIPI}_RX_DPHY_IP_CP_LINK_${i}]
                set_false_path -from [get_clocks V_${U_MIPI}_ESC_CLK_${i}] -to [get_clocks ${U_MIPI}_CORE_CLK_${src_pll}]
            }

            set DPHYIO_SIP 12
            if {$mipi_param(DER_RX_FR_CLK_FREQ_${i}) >= 93750000} {
                set DPHYIO_SIP_termen 11.5
            } else {
                set DPHYIO_SIP_termen 13
            }
            set rx_io_clk_pair [list]

            lappend rx_io_clk_pair [find_driving_async_port [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|cdc_sync_lp_p_fr|din_s1|d]]
            lappend rx_io_clk_pair [find_driving_async_port [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|cdc_sync_lp_n_fr|din_s1|d]]
            set num_ports [llength $rx_io_clk_pair]
            if {$num_ports == 2} {
                set_input_delay 0 -source_latency_included -clock [get_clocks V_${U_MIPI}_ESC_CLK_${i}] [get_ports $rx_io_clk_pair]
                set_data_delay -from [get_ports $rx_io_clk_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|cdc_sync_lp_*_fr|din_s1] $DPHYIO_SIP
                set_max_skew   -from [get_ports $rx_io_clk_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|cdc_sync_lp_*_fr|din_s1] -get_skew_value_from_clock_period dst_clock_period -skew_value_multiplier 1.0
                if {$mipi_param(DER_RX_FR_CLK_FREQ_${i}) >= 93750000} {
                    set_data_delay -from [get_ports $rx_io_clk_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|pcs_clk_rx|rx_clk_lp_n_q1] $DPHYIO_SIP_termen
                } else {
                    set_data_delay -from [get_ports $rx_io_clk_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.io_hipi_intf_inst|byte_in_link[*].c2p_ctrl_hipi_inst[*].c2p_ctrl_hipi_ff] $DPHYIO_SIP_termen
                }
            } else {
                post_message -type warning "${dut_hier} MIPI RX IO CLK PAIR on LINK ${i} constrain check has less than 2 ports ($num_ports)..."
            }

            for {set dlane 0} {$dlane < $mipi_param(GUI_NUM_LANES_${i})} {incr dlane} {
                set rx_io_d_pair [list]
                lappend rx_io_d_pair  [find_driving_async_port  [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[$dlane].pcs_data_rx|cdc_sync_lp_p_fr|din_s1|d]]
                lappend rx_io_d_pair  [find_driving_async_port  [get_pins ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[$dlane].pcs_data_rx|cdc_sync_lp_n_fr|din_s1|d]]
                set num_ports [llength $rx_io_d_pair]
                puts $rx_io_d_pair
                if {$num_ports == 2} {
                    set_input_delay 0 -source_latency_included -clock [get_clocks V_${U_MIPI}_ESC_CLK_${i}] [get_ports $rx_io_d_pair]
                    set_data_delay -from [get_ports $rx_io_d_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[$dlane].pcs_data_rx|cdc_sync_lp_*_fr|din_s1] $DPHYIO_SIP
                    set_max_skew   -from [get_ports $rx_io_d_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[$dlane].pcs_data_rx|cdc_sync_lp_*_fr|din_s1] -get_skew_value_from_clock_period dst_clock_period -skew_value_multiplier 1.0
                    set_data_delay -from [get_ports $rx_io_d_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[$dlane].pcs_data_rx|rx_data_lp_11*] $DPHYIO_SIP
                    if {$mipi_param(DER_RX_FR_CLK_FREQ_${i}) >= 93750000} {
                        set_data_delay -from [get_ports $rx_io_d_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.dphy_pcs|dphy_rx.dphy_pcs_rx|dphy_pcs_dlanes[$dlane].pcs_data_rx|rx_data_lp_n_q1] $DPHYIO_SIP_termen
                    } else {
                        set_data_delay -from [get_ports $rx_io_d_pair] -to [get_keepers  ${mipi_inst}|arch|dphy_inst|dphy_core_inst|dphy_link[${i}].dphy_link_used.io_hipi_intf_inst|byte_in_link[*].c2p_ctrl_hipi_inst[*].c2p_ctrl_hipi_ff] $DPHYIO_SIP_termen
                    }
   	            } else {
                    post_message -type warning "${dut_hier} MIPI RX IO D PAIR $dlane on LINK ${i} constrain check has less than 2 ports ($num_ports)..."
                }
            }
    
        }
    }


    # ------------------------- #
    # -      TEMPORARY        - #
    # ---    EXCEPTIONS     --- #
    # ------------------------- #


    

    # ----------------------------------------------------------------------------------------------------------------------
    # -      NOTE! - for FIXING!                   
    # ---    TEMPORARY FALSE PATHS, remove when arcs are fixed
    # -      Remove to check timing on other paths
    # ----------------------------------------------------------------------------------------------------------------------
   

if { $::mipi_debug } {
   post_message -type info "DEBUG MIPI SDC: SDC FILE READ DONE!"
   post_message -type info "DEBUG MIPI SDC: mipi_inst: $instname"
   post_message -type info "DEBUG MIPI SDC: U_MIPI prefix: $U_MIPI"
}

# ---  END OF foreach instname $mipi_archinst_list
# ---  BRACKET MOVED AT THE END OF SDC FILE
# ---  TO TAKE CARE OF MULTIPLE INSTANCES OF THE SAME MIPI IP (LOOP NOT TESTED/NOT WORKING YET)
}
