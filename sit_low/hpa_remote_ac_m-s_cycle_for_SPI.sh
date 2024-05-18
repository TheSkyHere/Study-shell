#!/bin/sh


logfile="./matao-hpa-test_ac-master-slave_for_SPI_sit_low.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

#network


# check master
./hpa_remote_check_bmc_master.sh >> $logfile
ret=$?
if [ $ret == 3 ];then
    ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.159.251"
    ping 10.75.159.251 -c 5   >> $logfile
    sleep 100
    ./hpa_remote_check_bmc_master.sh >> $logfile
    if [ $? != 0 ];then
        echo "BMC not master on ---10" >> $logfile
    fi
elif [ $ret == 1 ];then
    echo "BMC not master on ---11" >> $logfile
fi

./hpa_remote_check_bmc_mtd.sh >> $logfile 
ret=$?
if [ $ret == 1 ];then
    echo "BMC mdt error --1" >> $logfile
    exit 0
fi


# master to slave
./hpa_remote_config_bmc_to_slave.sh >> $logfile
date >> $logfile
sleep 300

#network


# check slave
./hpa_remote_check_bmc_slave.sh >> $logfile
ret=$?
if [ $ret == 3 ];then
    ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.159.251"
    ping 10.75.159.251 -c 5   >> $logfile
    sleep 100
    ./hpa_remote_check_bmc_slave.sh >> $logfile
    if [ $? != 0 ];then
        echo "BMC not slave on ---10" >> $logfile
    fi
elif [ $ret == 1 ];then
    echo "BMC not slave on ---11" >> $logfile
fi


./hpa_remote_check_bmc_mtd.sh >> $logfile 
ret=$?
if [ $ret == 1 ];then
    echo "BMC mdt error --2" >> $logfile
    exit 0
fi

# remove var/log
./hpa_remote_remove_bmc_var-log.sh >> $logfile
date >> $logfile
sleep 10

# # AC
./hpa_remote_config_chassis_ac_cycle.sh
sleep 300


echo "=================================================================================================="  >> $logfile
echo "**************************************************************************************************"  >> $logfile
echo "=================================================================================================="  >> $logfile
done
