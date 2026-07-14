package require qsys

set_module_property NAME                irq_pulse_counter
set_module_property DISPLAY_NAME        "IRQ Pulse Counter"
set_module_property VERSION             1.0
set_module_property GROUP               "Custom IP"
set_module_property DESCRIPTION         "Counts clock cycles between IRQ edges"
set_module_property AUTHOR              "Your Name"

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL irq_pulse_counter
add_fileset_file irq_pulse_counter.vhd VHDL PATH irq_pulse_counter.vhd

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL irq_pulse_counter
add_fileset_file irq_pulse_counter.vhd VHDL PATH irq_pulse_counter.vhd

# Clock
add_interface clk clock end
set_interface_property clk clockRate 0
add_interface_port clk clk clk Input 1

# Reset
add_interface reset reset end
set_interface_property reset associatedClock  clk
set_interface_property reset synchronousEdges DEASSERT
add_interface_port reset reset reset Input 1

# IRQ input
add_interface irq interrupt start
set_interface_property irq associatedClock clk
set_interface_property irq associatedReset reset
add_interface_port irq irq irq Input 1

# Count output
add_interface count conduit end
set_interface_property count associatedClock clk
set_interface_property count associatedReset reset
add_interface_port count count       count       Output 32
add_interface_port count count_valid count_valid Output 1