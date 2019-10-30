
variable "vpc_id" {
        description     =        "The default VPC"
        type            =        "string"
        default         =        "vpc-00e607d1c5a180ed1"
}

variable "db_ami" {
        description     =       "providing the ami id"
        type            =       "string"
        default         =       "ami-07d8bd97b46235bbf"
}

variable "security_groups" {
    type                =  "list"
    description         = "list of security groups"
    default             =  ["sg-014f50ea6bacfc4a8", "sg-03c853503056a8669", "sg-03f095e8d368c6802", "sg-0931fd9395dbfa19d", "sg-0e0e5c0987d0d7428", "sg-05f76decd561ff462", "sg-0a2d684569c7bf919", "sg-0cf6fb200719c0e4f", "sg-045d73422cf4f0d1a"]
}

variable "type" {
        type            =       "string"
        default         =       "r5.2xlarge"
}

variable "subnet_id" {
        type            =       "string"
        default         =       "subnet-0337ec7d3fbb316c7"
}

variable "key_name" {
        type            =       "string"
        default         =       "ctestmt"
}

variable "tag_snapshot" {
	type		=	"string"
	default 	=	"snap-0bab7ac23f449e92e"
}
variable "oraclesid" {
	type 		=	"string"
	default		=	""
}

variable "tag_instance" {
	type 		=	"string"
	default		=	""
}
variable "policy" {
        type            =       "string"
        default         =       "CTEEc2InstanceProfile"
}
variable "tag_application" {
        type            =       "string"
        default         =       "CTE"
}
variable "tag_department" {
        type            =       "string"
        default         =       "CTE"
}
variable "enviornment" {
        type            =       "string"
        default         =       "prod"
}

variable "tag_owners" {
	type 		=	"string"
	default		=	"745078641086"
}

variable "tag_type" {
	type		=	"string"
	default		=	"gp2"
}
variable "tag_size" {
        type            =       "string"
        default         =       "16384"
}
variable "tag_az" {
	type		= 	"string"
	default		=	"us-east-1a"
}

variable "tag_term" {
	type		=	"string"
	default		=	"true"
}

variable "CREATEDHOSTNAME" {
        type            =       "string"
        default         =       ""
}

variable "ZONEID" {
	type		= 	"string"
	default		=	"Z3J0HXHURHTK58"
}
