#!/bin/bash

# Validating the parameters
if [ -z "$1" ]
then
    echo "Please provide first parameter"
    exit
fi

if [ -z "$2" ]
then
    echo "Please provide second parameter"
    exit
fi

# Reading parameters
PARAM1=$1
PARAM2=$2

# File location
INPUT_FILE='./input.txt'

# Declare a hashmap to store the input mapping
declare -A INPUT_MAP

# Read & iterate through every line
while IFS= read -r line
do
    declare -a eachline=( $( echo $line | cut -d' ' -f1- ) )
    KEY=${eachline[0]}
    VALUE=${eachline[1]}
    INPUT_MAP[$KEY]=$VALUE
done < "$INPUT_FILE"

# Check if give values exists in the file or not
if [[ ${INPUT_MAP[$PARAM1]} ]]; then
    if [[ ${INPUT_MAP[$PARAM2]} ]]; then
        VALUE1=INPUT_MAP[$PARAM1]
        VALUE2=INPUT_MAP[$PARAM2]
    else
        echo "Invalid value for second argument i.e., $PARAM2"
    fi
else
    echo "Invalid value for first argument i.e., $PARAM1"
fi

# Use VALUE1 and VALUE2 here
ORACLESID=$VALUE1
CUSTID=$VALUE2

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
exit