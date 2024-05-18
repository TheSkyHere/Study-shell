#!/usr/bin/expect 
set timeout 20 
 
# if { [llength $argv] < 2} { 
#     puts "Usage:" 
#     puts "$argv0 local_file IP" 
#     exit 1 
# } 
 

set passwd 123456
 
spawn ssh pi@10.75.159.161

 

expect { 
    "*161's password:*" { 
        send "$passwd\r" 
        send "$passwd\r" 
        exp_continue 
    } 
    "*yes/no*" {
        send "yes\r" 
        exp_continue 
    } 
    "*pi@raspberrypi*" {
        send "ssh root@2002:db8:1:0:b2a3:f2ff:fe00:39f8\r"
        exp_continue
    }
    "*39f8's password*" {
        send "0penBmc\r" 
        exp_continue
    }
    "*root@*" {
        send "power cycle \r"
        exp_continue
    } 
    "*Successful*" {
        exit 1
    } 
    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
