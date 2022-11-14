# locals {
#   dns_domain = confluent_network.network.dns_domain
# }

resource "aws_route53_zone" "privatelink" {
  name = confluent_network.network.dns_domain

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  depends_on = [
    module.vpc
  ]
}

resource "aws_route53_record" "regional" {
  zone_id = aws_route53_zone.privatelink.zone_id
  name    = "*.${confluent_network.network.dns_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    aws_vpc_endpoint.privatelink.dns_entry[0]["dns_name"]
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_route53_record" "zonal" {
  for_each = toset(var.zones)

  zone_id = aws_route53_zone.privatelink.zone_id
  name    = "*.${each.key}.${confluent_network.network.dns_domain}"
  type = "CNAME"
  ttl = "60"
  records = [
    for dns_entry in aws_vpc_endpoint.privatelink.dns_entry: dns_entry.dns_name if (
      length(regexall(matchkeys(data.aws_availability_zones.available.names, data.aws_availability_zones.available.zone_ids, [each.key])[0], dns_entry.dns_name)) > 0
    )
  ]
}