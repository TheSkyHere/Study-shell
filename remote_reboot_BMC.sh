#!/usr/bin/expect 
set timeout 20 
 
# if { [llength $argv] < 2} { 
#     puts "Usage:" 
#     puts "$argv0 local_file IP" 
#     exit 1 
# } 
 
set local_file [lindex $argv 0] 
set IP [lindex $argv 1] 
set passwd bmc123
 
set passwderror 0 

# spawn ssh-keygen -f "/home/morton/.ssh/known_hosts" -R $IP
# sleep 2
# spawn scp $local_file /usr/local/morton/bmc_upgrade_for_ALI.sh root@$IP:~
spawn ssh pi@10.204.83.92 
 

expect { 
    "*password:*" { 
        if { $passwderror == 1 } { 
        puts "passwd is error" 
        exit 2 
        } 
        set timeout 1000 
        set passwderror 1 
        send "$passwd\r" 
        exp_continue 
    } 
    "*yes/no*" {
        send "yes\r" 
        exp_continue 
    } 
    "*pi@raspberrypi*" {
        send "sudo picocom -b 9600 /dev/ttyUSB0\r" 
        exp_continue 
    } 
    "*Terminal ready*" {
        send "\r" 
        exp_continue 
    } 
    "*bmc login:*" {
        send "root\r" 
        exp_continue 
    } 
    "*Password:*" {
        send "0penBmc\r"
        exp_continue 
    } 
    "*on /dev/ttyS0.*" {
        sleep 5
        send "wedge_power.sh reset\r"
        send "reboot\r"
        exp_continue 
    } 
    "*root@bmc:~#*" {
        send "wedge_power.sh reset\r"
        send "reboot\r"
        exit 3 
    } 

    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
