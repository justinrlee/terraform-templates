resource "aws_vpc_peering_connection" "r0_r1" {
  vpc_id        = aws_vpc.main_r0.id
  peer_vpc_id   = aws_vpc.main_r1.id
  peer_region   = var.region_r1

  tags = {
    Name = "${var.environment_name}-${var.region_short_r0}-${var.region_short_r1}"
    Side = "Requester"
    Local = var.region_r0
    Peer = var.region_r1
    # Provenance = "Multi-Region Terraform for ${var.environment_name}"
  }

  provider = aws.r0
}

resource "aws_vpc_peering_connection_accepter" "r0_r1" {
  vpc_peering_connection_id = aws_vpc_peering_connection.r0_r1.id
  auto_accept = true

  tags = {
    Name = "${var.environment_name}-${var.region_short_r1}-${var.region_short_r0}"
    Side = "Accepter"
    Local = var.region_r1
    Peer = var.region_r0
    # Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  provider = aws.r1
}

resource "aws_vpc_peering_connection_options" "r0_r1_requester" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r0_r1.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r0
}

resource "aws_vpc_peering_connection_options" "r0_r1_accepter" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r0_r1.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r1
}

resource "aws_route" "r0_r1_public" {
  route_table_id = aws_vpc.main_r0.default_route_table_id
  destination_cidr_block = "${var.prefix_r1}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0_r1.id

  provider = aws.r0
}

resource "aws_route" "r1_r0_public" {
  route_table_id = aws_vpc.main_r1.default_route_table_id
  destination_cidr_block = "${var.prefix_r0}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0_r1.id

  provider = aws.r1
}

resource aws_route "r0_r1_private" {
  for_each = aws_route_table.private_zonal_r0

  route_table_id = each.value.id
  destination_cidr_block = "${var.prefix_r1}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0_r1.id

  provider = aws.r0
}

resource aws_route "r1_r0_private" {
  for_each = aws_route_table.private_zonal_r1

  route_table_id = each.value.id
  destination_cidr_block = "${var.prefix_r0}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0_r1.id

  provider = aws.r1
}