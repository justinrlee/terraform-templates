variable "region_r1" {}
variable "prefix_r1" {}
variable "region_short_r1" {}
variable "zones_r1" {}

variable "ec2_public_key_name_r1" {}

# Ubuntu 20.04 LTS ARM64, 20241022
# 24.04 isn't yet supported: 
# https://docs.confluent.io/platform/current/installation/versions-interoperability.html#operating-systems
variable "ami_r1" {
    default = "ami-0427dff89cb7bbfd2"
}

variable "instances_r1" {}