#!/bin/sh                                                                                                                                            
logfile="/run/i3c_test.log"



current_cycle=0

cat /dev/ttyS3 >> $logfile &

while :
do 
echo "======================cycle$current_cycle"
echo "======================cycle$current_cycle Start===================================================================================================================="  >> $logfile
current_cycle=$((current_cycle+1))


echo -e "\n BMC send data to BIC (send: i3ctransfer -d /dev/bus/i3c/0-7ec80010009 -w 1,2,3,6 read:i3c smq I3C_0_SMQ -r 5)"  >> $logfile
i3ctransfer -d /dev/bus/i3c/0-7ec80010009 -w 1,2,3,6 >> $logfile
sleep 10
echo "i3c smq I3C_0_SMQ -r 5" > /dev/ttyS3
sleep 10

echo -e "\n BIC send data to BMC (send: i3c smq I3C_0_SMQ -w 0x0a,0x0b,0x0c read:hexdump -C /sys/bus/i3c/devices/0-7ec80010009/ibi-mqueue)"  >> $logfile
echo "i3c smq I3C_0_SMQ -w 0x0a,0x0b,0x0c" > /dev/ttyS3
sleep 10
echo " "  >> $logfile
hexdump -C /sys/bus/i3c/devices/0-7ec80010009/ibi-mqueue >> $logfile
echo -e "====================== Over========================================================================================================================================= \n \n \n "  >> $logfile
sleep 10
done
