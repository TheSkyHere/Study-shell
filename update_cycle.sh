#!/bin/sh

num=0
cycle=1000

log_file="/run/matao_sensor_cycle.log"

while :
do
    echo "==============TEST START  $num ==============" >> $log_file
    date  >> $log_file
    num=$((num+1))
    ## get raw 6 1
    busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay 0 6 0 0x1 0   >> $log_file
    ## get sdr
    busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay 0 0x0a 0 0x23 6 0x11 0x00 0x00 0x00 0x00 0xff   >> $log_file
    ## get sensor read
    busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay 0 0x04 0 0x2d 1 0x00   >> $log_file
    echo "==============TEST OVER=============="    >> $log_file

    if [ $num -ge $cycle ]; then
        exit 255
    fi
done