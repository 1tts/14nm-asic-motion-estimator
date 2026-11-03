set_block_pin_constraints -allowed_layers {M1 M2 M3 M4 M5 M6 M7} -corner_keepout_num_tracks 1 -allow_feedthroughs true -self

set_clock_routing_rules -default_rule -min_routing_layer M3 -max_routing_layer M6 

place_pins -ports [get_ports *]

create_net -power VDD
create_net -ground VSS

#For design with single level hierarchy
#connect_pg_net -net VDD [get_pins -physical_context *VDD]
#connect_pg_net -net VSS [get_pins -hierarchical *VSS]

##For design with hierarchy:

#connect_pg_net -net VDD [get_pins -hierarchical */VDD]

#connect_pg_net -net VSS [get_pins -hierarchical */VSS]

#OR, use the below two commands for both above cases.
resolve_pg_nets
connect_pg_net -automatic