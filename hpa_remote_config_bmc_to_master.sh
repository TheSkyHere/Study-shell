#!/usr/bin/expect 
set timeout 300
 
# if { [llength $argv] < 2} { 
#     puts "Usage:" 
#     puts "$argv0 local_file IP" 
#     exit 1 
# } 
 

set passwd 0penBmc
 
spawn ssh root@10.75.135.250

expect { 
    "*250's password:*" { 
        send "$passwd\r" 
        send "$passwd\r" 
        exp_continue 
    } 
    "*yes/no*" {
        send "yes\r" 
        exp_continue 
    } 
    "*root@*" {
        send "config_bmc_status -s master \r"
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
