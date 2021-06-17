resource "aws_instance" "zk_use1" {
  # count                       = var.worker_count
  ami                         = lookup(var.aws_amis, "us-east-1")
  instance_type               = var.zookeeper_instance_type
  associate_public_ip_address = var.zookeeper_public
  key_name                    = var.use1_ec2_public_key_name

  subnet_id                   = var.zookeeper_public ? module.vpc_use1.public_subnets[0] : module.vpc_use1.private_subnets[0]
  vpc_security_group_ids      = var.zookeeper_public ? [
    aws_security_group.use1_allow_ssh.id,
    aws_security_group.use1_allow_internal.id,
    aws_security_group.use1_allow_egress.id,
  ] : [
    aws_security_group.use1_allow_internal.id,
    aws_security_group.use1_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.worker_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-zookeeper"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.us-east-1
}

resource "aws_instance" "zk_use2" {
  # count                       = var.worker_count
  ami                         = lookup(var.aws_amis, "us-east-2")
  instance_type               = var.zookeeper_instance_type
  associate_public_ip_address = var.zookeeper_public
  key_name                    = var.use2_ec2_public_key_name

  subnet_id                   = var.zookeeper_public ? module.vpc_use2.public_subnets[0] : module.vpc_use2.private_subnets[0]
  vpc_security_group_ids      = var.zookeeper_public ? [
    aws_security_group.use2_allow_ssh.id,
    aws_security_group.use2_allow_internal.id,
    aws_security_group.use2_allow_egress.id,
  ] : [
    aws_security_group.use2_allow_internal.id,
    aws_security_group.use2_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.worker_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-zookeeper"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.us-east-2
}

resource "aws_instance" "zk_usw2" {
  # count                       = var.worker_count
  ami                         = lookup(var.aws_amis, "us-west-2")
  instance_type               = var.zookeeper_instance_type
  associate_public_ip_address = var.zookeeper_public
  key_name                    = var.usw2_ec2_public_key_name

  subnet_id                   = var.zookeeper_public ? module.vpc_usw2.public_subnets[0] : module.vpc_usw2.private_subnets[0]
  vpc_security_group_ids      = var.zookeeper_public ? [
    aws_security_group.usw2_allow_ssh.id,
    aws_security_group.usw2_allow_internal.id,
    aws_security_group.usw2_allow_egress.id,
  ] : [
    aws_security_group.usw2_allow_internal.id,
    aws_security_group.usw2_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.worker_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-zookeeper"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.us-west-2
}