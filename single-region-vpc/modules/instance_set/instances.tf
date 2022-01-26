resource "aws_instance" "instance_r0s" {
  count                       = var.instance_counts[0]
  ami                         = lookup(var.aws_amis, var.regions[0])
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip
  key_name                    = var.ec2_public_key_names[0]
  
  iam_instance_profile = var.iam_instance_profile

  subnet_id                   = var.public_subnet ? var.public_subnets[0][count.index % 3] : var.private_subnets[0][count.index % 3]
  vpc_security_group_ids      = var.public_subnet ? var.public_security_groups[0] : var.private_security_groups[0]
  
  root_block_device {
    delete_on_termination = var.delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-${var.type}-${var.label}"
    Provenance = "Single-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0a
}
