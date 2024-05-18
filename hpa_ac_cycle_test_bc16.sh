#!/bin/sh


logfile="./matao-hpa-test_bc16.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

echo "======================bc16 low config    Start======================"  >> $logfile
./remote_reboot_bc16_BMC.sh |grep -i "connect"  >> $logfile
sleep 240
echo "===================================================================="  >> $logfile
done
