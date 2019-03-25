variable "name" {
  type = "string"
  description = "Name of the Stack that will be launched and given to all resources"
}

variable "cidr" {
  type = "string"
  description = "CIDR range of the VPC created"
}

variable "region" {
  type = "string"
  description = "Region where the resouces will be launched"
}

variable "profile" {
  type = "string"
  description = "The AWS role assumed by terraform to perform actions"
}

variable "ssh_public_key_location" {
  type = "string"
  description = "The location where .pub file is placed"
}

variable "instance_type" {
  type = "string"
  description = "Type of instances to be launched"
}

# variable "public_subnets" {
#     description = "List of Public subnets IDs"
# }

# variable "keypair_name" {
#     description = "SSH key pair used to launch instances"
# }