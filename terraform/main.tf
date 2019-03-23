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