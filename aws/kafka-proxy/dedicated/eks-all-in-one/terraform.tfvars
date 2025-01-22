
environment_name = "justin-kp-eks"
owner_name = "Justin Lee"
owner_contact = "jlee@confluent.io"
date_updated = "2025-01-20"


vpc_cidr = "10.221.0.0/16"
region = "ap-southeast-1"
region_short = "apse1"
zones = {
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

# ap-southeast-1	Noble Numbat	24.04 LTS	amd64	hvm:ebs-ssd-gp3	20250115	ami-0672fd5b9210aa093	hvm
# ap-southeast-1	Noble Numbat	24.04 LTS	arm64	hvm:ebs-ssd-gp3	20250115	ami-0c2e5288624699cd8 hvm
bastion_ami_id = "ami-0672fd5b9210aa093" # AMD64
# bastion_ami_id = "ami-0c2e5288624699cd8" # ARM64

bastion_instance_type = "t3.medium"
bastion_public_key_name = "justinrlee-confluent-dev"
bastion_allowed_ranges = [
  "58.185.17.86/32",
  "119.74.174.151/32",
]

route_53_domain = "confluent.justinrlee.io"

subdomain = "apse1"

proxy_kafka = "dedicated"
proxy_zonal = {
  "az1" = "dedicated-apse1-az1",
  "az2" = "dedicated-apse1-az2",
  "az3" = "dedicated-apse1-az3",
  # "az4" = "dedicated-usw2-az4",
}

# Proxy
proxy_ami_id = "ami-0672fd5b9210aa093"
proxy_instance_type = "c6i.xlarge"
proxy_volume_size = 60
proxy_public_key_name = "justinrlee-confluent-dev"


confluent_cidr = "10.222.0.0/16"