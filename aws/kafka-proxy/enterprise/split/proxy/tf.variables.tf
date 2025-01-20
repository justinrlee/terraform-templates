
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


############## Proxy Configurations
variable "proxy_ami_id" {}
variable "proxy_instance_type" {}
variable "proxy_ec2_public_key_name" {}
variable "proxy_volume_size" {
  default = 40
}
variable "proxy_bootstrap" {}
# variable "proxy_endpoints" {}
variable "bootstrap_server" {}

############## Network configurations
variable "route_53_domain" {}
variable "certificate_arn" {}
variable "ssl_policy" {
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}
variable "port_bootstrap" {
  default = 9092
}
variable "port_broker_start" {
  default = 10000
}
variable "brokers_per_nlb" {
  default = 48
}

############## Inputs from prereqs
variable "vpc_id" {}
variable "nlb_security_group_id" {}
variable "internal_security_group_id" {}
variable "zone_eip_mappings" {}
variable "nlb_arn" {}
variable "zone_private_subnet_mappings" {}