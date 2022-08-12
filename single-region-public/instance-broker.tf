locals {
  total_brokers = var.broker_count + var.observer_count

  # If binpacking, only create additional brokers if total brokers is higher than total zookeeper
  distinct_bk = (var.binpack_zookeeper_brokers ?
    max(local.total_brokers - var.zookeeper_count, 0)
  : local.total_brokers)
}

# Way to error out TF if settings aren't right:
# https://github.com/hashicorp/terraform/issues/15469#issuecomment-814789329
# Only broker count or zonal broker should be used; one has to be zero

resource "null_resource" "check_brokers" {
  count = (((var.broker_count + var.observer_count == 0) || 
          (var.zonal_broker_count + var.zonal_observer_count == 0)) ? 
            0 : "Either broker_count or zonal_broker_count should be zero")

}

resource "aws_network_interface" "interfaces_brokers" {
  count = local.distinct_bk

  private_ips = ["${var.prefix}.${var.zones[0]}.${100 + count.index}"]
  # private_ips = ["${var.prefix}.${var.zones[count.index % 3]}.${100 + count.index}"]

  security_groups = [
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
    aws_security_group.broker.id,
  ]

  subnet_id = module.vpc.public_subnets[count.index % 3]

  tags = {
    Name = "${var.environment_name}-if"
  }
}

resource "aws_instance" "brokers" {
  count                       = local.distinct_bk
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = var.broker_instance_type
  # associate_public_ip_address = true
  key_name                    = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  # subnet_id = module.vpc.public_subnets[0]
  # subnet_id = module.vpc.public_subnets[count.index % 3]


  network_interface {
    network_interface_id = aws_network_interface.interfaces_brokers[count.index].id
    device_index = 0
  }

  # vpc_security_group_ids = [
  #   aws_security_group.allow_internal.id,
  #   aws_security_group.allow_egress.id,
  #   aws_security_group.broker.id,
  # ]

  root_block_device {
    delete_on_termination = var.broker_delete_root_block_device_on_termination
    volume_size           = 32
  }

  tags = {
    Name = "${var.environment_name}-broker"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# TODO: Need to slice to get first X brokers
locals {
  all_brokers = (var.binpack_zookeeper_brokers ?
    concat(aws_instance.zookeepers, aws_instance.brokers)
    : aws_instance.brokers
  )
}

output "test" {
  value = [for broker in local.all_brokers : broker.id]
}