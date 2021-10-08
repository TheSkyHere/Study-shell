#!/bin/sh

logfile="./morton.log"


while :
do 
    echo "Morton_start========================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $logfile
    date  >> $logfile
    echo "sensor-util smb --force |grep -i GB_" >> $logfile
    string=$(sensor-util smb --force |grep -i GB_)
    echo $string >> $logfile

    if [[ $string == *"NA"* ]]; then
        echo "===========================Failed read sensor-util =============" >> $logfile
    fi

    echo "morton============test----over------------------------------------" >> $logfile

done
