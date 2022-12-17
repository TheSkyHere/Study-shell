if [ $# -lt 1 ];then
   echo "Usage: `basename $0`+<1;2;all>"
   echo "1   : flash0"
   echo "2   : flash0ro"
   echo "all : flash0 & flash0ro"
   echo "ocp : update ocpbmc image"
   exit 255
fi
cat /proc/mtd |grep -i "flash0\""
cat /proc/mtd |grep -i "flash0ro"


F0_string=$(cat /proc/mtd |grep -i flash0\" |cut -b 1-4)
F1_string=$(cat /proc/mtd |grep -i flash0ro |cut -b 1-4)
if [ "$F1_string" = "" ]; then
    F1_string=$(cat /proc/mtd |grep -i flash1 |cut -b 1-4)
fi



if [ $1 == "1" ]; then
    source /usr/local/bin/openbmc-utils.sh
    echo "Update /dev/$F0_string"
    flashcp  ./flash-* /dev/$F0_string
elif [ $1 == "2" ]; then
    source /usr/local/bin/openbmc-utils.sh
    echo "Update /dev/$F1_string"
    flashcp ./flash-* /dev/$F1_string
elif [ $1 == "all" ]; then
    source /usr/local/bin/openbmc-utils.sh
    echo "Update /dev/$F0_string & /dev/$F1_string"

    echo "First  : Update /dev/$F0_string"
    flashcp ./flash-* /dev/$F0_string

    echo "Second : Update /dev/$F1_string"
    flashcp ./flash-* /dev/$F1_string
elif [ $1 == "ocp" ]; then
    Image_ID=$(ls /tmp/images/)
    if [ ${#Image_ID} -eq 8 ];then
      echo "IMAGE ID = ${Image_ID}"
    else
      echo "IMAGE ID = ${Image_ID}"
      echo "Error-----multiple image"
      exit 255
    fi
    
    echo "busctl set-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/$Image_ID xyz.openbmc_project.Software.Activation RequestedActivation s xyz.openbmc_project.Software.Activation.RequestedActivations.Active"
    busctl set-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/$Image_ID xyz.openbmc_project.Software.Activation RequestedActivation s xyz.openbmc_project.Software.Activation.RequestedActivations.Active
    sleep 3
    echo "busctl get-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/$Image_ID xyz.openbmc_project.Software.Activation Activation" 
    busctl get-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/$Image_ID xyz.openbmc_project.Software.Activation Activation
    sleep 1
fi

if [ $? == "0" ];then
  echo "Update Over"
  echo "reboot now !!!!"
  reboot
else
  echo "Update fail !!!!"
fi
