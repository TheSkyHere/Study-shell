#!/bin/sh

logfile="./AC_cycle_log.log"
cycle_file="./cycle"


current_cycle=`cat $cycle_file`
echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
echo $current_cycle > $cycle_file


date  >> $logfile
source /usr/local/bin/openbmc-utils.sh 


echo "sleep 120  #wait sonic power on"   >> $logfile
sleep 120

echo "wedge_power.sh status" >> $logfile
wedge_power.sh status >> $logfile

echo "=========================== Check bus 0 address 0x0d 0x70  Start ===========================" >> $logfile
string_byte=$(i2cget -f -y 0 0x0d 0x70 b)

echo $string_byte >> $logfile

if [[ $string_byte == 0x01 ]]; then
    echo "===========================sonic is power on" >> $logfile
else
    echo "===========================sonic is power off  so stop this test  " >> $logfile
    echo "sleep 120"   >> $logfile
    sleep 120
    echo "=========================== Check bus 0 address 0x0d 0x70  again ===========================" >> $logfile
    string_byte=$(i2cget -f -y 0 0x0d 0x70 b)
    echo $string_byte >> $logfile
    echo "===========================TEST Over=========================== wait for AC off" >> $logfile
    exit 255
fi



echo "wedge_power.sh status" >> $logfile
wedge_power.sh status >> $logfile
echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile


echo "=========================== power off===========================" >> $logfile

echo "=========================== power off test START==============================================" >> $logfile
echo "wedge_power.sh off " >> $logfile
wedge_power.sh off >> $logfile
echo "=========================== power off OVER====================================================" >> $logfile



echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile

echo "======sleep 10" >> $logfile
sleep 10

echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile


echo "wedge_power.sh status ( estimate:off )" >> $logfile
string=$(wedge_power.sh status)
echo $string >> $logfile
if [[ $string == *"on"* ]]; then
    echo "===========================wedge power off--------->>Failed" >> $logfile
fi


echo "===========================TEST Over=========================== wait for AC off" >> $logfile
