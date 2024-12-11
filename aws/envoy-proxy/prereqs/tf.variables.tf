# Env customization
variable "environment_name" {}
variable "owner_name" {}
variable "owner_contact" {}
variable "date_updated" {}

# Region Settings
# Full region name (e.g., us-east-1)
variable "region" {
  default = "ap-southeast-1"
}
# Region shortname
variable "region_short" {
  default = "apse1"
}

variable "ami" {}

variable "zones" {
  default = {
    "az1" = {
      "subnet" = 1,
      "az"     = "1a",
      "name"   = "ap-southeast-1a",
    },
    "az2" = {
      "subnet" = 2,
      "az"     = "1b",
      "name"   = "ap-southeast-1b",
    },
    "az3" = {
      "subnet" = 3,
      "az"     = "1c",
      "name"   = "ap-southeast-1c",
    },
  }
}

# # /16 prefix for each VPC (e.g., "10.2" for 10.2.0.0/16)
variable "prefix" {}

############################ Security Group / NLB configurations
variable "nlb_bootstrap_port" {
  default = 9092
}

# Default: 144 brokers, 10000-10143
variable "nlb_min_port" {
  default = 10000
}

variable "nlb_max_port" {
  default = 10000 + 48 * 3 - 1
}

############################ Bastion configurations
# Security group used for bastion host
variable "myip" {}

variable "ec2_public_key_name" {}
variable "bastion_instance_type" {}
variable "bastion_volume_size" {
  default = 32
}
