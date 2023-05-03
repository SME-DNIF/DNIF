#!/bin/bash
console_address=$(cat audit_trail.yaml | grep -i "console_address" | awk '{ print $2 }')
cluster_id=$(cat audit_trail.yaml | grep -i "cluster_id" | awk '{ print $2 }')
nstart_time=$(cat audit_trail.yaml | grep -i "start_time" | awk '{ print $2 }')
nend_time=$(cat audit_trail.yaml | grep -i "end_time" | awk '{ print $2 }')
start_time=$(date -d $nstart_time +"%s")
end_time=$(date -d $nend_time +"%s")
ssid=$(cat audit_trail.yaml | grep -i "ssid" | awk '{ print $2 }')
psize=$(cat audit_trail.yaml | grep -i "page_size" | awk '{ print $2 }')
dateis=$(date +%d%m%Y)
p_w_d=$(pwd)
ssid_error='{"status":"invalid","status_code":400}'
ip_error='Failed to connect to '$console_address' port 443'
clutid_er='<!doctype html><html lang="en"><head><meta charset="utf-8"/><title>DNIF | Analytics Console</title><meta name="viewport"'

function cluster() {
	curl_error_code=$(curl -k "https://$console_address/$cluster_id/mgmt/core/audit-trail?from=$start_time&to=$end_time&pageno=1&pagesize=1" -H "ssid: $ssid" --silent; echo $?)
	if [[ "$curl_error_code" == *"$ssid_error"* ]]; then
		echo -e "Error: $ssid_error\n"
		echo -e "Please check the ssid"
		echo -e "-----------------------------------------------------------------------------------------"
	elif [ "$curl_error_code" = "7" ]; then
                echo -e "Error: $ip_error\n"
                echo -e "Please check the console ip"
		echo -e "-----------------------------------------------------------------------------------------"
	elif [[ "$curl_error_code" == *"$clutid_er"* ]]; then
		echo -e "Error: Invalid cluster id $cluster_id\n"
		echo -e "Please check the cluster id"
                echo -e "-----------------------------------------------------------------------------------------"
	else
		curl -k "https://$console_address/$cluster_id/mgmt/core/audit-trail?from=$start_time&to=$end_time&pageno=1&pagesize=$psize" -H "ssid: $ssid" -o ./log/cluster_audit/cluster_audit_trail_$dateis"_"$start_time"_"$end_time.log --silent
		echo -e "Cluster Audit Trail log (cluster_audit_trail_$dateis"_"$start_time"_"$end_time.log) has been created at path: $p_w_d/log/cluster_audit/"
		echo -e "-----------------------------------------------------------------------------------------"
	fi
}

function console() {
	curl_error_code=$(curl -k "https://$console_address/lc/mgmt/audit-trail/?from=$start_time&to=$end_time&pageno=1&pagesize=$psize" -H "ssid: $ssid" --silent; echo $?)
        if [[ "$curl_error_code" == *"$ssid_error"* ]]; then
                echo -e "Error: $ssid_error\n"
                echo -e "Please check the ssid"
                echo -e "-----------------------------------------------------------------------------------------"
        elif [ "$curl_error_code" = "7" ]; then
                echo -e "Error: $ip_error\n"
                echo -e "Please check the console ip"
                echo -e "-----------------------------------------------------------------------------------------"
	else
                curl -k "https://$console_address/lc/mgmt/audit-trail/?from=$start_time&to=$end_time&pageno=1&pagesize=$psize" -H "ssid: $ssid" -o ./log/console_audit/console_audit_trail_$dateis"_"$start_time"_"$end_time.log --silent
                echo -e "Console Audit Trail log (console_audit_trail_$dateis"_"$start_time"_"$end_time.log) has been created at path: $p_w_d/log/console_audit/"
                echo -e "-----------------------------------------------------------------------------------------"
        fi
}
echo -e "-----------------------------------------------------------------------------------------"
echo -e "* Select a Audit Trail Log you want"
echo -e "    [1] Cluster Audit Trail"
echo -e "    [2] Console Audit Trail"
echo -e "-----------------------------------------------------------------------------------------"

CHOICE=""
while [[ ! $CHOICE =~ ^[1-2] ]]; do
  echo -e "Pick the number for the corresponding Audit Trail (1 - 2):  \c"
  read -r CHOICE
  done
echo -e "-----------------------------------------------------------------------------------------"
case "${CHOICE^^}" in
    1)
        cluster
        ;;
    2)
        console
        ;;
    esac
