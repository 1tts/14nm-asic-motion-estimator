set_host_options -max_cores 8

set script_dir "/home/922653261/motion_estimator/scripts"
source $script_dir/lib_container.tcl
source $script_dir/setup.tcl 
#set link_library  $LINK_LIBRARY_FILES_MVT 
#set target_library $TARGET_LIBRARY_FILES_MVT

set power "VDD"
set ground "VSS"

create_lib -ref_libs $NDM_REFERENCE_LIB_DIRS_MVT -technology $TECH_FILE libraryname

read_parasitic_tech -tlup $TLUPLUS_MAX_FILE  -layermap  $MAP_FILE -name tlup_max
read_parasitic_tech -tlup $TLUPLUS_MIN_FILE  -layermap  $MAP_FILE -name tlup_min

set TOP_DESIGN top
set gate_verilog "/home/922653261/motion_estimator/outputs/motion_estimator.v" 

read_verilog -top $TOP_DESIGN $gate_verilog

current_design $TOP_DESIGN

set_attribute [get_layers M1] routing_direction vertical
set_attribute [get_layers M2] routing_direction horizontal
set_attribute [get_layers M3] routing_direction vertical
set_attribute [get_layers M4] routing_direction horizontal
set_attribute [get_layers M5] routing_direction vertical
set_attribute [get_layers M6] routing_direction horizontal
set_attribute [get_layers M7] routing_direction vertical
set_attribute [get_layers M8] routing_direction horizontal
set_attribute [get_layers M9] routing_direction vertical
set_attribute [get_layers MRDL] routing_direction horizontal
set_wire_track_pattern -site_def unit -layer M1  -mode uniform -mask_constraint {mask_two mask_one} \
-coord 0.037 -space 0.074 -direction vertical

source $script_dir/mcmm.tcl