resource "aws_vpc" "main_r1" {
  cidr_block = "${var.prefix_r1}.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name = "${var.environment_name}-${var.region_short_r1}"
    },
  )

  provider = aws.r1
}

resource "aws_internet_gateway" "main_r1" {
  vpc_id = aws_vpc.main_r1.id

  tags = merge({
    Name = "${var.environment_name}-${var.region_short_r1}"
    },
  )

  provider = aws.r1
}

resource "aws_route" "default_r1" {
  route_table_id         = aws_vpc.main_r1.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_r1.id

  provider = aws.r1
}

resource "aws_subnet" "public_r1" {
  for_each = var.zones_r1

  vpc_id = aws_vpc.main_r1.id

  map_public_ip_on_launch = true

  cidr_block = "${var.prefix_r1}.${each.value.subnet}.0/24"

  availability_zone_id = "${var.region_short_r1}-${each.key}"

  tags = merge(
    {
      Name = "${var.environment_name}-${var.region_short_r1}-${each.key}-public"
    },
  )

  provider = aws.r1
}

resource "aws_subnet" "private_r1" {
  for_each = var.zones_r1

  vpc_id = aws_vpc.main_r1.id

  map_public_ip_on_launch = false

  cidr_block = "${var.prefix_r1}.${each.value.subnet + 10}.0/24"

  availability_zone_id = "${var.region_short_r1}-${each.key}"

  tags = merge(
    {
      Name = "${var.environment_name}-${var.region_short_r1}-${each.key}-private"
    },
  )

  provider = aws.r1
}

resource "aws_eip" "nat_gateway_zonal_r1" {
  for_each = var.zones_r1
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.environment_name}-${var.region_short_r1}-${each.key}-nat-gatewy"
    },
  )

  provider = aws.r1
}

resource "aws_nat_gateway" "zonal_r1" {
  for_each = var.zones_r1

  allocation_id = aws_eip.nat_gateway_zonal_r1[each.key].id
  subnet_id = aws_subnet.public_r1[each.key].id

  tags = merge(
    {
      Name = "${var.environment_name}-${var.region_short_r1}-${each.key}"
    },
  )

  provider = aws.r1
}

resource "aws_route_table" "private_zonal_r1" {
  for_each = var.zones_r1

  vpc_id = aws_vpc.main_r1.id

  tags = {
    Name = "${var.environment_name}-${var.region_short_r1}-${each.key}-private"
  }

  provider = aws.r1
}

resource "aws_route" "private_nat_gateway_r1" {
  for_each = var.zones_r1
  route_table_id = aws_route_table.private_zonal_r1[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.zonal_r1[each.key].id

  provider = aws.r1
}

resource "aws_route_table_association" "private_r1" {
  for_each = var.zones_r1

  subnet_id      = aws_subnet.private_r1[each.key].id
  route_table_id = aws_route_table.private_zonal_r1[each.key].id

  provider = aws.r1
}

resource "aws_security_group" "allow_internal_r1" {
  description = "All 10.0.0.0/8 traffic"
  name        = "${var.environment_name}-allow-internal"
  vpc_id      = aws_vpc.main_r1.id

  ingress = [{
    description      = null,
    protocol         = "-1",
    cidr_blocks      = ["10.0.0.0/8"],
    from_port        = 0,
    to_port          = 0,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]

  egress = [{
    description      = null,
    protocol         = "-1",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = 0,
    to_port          = 0,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]

  provider = aws.r1
}

resource "aws_security_group" "allow_home_r1" {
  description = "All from home"
  name        = "${var.environment_name}-allow-home"
  vpc_id      = aws_vpc.main_r1.id

  ingress = [{
    description = null,
    cidr_blocks = [
      "${var.myip}/32"
    ],
    from_port        = 0,
    to_port          = 0,
    protocol         = "all",
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]

  provider = aws.r1
}

locals {
  public_subnets_f3o_r1 = {
    for az,subnet in aws_subnet.public_r1:
      az => join(".", slice(split(".", subnet.cidr_block), 0, 3))
  }
  private_subnets_f3o_r1 = {
    for az,subnet in aws_subnet.private_r1:
      az => join(".", slice(split(".", subnet.cidr_block), 0, 3))
  }
}