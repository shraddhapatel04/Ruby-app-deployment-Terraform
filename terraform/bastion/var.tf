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
variable "public_subnets" {
    type = "list"
    description = "List of Public subnets"
}

variable "keypair_name" {
    type = "string"
    description = "Key Pair used to launch Bastion Node"
}