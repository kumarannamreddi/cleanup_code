#!/usr/bin/bash
# run this as sudo
# this will parse the newly created EC2 instances for their private IPs then concatenate
# them to the end of the /etc/ansible/hosts file under [ctepnpcust$]
cat ../terraform.tfstate |grep "private_ip" | awk '{print $2}' |cut -d'"' -f2 > IP.txt;
chown ec2-user:ec2-user IP.txt;
# cat IPS.txt >> /etc/ansible/hosts;
#csplit IP.txt 2 -f custom; 
cat IP.txt > createdIP;
chown ec2-user:ec2-user createdIP;
export ORACLESID=$(cat ../oraclesid.BAK)
export CUSTID=$(cat ../customerid.BAK)
export SIDPLUSCUST=$(cat ../custid.BAK)
echo "[$SIDPLUSCUST]" | cat - createdIP > formattedIPName ;
chown ec2-user:ec2-user *;
cat formattedIPName >> /etc/ansible/hosts;
# create 
# append IP to cust1 file under roles
cat createdIP >> roles/customersetup/templates/ctepnpcust1.hosts;
# replace placeholders within group_vars/pnpsetup/yml
#sed -i -e "s/replacehostname/$SIDPLUSCUST/" group_vars/pnpsetup.yml
#sed -i -e "s/replaceoraclesid/$ORACLESID/" group_vars/pnpsetup.yml 
# append IPs to the group_vars
#cat createdIP >> group_vars/pnpsetup.yml; 
echo -e "---\nhostname: $SIDPLUSCUST\noraclesid: $ORACLESID\ndomain: cte-prod.aws.gwl.com\n$ipaddress: $(cat createdIP)" > group_vars/pnpsetup.yml
# sed prepend 'ipaddress: ' to the vars above
sed -i -e '5s/^/ipaddress: /' group_vars/pnpsetup.yml;
# replace placeholders with values in Playbook
sed -i '/hosts:/d' Playbook.yml
sed -i "2a\ \ hosts: $SIDPLUSCUST" Playbook.yml
sed -i '/hostname:/d' Playbook.yml
sed -i "/vars:/a \ \ \ \ \ hostname: $SIDPLUSCUST" Playbook.yml
echo "     ipaddress: $(cat createdIP)" >> Playbook.yml
sed -i -e "s/replacehostname/$SIDPLUSCUST/" Playbook.yml
sed -i -e "s/replaceoraclesid/$ORACLESID/" Playbook.yml
# append IPs to the relevant playbook
#cat createdIP >> Playbook.yml;
# sed the playbooks for formatting
sed -i '/ipaddress:/d' Playbook.yml 
echo "     ipaddress: $(cat createdIP)" >> Playbook.yml

#sed -i -e '13s/^/     ipaddress: /' Playbook.yml;
chown -R ec2-user:ec2-user $PWD/*;
