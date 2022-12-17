#!/bin/sh

num=0

cycle=20


while :
do
    echo "==============TEST START  $num ==============" >> /home/root/update_cpld.log
    date >> /home/root/update_cpld.log
    num=$((num+1))
    echo "=================== #1" >> /home/root/update_cpld.log
    cpldupdate-i2c 11 0x40 ./PA5713_BASE_CPLD_V03_1010.hex >> /home/root/update_cpld.log
    echo "version：" >> /home/root/update_cpld.log
    i2ctransfer -f -y 11 w2@0x20 0x00 0x05 r1 >> /home/root/update_cpld.log
    echo "power_check：" >> /home/root/update_cpld.log
    i2ctransfer -f -y 11 w2@0x20 0x02 0x0c r1 >> /home/root/update_cpld.log


    echo "=================== #2" >> /home/root/update_cpld.log
    cpldupdate-i2c 11 0x40 ./PA5713_BASE_CPLD_V02_1010.hex >> /home/root/update_cpld.log
    echo "version：" >> /home/root/update_cpld.log
    i2ctransfer -f -y 11 w2@0x20 0x00 0x05 r1 >> /home/root/update_cpld.log
    echo "power_check：" >> /home/root/update_cpld.log
    i2ctransfer -f -y 11 w2@0x20 0x02 0x0c r1 >> /home/root/update_cpld.log

    if [ $num -ge $cycle ]; then
        echo "==============TEST OVER==============" >> /home/root/update_cpld.log
        exit 255
    fi
done