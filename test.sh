#!/bin/bash

    #   hex_number="0xffff"

    #   # 将十六进制数转换为二进制，并取出对应位的值
    #   bit15=$(echo "obase=2; ibase=16; ${hex_number}" | bc | rev | cut -c 15)
    #   bit11=$(echo "obase=2; ibase=16; ${hex_number}" | bc | rev | cut -c 11)
    #   bit0=$(echo "obase=2; ibase=16; ${hex_number}" | bc | rev | cut -c 1)
    #   echo "test: $bit15    $bit11     $bit1"

#!/bin/bash

# hex="0xc800"
# stringDec=`printf %d ${hex}`

# echo "16进制数 $hex 转换为二进制为: $stringDec"

# binary=$(echo "obase=2; ibase=10; $stringDec" | bc | rev | cut -c 13)

#       bit15=$(echo "obase=2; ibase=10; ${stringDec}" | bc | rev | cut -c 16)
#       bit11=$(echo "obase=2; ibase=10; ${stringDec}" | bc | rev | cut -c 12)
#       bit0=$(echo "obase=2; ibase=10; ${stringDec}" | bc | rev | cut -c 1)

# echo "test: $bit15    $bit11     $bit0"
# echo "16进制数 $hex 转换为二进制为: $binary"


hex="0x199a"
hex=${hex#0x}  # 去掉前缀"0x"
decimal=$((16#$hex))
binary=""
while [ $decimal -gt 0 ]; do
    remainder=$((decimal % 2))
    binary="$remainder$binary"
    decimal=$((decimal / 2))
done

echo "16进制数 $hex 转换为二进制为: $binary"

bit15=$(echo "${binary}"  | rev | cut -c 12)

echo "16进制数 $bit15 转换为二进制为: $binary"




#!/bin/bash
   while true
   do
        echo "====================================================================================begin"
        date
        redis-cli -h 240.1.1.1 -p 6379 -n 6 hget 'TRANSCEIVER_DOM_SENSOR|ethernet13' temperature
        redis-cli -h 240.1.1.1 -p 6379 -n 6 hget 'TRANSCEIVER_DOM_SENSOR|ethernet15' temperature
        redis-cli -h 240.1.1.1 -p 6379 -n 6 hget 'TRANSCEIVER_DOM_SENSOR|ethernet16' temperature
        cat /sys/bus/i2c/devices/9-000d/temp6_input 
        echo "====================================================================================over"
   done


   #!/bin/bash
   while true
   do
        echo "====================================================================================begin"
        date
        sfputil show eeprom |grep  Detected -A 25
        echo "====================================================="
        redis-cli -h 240.1.1.1 -p 6379 -n 6 hget 'TRANSCEIVER_DOM_SENSOR|ethernet13' temperature
        redis-cli -h 240.1.1.1 -p 6379 -n 6 hget 'TRANSCEIVER_DOM_SENSOR|ethernet15' temperature
        redis-cli -h 240.1.1.1 -p 6379 -n 6 hget 'TRANSCEIVER_DOM_SENSOR|ethernet16' temperature
        echo "====================================================================================over"
   done