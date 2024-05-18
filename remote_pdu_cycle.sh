#!/bin/sh

while :
do
    echo "==============TEST START==============" >> ./matao_pdu.log
    date  >> ./matao_pdu.log
    echo "power off AA8" >> ./matao_pdu.log
    ./remote_pdu_cycle_off.sh
    sleep 10
    echo "power on AA8" >> ./matao_pdu.log
    ./remote_pdu_cycle_on.sh
    sleep 360
    date  >> ./matao_pdu.log
    echo "==============TEST OVER==============" >> ./matao_pdu.log
done