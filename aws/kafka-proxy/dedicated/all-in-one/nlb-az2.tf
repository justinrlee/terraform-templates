resource "aws_eip" "az2" {
  domain                    = "vpc"

  tags = merge({
    Name = "${var.environment_name}-${var.region_short}-az2-nlb"
    },
  )
}

resource "aws_lb" "az2" {
  name               = "${var.environment_name}-az2"
  internal           = false
  load_balancer_type = "network"

  security_groups = [aws_security_group.nlb.id]
  
  subnet_mapping {
    subnet_id = aws_subnet.public["az2"].id
    allocation_id = aws_eip.az2.id
  }

  enable_deletion_protection = false
}
