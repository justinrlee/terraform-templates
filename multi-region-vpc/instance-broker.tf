resource "aws_instance" "broker_use1" {
  count                       = var.broker_count
  ami                         = lookup(var.aws_amis, "us-east-1")
  instance_type               = var.broker_instance_type
  associate_public_ip_address = var.broker_public_ip
  key_name                    = var.use1_ec2_public_key_name

  subnet_id                   = var.broker_public_subnet ? module.vpc_use1.public_subnets[count.index % 3] : module.vpc_use1.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.broker_public_subnet ? [
    aws_security_group.use1_allow_ssh.id,
    aws_security_group.use1_allow_internal.id,
    aws_security_group.use1_allow_egress.id,
    aws_security_group.use1_broker.id,
  ] : [
    aws_security_group.use1_allow_internal.id,
    aws_security_group.use1_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.broker_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-broker"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.us-east-1
}

resource "aws_instance" "broker_use2" {
  count                       = var.broker_count
  ami                         = lookup(var.aws_amis, "us-east-2")
  instance_type               = var.broker_instance_type
  associate_public_ip_address = var.broker_public_ip
  key_name                    = var.use2_ec2_public_key_name

  subnet_id                   = var.broker_public_subnet ? module.vpc_use2.public_subnets[count.index % 3] : module.vpc_use2.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.broker_public_subnet ? [
    aws_security_group.use2_allow_ssh.id,
    aws_security_group.use2_allow_internal.id,
    aws_security_group.use2_allow_egress.id,
    aws_security_group.use2_broker.id,
  ] : [
    aws_security_group.use2_allow_internal.id,
    aws_security_group.use2_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.broker_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-broker"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.us-east-2
}