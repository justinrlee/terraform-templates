

resource "aws_route" "peering" {
  route_table_id            = var.route_table_default
  destination_cidr_block    = var.peering_cidr
  vpc_peering_connection_id = var.peering_connection_id
}

resource "aws_route" "private_peering" {
  for_each = var.route_table_zone_mapping
  route_table_id            = each.value
  destination_cidr_block    = var.peering_cidr
  vpc_peering_connection_id = var.peering_connection_id
}