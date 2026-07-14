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


set corename "axi2cv_core"

# ***************
# Set False Path
# ***************
# The only synchronizer that the 'from' path is outside of the core
#set_false_path -to [get_keepers {*mgmt_rst_sync*|g_synchronizer_flop[*].u_synchronizer_flop|gen_flop_primitive[0].u_flop_primitive|out_data} -nowarn]

if {[get_collection_size [get_keepers {*|g_synchronizer_flop[*].u_synchronizer_flop|gen_flop_primitive[0].u_flop_primitive|out_data} -nowarn]] > 0} {
   set_false_path -to [get_keepers {*|g_synchronizer_flop[*].u_synchronizer_flop|gen_flop_primitive[0].u_flop_primitive|out_data} -nowarn]
}

if {[get_collection_size [get_keepers {*rst_vid_clk*} -nowarn]] > 0} {
   set_false_path -from * -to [get_keepers {*rst_vid_clk*} -nowarn]
}

if {[get_collection_size [get_keepers {*rst_mgmt_clk*} -nowarn]] > 0} {
   set_false_path -from * -to [get_keepers {*rst_mgmt_clk*} -nowarn]
}

if {[get_collection_size [get_keepers {*input_fifo*|auto_generated|rdaclr*} -nowarn]] > 0} {
   set_false_path -from * -to [get_keepers {*input_fifo*|auto_generated|rdaclr*} -nowarn]
}

if {[get_collection_size [get_keepers {*sdi_resampler*|auto_generated|rdaclr*} -nowarn]] > 0} {
   set_false_path -from * -to [get_keepers {*sdi_resampler*|auto_generated|rdaclr*} -nowarn]
}

if {[get_collection_size [get_keepers {*mipi_axi_in*|auto_generated|rdaclr*} -nowarn]] > 0} {
   set_false_path -from [get_keepers {*mipi_axi_in|fifo_rst} -nowarn] -to [get_keepers {*mipi_axi_in*|auto_generated|rdaclr*} -nowarn]
}

# ***************************
# Constraints for DCFIFO sdc
#****************************
#
# top-level sdc
# convention for module sdc apply_sdc_<module_name>
#
proc apply_sdc_dcfifo {hier_path} {
# gray_rdptr
#u_msgdatain doesn't have a read to write path
if {[string first "u_msgdatain" $hier_path] == -1} {
   apply_sdc_dcfifo_rdptr $hier_path
}
# gray_wrptr
apply_sdc_dcfifo_wrptr $hier_path
}
#
# common constraint setting proc
#
proc apply_sdc_dcfifo_for_ptrs {from_node_list to_node_list} {
# control skew for bits
set_max_skew -from $from_node_list -to $to_node_list -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
# path delay (exception for net delay)
if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
set_net_delay -from $from_node_list -to $to_node_list -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
}
#relax setup and hold calculation
set_max_delay -from $from_node_list -to $to_node_list 100
set_min_delay -from $from_node_list -to $to_node_list -100
}
#
# mstable propgation delay
#
proc apply_sdc_dcfifo_mstable_delay {from_node_list to_node_list} {
# mstable delay
if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
set_net_delay -from $from_node_list -to $to_node_list -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
}
}
#
# rdptr constraints
#
proc apply_sdc_dcfifo_rdptr {hier_path} {
# get from and to list
set from_node_list [get_keepers $hier_path|auto_generated|*rdptr_g* -nowarn]
set to_node_list [get_keepers $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe* -nowarn]
if {[get_collection_size $from_node_list] > 0 && [get_collection_size $to_node_list] > 0} {
   apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
}
# mstable
set from_node_mstable_list [get_keepers $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe* -nowarn]
set to_node_mstable_list [get_keepers $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe* -nowarn]
if {[get_collection_size $from_node_mstable_list] > 0 && [get_collection_size $to_node_mstable_list] > 0} {
   apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}
}
#
# wrptr constraints
#
proc apply_sdc_dcfifo_wrptr {hier_path} {
# control skew for bits
set from_node_list [get_keepers $hier_path|auto_generated|delayed_wrptr_g* -nowarn]
set to_node_list [get_keepers $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe* -nowarn]
if {[get_collection_size $from_node_list] > 0 && [get_collection_size $to_node_list] > 0} {
   apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
}
# mstable
set from_node_mstable_list [get_keepers $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe* -nowarn]
set to_node_mstable_list [get_keepers $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe* -nowarn]
if {[get_collection_size $from_node_mstable_list] > 0 && [get_collection_size $to_node_mstable_list] > 0} {
   apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}
}

proc apply_sdc_pre_dcfifo {entity_name} {
   set inst_list [get_entity_instances $entity_name]
   set current_instance [get_current_instance]
   foreach each_inst $inst_list {
       if {[string first $current_instance $each_inst] != -1} {
           #remove the front part of the string, as get_keeper of SDC_ENTITY_FILE will concat the instance name automatically to all queries
           regsub ***=${current_instance}| $each_inst "" each_inst
           apply_sdc_dcfifo $each_inst
       }
   }
}

apply_sdc_pre_dcfifo dcfifo
#apply_sdc_pre_dcfifo dcfifo_mixed_widths
