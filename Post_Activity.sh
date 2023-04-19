#!/bin/bash   

if [[ $EUID -ne 0 ]]; then
	echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else

    os=$(. /etc/os-release && echo -e "$ID")

    #variable depending on OS and Container

    if [ $os == "ubuntu" ]; then
        PCN=$(docker ps -a --format '{{.Names}}' | grep -w pico-v9)
        ACN=$(docker ps -a --format '{{.Names}}' | grep -w adapter-v9)
        DCN=$(docker ps -a --format '{{.Names}}' | grep -w datanode-v9)
        MDCN=$(docker ps -a --format '{{.Names}}' | grep -w datanode-master-v9)
        CCN=$(docker ps -a --format '{{.Names}}' | grep -w core-v9)
        LCCN=$(docker ps -a --format '{{.Names}}' | grep -w console-v9)
        PCID=$(docker ps -aqf "name=pico-v9") 
        ACID=$(docker ps -aqf "name=adapter-v9")
        DCID=$(docker ps -aqf "name=datanode-v9")
        CCID=$(docker ps -aqf "name=core-v9")
        MDCID=$(docker ps -aqf "name=datanode-master-v9")
        LCCID=$(docker ps -aqf "name=console-v9")
    fi

    if [ $os == "centos" ]; then
        PCN=$(docker ps -a --format '{{.Names}}' | grep -w pico-v9)
        ACN=$(docker ps -a --format '{{.Names}}' | grep -w adapter-v9)
        DCN=$(docker ps -a --format '{{.Names}}' | grep -w datanode-v9)
        MDCN=$(docker ps -a --format '{{.Names}}' | grep -w datanode-master-v9)
        CCN=$(docker ps -a --format '{{.Names}}' | grep -w core-v9)
        LCCN=$(docker ps -a --format '{{.Names}}' | grep -w console-v9)
        PCID=$(docker ps -aqf "name=pico-v9") 
        ACID=$(docker ps -aqf "name=adapter-v9")
        DCID=$(docker ps -aqf "name=datanode-v9")
        CCID=$(docker ps -aqf "name=core-v9")
        MDCID=$(docker ps -aqf "name=datanode-master-v9")
        LCCID=$(docker ps -aqf "name=console-v9")
    fi

    if [ $os == "rhel" ]; then
        PPCN=$(podman ps -a --format '{{.Names}}' | grep -w pico-v9)
        PACN=$(podman ps -a --format '{{.Names}}' | grep -w adapter-v9)
        PDCN=$(podman ps -a --format '{{.Names}}' | grep -w datanode-v9)
        PMDCN=$(podman ps -a --format '{{.Names}}' | grep -w datanode-v9)
        PCCN=$(podman ps -a --format '{{.Names}}' | grep -w core-v9)
        PLCCN=$(podman ps -a --format '{{.Names}}' | grep -w console-v9)
        PPCID=$(podman ps -aqf "name=pico-v9") 
        PACID=$(podman ps -aqf "name=adapter-v9")
        PDCID=$(podman ps -aqf "name=datanode-v9")
        PCCID=$(podman ps -aqf "name=core-v9")
        PMDCID=$(podman ps -aqf "name=datanode-v9")
        PLCCID=$(podman ps -aqf "name=console-v9")   
    fi
