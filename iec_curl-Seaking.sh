#!/bin/bash
trap 'SIGINT_Handler' SIGINT

EXTRA_FILE="iec_extra.sh"
PRODUCT_ID=""
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
                   Version 2.5.1
------------------------------------------------------
(C)Copyright 2019, Inventec
"

if [ -f "$EXTRA_FILE" ];then
    source "$EXTRA_FILE"
fi

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

    -G <log>         Collect all logs
       <async>       Show BIOS async updating progress

Examples:
    Update BMC : $ScriptName -H <IP> -U <UserName> -P <Password> -F rom.ima
    Update BIOS: $ScriptName -H <IP> -U <UserName> -P <Password> -F *.BIN
    Collect Log: $ScriptName -H <IP> -U <UserName> -P <Password> -G log
"
}

function DispErr()
{
    echo -e "\033[01;31m\n$*\033[0m"
}

function SIGINT_Handler()
{
    trap 'exit 255' SIGINT
    echo -e "\n*** Detect interrupt signal ***"
    SafeExit
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

function GetDeviceID()
{
    local res
    local ProductID

    res="`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 6 1`"
    echo "$?"
    if [ $? != 0 ];then
        DispErr "Fail to get device id"
        return 255
    fi

    ProductID=`echo "$res" | awk '{print $10}'`
    ProductID="`echo "$res" | awk '{print $11}'`${ProductID}"
    if [ "$ProductID" == "007a" ];then
        PRODUCT_ID="ARBOK"
    elif [ "$ProductID" == "0075" ];then
        PRODUCT_ID="Kingler"
    fi

    BMC_VERSION=`echo "$res" | awk '{print $4}'`
    BMC_VER_MAJOR=`echo "$res" | awk '{print $3}'`
    BMC_VER_MAJOR="$((16#$BMC_VER_MAJOR))"
}

function CreateSession()
{
    GetFileName "$COOKIE"
    COOKIE="$R_FILE_NAME"

    X_CSRFTOKEN=`curl -s -X POST https://$BMC_IP/api/session \
                      -d "password=${BMC_PASSWORD}&username=${BMC_USER_NAME}" \
                      -c "$COOKIE" -k | awk '{print $19}' `
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

    res=`curl -s -X DELETE https://$BMC_IP/api/session \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" -k`
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

    res=`curl -s -X GET https://$BMC_IP/api/maintenance/fwupdate_check \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" -k | awk '{print $3}'`
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
        curl -X PUT https://$BMC_IP/api/maintenance/flash \
             -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
             -b "$COOKIE" -k
        if [ $? != 0 ];then
            DispErr "Prepare for upgrading ...Fail"
            return 255
        fi
    elif [ "$IMAGE_TYPE" == "BIOS" ];then
        curl -X PUT https://$BMC_IP/api/maintenance/BIOSflash \
             -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
             -b "$COOKIE" -k
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

    res=`curl -X POST https://$BMC_IP/api/maintenance/firmware/firmware \
              -F "fwimage=@${FileName}" \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" -k | awk '{print $3}'`
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
        res=`curl -s -X GET https://$BMC_IP/api/maintenance/firmware/verification \
                  -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                  -b "$COOKIE" -k`
        if [ $? != 0 ];then
            DispErr "Verify image ...Fail"
            return 255
        fi
    elif [ "$IMAGE_TYPE" == "BIOS" ];then
        if [ "$ACTIVATE_ASYNC_FLAG" == "0" ];then
            res=`curl -s -X GET https://$BMC_IP/api/maintenance/firmware/verification \
                      -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                      -b "$COOKIE" -k`
            if [ $? != 0 ];then
                DispErr "Verify image ...Fail"
                return 255
            fi
        else
            res=`curl -s -X GET https://$BMC_IP/api/maintenance/AsyncAfterUpload\
                      -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                      -b "$COOKIE" -k`
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
        res=`curl -s -X PUT https://$BMC_IP/api/maintenance/firmware/upgrade \
                  -d '{"preserve_config":0, "flash_status":1}' \
                  -H "Content-Type:application/json" \
                  -H "X-CSRFTOKEN: $X_CSRFTOKEN" \
                  -b "$COOKIE" -k`
        if [ $? != 0 ];then
            DispErr "Firmware upgrade ...Fail"
            return 255
        fi
    elif [ "$IMAGE_TYPE" == "BIOS" ];then
        res=`curl -s -X PUT https://$BMC_IP/api/maintenance/firmware/upgrade \
                  -d '{"preserve_config":0, "flash_status":0}' \
                  -H "Content-Type:application/json" \
                  -H "X-CSRFTOKEN: $X_CSRFTOKEN" \
                  -b "$COOKIE" -k`
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
        res=`curl -s -X GET https://$BMC_IP/api/maintenance/firmware/flash-progress \
                  -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                  -b "$COOKIE" -k`
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

    res=`curl -s -X POST https://$BMC_IP/api/maintenance/reset \
              -d '{"flag":1}' \
              -H "Content-Type:application/json" \
              -H "X-CSRFTOKEN: $X_CSRFTOKEN" \
              -b "$COOKIE" -k`
    if [[ $? != 0 || "$res" != '{ "flag": 1 }' ]];then
        DispErr "Reset BMC ...Fail"
        return 255
    fi

    echo "Reset BMC ...Done"
}

function DeactivateBIOS()
{
    DEACTIVATE_BIOS_FLAG=0

    res=`curl -s -X PUT https://$BMC_IP/api/maintenance/BIOSflash/deactivateBIOS \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" -k`
    if [[ $? != 0 || "$res" != "" ]];then
        DispErr "Deactivate ...Fail"
        return 255
    fi

    res=`curl -s -X PUT https://$BMC_IP/api/maintenance/BIOSreset \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" -k`
    if [[ $? != 0 || "$res" != "" ]];then
        DispErr "Reset BIOS ...Fail"
        return 255
    fi

    echo "Deactivate ...Done"
}

function AsyncGetInfo()
{
    local res
    local i
    local j

    res="`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0xa4`"
    if [ $? != 0 ];then
        return 255
    fi

    j=1
    for i in $res
    do
        if [ "$j" == 2 ];then
            R_IsMemAddrValid="$i"
        elif [ "$j" == 3 ];then
            R_IsCrc32Valid="$i"
        elif [ "$j" == 4 ];then
            R_IsTaskExist="$i"
        elif [ "$j" == 5 ];then
            R_TaskProgress="$i"
        elif [ "$j" == 6 ];then
            R_ProcessRatio="$i"
        elif [ "$j" == 8 ];then
            R_IsWaitBIOSReady="$i"
        fi

        j=$(($j + 1))
    done
}

function AsyncDispProgress()
{
    local i
    local PrevTaskProgress=""
    local FailCnt=0

    AsyncGetInfo
    if [ $? != 0 ];then
        DispErr "Async: fail to get info"
        return 255
    fi

    if [ "$R_IsMemAddrValid" == "00" ];then
        echo "No async task"
        return 255
    fi

    if [ "$R_IsTaskExist" != "01" ];then
        if [ "$R_IsCrc32Valid" == "00" ];then
            echo "FW is uploading in other way"
            return 255
        fi

        if [ "$R_TaskProgress" == "00" ];then
            echo "Wait event to trigger updating"
            return 255
        fi

        if [ "$R_IsWaitBIOSReady" == "01" ];then
            echo "Wait BIOS to be ready"
            echo -e "\033[01;32mUpdate successfully !!!\033[0m"
            return 0
        fi
    fi

    for((i = 0; i < 600; i++))
    do
        AsyncGetInfo
        if [ $? != 0 ];then
            FailCnt=$(($FailCnt + 1))
            if [ "$FailCnt" -gt 10 ];then
                DispErr "Async: fail to get info"
                return 255
            fi

            sleep 2s
            continue
        fi

        if [[ "$R_TaskProgress" != "$PrevTaskProgress" &&  "$PrevTaskProgress" != "" ]];then
            echo ""
        fi

        if [ "$R_TaskProgress" == "01" ];then
            echo -ne "\rWait ME to be stable ..."
        elif [ "$R_TaskProgress" == "02" ];then
            echo -ne "\rSwitch device ..."
        elif [ "$R_TaskProgress" == "03" ];then
            echo -ne "\rActivate flash ..."
        elif [ "$R_TaskProgress" == "04" ];then
            echo -ne "\rProtect flash ..."
        elif [ "$R_TaskProgress" == "05" ];then
            echo -ne "\rUpgrading : $((16#$R_ProcessRatio))%"
        elif [ "$R_TaskProgress" == "06" ];then
            echo -ne "\rVerify image ..."
        elif [ "$R_TaskProgress" == "07" ];then
            echo -ne "\rDeactivate flash ..."
        elif [ "$R_TaskProgress" == "08" ];then
            echo -ne "\rWait ME to be stable ..."
        elif [ "$R_TaskProgress" == "0f" ];then
            echo -ne "\rFlash successfully"
        elif [ "$R_TaskProgress" == "10" ];then
            DispErr "Error in CRC verify"
            return 255
        elif [ "$R_TaskProgress" == "11" ];then
            DispErr "Error in CRC verify"
            return 255
        elif [ "$R_TaskProgress" == "12" ];then
            DispErr "Error in switch device"
            return 255
        elif [ "$R_TaskProgress" == "13" ];then
            DispErr "Error in activate flash"
            return 255
        elif [ "$R_TaskProgress" == "14" ];then
            DispErr "Error in protect flash"
            return 255
        elif [ "$R_TaskProgress" == "15" ];then
            DispErr "Error in flash"
            return 255
        elif [ "$R_TaskProgress" == "16" ];then
            DispErr "Error in deactivate flash"
            return 255
        elif [ "$R_TaskProgress" == "1F" ];then
            DispErr "Unknown error (code: $R_TaskProgress)"
            return 255
        else
            DispErr "Unknown progress: $R_TaskProgress"
            return 255
        fi

        PrevTaskProgress="$R_TaskProgress"
        FailCnt=0

        if [ "$R_IsWaitBIOSReady" == "01" ];then
            echo -e "\nWait BIOS to be ready"
            echo -e "\033[01;32mUpdate successfully !!!\033[0m"
            break
        fi

        sleep 1s
    done
}

function MainUpdateBMC()
{
    echo "BMC FW Update >>>>>>"

    tmp=`ls -l $IMAGE | awk '{print $5}'`
    if [ "$PRODUCT_ID" == "Kingler" ];then
        if [[ ! "$tmp" =~ "33554" ]];then
            echo "$IMAGE: damaged file"
            return 255
        fi

        if [[ "$BMC_VERSION" == "82" || "$BMC_VERSION" == "68" ]];then
            res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x32 0xba 0xfc 0x03`
            if [[ $? != 0 || "$res" != "" ]];then
                DispErr "For BMC $BMC_VERSION, fail to disable preserve SDR & FRU & SYSLog & Web config"
                return 255
            fi
            echo "For BMC $BMC_VERSION, disable preserve SDR & FRU & SYSLog & Web config"
        fi
    else
        if [ "$tmp" -ne "33554432" ];then
            echo "$IMAGE: damaged file"
            return 255
        fi
    fi

    if [ "$N_FLAG" == "1" ];then
        echo "Full flash firmware ..."
        res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x32 0xba 0x00 0x00`
        if [[ $? != 0 || "$res" != "" ]];then
            DispErr "Fail to disable preserve config function"
            return 255
        fi
    elif [[ "$PRODUCT_ID" == "ARBOK" && "$BMC_VERSION" == "86" ]];then
        echo "Enable preserving extlog function ..."
        ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0xfe 0x49 0x45 0x43 0x00 \
            0x72 0x73 0x79 0x6e 0x63 0x20 0x2f 0x65 0x78 0x74 0x6c 0x6f 0x67 0x2f 0x2a 0x2e 0x69 \
            0x6e 0x69 0x20 0x2f 0x63 0x6f 0x6e 0x66 0x2f 0x42 0x4d 0x43 0x31 0x2f >/dev/null
        if [ $? != 0 ];then
            echo "Enable preserving extlog function ...Fail"
            return 255
        fi

        sleep 3s
        echo "Enable preserving extlog function ...Done"
    fi

    if [ -f "$EXTRA_FILE" ];then
        BeforeUpdateBMC
        if [ $? != 0 ];then
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
    if [ $? != 0 ];then
        return 255
    fi

    echo -e "\033[01;32mUpdate successfully !!!\033[0m"
}

function MainUpdateBIOSAsync()
{
    echo "Asynchronous mode >>>"
    ACTIVATE_ASYNC_FLAG=1

    if [ "$N_FLAG" != "0" ];then
        res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x1a 0x01`
        if [[ $? != 0 || "$res" != "" ]];then
            DispErr "Fail to set as skipping ME firmware"
            return 255
        fi
        echo "SKip ME firmware ..."
    fi

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

    sleep 2s

    res="`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0xa0`"
    if [ $? != 0 ];then
        DispErr "Fail to check async status"
        return 255
    fi

    if [[ "$res" =~ "00 49 50 54 01" ]];then
        echo "BIOS has been uploaded. Take effect after power off"
        return 0
    elif [[ ! "$res" =~ "00 49 50 54 00" ]];then
        echo "Unknown state: $res"
        return 255
    fi

    AsyncDispProgress
    if [ $? != 0 ];then
        return 255
    fi

    return 0
}

function MainUpdateBIOS()
{
    echo "BIOS FW Update >>>>>>"

    if [ "$PRODUCT_ID" == "ARBOK" ];then
        if [[ "$BMC_VER_MAJOR" -eq 0 && "$BMC_VERSION" -lt 88 ]];then
            DispErr "Updating BIOS requires BMC v0.88 or later, but current BMC is v${BMC_VER_MAJOR}.${BMC_VERSION}\n"\
                    "Please update BMC to v0.88 or later"
            return 255
        fi
    fi

    tmp=`ls -l $IMAGE | awk '{print $5}'`
    if [ "$PRODUCT_ID" == "Kingler" ];then
        if [[ ! "$tmp" =~ "16777" ]];then
            echo "$IMAGE: damaged file"
            return 255
        fi
    else
        if [ "$tmp" -ne "33554432" ];then
            echo "$IMAGE: damaged file"
            return 255
        fi
    fi

    res="`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0xa0 2>/dev/null`"
    if [ $? != 0 ];then
        MainUpdateBIOSCommon
        return 0
    fi

    if [[ ! "$res" =~ "00 49 50 54" ]];then
        MainUpdateBIOSCommon
        if [ $? != 0 ];then
            return 255
        fi

        return 0
    fi

    AsyncGetInfo
    if [ $? != 0 ];then
        DispErr "Async: fail to get info"
        return 255
    fi

    if [ "$R_IsMemAddrValid" == "00" ];then
        if [[ "$res" =~ "00 49 50 54 00" ]];then
            MainUpdateBIOSCommon
            if [ $? != 0 ];then
                return 255
            fi

            return 0
        elif [[ ! "$res" =~ "00 49 50 54 01" ]];then
            echo "Unknown state: $res"
            return 255
        fi

        MainUpdateBIOSAsync
        if [ $? != 0 ];then
            return 255
        fi

        return 0
    fi

    echo "Asynchronous mode >>>"
    AsyncDispProgress
    if [ $? != 0 ];then
        return 255
    fi
}

function KinglerCollectLog()
{
	tftp_ip_with_space="0 0 0 0";
	IPMI_CMD="ipmitool -H $BMC_IP -I lanplus -U $BMC_USER_NAME -P $BMC_PASSWORD"
	username_ascii=`echo $BMC_USER_NAME | tr -d '\n' | xxd -c 100 -i | tr -d ','`
	password_ascii=`echo $BMC_PASSWORD | tr -d '\n' | xxd -c 100 -i | tr -d ','`
	username_len=${#BMC_USER_NAME}
	password_len=${#BMC_PASSWORD}

	TRIGGER_CMD="$IPMI_CMD raw 0x2E 0x15 0xA9 0x19 0x00 \
				 $tftp_ip_with_space $username_len $password_len \
				 $username_ascii $password_ascii"
	STATE_CMD="$IPMI_CMD raw 0x2E 0x16 0xA9 0x19 0x00"
	current_state=`$STATE_CMD | cut -d ' ' -f 5`
	if [ $current_state != "ff" ]; then
	    DispErr "$BMC_IP can't running info collector now."
	    DispErr "Please try it later."
	    exit 255
	fi

	echo "Starting info collector."
	$TRIGGER_CMD > /dev/null #2>&1
	if [ $? -ne 0 ]; then
	    DispErr "Start info collector failed!"
	    exit 255
	fi

	sleep 3

	current_state_d=0
	while [ $current_state_d -lt 100 ];
	do
	    echo -en "Collecting $current_state_d% ...\r"
	    current_state=`$STATE_CMD | cut -d ' ' -f 5`
		((current_state_d=0x`echo $current_state`))
	    sleep 2
	done
	echo
	sleep 1
	current_state=`$STATE_CMD | cut -d ' ' -f 5`
	if [ $current_state != "64" ]; then
	    DispErr "Run info collector failed!"
	    exit 255
	elif [ $current_state == "64" ];then
		echo "Collecting 100% Done !"
		echo " "
	fi

    CreateSession
    if [ $? != 0 ];then
        return 255
    fi
    if [ "$FileName" == "" ];then
        res=`curl -s -X GET https//$BMC_IP/api/GetDownloadPkgName \
                     -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                     -b "$COOKIE" -k | awk '{print $3}'`
        res=${res#*\"}
        res=${res%\"*}
        if [ "$res" == "" ];then
            FileName="dump_`date +%Y%m%d-%H%M`.tar"
            echo "Set file name as $FileName"
        else
            FileName="$res"
        fi
        GetFileName "$FileName"
        FileName="$R_FILE_NAME"
    fi

    echo "Download log ..."
    res=`curl -X GET -o $FileName https://$BMC_IP/api/DownloadOneKeyLog \
              -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
              -b "$COOKIE" -k`
    if [ $? != 0 ];then
        DispErr "Download log ...Fail"
        return 255
    fi
    echo "Download log ...Done"

	CloseSession
    if [ $? != 0 ];then
        return 255
    fi

	$IPMI_CMD raw 0x2e 0x17
}

function MainCollectLog()
{
    local ratio
    local FileName="$1"
    local res
    local i
    local FailCnt=0
    local UnknownStateCnt=0
    local RetryCnt0xFF=0

    if [ "$PRODUCT_ID" == "Kingler" ];then
        KinglerCollectLog
        if [ $? != 0 ];then
            return 255
        fi

        return 0
    fi

    if [ "$PRODUCT_ID" != "ARBOK" ];then
        DispErr "Not support in current BMC"
        return 255
    fi

    echo "Collect log ..."
    res="`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x01`"
    if [ $? != 0 ];then
        DispErr "Collect log ...Fail"
        return 255
    fi

    sleep 2s

    for((i = 0; i < 310; i++))
    do
        res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x02`
        if [ $? != 0 ];then
            FailCnt=$(($FailCnt + 1))
            if [ "$FailCnt" -gt "10" ];then
                DispErr "Collect log ...Fail"
                return 255
            fi

            DispErr "Collect log ...Retry $FailCnt"
            sleep 2s
            continue
        fi

        res=${res#*\ }
        if [ "$res" == "01" ];then
            ratio="0%"
        elif [ "$res" == "02" ];then
            ratio="5%"
        elif [ "$res" == "03" ];then
            ratio="10%"
        elif [ "$res" == "04" ];then
            ratio="15%"
        elif [ "$res" == "05" ];then
            ratio="20%"
        elif [ "$res" == "06" ];then
            ratio="30%"
        elif [ "$res" == "07" ];then
            ratio="40%"
        elif [ "$res" == "08" ];then
            ratio="50%"
        elif [ "$res" == "09" ];then
            ratio="60%"
        elif [ "$res" == "0a" ];then
            ratio="65%"
        elif [ "$res" == "10" ];then
            ratio="70%"
        elif [ "$res" == "11" ];then
            ratio="75%"
        elif [ "$res" == "20" ];then
            ratio="80%"
        elif [ "$res" == "21" ];then
            ratio="85%"
        elif [ "$res" == "22" ];then
            ratio="90%"
        elif [ "$res" == "30" ];then
            ratio="95%"
        elif [ "$res" == "00" ];then
            echo -e "\rCollect log : 100%"
            break;
        else
            if [ "$UnknownStateCnt" -lt 3 ];then
                UnknownStateCnt=$(($UnknownStateCnt + 1))
                sleep 2s
                continue
            fi

            if [ "$res" == "ff" ];then
                if [ "$RetryCnt0xFF" -ge 3 ];then
                    DispErr "Collect task may timeout in BMC, re-collect ...Fail"
                    ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x03 >/dev/null 2>&1
                    return 255
                fi

                RetryCnt0xFF=$(($RetryCnt0xFF + 1))
                echo -e "\nCollect task may timeout in BMC ...Re-collect$RetryCnt0xFF (time=$((2*$i)))"
                i=0
                FailCnt=0
                UnknownStateCnt=0
                ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x03 >/dev/null 2>&1
                sleep 3s
                ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x01 >/dev/null 2>&1
                sleep 2s
            else
                echo -e "\nUnknown state: 0x$res (time=$((2*$i)))"
                return 255
            fi
        fi

        echo -ne "\rCollect log : $ratio"
        sleep 2s
    done

    CreateSession
    if [ $? != 0 ];then
        return 255
    fi

    if [ "$i" -gt "310" ];then
        echo -e "\nCollect log ...Timeout"
        return 255
    fi

    if [ "$FileName" == "" ];then
        res=`curl -s -X GET https://$BMC_IP/api/GetDownloadPkgName \
                  -H "X-CSRFTOKEN:$X_CSRFTOKEN" \
                  -b "$COOKIE" -k | awk '{print $3}'`
        res=${res#*\"}
        res=${res%\"*}
        if [ "$res" == "" ];then
            FileName="dump_`date +%Y%m%d-%H%M`.tar"
            echo "Set file name as $FileName"
        else
            FileName="$res"
        fi

        GetFileName "$FileName"
        FileName="$R_FILE_NAME"
    fi

    echo "Download log ..."
    res="`curl -X GET -o $FileName https://$BMC_IP/api/ipt/download/alllogs -k`"
    if [ $? != 0 ];then
        DispErr "Download log ...Fail"
        return 255
    fi
    echo "Download log ...Done"

    CloseSession
    if [ $? != 0 ];then
        return 255
    fi

    echo "Clear BMC cache ..."
    for((i = 1; i <= 3; i++))
    do
        res="`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x03`"
        if [ $? != 0 ];then
            sleep 2s
            continue
        fi

        break
    done

    if [ "$i" -gt "3" ];then
        echo "Activate BMC to clear automatically"
    else
        echo "Clear BMC cache ...Done"
    fi

    echo "Success and save as \"$FileName\""
}

function MainClient2Server()
{
    local FileName="$1"
    local DestName
    local res

    DestName="${FileName#*\ }"
    FileName="${FileName%%\ *}"

    if [[ "$DestName" =~ "$FileName" || "$DestName" == "" ]];then
        DispErr "DestName is required"
        return 255
    fi

    if [ ! -f "$FileName" ];then
        DispErr "$FileName: no such file"
        return 255
    fi

    res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x20 0x49 0x45 0x43 0x00`
    if [[ $? != 0 || "$res" != "" ]];then
        echo "Prepare for uploading config ...Fail"
        return 255
    fi

    CreateSession
    if [ $? != 0 ];then
        return 255
    fi

    UploadFile "$FileName"

    CloseSession
    if [ $? != 0 ];then
        return 255
    fi

    res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x20 0x49 0x45 0x43 0x02 $DestName`
    if [[ $? != 0 || "$res" != "" ]];then
        echo "Enforce uploading ...Fail"
        return 255
    fi
}

function MainServer2Client()
{
    local FileName="$1"
    local SrcName
    local res

    SrcName="${FileName#*\ }"
    FileName="${FileName%%\ *}"

    if [[ "$SrcName" =~ "$FileName" || "$SrcName" == "" ]];then
        DispErr "SrcName is required"
        return 255
    fi

    if [ -f "$FileName" ];then
        DispErr "$FileName: it has existed"
        return 255
    fi

    res=`ipmitool -H $BMC_IP -U $BMC_USER_NAME -P $BMC_PASSWORD raw 0x3e 0x20 0x49 0x45 0x43 0x03 $SrcName`
    if [[ $? != 0 || "$res" != "" ]];then
        echo "Create link ...Fail"
        return 255
    fi

    CreateSession
    if [ $? != 0 ];then
        return 255
    fi

    echo "Download file ..."

    res="`curl -X GET -o $FileName https://$BMC_IP/api/OEMDownloadFile -k`"
    if [ $? != 0 ];then
        DispErr "Download file ...Fail"
        return 255
    fi

    echo "Download file ...Done"

    CloseSession
    if [ $? != 0 ];then
        return 255
    fi
}

function MainSendRawCommand()
{
    local NetFn
    local cmd
    local data
    local DataLen
    local i

    if [ "$1" == "" ];then
        DispErr "No available parameter"
        return 255
    fi

    DataLen=0
    for i in $1
    do
        if [ "$NetFn" == "" ];then
            NetFn="$i"
            continue
        fi

        if [ "$cmd" == "" ];then
            cmd="$i"
            continue
        fi

        DataLen=1
        break
    done

    if [[ "$NetFn" == "" || "$cmd" == "" ]];then
        DispErr "NetFn and command are required"
        return 255
    fi

    if [ $DataLen == 0 ];then
        data=""
    else
        data="$1"
        data="${data#*\ }"
        data="${data#*\ }"
    fi

    echo "NetFn=$NetFn cmd=$cmd data=\"$data\""

    CreateSession
    if [ $? != 0 ];then
        return 255
    fi

    res=`curl -s -X PUT https://$BMC_IP/api/SendRawCommand \
              -d "{\"data\":\"$1\"}" \
              -H "Content-Type:application/json" \
              -H "X-CSRFTOKEN: $X_CSRFTOKEN" \
              -b "$COOKIE" -k`

    echo $res

    CloseSession
    if [ $? != 0 ];then
        return 255
    fi
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
        G )
            G_FLAG="$OPTARG"
            ;;
        N )
            N_FLAG=1;
            ;;
        E )
            E_FLAG="$OPTARG"
            ;;
        * )
            exit 255
            ;;
    esac
done

if [ "$1" == "raw" ];then
    if [ $# -lt 2 ];then
        DispErr "No available data for \"raw\""
        ErrExit
    fi

    RawData="$@"
    RawData=${RawData#*\ }
    MainSendRawCommand "$RawData"
    SafeExit
fi

if [[ $# == 0 || "$HelpFlag" == "1" ]];then
    DispHelpInfo
    exit 0
fi

echo "$VERSION"

if [ "$VersionFlag" == "1" ];then
    exit 0
fi

if [[ "$BMC_IP" == "" || "$BMC_USER_NAME" == "" || "$BMC_PASSWORD" == "" ]];then
    echo "Require the option \"-H\" or \"-U\" or \"-P\""
    exit 255
fi

GetDeviceID
if [ $? != 0 ];then
    exit 255
fi

if [ "$G_FLAG" == "log" ];then
    MainCollectLog
    exit 0
elif [ "$G_FLAG" == "async" ];then
    AsyncDispProgress
    exit 0
elif [ "$G_FLAG" != "" ];then
    DispErr "$G_FLAG: unknown option"
    exit 255
fi

if [ "$IMAGE" == "" ];then
    echo "Require the option \"-F\" to specify file"
    exit 255
fi

if [ "$E_FLAG" == "c2s" ];then
    MainClient2Server "$IMAGE"
    if [ $? != 0 ];then
        ErrExit
    fi
    SafeExit
elif [ "$E_FLAG" == "s2c" ];then
    MainServer2Client "$IMAGE"
    if [ $? != 0 ];then
        ErrExit
    fi
    SafeExit
elif [ "$E_FLAG" != "" ];then
    DispErr "$E_FLAG: unknown option"
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
elif [[ "$tmp" =~ "BIN" ]];then
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
