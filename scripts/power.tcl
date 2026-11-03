create_pg_ring_pattern ring_pattern -horizontal_layer M7 -horizontal_width {0.3} -horizontal_spacing {0.17} -vertical_layer M6 -vertical_width {0.3} -vertical_spacing {0.17}

create_pg_std_cell_conn_pattern rail_pattern -layers {M1} -rail_width {0.11 0.11} 

set_pg_strategy core_ring -pattern {{name: ring_pattern} {nets: {VDD VSS}} {offset: {0.2 0.2}}} -core -extension {{stop: design_boundary}}

set_pg_strategy core_rail -pattern {{name: rail_pattern} {nets: {VDD VSS}}} -core -extension {{stop: first_target}}

compile_pg -strategies core_ring

compile_pg -strategies core_rail
