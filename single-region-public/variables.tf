# Env customization

variable "environment_name" {}

variable "owner_name" {}
variable "owner_contact" {}

variable "date_updated" {
}

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

# /16 prefix for each VPC (e.g., "10.2" for 10.2.0.0/16)
variable "prefix" {
  # example = ["10.2", "10.18", "10.50"]
}

variable "ec2_public_key_name" {
  # example = ["justin-confluent-dev", "justinrlee-confluent-dev", "justinrlee-confluent-dev"]
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

# variable bastion_public_subnet {
#   default = true
# }

# variable bastion_public_ip {
#   default = true
# }

variable "bastion_delete_root_block_device_on_termination" {
  default = true
}

###################################################################### Zookeeper
variable "zookeeper_count" {
  default = 1
}

# minimum to run a zookeeper and broker
variable "zookeeper_instance_type" {
  default = "t3.large"
}

# variable zookeeper_public_subnet {
#   default = false
# }

# variable zookeeper_public_ip {
#   default = false
# }

variable "zookeeper_delete_root_block_device_on_termination" {
  default = true
}

######################################################################## Brokers
# Broker count is per-region
variable "broker_count" {
  default = 0
}

variable "zonal_broker_count" {
  default = 2
}

variable "zonal_broker_rack" {
  default = true
}

variable "observer_count" {
  default = 0
}

variable zonal_observer_count {
  default = 0
}

# minimum to run a zookeeper and broker
variable "broker_instance_type" {
  default = "t3.large"
}

# variable broker_public_subnet {
#   default = false
# }

# variable broker_public_ip {
#   default = false
# }

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

################################################################ Schema Registry
variable "schema_registry_instance_type" {
  default = "t3.medium"
}

variable "schema_registry_count" {
  default = 0
}

# variable schema_registry_public_subnet {
#   default = false
# }

# variable schema_registry_public_ip {
#   default = false
# }

variable "schema_registry_delete_root_block_device_on_termination" {
  default = true
}

## Connect (not implemented; want multiple connect clusters)

## Rest Proxy (not implemented; low priority)

## ksql (not implemented)

################################################################# Control Center
variable "control_center_instance_type" {
  default = "t3.medium"
}

# By default, we use the bastion as a C3 instance (assuming bastion_for_c3 = true); this is for extra C3 instances
variable "extra_control_center_count" {
  default = 0
}

# variable control_center_public_subnet {
#   default = true
# }

# variable control_center_public_ip {
#   default = true
# }

variable "control_center_delete_root_block_device_on_termination" {
  default = true
}

variable "control_center_mode" {
  default = "management"
  # Options are "all" or "management"
}


################################################################# Connect
# variable "connect_clusters" {
#   #   description = "Should be a map of maps.  Each top-level map key will be a connect cluster; each child map should have the following information:\n name: Name of Connect worker cluster\n counts: 3-tuple of number of instances in each region\n instance_type: instance type for Connect worker instances"
#   default = {}
# }

## TODO: Support external IPs / subnets

### Example
# connect_clusters = {
#       one = {
#           name = "one"
#           counts = [2, 2, 0]
#           instance_type = "t3.large"
#       }
#       two = {
#           name = "two"
#           counts = [2, 2, 0]
#           instance_type = "t3.large"
#       }
#   }


################################################################# KSQL
# variable "ksqldb_clusters" {
#   #   description = "Should be a map of maps.  Each top-level map key will be a connect cluster; each child map should have the following information:\n name: Name of Connect worker cluster\n counts: 3-tuple of number of instances in each region\n instance_type: instance type for Connect worker instances"
#   default = {}
# }