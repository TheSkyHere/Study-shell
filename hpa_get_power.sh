#!/bin/bash
#shellcheck disable=SC1091
. /usr/local/bin/openbmc-utils.sh

PSU1_PMBUS_DIR=$(i2c_device_sysfs_abspath 14-0058)
PSU2_PMBUS_DIR=$(i2c_device_sysfs_abspath 15-0058)
XDPE132G=$(i2c_device_sysfs_abspath 76-004d)

program=$(basename "$0")

usage() {
    echo "Usage:"
    echo "  $program <Device>"
    echo
    echo "Device:"
    echo "  qsfp : total qsfp power "
    echo "  mac : total mac power "
    echo "  sys : total sys power "
    echo
    echo "Examples:"
    echo "  $program qsfp "
    echo "  $program mac "
    echo "  $program sys "
    echo
    exit 1
}

system_out_power() {
    sysout_power_1=0
    sysout_power_2=0
    prsnt=$(get_psu_present 1)
    power_sta=$(get_psu_power_sta 1)
    if [ "$prsnt" -eq 0 ] && [ "$power_sta" -eq 0 ];then
        sysout_power_1=$(head -n 1 "$PSU1_PMBUS_DIR/power2_input")
    fi
    prsnt=$(get_psu_present 2)
    power_sta=$(get_psu_power_sta 2)
    if [ "$prsnt" -eq 0 ] && [ "$power_sta" -eq 0 ];then
        sysout_power_2=$(head -n 1 "$PSU2_PMBUS_DIR/power2_input")
    fi
    echo $((("$sysout_power_1"+"$sysout_power_2")/1000000))"W"
}

psu1_out_power() {
    sysout_power_1=0
    sysout_power_2=0
    prsnt=$(get_psu_present 1)
    power_sta=$(get_psu_power_sta 1)
    if [ "$prsnt" -eq 0 ] && [ "$power_sta" -eq 0 ];then
        sysout_power_1=$(head -n 1 "$PSU1_PMBUS_DIR/power2_input")
    fi
    prsnt=$(get_psu_present 2)
    power_sta=$(get_psu_power_sta 2)
    if [ "$prsnt" -eq 0 ] && [ "$power_sta" -eq 0 ];then
        sysout_power_2=$(head -n 1 "$PSU2_PMBUS_DIR/power2_input")
    fi
    echo $((("$sysout_power_1"+"$sysout_power_2")/1000000))"W"
}

psu2_out_power() {
    sysout_power_1=0
    sysout_power_2=0
    prsnt=$(get_psu_present 1)
    power_sta=$(get_psu_power_sta 1)
    if [ "$prsnt" -eq 0 ] && [ "$power_sta" -eq 0 ];then
        sysout_power_1=$(head -n 1 "$PSU1_PMBUS_DIR/power2_input")
    fi
    prsnt=$(get_psu_present 2)
    power_sta=$(get_psu_power_sta 2)
    if [ "$prsnt" -eq 0 ] && [ "$power_sta" -eq 0 ];then
        sysout_power_2=$(head -n 1 "$PSU2_PMBUS_DIR/power2_input")
    fi
    echo $((("$sysout_power_1"+"$sysout_power_2")/1000000))"W"
}

mac_power() {
    xdpe_pout1=0
    xdpe_pout2=0
    xdpe_pout1_path=$(find "$XDPE132G/" -name "power3_input")
    xdpe_pout2_path=$(find "$XDPE132G/" -name "power4_input")
    xdpe_pout1=$(head "$xdpe_pout1_path" -n 1)
    xdpe_pout2=$(head "$xdpe_pout2_path" -n 1)
    xdpe_pout=$(("$xdpe_pout1"+"$xdpe_pout2"))
    echo $(($xdpe_pout/1000000))"W"
}

cpu_power() {
    power_log=$(ipmitool -b 5 -t 0x2c raw 0x2e 0xc8 0x57 0x01 0x00       0x01     0x01 0x0 |head -n 1)
    power_1byte=$(echo $power_log | awk -F " " '{printf "0x%s\n", $4}')
    power_0byte=$(echo $power_log | awk -F " " '{printf "0x%s\n", $5}')
    power=$((power_0byte*256))+$((power_1byte))
    echo $((power))"W"
}

qsfp_power() {
    qsfp_pout10=$(head "/sys/bus/i2c/devices/77-005a/power10_input" -n 1)
    qsfp_pout1=$(head "/sys/bus/i2c/devices/77-005a/power1_input" -n 1)
    qsfp_pout20=$(head "/sys/bus/i2c/devices/77-005a/power20_input" -n 1)
    qsfp_pout2=$(head "/sys/bus/i2c/devices/77-005a/power2_input" -n 1)
    echo $(("$qsfp_pout10"+"$qsfp_pout1"+"$qsfp_pout20"+"$qsfp_pout2"))"W"
}

fpga_power() {
    i2cset -f -y 78 0x0d 0x50 0x01
    i2cset -f -y 94 0x0d 0x50 0x01
    i2cset -f -y 86 0x0d 0x50 0x01
    i2cset -f -y 102 0x0d 0x50 0x01

    sleep 40

    i2cget -f -y 78 0x0d 0x51 
    i2cget -f -y 94 0x0d 0x51 
    i2cget -f -y 86 0x0d 0x51 
    i2cget -f -y 102 0x0d 0x51 

    fpga1_power_h=$(head "cat /sys/bus/i2c/devices/78-000d/fpga_pfm8_pow_h " -n 1)
    fpga1_power_l=$(head "cat /sys/bus/i2c/devices/78-000d/fpga_pfm8_pow_l " -n 1)

    fpga2_power_h=$(head "cat /sys/bus/i2c/devices/94-000d/fpga_pfm8_pow_h " -n 1)
    fpga2_power_l=$(head "cat /sys/bus/i2c/devices/94-000d/fpga_pfm8_pow_l " -n 1)

    fpga3_power_h=$(head "cat /sys/bus/i2c/devices/86-000d/fpga_pfm8_pow_h " -n 1)
    fpga3_power_l=$(head "cat /sys/bus/i2c/devices/86-000d/fpga_pfm8_pow_l " -n 1)

    fpga4_power_h=$(head "cat /sys/bus/i2c/devices/102-000d/fpga_pfm8_pow_h " -n 1)
    fpga4_power_l=$(head "cat /sys/bus/i2c/devices/102-000d/fpga_pfm8_pow_l " -n 1)


    power=$((fpga1_power_h*255))+$((fpga1_power_l))
    echo "FPGA1 power: $((power)) W"

    power=$((fpga2_power_h*255))+$((fpga2_power_l))
    echo "FPGA2 power: $((power)) W"

    power=$((fpga3_power_h*255))+$((fpga3_power_l))
    echo "FPGA3 power: $((power)) W"

    power=$((fpga4_power_h*255))+$((fpga4_power_l))
    echo "FPGA4 power: $((power)) W"

}

###################################################
check_parameter()
{
    if [ "$#" -ne 1 ];then
        usage
    fi
    dev="$1"
    if [ "$dev" != "qsfp" ] && [ "$dev" != "mac" ] && [ "$dev" != "sys" ] && [ "$dev" != "cpu" ];then
        usage
    fi
}

do_action()
{
    if [ "$dev" == "qsfp" ];then
        qsfp_power
    fi
    if [ "$dev" == "mac" ];then
        mac_power
    fi
    if [ "$dev" == "sys" ];then
        system_out_power
    fi
    if [ "$dev" == "cpu" ];then
        cpu_power
    fi
    if [ "$dev" == "fpga" ];then
        fpga_power
    fi
}

check_parameter "$@"
do_action