#!/bin/sh

while :
do
    echo "==============TEST START=============="
    echo "power off com1~5"
    pduoff 1
    pduoff 2
    pduoff 3
    pduoff 4
    pduoff 5
    sleep 5
    echo "power on com1~5"
    pduon 1
    pduon 2
    pduon 3
    pduon 4
    pduon 5
    sleep 300
    echo "==============TEST OVER=============="
done


#!/bin/sh

num=0
while :
do
    echo "==============TEST START $num =(com 4~5)============="i
    num=$((num+1))
    echo "power off com4~5"
    pduoff 4
    pduoff 5
    sleep 5
    echo "power on com4~5"
    pduon 4
    pduon 5
    sleep 400
    echo "==============TEST OVER=============="
done



