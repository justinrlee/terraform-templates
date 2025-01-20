# Env customization
variable "environment_name" {}

# Region Settings
# Full region name (e.g., us-east-1)
variable "region" {}
# Region shortname
variable "region_short" {}

# variable "ami" {}

variable "zones" {}

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

variable "brokers_per_nlb" {
  default = 48  
}

variable "nlb_max_port" {
  default = 10000 + 48 - 1
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

############################ Bastion configurations
# Security group used for bastion host
variable "bastion_allowed_ranges" {}
variable "myip" {}
variable "bastion_ami_id" {}
variable "bastion_instance_type" {}
variable "bastion_public_key_name" {}

# variable "ec2_public_key_name" {}
# variable "bastion_instance_type" {}
variable "bastion_volume_size" {
  default = 32
}

############################# DNS / ACM configurations
variable "route_53_domain" {}
variable "subdomain" {}
variable "certificate" {
  default = "kafka"
}

############################# Proxy Configurations
# variable "bootstrap_server" {}
variable "proxy_ami_id" {}
variable "proxy_instance_type" {}
variable "proxy_volume_size" {}
variable "proxy_public_key_name" {}
variable "proxy_tarball" {
  default = "https://github.com/justinrlee/kafka-proxy/releases/download/v0.3.15-dl-rs-cap/kafka-proxy-v0.3.15-dl-rs-cap-linux-amd64.tar.gz"
}
variable "proxy_count_min" {
  default = 0
}
variable "proxy_count_desired" {
  default = 4
}
variable "proxy_count_max" {
  default = 12
}