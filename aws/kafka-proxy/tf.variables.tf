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

############## Firewall variables
# Used for bastion host
variable "myip" {}

variable "min_kafka_port" {
  default = 9092
}

variable "max_kafka_port" {
  # dynamic ports are 9100 - 9243 (for 144 brokers)
  default = 9243
}

############## NLB variables
variable "port_broker_start" {
  default = 9100
}
# TODO consolidate with below
variable "port_broker_end" {
  default = 9243
}
variable "brokers_per_nlb" {
  default = 24
}

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
  default = "kp"
}
variable "proxy_endpoints" {
  default = {
    "az1_a" = "kp-az1-a",
    "az2_a" = "kp-az2-a",
    "az3_a" = "kp-az3-a",
    "az1_b" = "kp-az1-b",
    "az2_b" = "kp-az2-b",
    "az3_b" = "kp-az3-b",
  }
}

variable "zone_broker_offsets" {
  default = {
    "az1_a" = 0,
    "az2_a" = 1,
    "az3_a" = 2,
    "az1_b" = 3,
    "az2_b" = 4,
    "az3_b" = 5,
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
