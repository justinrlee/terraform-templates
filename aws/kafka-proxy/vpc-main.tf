# VPC
# Internet Gateway
# 3x private subnets - for NLB
# - Route in default route table, pointing at IGW
# - NAT Gateway (per zone)
# 3x public subnets - for proxy instances
# - Route table pointing at NAT Gateway

resource "aws_vpc" "main" {
  cidr_block = "${var.prefix}.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name = "${var.environment_name}-${var.region_short}"
    },
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${var.environment_name}-${var.region_short}"
    },
  )
}

resource "aws_route" "default" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_subnet" "public" {
  for_each = var.zones

  vpc_id = aws_vpc.main.id

  map_public_ip_on_launch = true

  cidr_block = "${var.prefix}.${each.value.subnet}.0/24"

  availability_zone_id = "${var.region_short}-${each.key}"

  tags = merge(
    {
      Name = "${var.environment_name}-${var.region_short}-${each.key}-public"
    },
  )
}

resource "aws_subnet" "private" {
  for_each = var.zones

  vpc_id = aws_vpc.main.id

  map_public_ip_on_launch = false

  cidr_block = "${var.prefix}.${each.value.subnet + 10}.0/24"

  availability_zone_id = "${var.region_short}-${each.key}"

  tags = merge(
    {
      Name = "${var.environment_name}-${var.region_short}-${each.key}-private"
    },
  )
}

resource "aws_eip" "nat_gateway_zonal" {
  for_each = var.zones
  domain = "vpc"
}

resource "aws_nat_gateway" "zonal" {
  for_each = var.zones

  allocation_id = aws_eip.nat_gateway_zonal[each.key].id
  subnet_id = aws_subnet.public[each.key].id

  tags = merge(
    {
      Name = "${var.environment_name}-${var.region_short}-${each.key}"
    },
  )
}

resource "aws_route_table" "private_zonal" {
  for_each = var.zones

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment_name}-${var.region_short}-${each.key}-private"
  }
}

resource "aws_route" "private_nat_gateway" {
  for_each = var.zones
  route_table_id = aws_route_table.private_zonal[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.zonal[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = var.zones

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_zonal[each.key].id
}