#!/bin/sh

#!/bin/sh

bus=4

ln -s /lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3  2>/dev/null

addr="0x40"
#read power offset 0x96
POWER_raw=$(i2cget -f -y $bus $addr 0x96 w)
POWER=$( ./line11 $POWER_raw)
echo "PSU1 POWER OUT:$POWER mW"

addr="0x41"
#read power offset 0x96
POWER_raw=$(i2cget -f -y $bus $addr 0x96 w)
POWER=$( ./line11 $POWER_raw)
echo "PSU2 POWER OUT:$POWER mW"

addr="0x42"
#read power offset 0x96
POWER_raw=$(i2cget -f -y $bus $addr 0x96 w)
POWER=$( ./line11 $POWER_raw)
echo "PSU3 POWER OUT:$POWER mW"

addr="0x43"
#read power offset 0x96
POWER_raw=$(i2cget -f -y $bus $addr 0x96 w)
POWER=$( ./line11 $POWER_raw)
echo "PSU4 POWER OUT:$POWER mW"
