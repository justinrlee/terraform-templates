resource "aws_instance" "schema_registry_r0s" {
  count                       = var.schema_registry_counts[0]
  ami                         = lookup(var.aws_amis, var.regions[0])
  instance_type               = var.schema_registry_instance_type
  associate_public_ip_address = var.schema_registry_public_ip
  key_name                    = var.ec2_public_key_names[0]

  subnet_id                   = var.schema_registry_public_subnet ? module.vpc_r0s.public_subnets[count.index % 3] : module.vpc_r0s.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.schema_registry_public_subnet ? [
    aws_security_group.r0s_allow_internal.id,
    aws_security_group.r0s_allow_egress.id,
  ] : [
    aws_security_group.r0s_allow_internal.id,
    aws_security_group.r0s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.schema_registry_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-schema-registry"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0a
}

resource "aws_instance" "schema_registry_r1s" {
  count                       = var.schema_registry_counts[1]
  ami                         = lookup(var.aws_amis, var.regions[1])
  instance_type               = var.schema_registry_instance_type
  associate_public_ip_address = var.schema_registry_public_ip
  key_name                    = var.ec2_public_key_names[1]

  subnet_id                   = var.schema_registry_public_subnet ? module.vpc_r1s.public_subnets[count.index % 3] : module.vpc_r1s.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.schema_registry_public_subnet ? [
    aws_security_group.r1s_allow_internal.id,
    aws_security_group.r1s_allow_egress.id,
  ] : [
    aws_security_group.r1s_allow_internal.id,
    aws_security_group.r1s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.schema_registry_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-schema-registry"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r1a
}

resource "aws_instance" "schema_registry_r2s" {
  count                       = var.schema_registry_counts[2]
  ami                         = lookup(var.aws_amis, var.regions[2])
  instance_type               = var.schema_registry_instance_type
  associate_public_ip_address = var.schema_registry_public_ip
  key_name                    = var.ec2_public_key_names[2]

  subnet_id                   = var.schema_registry_public_subnet ? module.vpc_r2s.public_subnets[count.index % 3] : module.vpc_r2s.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.schema_registry_public_subnet ? [
    aws_security_group.r2s_allow_internal.id,
    aws_security_group.r2s_allow_egress.id,
  ] : [
    aws_security_group.r2s_allow_internal.id,
    aws_security_group.r2s_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.schema_registry_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-schema-registry"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r2a
}