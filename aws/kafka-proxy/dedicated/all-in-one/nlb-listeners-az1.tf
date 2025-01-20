resource "aws_lb_target_group" "bootstrap_az1" {
  name     = "${var.environment_name}-az1-bs"
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

# resource "aws_lb_target_group_attachment" "bootstrap_az1" {
#   for_each = toset(var.zone_instances["az1"])

#   target_group_arn = aws_lb_target_group.bootstrap_az1.arn
#   target_id        = each.key
# }

resource "aws_lb_listener" "bootstrap_az1" {
  load_balancer_arn = aws_lb.az1.arn
  port              = 9092
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

  # port_instance_az1 = setproduct(local.ports_az1, var.zone_instances["az1"])

  # port_instance_az1_map = {
  #   for index, port_instance in local.port_instance_az1:
  #     "${port_instance[0]}-${port_instance[1]}" => port_instance
  # }
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

  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "broker_az1" {
  for_each = toset(local.ports_az1)

  load_balancer_arn = aws_lb.az1.arn
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker_az1[each.key].arn
  }
}
