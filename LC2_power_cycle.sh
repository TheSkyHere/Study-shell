#!/bin/sh


logfile="./wedge_power_on_off_log.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))

echo "wedge_power.sh lc2 off" >> $logfile
wedge_power.sh lc2 off

echo "<1>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<1>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile

echo "<2>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<2>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1 
echo "<3>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<3>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1 


echo "wedge_power.sh lc2 on" >> $logfile
wedge_power.sh lc2 on

echo "<1>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<1>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile

echo "<2>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<2>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1 
echo "<3>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<3>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1 
echo "<4>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<4>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1 
echo "<5>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<5>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1 
echo "<6>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<6>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1 
echo "<7>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<7>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 5
echo "<8>i2cget -f -y 82 0x0d 0x40" >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<8>i2cget -f -y 24 0x0d 0x45" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 180

done
