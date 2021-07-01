#!/bin/bash
#BY:morton

DHCP=192.168.0.8

while :
 do

	ipmitool -U admin -P admin -H $DHCP raw 6 2
	sleep 180
done

