#!/usr/bin/expect 
set timeout 400
 
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
        send "devmem 0x1e785010;devmem 0x1e785030;rm -rf /var/log/*;show_bmc_status \r"
        exp_continue
    } 
    "*code source: slave*" {
        exit 0
    } 
    "*code source: master*" {
        exit 1
    } 
    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
