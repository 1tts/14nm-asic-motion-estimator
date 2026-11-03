################################################################################
#
# Design name:  top
#
# Created by icc2 write_sdc on Mon Dec 15 20:14:27 2025
#
################################################################################

set sdc_version 2.0
set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000000
# capacitive_load_unit    : 1e-15
# voltage_unit            : 1
# current_unit            : 1e-06
# power_unit              : 1e-12
################################################################################


# Mode: func
# Corner: fast
# Scenario: func_fast

# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 9
create_clock -name ideal_clock1 -period 3 -waveform {0 1.5} [get_ports {clock}]
set_propagated_clock [get_clocks {ideal_clock1}]
# Warning: Libcell power domain derates are skipped!

# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 10
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {clock}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 11
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {start}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 36
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[7]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 37
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[6]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 38
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[5]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 39
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[4]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 40
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 41
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 42
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 43
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {BestDist[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 44
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionX[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 45
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionX[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 46
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionX[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 47
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionX[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 48
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionY[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 49
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionY[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 50
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionY[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 51
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {motionY[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 52
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[7]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 53
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[6]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 54
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[5]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 55
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[4]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 56
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 57
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 58
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 59
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressR[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 60
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[9]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 61
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[8]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 62
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[7]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 63
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[6]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 64
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[5]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 65
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[4]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 66
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 67
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 68
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 69
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS1[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 70
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[9]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 71
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[8]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 72
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[7]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 73
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[6]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 74
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[5]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 75
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[4]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 76
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 77
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 78
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 79
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports \
    {AddressS2[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 12
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[7]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 13
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[6]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 14
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[5]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 15
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[4]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 16
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 17
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 18
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 19
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {R[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 20
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[7]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 21
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[6]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 22
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[5]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 23
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[4]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 24
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 25
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 26
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 27
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S1[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 28
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[7]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 29
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[6]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 30
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[5]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 31
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[4]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 32
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[3]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 33
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[2]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 34
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[1]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 35
set_input_delay -clock [get_clocks {ideal_clock1}] 0.5 [get_ports {S2[0]}]
# /home/922653261/motion_estimator/outputs/motion_estimator.sdc, line 80
set_output_delay -clock [get_clocks {ideal_clock1}] 0.2 [get_ports {completed}]
