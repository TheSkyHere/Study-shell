#!/bin/bash

logfile="/home/admin/AC_cycle_log.log"
date  >> $logfile


echo "=========================== CIT test START==============================================" >> $logfile
sleep 240

sudo su
cd /usr/share/sonic/device/x86_64-alibaba_as24-128d-cl-r0/bmc_api_unittest
export BMC_TEST_PLATFORM=CEL


string=$(./api_unittest --run-tests test_fwmgrutil_refresh.TestFirmwareRefreshUtil.test_firmware_refresh_bios)
echo $string >> $logfile

if [[ $string == *"Failed"* ]]; then
    echo "===========================Failed to refresh firmware=============" >> $logfile
    sleep 30
    string=$(./api_unittest --run-tests test_fwmgrutil_refresh.TestFirmwareRefreshUtil.test_firmware_refresh_bios)
    echo $string >> $logfile

    if [[ $string == *"Failed"* ]]; then
        echo "===========================Failed to refresh firmware again=============" >> $logfile
        sleep 30
        reboot
    fi
fi
