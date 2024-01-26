# Env customization

variable "environment_name" {}

variable "owner_name" {} # TF_VAR_owner_name
variable "owner_contact" {} # TF_VAR_owner_contact
variable "date_updated" {} # TF_VAR_date_updated

variable "ec2_public_key_name" {} # TF_VAR_ec2_public_key_name

# Region Settings
# Full region name (e.g., us-east-1)
variable "region" {
  default = "us-east-1"
}

# Region shortname
variable "region_short" {
  default = "use1"
}

variable "zones" {
  default = [1, 2, 5]
}

variable "zk_closed_counts" {
  default = [3, 3, 3]
}

variable "kafka_closed_counts" {
  default = [3, 3, 3]
}

variable "deny_ab" {
  default = false
}

variable "deny_bc" {
  default = false
}

variable "deny_ac" {
  default = false
}

# variable "subnets" {
#   default = [11, 12, 21, 22, 51, 52]
# }

# variable "subnets" {
#   default = [11, 12, 21, 22, 51, 52]
# }

# /16 prefix for each VPC (e.g., "10.2" for 10.2.0.0/16)
variable "prefix" {
  # example = ["10.2", "10.18", "10.50"]
}

variable "iam_instance_profile" {
  default = null
}

variable "binpack_zookeeper_brokers" {
  default = true
}

# should be the name of terraform property on EC2 instance: "private_dns" or "public_dns" work well
variable "client_listener" {
  default = "public_dns"
}

variable "bastion_for_c3" {
  default = true
}

# Defaults
######################################################################## Bastion
variable "bastion_count" {
  default = 1
}

variable "bastion_instance_type" {
  default = "t3.small"
}
variable "bastion_delete_root_block_device_on_termination" {
  default = true
}

###################################################################### Zookeeper
variable "zookeeper_count" {
  default = 1
}

variable "zookeeper_instance_type" {
  default = "t3.medium"
}

variable "zookeeper_delete_root_block_device_on_termination" {
  default = true
}

######################################################################## Brokers
# Broker count is per-region
variable "broker_count" {
  default = 0
}

variable "zonal_broker_rack" {
  default = true
}

# minimum to run a zookeeper and broker
variable "broker_instance_type" {
  default = "t3.medium"
}

variable "broker_delete_root_block_device_on_termination" {
  default = true
}

variable "kafka_broker_custom_properties" {
  default = {}
}

# If set, uses public dns names as advertised listener with indicated port
# Should be either null or an int
variable "public_listener_port" {
  default = null
}