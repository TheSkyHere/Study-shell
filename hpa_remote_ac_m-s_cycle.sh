#!/bin/sh


logfile="./matao-hpa-test_ac-master-slave-master.log"


current_cycle=0

while :
do 

echo "======================cycle$current_cycle Start======================"  >> $logfile
current_cycle=$((current_cycle+1))
date >> $logfile

#network
ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
ping 10.75.135.250 -c 5   >> $logfile
sleep 20

# check master
./hpa_remote_check_bmc_master.sh >> $logfile
ret=$?
if [ $ret == 3 ];then
    ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
    ping 10.75.135.250 -c 5   >> $logfile
    sleep 100
    ./hpa_remote_check_bmc_master.sh >> $logfile
    if [ $? != 0 ];then
        echo "BMC not master on ---10" >> $logfile
        exit 0
    fi
elif [ $ret == 1 ];then
    echo "BMC not master on ---11" >> $logfile
    exit 0
fi

# master to slave
./hpa_remote_config_bmc_to_slave.sh >> $logfile
date >> $logfile
sleep 300

#network
ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
ping 10.75.135.250 -c 5   >> $logfile
sleep 20

# check slave
./hpa_remote_check_bmc_slave.sh >> $logfile
ret=$?
if [ $ret == 3 ];then
    ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
    ping 10.75.135.250 -c 5   >> $logfile
    sleep 100
    ./hpa_remote_check_bmc_slave.sh >> $logfile
    if [ $? != 0 ];then
        echo "BMC not slave on ---10" >> $logfile
        exit 0
    fi
elif [ $ret == 1 ];then
    echo "BMC not slave on ---11" >> $logfile
    exit 0
fi

# # AC
./hpa_remote_pdu_off.sh >> $logfile
sleep 20
./hpa_remote_pdu_on.sh >> $logfile
sleep 300

#network
ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
ping 10.75.135.250 -c 5   >> $logfile
sleep 20

# check slave
./hpa_remote_check_bmc_slave.sh >> $logfile
ret=$?
if [ $ret == 3 ];then
    ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
    ping 10.75.135.250 -c 5   >> $logfile
    sleep 100
    ./hpa_remote_check_bmc_slave.sh >> $logfile
    if [ $? != 0 ];then
        echo "BMC not slave on ---20" >> $logfile
        exit 0
    fi
elif [ $ret == 1 ];then
    echo "BMC not slave on ---21" >> $logfile
    exit 0
fi

# slave to master
./hpa_remote_config_bmc_to_master.sh >> $logfile
date >> $logfile
sleep 300

#network
ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
ping 10.75.135.250 -c 5   >> $logfile
sleep 20

# check master
./hpa_remote_check_bmc_master.sh >> $logfile
ret=$?
if [ $ret == 3 ];then
    ssh-keygen -f "/home_b/matao/.ssh/known_hosts" -R "10.75.135.250"
    ping 10.75.135.250 -c 5   >> $logfile
    sleep 100
    ./hpa_remote_check_bmc_master.sh >> $logfile
    if [ $? != 0 ];then
        echo "BMC not master on ---20" >> $logfile
        exit 0
    fi
elif [ $ret == 1 ];then
    echo "BMC not master on ---21" >> $logfile
    exit 0
fi

# # AC
./hpa_remote_pdu_off.sh >> $logfile
sleep 20
./hpa_remote_pdu_on.sh >> $logfile
sleep 300


echo "=================================================================================================="  >> $logfile
echo "**************************************************************************************************"  >> $logfile
echo "=================================================================================================="  >> $logfile
done
