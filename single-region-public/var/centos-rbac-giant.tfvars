# Default tfvars
environment_name = "justin-srp-centos-rbac"
owner_name = "Justin Lee"

ec2_public_key_name = "justinrlee-confluent-dev"
prefix = "10.9"

bastion_count = 1

zookeeper_count = 10

broker_count = 12

extra_control_center_count = 2

schema_registry_count = 4

iam_instance_profile = null
# iam_instance_profile = "Justin-Secrets"

client_listener = "public_dns"

aws_amis = {
  "us-east-1"      = "ami-0cf4ce46d7a86e24a"
}

# Small: 2/2
# Medium: 2/4
# Large: 2/8
# xlarge: 4/16
# 2xlarge: 8/32
bastion_instance_type = "t3.medium"
zookeeper_instance_type = "t3.medium"
broker_instance_type = "t3.large"
schema_registry_instance_type = "t3.small"
control_center_instance_type = "t3.xlarge" # perf tests run from here

binpack_zookeeper_brokers = false
bastion_for_c3 = false