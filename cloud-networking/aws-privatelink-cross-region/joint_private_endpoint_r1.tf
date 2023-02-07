resource "aws_security_group" "r1" {
  # Ensure that SG is unique, so that this module can be used multiple times within a single VPC
  name        = "ccloud-privatelink_${var.environment_name}"
  description = "Confluent Cloud Private Link minimal security group in ${aws_vpc.r1.id}"
  vpc_id      = aws_vpc.r1.id

  # ingress {
  #   # only necessary if redirect support from http/https is desired
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = [data.aws_vpc.privatelink.cidr_block]
  # }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.r1
}


resource "aws_vpc_endpoint" "r1" {
  vpc_id            = aws_vpc.r1.id
  service_name      = confluent_network.r1.aws[0].private_link_endpoint_service
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.r1.id,
  ]

  # Replace with private subnets if applicable
  subnet_ids = [ for subnet in aws_subnet.r1: subnet.id ]
  private_dns_enabled = false

  depends_on = [
    confluent_private_link_access.r1,
  ]

  provider = aws.r1
}