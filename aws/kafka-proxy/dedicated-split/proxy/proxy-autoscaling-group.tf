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

  # user_data = base64encode(local.userdata)
}

resource "aws_autoscaling_group" "proxy_az1" {
  name_prefix = "${var.environment_name}-proxy-az1"

  min_size = 2
  desired_capacity = 2
  max_size = 3

  launch_template {
    id = aws_launch_template.proxy.id
    version = "$Latest"
  }

  vpc_zone_identifier = [var.zone_private_subnet_mappings["az1"]]

  target_group_arns = concat(
    [aws_lb_target_group.bootstrap_az1.id],
    [for k, v in aws_lb_target_group.broker_az1: v.id],
  )
}

resource "aws_autoscaling_group" "proxy_az2" {
  name_prefix = "${var.environment_name}-proxy-az2"

  min_size = 2
  desired_capacity = 2
  max_size = 3

  launch_template {
    id = aws_launch_template.proxy.id
    version = "$Latest"
  }

  vpc_zone_identifier = [var.zone_private_subnet_mappings["az2"]]

  target_group_arns = concat(
    [aws_lb_target_group.bootstrap_az2.id],
    [for k, v in aws_lb_target_group.broker_az2: v.id],
  )
}

resource "aws_autoscaling_group" "proxy_az3" {
  name_prefix = "${var.environment_name}-proxy-az3"

  min_size = 2
  desired_capacity = 2
  max_size = 3

  launch_template {
    id = aws_launch_template.proxy.id
    version = "$Latest"
  }

  vpc_zone_identifier = [var.zone_private_subnet_mappings["az3"]]

  target_group_arns = concat(
    [aws_lb_target_group.bootstrap_az3.id],
    [for k, v in aws_lb_target_group.broker_az3: v.id],
  )
}