
resource "aws_security_group" "privatelink" {
  # Ensure that SG is unique, so that this module can be used multiple times within a single VPC
  name        = "ccloud-privatelink_${var.environment_name}"
  description = "Confluent Cloud Private Link minimal security group in ${module.vpc.vpc_id}"
  vpc_id      = module.vpc.vpc_id

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

  depends_on = [
    module.vpc
  ]
}


resource "aws_vpc_endpoint" "privatelink" {
  vpc_id            = module.vpc.vpc_id
  service_name      = confluent_network.network.aws[0].private_link_endpoint_service
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.privatelink.id,
  ]

  subnet_ids          = module.vpc.public_subnets
  # subnet_ids          = [for subnet in aws_subnet.subnets: subnet.id]
  private_dns_enabled = false

  depends_on = [
    confluent_private_link_access.aws,
    module.vpc,
    aws_security_group.privatelink
  ]
}