resource "aws_eip" "az1_b" {
  domain                    = "vpc"
}

resource "aws_lb" "az1_b" {
  name               = "${var.environment_name}-az1-b"
  internal           = false
  load_balancer_type = "network"

  security_groups = [aws_security_group.nlb.id]
  
  subnet_mapping {
    subnet_id = aws_subnet.public["az1"].id
    allocation_id = aws_eip.az1_b.id
  }

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "bootstrap_az1_b" {
  name     = "${var.environment_name}-az1-b-bs"
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

# resource "aws_lb_target_group_attachment" "bootstrap_az1_b" {
#   for_each = toset(var.zone_instances["az1"])

#   target_group_arn = aws_lb_target_group.bootstrap_az1_b.arn
#   target_id        = each.key
# }

resource "aws_lb_listener" "bootstrap_az1_b" {
  load_balancer_arn = aws_lb.az1_b.arn
  port              = 9092
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bootstrap_az1_b.arn
  }
}

locals {
  ports_az1_b = [for p in range(
    var.port_broker_start + var.zone_broker_offsets["az1_b"],
    var.port_broker_start + var.zone_broker_offsets["az1_b"] + var.brokers_per_nlb * 6,
    6,
  ): tostring(p)]

  # port_instance_az1_b = setproduct(local.ports_az1_b, var.zone_instances["az1"])

  # port_instance_az1_b_map = {
  #   for index, port_instance in local.port_instance_az1_b:
  #     "${port_instance[0]}-${port_instance[1]}" => port_instance
  # }
}

resource "aws_lb_target_group" "broker_az1_b" {
  for_each = toset(local.ports_az1_b)
  name = "${var.environment_name}-az1-b-${each.key}"
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

resource "aws_lb_listener" "broker_az1_b" {
  for_each = toset(local.ports_az1_b)

  load_balancer_arn = aws_lb.az1_b.arn
  port              = tonumber(each.key)
  protocol          = "TLS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.broker_az1_b[each.key].arn
  }
}