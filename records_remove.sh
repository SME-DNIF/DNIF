#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "\nThis script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
    os=""
    if [ -r /etc/os-release ]; then
        os=$(source /etc/os-release && echo "$ID")
    fi

    records_clean() {
        dateis=$(date +%d%m%Y)
        timeis=$(date +%H%M%S)
        uname=$(cat /DNIF/DL/csltuconfig/username)
        export HADOOP_USER_NAME=$uname
        cd /opt/hadoop/bin/

        ./hdfs dfs -rm -r "/DNIF/records/Scope=default/" >> "/var/tmp/records_clean${dateis}T${timeis}.out" 2>&1

        echo -e "\nrecords_clean log recorded successfully!!!\n"
        echo -e "path: /var/tmp/records_clean${dateis}T${timeis}.out"
    }

    if [[ $os == "ubuntu" ]]; then
        records_clean
    fi
fi

