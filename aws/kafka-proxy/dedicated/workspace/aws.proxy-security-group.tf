resource "aws_security_group" "proxy" {
  description = "allow traffic from NLB to proxy"
  name        = "${var.environment_name}-allow-nlb"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "proxy" {
  security_group_id = aws_security_group.proxy.id

  ip_protocol = -1
  referenced_security_group_id = aws_security_group.nlb.id
}
