#!/bin/bash

num=0
log_file="/var/log/TEST_DCDC_value.log"

while :
do
    echo "=============================================TEST START  $num ==============================================" >> $log_file
    date  >> $log_file
    num=$((num+1))

    echo "37-0060"  >> $log_file
    string=$(cat /sys/bus/i2c/devices/37-0060/in1_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 60 in1_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0060/in10_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 60 in10_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0060/curr2_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 60 curr2_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0060/curr20_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 60 curr20_input======================================================" >> $log_file
        exit 1
    fi


    echo "37-0062"  >> $log_file
    string=$(cat /sys/bus/i2c/devices/37-0062/in1_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 62 in1_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0062/in10_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 62 in10_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0062/curr2_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 62 curr2_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0062/curr20_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 62 curr20_input======================================================" >> $log_file
        exit 1
    fi

    echo "37-0064"  >> $log_file
    string=$(cat /sys/bus/i2c/devices/37-0064/in1_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 64 in1_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0064/in10_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 64 in10_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0064/curr2_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 64 curr2_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0064/curr20_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 64 curr20_input======================================================" >> $log_file
        exit 1
    fi


    echo "37-0066"  >> $log_file
    string=$(cat /sys/bus/i2c/devices/37-0066/in1_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 66 in1_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0066/in10_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 66 in10_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0066/curr2_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 66 curr2_input======================================================" >> $log_file
        exit 1
    fi
    string=$(cat /sys/bus/i2c/devices/37-0066/curr20_input)
    echo $string >> $log_file
    if [[ $string == *"-"* ]]; then
        echo "=============================================TEST OVER get fail - 66 curr20_input======================================================" >> $log_file
        exit 1
    fi

    echo "=============================================TEST OVER======================================================" >> $log_file
    sleep 0.1
done