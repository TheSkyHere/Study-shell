#!/bin/sh

while :
do
    echo "==============TEST START $num ==============" >> /run/thermal-test.log
    num=$((num+1))
    smartctl --all /dev/nvme0n1  >> /run/thermal-test.log
    smartctl --all /dev/sda  >> /run/thermal-test.log
    echo "==============TEST OVER==============" >> /run/thermal-test.log
    sleep 20
done