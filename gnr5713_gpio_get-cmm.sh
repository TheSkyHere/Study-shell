#!/bin/sh
#
# Copyright 2019-present Facebook. All Rights Reserved.
#
# This program file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program in a file named COPYING; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA

echo "============PSU1============"
echo "PSU1_CMM_PRSNT value:"
gpio-util get "PSU1_CMM_PRSNT"      
echo "PSU1_CMM_SMALT_N value:"
gpio-util get "PSU1_CMM_SMALT_N"    
echo "PSU1_CMM_ACOK_B value:"
gpio-util get "PSU1_CMM_ACOK_B"     
echo "PSU1_CMM_ACOK_A value:"
gpio-util get "PSU1_CMM_ACOK_A"     
echo "PSU1_CMM_DCOK value:"
gpio-util get "PSU1_CMM_DCOK"       

echo "============PSU2============"
echo "PSU2_CMM_PRSNT value:"
gpio-util get "PSU2_CMM_PRSNT"      
echo "PSU2_CMM_SMALT_N value:"
gpio-util get "PSU2_CMM_SMALT_N"    
echo "PSU2_CMM_ACOK_B value:"
gpio-util get "PSU2_CMM_ACOK_B"     
echo "PSU2_CMM_ACOK_A value:"
gpio-util get "PSU2_CMM_ACOK_A"     
echo "PSU2_CMM_DCOK value:"
gpio-util get "PSU2_CMM_DCOK"       

echo "============PSU3============"
echo "PSU3_CMM_PRSNT value:"
gpio-util get "PSU3_CMM_PRSNT"      
echo "PSU3_CMM_SMALT_N value:"
gpio-util get "PSU3_CMM_SMALT_N"    
echo "PSU3_CMM_ACOK_B value:"
gpio-util get "PSU3_CMM_ACOK_B"     
echo "PSU3_CMM_ACOK_A value:"
gpio-util get "PSU3_CMM_ACOK_A"     
echo "PSU3_CMM_DCOK value:"
gpio-util get "PSU3_CMM_DCOK"       

echo "============PSU4============"
echo "PSU4_CMM_SMALT_N value:"
gpio-util get "PSU4_CMM_SMALT_N"    
echo "PSU4_CMM_PRSNT value:"
gpio-util get "PSU4_CMM_PRSNT"      
echo "PSU4_CMM_ACOK_B value:"
gpio-util get "PSU4_CMM_ACOK_B"     
echo "PSU4_CMM_ACOK_A value:"
gpio-util get "PSU4_CMM_ACOK_A"     
echo "PSU4_CMM_DCOK value:"
gpio-util get "PSU4_CMM_DCOK"       


echo "============OTHER============"
echo "PWRGD_VR_P3V3_RGM_R value:"
gpio-util get "PWRGD_VR_P3V3_RGM_R" 
echo "PWRGD_VR_P1V8_PCIE_R value:"
gpio-util get "PWRGD_VR_P1V8_PCIE_R"
echo "PWRGD_VR_P1V8_R value:"
gpio-util get "PWRGD_VR_P1V8_R"     
echo "PWRGD_VR_P2V5_R value:"
gpio-util get "PWRGD_VR_P2V5_R"     
echo "PWRGD_VR_P1V2_R value:"
gpio-util get "PWRGD_VR_P1V2_R"     
echo "PWRGD_VR_P1V0_R value:"
gpio-util get "PWRGD_VR_P1V0_R"     
echo "PWRGD_VR_P3V3_STBY_R value:"
gpio-util get "PWRGD_VR_P3V3_STBY_R"
echo "UID_BTN_N value:"
gpio-util get "UID_BTN_N"           
echo "FCB_HITLESS_EN value:"
gpio-util get "FCB_HITLESS_EN"      
echo "SPDB_CMM_PRSNT value:"
gpio-util get "SPDB_CMM_PRSNT"      
echo "SPI_BMC_FWSPIWP_N value:"
gpio-util get "SPI_BMC_FWSPIWP_N"   


