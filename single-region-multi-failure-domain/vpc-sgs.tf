resource "aws_security_group" "allow_internal" {
  description = "All Single-Region traffic"
  name        = "${var.environment_name}-allow-internal"
  vpc_id      = module.vpc.vpc_id

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
}

resource "aws_security_group" "allow_ssh" {
  description = "SSH Inbound"
  name        = "${var.environment_name}-allow-ssh"
  vpc_id      = module.vpc.vpc_id

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
}

resource "aws_security_group" "allow_egress" {
  description = "All Egress"
  name        = "${var.environment_name}-allow-egress"
  vpc_id      = module.vpc.vpc_id

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
