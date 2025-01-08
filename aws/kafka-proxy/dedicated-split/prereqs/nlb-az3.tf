resource "aws_eip" "az3" {
  domain                    = "vpc"

  tags = merge({
    Name = "${var.environment_name}-${var.region_short}-az3-nlb"
    },
  )
}

resource "aws_lb" "az3" {
  name               = "${var.environment_name}-az3"
  internal           = false
  load_balancer_type = "network"

  security_groups = [aws_security_group.nlb.id]

  subnet_mapping {
    subnet_id = aws_subnet.public["az3"].id
    allocation_id = aws_eip.az3.id
  }

  enable_deletion_protection = false
}