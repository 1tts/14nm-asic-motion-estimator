report_design -floorplan > ../reports/reports_place/area.rpt
report_power > ../reports/reports_place/power.rpt
report_qor > ../reports/reports_place/qor.rpt
report_utilization > ../reports/reports_place/util.rpt 
report_timing > ../reports/reports_place/setup_route.rpt 
report_timing -delay_type min > ../reports/reports_place/hold_route.rpt 
save_block
