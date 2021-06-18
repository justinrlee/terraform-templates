# Customization

variable "cluster_name" {
}

variable "owner_name" {
}

variable "use1_ec2_public_key_name" {
}
variable "use2_ec2_public_key_name" {
}
variable "usw2_ec2_public_key_name" {
}

# Region-specific
variable "use1_slash16" {
}

variable "use2_slash16" {
}

variable "usw2_slash16" {
}

# Static but overrideable
variable "worker_count" {
  default = "1"
}

variable "worker_instance_type" {
  default = "t3.large"
}

variable "worker_tags" {
  type    = map(string)
  default = {}
}

variable "worker_associate_public_ip_address" {
  default = true
}

variable "worker_delete_root_block_device_on_termination" {
  default = true
}

variable zookeeper_instance_type {
  default = "t3.xlarge"
}

variable zookeeper_public {
  default = true
}

variable broker_instance_type {
  default = "t3.xlarge"
}

variable broker_public {
  default = true
}

variable broker_count {
  default = 3
}