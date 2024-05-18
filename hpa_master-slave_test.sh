#!/bin/sh

current_cycle=0

logfile="./matao-hpa-test_master_slave.log"

while :
do 

echo "======================cycle$current_cycle Start==============================================================================================="  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

python3 sysdiag.py -s bmc_switch_tc -U 3  >> $logfile
if [ $? -ne 0 ]; then
    printf "Fail  not master----!!!! "  >> $logfile
    exit 1
fi

python3 sysdiag.py -s bmc_switch_tc -U 2  >> $logfile
if [ $? -ne 0 ]; then
    printf "Fail  master to slave----!!!! "  >> $logfile
    exit 1
fi

sleep 250

python3 sysdiag.py -s bmc_switch_tc -U 4  >> $logfile
if [ $? -ne 0 ]; then
    printf "Fail  not slave----!!!! "  >> $logfile
    exit 1
fi


python3 sysdiag.py -s bmc_ac_reset_tc >> $logfile
if [ $? -ne 0 ]; then
    printf "BMC   ac   reset Fail----!!!! "  >> $logfile
    exit 1
fi


echo "====================================================================================================================================="  >> $logfile
echo "*************************************************************************************************************************************"  >> $logfile
echo "====================================================================================================================================="  >> $logfile
ssh-keygen -f "/root/.ssh/known_hosts" -R "240.1.1.2"
sleep 40
done
