resource "confluent_environment" "main" {
  display_name = var.environment_name

}

resource "confluent_private_link_attachment" "main" {
  cloud = "AWS"
  region = var.region
  display_name = "enterprise"
  environment {
    id = confluent_environment.main.id
  }
}

resource "aws_vpc_endpoint" "privatelink" {
  vpc_id = aws_vpc.main.id
  service_name = confluent_private_link_attachment.main.aws[0].vpc_endpoint_service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.cc.id,
  ]

  subnet_ids = [for aws_subnet in aws_subnet.private : aws_subnet.id]
  private_dns_enabled = false
}

resource "confluent_private_link_attachment_connection" "main" {
  display_name = var.environment_name
  environment {
    id = confluent_environment.main.id
  }
  aws {
    vpc_endpoint_id = aws_vpc_endpoint.privatelink.id
  }
  private_link_attachment {
    id = confluent_private_link_attachment.main.id
  }
}

resource "aws_route53_zone" "main" {
  name = confluent_private_link_attachment.main.dns_domain

  comment = "${var.environment_name}, managed by Terraform"

  tags = {
    Name = var.environment_name
  }
  
  vpc {
    vpc_id = aws_vpc.main.id
    vpc_region = var.region
  }
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.main.id
  name = "*.${confluent_private_link_attachment.main.dns_domain}"
  type = "CNAME"
  ttl = "60"

  records = [
    aws_vpc_endpoint.privatelink.dns_entry[0].dns_name
  ]
}
