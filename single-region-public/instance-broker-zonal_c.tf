resource "aws_network_interface" "interfaces_zone_c" {
  count = var.zonal_broker_count

  private_ips = ["${var.prefix}.${var.zones[2]}.${100 + count.index}"]

  security_groups = [
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
    aws_security_group.broker.id,
  ]

  subnet_id = module.vpc.public_subnets[2]

  tags = {
    Name = "${var.environment_name}-if"
  }
}

resource "aws_instance" "brokers_zone_c" {
  count                       = var.zonal_broker_count
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = var.broker_instance_type
  key_name                    = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  network_interface {
    network_interface_id = aws_network_interface.interfaces_zone_c[count.index].id
    device_index = 0
  }

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