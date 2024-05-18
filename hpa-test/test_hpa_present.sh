#!/bin/bash

num=0
log_file="/var/log/fan_psu_present_test.log"

while :
do
    echo "=============================================TEST START  $num ==============================================" >> $log_file
    date  >> $log_file
    echo "========fan1==========" >> $log_file
    data=$(cat /sys/bus/i2c/devices/i2c-59/59-000d/fan1_present |head -n 1)
    echo $data >> $log_file
    echo "=fan1=$data"

    date  >> $log_file
    echo "========fan2==========" >> $log_file
    data=$(cat /sys/bus/i2c/devices/i2c-59/59-000d/fan2_present |head -n 1)
    echo $data >> $log_file
    echo "==========fan2=$data"

    date  >> $log_file
    echo "========fan3==========" >> $log_file
    data=$(cat /sys/bus/i2c/devices/i2c-59/59-000d/fan3_present |head -n 1)
    echo $data >> $log_file
    echo "====================fan3=$data"

    date  >> $log_file
    echo "========fan4==========" >> $log_file
    data=$(cat /sys/bus/i2c/devices/i2c-59/59-000d/fan4_present |head -n 1)
    echo $data >> $log_file
    echo "==============================fan4=$data"

    date  >> $log_file
    echo "========psu1==========" >> $log_file
    data=$(cat /sys/bus/i2c/devices/9-000d/psu_1_present |head -n 1)
    echo $data >> $log_file
    echo "========================================psu1=$data"

    date  >> $log_file
    echo "========psu2==========" >> $log_file
    data=$(cat /sys/bus/i2c/devices/9-000d/psu_2_present |head -n 1)
    echo $data >> $log_file
    echo "==================================================psu2=$data"

    num=$((num+1))
    echo "=============================================TEST OVER======================================================" >> $log_file
done