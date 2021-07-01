if [ $# -lt 1 ];then
   echo "Usage: `basename $0`+<1;2;all>"
   echo "1   : mtd5"
   echo "2   : mtd11"
   echo "all : mtd5 & mtd11"
#   $1 = 1
   exit 255
fi


source /usr/local/bin/openbmc-utils.sh

if [ $1 == "1" ]; then
    echo "Update /dev/mtd5"
    flashcp -v ./flash-obmc-cl /dev/mtd5
elif [ $1 == "2" ]; then
    echo "Update /dev/mtd11"
    flashcp -v ./flash-obmc-cl /dev/mtd11
elif [ $1 == "all" ]; then
    echo "Update /dev/mtd5 & /dev/mtd11"

    echo "First Update /dev/mtd5"
    flashcp -v ./flash-obmc-cl /dev/mtd5

    echo "Second Update /dev/mtd11"
    flashcp -v ./flash-obmc-cl /dev/mtd11
fi

echo "Update Over"
echo "reboot now"
reboot
