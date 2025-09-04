# Initiated from region 1
resource "aws_vpc_peering_connection" "peering" {
  vpc_id        = aws_vpc.r1.id
  peer_vpc_id   = aws_vpc.r2.id
  peer_region   = var.r2.region

  provider = aws.r1
}

# Accepted in region 2
resource "aws_vpc_peering_connection_accepter" "peering" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept = true

  provider = aws.r2
}

resource "aws_vpc_peering_connection_options" "r1" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r1
}

resource "aws_vpc_peering_connection_options" "r2" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r2
}

resource "aws_route" "r1_peering" {
  route_table_id = aws_vpc.r1.default_route_table_id
  destination_cidr_block = var.r2.cidr
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.peering.id

  provider = aws.r1
}

resource "aws_route" "r2_peering" {
  route_table_id = aws_vpc.r2.default_route_table_id
  destination_cidr_block = var.r1.cidr
  vpc_peering_connection_id =  aws_vpc_peering_connection_accepter.peering.id

  provider = aws.r2
}