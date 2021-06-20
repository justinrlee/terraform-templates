resource "aws_vpc_peering_connection" "r1s_r2s" {
  vpc_id        = module.vpc_r1s.vpc_id
  peer_vpc_id   = module.vpc_r2s.vpc_id
  peer_region   = var.regions[2]

  tags = {
    Name = "${var.cluster_name}-${var.regions_short[1]}-${var.regions_short[2]}"
    Side = "Requester"
    Local = var.regions[1]
    Peer = var.regions[2]
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r1a
}

resource "aws_vpc_peering_connection_accepter" "r1s_r2s" {
  vpc_peering_connection_id = aws_vpc_peering_connection.r1s_r2s.id
  auto_accept = true

  tags = {
    Name = "${var.cluster_name}-${var.regions_short[2]}-${var.regions_short[1]}"
    Side = "Accepter"
    Local = var.regions[2]
    Peer = var.regions[1]
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r2a
}

resource "aws_vpc_peering_connection_options" "r1s_r2s_requester" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r1s_r2s.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r1a
}

resource "aws_vpc_peering_connection_options" "r1s_r2s_accepter" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r1s_r2s.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r2a
}

resource "aws_route" "r1s_r2s_public" {
  route_table_id = module.vpc_r1s.public_route_table_ids[0]
  destination_cidr_block = "${var.prefixes[2]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r1s_r2s.id

  provider = aws.r1a
}

resource "aws_route" "r2s_r1s_public" {
  route_table_id = module.vpc_r2s.public_route_table_ids[0]
  destination_cidr_block = "${var.prefixes[1]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r1s_r2s.id

  provider = aws.r2a
}

resource aws_route "r1s_r2s_private" {
  count = 3

  route_table_id = module.vpc_r1s.private_route_table_ids[count.index]
  destination_cidr_block = "${var.prefixes[2]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r1s_r2s.id

  provider = aws.r1a
}

resource aws_route "r2s_r1s_private" {
  count = 3

  route_table_id = module.vpc_r2s.private_route_table_ids[count.index]
  destination_cidr_block = "${var.prefixes[1]}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r1s_r2s.id

  provider = aws.r2a
}