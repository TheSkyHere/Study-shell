#!/bin/bash
#BY:morton

DHCP=192.168.2.107

while :
 do

date>>Horsea_test_power_cycle_time.txt
ipmitool -U admin -P admin -H $DHCP sel clear
ipmitool -U admin -P admin -H $DHCP power cycle
sleep 140
ipmitool -U admin -P admin -H $DHCP sel elist  >> Horsea_test_power_cycle_time.txt 
#ipmitool -U admin -P admin -H 192.168.0.25 power cycle
#sleep 300
#ipmitool -U admin -P admin -H 192.168.0.25 sdr elist |grep -i "DIMMG" >> Horsea_test_power_cycle.txt 
#ipmitool -U admin -P admin -H $DHCP raw 6 2
done
