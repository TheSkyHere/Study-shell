#!/bin/bash
#BY:morton

DHCP=192.168.2.107
File_name=Horsea_ali_test_ACcycle

while :
 do

date>>$File_name
#ipmitool -U admin -P admin -H $DHCP sel clear
#ipmitool -U admin -P admin -H $DHCP power cycle
#sleep 140
ipmitool -U admin -P admin -H $DHCP power status  >> $File_name
ipmitool -U admin -P admin -H $DHCP sdr elist |grep -i "DIMMG" >> $File_name
sleep 1
#ipmitool -U admin -P admin -H 192.168.0.25 power cycle
#sleep 300
#ipmitool -U admin -P admin -H 192.168.0.25 sdr elist |grep -i "DIMMG" >> Horsea_test_power_cycle.txt 
#ipmitool -U admin -P admin -H $DHCP raw 6 2
done
