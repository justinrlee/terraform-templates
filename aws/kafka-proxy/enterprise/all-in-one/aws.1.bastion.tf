# Option bastion host for ssh-ing into kafka-proxy instances

resource "aws_network_interface" "bastion" {
  private_ips = ["${local.public_subnets_f3o[0]}.10"]

  security_groups = [
    aws_security_group.allow_internal.id,
    aws_security_group.bastion.id,
  ]

  subnet_id = local.public_subnets_ids[0]

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

