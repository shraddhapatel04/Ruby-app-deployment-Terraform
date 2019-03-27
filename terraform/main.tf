provider "aws" {
  profile = "${var.profile}"
  region     = "${var.region}"
}

module "vpc" {
    source = "./vpc"
    cidr = "${var.cidr}"
    name = "${var.name}"
}

module "ssh" {
    source = "./ssh"
    ssh_public_key_location = "${var.ssh_public_key_location}"
    name = "${var.name}"
}

module "bastion_iam_role" {
    source = "./iam"
    name = "${var.name}.bastion.iam.computed"
    iamrole_template = "./templates/bastion_iam.tpl"
}

module "bastion_sg" {
    source = "./securitygroup"
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
}

# module "loadbalancer" {
#     source = "./loadbalancer"
#     name = "${var.name}"
#     vpc_id = "${module.vpc.vpc_id}"
#     public_subnets = "${module.vpc.public_subnets}"
# }

module "loadbalancer_sg" {
    source = "./securitygroup"
    name = "${var.name}-applb"
    vpc_id = "${module.vpc.vpc_id}"
    sg_ports = "22,80,443"
    protocol = "SSH,HTTP,HTTPS"
    cidr = ["0.0.0.0/0"]
}