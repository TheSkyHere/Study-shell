#!/bin/bash

sleep 40

data=$(cat /proc/mtd |grep mtd4)

echo "$data"

if [ -n "$data" ]; then
    power cycle
fi