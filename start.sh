#!/bin/bash
if [ -z "$1" ]
then
    echo "Please provide input file"
else
    if [ -f "$1" ]
    then
        input=$1
        while IFS= read -r line
        do
            declare -a linedata=( $( echo $line | cut -d' ' -f1- ) )
            echo -e "creating and configuring the ec2-instance.........."
            exec &> logfile.txt | tee -a "$logfile.txt"
            # Reading oracleid and customer id
            ORACLESID=${linedata[0]}
            CUSTID=${linedata[1]}
            # Message display
            echo -e "You entered $ORACLESID and $CUSTID."
            echo -e "Thank you. Please see the README.md for advanced options and further info"
            echo $ORACLESID > oraclesid.BAK
            echo $CUSTID > custid.BAK
            echo $CUSTID > customerid.BAK
            export ORACLESID=$(cat oraclesid.BAK)
            export CUSTID=$(cat custid.BAK)
            sed -i -e "1s/^/$ORACLESID/" custid.BAK
            export COMBINEDNAME=$(cat custid.BAK)
            sed -i -e "s/replaceme/$COMBINEDNAME/g" main.tf
            sleep 10
            echo -e "Provisioning infra"
            export TF_VAR_tag_instance=$CUSTID-$ORACLESID
            export TF_VAR_oraclesid=$ORACLESID
            export TF_VAR_CREATEDHOSTNAME=$(cat custid.BAK)
            terraform init
            terraform plan
            terraform apply -auto-approve
            ##echo -e "Successfully executed"
            PROVISIONED_IP=$(terraform output instance_ip)
            start_lis_path=/u01/app/oracle/product/12.2.0.1/dbhome_1/network/admin/listener.ora
            verify_lis_path=/var/opt/oracle/tnsnames.ora
            cd ./ansible
            sudo ./get_IPs.sh
            export PROVISIONED_IP=$PROVISIONED_IP
            echo "------------------------------------------------"
            echo "------------------------------------------------"
            echo "PROVISIONED_IP=$PROVISIONED_IP"
            echo "------------------------------------------------"
            echo "------------------------------------------------"
            export ORACLESID=$ORACLESID
            export start_lis_path=$start_lis_path
            export verify_lis_path=$verify_lis_path
            ansible-playbook Playbook.yml > ansible_output.txt | tee -a "$ansible_output.txt"
            ##ansible-playbook Playbook.yml -vvv
            cd ../
            mv *.tfstate* ./state_backup
        done < "$input"
    else
        echo "$1 not found. Please provide file location"
    fi
fi
