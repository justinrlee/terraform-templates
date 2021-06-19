resource "aws_instance" "zk_r1s" {
  count                       = var.zookeeper_counts[0]
  ami                         = lookup(var.aws_amis, var.r1)
  instance_type               = var.zookeeper_instance_type
  associate_public_ip_address = var.zookeeper_public_ip
  key_name                    = var.r1s_ec2_public_key_name

  subnet_id                   = var.zookeeper_public_subnet ? module.vpc_r1s.public_subnets[count.index % 3] : module.vpc_r1s.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.zookeeper_public_subnet ? [
    aws_security_group.r1s_allow_internal.id,
    aws_security_group.r1s_allow_egress.id,
  ] : [
    aws_security_group.r1s_allow_internal.id,
    aws_security_group.r1s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.zookeeper_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-zookeeper"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r1a
}

resource "aws_instance" "zk_r2s" {
  count                       = var.zookeeper_counts[1]
  ami                         = lookup(var.aws_amis, var.r2)
  instance_type               = var.zookeeper_instance_type
  associate_public_ip_address = var.zookeeper_public_ip
  key_name                    = var.r2s_ec2_public_key_name

  subnet_id                   = var.zookeeper_public_subnet ? module.vpc_r2s.public_subnets[count.index % 3] : module.vpc_r2s.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.zookeeper_public_subnet ? [
    aws_security_group.r2s_allow_internal.id,
    aws_security_group.r2s_allow_egress.id,
  ] : [
    aws_security_group.r2s_allow_internal.id,
    aws_security_group.r2s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.zookeeper_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-zookeeper"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r2a
}

resource "aws_instance" "zk_r3s" {
  count                       = var.zookeeper_counts[2]
  ami                         = lookup(var.aws_amis, var.r3)
  instance_type               = var.zookeeper_instance_type
  associate_public_ip_address = var.zookeeper_public_ip
  key_name                    = var.r3s_ec2_public_key_name

  subnet_id                   = var.zookeeper_public_subnet ? module.vpc_r3s.public_subnets[count.index % 3] : module.vpc_r3s.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.zookeeper_public_subnet ? [
    aws_security_group.r3s_allow_internal.id,
    aws_security_group.r3s_allow_egress.id,
  ] : [
    aws_security_group.r3s_allow_internal.id,
    aws_security_group.r3s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.zookeeper_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-zookeeper"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r3a
}