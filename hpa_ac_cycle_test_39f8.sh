#!/bin/sh


logfile="./matao-hpa-test_39f8.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

echo "======================39f8 low config dpu Start======================"  >> $logfile
./remote_reboot_39f8_BMC.sh |grep -i "connect"  >> $logfile
sleep 180
echo "===================================================================="  >> $logfile
done
