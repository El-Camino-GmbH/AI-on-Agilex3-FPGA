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


set script_dir [file dirname [info script]]
source "$script_dir/csi2_dphy_sys_mipi_dphy_dphy_arch_fp_610_vgxsyya_timing_utils.tcl"

load_package sdc_ext

proc mipi_initialize_archinst_db { mipi_db mipi_inst_list module} {
    upvar $mipi_db local_mipi_db
    upvar $mipi_inst_list instance_list


   post_sdc_message info "Initializing  database for MIPI ARCH MODULE $module"
   set instance_list [mipi_get_core_instance_list $module]

   foreach instname $instance_list {

      post_sdc_message info "Finding port-to-pin mapping for MIPI ARCH MODULE: $module INSTANCE: $instname"

      set local_mipi_db($instname) [ array get allpins ]
   }
}

proc mipi_find_ioplls_from_wrap {hier module mipi_param_vals} {

    array set iopll_inst_arr {}
    array set this_mipi_param $mipi_param_vals
    set iopll_wrap_list [get_entity_instances $module]

    set instance_list [list]

    foreach inst $iopll_wrap_list {
	regsub -all {\W} $hier {\\&} e_hier
	regsub -all {\W} $inst {\\&} e_inst
	if {$::mipi_debug == 1}  {
	     post_message -type info "DEBUG MIPI SDC: escaped hier - $e_hier"
	}
	if { [regexp "$e_hier" $inst] } {
	    lappend instance_list $inst
	    if {$::mipi_debug == 1}  {
		post_message -type info "DEBUG MIPI SDC: Finding - $hier"
		post_message -type info "DEBUG MIPI SDC: Appending to IOPLL list - $inst"
	    }	    
	}
    }

    if {[llength $instance_list] == 0} {
	post_message -type error "PLL Setting Issue. NUM_PLL - $this_mipi_param(GUI_NUM_PLL). Cannot find hierarchy from IOPLL wrap list."
    }
    
    foreach inst $instance_list {

	    if { [regexp {arch\|.*pll_gen\[0\]} $inst] } {
		if [catch {set iopll_0_inst $inst|iopll_inst} result] {
		    post_message -type error "NO IOPLL inst inside: $inst"
		} else {
		    set iopll_inst_arr(arch_0) $iopll_0_inst
		}
	    } elseif {$this_mipi_param(GUI_NUM_PLL) == 2} {
		if { [regexp {arch\|.*pll_gen\[1\]} $inst] } {
		    if [catch {set iopll_1_inst $inst|iopll_inst} result] {
			post_message -type error "NO IOPLL inst inside: $inst"
		    } else {
			set iopll_inst_arr(arch_1) $iopll_1_inst
		    }
		} else {
		    post_message -type error "PLL Setting Issue. NUM_PLL: $this_mipi_param(GUI_NUM_PLL). No PLL_GEN[1] instance."
		}
	    } else {
		post_message -type error "PLL Setting Issue. NUM_PLL: $this_mipi_param(GUI_NUM_PLL). No PLL_GEN[0] instance."
	    }

    }
    
    return [array get iopll_inst_arr]
}


proc mipi_find_cpas_from_wrap {hier module mipi_param_vals} {
    
    array set iopll_inst_arr {}
    array set this_mipi_param $mipi_param_vals
    set iopll_wrap_list [get_entity_instances $module]

    set instance_list [list]

    foreach inst $iopll_wrap_list {
	regsub -all {\W} $hier {\\&} e_hier
	if {$::mipi_debug == 1}  {
	     post_message -type info "DEBUG MIPI SDC: escaped hier - $e_hier"
	}
	if { [regexp "$e_hier" $inst] } {
	    lappend instance_list $inst
	    if {$::mipi_debug == 1}  {
		post_message -type info "DEBUG MIPI SDC: Finding - $hier"
		post_message -type info "DEBUG MIPI SDC: Appending to CPA list - $inst"
	    }	    
	}
    }

    if {[llength $instance_list] == 0} {
	post_message -type error "CPA Setting Issue. NUM_PLL - $this_mipi_param(GUI_NUM_PLL). Cannot find hierarchy from CPA wrap list."
    }    

    foreach inst $instance_list {

	    if { [regexp {arch\|.*cpa_gen\[0\]} $inst] } {
		if [catch {set iopll_0_inst $inst|cpa_inst} result] {
		    post_message -type error "NO CPA inst inside: $inst"
		} else {
		    set iopll_inst_arr(arch_0) $iopll_0_inst
		}
	    } elseif {$this_mipi_param(GUI_NUM_PLL) == 2} {
		if { [regexp {arch\|.*cpa_gen\[1\]} $inst] } {
		    if [catch {set iopll_1_inst $inst|cpa_inst} result] {
			post_message -type error "NO CPA inst inside: $inst"
		    } else {
			set iopll_inst_arr(arch_1) $iopll_1_inst
		    }
		} else {
		    post_message -type error "PLL Setting Issue. NUM_PLL: $this_mipi_param(GUI_NUM_PLL). No CPA_GEN[1] instance."
		}
	    } else {
		post_message -type error "PLL Setting Issue. NUM_PLL: $this_mipi_param(GUI_NUM_PLL). No CPA_GEN[0] instance."
	    }

    }
    
    return [array get iopll_inst_arr]
}

