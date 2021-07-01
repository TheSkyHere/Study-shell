#!/bin/sh                                                                                                                                            
logfile="./AC_cycle_log.log"
status_file="./status"
status=`cat $status_file`
                                                                                                                                                                                                                                              
                                                                                           
source /usr/local/bin/openbmc-utils.sh                                                                                                               

function fun_i2cdump()
{
    echo "i2cdump -y -f 0 0x0d" >> $logfile                                                    
    i2cdump -y -f 0 0x0d >> $logfile       
    echo "i2cdump -y -f 1 0x0d" >> $logfile
    i2cdump -y -f 1 0x0d >> $logfile  
}

if (($status == "0")); then
    echo "===================================================BMC--TEST--START===============================================================" >> $logfile
    date >> $logfile 
    echo "=============update slave" >> $logfile
    flashcp -v ./flash-obmc-cl_v120 /dev/mtd11
    sleep 2
    boot_info.sh >> $logfile
    echo "=============boot_from slave" >> $logfile
    
    echo 1 > $status_file
    sleep 10
    boot_from slave

elif (($status == "1")); then
    date >> $logfile 
    echo "=============update master" >> $logfile
    flashcp -v ./flash-obmc-cl_v120 /dev/mtd11
    sleep 2
    boot_info.sh >> $logfile
    echo "=============boot_from master" >> $logfile
    
    echo 2 > $status_file
    sleep 10
    boot_from master
    
elif (($status == "2")); then
    
    date >> $logfile                        
    echo "===========================wedge_power.sh status===========================" >> $logfile
    echo "wedge_power.sh status" >> $logfile                                                   
    wedge_power.sh status >> $logfile      
    fun_i2cdump


                                        
    echo "===========================wedge_power.sh off===========================" >> $logfile     
    echo "wedge_power.sh off" >> $logfile   
    wedge_power.sh off >> $logfile  
    echo "sleep 20" >> $logfile             
    sleep 20                                                                                        
    fun_i2cdump



    echo "===========================upgrande mtd5&mtd11===========================" >> $logfile      
    echo "Update /dev/mtd5 & /dev/mtd11" >> $logfile                                                                                       
    echo "First Update /dev/mtd5"       
    flashcp -v ./flash-obmc-cl_v118 /dev/mtd5
    sleep 2                                                                                     
    echo "Second Update /dev/mtd11" >> $logfile      
    flashcp -v ./flash-obmc-cl_v118 /dev/mtd11                                                            
    echo "Update Over"  >> $logfile               


    echo "===========================wedge_power.sh status===========================" >> $logfile
    echo "wedge_power.sh status" >> $logfile
    wedge_power.sh status >> $logfile                                                             
    fun_i2cdump                                                           


    echo "===========================reboot now ===========================" >> $logfile   
    sleep 2                 
    echo 3 > $status_file

    reboot 

elif (($status == "3")); then
    echo 0 > $status_file
    echo "===========================wait ac off ===========================" >> $logfile

fi



  