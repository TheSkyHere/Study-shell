#!/bin/sh
usage() {
    echo "Usage: update BMC thought redfish or BMC factory reset"
    echo "    $(basename $0) <IP>"
    echo "    $(basename $0) <IP> <factory bmc> "
    echo
    echo "Examples:"
    echo "    $(basename $0) 10.75.159.18 imagefile"
    echo "    $(basename $0) 10.75.159.18 f"
}

bmc=$1
##建立 Redfish 连接会话
token=`curl -k -H "Content-Type: application/json" -X POST https://$bmc/login -d '{"username" :  "root", "password" :  "0penBmc"}' | grep token | awk '{print $2;}' | tr -d '"'`
##获取BMC升级的URL
uri=$(curl -k -H "X-Auth-Token: $token" https://$bmc/redfish/v1/UpdateService |grep  '"HttpPushUri"' | awk -F '"' '{print $4;}')
##打印log
echo "bmc=$bmc    token=$token  uri=$uri"

if [ $# -eq 2 ] && [ "$2" = "f" ]; then  ##删除配置
    #恢复出厂设置，删除文件系统中的一些后期文件,立刻重启BMC系统
    curl -k -H "X-Auth-Token: $token" -X POST https://$bmc/redfish/v1/Managers/bmc/Actions/Manager.ResetToDefaults -d '{"ResetToDefaultsType": "ResetAll"}'
elif [ $# -eq 2 ]; then  ##保留配置升级
    ##升级完FW后等待下一次重启后生效
    # curl -k -H "X-Auth-Token: $token" -X PATCH -d '{"HttpPushUriOptions": {"HttpPushUriApplyTime": {"ApplyTime": "OnReset"}}}' https://$bmc/redfish/v1/UpdateService
    ##升级完FW后立刻自动重启后生效
    curl -k -H "X-Auth-Token: $token" -X PATCH -d '{"HttpPushUriOptions": {"HttpPushUriApplyTime": {"ApplyTime": "Immediate"}}}' https://$bmc/redfish/v1/UpdateService
    sleep 1
    ##升级的FW将被拷贝到/tmp/image/下-->对应的接收函数时bmcweb么快的handleUpdateServicePost函数
    # curl -k -H "X-Auth-Token: $token" -H "Content-Type: application/octet-stream" -X POST -T ./build/kestrel/tmp/deploy/images/kestrel/obmc-phosphor-image-kestrel.static.mtd.tar  https://$bmc$uri
    # curl -k -H "X-Auth-Token: $token" -H "Content-Type: application/octet-stream" -X POST -T ./build/gnr5713cmm/tmp/deploy/images/gnr5713cmm/obmc-phosphor-image-gnr5713cmm.static.mtd.tar  https://$bmc$uri
    curl -k -H "X-Auth-Token: $token" -H "Content-Type: application/octet-stream" -X POST -T $2  https://$bmc$uri
    # curl -k -H "X-Auth-Token: $token" -H "Expect:" -X POST -T ./build/gnr5713cmm/tmp/deploy/images/gnr5713cmm/obmc-phosphor-image-gnr5713cmm.static.mtd.tar  https://$bmc$uri
    # sleep 5
    ##重启BMC
    # curl -k -H "X-Auth-Token: $token" -X POST https://$bmc/redfish/v1/Managers/bmc/Actions/Manager.Reset -d '{"ResetType": "GracefulRestart"}'
elif [ $# -eq 3 ] && [ "$3" = "f" ]; then  ##不保留配置升级
    ##升级完FW后等待下一次重启后生效
    curl -k -H "X-Auth-Token: $token" -X PATCH -d '{"HttpPushUriOptions": {"HttpPushUriApplyTime": {"ApplyTime": "OnReset"}}}' https://$bmc/redfish/v1/UpdateService
    ##升级完FW后立刻自动重启后生效
    # curl -k -H "X-Auth-Token: $token" -X PATCH -d '{"HttpPushUriOptions": {"HttpPushUriApplyTime": {"ApplyTime": "Immediate"}}}' https://$bmc/redfish/v1/UpdateService
    sleep 1
    ##升级的FW将被拷贝到/tmp/image/下-->对应的接收函数时bmcweb么快的handleUpdateServicePost函数
    # curl -k -H "X-Auth-Token: $token" -H "Content-Type: application/octet-stream" -X POST -T ./build/kestrel/tmp/deploy/images/kestrel/obmc-phosphor-image-kestrel.static.mtd.tar  https://$bmc$uri
    # curl -k -H "X-Auth-Token: $token" -H "Content-Type: application/octet-stream" -X POST -T ./build/gnr5713cmm/tmp/deploy/images/gnr5713cmm/obmc-phosphor-image-gnr5713cmm.static.mtd.tar  https://$bmc$uri
    curl -k -H "X-Auth-Token: $token" -H "Content-Type: application/octet-stream" -X POST -T $2  https://$bmc$uri
    sleep 1
    curl -k -H "X-Auth-Token: $token" -X POST https://$bmc/redfish/v1/Managers/bmc/Actions/Manager.ResetToDefaults -d '{"ResetToDefaultsType": "ResetAll"}'
    # curl -k -H "X-Auth-Token: $token" -H "Expect:" -X POST -T ./build/gnr5713cmm/tmp/deploy/images/gnr5713cmm/obmc-phosphor-image-gnr5713cmm.static.mtd.tar  https://$bmc$uri
    # sleep 5
    ##重启BMC
    # curl -k -H "X-Auth-Token: $token" -X POST https://$bmc/redfish/v1/Managers/bmc/Actions/Manager.Reset -d '{"ResetType": "GracefulRestart"}'
else
    usage
fi