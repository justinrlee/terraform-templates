resource "aws_instance" "brokers_r0s" {
  count                       = var.broker_counts[0] + var.observer_counts[0]
  ami                         = lookup(var.aws_amis, var.regions[0])
  instance_type               = var.broker_instance_type
  associate_public_ip_address = var.broker_public_ip
  key_name                    = var.ec2_public_key_names[0]

  iam_instance_profile = var.iam_instance_profile

  subnet_id                   = var.broker_public_subnet ? module.vpc_r0s.public_subnets[count.index % 3] : module.vpc_r0s.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.broker_public_subnet ? [
    aws_security_group.r0s_allow_internal.id,
    aws_security_group.r0s_allow_egress.id,
    aws_security_group.r0s_allow_broker.id,
  ] : [
    aws_security_group.r0s_allow_internal.id,
    aws_security_group.r0s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.broker_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-broker"
    Provenance = "Single-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0a
}