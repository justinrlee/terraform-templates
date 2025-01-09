resource "aws_lb_target_group" "bootstrap" {
  name     = "${var.environment_name}-bs"
  port     = var.port_bootstrap
  protocol = "TCP"

  connection_termination = true
  deregistration_delay = 30

  stickiness {
    enabled = true
    type = "source_ip"
  }

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

resource "aws_lb_listener" "bootstrap" {
  load_balancer_arn = var.nlb_arn
  port              = var.port_bootstrap
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bootstrap.arn
  }
}

locals {
  port_range = [for p in range(
    var.port_broker_start,
    var.port_broker_start + var.brokers_per_nlb,
  ): tostring(p)]
}

resource "aws_lb_target_group" "broker" {
  for_each = toset(local.port_range)
  name = "${var.environment_name}-${each.key}"
  port = tonumber(each.key)
  protocol = "TCP"

  connection_termination = true
  deregistration_delay = 30

  stickiness {
    enabled = true
    type = "source_ip"
  }


  health_check {
    enabled = true

    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5

    # port     = 9080
    protocol = "TCP"
    # path     = "/health"
    # matcher  = null
  }

  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "broker" {
  for_each = toset(local.port_range)

  load_balancer_arn = var.nlb_arn
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker[each.key].arn
  }
}