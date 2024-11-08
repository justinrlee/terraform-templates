resource "aws_eip" "az2" {
  domain                    = "vpc"

  tags = merge({
    Name = "${var.environment_name}-${var.region_short}-az2-nlb"
    },
  )
}

resource "aws_lb" "az2" {
  name               = "${var.environment_name}-az2"
  internal           = false
  load_balancer_type = "network"

  security_groups = [aws_security_group.nlb.id]
  
  subnet_mapping {
    subnet_id = aws_subnet.public["az2"].id
    allocation_id = aws_eip.az2.id
  }

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "bootstrap_az2" {
  name     = "${var.environment_name}-az2-bs"
  port     = 9092
  protocol = "TCP"

  health_check {
    enabled = true

    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5

    port     = 9080
    protocol = "HTTP"
    path     = "/health"
    matcher  = 200
  }

  vpc_id = aws_vpc.main.id
}

# resource "aws_lb_target_group_attachment" "bootstrap_az2" {
#   for_each = toset(var.zone_instances["az2"])

#   target_group_arn = aws_lb_target_group.bootstrap_az2.arn
#   target_id        = each.key
# }

resource "aws_lb_listener" "bootstrap_az2" {
  load_balancer_arn = aws_lb.az2.arn
  port              = 9092
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bootstrap_az2.arn
  }
}

locals {
  ports_az2 = [for p in range(
    var.port_broker_start + var.zone_broker_offsets["az2"],
    var.port_broker_start + var.zone_broker_offsets["az2"] + var.brokers_per_nlb * 3,
    3,
  ): tostring(p)]

  # port_instance_az2 = setproduct(local.ports_az2, var.zone_instances["az2"])

  # port_instance_az2_map = {
  #   for index, port_instance in local.port_instance_az2:
  #     "${port_instance[0]}-${port_instance[1]}" => port_instance
  # }
}

resource "aws_lb_target_group" "broker_az2" {
  for_each = toset(local.ports_az2)
  name = "${var.environment_name}-az2-${each.key}"
  port = tonumber(each.key)
  protocol = "TCP"

  health_check {
    enabled = true

    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5

    port     = 9080
    protocol = "HTTP"
    path     = "/health"
    matcher  = 200
  }

  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "broker_az2" {
  for_each = toset(local.ports_az2)

  load_balancer_arn = aws_lb.az2.arn
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker_az2[each.key].arn
  }
}