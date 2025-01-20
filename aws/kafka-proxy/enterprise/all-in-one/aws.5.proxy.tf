resource "aws_security_group" "proxy" {
  description = "allow traffic from NLB to proxy"
  name        = "${var.environment_name}-allow-nlb"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "proxy" {
  security_group_id = aws_security_group.proxy.id

  ip_protocol = -1
  referenced_security_group_id = aws_security_group.nlb.id
}


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

  key_name = var.proxy_public_key_name

  vpc_security_group_ids = [
    aws_security_group.allow_internal.id,
    aws_security_group.proxy.id,
  ]

  update_default_version = true

  user_data = base64encode(local.userdata)
}

resource "aws_autoscaling_group" "proxy" {
  name_prefix = "${var.environment_name}-proxy"

  min_size = var.proxy_count_min
  desired_capacity = var.proxy_count_desired
  max_size = var.proxy_count_max

  launch_template {
    id = aws_launch_template.proxy.id
    version = "$Latest"
  }

  # Proxies go in the private subnets
  vpc_zone_identifier = [
    for aws_subnet in aws_subnet.private : aws_subnet.id
  ]

  target_group_arns = concat(
    [aws_lb_target_group.bootstrap.id],
    [for k, v in aws_lb_target_group.broker: v.id],
  )

  tag {
    key = "Name"
    value = "${var.environment_name}-proxy"
    propagate_at_launch = true
  }
}