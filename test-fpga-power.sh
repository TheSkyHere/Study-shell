#!/bin/bash
#shellcheck disable=SC1091

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


    i2cget -f -y 78 0x0d 0x51 
    i2cget -f -y 94 0x0d 0x51 
    i2cget -f -y 86 0x0d 0x51 
    i2cget -f -y 102 0x0d 0x51 

    fpga1_power_h=$(i2cget -f -y 78 0x0d 0x45)
    fpga1_power_l=$(i2cget -f -y 78 0x0d 0x44)

    fpga2_power_h=$(i2cget -f -y 94 0x0d 0x45)
    fpga2_power_l=$(i2cget -f -y 94 0x0d 0x44)

    fpga3_power_h=$(i2cget -f -y 86 0x0d 0x45)
    fpga3_power_l=$(i2cget -f -y 86 0x0d 0x44)

    fpga4_power_h=$(i2cget -f -y 102 0x0d 0x45)
    fpga4_power_l=$(i2cget -f -y 102 0x0d 0x44)

	
	
    fpga1_power1_h=$(i2cget -f -y 78 0x0d 0x4c)
    fpga1_power1_l=$(i2cget -f -y 78 0x0d 0x4b)

    fpga2_power1_h=$(i2cget -f -y 94 0x0d 0x4c)
    fpga2_power1_l=$(i2cget -f -y 94 0x0d 0x4b)

    fpga3_power1_h=$(i2cget -f -y 86 0x0d 0x4c)
    fpga3_power1_l=$(i2cget -f -y 86 0x0d 0x4b)

    fpga4_power1_h=$(i2cget -f -y 102 0x0d 0x4c)
    fpga4_power1_l=$(i2cget -f -y 102 0x0d 0x4b)


    power=$(($((fpga1_power_h*256))+$((fpga1_power_l))))
    power=$(./line11 $power)
    power1=$(($((fpga1_power1_h*256))+$((fpga1_power1_l))))
    power1=$(./line11 ${power1})
	echo "power:$power,power1:$power1"
	power=$((power+power1))
    echo "FPGA1 power: $((power/1000)) W"

    power=$(($((fpga2_power_h*256))+$((fpga2_power_l))))
    power=$(./line11 $power)
	power1=$(($((fpga2_power1_h*256))+$((fpga2_power1_l))))
    power1=$(./line11 ${power1})
	echo "power:$power,power1:$power1"
	power=$((power+power1))
    echo "FPGA2 power: $((power/1000)) W"

    power=$(($((fpga3_power_h*256))+$((fpga3_power_l))))
    power=$(./line11 $power)
    power1=$(($((fpga3_power1_h*256))+$((fpga3_power1_l))))
    power1=$(./line11 ${power1})
	echo "power:$power,power1:$power1"
	power=$((power+power1))
    echo "FPGA3 power: $((power/1000)) W"

    power=$(($((fpga4_power_h*256))+$((fpga4_power_l))))
    power=$(./line11 $power)
    power1=$(($((fpga4_power1_h*256))+$((fpga4_power1_l))))
    power1=$(./line11 ${power1})
	echo "power:$power,power1:$power1"
	power=$((power+power1))
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



current_cycle=0
while :
do
    echo "==============TEST START:$current_cycle==============" >> ./matao_test.log
    current_cycle=$((current_cycle+1)) >> ./matao_test.log
    fpga_power >> ./matao_test.log
    echo "==============TEST OVER=============="  >> ./matao_test.log
done


# check_parameter "$@"
# do_action