#!/bin/bash

num=0
log_file="/var/log/psu2_fru_test.log"

while :
do
    echo "=============================================TEST START  $num ==============================================" >> $log_file
    date >> $log_file
    show_fru psu2  >> $log_file
    date >> $log_file
    num=$((num+1))
    echo "=============================================TEST OVER======================================================" >> $log_file
done