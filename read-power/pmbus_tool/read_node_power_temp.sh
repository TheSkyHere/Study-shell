#!/bin/sh

#!/bin/sh

bus=15
power_C=1000

ln -s /lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3  2>/dev/null

addr="0x60"
#read VOUT offset 0x8b
VOUT_raw=$(i2cget -f -y $bus $addr 0x8b w)
VOUT=$( ./line16_vout_mode14 $VOUT_raw)
echo "VOUT:$VOUT mV"
#read IOUT offset 0x8c
IOUT_raw=$(i2cget -f -y $bus $addr 0x8c w)
IOUT=$( ./line11 $IOUT_raw)
echo "IOUT:$IOUT mA"
#read TEMP offset 0x8d
TEMP_raw=$(i2cget -f -y $bus $addr 0x8d w)
TEMP=$( ./line11 $TEMP_raw)
echo "TEMP:$TEMP mC"
#power
POWER1=`expr $IOUT \* $VOUT`
POWER1=`expr $POWER1 / $power_C`
echo "POWER1 OUT:$POWER1 mW"

addr="0x61"
#read VOUT offset 0x8b
VOUT_raw=$(i2cget -f -y $bus $addr 0x8b w)
VOUT=$( ./line16_vout_mode14 $VOUT_raw)
echo "VOUT:$VOUT mV"
#read IOUT offset 0x8c
IOUT_raw=$(i2cget -f -y $bus $addr 0x8c w)
IOUT=$( ./line11 $IOUT_raw)
echo "IOUT:$IOUT mA"
#read TEMP offset 0x8d
TEMP_raw=$(i2cget -f -y $bus $addr 0x8d w)
TEMP=$( ./line11 $TEMP_raw)
echo "TEMP:$TEMP mC"
#power
POWER2=`expr $IOUT \* $VOUT`
POWER2=`expr $POWER2 / $power_C`
echo "POWER2 OUT:$POWER2 mW"

addr="0x62"
#read VOUT offset 0x8b
VOUT_raw=$(i2cget -f -y $bus $addr 0x8b w)
VOUT=$( ./line16_vout_mode14 $VOUT_raw)
echo "VOUT:$VOUT mV"
#read IOUT offset 0x8c
IOUT_raw=$(i2cget -f -y $bus $addr 0x8c w)
IOUT=$( ./line11 $IOUT_raw)
echo "IOUT:$IOUT mA"
#read TEMP offset 0x8d
TEMP_raw=$(i2cget -f -y $bus $addr 0x8d w)
TEMP=$( ./line11 $TEMP_raw)
echo "TEMP:$TEMP mC"
#power
POWER3=`expr $IOUT \* $VOUT`
POWER3=`expr $POWER3 / $power_C`
echo "POWER3 OUT:$POWER3 mW"


POWERALL=`expr $POWER1 + $POWER2 + $POWER3`

echo "POWER ALL:$POWERALL mW"
