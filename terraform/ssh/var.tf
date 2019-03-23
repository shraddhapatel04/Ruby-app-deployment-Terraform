variable "name" {
  type = "string"
  description = "Name of the Key Pair that will be launched"
}

variable "ssh_public_key_location" {
  type = "string"
  description = "The location where .pub file is placed"
}