#!/bin/bash  

for ((i=1; i<255; i++))
do
    string=$(ping 10.55.208.$i -c 2 -w 2)
    if [[ $string == *"icmp_seq"* ]]; then
        echo "ip : 10.55.208.$i --ok"
    else
        echo "ip : 10.55.208.$i --fail"
    fi
done