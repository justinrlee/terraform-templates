resource "confluent_environment" "main" {
  display_name = var.environment_name

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "confluent_network" "peering" {
    display_name = var.environment_name
    cloud = "AWS"
    region = var.region
    cidr = var.confluent_cidr
    connection_types = ["PEERING"]

    zones = [
      "usw2-az1",
      "usw2-az2",
      "usw2-az3",
    ]

    environment {
      id = confluent_environment.main.id
    }

    # lifecycle {
    #   prevent_destroy = true
    # }
}

data "aws_caller_identity" "main" {}

resource "confluent_peering" "peering" {
    display_name = var.environment_name
    aws {
        account = data.aws_caller_identity.main.account_id
        vpc = aws_vpc.main.id
        routes = [aws_vpc.main.cidr_block]
        customer_region = var.region
    }
    environment {
      id = confluent_environment.main.id
    }
    network {
        id = confluent_network.peering.id
    }

    # lifecycle {
    #   prevent_destroy = true
    # }
}

data "aws_vpc_peering_connection" "accepter" {
  # peer_ is the accepter
  peer_owner_id = data.aws_caller_identity.main.account_id
  # peer_owner_id = "340752808385"
  peer_vpc_id      = aws_vpc.main.id
  # peer_vpc_id      = "vpc-01a664c5fd034a0a0"

  # owner_id and vpc_id are the requester
  # owner_id = "390327825978"
  # vpc_id = "vpc-0414a65a06f965c9e"
  owner_id = confluent_network.peering.aws[0].account
  vpc_id = confluent_network.peering.aws[0].vpc
}

resource "aws_vpc_peering_connection_accepter" "peer" {
    vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
    auto_accept = true
}

data "aws_route_tables" "tables" {
  vpc_id = aws_vpc.main.id
}

locals {
    non_default_route_tables = [
        for rt in data.aws_route_tables.tables.ids: rt if rt != aws_vpc.main.main_route_table_id
    ]
}

resource "aws_route" "peering" {
  for_each                  = toset(local.non_default_route_tables)
  route_table_id            = each.key
  destination_cidr_block    = confluent_network.peering.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
}

