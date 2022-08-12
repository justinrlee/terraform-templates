# Default tfvars
# environment_name = "justin-srp-centos-rbac"
# owner_name = "Justin Lee"

# ec2_public_key_name = "justinrlee-confluent-dev"
prefix = "10.9"

bastion_count = 1

zookeeper_count = 3

broker_count = 4

extra_control_center_count = 0

schema_registry_count = 1

client_listener = "public_dns"

aws_amis = {
  # justin-packer-centos-1655742322
  "us-east-1"      = "ami-0cf4ce46d7a86e24a"
}

bastion_instance_type = "t3.xlarge"
zookeeper_instance_type = "t3.xlarge"
broker_instance_type = "t3.xlarge"
schema_registry_instance_type = "t3.medium"
control_center_instance_type = "t3.xlarge"