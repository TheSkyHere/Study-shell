#!/bin/sh

while :
do 
    echo "morton----test----start---" >> ./morton.log
    date >> ./morton.log
    string=$(wedge_power.sh status)
    if [[ $string == *"off"* ]]; then
      echo "Morton===========================wedge power off"
    fi
    echo $string >> ./morton.log

    sleep 1 

done