resource "aws_instance" "bastion_r0s" {
  count                       = var.bastion_counts[0]
  ami                         = lookup(var.aws_amis, var.regions[0])
  instance_type               = var.bastion_instance_type
  associate_public_ip_address = var.bastion_public_ip
  key_name                    = var.ec2_public_key_names[0]

  subnet_id                   = var.bastion_public_subnet ? module.vpc_r0s.public_subnets[count.index % 3] : module.vpc_r0s.private_subnets[count.index % 3]

  vpc_security_group_ids      = [
    aws_security_group.r0s_allow_ssh.id,
    aws_security_group.r0s_allow_internal.id,
    aws_security_group.r0s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.bastion_delete_root_block_device_on_termination
    volume_size = 16
  }

  tags = {
    Name = "${var.cluster_name}-bastion"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0a
}