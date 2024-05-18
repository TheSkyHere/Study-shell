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
    echo "  dimm : total dimm power "
    echo "  cpu :  total cpu power "
    echo "  fpga : total fpga power "
    echo
    echo "Examples:"
    echo "  $program qsfp "
    echo "  $program mac "
    echo "  $program sys "
    echo
    exit 1
}


cpu_power() {
    power_log=$(ipmitool -b 5 -t 0x2c raw 0x2e 0xc8 0x57 0x01 0x00       0x01     0x01 0x0 |head -n 1)
    power_1byte=$(echo $power_log | awk -F " " '{printf "0x%s\n", $4}')
    power_0byte=$(echo $power_log | awk -F " " '{printf "0x%s\n", $5}')
    power=$((power_0byte*256))+$((power_1byte))
    echo $((power))"W"
}

dimm_power() {
    power_log=$(ipmitool -b 5 -t 0x2c raw 0x2e 0xc8 0x57 0x01 0x00       0x01     0x02 0x0 |head -n 1)
    power_1byte=$(echo $power_log | awk -F " " '{printf "0x%s\n", $4}')
    power_0byte=$(echo $power_log | awk -F " " '{printf "0x%s\n", $5}')
    power=$((power_0byte*256))+$((power_1byte))
    echo $((power))"W"
}

fpga_power() {
    i2cset -f -y 78 0x0d 0x50 0x01
    i2cset -f -y 94 0x0d 0x50 0x01
    i2cset -f -y 86 0x0d 0x50 0x01
    i2cset -f -y 102 0x0d 0x50 0x01

    sleep 1

    i2cget -f -y 78 0x0d 0x51 
    i2cget -f -y 94 0x0d 0x51 
    i2cget -f -y 86 0x0d 0x51 
    i2cget -f -y 102 0x0d 0x51 

    fpga1_power_h=$(head "/sys/bus/i2c/devices/78-000d/fpga_pfm8_pow_h" -n 1)
    fpga1_power_l=$(head "/sys/bus/i2c/devices/78-000d/fpga_pfm8_pow_l" -n 1)

    fpga2_power_h=$(head "/sys/bus/i2c/devices/94-000d/fpga_pfm8_pow_h" -n 1)
    fpga2_power_l=$(head "/sys/bus/i2c/devices/94-000d/fpga_pfm8_pow_l" -n 1)

    fpga3_power_h=$(head "/sys/bus/i2c/devices/86-000d/fpga_pfm8_pow_h" -n 1)
    fpga3_power_l=$(head "/sys/bus/i2c/devices/86-000d/fpga_pfm8_pow_l" -n 1)

    fpga4_power_h=$(head "/sys/bus/i2c/devices/102-000d/fpga_pfm8_pow_h" -n 1)
    fpga4_power_l=$(head "/sys/bus/i2c/devices/102-000d/fpga_pfm8_pow_l" -n 1)



    power=$(($((fpga1_power_h*255))+$((fpga1_power_l))))
    power=$(./line11 $power)
    echo "FPGA1 power: $((power/1000)) W"

    power=$(($((fpga2_power_h*255))+$((fpga2_power_l))))
    power=$(./line11 $power)
    echo "FPGA2 power: $((power/1000)) W"

    power=$(($((fpga3_power_h*255))+$((fpga3_power_l))))
    power=$(./line11 $power)
    echo "FPGA3 power: $((power/1000)) W"

    power=$(($((fpga4_power_h*255))+$((fpga4_power_l))))
    power=$(./line11 $power)
    echo "FPGA4 power: $((power/1000)) W"

}

###################################################
check_parameter()
{
    if [ "$#" -ne 1 ];then
        usage
    fi
    dev="$1"
    if [ "$dev" != "dimm" ] && [ "$dev" != "fpga" ] && [ "$dev" != "cpu" ];then
        usage
    fi
}

do_action()
{
    if [ "$dev" == "dimm" ];then
        dimm_power
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