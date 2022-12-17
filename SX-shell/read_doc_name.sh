#!/bin/sh

echo "get name ========================================="
for((i = 63; i < 123; i++))
do
    ls |grep "$i" |awk -F 'Paxlovid' '{print $1}'
done

echo "over=$1========================================"
