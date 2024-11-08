# ## Have an order of operations issue here; depends on peering connection being initiated by the Confluent side and accepted on customer side.

locals {
  peering_cidr          = "10.40.0.0/16"
  peering_connection_id = "pcx-0acac7d60136677e3"
}

resource "aws_route" "peering" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = local.peering_cidr
  vpc_peering_connection_id = local.peering_connection_id
}

resource "aws_route" "private_peering" {
  for_each = aws_route_table.private_zonal
  route_table_id            = each.value.id
  destination_cidr_block    = local.peering_cidr
  vpc_peering_connection_id = local.peering_connection_id
}