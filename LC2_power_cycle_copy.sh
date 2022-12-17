#!/bin/sh

logfile="./wedge_power_on_off_log.log"

current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================">> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

echo "wedge_power.sh lc2 off" >> $logfile
wedge_power.sh lc2 off >> $logfile
sleep 10

date >> $logfile
echo "wedge_power.sh lc2 on" >> $logfile
wedge_power.sh lc2 on >> $logfile
sleep 120

date >> $logfile
echo "come_power.sh lc2 off" >> $logfile
come_power.sh lc2 off >> $logfile
sleep 10

date >> $logfile
echo "come_power.sh lc2 on" >> $logfile
come_power.sh lc2 on >> $logfile
sleep 120

date >> $logfile
echo "come_power.sh lc2 cycle">> $logfile
come_power.sh lc2 cycle >> $logfile
sleep 120


done
