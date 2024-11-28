environment_name = "justinrlee-one-region"

############################################################ R0
region_r0 = "ap-southeast-1"
prefix_r0 = "10.38"
region_short_r0 = "apse1"
zones_r0 = {
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