#-------------------------------------------------------------------------------------------------
    #Pico
    
    if [[ $os == "ubuntu" ]] && [[ $PCN == "pico-v9" ]]; then      
        container_status=$(docker ps -a --filter "name=pico-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $PCID
                
                container_status_new=$(docker ps -a --filter "name=pico-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "Started container with name $PCN and ID $PCID is Up and Running"
                fi     
            else
                echo -e "container with name $PCN and ID $PCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"
    fi

    if [[ $os == "centos" ]] && [[ $PCN == "pico-v9" ]]; then      
        container_status=$(docker ps -a --filter "name=pico-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $PCID
                
                container_status_new=$(docker ps -a --filter "name=pico-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "Started container with name $PCN and ID $PCID is Up and Running"
                fi     
            else
                echo -e "container with name $PCN and ID $PCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"
    fi


    if [[ $os == "rhel" ]] && [[ $PPCN == "pico-v9" ]]; then      
        container_status=$(podman ps -a --filter "name=pico-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Podman container is exited"
                echo -e "Starting the podman container........"
                podman start $PPCID
                
                container_status_new=$(podman ps -a --filter "name=pico-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $PPCN and ID $PPCID is Up and Running"
                fi
            else
                echo -e "container with name $PPCN and ID $PPCID is Up and Running"
            fi
        echo -e "$(podman ps -a)"
    fi
#-------------------------------------------------------------------------------------------------
    #Adapter

    if [[ $os == "ubuntu" ]] && [[ $ACN == "adapter-v9" ]]; then      
        container_status=$(docker ps -a --filter "name=adapter-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $ACID
                
                container_status_new=$(docker ps -a --filter "name=adapter-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $ACN and ID $ACID is Up and Running"
                fi
            else
                echo -e "container with name $ACN and ID $ACID is Up and Running"
            fi
        echo -e "$(docker ps -a)"
    fi

    if [[ $os == "centos" ]] && [[ $ACN == "adapter-v9" ]]; then      
        container_status=$(docker ps -a --filter "name=adapter-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $ACID
                
                container_status_new=$(docker ps -a --filter "name=adapter-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $ACN and ID $ACID is Up and Running"
                fi
            else
                echo -e "container with name $ACN and ID $ACID is Up and Running"
            fi
        echo -e "$(docker ps -a)"
    fi

    if [[ $os == "rhel" ]] && [[ $PACN == "adapter-v9" ]]; then      
        container_status=$(podman ps -a --filter "name=adapter-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Podman container is exited"
                echo -e "Starting the podman container........"
                podman start $PACID
                
                container_status_new=$(podman ps -a --filter "name=adapter-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $PACN and ID $PACID is Up and Running"
                fi
            else
                echo -e "container with name $PACN and ID $PACID is Up and Running"
            fi
        echo -e "$(podman ps -a)"
    fi
#-------------------------------------------------------------------------------------------------
    #Datanode    

    if [[ $os == "ubuntu" ]] && [[ $DCN == "datanode-v9" ]]; then 

        spark_slave_check=$(systemctl is-active spark-slave.service)
        spark_master_check=$(systemctl is-active spark-master.service)
        hadoop_datanode_check=$(systemctl is-active hadoop-datanode.service)
        query_server_status=$(pgrep -f "query_server" || true)
        correlation_server_status=$(pgrep -f "correlation_server" || true)
        report_server_status=$(pgrep -f "report_server" || true)
        
        if [[ $hadoop_datanode_check == "active" ]]; then
            echo -e "Hadoop datanode service is active and running"
        else
            echo -e "hadoop-datanode.service is not active"
            systemctl restart hadoop-datanode.service
            echo -e "Restarting hadoop-datanode.service..........."
            sleep 10
            hadoop_datanode_check_new=$(systemctl is-active hadoop-datanode.service)
            if [[ $hadoop_datanode_check_new == "active" ]]; then
                echo -e "Restarted hadoop-datanode.service and it is active and running"
            fi
        fi

        if [[ $spark_slave_check == "active" ]] && [[ $spark_master_check == "active" ]]; then
            echo "Spark master and slave both are active and running"
        else
            if [[ $spark_slave_check == "failed" ]]; then 
                echo -e "spark-slave.service is not active"
            fi
            if [[ $spark_master_check == "failed" ]]; then 
                echo -e "spark-master.service is not active"
            fi
            systemctl restart spark-master.service spark-slave.service
            echo -e "Restarting spark-master.service and spark-slave.service............"
            sleep 10 
            spark_slave_check_new=$(systemctl is-active spark-slave.service)
            spark_master_check_new=$(systemctl is-active spark-master.service)
            if [[ $spark_slave_check_new == "active" ]] && [[ $spark_master_check_new == "active" ]]; then
                echo "Restarted spark-master.service and spark-slave.service and it is active and running"
            fi
        fi

        container_status=$(docker ps -a --filter "name=datanode-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $DCID                
                sleep 50
                container_status_new=$(docker ps -a --filter "name=datanode-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $DCN and ID $DCID is Up and Running"
                fi
            else
                echo -e "container with name $DCN and ID $DCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"


        if [[ -n "$query_server_status" && -n "$correlation_server_status" && -n "$report_server_status" ]]; then
            echo "query_correlation_report server's are running"
        else
            systemctl restart spark-master.service spark-slave.service
            echo -e "Restarting spark-master.service and spark-slave.service...................."
            sleep 10
            query_server_status_new=$(pgrep -f "query_server" || true)
            correlation_server_status_new=$(pgrep -f "correlation_server" || true)
            report_server_status_new=$(pgrep -f "report_server" || true)
            if [[ -n "$query_server_status_new" && -n "$correlation_server_status_new" && -n "$report_server_status_new" ]]; then
                echo "query_correlation_report server's are running"
            fi
        fi        
    fi

    if [[ $os == "centos" ]] && [[ $DCN == "datanode-v9" ]]; then 

        spark_slave_check=$(systemctl is-active spark-slave.service)
        spark_master_check=$(systemctl is-active spark-master.service)
        hadoop_datanode_check=$(systemctl is-active hadoop-datanode.service)
        query_server_status=$(pgrep -f "query_server" || true)
        correlation_server_status=$(pgrep -f "correlation_server" || true)
        report_server_status=$(pgrep -f "report_server" || true)
        
        if [[ $hadoop_datanode_check == "active" ]]; then
            echo -e "Hadoop datanode service is active and running"
        else
            echo -e "hadoop-datanode.service is not active"
            systemctl restart hadoop-datanode.service
            echo -e "Restarting hadoop-datanode.service..........."
            sleep 10
            hadoop_datanode_check_new=$(systemctl is-active hadoop-datanode.service)
            if [[ $hadoop_datanode_check_new == "active" ]]; then
                echo -e "Restarted hadoop-datanode.service and it is active and running"
            fi
        fi

        if [[ $spark_slave_check == "active" ]] && [[ $spark_master_check == "active" ]]; then
            echo "Spark master and slave both are active and running"
        else
            if [[ $spark_slave_check == "failed" ]]; then 
                echo -e "spark-slave.service is not active"
            fi
            if [[ $spark_master_check == "failed" ]]; then 
                echo -e "spark-master.service is not active"
            fi
            systemctl restart spark-master.service spark-slave.service
            echo -e "Restarting spark-master.service and spark-slave.service............"
            sleep 10 
            spark_slave_check_new=$(systemctl is-active spark-slave.service)
            spark_master_check_new=$(systemctl is-active spark-master.service)
            if [[ $spark_slave_check_new == "active" ]] && [[ $spark_master_check_new == "active" ]]; then
                echo "Restarted spark-master.service and spark-slave.service and it is active and running"
            fi
        fi

        container_status=$(docker ps -a --filter "name=datanode-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $DCID                
                sleep 50
                container_status_new=$(docker ps -a --filter "name=datanode-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $DCN and ID $DCID is Up and Running"
                fi
            else
                echo -e "container with name $DCN and ID $DCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"


        if [[ -n "$query_server_status" && -n "$correlation_server_status" && -n "$report_server_status" ]]; then
            echo "query_correlation_report server's are running"
        else
            systemctl restart spark-master.service spark-slave.service
            echo -e "Restarting spark-master.service and spark-slave.service...................."
            sleep 10
            query_server_status_new=$(pgrep -f "query_server" || true)
            correlation_server_status_new=$(pgrep -f "correlation_server" || true)
            report_server_status_new=$(pgrep -f "report_server" || true)
            if [[ -n "$query_server_status_new" && -n "$correlation_server_status_new" && -n "$report_server_status_new" ]]; then
                echo "query_correlation_report server's are running"
            fi
        fi        
    fi

    if [[ $os == "rhel" ]] && [[ $PDCN == "datanode-v9" ]] && [[ $PCCN != "core-v9" ]]; then 

        spark_slave_check=$(systemctl is-active spark-slave.service)
        spark_master_check=$(systemctl is-active spark-master.service)
        hadoop_datanode_check=$(systemctl is-active hadoop-datanode.service)
        query_server_status=$(pgrep -f "query_server" || true)
        correlation_server_status=$(pgrep -f "correlation_server" || true)
        report_server_status=$(pgrep -f "report_server" || true)
        
        if [[ $hadoop_datanode_check == "active" ]]; then
            echo -e "Hadoop datanode service is active and running"
        else
            echo -e "hadoop-datanode.service is not active"
            systemctl restart hadoop-datanode.service
            echo -e "Restarting hadoop-datanode.service..........."
            sleep 10
            hadoop_datanode_check_new=$(systemctl is-active hadoop-datanode.service)
            if [[ $hadoop_datanode_check_new == "active" ]]; then
                echo -e "Restarted hadoop-datanode.service and it is active and running"
            fi
        fi

        if [[ $spark_slave_check == "active" ]] && [[ $spark_master_check == "active" ]]; then
            echo "Spark master and slave both are active and running"
        else
            if [[ $spark_slave_check == "failed" ]]; then 
                echo -e "spark-slave.service is not active"
            fi
            if [[ $spark_master_check == "failed" ]]; then 
                echo -e "spark-master.service is not active"
            fi
            systemctl restart spark-master.service spark-slave.service
            echo -e "Restarting spark-master.service and spark-slave.service............."
            sleep 10 
            spark_slave_check_new=$(systemctl is-active spark-slave.service)
            spark_master_check_new=$(systemctl is-active spark-master.service)
            if [[ $spark_slave_check_new == "active" ]] && [[ $spark_master_check_new == "active" ]]; then
                echo "Restarted spark-master.service and spark-slave.service and it is active and running"
            fi
        fi

        container_status=$(podman ps -a --filter "name=datanode-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Podman container is exited"
                echo -e "Starting the podman container........"
                podman start $PDCID    
                sleep 50
                container_status_new=$(podman ps -a --filter "name=datanode-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $PDCN and ID $PDCID is Up and Running"
                fi
            else
                echo -e "container with name $PDCN and ID $PDCID is Up and Running"
            fi
        echo -e "$(podman ps -a)"


        if [[ -n "$query_server_status" && -n "$correlation_server_status" && -n "$report_server_status" ]]; then
            echo "query_correlation_report server's are running"
        else
            systemctl restart spark-master.service spark-slave.service
            echo -e "Restarting spark-master.service and spark-slave.service............"
            sleep 10
            query_server_status_new=$(pgrep -f "query_server" || true)
            correlation_server_status_new=$(pgrep -f "correlation_server" || true)
            report_server_status_new=$(pgrep -f "report_server" || true)
            if [[ -n "$query_server_status_new" && -n "$correlation_server_status_new" && -n "$report_server_status_new" ]]; then
                echo "query_correlation_report server's are running"
            fi
        fi        
    fi
#-------------------------------------------------------------------------------------------------
    #Core

    if [[ $os == "ubuntu" ]] && [[ $CCN == "core-v9" ]]; then 
        container_status_mdn=$(docker ps -a --filter "name=datanode-master-v9" --format "{{.Status}}")
        container_status=$(docker ps -a --filter "name=core-v9" --format "{{.Status}}")
        hadoop_namenode_check=$(systemctl is-active hadoop-namenode.service)            
            if [[ $hadoop_namenode_check == "active" ]]; then
                echo -e "Hadoop namenode service is active and running"
            else
                echo -e "Hadoop namenode service is not active"
                systemctl restart hadoop-namenode.service
                echo -e "Restarting hadoop-namenode.service..............."
                sleep 10
                hadoop_namenode_check_new=$(systemctl is-active hadoop-namenode.service) 
                if [[ $hadoop_namenode_check_new == "active" ]]; then
                echo -e "Restarted hadoop-namenode.service and it is active and running"
                fi
            fi
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container for core is exited"
                echo -e "Starting the docker container for core ........."
                docker start $CCID
                container_status_new=$(docker ps -a --filter "name=core-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e echo -e "container with name $CCN and ID $CCID is Up and Running"
                fi 
            else
                echo -e "container with name $CCN and ID $CCID is Up and Running"
            fi
            if [[ $container_status_mdn == *"Exited"* ]]; then      
                echo -e "Docker container for Master-Datanode is exited"
                echo -e "Starting the docker container for Master-Datanode ........."
                docker start $MDCID
                container_status_mdn_new=$(docker ps -a --filter "name=datanode-master-v9" --format "{{.Status}}")
                if [[ $container_status_mdn_new == *"UP"* ]]; then   
                    echo -e echo -e "container with name $MDCN and ID $MDCID is Up and Running"
                fi
            else 
                echo -e "container with name $MDCN and ID $MDCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"    
    fi

    if [[ $os == "centos" ]] && [[ $CCN == "core-v9" ]]; then 
        container_status_mdn=$(docker ps -a --filter "name=datanode-master-v9" --format "{{.Status}}")
        container_status=$(docker ps -a --filter "name=core-v9" --format "{{.Status}}")
        hadoop_namenode_check=$(systemctl is-active hadoop-namenode.service)            
            if [[ $hadoop_namenode_check == "active" ]]; then
                echo -e "Hadoop namenode service is active and running"
            else
                echo -e "Hadoop namenode service is not active"
                systemctl restart hadoop-namenode.service
                echo -e "Restarting hadoop-namenode.service..............."
                sleep 10
                hadoop_namenode_check_new=$(systemctl is-active hadoop-namenode.service) 
                if [[ $hadoop_namenode_check_new == "active" ]]; then
                echo -e "Restarted hadoop-namenode.service and it is active and running"
                fi
            fi
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container for core is exited"
                echo -e "Starting the docker container for core ........."
                docker start $CCID
                container_status_new=$(docker ps -a --filter "name=core-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e echo -e "container with name $CCN and ID $CCID is Up and Running"
                fi 
            else
                echo -e "container with name $CCN and ID $CCID is Up and Running"
            fi
            if [[ $container_status_mdn == *"Exited"* ]]; then      
                echo -e "Docker container for Master-Datanode is exited"
                echo -e "Starting the docker container for Master-Datanode ........."
                docker start $MDCID
                container_status_mdn_new=$(docker ps -a --filter "name=datanode-master-v9" --format "{{.Status}}")
                if [[ $container_status_mdn_new == *"UP"* ]]; then   
                    echo -e echo -e "container with name $MDCN and ID $MDCID is Up and Running"
                fi
            else 
                echo -e "container with name $MDCN and ID $MDCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"    
    fi

    if [[ $os == "rhel" ]] && [[ $PCCN == "core-v9" ]]; then 
        container_status_mdn=$(podman ps -a --filter "name=datanode-v9" --format "{{.Status}}")
        container_status=$(podman ps -a --filter "name=core-v9" --format "{{.Status}}")
        hadoop_namenode_check=$(systemctl is-active hadoop-namenode.service)            
            if [[ $hadoop_namenode_check == "active" ]]; then
                echo -e "Hadoop namenode service is active and running"
            else
                echo -e "Hadoop namenode service is not active"
                systemctl restart hadoop-namenode.service
                echo -e "Restarting hadoop-namenode.service..............."
                sleep 10
                hadoop_namenode_check_new=$(systemctl is-active hadoop-namenode.service) 
                if [[ $hadoop_namenode_check == "active" ]]; then
                echo -e "Restarted hadoop-namenode.service and it is active and running"
                fi
            fi
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Podman container for core is exited"
                echo -e "Starting the Podman container for core ........."
                podman start $PCCID
                container_status_new=$(podman ps -a --filter "name=core-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then
                    echo -e "container with name $PCCN and ID $PCCID is Up and Running"
                fi
            else
                echo -e "container with name $PCCN and ID $PCCID is Up and Running"
            fi
            if [[ $container_status_mdn == *"Exited"* ]]; then      
                echo -e "Podman container for Master-Datanode is exited"
                echo -e "Starting the podman container for Master-Datanode ........."
                podman start $PMDCID
                container_status_mdn_new=$(podman ps -a --filter "name=datanode-v9" --format "{{.Status}}")
                if [[ $container_status_mdn_new == *"UP"* ]]; then 
                    echo -e "container with name $PMDCN and ID $PMDCID is Up and Running"
                fi
            else
                echo -e "container with name $PMDCN and ID $PMDCID is Up and Running"
            fi
        echo -e "$(podman ps -a)"    
    fi
#-------------------------------------------------------------------------------------------------
    #Console

    if [[ $os == "ubuntu" ]] && [[ $LCCN == "console-v9" ]]; then      
        container_status=$(docker ps -a --filter "name=console-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $LCCID
                container_status_new=$(docker ps -a --filter "name=console-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then 
                    echo -e "container with name $LCCN and ID $LCCID is Up and Running"
                fi
            else
                echo -e "container with name $LCCN and ID $LCCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"
    fi

    if [[ $os == "centos" ]] && [[ $LCCN == "console-v9" ]]; then      
        container_status=$(docker ps -a --filter "name=console-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Docker container is exited"
                echo -e "Starting the docker container........"
                docker start $LCCID
                container_status_new=$(docker ps -a --filter "name=console-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"UP"* ]]; then 
                    echo -e "container with name $LCCN and ID $LCCID is Up and Running"
                fi
            else
                echo -e "container with name $LCCN and ID $LCCID is Up and Running"
            fi
        echo -e "$(docker ps -a)"
    fi

    if [[ $os == "rhel" ]] && [[ $PLCCN == "console-v9" ]]; then      
        container_status=$(podman ps -a --filter "name=console-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "Podman container is exited"
                echo -e "Starting the podman container........"
                podman start $PLCCID
                container_status_new=$(podman ps -a --filter "name=console-v9" --format "{{.Status}}")
                if [[ $container_status_new == *"Exited"* ]]; then
                    echo -e "container with name $PLCCN and ID $PLCCID is Up and Running"
                fi
            else
                echo -e "container with name $PLCCN and ID $PLCCID is Up and Running"
            fi
        echo -e "$(podman ps -a)"
    fi

fi  
