resource "aws_vpc_peering_connection" "r0s_r2s" {
  vpc_id        = module.vpc_r0s.vpc_id
  peer_vpc_id   = module.vpc_r2s.vpc_id
  peer_region   = var.r2

  tags = {
    Name = "${var.cluster_name}-${var.r0s}-${var.r2s}"
    Side = "Requester"
    Local = var.r0
    Peer = var.r2
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0a
}

resource "aws_vpc_peering_connection_accepter" "r0s_r2s" {
  vpc_peering_connection_id = aws_vpc_peering_connection.r0s_r2s.id
  auto_accept = true

  tags = {
    Name = "${var.cluster_name}-${var.r2s}-${var.r0s}"
    Side = "Accepter"
    Local = var.r2
    Peer = var.r0
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r2a
}

resource "aws_vpc_peering_connection_options" "r0s_r2s_requester" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r0s_r2s.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r0a
}

resource "aws_vpc_peering_connection_options" "r0s_r2s_accepter" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.r0s_r2s.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r2a
}

resource "aws_route" "r0s_r2s_public" {
  route_table_id = module.vpc_r0s.public_route_table_ids[0]
  destination_cidr_block = "${var.r2s_prefix16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r2s.id

  provider = aws.r0a
}

resource "aws_route" "r2s_r0s_public" {
  route_table_id = module.vpc_r2s.public_route_table_ids[0]
  destination_cidr_block = "${var.r0s_prefix16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r2s.id

  provider = aws.r2a
}

resource aws_route "r0s_r2s_private" {
  count = 3

  route_table_id = module.vpc_r0s.private_route_table_ids[count.index]
  destination_cidr_block = "${var.r2s_prefix16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r2s.id

  provider = aws.r0a
}

resource aws_route "r2s_r0s_private" {
  count = 3

  route_table_id = module.vpc_r2s.private_route_table_ids[count.index]
  destination_cidr_block = "${var.r0s_prefix16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.r0s_r2s.id

  provider = aws.r2a
}