resource "aws_network_acl" "closed_a" {
  vpc_id      = module.vpc.vpc_id

  subnet_ids = [module.vpc.public_subnets[3]]
}

resource "aws_network_acl" "closed_b" {
  vpc_id      = module.vpc.vpc_id

  subnet_ids = [module.vpc.public_subnets[4]]
}

resource "aws_network_acl" "closed_c" {
  vpc_id      = module.vpc.vpc_id

  subnet_ids = [module.vpc.public_subnets[5]]
}

# TODO: Rename to `closed_allow_inbound`
resource "aws_network_acl_rule" "closed_allow_inbound" {
  for_each = {
    "3" = aws_network_acl.closed_a.id, 
    "4" = aws_network_acl.closed_b.id, 
    "5" = aws_network_acl.closed_c.id
  }

  network_acl_id = each.value
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "closed_allow_outbound" {
  for_each = {
    "3" = aws_network_acl.closed_a.id, 
    "4" = aws_network_acl.closed_b.id, 
    "5" = aws_network_acl.closed_c.id
  }

  network_acl_id = each.value
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "closed_allow_inbound_ipv6" {
  for_each = {
    "3" = aws_network_acl.closed_a.id, 
    "4" = aws_network_acl.closed_b.id, 
    "5" = aws_network_acl.closed_c.id
  }

  network_acl_id = each.value
  rule_number    = 101
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  ipv6_cidr_block     = "::/0"
}

resource "aws_network_acl_rule" "closed_allow_outbound_ipv6" {
  for_each = {
    "3" = aws_network_acl.closed_a.id, 
    "4" = aws_network_acl.closed_b.id, 
    "5" = aws_network_acl.closed_c.id
  }
  
  network_acl_id = each.value
  rule_number    = 101
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  ipv6_cidr_block     = "::/0"
}