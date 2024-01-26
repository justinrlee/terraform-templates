resource "aws_network_acl_rule" "deny_ab" {
  # Used to create both an ingress and egress rule
  for_each = var.deny_ab ? {
    "a_from_b_ingress" = {
      acl_id = aws_network_acl.closed_a.id
      rule_number = 50
      cidr_block = "${var.prefix}.${20 + var.zones[1]}.0/24"
      egress = false
    },
    "a_from_b_egress" = {
      acl_id = aws_network_acl.closed_a.id
      rule_number = 50
      cidr_block = "${var.prefix}.${20 + var.zones[1]}.0/24"
      egress = true
    },
    "b_from_a_ingress" = {
      acl_id = aws_network_acl.closed_b.id
      rule_number = 50
      cidr_block = "${var.prefix}.${20 + var.zones[0]}.0/24"
      egress = false
    },
    "b_from_a_egress" = {
      acl_id = aws_network_acl.closed_b.id
      rule_number = 50
      cidr_block = "${var.prefix}.${20 + var.zones[0]}.0/24"
      egress = true
    },
  } : {}

  network_acl_id = each.value.acl_id
  rule_number    = each.value.rule_number
  egress         = each.value.egress
  cidr_block     = each.value.cidr_block

  protocol       = -1
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "deny_bc" {
  # Used to create both an ingress and egress rule
  for_each = var.deny_bc ? {
    "b_from_c_ingress" = {
      acl_id = aws_network_acl.closed_b.id
      rule_number = 51
      cidr_block = "${var.prefix}.${20 + var.zones[2]}.0/24"
      egress = false
    },
    "b_from_c_egress" = {
      acl_id = aws_network_acl.closed_b.id
      rule_number = 51
      cidr_block = "${var.prefix}.${20 + var.zones[2]}.0/24"
      egress = true
    },
    "c_from_b_ingress" = {
      acl_id = aws_network_acl.closed_c.id
      rule_number = 51
      cidr_block = "${var.prefix}.${20 + var.zones[1]}.0/24"
      egress = false
    },
    "c_from_b_egress" = {
      acl_id = aws_network_acl.closed_c.id
      rule_number = 51
      cidr_block = "${var.prefix}.${20 + var.zones[1]}.0/24"
      egress = true
    },
  } : {}

  network_acl_id = each.value.acl_id
  rule_number    = each.value.rule_number
  egress         = each.value.egress
  cidr_block     = each.value.cidr_block

  protocol       = -1
  rule_action    = "deny"
}

resource "aws_network_acl_rule" "deny_ac" {
  # Used to create both an ingress and egress rule
  for_each = var.deny_ac ? {
    "a_from_c_ingress" = {
      acl_id = aws_network_acl.closed_a.id
      rule_number = 52
      cidr_block = "${var.prefix}.${20 + var.zones[2]}.0/24"
      egress = false
    },
    "a_from_c_egress" = {
      acl_id = aws_network_acl.closed_a.id
      rule_number = 52
      cidr_block = "${var.prefix}.${20 + var.zones[2]}.0/24"
      egress = true
    },
    "c_from_a_ingress" = {
      acl_id = aws_network_acl.closed_c.id
      rule_number = 52
      cidr_block = "${var.prefix}.${20 + var.zones[0]}.0/24"
      egress = false
    },
    "c_from_a_egress" = {
      acl_id = aws_network_acl.closed_c.id
      rule_number = 52
      cidr_block = "${var.prefix}.${20 + var.zones[0]}.0/24"
      egress = true
    },
  } : {}

  network_acl_id = each.value.acl_id
  rule_number    = each.value.rule_number
  egress         = each.value.egress
  cidr_block     = each.value.cidr_block

  protocol       = -1
  rule_action    = "deny"
}