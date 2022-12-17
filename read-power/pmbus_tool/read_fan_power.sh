#!/bin/sh

## Maximum Expected Current = 20A
## R(SHUNT) = 0.0005R
## Current_LSB=20*2^15
## SHUNT_CAL = 819.2 x 10^6 x CURRENT_LSB x R(SHUNT) 
## SHUNT_CAL = 0xFA
## Power [W] = 0.2 x CURRENT_LSB x POWER
## 0.2 x CURRENT_LSB = 1/8192

bus=5
addr="0x4d"
power_C=8192 ## 0.2 x CURRENT_LSB = 1/8192
changemW=1000

ln -s /lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3  2>/dev/null


i2ctransfer -f -y $bus w3@$addr 0x02 0x00 0xFA  ##写CAL



POWER_raw=$(i2ctransfer -f -y $bus w1@$addr 0x08 r3 | sed 's/ 0x//g')  ##读power
POWER_raw=$(printf %d $POWER_raw)
POWER_raw=`expr $POWER_raw \* $changemW`   ## W 转 mW

POWER=`expr $POWER_raw / $power_C`

echo "FAN POWER OUT:$POWER mW"
