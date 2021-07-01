#!/bin/bash


BMC_VERSION=""
COOKIE=".`date +%Y%m%d%H$M%S%N`.cookie"
X_CSRFTOKEN=""
R_FILE_NAME=""
N_FLAG=0
RESET_BMC_FLAG=0
DEACTIVATE_BIOS_FLAG=0
CLOSE_SESSION_FLAG=0
ACTIVATE_ASYNC_FLAG=0

VERSION="\
------------------------------------------------------
                   Version 2.2.0
------------------------------------------------------
(C)Copyright 2019, Inventec
"


function DispHelpInfo()
{
    ScriptName=`basename $0`

    echo "$VERSION"

    echo "\
Usage: $ScriptName + [options]

[Options]
    -h               Show this help info
    -v               Show version info
    -H <IP>          BMC IP
    -U <UserName>    BMC user name
    -P <Password>    BMC password

    -F <FileName>    BMC/BIOS firmware
    -N               Not preserve config when flash BMC
                     Not flash ME firmware when flash BIOS (async mode)


Examples:
    Update BMC : $ScriptName -H <IP> -U <UserName> -P <Password> -F rom.ima
    Update BIOS: $ScriptName -H <IP> -U <UserName> -P <Password> -F *.BIN


"
}

function DispErr()
{
    echo -e "\033[01;31m\n$*\033[0m"
}

function FreeResource()
{
    if [ "$DEACTIVATE_BIOS_FLAG" == "1" ];then
        DeactivateBIOS
        if [ $? != 0 ];then
            rm -f "$COOKIE"
            exit 255
        fi
    fi

    if [ "$RESET_BMC_FLAG" == "1" ];then
        ResetBMC
        if [ $? != 0 ];then
            rm -f "$COOKIE"
            exit 255
        fi
    fi

    if [ "$CLOSE_SESSION_FLAG" == "1" ];then
        CloseSession
        if [ $? != 0 ];then
            rm -f "$COOKIE"
            exit 255
        fi
    fi

    if [ -f "$COOKIE" ];then
        rm -f "$COOKIE"
    fi
}

function SafeExit()
{
    FreeResource
    exit 0
}

function ErrExit()
{
    FreeResource
    exit 255
}

function GetFileName()
{
    local i
    R_FILE_NAME="$1"

    if [ "$R_FILE_NAME" == "" ];then
        R_FILE_NAME="`date +%Y%m%d%H$M%S%N`"
    fi

    if [ -f "$R_FILE_NAME" ];then
        for((i = 1; i < 0xFFFF; i++))
        do
            tmp="${R_FILE_NAME}${i}"
            if [ ! -f "$tmp" ];then
                R_FILE_NAME="$tmp"
                break
            fi
        done
    fi
}


