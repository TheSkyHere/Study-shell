#!/bin/sh

current_cycle=0

logfile="./matao-wdt2-dump.log"

reg=0x1e620000

while :
do 

echo "read $reg" >> $logfile
devmem $reg >> $logfile

if [ $((reg)) -eq 509739200 ]; then
    break
fi

reg=$((reg+4))

reg=$(printf "0x%x" $reg)
done


reg=0x1e785000

while :
do 

echo "read $reg" >> $logfile
devmem $reg >> $logfile

if [ $((reg)) -eq 511201372 ]; then
    printf "test  over"
    break
fi

reg=$((reg+4))

reg=$(printf "0x%x" $reg)
done