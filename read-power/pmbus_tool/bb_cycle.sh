#!/bin/sh


while :
do
    echo "==============TEST START $num ==============" >> /run/thermal-test.log
    num=$((num+1))
    ipmitool sensor list >> /run/thermal-test.log
    ./read_node_power_temp.sh >> /run/thermal-test.log
    echo "==============TEST OVER==============" >> /run/thermal-test.log
    sleep 20
done
