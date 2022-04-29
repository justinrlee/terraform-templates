resource "aws_instance" "zookeepers" {
  count                       = var.zookeeper_count
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = var.zookeeper_instance_type
  associate_public_ip_address = true
  key_name                    = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  subnet_id = module.vpc.public_subnets[count.index % 3]

  # TODO: only apply broker security group under certain situations.  Also maybe zookeeper security group
  vpc_security_group_ids = [
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
    aws_security_group.broker.id,
  ]

  root_block_device {
    delete_on_termination = var.zookeeper_delete_root_block_device_on_termination
    volume_size           = 32
  }

  tags = {
    Name = "${var.environment_name}-zookeeper"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}