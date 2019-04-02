####################################
## Provider details
####################################

provider "aws" {
  profile = "${var.profile}"
  region     = "${var.region}"
}

####################################
## VPC
####################################
module "vpc" {
    source = "./vpc"
    cidr = "${var.cidr}"
    name = "${var.name}"
}

####################################
## SSH
####################################

module "ssh" {
    source = "./ssh"
    ssh_public_key_location = "${var.ssh_public_key_location}"
    name = "${var.name}"
}

####################################
## Bastion
####################################

module "bastion_iam_role" {
    source = "./iam"
    name = "${var.name}.bastion"
    iamrole_template = "./templates/bastion_iam.tpl"
}

module "bastion_sg" {
    source = "./securitygroup_cidr"
    name = "${var.name}.bastion"
    vpc_id = "${module.vpc.vpc_id}"
    sg_ports = "22"
    protocol = "SSH"
    cidr = ["0.0.0.0/0"]
}

module "bastion" {
    source = "./autoscaling"
    name = "${var.name}.bastion"
    vpc_id = "${module.vpc.vpc_id}"
    instance_type = "${var.instance_type}"
    subnets = "${module.vpc.public_subnets}"
    keypair_name = "${module.ssh.key_name}"
    iam_instance_profile = "${module.bastion_iam_role.iam_instance_profile}"
    sg_id = "${module.bastion_sg.sg_id}"
    userdata_path = "./templates/bastion_userdata.sh"
}

####################################
## Application Servers
####################################
module "application_iam_role" {
    source = "./iam"
    name = "${var.name}.appserver"
    iamrole_template = "./templates/webserver_iam.tpl"
}  

module "loadbalancer_sg" {
    source = "./securitygroup_cidr"
    name = "${var.name}.applb"
    vpc_id = "${module.vpc.vpc_id}"
    sg_ports = "80,443"
    protocol = "HTTP,HTTPS"
    cidr = ["0.0.0.0/0"]
}

module "application_sg" {
    source = "./securitygroup_sg"
    name = "${var.name}.appserver"
    vpc_id = "${module.vpc.vpc_id}"
    sg_ports = "22,80"
    protocol = "SSH,HTTP"
    source_sg_id = ["${module.bastion_sg.sg_id}","${module.loadbalancer_sg.sg_id}"]
}

module "application" {
    source = "./autoscaling"
    name = "${var.name}.appserver"
    vpc_id = "${module.vpc.vpc_id}"
    instance_type = "${var.instance_type}"
    subnets = "${module.vpc.private_subnets}"
    keypair_name = "${module.ssh.key_name}"
    iam_instance_profile = "${module.application_iam_role.iam_instance_profile}"
    sg_id = "${module.application_sg.sg_id}"
    userdata_path = "./templates/appserver_userdata.sh"
}


module "loadbalancer" {
    source = "./loadbalancer"
    name = "${var.name}"
    sg_id = "${module.loadbalancer_sg.sg_id}"
    public_subnets = "${module.vpc.public_subnets}"
    asg_id = "${module.application.asg_id}"
}

####################################
## RDS DATABASE
####################################

module "rds" {
    source = "./rds"
    name = "${var.name}"
    subnet_ids = ["${module.vpc.private_subnets}"]
    vpc_id = "${module.vpc.vpc_id}"
    cidr = "${var.cidr}"
    user = "${var.db_user}"
    password = "${var.db_password}"
}