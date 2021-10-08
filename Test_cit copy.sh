#!/bin/bash


#need image // ~/DATA/TEMP/img

# cd /home/admin
# sudo ./test.sh &

logfile="./morton.log"
Falgfile="./update_flag.log"


sleep 600

cd /usr/share/sonic/device/x86_64-alibaba_as14-40d-cl-r0/bmc_api_unittest
export BMC_TEST_PLATFORM=CEL

echo "===========================test begin===================" >> $logfile
flag=$(cat $Falgfile)
date >> $logfile

echo "=======================ping 240.1.1.1=============" >> $logfile
string=$(ping 240.1.1.1 -w 20)
echo $string >> $logfile
if [[ $string == *"100% packet loss"* ]]; then
    echo "===ping Failed=====" >> $logfile
    exit 255
fi

echo "=======================CPLD version=============" >> $logfile
/usr/share/sonic/device/x86_64-alibaba_as14-40d-cl-r0/plugins/get_fw_version.py >> $logfile


#1 CPLD versin 10
if [[ $flag == "1" ]]; then
    echo 2 > $Falgfile
    echo "begin update CPLD versin 10 " >> $logfile
    cp /home/admin/img/Shamu_CTRL_CPLD_V10_20210310.vme  /home/admin/img/as14-40d_cpld_2_cpu_pwr.vme
#2 CPLD versin 11
elif [ $flag == "2" ]; then
    echo 1 > $Falgfile
    echo "begin update CPLD versin 11 " >> $logfile
    cp /home/admin/img/Shamu_CTRL_CPLD_V11_20210715.vme  /home/admin/img/as14-40d_cpld_2_cpu_pwr.vme
else
     echo 1 > $Falgfile
fi

echo "runing   api_unittest --run-tests test_fwmgrutil_refresh.TestFirmwareRefreshUtil.test_firmware_refresh_base_cpld" >> $logfile
./api_unittest --run-tests test_fwmgrutil_refresh.TestFirmwareRefreshUtil.test_firmware_refresh_base_cpld   >> $logfile


sleep 1000
echo "api_unittest   FAIL:  test again   sleep 1000 sonic not reboot fail  ========" >> $logfile
