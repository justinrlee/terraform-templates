resource "aws_vpc_peering_connection" "r0s_r1s" {
  vpc_id        = module.vpc_r0s.vpc_id
  peer_vpc_id   = module.vpc_r1s.vpc_id
  peer_region   = var.regions[1]

  tags = {
    Name = "${var.cluster_name}-${var.regions_short[0]}-${var.regions_short[1]}"
    Side = "Requester"
    Local = var.regions[0]
    Peer = var.regions[1]
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0a
}

resource "aws_vpc_peering_connection_accepter" "r0s_r1s" {
  vpc_peering_connection_id = aws_vpc_peering_connection.r0s_r1s.id
  auto_accept = true

  tags = {
    Name = "${var.cluster_name}-${var.regions_short[1]}-${var.regions_short[0]}"
    Side = "Accepter"
    Local = var.regions[1]
    Peer = var.regions[0]
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r1a
}

resource "aws_vpc_peering_connection_options" "r0s_r1s_requester" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r0s_r1s.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r0a
}

resource "aws_vpc_peering_connection_options" "r0s_r1s_accepter" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r0s_r1s.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r1a
}

resource "aws_route" "r0s_r1s_public" {
  route_table_id = module.vpc_r0s.public_route_table_ids[0]
  destination_cidr_block = "${var.prefixes[1]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r1s.id

  provider = aws.r0a
}

resource "aws_route" "r1s_r0s_public" {
  route_table_id = module.vpc_r1s.public_route_table_ids[0]
  destination_cidr_block = "${var.prefixes[0]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r1s.id

  provider = aws.r1a
}

resource aws_route "r0s_r1s_private" {
  count = 3

  route_table_id = module.vpc_r0s.private_route_table_ids[count.index]
  destination_cidr_block = "${var.prefixes[1]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r1s.id

  provider = aws.r0a
}

resource aws_route "r1s_r0s_private" {
  count = 3

  route_table_id = module.vpc_r1s.private_route_table_ids[count.index]
  destination_cidr_block = "${var.prefixes[0]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r1s.id

  provider = aws.r1a
}