#!/bin/bash 

sleep 35


log="/home/pi/autoboot.log"

ip a > $log

echo $log

#sleep 2

# sshpass -p '111111' scp /home/pi/autoboot.log fred@10.204.112.34:/opt/pi/pi3_autoboot.log

#because need input "yes" at first time so use this command :
sshpass -p '1' ssh -o StrictHostKeyChecking=no morton@10.204.112.111 'echo 1'
#send ip to 
sshpass -p '1' scp /home/pi/autoboot.log morton@10.204.112.111:/tmp/pi3_autoboot_ip_morton.log

# #because need input "yes" at first time so use this command :
# sshpass -p '11' ssh -o StrictHostKeyChecking=no morton@192.168.1.56 'echo 1'
# #send ip to 
# sshpass -p '11' scp /home/pi/autoboot.log morton@192.168.1.56:/tmp/pi3_autoboot.log
