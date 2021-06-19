# Env customization

variable "cluster_name" {}

variable "owner_name" {}

variable "r0s_ec2_public_key_name" {}
variable "r1s_ec2_public_key_name" {}
variable "r2s_ec2_public_key_name" {}

# Region-specific (prefix for a /16; eg., 10.8)
variable "r0s_prefix16" {}
variable "r1s_prefix16" {}
variable "r2s_prefix16" {}

# Region Settings
# Full region name (e.g., us-east-1)
variable "r0" {
  default = "us-east-1"
}

variable "r1" {
  default = "us-east-2"
}

variable "r2" {
  default = "us-west-2"
}

# Region shortname (e.g., use1)
variable "r0s" {
  default = "use1"
}

variable "r1s" {
  default = "use2"
}

variable "r2s" {
  default = "usw2"
}

# Defaults

# Bastion Settings
variable bastion_counts {
  default = [1, 0, 0]
}

variable "bastion_instance_type" {
  default = "t3.large"
}

variable bastion_public_subnet {
  default = true
}

variable bastion_public_ip {
  default = true
}

variable "bastion_delete_root_block_device_on_termination" {
  default = true
}

# Zookeeper Settings
variable zookeeper_counts {
  default = [1, 1, 1]
}

variable zookeeper_instance_type {
  default = "t3.xlarge"
}

variable zookeeper_public_subnet {
  default = true
}

variable zookeeper_public_ip {
  default = false
}

variable "zookeeper_delete_root_block_device_on_termination" {
  default = true
}

# Broker Settings
# Broker count is per-region
variable broker_counts {
  default = [3, 3, 0]
}

variable r0s_broker_count {
  default = 3
}

variable r1s_broker_count {
  default = 3
}

variable r2s_broker_count {
  default = 0
}

variable broker_instance_type {
  default = "t3.xlarge"
}

variable broker_public_subnet {
  default = true
}

variable broker_public_ip {
  default = true
}

variable "broker_delete_root_block_device_on_termination" {
  default = true
}