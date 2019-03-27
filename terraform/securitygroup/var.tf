variable "sg_ports" {
    type = "string"
    description = "Ports for Security Group"
}
variable "protocol" {
    type = "string"
    description = "Protocol for Security Group"
}

variable "name" {
    type = "string"
    description = "Name for Security Group"
}

variable "vpc_id" {
    type = "string"
    description = "VPC ID for Security Group"
}
variable "cidr" {
    type = "list"
    description = "CIDR of VPC for Security Group"
}