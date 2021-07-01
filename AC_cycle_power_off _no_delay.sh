#!/bin/sh


logfile="./AC_cycle_log.log"
cycle_file="./cycle"



current_cycle=`cat $cycle_file`
echo "======================cycle$current_cycle Start======================"  >> $logfile

current_cycle=$((current_cycle+1))
echo $current_cycle > $cycle_file
source /usr/local/bin/openbmc-utils.sh 

date  >> $logfile
echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile


echo "=========================== Check bus 0 address 0x0d 0x70  Start ===========================" >> $logfile
echo "i2cget -f -y 0 0x0d 0x70 b " >> $logfile
i2cget -f -y 0 0x0d 0x70 b  >> $logfile
echo "=========================== Check bus 0 address 0x0d 0x70 Over ===========================" >> $logfile
  


echo "===========================wedge_power.sh off  START==============================================" >> $logfile
echo "wedge_power.sh off " >> $logfile
wedge_power.sh off >> $logfile
echo "===========================wedge_power.sh off  OVER ==============================================" >> $logfile

echo "sleep 30" >> $logfile
sleep 30


echo "wedge_power.sh status ( estimate:off )" >> $logfile
wedge_power.sh status >> $logfile

string=$(wedge_power.sh status)
if [[ $string == *"on"* ]]; then
    echo "===========================power off--------->>Failed" >> $logfile
    echo "===========================power off again ==================" >> $logfile
    echo "wedge_power.sh off " >> $logfile
    wedge_power.sh off >> $logfile
fi


echo "i2cdump -y -f 0 0x0d" >> $logfile
i2cdump -y -f 0 0x0d >> $logfile
echo "i2cdump -y -f 1 0x0d" >> $logfile
i2cdump -y -f 1 0x0d >> $logfile

echo "===========================TEST Over=========================== wait for AC off" >> $logfile





