#### details of the repository ####
    This repo contains the scripts which can spinup ec2 instance with inputs given. Taking the ORACLESID, 
the scripts takes the most recent snapshot and attaches to the volume.
------------------------------------------------------------------------------------------------------------------------------------*




** Prerequisites :**

1. AWS CLI
2. relevant .pem
3. Terraform
4. Ansible
5. Relevant Oracle SID
6. Customer name/string



###### How to run the instance?? ######

	run the start.sh file as follows.
		./start.sh ORACLESID CUSTID(6 digits)

	error: if you fail to provide the ORACLESID && CUSTID, a dummy space will be  created in hosts file.
-------------------------------------------------------------------------------------------------------------------------------------


To check the things went right,
    1. check for the hostname, it has to be like ORACLESIDCUSTID.
    2. Use command 'lsblk' to check if the volume is attached
    3. Use command 'df -h' to check if the volume is mounted.
