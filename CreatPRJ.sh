#!/bin/bash


ABS_PATH="`pwd`"

if [ $# -lt 1 ];then
   echo "Usage: `basename $0`+<projetc-name>"
#   echo " BMC 1"
#   $1 = 1
   exit 255
fi 





if [ -d "$1" ];then
   echo "$ABS_PATH: $1 file exists "
   exit 255
fi

mkdir $1
cd $1
mkdir Project
cp /usr/local/bin/ocelot_install ./
cp -r /home/morton/.sandbox/Celestica-CI/CI ./
echo "Creat Project is over"

exit 255

