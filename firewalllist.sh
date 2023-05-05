#!/bin/bash

Months=("202201" "202202" "202203" "202204" "202205" "202206" "202207" "202208" "202209" "202210" "202211" "202212")
Months23=("202301" "202302" "202303" "202304" "202305")
#Year=("2022" "2023")
if [[ $EUID -ne 0 ]]; then
	echo -e "\nThis script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
	
	if [ -r /etc/os-release ]; then
		os="$(. /etc/os-release && echo -e "$ID")"
	fi
	
	if [[ $os == "ubuntu" ]]; then
		if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
			dateis=$(date +%d%m%Y)
		        timeis=$(date +%H%M%S)
		        uname=$(cat /DNIF/DL/csltuconfig/username)
		        export HADOOP_USER_NAME=$uname
		        cd /opt/hadoop-3.2.3/bin/
                for a in ${!Months[@]}
                do
                    ./hadoop fs -ls /DNIF/events/Scope=default/Stream=FIREWALL/Year=2022/Month=${Months[$a]} >> /var/tmp/dfsfirewalllist__$dateis"T"$timeis.out
                done
                for b in ${!Months23[@]}
                do
                    ./hadoop fs -ls /DNIF/events/Scope=default/Stream=FIREWALL/Year=2023/Month=${Months23[$b]} >> /var/tmp/dfsfirewalllist__$dateis"T"$timeis.out
                done
				for a in ${!Months[@]}
                do
                    ./hadoop fs -du -h /DNIF/events/Scope=default/Stream=FIREWALL/Year=2022/Month=${Months[$a]} >> /var/tmp/dfsfirewallsize__$dateis"T"$timeis.out
                done
                for b in ${!Months23[@]}
                do
                    ./hadoop fs -du -h /DNIF/events/Scope=default/Stream=FIREWALL/Year=2023/Month=${Months23[$b]} >> /var/tmp/dfsfirewallsize__$dateis"T"$timeis.out
                done
            echo -e "\ndfslist report generated successfully!!!\n"
			echo -e "path: /var/tmp/dfsfirewalllist__$dateis"T"$timeis.out\n"
			echo -e "path: /var/tmp/dfsfirewallsize__$dateis"T"$timeis.out\n"
		else
			echo -e "\nThis is not the CORE server!!!\n"
			echo -e "This script should be executed on the CORE server only!!!\n"
		fi
	fi
	
	if [[ $os == "rhel" ]]; then
                if [[ $(podman ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
			dateis=$(date +%d%m%Y)
	 	       	timeis=$(date +%H%M%S)
	 	       	uname=$(cat /DNIF/DL/csltuconfig/username)
	 	       	export HADOOP_USER_NAME=$uname
	 	       	cd /opt/hadoop-3.2.3/bin/
 		       	for a in ${!Months[@]}
                do
                    ./hadoop fs -ls /DNIF/events/Scope=default/Stream=FIREWALL/Year=2022/Month=${Months[$a]} >> /var/tmp/dfsfirewalllist__$dateis"T"$timeis.out
                done
                for b in ${!Months23[@]}
                do
                    ./hadoop fs -ls /DNIF/events/Scope=default/Stream=FIREWALL/Year=2023/Month=${Months23[$a]} >> /var/tmp/dfsfirewalllist__$dateis"T"$timeis.out
                done
				for a in ${!Months[@]}
                do
                    ./hadoop fs -du -h /DNIF/events/Scope=default/Stream=FIREWALL/Year=2022/Month=${Months[$a]} >> /var/tmp/dfsfirewallsize__$dateis"T"$timeis.out
                done
                for b in ${!Months23[@]}
                do
                    ./hadoop fs -du -h /DNIF/events/Scope=default/Stream=FIREWALL/Year=2023/Month=${Months23[$b]} >> /var/tmp/dfsfirewallsize__$dateis"T"$timeis.out
                done
			echo -e "\ndfslist report generated successfully!!!\n"
            echo -e "path: /var/tmp/dfsfirewalllist__$dateis"T"$timeis.out\n"
			echo -e "path: /var/tmp/dfsfirewallsize__$dateis"T"$timeis.out\n"
		else
                echo -e "\nThis is not CORE server!!!\n"
                        echo -e "This should be executed in CORE server only!!!\n"
						
                fi
        fi
fi