proc mipi_find_fa_p2c_from_wrap {module mipi_param_vals} {
    
    array set fa_p2c_inst_arr {}
    array set this_mipi_param $mipi_param_vals
    set fa_p2c_wrap_list [get_entity_instances $module]

    set sorted_list [lsort -dic $fa_p2c_wrap_list]
    foreach inst $sorted_list {
	regexp {dphy_link\[([0-7]).*byte_in_link\[([0-1])} $inst -> link b_link
	set fa_p2c_inst_arr(${link}_${b_link}) $inst|fa_p2c_lane_inst
	
    }
    return [array get fa_p2c_inst_arr]
}

proc mipi_find_phy_adapt_from_wrap {module mipi_param_vals} {
    
    array set inst_arr {}
    array set this_mipi_param $mipi_param_vals
    set wrap_list [get_entity_instances $module]

    set sorted_list [lsort -dic $wrap_list]
    foreach inst $sorted_list {
	regexp {dphy_link\[([0-7]).*byte_in_link\[([0-1])} $inst -> link b_link
	set inst_arr(${link}_${b_link}) $inst|phy_adaptor_inst
	
    }
    return [array get inst_arr]
}

proc mipi_find_insts_from_wrap {hier module io_inst_name mipi_param_vals} {
    
    array set inst_arr {}
    array set this_mipi_param $mipi_param_vals
    set wrap_list [get_entity_instances $module]

    set instance_list [list]
    regsub -all {\W} $hier {\\&} e_hier
    
    set sorted_list [lsort -dic $wrap_list]
    foreach inst $sorted_list {
	set matched 0

	    if { [regexp "$e_hier" $inst] } {
		regexp {(arch)\|.*dphy_link\[([0-7]).*byte_in_link\[([0-1])} $inst -> dphyinst link b_link
		set matched 1
		if {$::mipi_debug == 1}  {
		    post_message -type info "DEBUG MIPI SDC: escaped hier - $e_hier"
		    post_message -type info "DEBUG MIPI SDC: inst - $inst"
		}		
	    }

	if {$matched} { set inst_arr(${dphyinst}_${link}_${b_link}) $inst|$io_inst_name }
    }
    return [array get inst_arr]
}

proc mipi_get_clock_pins {instname allpins rate var_array_name} {
   # We need to make a local copy of the allpins associative array
   upvar allpins pins
   upvar 1 $var_array_name var
   set debug 0

   set var(pll_inclock_search_depth) 30
   set var(pll_outclock_search_depth) 20
   set var(pll_vcoclock_search_depth) 5
 

   set pll_c0_periph_clock_pin_name     "out_clk_periph0";#"lvds_clk\[0\]"
   set pll_c1_periph_clock_pin_name     "out_clk_periph1";#"loaden\[0\]"
   set vco_clock_pin_name               "vco_clk\[0\]";#"vcoph\[0\]"
   set vco_periph_clock_pin_name        "vco_clk_periph"
   set pll_path                         "${instname}|arch_inst|phylite_clocking_inst|iopll_inst"

   # Find the ncntr register in the pll
   set pins(pll_ncntr) [list]
   set pins(pll_ncntr_reg_id) [get_registers ${pll_path}*ncntr_reg]

   foreach_in_collection r $pins(pll_ncntr_reg_id) {
      set reg_name [get_register_info -name $r]
      lappend pins(pll_ncntr) [regsub -all {\\} $reg_name {\\\\}]
   }
   set pins(pll_ncntr) [phylite_sort_duplicate_names $pins(pll_ncntr)]
 
   #  C0 output in the periphery
   set pins(pll_c0_periph_clock) [list]
   set pins(pll_c0_periph_reg) [list]
   set pins(pll_c0_periph_clock_pin_id) [get_pins -nowarn [list $pll_path*|$pll_c0_periph_clock_pin_name]]
 
   foreach_in_collection c $pins(pll_c0_periph_clock_pin_id) {
      set pin_info [get_pin_info -net $c]
      set net_name [get_net_info -name $pin_info]
 
      if {$debug} {
         puts "PLL pin -> PLL Net: [get_node_info -name $c] -> $net_name"
      }
      lappend pins(pll_c0_periph_clock) [regsub -all {\\} $net_name {\\\\}]
      array set creg_name [list]
      phylite_traverse_fanin_up_to_depth $net_name phylite_is_node_type_reg clock creg_name 2 
      lappend pins(pll_c0_periph_reg) [regsub -all {\\} [get_register_info -name [lindex [array names creg_name] 0]] {\\\\}]
      array unset creg_name
   }
   set pins(pll_c0_periph_clock) [phylite_sort_duplicate_names $pins(pll_c0_periph_clock)]
 
   #  C1 output in the periphery
   set pins(pll_c1_periph_clock) [list]
   set pins(pll_c1_periph_reg) [list]
   set pins(pll_c1_periph_clock_pin_id) [get_pins -nowarn [list $pll_path*|$pll_c1_periph_clock_pin_name]]
 
   foreach_in_collection c $pins(pll_c1_periph_clock_pin_id) {
      set pin_info [get_pin_info -net $c]
      set net_name [get_net_info -name $pin_info]
 
      if {$debug} {
         puts "PLL pin -> PLL Net: [get_node_info -name $c] -> $net_name"
      }
 
      lappend pins(pll_c1_periph_clock) [regsub -all {\\} $net_name {\\\\}]
      array set creg_name [list]
      phylite_traverse_fanin_up_to_depth $net_name phylite_is_node_type_reg clock creg_name 2 
      lappend pins(pll_c1_periph_reg) [regsub -all {\\} [get_register_info -name [lindex [array names creg_name] 0]] {\\\\}]
      array unset creg_name
   }
   set pins(pll_c1_periph_clock) [phylite_sort_duplicate_names $pins(pll_c1_periph_clock)]
 
   #  VCO clock (used for the system clock)
   set pins(vco_base_node) [list]
   set pins(vco_base_node_id) [get_nodes -nowarn [list ${pll_path}~vctrl]]
   
   foreach_in_collection n $pins(vco_base_node_id) {
      set net_name [get_node_info -name $n]
 
      if {$debug} {
         puts "PLL pin -> PLL Net: [get_node_info -name $n] -> $net_name"
      }
 
      lappend pins(vco_base_node) [regsub -all {\\} $net_name {\\\\}]
   }
   set pins(vco_clock) [list]
   set pins(vco_clock_pin_id) [get_pins -nowarn [list $pll_path*|$vco_clock_pin_name]]
 
   foreach_in_collection c $pins(vco_clock_pin_id) {
      set pin_info [get_pin_info -net $c]
      set net_name [get_net_info -name $pin_info]
 
      if {$debug} {
         puts "PLL pin -> PLL Net: [get_node_info -name $c] -> $net_name"
      }
 
      lappend pins(vco_clock) [regsub -all {\\} $net_name {\\\\}]
   }


   #  VCO periph clock (used for the system clock)
   set pins(vco_periph_clock) [list]
   set pins(vco_periph_clock_pin_id) [get_pins -nowarn [list $pll_path*|$vco_periph_clock_pin_name]]
 
   foreach_in_collection c $pins(vco_periph_clock_pin_id) {
      set pin_info [get_pin_info -net $c]
      set net_name [get_net_info -name $pin_info]
 
      if {$debug} {
         puts "PLL pin -> PLL Net: [get_node_info -name $c] -> $net_name"
      }
 
      lappend pins(vco_periph_clock) [regsub -all {\\} $net_name {\\\\}]
   }

   set pins(vco_periph_clock) [phylite_sort_duplicate_names $pins(vco_periph_clock)]
   set pins(pll_vco_clock) $pins(vco_clock)
   set pins(pll_phy_clock) $pins(pll_c0_periph_clock)
   set pins(pll_phy_clock_sync) $pins(pll_c1_periph_clock)
   set pins(pll_vco_periph_clock) $pins(vco_periph_clock)
   set pins(pll_phy_reg) $pins(pll_c0_periph_reg)
   set pins(pll_phy_reg_sync) $pins(pll_c1_periph_reg)
 
   if {$debug == 1} {
     puts "VCO:           $pins(pll_vco_clock)"
     puts "PHY:           $pins(pll_phy_clock)"
     puts "PHY_SYNC:      $pins(pll_phy_clock_sync)"
     puts ""
   }
 
   #########################################
   # 2.0  Find the actual master core clock
   #      As it could come from another interface
   #      In master/slave configurations
   #
   
   set pins(master_vco_clock) ""
   set pins(master_vco_clock_sec) ""
   set pins(master_core_usr_clock) ""
   set pins(master_core_usr_half_clock) ""
   set pins(master_core_usr_clock_sec) ""
   set pins(master_core_usr_half_clock_sec) ""
   set pins(master_core_afi_clock) ""
   set pins(master_core_dft_cpa_1_clock) ""
   set pins(master_cal_master_clk) ""
   set pins(master_cal_slave_clk) ""
   
      #  CPA Clock
      set pins(cpa_clock) [list]
      set pins(cpa_clock_pin_id) [get_pins -nowarn [list ${instname}|arch_inst|phylite_clocking_inst|cpa_inst|o_core_clk_out]]
 
      foreach_in_collection c $pins(cpa_clock_pin_id) {
         set pin_info [get_pin_info -net $c]
         set net_name [get_net_info -name $pin_info]
 
         if {$debug} {
            puts "CPA pin -> CPA Net: [get_node_info -name $c] -> $net_name"
         }
 
         lappend pins(cpa_clock) [regsub -all {\\} $net_name {\\\\}]
    }
     
   # ########################################
   #  2.5 Find the reference clock input of the PLL
 
   set pins(pll_refclk_in) [get_pins -compatibility_mode ${pll_path}|ref_clk0]
   set pll_ref_clock_id [phylite_get_input_clk_id $pins(pll_refclk_in) var]
   if {$pll_ref_clock_id == -1} {
      post_message -type critical_warning "phylite_pin_map.tcl: Failed to find PLL reference clock"
   } else {
      set pll_ref_clock [get_node_info -name $pll_ref_clock_id]
   }
   set pins(pll_ref_clock) $pll_ref_clock
 
   if {$debug == 1} {
     puts "REF:     $pins(pll_ref_clock)"
     puts ""
   }
 
   #########################################
   # 3.0  find the FPGA pins

   # The hierarchy paths to all the pins are stored in the *_ip_parameters.tcl
   # file which is a generated file. Pins are divided into the following
   # protocol-agnostic categories. For each pin category, we need to
   # fully-resolve the hierarchy path patterns and store the results into
   # the "pins" arrays.
   #Taken from altera_phylite instead of emif_ph2

   set num_grps $var(PHYLITE_NUM_GROUPS)
   for {set i_grp_idx 0} {$i_grp_idx < $num_grps} {incr i_grp_idx} {
      set pin_categories [list rclk,$i_grp_idx \
                               rclk_n,$i_grp_idx \
                               wclk,$i_grp_idx \
                               wclk_n,$i_grp_idx \
                               rdata,$i_grp_idx \
                               wdata,$i_grp_idx ]

      set patterns [ list ]
      foreach pin_category $pin_categories {
         set pins($pin_category) [list]

         foreach pattern $var(PATTERNS_[string toupper $pin_category]) {
            set pattern "${instname}|$pattern"
            lappend patterns $pin_category $pattern
         }
      }

      foreach {pin_type pattern} $patterns { 
         if {($pin_type == "rdata,$i_grp_idx") || ($pin_type == "rclk,$i_grp_idx") || ($pin_type == "rclk_n,$i_grp_idx")} {
            set local_pins [ phylite_get_names_in_collection [ get_fanins $pattern ] ]
         } else {
            set local_pins [ phylite_get_names_in_collection [ get_fanouts $pattern ] ]
         }

         if {[llength $local_pins] == 0} {
            post_message -type critical_warning "Could not find pin of type $pin_type from pattern $pattern"
         } else {
            foreach pin [lsort -unique $local_pins] {
               lappend pins($pin_type) $pin
            }
         }
      }
   }

}
