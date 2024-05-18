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
        send "ssh root@10.75.159.251\r"
        exp_continue
    }
    "*yes/no*" {
        send "yes\r" 
        exp_continue 
    } 
    "*251's password*" {
        send "0penBmc\r" 
        exp_continue
    }
    "*root@*" {
        send "show_version bmc |grep Pingpong  \r"
        exp_continue
    } 
    "*hpa-v2*" {
        exit 0
    } 
    "*NA*" {
        exit 1
    }
    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
