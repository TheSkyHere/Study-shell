#!/bin/bash

num=1
while :
do 
    echo "morton----test----start===================================$num" >> ./morton.log
    date >> ./morton.log
    ./remote_test_ssh.sh >> ./morton.log
    echo "sleep 360  wait BMC up" >> ./morton.log
    sleep 480
    num=$((num+1))
    echo "morton----test----over===================================" >> ./morton.log

done