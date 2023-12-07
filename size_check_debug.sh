#!/bin/bash


Stream=("OTHER" "FIREWALL" "WAF" "WEBSERVER" "APPLICATION" "LOADBALANCER" "WIN-AUDIT" "IAM" "WEBFILTER" "DATABASE" "CONFIGURATION" "AUTHENTICATION" "THREAT" "DBBACKUP" "VPN" "IPS" "TREND-MICRO-DSA" "EMAIL-GATEWAY")
Months23=("202301" "202302" "202303" "202304" "202305" "202306" "202307" "202308" "202309" "202310" "202311" "202312")
Months22=("202201" "202202" "202203" "202204" "202205" "202206" "202207" "202208" "202209" "202210" "202211" "202212")

if [[ $EUID -ne 0 ]]; then
	echo -e "\nThis script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
	os=""
	if [ -r /etc/os-release ]; then
		os=$(. /etc/os-release && echo -e "$ID")
	fi
	
    get_details () {
        dateis=$(date +%d%m%Y)
        timeis=$(date +%H%M%S)
        uname=$(cat /DNIF/DL/csltuconfig/username)
        export HADOOP_USER_NAME=$uname
        cd /opt/hadoop-3.2.3/bin/
        
 
        ./hadoop fs -du -h "/DNIF/" >> "/var/tmp/dfssize_dnif_${dateis}T${timeis}.out"

        ./hadoop fs -du -h "/DNIF/events/Scope=default" >> "/var/tmp/dfssize_events_streams_${dateis}T${timeis}.out"
        
        ./hadoop fs -du -h "/DNIF/records/Scope=default" >> "/var/tmp/dfssize_records_streams_${dateis}T${timeis}.out"
        #---------------------------------------------------------------------------------
        for a in "${!Stream[@]}"; do
            ./hadoop fs -du -h "/DNIF/events/Scope=default/Stream=${Stream[$a]}/Year=2023/" >> "/var/tmp/dfssize_stream_months_23_${dateis}T${timeis}.out"
        done

        for a in "${!Stream[@]}"; do
            for i in "${!Months23[@]}"; do
                ./hadoop fs -du -h "/DNIF/events/Scope=default/Stream=${Stream[$a]}/Year=2023/Month=${Months23[$i]}" >> "/var/tmp/dfssize_stream_days_23_${dateis}T${timeis}.out"
            done
        done
        #------------------------------------
        for a in "${!Stream[@]}"; do
            ./hadoop fs -du -h "/DNIF/events/Scope=default/Stream=${Stream[$a]}/Year=2022/" >> "/var/tmp/dfssize_stream_months_22_${dateis}T${timeis}.out"
        done

        for a in "${!Stream[@]}"; do
            for i in "${!Months22[@]}"; do
                ./hadoop fs -du -h "/DNIF/events/Scope=default/Stream=${Stream[$a]}/Year=2022/Month=${Months22[$i]}" >> "/var/tmp/dfssize_stream_days_22_${dateis}T${timeis}.out"
            done
        done
        
        #---------------------------------------------------------------------------------
        for a in "${!Stream[@]}"; do
            ./hadoop fs -du -h "/DNIF/records/Scope=default/Stream=${Stream[$a]}/Year=2023/" >> "/var/tmp/dfssize_stream_months_records_23_${dateis}T${timeis}.out"
        done

        for a in "${!Stream[@]}"; do
            for i in "${!Months23[@]}"; do
                ./hadoop fs -du -h "/DNIF/records/Scope=default/Stream=${Stream[$a]}/Year=2023/Month=${Months23[$i]}" >> "/var/tmp/dfssize_stream_days_records_23_${dateis}T${timeis}.out"
            done
        done
        #------------------------------------
        for a in "${!Stream[@]}"; do
            ./hadoop fs -du -h "/DNIF/records/Scope=default/Stream=${Stream[$a]}/Year=2022/" >> "/var/tmp/dfssize_stream_months_records_22_${dateis}T${timeis}.out"
        done

        for a in "${!Stream[@]}"; do
            for i in "${!Months22[@]}"; do
                ./hadoop fs -du -h "/DNIF/records/Scope=default/Stream=${Stream[$a]}/Year=2022/Month=${Months22[$i]}" >> "/var/tmp/dfssize_stream_days_records_22_${dateis}T${timeis}.out"
            done
        done
        
        echo -e "\ndfslist report generated successfully!!!\n"
        echo -e "path: /var/tmp/dfssize_dnif_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_events_streams_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_records_streams_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_months_23_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_days_23_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_months_22_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_days_22_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_months_records_23_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_days_records_23_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_months_records_22_${dateis}T${timeis}.out"
        echo -e "path: /var/tmp/dfssize_stream_days_records_22_${dateis}T${timeis}.out"
    }

	if [[ $os == "ubuntu" ]]; then
		if docker ps -a --format '{{.Names}}' | grep -wq "core-v9"; then
            get_details
		else
			echo -e "\nThis is not the CORE server!!!\n"
			echo -e "This script should be executed on the CORE server only!!!\n"
		fi
	fi
	
	if [[ $os == "rhel" ]]; then
        if podman ps -a --format '{{.Names}}' | grep -wq "core-v9"; then
			get_details
		else
            echo -e "\nThis is not the CORE server!!!\n"
            echo -e "This script should be executed on the CORE server only!!!\n"
        fi
    fi
fi
