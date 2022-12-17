#!/bin/bash
#
# Copyright 2019-present Facebook. All Rights Reserved.
#
# This program file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program in a file named COPYING; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA


usage()
{
    program=$(basename "$0")
    echo "Usage: $program"
    echo "$program <bit:0~3> <fru.bin>"
}


if [ "$#" -ne "2" ];then
    usage
    exit 1
fi
if [ "$1" -gt "3" ] || [ "$1" -lt "0" ];then
    usage
    exit 1
fi



bic_channel=$((($1+1)*4))
fru_bin=$2

fru_len=$(du -b $fru_bin | awk -F ' ' '{print $1;}') 
# array=$(hexdump -b $fru_bin |  awk '{$1=null;print}' | xargs)
array=$(hexdump  -e '1/1 "0x%02x "' $fru_bin -v)
if [ "$fru_len" -gt "1024" ];then 
    echo "Only support 1024 bin"
    exit 1
fi
echo $array

mark=0x00ff
mark=$(($mark))

## set channel## not need set WP  
busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $bic_channel 0x3a 0 0x04 5  4 0xe2 0x00 0x00 0x02
echo "busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $bic_channel 0x3a 0 0x04 5  4 0xe2 0x00 0x00 0x02"

i=0
while :
do
    if [ "$fru_len" -ge "128" ]; then  ## MAX send 128 byte
        fru_len=$(($fru_len-128))
        offset=$(($i*128))
        offset_high=$(($offset>>8))
        offset_low=$(($offset&$mark))
        busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $bic_channel 0x3a 0 0x04 $((128+5))      4 0xA0 0x00 $offset_high $offset_low  ${array:$(($i*128*5)):$((128*5))}
        echo "busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $bic_channel 0x3a 0 0x04 $((128+5))      4 0xA0 0x00 $offset_high $offset_low  ${array:$(($i*128*5)):$((128*5))}"
    elif [ "$fru_len" -gt "0" ]; then
        offset=$(($i*128))
        offset_high=$(($offset>>8))
        offset_low=$(($offset&$mark))
        busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $bic_channel 0x3a 0 0x04 $(($fru_len+5))      4 0xA0 0x00 $offset_high $offset_low  ${array:$(($i*128*5)):$(($fru_len*5))}
        echo "busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $bic_channel 0x3a 0 0x04 $(($fru_len+5))      4 0xA0 0x00 $offset_high $offset_low  ${array:$(($i*128*5)):$(($fru_len*5))} "
        exit 1
    else
        exit 1
    fi
    i=$(($i+1))
done
