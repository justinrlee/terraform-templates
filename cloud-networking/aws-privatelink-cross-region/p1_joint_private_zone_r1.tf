resource "aws_route53_zone" "r1" {
  name = confluent_network.r1.dns_domain

  comment = "${var.environment_name}-${var.r1.region}"

  vpc {
    vpc_id = aws_vpc.r1.id
    vpc_region = var.r1.region
  }

  vpc {
    vpc_id = aws_vpc.r2.id
    vpc_region = var.r2.region
  }

  provider = aws.r1
}

resource "aws_route53_record" "r1_regional" {
  zone_id = aws_route53_zone.r1.zone_id
  name    = "*.${confluent_network.r1.dns_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    aws_vpc_endpoint.r1.dns_entry[0]["dns_name"]
  ]

  provider = aws.r1
}

data "aws_availability_zones" "r1" {
  state = "available"

  provider = aws.r1
}

resource "aws_route53_record" "r1_zonal" {
  for_each = toset(keys(var.r1.zones))

  zone_id = aws_route53_zone.r1.zone_id
  name    = "*.${each.key}.${confluent_network.r1.dns_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    for dns_entry in aws_vpc_endpoint.r1.dns_entry : dns_entry.dns_name if(
      length(regexall(matchkeys(data.aws_availability_zones.r1.names, data.aws_availability_zones.r1.zone_ids, [each.key])[0], dns_entry.dns_name)) > 0
    )
  ]

  provider = aws.r1
}