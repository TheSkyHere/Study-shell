#!/usr/bin/expect 
set timeout 400 
 
# if { [llength $argv] < 2} { 
#     puts "Usage:" 
#     puts "$argv0 local_file IP" 
#     exit 1 
# } 
 

set passwd 123456
 
spawn ssh pi@10.75.159.161


expect { 
    "*yes/no*" {
        send "yes\r" 
        exp_continue 
    } 
    "*161's password:*" { 
        send "$passwd\r" 
        send "$passwd\r" 
        exp_continue 
    } 
    "*pi@raspberrypi*" {
        send "ssh root@10.75.159.250\r"
        exp_continue
    }
    "*yes/no*" {
        send "yes\r" 
        exp_continue 
    } 
    "*250's password*" {
        send "0penBmc\r" 
        exp_continue
    }
    "*root@*" {
        send "config_bmc_status -s slave \r"
        exp_continue
    } 
    "*after 10 seconds*" {
        exit 0
    } 
    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
