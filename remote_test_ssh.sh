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

# study  https://www.cnblogs.com/autopenguin/p/5918717.html
# study  https://blog.csdn.net/a970973835/article/details/48290059

# spawn ssh-keygen -f "/home/morton/.ssh/known_hosts" -R $IP
# sleep 2
# spawn scp $local_file /usr/local/morton/bmc_upgrade_for_ALI.sh root@$IP:~
spawn ssh pi@10.204.82.198
 

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
        send "sudo picocom -b 9600 /dev/ttyUSB1\r" 
        exp_continue 
    } 
    "*Terminal ready*" {
        sleep 1
        send "\r" 
        exp_continue 
    } 
    "*bmc login:*" {
        sleep 1
        send "root\r" 
        exp_continue 
    } 
    "*Password:*" {
        sleep 1
        send "0penBmc\r"
        exp_continue 
    }


    "*on /dev/ttyS0.*" {
        sleep 1
        send "\r"
        sleep 1
        send "/mnt/data/test.sh & \r"
        send "source /usr/local/bin/openbmc-utils.sh \r"
        send "come_reset slave\r"
        sleep 5 
        send "sol.sh\r"
        sleep 200
        send "\r"
        exp_continue 
    } 
    "*TERMINAL MULTIPLEXER*" {
        sleep 1
        send "\r"
        exp_continue 
    } 
    "*sonic login:*" {
        sleep 1
        send "admin\r"
        expect {
            "*Password:*" {
                sleep 1
                send "admin\r"
                send "./test.sh\r"
                expect {
                    "*morton=========test===start*" {
                        # send CTRL+A :01   CTRL+B :02   CTRL+C :03  
                        send "\03"
                        sleep 1
                        send "exit\r"
                        sleep 1
                        exit 3 
                    } 
                } 
            } 
        }
        exp_continue 
    } 

    timeout { 
        puts "connect is timeout" 
        exit 3 
    } 
} 
