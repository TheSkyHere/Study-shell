#!/bin/sh


logfile="./AC_cycle_log.log"
cycle_file="./cycle"



current_cycle=`cat $cycle_file`
echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
echo $current_cycle > $cycle_file


date  >> $logfile
source /usr/local/bin/openbmc-utils.sh 



echo "sleep 130  #wait sonic power on"   >> $logfile
sleep 130

echo "wedge_power.sh status" >> $logfile
wedge_power.sh status >> $logfile
echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile


echo "=========================== power off===========================" >> $logfile
echo "===========================EE test START==============================================EE set register ==power off" >> $logfile

echo "i2cget -f -y 0 0x0d 0x70 b " >> $logfile
i2cget -f -y 0 0x0d 0x70 b >> $logfile
echo "i2cget -f -y 0 0x0d 0x24 b" >> $logfile
i2cget -f -y 0 0x0d 0x24 b >> $logfile
echo "i2cget -f -y 0 0x0d 0x18 b " >> $logfile
i2cget -f -y 0 0x0d 0x18 b >> $logfile
echo "i2cget -f -y 0 0x0d 0x22 b" >> $logfile
i2cget -f -y 0 0x0d 0x22 b >> $logfile


echo "i2cset -f -y 0 0x0d 0x70 0x01" >> $logfile
echo "i2cset -f -y 0 0x0d 0x24 0x00" >> $logfile
echo "sleep 5" >> $logfile
echo "i2cset -f -y 0 0x0d 0x24 0x01" >> $logfile
i2cset -f -y 0 0x0d 0x70 0x01 >> $logfile
i2cset -f -y 0 0x0d 0x24 0x00 >> $logfile
sleep 5
i2cset -f -y 0 0x0d 0x24 0x01 >> $logfile


echo "i2cget -f -y 0 0x0d 0x70 b " >> $logfile
i2cget -f -y 0 0x0d 0x70 b >> $logfile
echo "i2cget -f -y 0 0x0d 0x24 b" >> $logfile
i2cget -f -y 0 0x0d 0x24 b >> $logfile
echo "i2cget -f -y 0 0x0d 0x18 b" >> $logfile
i2cget -f -y 0 0x0d 0x18 b >> $logfile
echo "i2cget -f -y 0 0x0d 0x22 b" >> $logfile
i2cget -f -y 0 0x0d 0x22 b >> $logfile

echo "===========================EE test OVER==============================================EE set register ==power off" >> $logfile

echo "sleep 10" >> $logfile
sleep 10


echo "wedge_power.sh status ( estimate:off )" >> $logfile
wedge_power.sh status >> $logfile

string=$(wedge_power.sh status)
if [[ $string == *"on"* ]]; then
    echo "===========================EE set register ==power off--------->>Failed" >> $logfile

    echo "=========================wedge_power.sh off again =======================" >> $logfile
    echo "wedge_power.sh off " >> $logfile
    wedge_power.sh off >> $logfile

    echo "===========================BMC check sensors===========================" >> $logfile
    sensors >> $logfile
fi



echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile


echo "wedge_power.sh status" >> $logfile
wedge_power.sh status >> $logfile

echo "===========================TEST Over=========================== wait for AC off" >> $logfile





