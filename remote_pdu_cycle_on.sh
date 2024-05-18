#!/usr/bin/expect 

 
set timeout 200000

set passwd AABBab12
 
set passwderror 0 

# spawn ssh-keygen -f "/home/morton/.ssh/known_hosts" -R $IP
# sleep 2
# spawn scp $local_file /usr/local/morton/bmc_upgrade_for_ALI.sh root@$IP:~
spawn ssh admn@10.75.135.27
 

expect { 
    "*Password:*" { 
        send "$passwd\r" 
        exp_continue 
    } 
    "*yes/no*" {
        send "yes\r" 
        exp_continue 
    } 
    "*Switched PDU:*" {
        sleep 1
        send "on AA8\r"
        sleep 1
        exit 1
    }
    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
