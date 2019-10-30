provider "aws" {
        region          =       "us-east-1"
}

data "aws_ebs_snapshot" "db_snap" {
  most_recent = true
  owners      = ["${var.tag_owners}"]

  filter {
    name   = "tag:Name"
    values = ["${var.oraclesid}*"]
  }
}
resource "aws_instance" "CUST_DB" {
        ami                     =       "${var.db_ami}"
        instance_type           =       "${var.type}"
        subnet_id               =       "${var.subnet_id}"
        vpc_security_group_ids  =       "${var.security_groups}"
        key_name                =       "${var.key_name}"
        iam_instance_profile    =       "${var.policy}"
        ebs_optimized           =       "${var.tag_term}"
        tags ={
                Name                    =       "${var.tag_instance}"
                applicationid           =       "${var.tag_application}"
		unique_id		=	"CTE_CUSTOMER"
                version                 =       "1"
                department              =       "${var.tag_department}"
                env                     =       "${var.enviornment}"
                		}
}




## creating, attaching and taking snapshot of the ebs volume(XPPNP) ##
resource "aws_ebs_volume" "db_snapshot-datafiles" {
        availability_zone = "us-east-1a"
        size = "${var.tag_size}"
        type = "${var.tag_type}"
        snapshot_id = "${data.aws_ebs_snapshot.db_snap.id}"
        tags =  {
                description = "ebs volume for the db_snapshot DB datafiles for migration"
                Name = "db_snapshot-datafiles"
		snapshot = "${data.aws_ebs_snapshot.db_snap.id}"

        }
}

resource "aws_volume_attachment" "db_snapshot-datafiles-attachment" {
        device_name = "/dev/xvdb"
        volume_id = "${aws_ebs_volume.db_snapshot-datafiles.id}"
        instance_id = "${aws_instance.CUST_DB.id}"
}

resource "aws_route53_record" "dns_entry" {
	zone_id ="${var.ZONEID}"
	name = "${var.CREATEDHOSTNAME}"
	type = "A"
	ttl = "300"
	records = ["${aws_instance.CUST_DB.*.private_ip[0]}"]
}
output "instance_ip" {
    value = "${aws_instance.CUST_DB.*.private_ip[0]}"
}
