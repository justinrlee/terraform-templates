
resource "aws_lb_target_group" "bootstrap_az1" {
  name     = "${var.environment_name}-az1-bs"
  port     = var.port_bootstrap
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

  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "bootstrap_az1" {
  load_balancer_arn = var.zone_nlb_mappings["az1"]
  port              = var.port_bootstrap
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bootstrap_az1.arn
  }
}

locals {
  ports_az1 = [for p in range(
    var.port_broker_start + var.zone_broker_offsets["az1"],
    var.port_broker_start + var.zone_broker_offsets["az1"] + var.brokers_per_nlb * 3,
    3,
  ): tostring(p)]
}

resource "aws_lb_target_group" "broker_az1" {
  for_each = toset(local.ports_az1)
  name = "${var.environment_name}-az1-${each.key}"
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

  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "broker_az1" {
  for_each = toset(local.ports_az1)

  load_balancer_arn = var.zone_nlb_mappings["az1"]
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker_az1[each.key].arn
  }
}