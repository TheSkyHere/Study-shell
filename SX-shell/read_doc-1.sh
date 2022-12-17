#!/bin/sh
for((i = 41; i < 62; i++))
do
    # antiword ./$i* |grep "$1" |awk -F '|' '{print $3}' |awk -F ' ' '{print $1}'
    echo "test ========================================================== $i"    
    antiword ./$i* |grep  "$1"
done
