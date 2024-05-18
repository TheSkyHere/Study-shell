#!/bin/sh

# num=0
# log_file="/var/log/TEST_DCD_os_power_cycle.log"

# while :
# do
#     echo "=============================================TEST START  $num ==============================================" >> $log_file
#     date  >> $log_file
#     num=$((num+1))
#     reboot_cpu cycle
#     sleep 90

#     string=$(cat /var/log/syslog |grep -i "matao----test data=0xff")
#     if [[ $string == *"matao"* ]]; then
#         echo "=============================================TEST OVER get fail ======================================================" >> $log_file
#         exit 1
#     fi
#     echo "=============================================TEST OVER======================================================" >> $log_file

# done



#!/bin/sh

num=0
log_file="/var/log/TEST_DCD_os_power_cycle.log"

while :
do
    echo "=============================================TEST START  $num ==============================================" >> $log_file
    date  >> $log_file
    num=$((num+1))
    reboot_cpu off
    sleep 10
    string=$(cat /var/log/dcdcmon.log |grep -i "value is -")
    if [[ $string == *"value"* ]]; then
        echo "=============================================TEST OVER get fail status:off======================================================" >> $log_file
        exit 1
    fi

    reboot_cpu on
    sleep 90
    string=$(cat /var/log/dcdcmon.log |grep -i "value is -")
    if [[ $string == *"value"* ]]; then
        echo "=============================================TEST OVER get fail status:on======================================================" >> $log_file
        exit 1
    fi

    echo "=============================================TEST OVER======================================================" >> $log_file

done