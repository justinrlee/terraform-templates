resource "aws_network_interface" "kafka_closed_a" {
  count = var.kafka_closed_counts[0]

  private_ips = [
    "${var.prefix}.${var.zones[0] + 20}.${150 + count.index}"
    # closed zone: 20 + zone
    # ip: closed kafka start with 150
  ]

  security_groups = concat(
    [
      aws_security_group.allow_ssh.id,
      aws_security_group.allow_internal.id,
      aws_security_group.allow_egress.id,
    ],
  )

  subnet_id = module.vpc.public_subnets[3]

  tags = {
    Name = "${var.environment_name}-kafka-closed-a"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_eip" "kafka_closed_a" {
  count = var.kafka_closed_counts[0]

  domain            = "vpc"
  network_interface = aws_network_interface.kafka_closed_a[count.index].id
}

resource "aws_instance" "kafka_closed_a" {
  count = var.kafka_closed_counts[0]

  ami           = lookup(var.aws_amis, var.region)
  instance_type = var.broker_instance_type
  key_name      = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  network_interface {
    network_interface_id = aws_network_interface.kafka_closed_a[count.index].id
    device_index         = 0
  }

  root_block_device {
    delete_on_termination = var.broker_delete_root_block_device_on_termination
    volume_size           = 32
  }

  tags = {
    Name = "${var.environment_name}-kafka-closed-a"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

output "kafka_closed_a" {
  value = {
    public_ip   = aws_instance.kafka_closed_a.*.public_ip,
    private_ip  = aws_instance.kafka_closed_a.*.private_ip,
    public_dns  = aws_instance.kafka_closed_a.*.public_dns,
    private_dns = aws_instance.kafka_closed_a.*.private_dns,
  }
}
