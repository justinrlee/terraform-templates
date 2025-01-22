# Security group allowing all internal traffic
# Security group allowing access from home to bastion
# Security group to be assigned to NLB

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

resource "aws_security_group" "bastion" {
  description = "Bastion"
  name        = "${var.environment_name}-bastion-ingress"
  vpc_id      = aws_vpc.main.id

  ingress = [{
    description = null,
    cidr_blocks = var.bastion_allowed_ranges
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

  ingress = [
    {
      description      = null,
      protocol         = "tcp",
      cidr_blocks      = ["0.0.0.0/0"],
      from_port        = var.nlb_bootstrap_port,
      to_port          = var.nlb_bootstrap_port,
      ipv6_cidr_blocks = null,
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null
    },
    {
      description      = null,
      protocol         = "tcp",
      cidr_blocks      = ["0.0.0.0/0"],
      from_port        = var.nlb_min_port,
      to_port          = var.nlb_max_port,
      ipv6_cidr_blocks = null,
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null
    },
  ]

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