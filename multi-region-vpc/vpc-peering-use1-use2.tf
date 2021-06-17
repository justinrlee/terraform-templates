resource "aws_vpc_peering_connection" "use1_use2" {
  vpc_id        = module.vpc_use1.vpc_id
  peer_vpc_id   = module.vpc_use2.vpc_id
  peer_region   = "us-east-2"

  tags = {
    Name = "${var.cluster_name}-use1-use2"
    Side = "Requester"
    Local = "us-east-1"
    Peer = "us-east-2"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.us-east-1
}

resource "aws_vpc_peering_connection_accepter" "use1_use2" {
  vpc_peering_connection_id = aws_vpc_peering_connection.use1_use2.id
  auto_accept = true

  tags = {
    Name = "${var.cluster_name}-use2-use1"
    Side = "Accepter"
    Local = "us-east-2"
    Peer = "us-east-1"
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.us-east-2
}

resource "aws_vpc_peering_connection_options" "use1_use2_requester" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.use1_use2.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.us-east-1
}

resource "aws_vpc_peering_connection_options" "use1_use2_accepter" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.use1_use2.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.us-east-2
}

resource "aws_route" "use1_use2_public" {
  route_table_id = module.vpc_use1.public_route_table_ids[0]
  destination_cidr_block = "${var.use2_slash16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.use1_use2.id

  provider = aws.us-east-1
}

resource "aws_route" "use2_use1_public" {
  route_table_id = module.vpc_use2.public_route_table_ids[0]
  destination_cidr_block = "${var.use1_slash16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.use1_use2.id

  provider = aws.us-east-2
}

resource aws_route "use1_use2_private" {
  count = 3

  route_table_id = module.vpc_use1.private_route_table_ids[count.index]
  destination_cidr_block = "${var.use2_slash16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.use1_use2.id

  provider = aws.us-east-1
}

resource aws_route "use2_use1_private" {
  count = 3

  route_table_id = module.vpc_use2.private_route_table_ids[count.index]
  destination_cidr_block = "${var.use1_slash16}.0.0/16"
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.use1_use2.id

  provider = aws.us-east-2
}