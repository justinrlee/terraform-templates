environment_name = "justinrlee-one-region-use2"

# Ubuntu 22.04 LTS ARM64 20241211
ami_r0 = "ami-0d1d268a9190c3e4e"

region_r0 = "us-east-2"
prefix_r0 = "10.16"
region_short_r0 = "use2"

zones_r0 = {
    "az1" = {
      "subnet" = 1,
      "az"     = "2a",
      "name"   = "us-east-2a",
    },
    "az2" = {
      "subnet" = 2,
      "az"     = "2b",
      "name"   = "us-east-2b",
    },
    "az3" = {
      "subnet" = 3,
      "az"     = "2c",
      "name"   = "us-east-2c",
    },
  }
ec2_public_key_name_r0 = "justinrlee-confluent-dev"

instances_r0 = {
  "az1" = {
      public_count = 1,
      private_count = 0,
  },
  "az2" = {
      public_count = 1,
      private_count = 0,
  },
  "az3" = {
      public_count = 1,
      private_count = 0,
  },
}
