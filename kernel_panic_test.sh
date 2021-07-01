#!/bin/bash

current_cycle=1

while :
do

        echo "======================cycle$current_cycle Start======================"
        current_cycle=$((current_cycle+1))
        date
        echo "24-005b"
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/MFR_ID_GW
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/MFR_Model_GW
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/MFR_Serial_GW
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/MFR_Revision_GW

        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/in1_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/in2_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/power1_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/power2_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/temp1_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/temp2_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/curr1_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/curr2_input
        cat /sys/bus/i2c/drivers/dps1100/24-005b/hwmon/hwmon16/fan1_input


        echo "25-005b"
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/MFR_ID_GW
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/MFR_Model_GW
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/MFR_Serial_GW
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/MFR_Revision_GW
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/in1_input

        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/in1_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/in2_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/power1_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/power2_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/temp1_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/temp2_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/curr1_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/curr2_input
        cat /sys/bus/i2c/drivers/dps1100/25-005b/hwmon/hwmon17/fan1_input

done
