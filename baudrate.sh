#!/bin/sh

num=0

while :
do
    echo "matao===test===================================================================TEST START $num"
    num=$((num+1))

    ./config_baudrate -b 9600
    baudrate=$(show_baudrate)
    if [[ $baudrate =~ "9600" ]];then
        echo "matao--test=====OK 9600"
    else
        echo "matao--test=====FAIL!!!!!!!!!!! 9600"
        show_baudrate
        echo "matao--test=====FAIL!!!!!!!!!!! 9600"
    fi
    sleep 4
    ./config_baudrate -b 115200
    baudrate=$(show_baudrate)
    if [[ $baudrate =~ "115200" ]];then
        echo "matao--test=====OK 115200"
    else
        echo "matao--test=====FAIL!!!!!!!!!!! 115200"
        show_baudrate
        echo "matao--test=====FAIL!!!!!!!!!!! 115200"
    fi
    sleep 4
done
