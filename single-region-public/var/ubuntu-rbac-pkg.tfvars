# Default tfvars
# environment_name = "justin-srp-ubuntu-rbac"
# owner_name = "Justin Lee"

# ec2_public_key_name = "justinrlee-confluent-dev"
prefix = "10.18"

bastion_count = 1

zookeeper_count = 3

broker_count = 4

extra_control_center_count = 0

schema_registry_count = 1

iam_instance_profile = null
# iam_instance_profile = "Justin-Secrets"

client_listener = "public_dns"

aws_amis = {
  # Prebaked Ubuntu 20.04 with git, docker, ansible, java
  # justin-packer-ubuntu-1655684014
  "us-east-1"      = "ami-00e519b15d7a6e830"
  # justin-packer-ubuntu-1655687335-7.1.1 (includes 7.1.1 installed via APT)
  # "us-east-1"      = ami-05953d32a6cf53f65
}

bastion_instance_type = "t3.xlarge"
zookeeper_instance_type = "t3.xlarge"
broker_instance_type = "t3.xlarge"
schema_registry_instance_type = "t3.medium"
control_center_instance_type = "t3.xlarge"

zonal_broker_count = 0