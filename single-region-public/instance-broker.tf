locals {
  total_brokers = var.broker_count + var.observer_count

  # If binpacking, only create additional brokers if total brokers is higher than total zookeeper
  distinct_bk = (var.binpack_zookeeper_brokers ?
    max(local.total_brokers - var.zookeeper_count, 0)
  : local.total_brokers)
}

resource "aws_instance" "brokers" {
  count                       = local.distinct_bk
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = var.broker_instance_type
  associate_public_ip_address = true
  key_name                    = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  subnet_id = module.vpc.public_subnets[count.index % 3]

  vpc_security_group_ids = [
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
    aws_security_group.broker.id,
  ]

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