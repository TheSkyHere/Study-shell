#!/bin/sh
#By:morton
#Usage:Enter docker environment
PWD="pwd"


cd sandbox/ 

if [ "$1" == "build" ];then                  
    echo "Enter docker AND build"  
    ./docker.run
    # expect {\"password\" {send \"11\r\";}};
    expect -c " 
        
        expect {\"Do you want to execute as\" {send \"Y\r\";}};
        echo "Enter docker AND build111111111"  
        expect {\"container's image\" {send \"3\r\";}};
        echo "Enter docker AND build1111122222221111"  
        expect {\"root@morton\" {send \"cd $PWD/CI\";}};
        echo "Enter docker AND build11113333311111"  
    "


else
    echo "Enter only docker"
    
fi
exit 255

cd ../../


APG_CNT=$(expr $# - 1)
i=1
  while [ $i -le $APG_CNT ];do
   echo $i debug
  echo ${!i}
    case ${!i} in
        -N)
            i=$(expr $i + 1)
            Num=${!i}
            ;;
        -T)
            i=$(expr $i + 1)
            Time=${!i}
            ;;
         *)
            exit 0
            ;;
    esac
    i=$(expr $i + 1)
    if [ $Num = 0 ]; then
	Num=$(expr $Num + 9)
	
    fi
 done

echo "MT--------------------------------------------------"
echo "$Num"
expect -c " 
        
	set timeout 10 
	spawn telnet 192.168.0.254
	expect \"Name\" {send \"apc\r\"};
	expect \"Password\" { send \"apc\r\" }; 
	expect \"1- Device\" {send \"1\r\"};
	expect \"2- Outlet Management\" {send \"2\r\"};
	expect \"1- Outlet Control/Configuration\" {send \"1\r\"};
	expect \"9- Master\" {send \"$Num\r\"};
        expect \"1- Control\" {send \"1\r\"};
	while {1} {
		expect {\"Master\" {send \"1\r\";}};

		expect \"YES\" {send \"YES\r\r\"};

#		expect \"\033\" {send \"\033\"};
#		expect \"\033\" {send \"\033\"};


		sleep $Time
		expect {\"Master\" {send \"2\r\";}};

		expect \"YES\" {send \"YES\r\r\"};
		sleep $Time
	}
	send \"exit\r\"
	expect eof
	exit

"













# if [ $# -lt 1 ];then
#   echo "Usage: `basename $0`+<var/lib/tftpboot/BMCX  X=num>"
# #   echo " BMC 1"  
# #   $1 = 1     
#    exit 255
# fi  





#   1 #!/bin/bash
#   2                
#   3 #sudo rm -rf /var/lib/tftpboot/BMC1/*
#   4                                                                                                                                                                                                             
#   5 ABS_PATH="`pwd`"
#   6                
#   7 if [ $# -lt 1 ];then
#   8    echo "Usage: `basename $0`+<var/lib/tftpboot/BMCX  X=num>"
#   9 #   echo " BMC 1"  
#  10 #   $1 = 1     
#  11    exit 255
#  12 fi             
#  13                
#  14                
#  15                
#  16 if [ ! -d "workspace/Build/output" ];then
#  17    echo "$ABS_PATH: no file <workspace/Build/output>"
#  18    exit 255
#  19 fi             
#  20                
#  21 cd workspace/Build/output
#  22                
#  23                
#  24 sudo cp -rf ./ImageTree /var/lib/tftpboot/BMC$1
#  25 sudo cp -f ./bootloader/u-boot.bin /var/lib/tftpboot/BMC$1
#  26 sudo cp -f ./kernel/uImage /var/lib/tftpboot/BMC$1
#  27 #sudo cp -f ./test.sh /var/lib/tftpboot/BMC$2/usr/local/bin
#  28                
#  29 #if [ ! -d "/home/morton/MDS_bin" ];then
#  30 #   echo "/home/morton/MDS_bin is no directory"
#  31 #else          
#  32 #   echo "cp rom.ima is sucess"
#  33 #   sudo cp -f ./rom.ima /home/morton/MDS_bin
#  34 #fi            
#  35                
#  36 if [ ! -d "/var/lib/tftpboot/BMC$1/ImageTree" ];then
#  37    echo "/var/lib/tftpboot/BMC$1: cp is fail no directory <ImageTree>!!!"
#  38    exit 255
#  39 fi             
#  40 if [ ! -f "/var/lib/tftpboot/BMC$1/u-boot.bin" ];then
#  41    echo "/var/lib/tftpboot/BMC$1: cp is fail no file <u-boot.bin>!!!"
#  42    exit 255
#  43 fi             
#  44 if [ ! -f "/var/lib/tftpboot/BMC$1/uImage" ];then
#  45    echo "/var/lib/tftpboot/BMC$1: cp is fail no directory <uImage>!!!"
#  46    exit  255
#  47 fi             
#  48                
#  49 echo  "copy is sucess"



#   1 #!/bin/sh             
#   2 #echo $mcinfo         
#   3                       
#   4 str1="Firmware Revision : 1.12"
#   5                       
#   6                       
#   7 while :               
#   8 do                    
#   9                       
#  10 mcinfo=$(ipmitool -H $1 -U admin -P admin mc info )
#  11 result=$(echo $mcinfo | grep "${str1}")
#  12                       
#  13 if [ "$result" == "" ];
#  14 then                  
#  15     echo mc info again                                                                                                                                                                                      
#  16     sleep 1           
#  17 else                  
#  18                       
#  19     echo test ok------1
#  20     ipmitool -H $1 -U admin -P admin sel elist
#  21     sleep 1           
#  22     echo test ok------2
#  23     ipmitool -H $1 -U admin -P admin sel elist
#  24                       
#  25     echo test sel clear 
#  26     ipmitool -H $1 -U admin -P admin sel clear
#  27                       
#  28     exit 0            
#  29 fi                    
#  30                       
#  31 done                  
#  32                       
#  33 #mcinfo_data1=$($mcinfo |grep Firmware Revision | cut -f2 -d "2")
#  34                       
#  35 #echo $mcinfo_data1   