function CreateSession()
{
    GetFileName "$COOKIE"
    COOKIE="$R_FILE_NAME"

    X_CSRFTOKEN=`curl -s -X POST http://$BMC_IP/api/session \
                      -d "password=${BMC_PASSWORD}&username=${BMC_USER_NAME}" \
                      -c "$COOKIE" | awk '{print $19}'`
    X_CSRFTOKEN=${X_CSRFTOKEN%\"*}
    X_CSRFTOKEN=${X_CSRFTOKEN#*\"}
    if [[ $? != 0 || "$X_CSRFTOKEN" == "" ]];then
        DispErr "Fail to create session ($BMC_IP)"
        return 255
    fi

    CLOSE_SESSION_FLAG=1
    echo "Create session ($BMC_IP) ...Done"
}

function CloseSession()
{
    local res

    res=`curl -s -X DELETE http://$BMC_IP/api/session \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE"`
    if [ $? != 0 ];then
        DispErr "Close session ($BMC_IP) ...Fail"
        return 255
    fi

    rm -f "$COOKIE"
    CLOSE_SESSION_FLAG=0
    echo "Close session ($BMC_IP) ...Done"
}

function BeforeUpload()
{
    local res

    res=`curl -s -X GET http://$BMC_IP/api/maintenance/fwupdate_check \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" | awk '{print $3}'`
    if [ "$res" != "0" ];then
        if [ "$res" != "1" ];then
            DispErr "Fail to check fw update status"
            return 255
        fi

        DispErr "BIOS has been in updating"
        return 254
    fi

    echo "Prepare for upgrading ..."
    if [ "$IMAGE_TYPE" == "BMC" ];then
        curl -X PUT http://$BMC_IP/api/maintenance/flash \
             -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
             -b "$COOKIE"
        if [ $? != 0 ];then
            DispErr "Prepare for upgrading ...Fail"
            return 255
        fi
    elif [ "$IMAGE_TYPE" == "BIOS" ];then
        curl -X PUT http://$BMC_IP/api/maintenance/BIOSflash \
             -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
             -b "$COOKIE"
        if [ $? != 0 ];then
            DispErr "Prepare for upgrading ...Fail"
            return 255
        fi
    else
        DispErr "Unsupported image type"
        return 255
    fi

    echo "Prepare for upgrading ...Done"
}

function UploadFile()
{
    local res
    local FileName="$1"

    if [ "$FileName" == "" ];then
        return 255
    fi

    echo "Upload file ..."

    res=`curl -X POST http://$BMC_IP/api/maintenance/firmware \
              -F "fwimage=@${FileName}" \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" | awk '{print $3}'`
    if [[ $? != 0 || "$res" != "0" ]];then
        DispErr "Upload file ...Fail"
        return 255
    fi

    echo "Upload file ...Done"
}

function AfterUpload()
{
    local res

    echo "Verify image ..."

    if [ "$IMAGE_TYPE" == "BMC" ];then
        res=`curl -s -X GET http://$BMC_IP/api/maintenance/firmware/verification \
                  -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                  -b "$COOKIE"`
        if [ $? != 0 ];then
            DispErr "Verify image ...Fail"
            return 255
        fi
    elif [ "$IMAGE_TYPE" == "BIOS" ];then
        if [ "$ACTIVATE_ASYNC_FLAG" == "0" ];then
            res=`curl -s -X GET http://$BMC_IP/api/maintenance/firmware/verification \
                      -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                      -b "$COOKIE"`
            if [ $? != 0 ];then
                DispErr "Verify image ...Fail"
                return 255
            fi
        else
            res=`curl -s -X GET http://$BMC_IP/api/maintenance/AsyncAfterUpload\
                      -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                      -b "$COOKIE"`
            if [ $? != 0 ];then
                DispErr "Verify image ...Fail"
                return 255
            fi

            tmp=`echo "$res" | awk '{print $3}'`
            tmp=${tmp%%,*}
            if [ "$tmp" != "1" ];then
                DispErr "Verify image ...Fail (Internal critical error occurs)"
                return 255
            fi
        fi
    fi

    echo "Verify image ...Done"
}

function StartUpgrade()
{
    local res
    local i
    local retry=0
    local FailCnt=0

    echo "Firmware upgrade ..."

    if [ "$IMAGE_TYPE" == "BMC" ];then
        res=`curl -s -X PUT http://$BMC_IP/api/maintenance/firmware/upgrade \
                  -d '{"preserve_config":0, "flash_status":1}' \
                  -H "Content-Type:application/json" \
                  -H "X-CSRFTOKEN: $X_CSRFTOKEN" \
                  -b "$COOKIE"`
        if [ $? != 0 ];then
            DispErr "Firmware upgrade ...Fail"
            return 255
        fi
    elif [ "$IMAGE_TYPE" == "BIOS" ];then
        res=`curl -s -X PUT http://$BMC_IP/api/maintenance/firmware/upgrade \
                  -d '{"preserve_config":0, "flash_status":0}' \
                  -H "Content-Type:application/json" \
                  -H "X-CSRFTOKEN: $X_CSRFTOKEN" \
                  -b "$COOKIE"`
        if [ $? != 0 ];then
            DispErr "Firmware upgrade ...Fail"
            return 255
        fi
    else
        DispErr "Unknown image type: $IMAGE_TYPE"
        return 255
    fi

    tmp=`echo "$res" | grep -i error`
    if [ "$tmp" != "" ];then
        echo "$res"
        DispErr "Firmware upgrade ...Fail"
        return 255
    fi

    for((i = 0; i < 300; i++))
    do
        res=`curl -s -X GET http://$BMC_IP/api/maintenance/firmware/flash-progress \
                  -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                  -b "$COOKIE"`
        if [ $? != 0 ];then
            FailCnt=$(($FailCnt + 1))
            if [ "$FailCnt" -gt 10 ];then
                DispErr "Fail to get upgrading progress"
                return 255
            fi

            sleep 2s
            continue
        fi

        tmp=`echo "$res" | awk '{print $7}'`
        tmp=${tmp#*\"}
        tmp=${tmp%%\%*}
        expr $tmp + 10 &>/dev/null
        if [ $? != 0 ];then
            if [[ "$tmp" =~ "Complete" ]];then
                echo -e "\rFirmware upgrade : 100%"
                break
            fi

            retry=$(($retry + 1))
            if [ "$retry" -gt 10 ];then
                DispErr "Unknown upgrading progress, res=\"$res\""
                return 255
            fi

            sleep 2s
            continue
        fi

        if [ "$tmp" == "100" ];then
            echo -e "\rFirmware upgrade : 100%"
            break
        fi

        retry=0
        FailCnt=0
        echo -ne "\rFirmware upgrade : ${tmp}%"
        sleep 2s
    done

    echo "Firmware upgrade ...Done"
}

function ResetBMC()
{
    local res

    RESET_BMC_FLAG=0
    echo "Reset BMC ..."

    res=`curl -s -X POST http://$BMC_IP/api/maintenance/reset \
              -d '{"flag":1}' \
              -H "Content-Type:application/json" \
              -H "X-CSRFTOKEN: $X_CSRFTOKEN" \
              -b "$COOKIE"`
    if [[ $? != 0 || "$res" != '{ "flag": 1 }' ]];then
        DispErr "Reset BMC ...Fail"
        return 255
    fi

    echo "Reset BMC ...Done"
}

function DeactivateBIOS()
{
    DEACTIVATE_BIOS_FLAG=0

    res=`curl -s -X PUT http://$BMC_IP/api/maintenance/BIOSflash/deactivateBIOS \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE"`
    if [[ $? != 0 || "$res" != "" ]];then
        DispErr "Deactivate ...Fail"
        return 255
    fi

    res=`curl -s -X PUT http://$BMC_IP/api/maintenance/BIOSreset \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE"`
    if [[ $? != 0 || "$res" != "" ]];then
        DispErr "Reset BIOS ...Fail"
        return 255
    fi

    echo "Deactivate ...Done"
}


function MainUpdateBMC()
{
    echo "BMC FW Update >>>>>>"

    tmp=`ls -l $IMAGE | awk '{print $5}'`
	if [ "$tmp" -ne "33554432" ];then
		echo "$IMAGE: damaged file"
		return 255
	fi

    if [ "$N_FLAG" == "1" ];then
        echo "Full flash firmware ..."
        res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x32 0xba 0x00 0x00`
        if [[ $? != 0 || "$res" != "" ]];then
            DispErr "Fail to disable preserve config function"
            return 255
        fi
    fi

    CreateSession
    if [ $? != 0 ];then
        return 255
    fi

    RESET_BMC_FLAG=1
    CLOSE_SESSION_FLAG=0

    BeforeUpload
    res="$?"
    if [ "$res" != "0" ];then
        if [ "$res" == "254" ];then
            RESET_BMC_FLAG=0
            CLOSE_SESSION_FLAG=1
        fi
        return 255
    fi

    UploadFile "$IMAGE"
    if [ $? != 0 ];then
        return 255
    fi

    AfterUpload
    if [ $? != 0 ];then
        return 255
    fi

    RESET_BMC_FLAG=0

    StartUpgrade
    if [ $? != 0 ];then
        return 255
    fi

    if [ -f "$EXTRA_FILE" ];then
        AfterUpdateBMC
        if [ $? != 0 ];then
            return 255
        fi
    fi

    echo -e "\033[01;32mUpdate successfully !!!\033[0m"
}

function SetMEIntoRecoverMode()
{
	sleep  10  #do not delete sleep 10s ,wait enough time for me operation
	while true
	do
		ipmitool -I lanplus -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD -b 0x06 -t 0x2c raw 0x2e 0xdf 0x57 0x01 0x00 0x01  2>/dev/null
		if [ $? == 0 ]; then
			return 0
		else
			n=$[$n+1]
			sleep 2
			
			res=`ipmitool -I lanplus -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD -b 0x06 -t 0x2c raw 6 1 2>/dev/null |awk '{ print $3 }'|cut -b 1 `
			#check bit7 of byte3 in return values : 50 01 84 14 02 20 57 01 00 0a 0b 00 25 60 00
			if [ $? == 0 && "$res" -ge "8" ]; then
				# ME in recovery mode
				return 0
			elif [ $n -ge 50 ]; then
				echo "Over 50 set-check cycles ,ME still not in recovery mode">>./.update_err.log
				exit 1
			fi
			sleep 2
		fi
	done
}
function SetMERestoreIntoNormalMode()
{
	sleep 10  #do not delete sleep 10s ; wait enough time for me operation
	while true
	do
		res=`ipmitool -I lanplus -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD -b 0x06 -t 0x2c raw 6 1 2>/dev/null |awk '{ print $3 }'|cut -b 1 `
		#check bit7 of byte3 in return values : 50 01 04 14 02 21 57 01 00 0a 0b 04 25 60 01
		if [ $? -eq 0 ] && [ "$res" != "8" ]; then
			# ME restore into normal mode 
			return 0
		fi
		ipmitool -I lanplus -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD -b 0x06 -t 0x2c raw 0x2e 0xdf 0x57 0x01 0x00 0x02  2>/dev/null
		if [ $? -eq 0 ]; then
			return 0
		else
			n=$[$n+1]
			sleep 2
			
			res=`ipmitool -I lanplus -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD -b 0x06 -t 0x2c raw 6 1 2>/dev/null |awk '{ print $3 }'|cut -b 1 `
			#check bit7 of byte3 in return values : 50 01 04 14 02 21 57 01 00 0a 0b 04 25 60 01
			if [ $? -eq 0 ] && [ "$res" != "8" ]; then
				# ME restore into normal mode 
				return 0
			elif [ $n -ge 50 ]; then
				echo "Over 50 set-check cycles ,ME still not restore to normal mode">>./.update_err.log
				exit 1
			fi		
			sleep 2
		fi
	done
}

function MainUpdateBIOSCommon()
{
    if [ "$N_FLAG" != "0" ];then
        res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x1a 0x01`
        if [[ $? != 0 || "$res" != "" ]];then
            DispErr "Fail to set as skipping ME firmware"
            return 255
        fi
        echo "SKip ME firmware ..."
    fi
	SetMEIntoRecoverMode
    CreateSession
    if [ $? != 0 ];then
        return 255
    fi
	
    CLOSE_SESSION_FLAG=1

    BeforeUpload
    if [ $? != 0 ];then
        return 255
    fi

    UploadFile "$IMAGE"
    if [ $? != 0 ];then
        return 255
    fi

    AfterUpload
    if [ $? != 0 ];then
        return 255
    fi

    StartUpgrade
    if [ $? != 0 ];then
        return 255
    fi

    #It would deactivate automatically in 10s in BMC
    echo "Deactivate ..."
    sleep 12s

    DEACTIVATE_BIOS_FLAG=0
    DeactivateBIOS
    if [ $? != 0 ];then
        return 255
    fi
	
	
    CLOSE_SESSION_FLAG=0
    CloseSession
	SetMERestoreIntoNormalMode
    if [ $? != 0 ];then
        return 255
    fi

    echo -e "\033[01;32mUpdate successfully !!!\033[0m"
}



function MainUpdateBIOS()
{
    echo "BIOS FW Update >>>>>>"

    tmp=`ls -l $IMAGE | awk '{print $5}'`
	if [ "$tmp" != "33554432" ];then
		echo "$IMAGE: damaged file"
		exit 255
	fi

	MainUpdateBIOSCommon

}

while getopts "hvH:U:P:F:G:NE:" opts
do
    case $opts in
        h )
            HelpFlag=1
            ;;
        v )
            VersionFlag=1
            ;;
        H )
            BMC_IP="$OPTARG"
            ;;
        U )
            BMC_USER_NAME="$OPTARG"
            ;;
        P )
            BMC_PASSWORD="$OPTARG"
            ;;
        F )
            IMAGE="$OPTARG"
            ;;
        N )
            N_FLAG=1;
            ;;
        * )
            exit 255
            ;;
    esac
