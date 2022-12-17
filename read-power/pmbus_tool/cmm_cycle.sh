#!/bin/sh

while :
do
    echo "==============TEST START $num ==============" >> /run/thermal-test.log
    num=$((num+1))
    ./read_fan_power.sh >> /run/thermal-test.log
    ./read_psu_power.sh >> /run/thermal-test.log
    echo "==============TEST OVER==============" >> /run/thermal-test.log
    sleep 20
done