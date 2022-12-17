#!/bin/sh



check_bit=$(printf "%d" 0x55)
mode_1=$(printf "%d" 0x55)
mode_2=$(printf "%d" 0x05)
mode_3=$(printf "%d" 0x01)

## Check GPU1 and GPU2 at node0 or node1
node_present=$(i2ctransfer -f -y 11 w2@0x20 0x02 0x06 r1)
node_present=$(printf "%d" $node_present)
node_present=$(($node_present &$check_bit))


if [ "$node_present" -eq "$mode_1" ] ; then ## mode config 0x1
echo  "mode 1"
elif [ "$node_present" -eq "$mode_2" ] ; then ## mode config 0x2
echo  "mode 2"
elif [ "$node_present" -eq "$mode_3" ] ; then ## mode config 0x3
echo  "mode 3"
fi

