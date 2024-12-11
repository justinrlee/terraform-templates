
resource "aws_lb_target_group" "bootstrap_az3" {
  name     = "${var.environment_name}-az3-bs"
  port     = var.port_bootstrap
  protocol = "TCP"

#   health_check {
#     enabled = true

#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 2
#     interval            = 5

#     port     = 9080
#     protocol = "HTTP"
#     path     = "/health"
#     matcher  = 200
#   }

  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "bootstrap_az3" {
  load_balancer_arn = var.zone_nlb_mappings["az3"]
  port              = var.port_bootstrap
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bootstrap_az3.arn
  }
}

locals {
  ports_az3 = [for p in range(
    var.port_broker_start + var.zone_broker_offsets["az3"],
    var.port_broker_start + var.zone_broker_offsets["az3"] + var.brokers_per_nlb * 3,
    3,
  ): tostring(p)]
}

resource "aws_lb_target_group" "broker_az3" {
  for_each = toset(local.ports_az3)
  name = "${var.environment_name}-az3-${each.key}"
  port = tonumber(each.key)
  protocol = "TCP"

#   health_check {
#     enabled = true

#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 2
#     interval            = 5

#     port     = 9080
#     protocol = "HTTP"
#     path     = "/health"
#     matcher  = 200
#   }

  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "broker_az3" {
  for_each = toset(local.ports_az3)

  load_balancer_arn = var.zone_nlb_mappings["az3"]
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker_az3[each.key].arn
  }
}