resource "aws_instance" "bastions" {
  count                       = var.bastion_count
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = var.bastion_instance_type
  associate_public_ip_address = true
  key_name                    = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  subnet_id = module.vpc.public_subnets[count.index % 3]

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
    aws_security_group.control_center.id,
  ]

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