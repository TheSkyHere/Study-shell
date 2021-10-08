#!/bin/sh


while :
do 
    echo "Morton_start========================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    
    date
    echo "Morton sensor 1"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp1_input
    gbi2ctool -f 3 0x2a 0x080000
    echo "Morton sensor 2"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp2_input
    gbi2ctool -f 3 0x2a 0x080004
    echo "Morton sensor 3"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp3_input
    gbi2ctool -f 3 0x2a 0x080008
    echo "Morton sensor 4"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp4_input
    gbi2ctool -f 3 0x2a 0x08000c
    echo "Morton sensor 5"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp5_input
    gbi2ctool -f 3 0x2a 0x080010
    echo "Morton sensor 6"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp6_input
    gbi2ctool -f 3 0x2a 0x080014
    echo "Morton sensor 7"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp7_input
    gbi2ctool -f 3 0x2a 0x080018
    echo "Morton sensor 8"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp8_input
    gbi2ctool -f 3 0x2a 0x08001c
    echo "Morton sensor 9"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp9_input
    gbi2ctool -f 3 0x2a 0x080020
    echo "Morton sensor 10"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp10_input
    gbi2ctool -f 3 0x2a 0x080024
    echo "Morton sensor 11"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp11_input
    gbi2ctool -f 3 0x2a 0x080028
    echo "Morton sensor 12"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp12_input
    gbi2ctool -f 3 0x2a 0x08002c

    echo "morton============test----over------------------------------------"

done













#!/bin/sh


while :
do 
    echo "Morton_start========================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    
    date
    echo "Morton sensor 1"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp1_input

    echo "Morton sensor 2"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp2_input

    echo "Morton sensor 3"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp3_input

    echo "Morton sensor 4"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp4_input

    echo "Morton sensor 5"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp5_input

    echo "Morton sensor 6"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp6_input

    echo "Morton sensor 7"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp7_input

    echo "Morton sensor 8"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp8_input

    echo "Morton sensor 9"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp9_input

    echo "Morton sensor 10"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp10_input

    echo "Morton sensor 11"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp11_input

    echo "Morton sensor 12"
    cat /sys/bus/i2c/devices/3-002a/hwmon/hwmon15/temp12_input


    echo "morton============test----over------------------------------------"

done

#!/bin/sh


while :
do
    date
    string_curr=$(gbi2ctool -f 3 0x2a 0x080108 |grep -i "Read data")
    echo $string_curr
    if [[ $string_curr == $string_old ]]; then
        echo "morton=============== fail---1"
    fi
    if [[ $string_curr == $string_old1 ]]; then
        echo "morton=============== fail---2"
    fi
    string_old1=$string_old
    string_old=$string_curr


done


    if [[ $string_curr == "0" ]]; then
        echo "morton=============== fail---1"
    fi