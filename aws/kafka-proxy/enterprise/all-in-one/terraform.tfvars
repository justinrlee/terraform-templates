environment_name = "justin-glkp-usw2"

prefix = "10.25"
region = "us-west-2"
region_short = "usw2"
zones = {
    "az1" = {
      "subnet" = 1,
      "az"     = "2b",
      "name"   = "us-west-2b",
    },
    "az2" = {
      "subnet" = 2,
      "az"     = "2a",
      "name"   = "us-west-2a",
    },
    "az3" = {
      "subnet" = 3,
      "az"     = "2c",
      "name"   = "us-west-2c",
    },
    "az4" = {
      "subnet" = 4,
      "az"     = "2d",
      "name"   = "us-west-2d",
    },
  }

bastion_ami_id = "ami-0b4bfcfff930ca7c0" # AMD64
# bastion_ami_id = "ami-0a23f6cff7b1c8ca1" # ARM64
bastion_instance_type = "t3.medium"
bastion_public_key_name = "justinrlee-confluent-dev"
bastion_allowed_ranges = [
]

route_53_domain = "confluent.justinrlee.io"

subdomain = "usw2"

# Proxy
proxy_ami_id = "ami-0b4bfcfff930ca7c0"
proxy_instance_type = "c6i.xlarge"
proxy_volume_size = 60
proxy_public_key_name = "justinrlee-confluent-dev"