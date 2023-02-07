resource "aws_vpc" "r2" {
  cidr_block = var.r2.cidr

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment_name}-tf-${var.r2.region}"
  }

  provider = aws.r2
}


resource "aws_internet_gateway" "r2" {
  vpc_id = aws_vpc.r2.id

  tags = {
    Name = "${var.environment_name}-tf-${var.r2.region}"
  }

  provider = aws.r2
}

# Attach route to route table: `aws_vpc.justin.default_route_table_id`
resource "aws_route" "r2_default" {
  route_table_id         = aws_vpc.r2.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.r2.id

  provider = aws.r2
}

resource "aws_subnet" "r2" {
  for_each = var.r2.zones

  vpc_id = aws_vpc.r2.id

  map_public_ip_on_launch = true

  cidr_block = each.value.public_subnet

  availability_zone_id = each.key
  # replace with "use1-${each.key}" for us-east-1, or "usw2-${each.key}" for us-west-2

  tags = {
    Name = "${var.environment_name}-tf-${each.key}"
    "kubernetes.io/role/elb" = 1
  }

  provider = aws.r2
}