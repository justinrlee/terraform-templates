# Create a single launch template, which is just an Ubuntu instance that downloads kafka-proxy and then starts it with userdata
resource "aws_launch_template" "proxy" {
  name_prefix = "${var.environment_name}-proxy"

  ebs_optimized = true

  image_id = var.proxy_ami_id
  instance_type = var.proxy_instance_type
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.proxy_volume_size
    }
  }

  key_name = var.proxy_ec2_public_key_name

  vpc_security_group_ids = [
    var.internal_security_group_id,
    aws_security_group.proxy.id,
  ]

  update_default_version = true

  user_data = base64encode(local.userdata)
}

resource "aws_autoscaling_group" "proxy" {
  name_prefix = "${var.environment_name}-proxy"

  min_size = 2
  desired_capacity = 6
  max_size = 12

  launch_template {
    id = aws_launch_template.proxy.id
    version = "$Latest"
  }

  vpc_zone_identifier = [for k, v in var.zone_private_subnet_mappings: v]

  target_group_arns = concat(
    [aws_lb_target_group.bootstrap.id],
    [for k, v in aws_lb_target_group.broker: v.id],
  )
}