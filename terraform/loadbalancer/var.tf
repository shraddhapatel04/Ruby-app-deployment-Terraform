variable "name"{
    description = "Name of the Lodbalancer being created"
    type = "string"
}

variable "sg_id"{
    description = "ID of the Security group for the LB being created"
    type = "string"
}

variable "public_subnets"{
    description = "ID of the public subnet where the LB is launched"
    type = "list"
}

variable "asg_id"{
    description = "ID of the Autoscaling group attached to the LB"
    type = "string"
}