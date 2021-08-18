variable "env" {}
variable "isDocker" {}
variable "directory" {}
variable "port" {}
variable "name" {}
variable "accessKey" {}
variable "secretKey" {}
variable "subnet" {}
variable "nbTarget" {}
variable "key_name" {
  description = "The key name to use for the instance"
  default = "yourKeyHere"
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  default = [
    "sg-1",
    "sg-2"
  ]
}