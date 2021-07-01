#!/bin/bash

BMCVERSION="v1.2.0"
DEVICE="x86_64-alibaba_as14-40d-cl-r0"
DIAGTOOLPATH="/usr/local/CPU_Diag/bin/"
VERSION_TOOL="./cel-cpld-test -v"
TESTCASE="test_firmware_refresh_cpld"

#COME_CPLD_VERSION_A="COMe board CPLD version: 0x14"
#BASE_CPLD_VERSION_A="Base board CPLD version: 0x10"
#FAN_CPLD_VERSION_A="FAN CPLD Version     : 0x00"
SW_CPLD_VERSION_A="Switch CPLD-1 version: 0x06"
#LC1_CPLD_VERSION_A="Top Line CPLD1 Version : 0x0c"
#LC2_CPLD_VERSION_A="BOT Line CPLD1 Version : 0x0c"
#FPGA_VERSION_A="0x00000006"
VERSION_A_CONFIG_FILE="/usr/share/sonic/device/$DEVICE/bmc_api_unittest/unittest_config.py.a"

#COME_CPLD_VERSION_B="COMe board CPLD version: 0x14"
#BASE_CPLD_VERSION_B="Base board CPLD version: 0x0e"
#FAN_CPLD_VERSION_B="FAN CPLD Version     : 0x00"
SW_CPLD_VERSION_B="Switch CPLD-1 version: 0x07"
#LC1_CPLD_VERSION_B="Top Line CPLD1 Version : 0x0b"
#LC2_CPLD_VERSION_B="BOT Line CPLD1 Version : 0x0b"
VERSION_B_CONFIG_FILE="/usr/share/sonic/device/$DEVICE/bmc_api_unittest/unittest_config.py.b"

USE_CONFIG_FILE="/usr/share/sonic/device/$DEVICE/bmc_api_unittest/unittest_config.py"

AB_file="/home/admin/img/abfile"
cycle_file="/home/admin/img/cycle"
bmc_reboot_cnt="/home/admin/img/bmc_reboot_cnt"

__PRINT_LOG_BRIEF="/home/admin/img/refresh_cpld.log"
__PRINT_LOG="${__PRINT_LOG_BRIEF}all"
touch ${__PRINT_LOG_BRIEF}
touch ${__PRINT_LOG}

__CYCLE=200

function log_only() {
	echo -e "[`date +"%F_%H-%M-%S"`] $*" >> ${__PRINT_LOG}
    sync
	return $?
}

function print_log(){ 
	echo -e "[`date +"%F_%H-%M-%S"`] $*" | tee -a ${__PRINT_LOG}
	echo -e "$*" >> ${__PRINT_LOG_BRIEF}
    sync
	return $?
}

function file_exist() {
	local file=$1

	[ -f "$file" ] || {
        echo "$file is not exist"
		return 1
	}
	return 0
}

function set_refresh_fw()
{
    cd /usr/share/sonic/device/$DEVICE/bmc_api_unittest
    rm -f $USE_CONFIG_FILE
    cp $1 $USE_CONFIG_FILE
}

function var_verify_cycle()
{
	local v=$1
	if [ ${v} -gt ${__CYCLE} ] ; then
		print_log "$[$FUNCNAME] cycle [$v], test finished!!!"
		return 2
	fi
	return 0
}

function check_ab_version()
{
    if [[ $1 = *$2* ]]
    then
        log_only "Check $2 OK"
        return 0
    else
        log_only "Check $2 Fail"
        exit 1
    fi   
}

