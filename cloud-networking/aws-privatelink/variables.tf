variable "environment_name" {
  type = string
  validation {
    condition     = can(regex("[a-z]([-a-z0-9]*[a-z0-9])?", var.environment_name))
    error_message = "Invalid environment_name; must start with lowercase letter, and all following characters must be a dash, lowercase letter, or digit."
  }
}

variable "aws_amis" {
  default = {
    "us-east-1" = "ami-01d08089481510ba2",
    "us-east-2" = "ami-0066d036f9777ec38",
    "us-west-1" = "ami-064562725417500be",
    "us-west-2" = "ami-0066d036f9777ec38",
  }

}

variable "region" {}


variable "availability_zones" {
  # use1-az3 doesn't work cause it doesn't have C5N
  # default = ["use1-az1", "use1-az2", "use1-az5"]
}
# TODO Remove this
variable "zones" {}
variable "aws_account" {}
variable "owner" {}
variable "owner_email" {}

# Not useful for PL, may be helpful for Peering
variable "internal_proxy" {
  default = false
}

variable "external_proxy" {
  default = true
}

variable "external_dns" {
  default = true
}

variable "external_proxy_whitelist" {
  default = ["0.0.0.0/0"]
}

variable "dedicated_cluster" {
  default = true
}

variable "dedicated_maz" {
  default = false
}

variable "dedicated_ckus" {
  default = 1
}

variable "namespace" {
  default = "confluent-proxy"
}

variable "eks_version" {
  default = "1.23"
}

variable "controller_namespace" {
  default = "kube-system"
}

variable "controller_name" {
  default = "aws-load-balancer-controller"
}