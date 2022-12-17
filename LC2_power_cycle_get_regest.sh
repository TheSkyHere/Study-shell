#!/bin/sh

logfile="./matao_get_LC2_regest.log"

current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================">> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile
echo "<2>i2cget -f -y 24 0x0d 0x0e <LC CPLD regest come power status bit2>  " >> $logfile
i2cget -f -y 82 0x0d 0x40 >> $logfile
echo "<2>i2cget -f -y 24 0x0d 0x45 <LC CPLD regest bios_boot_state <bit4 bit5>   cpu_boot_bios_sel<bit3>>" >> $logfile
i2cget -f -y 24 0x0d 0x45 >> $logfile
sleep 1

done
