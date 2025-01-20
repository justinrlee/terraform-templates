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

# Used for bastion host
variable "myip" {}

############## Listener configurations


variable "kafka_boostrap_port" {
  default = 9092
}

variable "port_broker_start" {
  default = 10000
}

variable "brokers_per_nlb" {
  default = 48
}

# SSL Policy used for TLS listeners
# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/describe-ssl-policies.html for more details
variable "ssl_policy" {
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

locals {
  total_brokers = var.brokers_per_nlb * 3
  min_kafka_port = var.port_broker_start
  max_kafka_port = var.port_broker_start + local.total_brokers - 1
}

# variable "min_kafka_port" {
#   default = 9092
# }

# variable "max_kafka_port" {
#   # dynamic ports are 9100 - 9243 (for 144 brokers)
#   default = 9243
# }

############## NLB variables
# variable "port_broker_start" {
#   default = 9100
# }
# # TODO consolidate with below
# variable "port_broker_end" {
#   default = 9243
# }


variable "certificate_arn" {}

############## Bastion variabless
variable "ec2_public_key_name" {}
variable "bastion_instance_type" {}
variable "bastion_volume_size" {
  default = 32
}

############## DNS

variable "proxy_dns_zone" {
  # Should be a public hosted zone
  default = "confluent.justinrlee.io"
}
variable "proxy_bootstrap" {
  default = "kafka"
}
variable "proxy_endpoints" {
  default = {
    "az1" = "kafka-az1",
    "az2" = "kafka-az2",
    "az3" = "kafka-az3",
  }
}

variable "zone_broker_offsets" {
  default = {
    "az1" = 0,
    "az2" = 1,
    "az3" = 2,
  }
}

variable "bootstrap_server" {}

############## Proxy instances
variable "proxy_ami_id" {}
variable "proxy_ec2_public_key_name" {}
variable "proxy_instance_type" {
  default = "m6i.xlarge"
}
variable "proxy_volume_size" {
  default = 40
}
