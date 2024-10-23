# Security group allowing all internal traffic
# Security group allowing access from home to bastion
# Security group to be assigned to NLB (allowing traffic on all Kafka ports: 9092 - 9243)
# Security group to be assigned to proxy instances (allowing all traffic from NLB SG)

resource "aws_security_group" "allow_internal" {
  description = "All 10.0.0.0/8 traffic"
  name        = "${var.environment_name}-allow-internal"
  vpc_id      = aws_vpc.main.id

  ingress = [{
    description      = null,
    protocol         = "-1",
    cidr_blocks      = ["10.0.0.0/8"],
    from_port        = 0,
    to_port          = 0,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]

  egress = [{
    description      = null,
    protocol         = "-1",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = 0,
    to_port          = 0,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]
}

resource "aws_security_group" "allow_home" {
  description = "All from home"
  name        = "${var.environment_name}-allow-home"
  vpc_id      = aws_vpc.main.id

  ingress = [{
    description = null,
    cidr_blocks = [
      "${var.myip}/32"
    ],
    from_port        = 0,
    to_port          = 0,
    protocol         = "all",
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]
}

resource "aws_security_group" "nlb" {
  description = "security group attached to nlb"
  name        = "${var.environment_name}-nlb"
  vpc_id      = aws_vpc.main.id

  ingress = [{
    description      = null,
    protocol         = "tcp",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = var.min_kafka_port,
    to_port          = var.max_kafka_port,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]

  egress = [{
    description      = null,
    protocol         = "-1",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = 0,
    to_port          = 0,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]
}

resource "aws_security_group" "proxy" {
  description = "target group allow from nlb"
  name        = "${var.environment_name}-allow-nlb"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "proxy" {
  security_group_id = aws_security_group.proxy.id

  ip_protocol = -1
  referenced_security_group_id = aws_security_group.nlb.id
}
