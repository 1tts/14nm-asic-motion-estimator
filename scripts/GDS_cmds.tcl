set_app_options -name time.enable_ccs_rcv_cap -value true
set_app_options -name time.si_enable_analysis -value true
set_app_options -list {extract.starrc_mode {none}}
set_app_options -list {extract.enable_coupling_cap {true}}

set output_dir "/home/922653261/motion_estimator/outputs"

write_parasitics -output $output_dir/motionEstimator_parasitics

write_sdc -output $output_dir/topMotionPara.sdc

write_verilog -top_module_first $output_dir/topMotionPara.v



