IP="10.204.112.164"
User="admin"
Password="admin"


ID_Low="0x00"
ID_High="0x00"
while [ "$ID_Low" != "0xff" -o "$ID_High" != "0xff" ]
do
    echo ipmitool -I lanplus -H $IP -U $User -P $Password raw 0x0a 0x23 0x00 0x00 $ID_Low $ID_High 0x00 0xFF
    ipmitool -I lanplus -H $IP -U $User -P $Password raw 0x0a 0x23 0x00 0x00 $ID_Low $ID_High 0x00 0xFF
    Ret=$(ipmitool -I lanplus -H $IP -U $User -P $Password raw 0x0a 0x23 0x00 0x00 $ID_Low $ID_High 0x00 0xFF | tr '\n' ' ' | sed 's/  / /g')
    ID_Low="0x"$(echo "$Ret" | cut -c 2-3)
    ID_High="0x"$(echo "$Ret" | cut -c 5-6)
    recordType=$(echo "$Ret" | cut -c 17-19)
    echo "Record ID: "$(echo "$Ret" | cut -c 8-12)
    echo "Record Type: "$recordType
    echo -n "Record Name: "
    if [ $recordType == "01" ]
    then
        name=$(echo "$Ret" | cut -c 152-)
        #echo $name
        for i in $name
        do
            echo -ne "\x$i"
        done
        echo
    fi
    if [ $recordType == "02" ]
    then
        name=$(echo "$Ret" | cut -c 104-)
        #echo $name
        for i in $name
        do
            echo -ne "\x$i"
        done
        echo
    fi
    if [ $recordType == "03" ]
    then
        name=$(echo "$Ret" | cut -c 59-)
        echo $name
        for i in $name
        do
            echo -ne "\x$i"
        done
        echo
    fi
    echo "Raw Record Data:"
    echo "$Ret" | cut -c 8-
    echo
done
