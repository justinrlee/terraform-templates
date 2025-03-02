# Currently configured for us-east-1

# General
environment_name = "justinrlee-use1-kp"

# Region-specific
region = "us-east-1"
region_short = "use1"

zones = {
    "az1" = {
        "subnet" = 1,
        "az"     = "1d",
        "name"   = "us-east-1d",
    },
    "az2" = {
        "subnet" = 2,
        "az"     = "1a",
        "name"   = "us-east-1a",
    },
    # "az3" = {
    #     "subnet" = 3,
    #     "az"     = "1e",
    #     "name"   = "us-east-1e",
    # },
    "az4" = {
        "subnet" = 4,
        "az"     = "1b",
        "name"   = "us-east-1b",
    },
    "az5" = {
        "subnet" = 5,
        "az"     = "1f",
        "name"   = "us-east-1f",
    },
    "az6" = {
        "subnet" = 6,
        "az"     = "1c",
        "name"   = "us-east-1c",
    },
}

# Prereq-specific
prefix = "10.6"
bastion_instance_type = "t3.xlarge"
ec2_public_key_name = "justinrlee-confluent-dev"

# use1 Ubuntu 24.04 LTS amd64
ami = "ami-079cb33ef719a7b78"
# use1 Ubuntu 24.04 LTS arm64
# ami = "ami-04474687c34a061cf"