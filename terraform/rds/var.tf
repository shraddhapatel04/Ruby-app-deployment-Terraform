variable "name" {
    type = "string"
    description = "Nmae of the RDS resources being launched"
}

variable "user" {
    type = "string"
    description = "Username for the RDS Database"
}


variable "password" {
    type = "string"
    description = "password for the RDS Database"
}

variable "vpc_id" {
    type = "string"
    description = "VPC ID where the database is launched"
}

variable "subnet_ids" {
    type = "list"
    description = "Subnet ID where the database is launched"
}

variable "cidr" {
    type = "string"
    description = "CIDR for Security Group"
}
