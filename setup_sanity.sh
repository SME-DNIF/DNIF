if [[ $EUID -ne 0 ]]; then
	echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
    cwd=$(pwd)
     
	dateis=$(date +%d%m%Y)

	if [[ -e ./Setup_Report_$dateis.log ]]; then
		rm -rf ./Setup_Report_$dateis.log
		touch Setup_Report_$dateis.log
	else
		touch Setup_Report_$dateis.log
	fi

	if [[ -e ./OS_logs_$dateis.tar.gz ]]; then
		rm -rf ./OS_logs_$dateis.tar.gz
	fi

	if [[ -e ./history_$dateis.log ]]; then
		rm -rf ./history_$dateis.log
	fi

	if [[ -e ./top_$dateis.log ]]; then
		rm -rf ./top_$dateis.log
	fi

	if [[ -e ./ps_pcpu_$dateis.log ]]; then
		rm -rf ./ps_pcpu_$dateis.log
	fi

	if [[ -e ./ps_rss_$dateis.log ]]; then
		rm -rf ./ps_rss_$dateis.log
	fi

	if [[ -e ./System_Report_$dateis.tar.gz ]]; then
		rm -rf ./System_Report_$dateis.tar.gz
	fi

    if [[ -e ./service_logs_$dateis.tar.gz ]]; then
		rm -rf ./service_logs_$dateis.tar.gz
	fi

    #----------------------------------------------------------------------------------------------------------
    function ip_connectivity() {
    
	    ip_addresses=$(cat /DNIF/PICO/docker-compose.yaml | grep -i core | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')

	    echo -e "Testing connection with Core IP($ip_addresses):\n" >> $cwd/Setup_Report_$dateis.log

	    for i in $ip_addresses;
	    do
        echo -e "\n ---------------------------------------------------------------------------- \n"
		printf "Testing connectivity with $i on port 1443\n" >> $cwd/Setup_Report_$dateis.log
		echo -e "$ nc -z -v $i 1443" >> $cwd/Setup_Report_$dateis.log
		nc -z -v $i 1443 &>> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n"
		printf "\nTesting connectivity with $i on port 8086\n" >> $cwd/Setup_Report_$dateis.log
		echo -e "$ nc -z -v $i 8086" >> $cwd/Setup_Report_$dateis.log
		nc -z -v $i 8086 &>> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n"
		printf "\nTesting connectivity with $i on port 8765\n" >> $cwd/Setup_Report_$dateis.log
		echo -e "$ nc -z -v $i 8765" >> $cwd/Setup_Report_$dateis.log
		nc -z -v $i 8765 &>> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n"
	    done

	}

    function hadoop_spark_servers_status() {
        echo -e "***** HADDOP DATANDOE SERVICE ***** \n" >> $cwd/Setup_Report_$dateis.log
        systemctl status hadoop-datanode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

        echo -e "***** SPARK MASTER DATANDOE SERVICE *****\n" >> $cwd/Setup_Report_$dateis.log
        systemctl status spark-master.service | grep -i active >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

        echo -e "***** SPARK SLAVE DATANDOE SERVICE *****\n" >> $cwd/Setup_Report_$dateis.log
        systemctl status spark-slave.service | grep -i active >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

        echo -e "***** QUERY-CORRELATION-REPORT SERVER STATUS *****\n" >> $cwd/Setup_Report_$dateis.log
        ps -aux | grep -i "thrift"  >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
    }

    function dn_service_logs() {
        echo -e "***** DATANODE SERVICE LOGS *****\n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "dn_monitor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/dn_monitor.log >> $cwd/Setup_Report_$dateis.log                               
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "health_reporter.log" >> $cwd/Setup_Report_$dateis.log	
        tail /DNIF/DL/log/health_reporter.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "robocop.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/robocop.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "sheepdog.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/sheepdog.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "supervisor_monitor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/supervisor_monitor.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
    }
    
    function core_service_logs() {
        echo -e "***** MASTER DATANODE SERVICE LOGS *****\n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "dn_monitor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/dn_monitor.log >> $cwd/Setup_Report_$dateis.log               
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "health_reporter.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/health_reporter.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "robocop.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/robocop.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "sheepdog.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/sheepdog.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "supervisor_monitor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/DL/log/supervisor_monitor.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

        echo -e "***** CORE SERVICE LOGS *****\n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "api_service.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/api_service.log >> $cwd/Setup_Report_$dateis.log  
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "auto_scheduler.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/auto_scheduler.log >> $cwd/Setup_Report_$dateis.log  
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "celery_scheduler.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/celery_scheduler.log >> $cwd/Setup_Report_$dateis.log  
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "cluster_api_service.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/cluster_api_service.log >> $cwd/Setup_Report_$dateis.log  
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "core_worker.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/core_worker.log >> $cwd/Setup_Report_$dateis.log  
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "dispatcher_api_service.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/dispatcher_api_service.log >> $cwd/Setup_Report_$dateis.log  
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "signal_sync.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/signal_sync.log >> $cwd/Setup_Report_$dateis.log   
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "health_reporter.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/health_reporter.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "robocop.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/robocop.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "sheepdog.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/sheepdog.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "supervisor_monitor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/CO/log/supervisor_monitor.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
    }

    function adapter_service_logs() {
        echo -e "***** ADAPTER SERVICE LOGS *****\n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n"
        echo -e "log of dfs_put" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/dfs_put.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "enrich_process.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/enrich_process.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "eps-governor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/eps-governor.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "health_reporter.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/health_reporter.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "indexer_process.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/indexer_process.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "log_consumer.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/log_consumer.log >> $cwd/Setup_Report_$dateis.log               
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "parser_process.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/parser_process.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "robocop.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/robocop.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "sheepdog.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/sheepdog.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "supervisor_monitor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/AD/log/supervisor_monitor.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
    }

    function pico_service_logs() {
        echo -e "***** PICO SERVICE LOGS *****\n" >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "eps-governor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/PICO/log/eps-governor.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "filter_engine" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/PICO/log/filter_engine.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "native_forwarder.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/PICO/log/native_forwarder.log >> $cwd/Setup_Report_$dateis.log               
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "health_reporter.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/PICO/log/health_reporter.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "robocop.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/PICO/log/robocop.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "sheepdog.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/PICO/log/sheepdog.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
        echo -e "supervisor_monitor.log" >> $cwd/Setup_Report_$dateis.log
        tail /DNIF/PICO/log/supervisor_monitor.log >> $cwd/Setup_Report_$dateis.log
        echo -e "\n ---------------------------------------------------------------------------- \n" >> $cwd/Setup_Report_$dateis.log
    }

    #----------------------------------------------------------------------------------------------------------
    echo -e "\n================================Setup Report=================================\n" >> $cwd/Setup_Report_$dateis.log

    echo -e "***** TIMEDATECTL *****\n" >> $cwd/Setup_Report_$dateis.log

    timedatectl >> $cwd/Setup_Report_$dateis.log

    echo -e "***** IP OF THE SERVER ***** \n" >> $cwd/Setup_Report_$dateis.log

    ifconfig >> $cwd/Setup_Report_$dateis.log

    echo -e "***** HOSTNAME ***** \n" >> $cwd/Setup_Report_$dateis.log

    hostname >> $cwd/Setup_Report_$dateis.log
    
    echo -ne '##                        (10%)\r'
    echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
    #===========================================================================================================
    if [ -r /etc/os-release ]; then
		os="$(. /etc/os-release && echo -e "$ID")"
	fi
    #===========================================================================================================

    if [[ $os == "ubuntu" ]]; then
        #------------------------------------------------------------------------------------------------------
        echo -e "***** DOCKER DETAILS ***** \n"  >> $cwd/Setup_Report_$dateis.log

		docker ps -a >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** DOCKER IMAGES ***** \n" >> $cwd/Setup_Report_$dateis.log

		docker images --digests >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** DOCKER VERSION ***** \n" >> $cwd/Setup_Report_$dateis.log

		docker --version >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** DOCKER COMPOSE VERISON ***** \n" >> $cwd/Setup_Report_$dateis.log

		docker-compose --version >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -ne '####                      (20%)\r'
        #----------------------------------------------------------------------------------------------------------

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
			
			echo -ne '######                    (30%)\r'
            
			cd /DNIF/LC/ 
            compname=$"LC"
            #echo -e $compname
			echo -e "***** DOCKER COMPOSE YAML ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "*****DOCKER COMPOSE LOGS ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker-compose logs >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HOST FILE INSIDE THE CONATINER ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** SUPERVISORCTL STATUS ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** PROXY INSIDE THE CONATINER ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HOSTNAME INSIDE THE CONTAINER ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") hostname >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		fi

        #---------------------------------------------------------------------------------------------------------
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
			if [[ -e /DNIF/DL/docker-compose.yaml ]]; then

				echo -ne '######                    (30%)\r'
				
				cd /DNIF/DL
                compname=$"DN"
				echo -e "***** DOCKER COMPOSE YAML *****\n" >> $cwd/Setup_Report_$dateis.log
				cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "*****DOCKER COMPOSE LOGS *****\n" >> $cwd/Setup_Report_$dateis.log
				docker-compose logs >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "***** HOST FILE INSIDE THE CONATINER *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "***** SUPERVISORCTL STATUS *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				hadoop_spark_servers_status

				echo -e "***** PROXY INSIDE THE CONATINER *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "***** HOSTNAME INSIDE THE CONTAINER *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") hostname >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
                dn_service_logs
			fi
		fi
        #---------------------------------------------------------------------------------------------------
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then

			echo -ne '######                    (30%)\r'
			
			cd /DNIF/
            compname=$"CO"
			echo -e "***** DOCKER COMPOSE YAML (CORE) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "*****DOCKER COMPOSE LOGS (CORE) *****\n" >> $cwd/Setup_Report_$dateis.log
			docker-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOST FILE INSIDE THE CONATINER (CORE)***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HOST FILE INSIDE THE CONATINER (MASTER DN )***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS (CORE) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS (MASTER DN) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HADOOP NAMENDOE STATUS *****" >> $cwd/Setup_Report_$dateis.log
			systemctl status hadoop-namenode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n"	 >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER (CORE) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER (MASTER DN) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER ***** (CORE)\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER (MASTER DN)*****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            core_service_logs
		fi

        #----------------------------------------------------------------------------------------------

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then

			echo -ne '######                    (30%)\r'
	        
	        cd /DNIF/AD/
            compname=$"AD"
	        echo -e "***** DOCKER COMPOSE YAML (ADAPTER) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "*****DOCKER COMPOSE LOGS (ADAPTER) ***** \n" >> $cwd/Setup_Report_$dateis.log
	        docker-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '***** HOST FILE INSIDE THE CONATINER ***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS ***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER ***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** RABBITMQCTL SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") bash -c 'source /etc/profile && /etc/init.d/rabbitmq-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** RABBITMQCTL QUEUES STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") bash -c 'source /etc/profile && rabbitmqctl list_queues' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** REDIES SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") bash -c '/etc/init.d/redis-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
            
            adapter_service_logs
    	fi
     #-----------------------------------------------------------------------------------------------------
       
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then

    		echo -ne '######                    (30%)\r'
	        
	        cd /DNIF/PICO/
            compname=$"PC"
	        echo -e "***** DOCKER COMPOSE YAML (PICO) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "***** DOCKER COMPOSE LOGS (PICO) *****\n" >> $cwd/Setup_Report_$dateis.log
	        docker-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '***** HOST FILE INSIDE THE CONATINER *****' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
			
			echo -e "***** RABBITMQCTL SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") bash -c 'source /etc/profile && /etc/init.d/rabbitmq-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** RABBITMQCTL QUEUES STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") bash -c 'source /etc/profile && rabbitmqctl list_queues' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** REDIES SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") bash -c '/etc/init.d/redis-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
			
			ip_connectivity
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            pico_service_logs
   		fi
        
        echo -e "***** FIREWALL STATUS ***** \n" >> $cwd/Setup_Report_$dateis.log

		ufw status >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log


    fi
    
    if [[ $os == "rhel" ]]; then

        echo -e "***** PODMAN DETAILS *****\n"  >> $cwd/Setup_Report_$dateis.log

		podman ps -a >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** PODMAN IMAGES *****\n" >> $cwd/Setup_Report_$dateis.log

		podman images --digests >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** PODMAN VERSION *****\n" >> $cwd/Setup_Report_$dateis.log

		podman --version >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** PODMAN COMPOSE VERSION *****\n" >> $cwd/Setup_Report_$dateis.log

		podman-compose --version >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -ne '####                      (20%)\r'
        #----------------------------------------------------------------------------------------
        if [[ $(podman ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then

			echo -ne '######                    (30%)\r'
			
			cd /DNIF/LC/ 
            compname=$"LC"
			echo -e "***** DOCKER COMPOSE YAML (CONSOLE) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** PODMAN COMPOSE LOGS (CONSOLE) ****** \n" >> $cwd/Setup_Report_$dateis.log
			podman-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOST FILE INSIDE THE CONATINER *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER *****' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
													
		fi
        #----------------------------------------------------------------------------------------
        if [[ $(podman ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then

			echo -ne '######                    (30%)\r'

			if [[ -e /DNIF/DL/podman-compose.yaml ]]; then
				
				cd /DNIF/DL
                compname=$"DN"
				echo -e "***** PODMAN COMPOSE YAML *****(DATANODE)\n" >> $cwd/Setup_Report_$dateis.log
				cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "***** PODMAN COMPOSE LOGS (DATANODE) ******\n" >> $cwd/Setup_Report_$dateis.log
				podman-compose logs >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '***** HOST FILE INSIDE THE CONATINER *****' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '***** SUPERVISORCTL STATUS *****' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				if [[ $(podman ps -a --format '{{.Names}}' ) != *"core-v9"* ]]; then
					hadoop_spark_servers_status
				fi

				echo -e '***** PROXY INSIDE THE CONATINER *****\n' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
				echo -e '***** HOSTNAME INSIDE THE CONTAINER *****\n' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") hostname >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
                
               dn_service_logs
            fi
        fi
        #----------------------------------------------------------------------------------------

        if [[ $(podman ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then

			echo -ne '######                    (30%)\r'
			
			cd /DNIF/
            compname=$"CO"
			echo -e "***** PODMAN COMPOSE YAML (CORE) *****\n" >> $cwd/Setup_Report_$dateis.log
			cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** PODMAN COMPOSE LOGS (CORE) *****\n" >> $cwd/Setup_Report_$dateis.log
			podman-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOST FILE INSIDE THE CONATINER (CORE)*****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOST FILE INSIDE THE CONATINER (MASTER DN )*****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=datanode-master-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS (CORE) *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS (MASTER DN) *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=datanode-master-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HADOOP NAMENDOE STATUS *****\n" >> $cwd/Setup_Report_$dateis.log
			systemctl status hadoop-namenode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n"	 >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER (CORE) *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER (MASTER DN) *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=datanode-master-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER ***** (CORE)' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER (MASTER DN)*****' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=datanode-master-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
            core_service_logs

        fi
        #---------------------------------------------------------------------------------------

        if [[ $(podman ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then

            echo -ne '######                    (30%)\r'
            
            cd /DNIF/AD/
            compname=$"AD"
            echo -e "***** PODMAN COMPOSE YAML (ADAPTER) ***** \n" >> $cwd/Setup_Report_$dateis.log
            cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e "***** PODMAN COMPOSE LOGS (ADAPTER) ***** \n" >> $cwd/Setup_Report_$dateis.log
            podman-compose logs >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e '***** HOST FILE INSIDE THE CONATINER ***** \n' >> $cwd/Setup_Report_$dateis.log
            podman exec $(podman ps -aqf "name=adapter-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e '***** SUPERVISORCTL STATUS ***** \n' >> $cwd/Setup_Report_$dateis.log
            podman exec $(podman ps -aqf "name=adapter-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e '***** PROXY INSIDE THE CONATINER ***** \n' >> $cwd/Setup_Report_$dateis.log
            podman exec $(podman ps -aqf "name=adapter-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e '***** HOSTNAME INSIDE THE CONTAINER *****\n' >> $cwd/Setup_Report_$dateis.log
            podman exec $(podman ps -aqf "name=adapter-v9") hostname >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e "***** RABBITMQCTL SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
            podman exec $(podman ps -aqf "name=adapter-v9") bash -c 'source /etc/profile && /etc/init.d/rabbitmq-server status' >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e "***** RABBITMQCTL QUEUES STATUS  *****" >> $cwd/Setup_Report_$dateis.log
            podman exec $(podman ps -aqf "name=adapter-v9") bash -c 'source /etc/profile && rabbitmqctl list_queues' >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            echo -e "***** REDIES SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
            podman exec $(podman ps -aqf "name=adapter-v9") bash -c '/etc/init.d/redis-server status' >> $cwd/Setup_Report_$dateis.log
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
            
            adapter_service_logs
        fi
        #---------------------------------------------------------------------------------------

        if [[ $(podman ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then

    		echo -ne '######                    (30%)\r'
	        
	        cd /DNIF/PICO/
            compname=$"PC"
	        echo -e "***** PODMAN COMPOSE YAML (PICO) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "***** PODMAN COMPOSE LOGS (PICO) *****\n" >> $cwd/Setup_Report_$dateis.log
	        podman-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '***** HOST FILE INSIDE THE CONATINER *****' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER *****\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
			
			echo -e "***** RABBITMQCTL SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") bash -c 'source /etc/profile && /etc/init.d/rabbitmq-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** RABBITMQCTL QUEUES STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") bash -c 'source /etc/profile && rabbitmqctl list_queues' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** REDIES SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") bash -c '/etc/init.d/redis-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
			
			ip_connectivity
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            pico_service_logs
   		fi
        #---------------------------------------------------------------------------------------

        echo -e " ***** FIREWALL STATUS ***** \n" >> $cwd/Setup_Report_$dateis.log

		systemctl staus firewalld.service >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

    fi
    
    if [[ $os == "centos" ]]; then
        #------------------------------------------------------------------------------------------------------
        echo -e "***** DOCKER DETAILS ***** \n"  >> $cwd/Setup_Report_$dateis.log

		docker ps -a >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** DOCKER IMAGES ***** \n" >> $cwd/Setup_Report_$dateis.log

		docker images --digests >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** DOCKER VERSION ***** \n" >> $cwd/Setup_Report_$dateis.log

		docker --version >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "***** DOCKER COMPOSE VERISON ***** \n" >> $cwd/Setup_Report_$dateis.log

		docker-compose --version >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -ne '####                      (20%)\r'
        #----------------------------------------------------------------------------------------------------------

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
			
			echo -ne '######                    (30%)\r'

			cd /DNIF/LC/ 
            compname=$"LC"
			echo -e "***** DOCKER COMPOSE YAML ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "*****DOCKER COMPOSE LOGS ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker-compose logs >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HOST FILE INSIDE THE CONATINER ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** SUPERVISORCTL STATUS ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** PROXY INSIDE THE CONATINER ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HOSTNAME INSIDE THE CONTAINER ***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") hostname >> $cwd/Setup_Report_$dateis.log
			
            echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		fi

        #---------------------------------------------------------------------------------------------------------
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
			if [[ -e /DNIF/DL/docker-compose.yaml ]]; then

				echo -ne '######                    (30%)\r'
				
				cd /DNIF/DL
                compname=$"DN"
				echo -e "***** DOCKER COMPOSE YAML *****\n" >> $cwd/Setup_Report_$dateis.log
				cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "*****DOCKER COMPOSE LOGS *****\n" >> $cwd/Setup_Report_$dateis.log
				docker-compose logs >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "***** HOST FILE INSIDE THE CONATINER *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "***** SUPERVISORCTL STATUS *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				hadoop_spark_servers_status

				echo -e "***** PROXY INSIDE THE CONATINER *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "***** HOSTNAME INSIDE THE CONTAINER *****\n" >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") hostname >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
                dn_service_logs
			fi
		fi
        #---------------------------------------------------------------------------------------------------
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then

			echo -ne '######                    (30%)\r'
			
			cd /DNIF/
            compname=$"CO"
			echo -e "***** DOCKER COMPOSE YAML (CORE) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "*****DOCKER COMPOSE LOGS (CORE) *****\n" >> $cwd/Setup_Report_$dateis.log
			docker-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOST FILE INSIDE THE CONATINER (CORE)***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HOST FILE INSIDE THE CONATINER (MASTER DN )***** \n" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS (CORE) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS (MASTER DN) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** HADOOP NAMENDOE STATUS *****" >> $cwd/Setup_Report_$dateis.log
			systemctl status hadoop-namenode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n"	 >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER (CORE) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER (MASTER DN) *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER ***** (CORE)\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER (MASTER DN)*****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            core_service_logs
		fi

        #----------------------------------------------------------------------------------------------

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then

			echo -ne '######                    (30%)\r'
	        
	        cd /DNIF/AD/
            compname=$"AD"
	        echo -e "***** DOCKER COMPOSE YAML (ADAPTER) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "*****DOCKER COMPOSE LOGS (ADAPTER) ***** \n" >> $cwd/Setup_Report_$dateis.log
	        docker-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '***** HOST FILE INSIDE THE CONATINER ***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS ***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER ***** \n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** RABBITMQCTL SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") bash -c 'source /etc/profile && /etc/init.d/rabbitmq-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** RABBITMQCTL QUEUES STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") bash -c 'source /etc/profile && rabbitmqctl list_queues' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** REDIES SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") bash -c '/etc/init.d/redis-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
            
            adapter_service_logs
    	fi
        #-----------------------------------------------------------------------------------------------------
       
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then

    		echo -ne '######                    (30%)\r'
	        
	        cd /DNIF/PICO/
            compname=$"PC"
	        echo -e "***** DOCKER COMPOSE YAML (PICO) ***** \n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "***** DOCKER COMPOSE LOGS (PICO) *****\n" >> $cwd/Setup_Report_$dateis.log
	        docker-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '***** HOST FILE INSIDE THE CONATINER *****' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** SUPERVISORCTL STATUS *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** PROXY INSIDE THE CONATINER *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '***** HOSTNAME INSIDE THE CONTAINER *****\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
			
			echo -e "***** RABBITMQCTL SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") bash -c 'source /etc/profile && /etc/init.d/rabbitmq-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** RABBITMQCTL QUEUES STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") bash -c 'source /etc/profile && rabbitmqctl list_queues' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "***** REDIES SERVER STATUS  *****" >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") bash -c '/etc/init.d/redis-server status' >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
			
			ip_connectivity
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

            pico_service_logs
   		fi
        
        echo -e "***** FIREWALL STATUS ***** \n" >> $cwd/Setup_Report_$dateis.log

		ufw status >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
    fi

    #===========================================================================================================
    echo -e "***** UPTIME OF THE SERVER *****\n" >> $cwd/Setup_Report_$dateis.log

	uptime -p >> $cwd/Setup_Report_$dateis.log

	echo -ne '########                  (40%)\r'

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e " ***** LAST REBOOT ***** \n" >> $cwd/Setup_Report_$dateis.log

	last reboot >> $cwd/Setup_Report_$dateis.log

	echo -ne '##########                (50%)\r'

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "***** DISK DETAILS *****\n" >> $cwd/Setup_Report_$dateis.log

	df -h >> $cwd/Setup_Report_$dateis.log

	echo -ne '############              (60%)\r'

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "***** MEMROY DETAILS  *****\n" >> $cwd/Setup_Report_$dateis.log

	free -h >> $cwd/Setup_Report_$dateis.log

	echo -ne '##############            (70%)\r'

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "***** HOST PROXY ***** \n" >> $cwd/Setup_Report_$dateis.log

	env | grep -i proxy >> $cwd/Setup_Report_$dateis.log

	echo -ne '################          (80%)\r'

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "***** UMASK OF THE SERVER ***** \n" >> $cwd/Setup_Report_$dateis.log

	umask >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "***** SESTATUS ***** \n" >> $cwd/Setup_Report_$dateis.log

	if [ ! -f "/usr/sbin/sestatus" ]; then
		echo "policycoreutils is not installed" >> $cwd/Setup_Report_$dateis.log
	else
		sestatus >> $cwd/Setup_Report_$dateis.log
	fi

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "***** IP OF THE SERVER ***** \n" >> $cwd/Setup_Report_$dateis.log

	ifconfig >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e " ***** CPU DETAILS  ***** \n" >> $cwd/Setup_Report_$dateis.log

	lscpu >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e " ***** NUMBER OF VIRTUAL CPU ****** \n" >> $cwd/Setup_Report_$dateis.log

	nproc >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e " ***** HOST FILE ***** \n" >> $cwd/Setup_Report_$dateis.log

	cat /etc/hosts >> $cwd/Setup_Report_$dateis.log

	echo -ne '##################        (90%)\r'

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e " ***** HOSTNAME OF THE SERVER *****\n" >> $cwd/Setup_Report_$dateis.log

	hostname >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "***** PORTS ON LISTENING \n" >> $cwd/Setup_Report_$dateis.log

	netstat -auntp | grep -i listen >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -ne '###################       (95%)\r'

	cd $cwd

    if [[ $os == "ubuntu" ]]; then
        tar fcz OS_logs_$dateis.tar.gz --absolute-names /var/log/syslog* /var/log/kern.log* /var/log/dmesg*  
    fi
	
    if [[ $os == "rhel" ]]; then
        tar fcz OS_logs_$dateis.tar.gz --absolute-names /var/log/syslog* /var/log/kern.log* /var/log/dmes* /var/log/mes*
    fi
	
    if [[ $os == "centos" ]]; then
        tar fcz OS_logs_$dateis.tar.gz --absolute-names /var/log/syslog* /var/log/kern.log* /var/log/dmesg*  
    fi

    #-----------------------------------------------------------------------------------------

    if [[ $os == "ubuntu" ]]; then
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/DL/correlation_server/logs/ /DNIF/DL/report_server/logs/ /DNIF/DL/query_server/logs/ /DNIF/DL/log/ /DNIF/DL/csltuconfig/ /opt/spark-3.1.3-bin-hadoop3.2/logs/ /opt/hadoop-3.2.3/logs/ 
        fi

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/DL/log/ /DNIF/DL/csltuconfig/  /DNIF/CO/log/ /DNIF/CO/csltuconfig/ /opt/hadoop-3.2.3/logs/  /DNIF/CO/core/notable* 
        fi

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/AD/log/ /DNIF/AD/csltuconfig/
        fi

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/PICO/log/ /DNIF/PICO/csltuconfig/
        fi
    fi

    if [[ $os == "rhel" ]]; then
        if [[ $(podman ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/DL/correlation_server/logs/ /DNIF/DL/report_server/logs/ /DNIF/DL/query_server/logs/ /DNIF/DL/log/ /DNIF/DL/csltuconfig/ /opt/spark-3.1.3-bin-hadoop3.2/logs/ /opt/hadoop-3.2.3/logs/ 
        fi

        if [[ $(podman ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/DL/log/ /DNIF/DL/csltuconfig/  /DNIF/CO/log/ /DNIF/CO/csltuconfig/ /opt/hadoop-3.2.3/logs/  /DNIF/CO/core/notable* 
        fi

        if [[ $(podman ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/AD/log/ /DNIF/AD/csltuconfig/
        fi

        if [[ $(podman ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/PICO/log/ /DNIF/PICO/csltuconfig/
        fi
    fi


    if [[ $os == "centos" ]]; then
        if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/DL/correlation_server/logs/ /DNIF/DL/report_server/logs/ /DNIF/DL/query_server/logs/ /DNIF/DL/log/ /DNIF/DL/csltuconfig/ /opt/spark-3.1.3-bin-hadoop3.2/logs/ /opt/hadoop-3.2.3/logs/ 
        fi

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/DL/log/ /DNIF/DL/csltuconfig/  /DNIF/CO/log/ /DNIF/CO/csltuconfig/ /opt/hadoop-3.2.3/logs/  /DNIF/CO/core/notable* 
        fi

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/AD/log/ /DNIF/AD/csltuconfig/
        fi

        if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
            tar fcz service_logs_$dateis.tar.gz --absolute-names /DNIF/PICO/log/ /DNIF/PICO/csltuconfig/
        fi
    fi

    #-----------------------------------------------------------------------------------------
    
	HISTFILE=~/.bash_history
    set -o history
	history >> history_$dateis.log

	top -c -b -n 5 > top_$dateis.log
	ps aux --sort -pcpu >> ps_pcpu_$dateis.log
	ps aux --sort -rss >> ps_rss_$dateis.log

	tar fcz System_Report_"$compname"_"$dateis".tar.gz --absolute-names Setup_Report_$dateis.log OS_logs_$dateis.tar.gz history_$dateis.log top_$dateis.log ps_pcpu_$dateis.log ps_rss_$dateis.log service_logs_$dateis.tar.gz

	if [[ -e ./Setup_Report_$dateis.log ]]; then
		rm -rf ./Setup_Report_$dateis.log
	fi

	if [[ -e ./OS_logs_$dateis.tar.gz ]]; then
		rm -rf ./OS_logs_$dateis.tar.gz
	fi

	if [[ -e ./history_$dateis.log ]]; then
		rm -rf ./history_$dateis.log
	fi

	if [[ -e ./top_$dateis.log ]]; then
		rm -rf ./top_$dateis.log
	fi

	if [[ -e ./ps_pcpu_$dateis.log ]]; then
		rm -rf ./ps_pcpu_$dateis.log
	fi

	if [[ -e ./ps_rss_$dateis.log ]]; then
		rm -rf ./ps_rss_$dateis.log
	fi

    if [[ -e ./service_logs_$dateis.tar.gz ]]; then
		rm -rf ./service_logs_$dateis.tar.gz
	fi

	echo -ne '#######################   (100%)\r'
	echo -ne '\n'

fi
