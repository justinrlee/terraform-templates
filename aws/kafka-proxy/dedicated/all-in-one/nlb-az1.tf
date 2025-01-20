resource "aws_eip" "az1" {
  domain                    = "vpc"

  tags = merge({
    Name = "${var.environment_name}-${var.region_short}-az1-nlb"
    },
  )
}

resource "aws_lb" "az1" {
  name               = "${var.environment_name}-az1"
  internal           = false
  load_balancer_type = "network"

  security_groups = [aws_security_group.nlb.id]

  subnet_mapping {
    subnet_id = aws_subnet.public["az1"].id
    allocation_id = aws_eip.az1.id
  }

  enable_deletion_protection = false
}
