#!/bin/sh

num=0
cd /sys/bus/i2c/devices/i2c-3/
while :
do
    echo "==============TEST START $num =(com 4~5)============="i
    num=$((num+1))
    echo "dps800 0x58" >> ./new_device
    string=$(cat ./3-0058/hwmon/hwmon*/curr1_label)
    echo "0x58" >> ./delete_device    
    if [ $string == "iin" ];then
        echo "==============TEST OVER status:OK   string:$string=============="
    else
        echo "==============TEST OVER status:FAIL string:$string=============="
    fi
done



