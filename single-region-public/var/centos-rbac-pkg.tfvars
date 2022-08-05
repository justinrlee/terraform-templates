# Default tfvars
environment_name = "justin-srp-centos-rbac"
owner_name = "Justin Lee"

ec2_public_key_name = "justinrlee-confluent-dev"
prefix = "10.9"

bastion_count = 1

zookeeper_count = 3

broker_count = 4

extra_control_center_count = 0

schema_registry_count = 1

iam_instance_profile = null
# iam_instance_profile = "Justin-Secrets"

client_listener = "public_dns"

aws_amis = {
  "us-east-1"      = "ami-0192e2547e058b4e1"
}

bastion_instance_type = "t3.xlarge"
zookeeper_instance_type = "t3.xlarge"
broker_instance_type = "t3.xlarge"
schema_registry_instance_type = "t3.medium"
control_center_instance_type = "t3.xlarge"