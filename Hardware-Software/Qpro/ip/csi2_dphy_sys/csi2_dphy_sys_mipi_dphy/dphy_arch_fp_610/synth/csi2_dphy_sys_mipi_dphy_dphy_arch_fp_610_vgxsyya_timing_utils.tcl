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

load_package sdc_ext
load_package design

proc post_sdc_message {msg_type msg} {
    global ::io_only_analysis
    global ::mipi_debug

    if {($::mipi_debug == 1) || ($::io_only_analysis == 1) || $::TimeQuestInfo(nameofexecutable) != "quartus_fit"} {
	post_message -type info "DEBUG TimeQuestInfo: $::TimeQuestInfo(nameofexecutable)"
	post_message -type $msg_type $msg
    }
}


proc mipi_round_3dp { x } {
   return [expr { round($x * 1000) / 1000.0  } ]
}

proc mipi_hz_to_ns { x } {
   return [mipi_round_3dp [expr { 1e9 / $x  }]]
}

proc mipi_find_insts_from_entity {module} {
    
    array set inst_arr {}
    set inst_list [get_entity_instances $module]

    foreach inst $inst_list {
       puts "$inst"
    }
}

proc mipi_get_core_instance_list {module} {
   global ::io_only_analysis
   global ::mipi_debug
   
   if {$::io_only_analysis == 1}  {
      set instance_list [list $module]

   } else {
      set full_instance_list [mipi_get_core_full_instance_list $module]
      set instance_list [list]

       foreach inst $full_instance_list {
	   if {$::mipi_debug == 1}  {
	       post_message -type info "DEBUG INST: $inst"
	   }
	   set sta_name $inst
	   if {[lsearch $instance_list [escape_brackets $sta_name]] == -1} {
	       	   if {$::mipi_debug == 1}  {
		       post_message -type info "DEBUG APPEND TO LIST: $sta_name"
		   }
	       lappend instance_list $sta_name
	   }
       }

   }
   return $instance_list
}

proc mipi_get_core_full_instance_list {module} {

   set instance_list [list]
   global ::mipi_debug

   if {[is_fitter_in_qhd_mode]} {
      set instance_list_pre [design::get_instances -entity $module]

   } else {
      set instance_list_pre [get_entity_instances $module]
   }

   foreach instance $instance_list_pre {      
       regsub {\|arch$} $instance "" instance_no_arch
       lappend instance_list $instance_no_arch
       if {$::mipi_debug == 1}  {
	   post_message -type info "DEBUG MIPI INST: $instance"
	   post_message -type info "DEBUG MIPI INST (ARCH top instantiation): $instance_no_arch"	   
       }
   }

   if {[ llength $instance_list ] == 0} {
      post_message -type error "The auto-constraining script was not able to detect any instance for core < $module >"
      post_message -type error "Make sure the core < $module > is instantiated within another component (wrapper)"
      post_message -type error "and it's not the top-level for your project"
   }

   return $instance_list
}

proc mipi_traverse_fanin_up_to_depth { node_id match_command edge_type results_array_name depth} {
   upvar 1 $results_array_name results
   global ::mipi_debug

   if {$depth < 0} {
      post_message -type error "Internal error: Bad timing netlist search depth for MIPI traverse path check."
   }
   set fanin_edges [get_node_info -${edge_type}_edges $node_id]
   set number_of_fanin_edges [llength $fanin_edges]
   for {set i 0} {$i != $number_of_fanin_edges} {incr i} {
      set fanin_edge [lindex $fanin_edges $i]
      set fanin_id [get_edge_info -src $fanin_edge]
      if {$match_command == "" || [eval $match_command $fanin_id] != 0} {
         set results($fanin_id) 1
         if { $::mipi_debug } {puts "traverse: [get_node_info -name $fanin_id]"}
      } elseif {$depth == 0} {
         if { $::mipi_debug } {puts "DEPTH is 0"}
      } else {
         if { $::mipi_debug } {puts "NEXT traverse. Depth is [expr {$depth - 1}]"}
         if { $::mipi_debug } {puts [get_node_info -name $fanin_id]}
         mipi_traverse_fanin_up_to_depth $fanin_id $match_command $edge_type results [expr {$depth - 1}]
      }
   }
}

proc mipi_is_node_type_port { node_id } {
   set node_type [get_node_info -type $node_id]
   if {$node_type == "port"} {
      set result 1
   } else {
      set result 0
   }
   return $result
}

proc mipi_get_input_port_id { pin_input_id edge_type} {

   array set results_array [list]
   set depth 50
   global ::mipi_debug

   mipi_traverse_fanin_up_to_depth $pin_input_id mipi_is_node_type_port $edge_type results_array $depth
   if {[array size results_array] == 1} {
      set pin_id [lindex [array names results_array] 0]
      set result $pin_id
      if { $::mipi_debug } {puts "found input: [get_node_info $result -name]"}
   } else {
      post_message -type critical_warning "Could not find Input Port for [get_node_info -name $pin_input_id]"
      set result -1
   }

   return $result
}



proc find_driving_src {drive_path} {
     set drive_src ""
     set path_col [get_path -through $drive_path -npath 1]
     foreach_in_collection p $path_col {
          set drive_src [get_node_info -name [get_path_info -from $p]]
     	  if {[get_node_info -type [get_path_info -from $p]] ne "port"} {
	     post_message -type warning "MIPI GPIO_DIN source is not a port. Check RX Asynchronous IO ports if constained properly."
	     return $drive_src
	  }
     }
      return $drive_src
}
