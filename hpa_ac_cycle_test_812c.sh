#!/bin/sh


logfile="./matao-hpa-test_812c.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

echo "======================812c low config dpu Start======================"  >> $logfile
./remote_reboot_812c_BMC.sh |grep -i "connect"  >> $logfile
sleep 230
echo "===================================================================="  >> $logfile
done