function check_version()
{
    cd $DIAGTOOLPATH

    local version=$($VERSION_TOOL)

    if [ "$1" = "A" ]; then
        #check_ab_version "$version" "$COME_CPLD_VERSION_A"
        #check_ab_version "$version" "$BASE_CPLD_VERSION_A"
        #check_ab_version "$version" "$FAN_CPLD_VERSION_A"
        check_ab_version "$version" "$SW_CPLD_VERSION_A"
        #check_ab_version "$version" "$LC1_CPLD_VERSION_A"
        #check_ab_version "$version" "$LC2_CPLD_VERSION_A"
        # check_ab_version "$version" "$FPGA_VERSION_A"
    elif [ "$1" = "B" ]; then
        #check_ab_version "$version" "$COME_CPLD_VERSION_B"
        #check_ab_version "$version" "$BASE_CPLD_VERSION_B"
        #check_ab_version "$version" "$FAN_CPLD_VERSION_B"
        check_ab_version "$version" "$SW_CPLD_VERSION_B"
        #check_ab_version "$version" "$LC1_CPLD_VERSION_B"
        #check_ab_version "$version" "$LC2_CPLD_VERSION_B"
        # check_ab_version "$version" "$FPGA_VERSION_A"
    fi
}

function check_bmc_reboot()
{
    local last_bmc_reboot_cnt=`cat $bmc_reboot_cnt`
    local curr_bmc_reboot_cnt=`boot_info.sh | head -n 1 | awk -F ":  " '{print $2}'`

    if [ $((last_bmc_reboot_cnt+1)) -ne $curr_bmc_reboot_cnt ];then
        print_log "BMC restarted abnormally... Failed"
        cmd="boot_info.sh"
        eval ${cmd} 2>&1 >> ${__PRINT_LOG}
    fi

    echo $curr_bmc_reboot_cnt > $bmc_reboot_cnt
    sync
}

function check_restful()
{
    print_log "Check restful status..."
    for ((i=1; i<30; i++))
    do
        bmc-exec "cat /etc/issue" | grep -i "$BMCVERSION" > /dev/null
        if [ $? -ne 0 ];then
            print_log "retry to connect bmc restful... $i"
            sleep 10
            continue
        fi
        break
    done

    if [ $i -eq 30 ];then
        print_log "Cannot to connect restful service... Failed"
        exit 1
    fi
}

function refresh_cpld_stress()
{
    sleep 60

    local Next_A_B=
    local current_cycle=
    local is_first=0

    echo "### refresh cpld stress ###"

    check_restful

    file_exist $AB_file
    if [ $? -eq 1 ]; then
        print_log "###### loop1 start ######"

        set_refresh_fw $VERSION_A_CONFIG_FILE

        mkdir -p `dirname ${AB_file}` && touch ${AB_file}
		mkdir -p `dirname ${cycle_file}` && touch ${cycle_file}

		echo "B">$AB_file
		echo "1">$cycle_file
        is_first=1
        sync
    fi
    Next_A_B=`cat $AB_file`
    current_cycle=`cat $cycle_file`
    var_verify_cycle $current_cycle
	[[ $? -eq 0 ]] || {
        print_log "Verify cycle is ok"
		return 0
	}

    if [ $is_first -eq 0 ];then
        # check_bmc_reboot

        if [ $Next_A_B == "B" ]; then
            print_log "checking verA..."
            check_version "A"
            set_refresh_fw $VERSION_B_CONFIG_FILE
            echo "A">$AB_file
            sleep 1
            echo "A">$AB_file
        elif [ $Next_A_B == "A" ]; then
            print_log "checking verB..."
            check_version "B"
            set_refresh_fw $VERSION_A_CONFIG_FILE
            echo "B">$AB_file
            sleep 1
            echo "B">$AB_file
        fi
    fi

    print_log "======================== Cycle $current_cycle Start======================="
    current_cycle=$((current_cycle+1))
	echo $current_cycle > $cycle_file
    sync
    export BMC_TEST_PLATFORM=CEL
    cd /usr/share/sonic/device/$DEVICE/bmc_api_unittest
    cmd="./api_unittest --run-tests test_fwmgrutil_refresh.TestFirmwareRefreshUtil.$TESTCASE"
    eval ${cmd} 2>&1 >> ${__PRINT_LOG}
}

refresh_cpld_stress &