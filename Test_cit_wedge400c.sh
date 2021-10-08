#!/bin/sh

logfile="./morton.log"

while :
do 

    echo "morton===================================test----start---" >> $logfile
    date  >> $logfile
    

    echo "python cit_runner.py -p wedge400 --run-test tests.wedge400.test_libpal.LibPalTest" >> $logfile
    python cit_runner.py -p wedge400 --run-test tests.wedge400.test_libpal.LibPalTest

    echo "sensor-util all --force |grep  GB_" >> $logfile
    string=$(sensor-util all --force |grep  GB_)
    echo $string >> $logfile

    if [[ $string == *"NA"* ]]; then
      echo "Morton_failed========================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $logfile
    fi

    echo "morton==============test----over---" >> $logfile
    sleep 10

done
