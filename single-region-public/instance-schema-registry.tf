resource "aws_instance" "schema_registries" {
  count                       = var.schema_registry_count
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = var.schema_registry_instance_type
  associate_public_ip_address = true
  key_name                    = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  subnet_id = module.vpc.public_subnets[count.index % 3]

  # TODO: schema registry security group
  vpc_security_group_ids = [
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
  ]

  root_block_device {
    delete_on_termination = var.schema_registry_delete_root_block_device_on_termination
    volume_size           = 32
  }

  tags = {
    Name = "${var.environment_name}-schema-registry"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
