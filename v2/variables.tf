variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(any)
  default     = ["sg-***", "sg-***", "sg-***"]
}


variable "subnet_public" {
  type    = list(any)
  default = ["subnet-***", "subnet-***", "subnet-***"]
}

variable "subnet_private" {
  type    = list(any)
  default = ["subnet-***", "subnet-***", "subnet-***"]
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = map(any)
  default = {
    dev : "serverDevKeyPem"
    prod : "serverProdKeyPem"
  }
}

variable "ENV" {
  type = string
}

variable "ALIAS" {
  type = string
}
variable "DOMAIN" {
  type = string
}

variable "SLUG" {
  type = string
}

variable "NAME" {
  type = string
}

variable "INSTANCE" {
  type = string
}

variable "AMI" {
  type = string
}

variable "PUBLIC" {
  type = bool
}

variable "STATUS" {
  type = string
}
