#!/bin/sh


while :
do 

curl -X POST -H "Content-Type: application/json" -d '{"cmd":"bmc reset cold"}' http://240.1.1.2:8080/api/v1.0/power

sleep 300

done