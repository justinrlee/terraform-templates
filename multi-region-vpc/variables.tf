# Env customization

variable "cluster_name" {}

variable "owner_name" {}

# Region Settings
# Full region name (e.g., us-east-1)
variable "regions" {
  default = ["us-east-1", "us-east-2", "us-west-2"]
}

# Region shortname
variable "regions_short" {
  default = ["use1", "use2", "usw2"]
}

# /16 prefix for each VPC (e.g., "10.2" for 10.2.0.0/16)
variable "prefixes" {
  # example = ["10.2", "10.18", "10.50"]
}

variable ec2_public_key_names {
  # example = ["justin-confluent-dev", "justinrlee-confluent-dev", "justinrlee-confluent-dev"]
}


# Defaults
######################################################################## Bastion
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

###################################################################### Zookeeper
variable zookeeper_counts {
  default = [1, 1, 1]
}

variable zookeeper_instance_type {
  default = "t3.xlarge"
}

variable zookeeper_public_subnet {
  default = false
}

variable zookeeper_public_ip {
  default = false
}

variable "zookeeper_delete_root_block_device_on_termination" {
  default = true
}

######################################################################## Brokers
# Broker count is per-region
variable broker_counts {
  default = [3, 3, 0]
}

variable observer_counts {
  default = [1, 1, 0]
}

variable broker_instance_type {
  default = "t3.xlarge"
}

variable broker_public_subnet {
  default = false
}

variable broker_public_ip {
  default = false
}

variable "broker_delete_root_block_device_on_termination" {
  default = true
}

variable "kafka_broker_custom_properties" {
  default = {}
}

# If set, uses public dns names as advertised listener with indicated port
# Should be either null or an int
variable public_listener_port {
  default = null
}

################################################################ Schema Registry
variable schema_registry_instance_type {
  default = "t3.medium"
}

variable schema_registry_counts {
  default = [1, 1, 0]
}

variable schema_registry_public_subnet {
  default = false
}

variable schema_registry_public_ip {
  default = false
}

variable "schema_registry_delete_root_block_device_on_termination" {
  default = true
}

## Connect (not implemented; want multiple connect clusters)

## Rest Proxy (not implemented; low priority)

## ksql (not implemented)

################################################################# Control Center
variable control_center_instance_type {
  default = "t3.xlarge"
}

variable control_center_counts {
  default = [1, 0, 0]
}

variable control_center_public_subnet {
  default = true
}

variable control_center_public_ip {
  default = true
}

variable "control_center_delete_root_block_device_on_termination" {
  default = true
}