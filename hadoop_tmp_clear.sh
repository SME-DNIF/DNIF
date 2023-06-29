#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo -e "\nThis script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
    if [ -r /etc/os-release ]; then
		os="$(. /etc/os-release && echo -e "$ID")"
	fi
    
    dateis=$(date +%d-%m-%Y)
	timeis=$(date +%H:%M:%S)
    cwd=$(pwd)
    
function hadoop_tmp_clear() {
    uname=$(cat /DNIF/DL/csltuconfig/username)
    export HADOOP_USER_NAME=$uname
    cd /opt/hadoop-3.2.3/bin/
    tmp_count=$(./hadoop fs -ls /tmp/hive/$uname  | wc -l)
    if [[ $tmp_count -gt 700000 ]]; then        
        echo -e "$dateis $timeis count of tmp files in hadoop is $tmp_count" >> $cwd/hadoop_tmp_clear.log
        timeout 240s ./hadoop fs -rm -r /tmp/hive/$uname/* 
        echo -e "$dateis $timeis executed hadoop tmp clear command for 180s" >> $cwd/hadoop_tmp_clear.log
        tmp_count_new=$(./hadoop fs -ls /tmp/hive/$uname  | wc -l)
        echo -e "$dateis $timeis updated count of tmp files in hadoop is $tmp_count_new" >> $cwd/hadoop_tmp_clear.log
    else
        echo -e "$dateis $timeis count of tmp files in hadoop is $tmp_count" >> $cwd/hadoop_tmp_clear.log
    fi
} 

    if [[ $os == "ubuntu" ]]; then
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
            hadoop_tmp_clear        
        fi
    fi

    if [[ $os == "centos" ]]; then
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
            hadoop_tmp_clear        
        fi
    fi

    if [[ $os == "rhel" ]]; then
        if [[ $(podman ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
            hadoop_tmp_clear
        fi
    fi

fi
