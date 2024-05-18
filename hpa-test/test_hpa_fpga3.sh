#!/bin/bash

num=0
log_file="/var/log/fpga3_fru_test.log"

while :
do
    echo "=============================================TEST START  $num ==============================================" >> $log_file
    date >> $log_file
    cat /sys/bus/i2c/devices/90-0050/eeprom  >> $log_file
    date >> $log_file
    num=$((num+1))
    echo "=============================================TEST OVER======================================================" >> $log_file
done