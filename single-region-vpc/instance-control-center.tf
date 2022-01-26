resource "aws_instance" "control_centers" {
  count                       = var.control_center_counts[0]
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = var.control_center_instance_type
  associate_public_ip_address = var.control_center_public_ip
  key_name                    = var.ec2_public_key_name

  iam_instance_profile = var.iam_instance_profile

  subnet_id                   = var.control_center_public_subnet ? module.vpc.public_subnets[count.index % 3] : module.vpc.private_subnets[count.index % 3]
  vpc_security_group_ids      = var.control_center_public_subnet ? [
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
  ] : [
    aws_security_group.allow_internal.id,
    aws_security_group.allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = var.control_center_delete_root_block_device_on_termination
    volume_size = 32
  }

  tags = {
    Name = "${var.cluster_name}-control-center"
    Provenance = "Single-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
