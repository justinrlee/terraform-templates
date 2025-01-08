
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

variable "peering_cidr" {}
variable "peering_connection_id" {}

variable "route_table_default" {}
variable "route_table_zone_mapping" {}