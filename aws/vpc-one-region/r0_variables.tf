variable "region_r0" {}
variable "prefix_r0" {}
variable "region_short_r0" {}
variable "zones_r0" {}

variable "ec2_public_key_name_r0" {}

# Ubuntu 20.04 LTS ARM64, 20241022
# 24.04 isn't yet supported: 
# https://docs.confluent.io/platform/current/installation/versions-interoperability.html#operating-systems
variable "ami_r0" {
    default = "ami-0e649cb5c97b59206"
}

# 22.04 ap-southeast-1
# Intel
# 	ami-0aebd6a41cf6ab2eb # 2025-03-27
# ARM
#  ami-0edc2b8974fff28e1 # 2025-03-27

variable "instances_r0" {}