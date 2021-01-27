variable "env" {
  description = "Nom de l'appli + Environnement"
  type = string
}

variable "key_name" {
  description = "Nom de l'appli + Environnement"
  type = string
}

variable "ami_id" {
  description = "Id de AMI"
  type = string
}

variable "subnet" {
  description = "accessibilité du subnet"
  type = string
}

variable "subnet_kc_private" {
  description = "Private Subnet"
  type = string
  default = "subnet_kc_private"
}

variable "subnet_kc_public" {
  description = "Public Subnet"
  type = string
  default = "subnet_kc_public"
}

variable "vpc_security_group_ids" {}
variable "name" {}
variable "directory" {}
variable "isDocker" {}