done

md5sum -c --status MD5
if [ $? -ne 0 ]; then
	echo "BMC FW or yafuflash md5sum mismatch!"
	exit 4
fi

if [[ $# -eq 0 || "$HelpFlag" = "1" ]];then
    DispHelpInfo
    exit 0
fi

echo "$VERSION"

if [ "$VersionFlag" = "1" ];then
    exit 0
fi

if [[ "$BMC_IP" = "" || "$BMC_USER_NAME" = "" || "$BMC_PASSWORD" = "" ]];then
    echo "Require the option \"-H\" or \"-U\" or \"-P\""
    exit 255
fi

if [ "$IMAGE" = "" ];then
    echo "Require the option \"-F\" to specify file"
    exit 255
fi

if [ ! -f "$IMAGE" ];then
    echo "$IMAGE: no such file"
    exit 255
fi

tmp="${IMAGE##*.}"
if [[ "$tmp" =~ "ima" ]];then
    IMAGE_TYPE="BMC"
    MainUpdateBMC
    if [ $? != 0 ];then
        ErrExit
    fi
elif [[ "$tmp" =~ "BIN" ]] || [[ "$tmp" =~ "bin" ]];then
    IMAGE_TYPE="BIOS"
    MainUpdateBIOS
    if [ $? != 0 ];then
        ErrExit
    fi
else
    echo "$IMAGE: not a BMC or BIOS firmware"
    exit 255
fi

SafeExit
