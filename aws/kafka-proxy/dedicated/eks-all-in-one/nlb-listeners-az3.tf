
resource "aws_lb_target_group" "bootstrap_az3" {
  name     = "${var.environment_name}-az3-bs"
  port     = var.nlb_bootstrap_port
  protocol = "TCP"

  target_type = "ip"

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

  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "bootstrap_az3" {
  load_balancer_arn = aws_lb.az3.arn
  port              = var.nlb_bootstrap_port
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_acm_certificate.kafka.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bootstrap_az3.arn
  }
}

locals {
  ports_az3 = [for p in range(
    var.nlb_min_port + local.zone_broker_offsets["az3"],
    var.nlb_min_port + local.zone_broker_offsets["az3"] + var.brokers_per_nlb * 3,
    3,
  ): tostring(p)]
}

resource "aws_lb_target_group" "broker_az3" {
  for_each = toset([for p in range(
      var.nlb_min_port + local.zone_broker_offsets["az3"],
      var.nlb_min_port + local.zone_broker_offsets["az3"] + var.brokers_per_nlb * 3,
      3,
    ): tostring(p)])
  name = "${var.environment_name}-3-${each.key}"
  port = tonumber(each.key)
  protocol = "TCP"

  target_type = "ip"
  
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

  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "broker_az3" {
  for_each = toset([for p in range(
      var.nlb_min_port + local.zone_broker_offsets["az3"],
      var.nlb_min_port + local.zone_broker_offsets["az3"] + var.brokers_per_nlb * 3,
      3,
    ): tostring(p)])

  load_balancer_arn = aws_lb.az3.arn
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_acm_certificate.kafka.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker_az3[each.key].arn
  }
}