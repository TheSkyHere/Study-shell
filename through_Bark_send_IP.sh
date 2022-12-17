#!/bin/bash 

sleep 35


IP=$(ip a |tr '\n' '*********')
IP=${IP////_}
IP=${IP// /_}
echo $IP >> ~/morton.log
curl https://api.day.app/HgNU6GvELBMgBohvx9MSPd/$IP
