# Option bastion host for ssh-ing into kafka-proxy instances

resource "aws_network_interface" "bastion" {
  private_ips = [cidrhost(aws_subnet.public["az1"].cidr_block, 10)]

  security_groups = [
    aws_security_group.allow_internal.id,
    aws_security_group.bastion.id,
  ]

  subnet_id = aws_subnet.public["az1"].id

  tags = {
    Name = "${var.environment_name}-bastion"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_instance" "bastion" {
  ami           = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  key_name      = var.bastion_public_key_name

  network_interface {
    network_interface_id = aws_network_interface.bastion.id
    device_index         = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.bastion_volume_size

    tags = {
      Name = "${var.environment_name}-bastion"
    }
  }

  tags = {
    Name = "${var.environment_name}-bastion"
  }
}

