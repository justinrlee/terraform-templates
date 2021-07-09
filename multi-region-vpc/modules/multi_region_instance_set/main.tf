resource "aws_instance" "instance_r0s" {
  count                       = var.instance_counts[0]
  ami                         = lookup(var.aws_amis, var.regions[0])
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip
  key_name                    = var.ec2_public_key_names[0]

  subnet_id                   = var.public_subnet ? var.public_subnets[0][count.index % 3] : var.private_subnets[0][count.index % 3]
  vpc_security_group_ids      = var.public_subnet ? var.public_security_groups[0] : var.private_security_groups[0]
  
  root_block_device {
    delete_on_termination = var.delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-${var.type}-${var.label}"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0a
}

resource "aws_instance" "instance_r1s" {
  count                       = var.instance_counts[1]
  ami                         = lookup(var.aws_amis, var.regions[1])
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip
  key_name                    = var.ec2_public_key_names[1]

  subnet_id                   = var.public_subnet ? var.public_subnets[1][count.index % 3] : var.private_subnets[1][count.index % 3]
  vpc_security_group_ids      = var.public_subnet ? var.public_security_groups[1] : var.private_security_groups[1]
  
  root_block_device {
    delete_on_termination = var.delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-${var.type}-${var.label}"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r1a
}

resource "aws_instance" "instance_r2s" {
  count                       = var.instance_counts[2]
  ami                         = lookup(var.aws_amis, var.regions[2])
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip
  key_name                    = var.ec2_public_key_names[2]

  subnet_id                   = var.public_subnet ? var.public_subnets[2][count.index % 3] : var.private_subnets[2][count.index % 3]
  vpc_security_group_ids      = var.public_subnet ? var.public_security_groups[2] : var.private_security_groups[2]
  
  root_block_device {
    delete_on_termination = var.delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-${var.type}-${var.label}"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r2a
}
