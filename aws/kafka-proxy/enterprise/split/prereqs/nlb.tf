resource "aws_eip" "nlb" {
    for_each = var.zones
    domain                    = "vpc"

    tags = merge({
            Name = "${var.environment_name}-${var.region_short}-${each.key}-nlb"
        },
    )
}

resource "aws_lb" "main" {
  name               = "${var.environment_name}"
  internal           = false
  load_balancer_type = "network"

  security_groups = [aws_security_group.nlb.id]

  dynamic "subnet_mapping" {
    for_each = var.zones
    content {
      subnet_id = aws_subnet.public[subnet_mapping.key].id
      allocation_id = aws_eip.nlb[subnet_mapping.key].id
    }
  }

  enable_deletion_protection = false
}