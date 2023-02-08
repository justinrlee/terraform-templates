resource "aws_vpc" "r1" {
  cidr_block = var.r1.cidr

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment_name}-tf-${var.r1.region}"
  }

  provider = aws.r1
}


resource "aws_internet_gateway" "r1" {
  vpc_id = aws_vpc.r1.id

  tags = {
    Name = "${var.environment_name}-tf-${var.r1.region}"
  }

  provider = aws.r1
}

# Attach route to route table: `aws_vpc.justin.default_route_table_id`
resource "aws_route" "r1_default" {
  route_table_id         = aws_vpc.r1.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.r1.id

  provider = aws.r1
}

resource "aws_subnet" "r1" {
  for_each = var.r1.zones

  vpc_id = aws_vpc.r1.id

  map_public_ip_on_launch = true

  cidr_block = each.value.public_subnet

  availability_zone_id = each.key
  # replace with "use1-${each.key}" for us-east-1, or "usw2-${each.key}" for us-west-2

  tags = {
    Name = "${var.environment_name}-tf-${each.key}"
    "kubernetes.io/role/elb" = 1
  }

  # Create an pseudo-implicit dependency on VPC < IGW < Default Route < Subnet < EKS Cluster so EKS isn't created until the route is up
  depends_on = [
    aws_route.r1_default,
  ]

  provider = aws.r1
}