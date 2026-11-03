puts "RM-Info: Running script [info script]\n"

set DESIGN_NAME                   "top"  ;#  The name of the top-level design

## Point to the new 14nm SAED libs
set DESIGN_REF_PATH "/packages/process_kit/generic/generic_14nm/"
set DESIGN_REF_TECH_PATH          "${DESIGN_REF_PATH}/tech"

set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#

#multi_vt


set NDM_REFERENCE_LIB_DIRS_MVT  " \
	${DESIGN_REF_PATH}/stdcell_rvt/ndm/saed14rvt_frame_only.ndm \
	${DESIGN_REF_PATH}/stdcell_hvt/ndm/saed14hvt_frame_only.ndm \
	${DESIGN_REF_PATH}/stdcell_lvt/ndm/saed14lvt_frame_only.ndm \
	${DESIGN_REF_PATH}/stdcell_slvt/ndm/saed14slvt_frame_only.ndm" 

set TECH_FILE                     "${DESIGN_REF_PATH}/tech/milkyway/saed14nm_1p9m_mw.tf"  ;#  Milkyway technology file
set MAP_FILE                      "${DESIGN_REF_PATH}/tech/star_rc/saed14nm_tf_itf_tluplus.map"  ;#  Mapping file for TLUplus
set TLUPLUS_MAX_FILE              "${DESIGN_REF_PATH}/tech/star_rc/max/saed14nm_1p9m_Cmax.tluplus"  ;#  Max TLUplus file
set TLUPLUS_MIN_FILE              "${DESIGN_REF_PATH}/tech/star_rc/min/saed14nm_1p9m_Cmin.tluplus"  ;#  Min TLUplus file
set GDS_MAP_FILE          	  "${DESIGN_REF_PATH}/tech/milkyway/saed14nm_1p9m_gdsout_mw.map"
set STD_CELL_GDS                  " \
				${DESIGN_REF_PATH}/stdcell_rvt/gds/saed14rvt.gds \
				${DESIGN_REF_PATH}/stdcell_lvt/gds/saed14lvt.gds \
				${DESIGN_REF_PATH}/stdcell_hvt/gds/saed14hvt.gds \
				${DESIGN_REF_PATH}/stdcell_slvt/gds/saed14slvt.gds \
				"
puts "RM-Info: Completed script [info script]\n"