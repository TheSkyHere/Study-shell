#!/bin/sh


logfile="./AC_cycle_log.log"
cycle_file="./cycle"



current_cycle=`cat $cycle_file`
echo "======================cycle$current_cycle Start======================"  >> $logfile
echo "sleep 10 wait sonic power on " >> $logfile

sleep 120
current_cycle=$((current_cycle+1))
echo $current_cycle > $cycle_file

date  >> $logfile
source /usr/local/bin/openbmc-utils.sh 



echo "wedge_power.sh status" >> $logfile
wedge_power.sh status >> $logfile

echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile


echo "=========================== Check bus 0 address 0x0d 0x70  Start ===========================" >> $logfile
echo "i2cget -f -y 0 0x0d 0x70 b " >> $logfile
i2cget -f -y 0 0x0d 0x70 b  >> $logfile
string_byte=$(i2cget -f -y 0 0x0d 0x70 b)
if [[ $string_byte == 0x00 ]]; then
    echo "===========================power on   --------->>Failed" >> $logfile
    echo "===========================Sonic not power on====================================================================" >> $logfile
    echo "===========================exit 255===========================" >> $logfile
    echo "===========================TEST Over=========================== wait for AC off" >> $logfile
    exit 255
fi
echo "=========================== Check bus 0 address 0x0d 0x70 Over ===========================" >> $logfile
  


echo "=========================== power off===========================" >> $logfile
echo "===========================wedge_power.sh off  START==============================================" >> $logfile


echo "wedge_power.sh off " >> $logfile
wedge_power.sh off >> $logfile


echo "===========================wedge_power.sh off  OVER==============================================" >> $logfile

echo "sleep 10" >> $logfile
sleep 10


echo "wedge_power.sh status ( estimate:off )" >> $logfile
wedge_power.sh status >> $logfile

string=$(wedge_power.sh status)
if [[ $string == *"on"* ]]; then
    echo "===========================power off--------->>Failed" >> $logfile
    echo "===========================BMC check sensors Start====================================================================" >> $logfile
    sensors >> $logfile
    echo "===========================BMC check sensors Over=====================================================================" >> $logfile
fi



echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile


echo "wedge_power.sh status" >> $logfile
wedge_power.sh status >> $logfile
echo "===========================TEST Over=========================== wait for AC off" >> $logfile





