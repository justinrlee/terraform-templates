resource "aws_network_interface" "bastions" {
  count = var.bastion_count

  private_ips = [
    "${var.prefix}.${var.zones[0] + 10}.${10 + count.index}"
    # prefix (10.2)
    # zone (first zone: 10 + zone number)
    # ip: bastions start with 10 (10)
    # 10.2.12.10
  ]

  security_groups = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
  ]

  subnet_id = module.vpc.public_subnets[0] #TBD

  tags = {
    Name = "${var.environment_name}-bastion"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_eip" "bastions" {
  count = var.bastion_count

  domain            = "vpc"
  network_interface = aws_network_interface.bastions[count.index].id
}

resource "aws_instance" "bastions" {
  count         = var.bastion_count
  
  ami           = lookup(var.aws_amis, var.region)
  instance_type = var.bastion_instance_type
  key_name = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  network_interface {
    network_interface_id = aws_network_interface.bastions[count.index].id
    device_index         = 0
  }

  root_block_device {
    delete_on_termination = var.bastion_delete_root_block_device_on_termination
    volume_size           = 32
  }

  tags = {
    Name = "${var.environment_name}-bastion"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

output "bastion" {
  value = {
    public_ip   = aws_instance.bastions.*.public_ip,
    private_ip  = aws_instance.bastions.*.private_ip,
    public_dns  = aws_instance.bastions.*.public_dns,
    private_dns = aws_instance.bastions.*.private_dns,
  }
}