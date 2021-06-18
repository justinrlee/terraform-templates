resource "aws_instance" "bastion" {
  # count                       = var.worker_count
  ami                         = lookup(var.aws_amis, "us-east-1")
  instance_type               = var.bastion_instance_type
  associate_public_ip_address = var.bastion_public_ip
  key_name                    = var.use1_ec2_public_key_name

  subnet_id                   = var.bastion_public_subnet ? module.vpc_use1.public_subnets[2] : module.vpc_use1.private_subnets[2]

  vpc_security_group_ids      = [
    aws_security_group.use1_allow_ssh.id,
    aws_security_group.use1_allow_internal.id,
    aws_security_group.use1_allow_egress.id,
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

  provider = aws.us-east-1
}