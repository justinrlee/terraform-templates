resource "aws_lb_target_group" "bootstrap_az3" {
  name     = "${var.environment_name}-az3-bs"
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

# resource "aws_lb_target_group_attachment" "bootstrap_az3" {
#   for_each = toset(var.zone_instances["az3"])

#   target_group_arn = aws_lb_target_group.bootstrap_az3.arn
#   target_id        = each.key
# }

resource "aws_lb_listener" "bootstrap_az3" {
  load_balancer_arn = aws_lb.az3.arn
  port              = 9092
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

  # port_instance_az3 = setproduct(local.ports_az3, var.zone_instances["az3"])

  # port_instance_az3_map = {
  #   for index, port_instance in local.port_instance_az3:
  #     "${port_instance[0]}-${port_instance[1]}" => port_instance
  # }
}

resource "aws_lb_target_group" "broker_az3" {
  for_each = toset(local.ports_az3)
  name = "${var.environment_name}-az3-${each.key}"
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

resource "aws_lb_listener" "broker_az3" {
  for_each = toset(local.ports_az3)

  load_balancer_arn = aws_lb.az3.arn
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker_az3[each.key].arn
  }
}
