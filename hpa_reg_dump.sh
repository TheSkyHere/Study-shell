#!/bin/bash

CheckBusy() 
{
   while true
   do
      hex_number=$(mdio-util -m 1 -p 0x1c -r 0x18 | awk -F ' ' '{{print$7}}')
      echo "0x1c -r 0x18 read:$hex_number"  >> ./dump_1512_6321_reg.log
      hex_number=${hex_number#0x}  # 去掉前缀"0x"
      decimal=$((16#$hex_number))
      binary=""
      while [ $decimal -gt 0 ]; do
         remainder=$((decimal % 2))
         binary="$remainder$binary"
         decimal=$((decimal / 2))
      done
      # 补足16位
      while [ ${#binary} -lt 16 ]; do
         binary="0$binary"
      done

      bit15=$(echo "${binary}" | rev | cut -c 16)

      # 判断第 15 位、第 11 位和第 0 位是否为 1
      if [ $bit15 -eq 1 ]; then
         echo "第 15 位为 1" >> ./dump_1512_6321_reg.log
      else
         echo "不为 1" >> ./dump_1512_6321_reg.log
         break  # exit
      fi
      sleep 0.2
   done
}
 


# 1. 1512 Page[0] dump...
CheckBusy
mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0000 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb800 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb801 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb802 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb803 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb804 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb805 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb806 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb807 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb808 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb809 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80f >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb810 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb811 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb812 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb813 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb814 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb815 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb816 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb817 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb818 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb819 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81f >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

# 2. 1512 Page[1] dump...

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0001 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb800 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb801 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb802 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb803 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb804 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb805 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb806 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb807 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb808 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb809 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb80f >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb810 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb811 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb812 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb813 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb814 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb815 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb816 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb817 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb818 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb819 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb81f >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

# 3. 1512 Page[18] dump...


CheckBusy
mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0012 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb814 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0000 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416 >> ./dump_1512_6321_reg.log

# 4. Port[0x10] dump...
mdio-util -m 1 -p 0x10 -r 0x0 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x3 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x4 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x5 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x6 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x7 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x8 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x9 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xa >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xb >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xc >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xd >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xe >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xf >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x10 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x11 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x12 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x13 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x14 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x15 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x16 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x17 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x18 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x19 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1f >> ./dump_1512_6321_reg.log

# 5. Serdes Page[1] dump...

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0001 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb596 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb980 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb981 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb982 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb983 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb984 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb985 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb986 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb987 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb988 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb989 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb98a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb98b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb98c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb98d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb98e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb98f >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb990 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb991 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb992 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb993 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb994 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb995 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb996 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb997 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb998 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb999 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb99a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb99b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb99c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb99d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb99e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log

CheckBusy
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb99f >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log


# 6. Port[0x1b] dump...
mdio-util -m 1 -p 0x1b -r 0x0 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x1 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x2 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x3 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x4 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x5 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x6 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x7 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x8 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x9 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0xa >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0xb >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0xc >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0xd >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0xe >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0xf >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x10 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x11 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x12 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x13 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x14 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x15 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x16 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x17 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x18 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x19 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x1a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x1b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x1c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x1d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x1e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1b -r 0x1f >> ./dump_1512_6321_reg.log

# 7. Port[0x1c] dump...
mdio-util -m 1 -p 0x1c -r 0x0 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x1 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x2 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x3 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x4 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x5 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x6 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x7 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x8 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x9 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0xa >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0xb >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0xc >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0xd >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0xe >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0xf >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x10 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x11 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x12 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x13 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x14 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x15 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x16 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x17 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x18 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x1a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x1b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x1c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x1d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x1e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x1f >> ./dump_1512_6321_reg.log