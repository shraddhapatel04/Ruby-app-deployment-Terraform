variable "vpc_id" {
    type = "string"
    description = "VPC id of the launched"
}

variable "name" {
    type = "string"
    description = "Name associated with resources being created"
}

variable "instance_type" {
    type = "string"
    description = "Type of instance being created"
}
variable "subnets" {
    type = "list"
    description = "List of Public subnets"
}

variable "keypair_name" {
    type = "string"
    description = "Key Pair used to launch Bastion Node"
}

variable "sg_id" {
    type = "string"
    description = "Security Group of the  launch Bastion Node"
}

variable "iam_instance_profile" {
    type = "string"
    description = "IAM Instance Profile of launch Bastion Node"
}

variable "userdata_path" {
    type = "string"
    description = "Path where the userdata file is placed"
}