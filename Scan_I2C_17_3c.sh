#!/bin/sh
current_cycle=0
logfile="./i2c_test_log.log"


source /usr/local/bin/openbmc-utils.sh 

while :
do

    echo "======================cycle$current_cycle Start===================" >> $logfile
    current_cycle=$((current_cycle+1))


    date  >> $logfile
    string=$(i2cdetect -y -r 17)
    echo $string  >> $logfile

    if [[ $string == *"3c"* ]]; then
        echo "===========================TEST--------->> ok" >> $logfile
    else
        echo "===========================TEST--------->> Failed" >> $logfile
        echo "====i2cdetect -y -r 17  again ======" >> $logfile
        i2cdetect -y -r 17   >> $logfile
    fi
    echo "====================== OVER======================================" >> $logfile
done


   
    
    