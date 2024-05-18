#!/usr/bin/expect 
set timeout 20 
 
# if { [llength $argv] < 2} { 
#     puts "Usage:" 
#     puts "$argv0 local_file IP" 
#     exit 1 
# } 
 

set passwd 123456
 
spawn telnet 10.75.135.100  

expect { 
    "*User Name*" { 
        send "apc\r" 
        exp_continue 
    }
    "*Password*" { 
        send "$passwd\r" 
        exp_continue 
    } 
    "*apc>*" {
        send "olOff 9,10\r"
        exp_continue
    } 
    "*E000: Success*" {
        exit 0
    } 
    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
