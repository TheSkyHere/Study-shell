#!/usr/bin/expect

set timeout 20

if { [llength $argv] < 2} {
    puts "Usage:"
    puts "$argv0 File IP"
    exit 1
}

set IP [lindex $argv 1]
#set local_file ./tmp/deploy/images/obmc-cl/flash-obmc-cl
set local_file [lindex $argv 0]


spawn echo $local_file
expect {
    "*cloudripper*" {
        set upgrade_file /share/disk_d/morton/usr/local/bin/bmc_upgrade_for_cloudripper.sh
        puts "===!!!Scp cloudripper Upgrade file!!!==="
    }

    "*wedge400*" {
        set upgrade_file /share/disk_d/morton/usr/local/bin/bmc_upgrade_for_wedge400.sh
        puts "===!!!Scp wedge400 Upgrade file!!!==="
    }

    "*fuji*" {
        set upgrade_file /share/disk_d/morton/usr/local/bin/bmc_upgrade_for_fuji.sh
        puts "===!!!Scp fuji Upgrade file!!!==="
    }
    timeout {
        puts "Check platform is timeout"
        exit 3

    }
}


set passwd 0penBmc
set passwderror 0


spawn ssh-keygen -f "/home/morton/.ssh/known_hosts" -R $IP
sleep 2
spawn scp $local_file $upgrade_file root@$IP:~


expect {
    "*assword:*" {
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
    timeout {
        puts "connect is timeout"
        exit 3
    }
}
