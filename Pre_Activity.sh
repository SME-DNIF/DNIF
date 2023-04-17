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
    if [ $os == "rhel" ]; then
        PPCN=$(podman ps -a --format '{{.Names}}' | grep -w pico-v9)
        PACN=$(podman ps -a --format '{{.Names}}' | grep -w adapter-v9)
        PDCN=$(podman ps -a --format '{{.Names}}' | grep -w datanode-v9)
        PMDCN=$(podman ps -a --format '{{.Names}}' | grep -w datanode-master-v9)
        PCCN=$(podman ps -a --format '{{.Names}}' | grep -w core-v9)
        PLCCN=$(podman ps -a --format '{{.Names}}' | grep -w console-v9)
        PPCID=$(podman ps -aqf "name=pico-v9") 
        PACID=$(podman ps -aqf "name=adapter-v9")
        PDCID=$(podman ps -aqf "name=datanode-v9")
        PCCID=$(podman ps -aqf "name=core-v9")
        PMDCID=$(podman ps -aqf "name=datanode-master-v9")
        PLCCID=$(podman ps -aqf "name=console-v9")   
    fi
#-------------------------------------------------------------------------------------------------
    if [[ $os == "ubuntu" ]] && [[ $PCN == "pico-v9" ]]; then      
        docker stop $PCID
        container_status=$(docker ps -a --filter "name=pico-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $PCN and ID $PCID is stopped"
            else
                echo -e "container with name $PCN and ID $PCID is not stopped"
            fi
        echo -e "$(docker ps -a)"
    fi

    if [[ $os == "rhel" ]] && [[ $PPCN == "pico-v9" ]]; then       
        podman stop $PPCID
        container_status=$(podman ps -a --filter "name=pico-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $PPCN and ID $PPCID is stopped"
            else
                echo -e "container with name $PPCN and ID $PPCID is not stopped"
            fi
        echo -e "$(podman ps -a)"
    fi
#-------------------------------------------------------------------------------------------------
    if [[ $os == "ubuntu" ]] && [[ $ACN == "adapter-v9" ]]; then
        docker stop $ACID
        container_status=$(docker ps -a --filter "name=adapter-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $ACN and ID $ACID is stopped"
            else
                echo -e "container with name $ACN and ID $ACID is not stopped"
            fi
        echo -e "$(docker ps -a)"
    fi

    if [[ $os == "rhel" ]] && [[ $PACN == "adapter-v9" ]]; then        
        podman stop $PACID
        container_status=$(podman ps -a --filter "name=adapter-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $PACN and ID $PACID is stopped"
            else
                echo -e "container with name $PACN and ID $PACID is not stopped"
            fi
        echo -e "$(podman ps -a)"
    fi
#-------------------------------------------------------------------------------------------------
    if [[ $os == "ubuntu" ]] && [[ $DCN == "datanode-v9" ]]; then        
        docker stop $DCID
        container_status=$(docker ps -a --filter "name=datanode-v9" --format "{{.Status}}")
        if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $DCN and ID $DCID is stopped"
            else
                echo -e "container with name $DCN and ID $DCID is not stopped"
            fi
        echo -e "$(docker ps -a)" 
    fi
    if [[ $os == "rhel" ]] && [[ $PDCN == "datanode-v9" ]]; then         
        podman stop $PDCID
        container_status=$(podman ps -a --filter "name=datanode-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $PDCN and ID $PDCID is stopped"
            else
                echo -e "container with name $PDCN and ID $PDCID is not stopped"
            fi
        echo -e "$(podman ps -a)"
    fi
#-------------------------------------------------------------------------------------------------
    if [[ $os == "ubuntu" ]] && [[ $CCN == "core-v9" ]]; then       
        docker stop $MDCID
        docker stop $CCID
        container_status_mdn=$(docker ps -a --filter "name=datanode-master-v9" --format "{{.Status}}")
        container_status=$(docker ps -a --filter "name=core-v9" --format "{{.Status}}")
            if [[ $container_status_mdn == *"Exited"* ]]; then      
                echo -e "container with name $MDCN and ID $MDCID is stopped"
            else
                echo -e "container with name $MDCN and ID $MDCID is not stopped"
            fi
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $CCN and ID $CCID is stopped"
            else
                echo -e "container with name $CCN and ID $CCID is not stopped"
            fi
        echo -e "$(docker ps -a)"
    fi
    if [[ $os == "rhel" ]] && [[ $PCCN == "core-v9" ]]; then         
        podman stop $PMDCID
        podman stop $PCCID
        container_status_mdn=$(podman ps -a --filter "name=datanode-master-v9" --format "{{.Status}}")
        container_status=$(podman ps -a --filter "name=core-v9" --format "{{.Status}}")
            if [[ $container_status_mdn == *"Exited"* ]]; then      
                echo -e "container with name $PMDCN and ID $PMDCID is stopped"
            else
                echo -e "container with name $PMDCN and ID $PMDCID is not stopped"
            fi
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $PCCN and ID $PCCID is stopped"
            else
                echo -e "container with name $PCCN and ID $PCCID is not stopped"
            fi
        echo -e "$(podman ps -a)"
    fi
#-------------------------------------------------------------------------------------------------
    if [[ $os == "ubuntu" ]] && [[ $LCCN == "console-v9" ]]; then        
        docker stop $LCCID
        container_status=$(docker ps -a --filter "name=console-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $LCCN and ID $LCCID is stopped"
            else
                echo -e "container with name $LCCN and ID $LCCID is not stopped"
            fi
        echo -e "$(docker ps -a)"
    fi
    if [[ $os == "rhel" ]] && [[ $PLCCN == "console-v9" ]]; then        
        podman stop $PLCCID
        container_status=$(podman ps -a --filter "name=console-v9" --format "{{.Status}}")
            if [[ $container_status == *"Exited"* ]]; then      
                echo -e "container with name $PLCCN and ID $PLCCID is stopped"
            else
                echo -e "container with name $PLCCN and ID $PLCCID is not stopped"
            fi
        echo -e "$(podman ps -a)"
    fi
#-------------------------------------------------------------------------------------------------

fi
