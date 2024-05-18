#!/bin/sh


reg_begin=$1
reg_over=$2
echo "read:$reg_begin ~ $reg_over"

reg_over=$(printf "%d" "$reg_over")

echo "test:$reg_over"

while :
do 

echo "read === $reg_begin =="
devmem $reg_begin

if [ $((reg_begin)) -gt $reg_over ]; then
    break
fi

reg_begin=$((reg_begin+4))

reg_begin=$(printf "0x%x" $reg_begin)
done