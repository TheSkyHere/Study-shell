#!/bin/sh


logfile="./matao-hpa-test_bc2e.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

echo "======================bc2e low config dpu Start======================"  >> $logfile
./remote_reboot_bc2e_BMC.sh |grep -i "connect"  >> $logfile
sleep 180
echo "===================================================================="  >> $logfile
done
