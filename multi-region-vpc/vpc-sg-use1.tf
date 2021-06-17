resource "aws_security_group" "use1_allow_internal" {
  description = "All multi-region traffic"
  name        = "${var.cluster_name}-allow-internal"
  vpc_id      = module.vpc_use1.vpc_id

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
    cidr_blocks      = ["10.0.0.0/8"],
    from_port        = 0,
    to_port          = 0,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]

  provider = aws.us-east-1
}

resource "aws_security_group" "use1_allow_ssh" {
  description = "SSH Inbound"
  name        = "${var.cluster_name}-allow-ssh"
  vpc_id      = module.vpc_use1.vpc_id

  ingress = [{
    description      = null,
    protocol         = "tcp",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = 22,
    to_port          = 22,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]
  
  provider = aws.us-east-1
}

resource "aws_security_group" "use1_allow_egress" {
  description = "All Egress"
  name        = "${var.cluster_name}-allow-egress"
  vpc_id      = module.vpc_use1.vpc_id

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
  
  provider = aws.us-east-1
}

resource "aws_security_group" "use1_broker" {
  description = "Broker Inbound"
  name        = "${var.cluster_name}-broker"
  vpc_id      = module.vpc_use1.vpc_id

  ingress = [{
    description      = null,
    protocol         = "tcp",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = 9092,
    to_port          = 9092,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]
  
  provider = aws.us-east-1
}