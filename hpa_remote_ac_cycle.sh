#!/bin/sh


logfile="./matao-hpa-test_ac-cycle.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

# # AC
./hpa_remote_pdu_off.sh >> $logfile
sleep 5
./hpa_remote_pdu_on.sh >> $logfile
sleep 320

#network
ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
ping 10.75.135.250 -c 5   >> $logfile


# power cycle
./hpa_remote_config_chassis_ac_cycle.sh >> $logfile
sleep 320



echo "=================================================================================================="  >> $logfile
echo "**************************************************************************************************"  >> $logfile
echo "=================================================================================================="  >> $logfile
done
