#!/bin/bash  

BMCVERSION="OpenBMC"
logfile="/home/admin/bmc_update.log"



#检查sonic能否成功连接上bmc
function check_restful()
{
    for ((i=1; i<30; i++))
    do
        bmc-exec "cat /etc/issue" | grep -i "$BMCVERSION" > /dev/null
        if [ $? -ne 0 ];then
            echo "retry to connect bmc restful... $i"
            sleep 10
            continue
        fi
        break
    done

    if [ $i -eq 30 ];then
        echo  "Cannot to connect restful service... Failed"  >>$logfile
        exit 1
    fi
}

#打印i2cdump信息
function i2cdump()
{
    echo "i2cdump -y -f 0 0x0d" >> $logfile
    bmc-exec "i2cdump -y -f 0 0x0d" >> $logfile
    echo "i2cdump -y -f 1 0x0d" >> $logfile
    bmc-exec "i2cdump -y -f 1 0x0d" >> $logfile
}

#sonic下升级bmc，升级前后都将i2cdump
function bmc_upgrande()
{
    echo "============================Sonic test start================================"
    #在master下升级slave bmc
    date >> $logfile
    echo "flashcp -v /var/log/img/flash-obmc-cl_v120 /dev/mtd11" >> $logfile    
    i2cdump
    bmc-exec "flashcp -v /var/log/img/flash-obmc-cl_v120 /dev/mtd11"
    sleep 900
    i2cdump
    bmc-exec "source /usr/local/bin/openbmc-utils.sh;boot_from slave"

    echo "boot_from slave" >> $logfile
    check_restful   

    #在slave下升级master bmc
    date >> $logfile
    i2cdump
    bmc-exec "flashcp -v /var/log/img/flash-obmc-cl_v120 /dev/mtd11"
    sleep 900
    i2cdump
    bmc-exec "source /usr/local/bin/openbmc-utils.sh;boot_from master"

    check_restful
    i2cdump

#BMC端执行后续步骤：power off，版本回退至1.1.8
    echo "============================Sonic test over================================="
    bmc-exec "cd /var/log/img;./power_cycle.sh all"

}
check_restful
bmc_upgrande &
