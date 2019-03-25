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

module "bastion" {
    source = "./bastion"
    name = "${var.name}"
    vpc_id = "${module.vpc.vpc_id}"
    instance_type = "${var.instance_type}"
    public_subnets = "${module.vpc.public_subnets}"
    keypair_name = "${module.ssh.key_name}"
}