locals {
  public_subnets = [
    for aws_subnet in aws_subnet.public : aws_subnet.cidr_block
  ]
  public_subnets_ids = [
    for aws_subnet in aws_subnet.public : aws_subnet.id
  ]
  # First three octets of every public subnet
  public_subnets_f3o = [
    for aws_subnet in aws_subnet.public : join(".", slice(split(".", aws_subnet.cidr_block), 0, 3))
  ]
  private_subnets = [
    for aws_subnet in aws_subnet.private : aws_subnet.cidr_block
  ]
  private_subnets_ids = [
    for aws_subnet in aws_subnet.private : aws_subnet.id
  ]
  # # First three octets of every public subnet
  # private_subnets_f3o = [
  #   for aws_subnet in aws_subnet.private : join(".", slice(split(".", aws_subnet.cidr_block), 0, 3))
  # ]
}