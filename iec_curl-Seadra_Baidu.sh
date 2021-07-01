#!/bin/bash
if [[ $# != 3  &&  $# != 2 ]] ; then
	echo "Usage: $0 BMC/BIOS/JNLP  IP  [ImagePath]"
	exit
fi
IP=$2
ImagePath=$3
case "$1" in
	"BIOS")
		IP=$2
		ImagePath=$3
		echo "Create session..."
		X_CSRFTOKEN=`curl -k -X POST https://$IP/baidu/session -d 'password=ADMIN&username=ADMIN' -c ./cookie | awk 'BEGIN {FS=":"}  {print $10 }'| cut -c 3-10`
		echo $X_CSRFTOKEN
		echo "Start upload..."
		status=`curl -k  https://$IP/baidu/maintenance/BIOS/firmware  -F "fwimage=@${ImagePath}" -H "X-CSRFTOKEN:$X_CSRFTOKEN"  -b ./cookie`
		echo $status
		echo "Start configure..."
		status=`curl -k -X POST https://$IP/baidu/maintenance/BIOS/configuration  -d '{"action":"04"}' -H "Content-Type:application/json" -H "X-CSRFTOKEN: $X_CSRFTOKEN"  -b ./cookie`
		echo $status
		echo " Start upgrade..."
		status=`curl -k -X POST https://$IP/baidu/maintenance/BIOS/upgrade  -d '{"action":"03"}' -H "Content-Type:application/json" -H "X-CSRFTOKEN: $X_CSRFTOKEN"  -b ./cookie`
		echo $status	
	;;
	"BMC")
		IP=$2
		ImagePath=$3
		echo "Create session..."
		X_CSRFTOKEN=`curl -k -X POST https://$IP/baidu/session -d 'password=ADMIN&username=ADMIN' -c ./cookie | awk 'BEGIN {FS=":"}  {print $10 }'| cut -c 3-10`
		echo $X_CSRFTOKEN
		echo "Start upload..."
		status=`curl -k  https://$IP/baidu/maintenance/BMC/firmware  -F "fwimage=@${ImagePath}" -H "X-CSRFTOKEN:$X_CSRFTOKEN"  -b ./cookie`
		echo $status
		echo "Start configure..."
		status=`curl -k -X POST https://$IP/baidu/maintenance/BMC/configuration  -d '{"action":"04"}' -H "Content-Type:application/json" -H "X-CSRFTOKEN: $X_CSRFTOKEN"  -b ./cookie`
		echo $status
		echo " Start upgrade..."
		status=`curl -k -X POST https://$IP/baidu/maintenance/BMC/upgrade  -d '{"action":"03"}' -H "Content-Type:application/json" -H "X-CSRFTOKEN: $X_CSRFTOKEN"  -b ./cookie`
		echo $status
		echo "Wait 10min( WriteFwIntoFlashAndReboot ) before you check FW version to confirm updating OK"
		#echo " Query status ..."
		#status=`curl -k -X GET https://$IP/baidu/maintenance/BMC/status -b ./cookie`
		#echo $status
		;;
	"JNLP")
		IP=$2
		echo "Create session..."
		X_CSRFTOKEN=`curl -k -X POST https://$IP/baidu/session -d 'password=ADMIN&username=ADMIN' -c ./cookie | awk 'BEGIN {FS=":"}  {print $10 }'| cut -c 3-10`
		echo $X_CSRFTOKEN

		echo "Download jviewer.jnlp file "
		status=`curl -k  -o ${IP}-jviewer.jnlp  https://$IP/api/remote_control/get/kvm/launch -H "X-CSRFTOKEN:$X_CSRFTOKEN" -b ./cookie`
		echo "1>Execute \"find / -name jcontrol\" to get your java control panel tool path(eg:/usr/lib/jvm/jdk1.8.0_171/bin/jcontrol )"
		echo "2>Execute jcontrol to launch java control panel"
		echo "3>Under Security lable, Add http/https://BMCIP in to exception list (avoid Security checking)"	
		echo "3>Run \"javaws ${IP}-jviewer.jnlp\" to launch kvm window "
		;;
#	"JNLPOLD")
#		IP=$2
#		echo "Create session..."
#		#X_CSRFTOKEN=`curl -k -X POST https://$IP/baidu/session -d 'password=ADMIN&username=ADMIN' -c ./cookie | awk 'BEGIN {FS=":"}  {print $10 }'| cut -c 3-10`
#		#{ "ok": 0, "privilege": 4, "extendedpriv": 259, "racsession_id": 8, "remote_addr": "192.168.0.4", "server_name": "192.168.0.9", "server_addr": "192.168.0.9", "HTTPSEnabled": 1, "CSRFToken": "fDTVSlQj" }% 	
#		CmdRes="`curl -k -X POST https://$IP/baidu/session -d 'password=ADMIN&username=ADMIN' -c ./cookie`" 
#		echo $CmdRes | grep "error"
#		if [ $? = 0 ];then
#			echo "Create session error"
#			exit 1
#		fi
#		X_CSRFTOKEN=`echo $CmdRes | awk 'BEGIN {FS=":"}  {print $10 }'| cut -c 3-10`
#		privilege=`echo $CmdRes | awk 'BEGIN {FS=":"}  {print $3 }'| sed 's/ //g' | awk -F"," '{ print $1 }'`
#		extendedpriv=`echo $CmdRes | awk 'BEGIN {FS=":"}  {print $4 }'| sed 's/ //g' | awk -F"," '{ print $1}'`
#		echo "$X_CSRFTOKEN $privilege $extendedpriv"
#		echo "Download jviewer.jnlp file "
#		echo "curl -k -H "X-CSRFTOKEN:$X_CSRFTOKEN" -b ./cookie -o jviewer.jnlp  https://$IP/api/kvmjnlp?protocol=https&externalIP=${IP}&UserName=ADMIN&JNLPSTR=JViewer&role=${privilege}&extended_privilege=${extendedpriv}"
#		status=`curl  -o jviewer.jnlp  https://$IP/api/kvmjnlp?protocol=https&externalIP=${IP}&UserName=ADMIN&JNLPSTR=JViewer&role=${privilege}&extended_privilege=${extendedpriv}`
#		
#		echo "1>Execute \"find / -name jcontrol\" to get your java control panel tool path(eg:/usr/lib/jvm/jdk1.8.0_171/bin/jcontrol )"
#		echo "2>Execute jcontrol to launch java control panel"
#		echo "3>Under Security lable, Add http/https://BMCIP in to exception list (avoid Security checking)"	
#		echo "3>Run \"javaws ${IP}-jviewer.jnlp\" to launch kvm window "
#		;;
	?)
		echo "Usage: $0 BMC/BIOS  IP  ImagePath"
		;;
esac
