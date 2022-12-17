#!/bin/sh


logfile="./mTerm_kestrel.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
echo "matao-----test" >> $logfile
done
