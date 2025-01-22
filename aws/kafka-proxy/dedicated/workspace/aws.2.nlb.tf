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

# resource "aws_eip" "az4" {
#   domain                    = "vpc"

#   tags = merge({
#     Name = "${var.environment_name}-${var.region_short}-az4-nlb"
#     },
#   )
# }

# resource "aws_lb" "az4" {
#   name               = "${var.environment_name}-az4"
#   internal           = false
#   load_balancer_type = "network"

#   security_groups = [aws_security_group.nlb.id]

#   subnet_mapping {
#     subnet_id = aws_subnet.public["az4"].id
#     allocation_id = aws_eip.az4.id
#   }

#   enable_deletion_protection = false
# }
