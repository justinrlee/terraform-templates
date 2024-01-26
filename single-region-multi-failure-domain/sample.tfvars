# Default tfvars
environment_name = "justin-tf-dev"
owner_name       = "Justin Lee"
owner_contact    = "jlee@confluent.io"
date_updated     = "2022-04-15"

ec2_public_key_name = "justinrlee-confluent-dev"
prefix              = "10.2"

iam_instance_profile = "Justin-Secrets"

# `binpack_zookeeper_brokers` and `bastion_for_c3` both to true, so this will stand up the following VMs:
# 1 bastion node, which will also be used by C3
# 3 zookeepers, which also have brokers
# 1 schema registry instance
# 1 extra broker

bastion_count = 1
zookeeper_count = 3
broker_count = 4
zonal_broker_count = 0
schema_registry_count = 1

# You cannot currently deploy both zonal brokers and regular brokers (regular brokers currently support binpacking with zookeeper; zonal brokers do not)

# extra_control_center_count = 0
