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
    program=$(basename "$0" :read fru to file by bic ,read only 1024 byte)
    echo "Usage: $program"
    echo "$program <bit:0~3> <file>"
}


creat_virtualfru_file()
{
    if [ "$#" -ne "2" ];then
        usage
        exit 1
    fi
    if [ "$1" -gt "3" ] || [ "$1" -lt "0" ];then
        usage
        exit 1
    fi
    bic_channel=$((($1+1)*4))
    eeprom=$2
    fru_len=$((1024))
    mark=0x00ff
    mark=$(($mark))

    ## set channel## not need set WP  
    busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $bic_channel 0x3a 0 0x04 5  4 0xe2 0x00 0x00 0x02
    if [ "$?" != "0" ] ; then
        echo "node$1 Absent!!!"
    fi

    i=0
    while :
    do
        if [ "$fru_len" -ge "230" ]; then  ## MAX read 230 byte
            fru_len=$(($fru_len-230))
            offset=$(($i*230))
            offset_high=$(($offset>>8))
            offset_low=$(($offset&$mark))
            arry_tmp=$(busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay 4 0x3a 0 0x04 5    4 0xA0 230    $offset_high $offset_low | awk -F 'iyyyyay) 0 59 0 4 0 230 ' '{print $2}')
            if [ "$i" -eq "0" ]; then
                arry=$arry_tmp
            else
                arry=${arry}" "${arry_tmp}
            fi
        elif [ "$fru_len" -gt "0" ]; then  ##read 1024 so fru_len=104
            offset=$(($i*230))
            offset_high=$(($offset>>8))
            offset_low=$(($offset&$mark))
            arry_tmp=$(busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay 4 0x3a 0 0x04 5    4 0xA0 104    $offset_high $offset_low | awk -F 'iyyyyay) 0 59 0 4 0 104 ' '{print $2}')
            arry=${arry}" "${arry_tmp}

            echo "$arry"
            OLD_IFS="$IFS"
            IFS=" "
            hex_data=($arry)
            for s in ${hex_data[@]}
            do
                # s=$(printf "%X" $s)
                echo -e -n "\x$(printf "%X" $s)" >> $eeprom
            done
            exit 1
        else
            exit 1
        fi

        i=$(($i+1))
    done
}



creat_virtualfru_file 0 /sys/bus/i2c/devices/33-0074/eeprom
creat_virtualfru_file 1 /sys/bus/i2c/devices/33-0075/eeprom
creat_virtualfru_file 2 /sys/bus/i2c/devices/33-0076/eeprom
creat_virtualfru_file 3 /sys/bus/i2c/devices/33-0077/eeprom