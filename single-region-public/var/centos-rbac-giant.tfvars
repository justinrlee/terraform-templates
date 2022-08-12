# Intended to test cluster rebuild (replace zookeepers with new zookeepers, brokers with new brokers, C3 with new C3)
prefix = "10.9"

bastion_count = 1

zookeeper_count = 10

broker_count = 0

extra_control_center_count = 2

schema_registry_count = 4

aws_amis = {
  # justin-packer-centos-1655742322
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

zones = [2, 4, 6]

zonal_broker_count = 4